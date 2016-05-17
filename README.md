# BeeGFS on Docker

## Host setup

### Kernel module

First the `beegfs` kernel module needs to be loaded:

	modprobe beegfs

If it hasn't been built either copy `./beegfs.ko` into `/lib/modules/3.10.0-327.18.2.el7.x86_64/updates/fs/beegfs_autobuild/beegfs.ko`
if the kernel version matches (built on CentOS 7.2.1511).
Otherwise install `beegfs-client`, then:

	cd /opt/beegfs/src/client/beegfs_client_module_2015.03/build
	make beegfs

Path to kernel headers may be incorrect; to fix it up:

	ln -s 3.10.0-327.18.2.el7.x86_64/ /usr/src/kernels/3.10.0-327.18.2.el7.x86_64/

### SELinux

In order for BeeGFS to function properly SELinux needs to be disabled on the host too.

## Build containers

You can skip building the images if you're using the images from the Docker Hub:

	docker-compose -f docker-compose.dev.yml build

## Run containers

	docker-compose up

or to force them to the background with:

	docker-compose start

If you have enable the client (see caveats section below):

Verify the client has mounted the file system:

	host# docker exec -ti dockerbeegfs_client_1 beegfs-df

Otherwise you can use `beegfs-df` from another client instead.

## Setup description

The storage container uses a volume for the storage directory `/data`. By default
the `docker-compose.yml` will use `~/beegfs_storage` on the host. This ensures that
all files will be persistent across container restarts.

The hostname of the `storage` container is encoded into `/data/originalNodeID`. This
container therefore has a fixed hostname `node03.dockerbeegfs`. If this is not desired the
aforementioned file must be removed between storage container restarts or it will fail
to start again:

	"Error: NodeID has changed from 'e2a56526a0b9' to 'ee6886c9c982'. Shutting down... (File: /data/originalNodeID)"

### Node names

The containers/hostnames vs. service mapping is equivalent to what's used in the
[Quickstart Guide](http://www.beegfs.com/wiki/ManualInstallWalkThrough#example_setup)

## Caveats

The client container (`node04`) may sometimes have issues stopping cleanly and may
actually hog the Docker daemon itself at times. This is most likely related to the
fact it's using the external kernel module. The container is only included for
demonstration purposes and not started by default.

If you want to write to a BeeGFS cluster from within a Docker container you should
use the [docker-volume-beegfs](https://github.com/RedCoolBeans/docker-volume-beegfs) plugin instead.
It exposes a Docker native volume to your containers.

## Environment variables

- `BEEGFS_LOGLEVEL`: 0 - 5 (default: 3)
- metadata-specific:
  - `METADATA_SERVICE_ID` default: 2
- storage-specific:
  - `STORAGE_SERVICE_ID` default: 3
  - `STORAGE_TARGET_ID` default: 301

## Support

These images are provided free of charge by RedCoolBeans. Various security measures
have not been implemented or added in these images.
For supported and security hardened images with BeeGFS, please [contact us](http://www.redcoolbeans.com/contact/).

## Copyright and license

MIT, please see the LICENSE file.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
