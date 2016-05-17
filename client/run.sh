#!/bin/bash
#
# Wrapper around beegfs client services to start the services _and_
# keep an eye on the logs.

trap "umount -f /mnt/beegfs" SIGINT SIGTERM

: ${BEEGFS_LOGLEVEL:="3"}

/opt/beegfs/sbin/beegfs-helperd \
    cfgFile=/etc/beegfs/beegfs-helperd.conf \
    logLevel=${BEEGFS_LOGLEVEL}

# Give the other daemons a change to start up before attempting to mount anything
sleep 10

###
# Code until EOT copied from init.d/beegfs-client
SELINUX_OPT=""
DEFAULT_FS_TYPE="beegfs"
BEEGFS_MOUNT_CONF="/etc/beegfs/beegfs-mounts.conf"
echo "- Mounting directories from $BEEGFS_MOUNT_CONF"

OLDIFS="$IFS"
IFS=$'\n'
file=`tr -d '\r' < $BEEGFS_MOUNT_CONF`
for line in $file; do
  if [ -z "$line" ]; then
     continue # ignore empty line
  fi

  mnt=`echo $line | awk '{print $1}'`
  cfg=`echo $line | awk '{print $2}'`
  fstype=`echo $line | awk '{print $3}'`

  if [ -z "$mnt" -o -z "$cfg" ]; then
     echo "Invalid config line: \"$line\""
     continue
  fi

  if [ -z "$fstype" ]; then
     fstype=${DEFAULT_FS_TYPE}
  fi

  set +e
  mount -t ${fstype} | grep "${mnt} " >/dev/null 2>&1
  if [ $? -eq 0 ]; then
     # already mounted
     set -e
     continue
  fi
  set -e

  if [ ! -e ${mnt} ]; then mkdir -p ${mnt}; fi
    # XXX:
    # Prevent this from failing as it would kill the container.
    # However an error ought to be printed too.
    mount -t ${fstype} beegfs_nodev ${mnt} -ocfgFile=${cfg},_netdev,${SELINUX_OPT} || true
done

IFS="$OLDIFS"
# EOT
###

tail -f /var/log/beegfs-client.log
