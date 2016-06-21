FROM centos:centos7
MAINTAINER r2h2 <rainer@hoerbe.at>
# Management System for Safenet eTokenPro

# useful tools
RUN yum -y install curl git ip lsof net-tools openssl sudo wget which

# boot into GNOME
RUN yum -y groupinstall "GNOME Desktop" \
 && ln -sf /lib/systemd/system/runlevel5.target /etc/systemd/system/default.target

RUN echo "change this to invalidate docker cache" > /tmp/x

# development & admin tools
RUN yum -y groupinstall "Development Tools" \
 && yum -y install epel-release \
 && yum -y install curl gcc gcc-c++ net-tools opensc openssl pcsc-lite unzip usbutils wget
RUN systemctl enable  pcscd.service

# Safenet Authentication Client
COPY install/safenet/RPM-GPG-KEY-SafenetAuthenticationClient /opt/sac/
COPY install/safenet/SafenetAuthenticationClient_x86_64.rpm /opt/sac/
RUN rpm --import /opt/sac/RPM-GPG-KEY-SafenetAuthenticationClient \
 && rpm -i /opt/sac/SafenetAuthenticationClient_x86_64.rpm --nodeps


# pyff to test pkcs11 interface
RUN yum -y install python-pip python-devel libxslt-devel \
 && pip install --upgrade pip

#using pykcs11 1.3.0 because of missing wrapper in v 1.3.1
#use easy_install solves install bug
RUN pip install six \
&&  easy_install --upgrade six \
&& pip install importlib pykcs11==1.3.0


ARG USERNAME=livecd
ARG UID=1000
RUN groupadd --gid $UID $USERNAME \
 && useradd --gid $UID --uid $UID $USERNAME \
 && chown $USERNAME:$USERNAME /run /var/log

USER $USERNAME