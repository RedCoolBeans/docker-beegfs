# BeeGFS management server (node01)
FROM centos:7

LABEL beegfs_component="management"

ENV BEEGFS_VERSION 6

RUN yum -q -y update

#
# BeeGFS << EOT
#
RUN curl -L -o /etc/yum.repos.d/beegfs-rhel7.repo \
  http://www.beegfs.com/release/beegfs_${BEEGFS_VERSION}/dists/beegfs-rhel7.repo
RUN yum install -q -y beegfs-mgmtd beegfs-utils; yum clean all

RUN /opt/beegfs/sbin/beegfs-setup-mgmtd -p /data/beegfs/beegfs_mgmtd

ADD beegfs/beegfs-mgmtd.conf /etc/beegfs/
ADD run.sh /

RUN chmod +x /run.sh
# EOT

ENTRYPOINT ["/run.sh"]

EXPOSE 8008
