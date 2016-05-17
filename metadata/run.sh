#!/bin/bash
#
# Wrapper around beegfs-meta to start the service _and_ keep an eye
# on the log. beegfs-meta is able to run non-daemonized, but it
# doesn't report anything on stdout/stderr.

: ${BEEGFS_LOGLEVEL:="3"}

/opt/beegfs/sbin/beegfs-meta \
    cfgFile=/etc/beegfs/beegfs-meta.conf \
    logLevel=${BEEGFS_LOGLEVEL}

tail -f /var/log/beegfs-meta.log
