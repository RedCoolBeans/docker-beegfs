# BeeGFS storage server (node03)
FROM centos:7

LABEL beegfs_component="storage"

ENV BEEGFS_VERSION=6 \
    STORAGE_SERVICE_ID="3" \
    STORAGE_TARGET_ID="301" \
    STORAGE_LOCATION="/data"

RUN yum -q -y update

RUN curl -L -o /etc/yum.repos.d/beegfs-rhel7.repo \
  http://www.beegfs.com/release/beegfs_${BEEGFS_VERSION}/dists/beegfs-rhel7.repo
RUN yum install -q -y beegfs-storage; yum clean all

RUN mkdir -p ${STORAGE_LOCATION} && \
	/opt/beegfs/sbin/beegfs-setup-storage -p ${STORAGE_LOCATION} \
	    -s ${STORAGE_SERVICE_ID} -i ${STORAGE_TARGET_ID} -m node01

VOLUME ${STORAGE_LOCATION}

ADD beegfs/beegfs-storage.conf /etc/beegfs/

ADD run.sh /

RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]

EXPOSE 8003
