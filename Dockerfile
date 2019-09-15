FROM centos:7

COPY _built /_built

CMD [ "/_built/bin/app" ]
