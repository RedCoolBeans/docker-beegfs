# BeeGFS metadata server (node02)
FROM centos:7

LABEL beegfs_component="metadata"

ENV BEEGFS_VERSION=6 \
    METADATA_SERVICE_ID=2

RUN yum -q -y update
RUN curl -L -o /etc/yum.repos.d/beegfs-rhel7.repo \
  http://www.beegfs.com/release/beegfs_${BEEGFS_VERSION}/dists/beegfs-rhel7.repo
RUN yum install -q -y beegfs-meta; yum clean all

RUN /opt/beegfs/sbin/beegfs-setup-meta -p /data/beegfs/beegfs_meta \
    -s ${METADATA_SERVICE_ID} -m node01

ADD beegfs/beegfs-meta.conf /etc/beegfs/
ADD run.sh /

RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]

EXPOSE 8005
