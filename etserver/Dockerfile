FROM opensuse/leap

RUN zypper ref
RUN zypper --non-interactive in EternalTerminal
RUN zypper --non-interactive in openssh
RUN zypper --non-interactive in fish
RUN sed -i 's/2022/9022/' /etc/et.cfg

RUN echo IyEvYmluL2Jhc2gKCnNldCAteAoKaWYgWyAiJDEiID09IHNlcnZlciBdOyB0aGVuCiAgICAvdXNyL3NiaW4vc3NoZAogICAgc2hpZnQKICAgIGV4ZWMgZXRzZXJ2ZXIgLS1sb2d0b3N0ZG91dCAtdiAxICIkQCIKZWxzZQogICAgc2hpZnQKICAgIGV4ZWMgZXQgIiRAIgpmaQo= | base64 -w 0 -d > /bin/container_entrypoint
RUN chmod a+x /bin/container_entrypoint

ENTRYPOINT ["/bin/container_entrypoint", "server"]
CMD ["--cfgfile=/etc/et.cfg"]
