
FROM ubuntu:resolute-20260108

ARG USERNAME
ARG USERID
ARG GROUPID


###############################################################################
# Install required debian packages

RUN apt update && apt install -y \
 sudo \
 vim \
 zsh \ 
 git \
 curl \
 #fonts-powerline \
 console-setup
###############################################################################


###############################################################################
# Remove predefined ubuntu user from container. This is done as the this user
# occupies UID 1000 but we want to keep the host's username with same ID
# inside the container
RUN userdel -r ubuntu
###############################################################################


###############################################################################
# Add user with same name UID and GID as on the host.
RUN groupadd -g ${GROUPID} ${USERNAME}
RUN useradd ${USERNAME} -m -u ${USERID} -g ${GROUPID} -s /bin/zsh -G sudo
###############################################################################


###############################################################################
# Set our user as default user
USER  ${USERNAME}
WORKDIR /home/${USERNAME}
###############################################################################


###############################################################################
# Install oh-my-zsh according to https://github.com/ohmyzsh/ohmyzsh

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
###############################################################################


###############################################################################
# Install powerlevel 10k
# According to https://github.com/romkatv/powerlevel10k

RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
 "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
RUN sed -i 's/ZSH_THEME.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' /home/${USERNAME}/.zshrc
#RUN sed -i 's/ZSH_THEME.*/ZSH_THEME="agnoster"/' /home/${USERNAME}/.zshrc
RUN mkdir -p /home/${USERNAME}/.fonts \
  && curl -LO "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" --output-dir /home/${USERNAME}/.fonts \
  && curl -LO "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf" --output-dir /home/${USERNAME}/.fonts \
  && curl -LO "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf" --output-dir /home/${USERNAME}/.fonts \
  && curl -LO "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf" --output-dir /home/${USERNAME}/.fonts  
  #&& fc-cache -f -v


###############################################################################


CMD ["/bin/zsh"]


