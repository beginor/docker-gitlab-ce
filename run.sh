#! /bin/bash

docker run \
    --detach \
    --publish 8443:443 \
    --publish 8080:80 \
    --name gitlab \
    --restart unless-stopped \
    --volume /mnt/sda1/gitlab/etc:/etc/gitlab \
    --volume /mnt/sda1/gitlab/log:/var/log/gitlab \
    --volume /mnt/sda1/gitlab/data:/var/opt/gitlab \
    beginor/gitlab-ce