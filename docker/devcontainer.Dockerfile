
FROM ubuntu:resolute-20260108

ARG GIT_REPOSITORY_PATH
ARG USERNAME
ARG USERID
ARG GROUPID


###############################################################################
# Install required debian packages

RUN apt update && apt install -y \
 sudo \
 zsh \
 unzip \
 git \
 curl \
 console-setup \
 build-essential \
 && sudo rm -rf /var/lib/apt/lists/*
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
RUN touch /etc/sudoers.d/${USERNAME} \
&& echo "${USERNAME} ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME}
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
#RUN mkdir -p /home/${USERNAME}/.fonts \
#  && curl -LO "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf" --output-dir /home/${USERNAME}/.fonts \
#  && curl -LO "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf" --output-dir /home/${USERNAME}/.fonts \
#  && curl -LO "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf" --output-dir /home/${USERNAME}/.fonts \
#  && curl -LO "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf" --output-dir /home/${USERNAME}/.fonts  
#  #&& fc-cache -f -v

COPY zshrc /home/${USERNAME}/.zshrc
COPY p10k.zsh /home/${USERNAME}/.p10k.zsh
###############################################################################


#################################################################################
### Setup vim as IDE
#RUN sudo apt install -y vim build-essential cmake vim-nox python3-dev mono-complete golang nodejs openjdk-17-jdk openjdk-17-jre npm
#RUN git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
#COPY vimrc /home/${USERNAME}/.vimrc
#RUN vim +PluginInstall +qall
#RUN cd ~/.vim/bundle/youcompleteme && python3 install.py --all
#################################################################################


################################################################################
## Setup neovim as IDE
RUN sudo apt update && sudo apt install -y neovim \
  && sudo rm -rf /var/lib/apt/lists/*
RUN git clone https://github.com/LazyVim/starter /home/${USERNAME}/.config/nvim
RUN nvim --headless -c "Mason" -c  "MasonInstall clangd" -c qall
################################################################################


################################################################################
##  Install firefox, see: https://linuxconfig.org/how-to-install-firefox-without-snap-on-ubuntu-26-04
RUN sudo apt update && sudo apt install -y \
 software-properties-common 
RUN sudo add-apt-repository ppa:mozillateam/ppa
RUN sudo apt update && sudo apt install -y firefox-esr \
  && sudo rm -rf /var/lib/apt/lists/*
################################################################################


CMD ["/bin/zsh"]


