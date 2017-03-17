FROM rhoerbe/keymgmt

# Extend base image with Gemalto/Safenet/Alladin eTokenPro support

# Safenet Authentication Client
# The software has a proprietary license and must be obtained from the vendor
# and copied into the build environment (install/safenet). Adapt the install path.


COPY install/safenet/Linux/Installation/Standard/RPM/x64/RPM-GPG-KEY-SafenetAuthenticationClient /opt/sac/
COPY install/safenet/Linux/Installation/Standard/RPM/SafenetAuthenticationClient-9.1.7-0.x86_64.rpm /opt/sac/SafenetAuthenticationClient_x86_64.rpm

RUN yum -y install gtk2 xdg-utils \
 && rpm --import /opt/sac/RPM-GPG-KEY-SafenetAuthenticationClient \
 && rpm -i /opt/sac/SafenetAuthenticationClient_x86_64.rpm --nodeps \
 && yum clean all

ENV PKCS11_CARD_DRIVER='/usr/lib64/libeToken.so'
COPY install/scripts/*.sh /
