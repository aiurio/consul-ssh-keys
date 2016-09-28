FROM hashicorp/consul:latest
MAINTAINER your mom
ADD doit.sh /
ENTRYPOINT [ "/bin/busybox","sh","/doit.sh" ]
