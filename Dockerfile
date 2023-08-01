FROM oraclelinux:7-slim
LABEL maintainer="Team at Oracle"
LABEL description="OCI format to generate CD3 image"

ARG USERNAME=cd3user
ARG USER_UID=1001
ARG USER_GID=$USER_UID

RUN yum install sudo -y && groupadd --gid $USER_GID $USERNAME \
&& useradd --uid $USER_UID --gid $USER_GID -d /$USERNAME -m $USERNAME \
&& echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
&& chmod 0440 /etc/sudoers.d/$USERNAME \
&& mkdir /cd3user/tenancies/ && sudo chown -R $USERNAME:$USERNAME /cd3user/tenancies/


USER $USERNAME
WORKDIR /cd3user/oci_tools/
COPY $PWD/cd3_automation_toolkit ./cd3_automation_toolkit

RUN ls -la 

RUN sudo yum install -y oracle-softwarecollection-release-el7 \
&& sudo chown -R $USERNAME:$USERNAME /cd3user/


#WORKDIR /cd3user/
WORKDIR /cd3user/oci_tools/cd3_automation_toolkit

RUN sudo sed -i -e 's/\r$//' /cd3user/oci_tools/cd3_automation_toolkit/shell_script.sh \
&& bash /cd3user/oci_tools/cd3_automation_toolkit/shell_script.sh \
&& sudo chown -R cd3user:cd3user /cd3user/ && sudo yum clean all && sudo rm -rf /var/cache/yum /root/ocswork \
&& sudo chmod -R 740 /cd3user/


#RUN sudo sed -i -e 's/\r$//' /cd3user/oci_tools/cd3_automation_toolkit/shell_script.sh \
#&& bash /cd3user/oci_tools/cd3_automation_toolkit/shell_script.sh \
#&& sudo chown -R cd3user:cd3user /cd3user/ && sudo yum clean all && sudo rm -rf /var/cache/yum /root/ocswork \
#&& sudo rm -rf /cd3user/oci_tools/Dockerfile && sudo rm -rf /cd3user/oci_tools/Readme.md \
#&& sudo rm -rf /cd3user/oci_tools/.git && sudo rm -rf /cd3user/oci_tools/.gitignore && sudo chmod -R 740 /cd3user/

