#! /bin/bash
# --restart unless-stopped \
docker run \
    --detach \
    --publish 8443:443 \
    --publish 8080:80 \
    --name gitlab \
    --volume /mnt/sda1/gitlab/etc:/etc/gitlab \
    --volume /mnt/sda1/gitlab/log:/var/log/gitlab \
    --volume /mnt/sda1/gitlab/data:/var/opt/gitlab \
    beginor/gitlab-ce