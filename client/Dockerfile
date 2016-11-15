# BeeGFS client (node04)
FROM centos:7

LABEL beegfs_component="client"

ENV BEEGFS_VERSION 6

RUN yum -q -y update
RUN curl -L -o /etc/yum.repos.d/beegfs-rhel7.repo \
  http://www.beegfs.com/release/beegfs_${BEEGFS_VERSION}/dists/beegfs-rhel7.repo
RUN yum install -q -y beegfs-client beegfs-helperd beegfs-utils; yum clean all

RUN /opt/beegfs/sbin/beegfs-setup-client -m node01

ADD beegfs/*.conf /etc/beegfs/
ADD run.sh /

RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]

EXPOSE 8004 8006
