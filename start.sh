#!/bin/bash

# Allow connections to the X server
xhost +local:

# Run Docker Compose
sudo docker-compose run stable-diffusion
