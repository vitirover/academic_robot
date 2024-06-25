import socket
import telemetry_pb2 as telemetry_pb2
import random
import pygame
import math
import time
from google.protobuf.text_format import MessageToString

# Initialize pygame
pygame.init()

# Screen dimensions
WIDTH, HEIGHT = 200, 100

# Colors
WHITE = (255, 255, 255)
YELLOW = (255, 255, 0)
BLUE = (50, 120, 255)
RED = (255, 0, 0)  # Color for the trajectory

# Screen setup
screen = pygame.display.set_mode((WIDTH, HEIGHT))
pygame.display.set_caption("Vitirover Robot Control")

# Function to set speed based on pressed key
def set_speed_from_key():
    global low_order  # Declare low_order as global to modify it

    #angle_in_degrees = telemetry_data.back_axle_angle

    # Conversion de degrés en radians
    #angle_value = angle_in_degrees * (math.pi / 180)
    #print("angle value: ", angle_value)

    keys = pygame.key.get_pressed()
    v = 0
    omega = 0.001

    if keys[pygame.K_UP]:
        omega = 0.0
        v = 0.5 
    elif keys[pygame.K_DOWN]:
        omega = 0.0
        v = -0.5
    elif keys[pygame.K_LEFT]:
        omega = -1.0
        v = 0.5
    elif keys[pygame.K_RIGHT]:
        omega = 1.0
        v = 0.5
    
    dt = 1/60.0
    e = 0.340  # Track width (m)
    r = 0.088  # Wheel radius (m)
    x = 0.400
    R = x/(math.tan(omega*dt)+0.0001)
    #R = x/(math.tan(angle_value*dt)+0.0001)

    wI = (v/r) + omega * e/(2*r)
    wJ = (v/r) - omega * e/(2*r)
    wG = (v/r) * (1 - e/(2*R))
    wH = (v/r) * (1 + e/(2*R))

    low_order.front_left_speed = int(wI * 20)
    print("wI: ", low_order.front_left_speed)
    low_order.front_right_speed = int(wJ * 20)
    print("wJ: ", low_order.front_right_speed)
    low_order.back_left_speed = int(wG * 20)
    print("wG: ", low_order.back_left_speed)
    low_order.back_right_speed = int(wH * 20)
    print("wH: ", low_order.back_right_speed)

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(("192.168.1.123", 5005)) #Your IP Here
sock.setblocking(0)

low_order = telemetry_pb2.VitiroverLowLevelOrder()  # Initialize here for global accessibility

while True:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()

    set_speed_from_key()

    order = telemetry_pb2.VitiroverOrder()
    order.low_level_order.CopyFrom(low_order)

    data = order.SerializeToString()
    sock.sendto(data, ("192.168.2.42", 5005)) #Robot IP
    time.sleep(0.1)
    try:
        data, addr = sock.recvfrom(20000)
        telemetry_data = telemetry_pb2.VitiroverTelemetry()
        telemetry_data.ParseFromString(data)
        print(MessageToString(telemetry_data))
        print("timeout")
    except BlockingIOError:
        break

