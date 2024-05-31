# Note that there may be a memory leak. If you run out of VRAM when upscaling (for example), you'll need to re-launch the docker container in order to recover that VRAM. I probably used a wrong library version somewhere :/

FROM rocm/pytorch:rocm6.0.2_ubuntu22.04_py3.10_pytorch_2.1.2

# Allow ROCm to work with 6700 XT
ENV HSA_OVERRIDE_GFX_VERSION=10.3.0

RUN apt update -qq
# I didn't check if this image comes with all the necessary Python stuff, so we get it all just in case.
RUN apt install -y wget git python3.10-venv python3-pip libgl1 libglib2.0-0

RUN ln -s $(which python3) /usr/local/bin/python

RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui
WORKDIR "./stable-diffusion-webui"
# this is the most recent commit as of 2024-05-31
RUN git reset --hard feee37d75f1b168768014e4634dcb156ee649c05
RUN python -m venv venv
RUN . ./venv/bin/activate
RUN python -m pip install --upgrade pip wheel
RUN pip install -r requirements_versions.txt

# The default path to our Docker volume. This value must match the path that you use when starting the container later.
# Basically, we'll tell stable diffusion to look to the volume for models etc, so they only need to be downloaded once.
# You should avoid overwriting this environment variable during container operation.
ENV vol /dockerx/rocm/stable-diffusion

# Save code repositories in the volume, so they're not lost between container restarts.
RUN ln -s $vol/repositories /var/lib/jenkins/stable-diffusion-webui/repositories 

# Make aliases with which to launch the web interface, or api-only. You can add "--medvram" or "--lowvram" like this: "pylaunchgui --medvram".
# The precision full and no-half arguments help certain AMD cards. You may not need them. Reddit post explaining their effect: https://www.reddit.com/r/StableDiffusion/comments/z0m8pg/what_do_precision_full_and_nohalf_do/
RUN echo 'alias pylaunchgui="python launch.py --no-half --precision=full --data-dir=$vol" \n\
alias pylaunchapi="python launch.py --no-half --precision=full --nowebui --data-dir=$vol"' >> ~/.bashrc

CMD ["/bin/bash"]
