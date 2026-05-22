
FROM ubuntu:resolute-20260108

ARG USERNAME
ARG USERID
ARG GROUPID

RUN apt update && apt install -y sudo vim zsh git curl
RUN userdel -r ubuntu
RUN groupadd -g ${GROUPID} ${USERNAME}
RUN useradd ${USERNAME} -m -u ${USERID} -g ${GROUPID} -s /bin/zsh


USER  ${USERNAME}
WORKDIR /home/${USERNAME}
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

CMD ["/bin/zsh"]
