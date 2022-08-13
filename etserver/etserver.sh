docker run -d --rm -p 9022:9022 -p 9222:32222 \
    -v /etc/ssh:/etc/ssh \
    -v /etc/passwd:/etc/passwd \
    -v /etc/shadow:/etc/shadow \
    -v /etc/group:/etc/group \
    -v /home:/home \
    --name etserver \
    etserver
