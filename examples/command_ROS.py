import rospy
import pygame
import math
import tf
from geometry_msgs.msg import Twist, PoseStamped
import std_msgs.msg
import socket
import telemetry_pb2 as telemetry_pb2
from google.protobuf.text_format import MessageToString
from math import tan, sin, cos
import numpy as np
import time

# Maximum rate of change (acceleration/deceleration)
MAX_LINEAR_ACCEL = 1.0  # meters per second squared
MAX_ANGULAR_ACCEL = 1.0 # radians per second squared

# Target velocities
target_v = 0.0
target_omega = 0.0

# Linear and angular velocity
v = 0.0
omega = 0.0

# Constants for the robot
e = 0.340  # Track width (m)
r = 0.088  # Wheel radius (m)
x = 0.400 
dt = 1.0

# Robot properties
robot_width, robot_height = 35, 18
robot_x, robot_y = 0, 0
robot_orientation = 0.001
scaleValue = 10

# ROS Callback
def cmd_vel_callback(data):
    global target_v, target_omega
    target_v = data.linear.x
    target_omega = data.angular.z

def calculate_ramped_velocity(current_vel, target_vel, max_accel, dt):
    if current_vel < target_vel:
        ramped_vel = current_vel + min(max_accel * dt, target_vel - current_vel)
    elif current_vel > target_vel:
        ramped_vel = current_vel - min(max_accel * dt, current_vel - target_vel)
    else:
        ramped_vel = current_vel
    return ramped_vel

# Socket setup
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(("192.168.1.123", 5005))
sock.setblocking(0)

# Initialize ROS
rospy.init_node('vitirover_simulation', anonymous=True)
rospy.Subscriber("cmd_vel", Twist, cmd_vel_callback)
axle_angle_pub = rospy.Publisher("back_axle_angle", std_msgs.msg.Float64, queue_size=10)

# Main loop
rate = rospy.Rate(10)
running = True

while running and not rospy.is_shutdown():
    # Ramping for linear velocity
    v = calculate_ramped_velocity(v, target_v, MAX_LINEAR_ACCEL, dt)

    # Ramping for angular velocity
    omega = calculate_ramped_velocity(omega, target_omega, MAX_ANGULAR_ACCEL, dt)

    current_time = time.time()
    data, _ = sock.recvfrom(20000)
    telemetry_data = telemetry_pb2.VitiroverTelemetry()
    telemetry_data.ParseFromString(data)

    # Robot motion simulation logic
    angle_value = telemetry_data.back_axle_angle # angle measured in degree
    angle_value_rad = angle_value * 3.1415/180
    """
    angle = 0  
    angledeg = 0   
    if omega!=0 and v!=0:
        angle = math.atan(-omega*x/(v)) # angle computed from omega in radians
        angledeg = angle*180/3.1415 # angle computed in degree
    else:
        angle = 0
        angledeg = 0
    """
    # Calcul des valeurs
    A = [
        ((x + e * tan(angle_value_rad) / 2) / x * r, 0), 
        ((x - e * tan(angle_value_rad) / 2) / x * r, 0), 
        ((x + e * sin(angle_value_rad) / 2) / x * r * cos(angle_value_rad), -e / 2 * r), 
        ((x - e * sin(angle_value_rad) / 2) / x * r * cos(angle_value_rad), e / 2 * r)
    ]

    angle_value = telemetry_data.back_axle_angle
    angle_msg = std_msgs.msg.Float64()
    angle_msg.data = angle_value
    axle_angle_pub.publish(angle_msg)
        
    wRoues = np.dot(A, np.array([v, omega]))

    wG = wRoues[0]  # Front Left Wheel
    wH = wRoues[1]  # Front Right Wheel
    wI = wRoues[2]  # Back Right Wheel
    wJ = wRoues[3]  # Back Left Wheel

    vcheck = r*math.cos(angle)/2*(wI+wJ)
    omegacheck = -r*math.sin(angle)/2*x*(wI+wJ)
    print('omega: ', omega)
    print('v: ', v)
    
    # Send to your robot over socket
    order = telemetry_pb2.VitiroverOrder()
    order.low_level_order.front_left_speed = int(wG*scaleValue)
    order.low_level_order.front_right_speed = int(wH*scaleValue)
    order.low_level_order.back_left_speed = int(wI*scaleValue0)
    order.low_level_order.back_right_speed = int(wJ*scaleValue)

    print("wG: ", int(wG*scaleValue)) 
    print("wH: ", int(wH*scaleValue)) 
    print("wI: ", int(wI*scaleValue))
    print("wJ: ", int(wJ*scaleValue))
    
    data = order.SerializeToString()
    sock.sendto(data, ("192.168.1.42", 5005))

    telemetry_data = None
    while True:
        try:
            data, addr = sock.recvfrom(20000)  # Buffer size
            telemetry_data = telemetry_pb2.VitiroverTelemetry()
        except BlockingIOError:
            # Plus de messages dans le buffer, sortir de la boucle
            break
    if telemetry_data != None:
        telemetry_data.ParseFromString(data)
        # Afficher quelques valeurs
        #print("Motor Data:", telemetry_data.front_left_wheel.back_electromotive_force)
        #print("wG/wGBFM: ", wG/(telemetry_data.front_left_wheel.back_electromotive_force+0.0001))
        #print("wH/wHBFM: ", wH/(telemetry_data.front_right_wheel.back_electromotive_force+0.0001))
        #print("wI/wIBFM: ", wI/(telemetry_data.back_left_wheel.back_electromotive_force+0.0001))
        #print("wJ/wJBFM: ", wJ/(telemetry_data.back_right_wheel.back_electromotive_force+0.0001))

    rate.sleep()
pygame.quit(),
