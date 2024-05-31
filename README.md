This is a personal project. This means you can use it as you like, but please note that I expect nothing of you, and promise nothing to you.

# What this repo does
This sets up stable-diffusion web UI in a docker image, with the ability to use the system's AMD GPU. It works on my system (Ubuntu 22.04.3 with ROCm 6.0 installed, and AMD RX 6700 XT) as of 2024-05-31, but perhaps not yours.

# Steps
## With docker compose (easier)
1) have ROCm installed on the host machine.
2) clone this repo.
3) cd into the repo.
4) update the volume paths in compose.yaml according to your preferences. Create those directories on your host machine if they don't already exist.
5) ```sudo docker compose run stable-diffusion```
6) inside the docker container, run ```pylaunchgui``` for the GUI, or ```pylaunchapi``` for API only.

## Without docker compose
1) as above
2) as above
3) as above
4) ```sudo docker build --no-cache -t 'stable-diffusion-webui-rocm' .```
5) create the volume folder mentioned in the next command, if you haven't already.
6) ```xhost +local: && sudo docker run --rm -it --network=host --device=/dev/kfd --device=/dev/dri --group-add=video --ipc=host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME/dockerx:/dockerx -e DISPLAY=${DISPLAY} stable-diffusion-webui-rocm```
7) inside the docker container, run ```pylaunchgui``` for the GUI, or ```pylaunchapi``` for API only.

## Advice
- If using the docker compose, remember to use ```--no-cache``` when the Dockerfile is updated, e.g. ```sudo docker compose build --no-cache```
- The xhost stuff is adapted from [this DockerHub page](https://hub.docker.com/r/rocm/pytorch).
- Following a successful build and user test, you may wish to re-build using a newer commit than the one I hard-coded in the Dockerfile.

- There's a lot of experimentation in finding good prompts. There are good guides, however.
- If you have limited VRAM, try launching with the "--medvram" or "--lowvram" parameters.
- stable-diffusion XL models require a lot of VRAM. Interestingly, I can run some repeatedly via the API but not the GUI.
