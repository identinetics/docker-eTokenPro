FROM rhoerbe/keymgmt
LABEL version="0.5.0" \
      didi_dir="https://raw.githubusercontent.com/identinetics/keymgmt-safenetac/master/didi"

# Extend base image with Gemalto/Safenet/Alladin eTokenPro (eToken5110 etc.) support

# Safenet Authentication Client
# The software has a proprietary license and must be obtained from the vendor
# and copied into the build environment (install/i-safenetac-linux).
# The referenced submodule i-safenetac-linux is only available for devices licensed to Identinetics


COPY install/i-safenetac-linux/safenet/linux/Installation/Standard/RPM/RPM-GPG-KEY-SafenetAuthenticationClient /opt/sac/
COPY install/i-safenetac-linux/safenet/linux/Installation/Standard/RPM/SafenetAuthenticationClient-9.1.7-0.x86_64.rpm /opt/sac/SafenetAuthenticationClient_x86_64.rpm
COPY install/p11kit/* /root/.config/pkcs11/modules/
COPY install/java_crypto/eTokenpro_JCE.cfg /etc/pki/java/
# replace default SoftHSM configuration
RUN ln -sf /etc/pki/eTokenpro_JCE.cfg /etc/pki/java/pkcs11.cfg


RUN yum -y install gtk2 xdg-utils PackageKit-gtk3-module libcanberra-gtk3 \
 && rpm --import /opt/sac/RPM-GPG-KEY-SafenetAuthenticationClient \
 && rpm -i /opt/sac/SafenetAuthenticationClient_x86_64.rpm --nodeps \
 && yum clean all

# overwrite default start.sh
COPY install/scripts/start.sh /scripts/
RUN chmod +x /scripts/start.sh