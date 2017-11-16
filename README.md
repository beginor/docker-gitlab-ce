# GitLab 中文社区版 Docker 镜像

基于 GitLab 官方社区版 Docker 镜像制作的中文 Docker 镜像， 汉化补丁来自网友 [larryli](https://gitlab.com/larryli/gitlab) (8.8.5之前)， 后续由网友 [xhang](https://gitlab.com/xhang/gitlab) 维护。

由于汉化工作需要大量的人力， 所以中文版的版本会比官方的版本稍低， 如果刻意最求最新版， 请使用官方的 GitLab Docker 镜像。

如果发现汉化的问题， 请向 [xhang](https://gitlab.com/xhang/gitlab) 反映。

## 获取镜像

```sh
docker pull beginor/gitlab-ce:10.1.0-ce.0
```

## 运行

通常会将 GitLab 的配置 (etc) 、 日志 (log) 、数据 (data) 放到容器之外， 便于日后升级， 因此请先准备这三个目录。

```sh
sudo mkdir -p /mnt/sda1/gitlab/etc
sudo mkdir -p /mnt/sda1/gitlab/log
sudo mkdir -p /mnt/sda1/gitlab/data
```
准备好这三个目录之后， 就可以开始运行 Docker 镜像了。 我的建议是使用`unless-stopped` 作为重启策略， 因为这样可以手工停止容器， 方便维护。

完整的运行命令如下：

```sh
docker run \
    --detach \
    --publish 8443:443 \
    --publish 8080:80 \
    --name gitlab \
    --restart unless-stopped \
    --volume /mnt/sda1/gitlab/etc:/etc/gitlab \
    --volume /mnt/sda1/gitlab/log:/var/log/gitlab \
    --volume /mnt/sda1/gitlab/data:/var/opt/gitlab \
    beginor/gitlab-ce:10.1.0-ce.0
```

## 升级

小版本升级（例如从 8.8.2 升级到 8.8.3）， 参照官方的说明， 将原来的容器停止， 然后删除：

```sh
docker stop gitlab
docker rm gitlab
```

然后重新拉一个新版本的镜像下来， 

```sh
docker pull beginor/gitlab-ce:10.1.0-ce.0
```

还使用原来的运行命令运行， 

```sh
docker run \
    --detach \
    --publish 8443:443 \
    --publish 8080:80 \
    --name gitlab \
    --restart unless-stopped \
    --volume /mnt/sda1/gitlab/etc:/etc/gitlab \
    --volume /mnt/sda1/gitlab/log:/var/log/gitlab \
    --volume /mnt/sda1/gitlab/data:/var/opt/gitlab \
    beginor/gitlab-ce:10.1.0-ce.0
```

GitLab 在初次运行的时候会自动升级， 为了预防万一， 还是建议先备份一下 `/mnt/sda1/gitlab/` 这个目录。

大版本升级（例如从 8.7.x 升级到 8.8.x）用上面的操作有可能会出现错误， 如果出现错误可以尝试登录到容器内部， 可以用 `docker exec` ， 也可以用 ssh ， 依次执行下面的命令：

```sh
gitlab-ctl reconfigure
gitlab-ctl restart
```

## 更多

想知道更多高级的玩法， 请参考这些： 

- The official GitLab Community Edition Docker image is [available on Docker Hub](https://registry.hub.docker.com/u/gitlab/gitlab-ce/).
- The official GitLab Enterprise Edition Docker image is [available on Docker Hub](https://registry.hub.docker.com/u/gitlab/gitlab-ee/).
- The complete usage guide can be found in [Using GitLab Docker images](http://doc.gitlab.com/omnibus/docker/).
- The Dockerfile used for building public images is in [Omnibus Repository](https://gitlab.com/gitlab-org/omnibus-gitlab/tree/master/docker).
- Check the guide for [creating Omnibus-based Docker Image](http://doc.gitlab.com/omnibus/build/README.html#Build-Docker-image).
