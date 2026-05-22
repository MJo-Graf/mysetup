
FROM ubuntu:resolute-20260108

ARG USERNAME
ARG USERID
ARG GROUPID

RUN apt update && apt install -y sudo vim zsh
RUN userdel -r ubuntu
RUN groupadd -g ${GROUPID} ${USERNAME}
RUN useradd ${USERNAME} -m -u ${USERID} -g ${GROUPID} -s /bin/zsh

CMD ["/bin/zsh"]
