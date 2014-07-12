FROM ubuntu:14.04
MAINTAINER Junichi Kajiwara<junichi.kajiwara@gmail.com>
RUN apt-get update
RUN apt-get install -y libbz2-dev ninix-aya openssh-server x11-apps
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y ubuntu-desktop
RUN apt-get install -y language-pack-ja git

RUN /etc/init.d/ssh start
RUN /etc/init.d/ssh stop
# sshdの設定ファイルのカスタマイズ
RUN sed -ri 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

# rootのパスワード設定
ENV ROOTPASSWORD ninix123
RUN echo "root:${ROOTPASSWORD}" |chpasswd
#RUN echo "XForwarding yes">>/etc/ssh/sshd_config
ENV DEBIAN_FRONTEND dialog

ADD ninix/mayura_final.nar /root/mayura_final.nar

# Set environment variables.
ENV HOME /root

# Define working directory.
WORKDIR /root

RUN wget -O /root/ninix-balloon-v13.zip http://www.geocities.co.jp/SiliconValley-Cupertino/7565/archive/ninix-balloon-v13.zip
RUN git -C /root clone https://github.com/safx/ssp-jenkins-ghost.git
RUN echo "export LANG=ja_JP.utf8">>/root/.bashrc
RUN echo "export PATH=$PATH:/usr/games">>/root/.bashrc
# sshdを動かす
EXPOSE 22
CMD /usr/sbin/sshd -D
EXPOSE 9801
