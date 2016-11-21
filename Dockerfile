FROM gitlab/gitlab-ce:8.13.6-ce.0

MAINTAINER beginor <beginor@qq.com>

ENV TMPDIR=/tmp/gitlab-zh
ENV GITLAB_VERSION=v8.13.6

# clone && apply zh patch.
RUN git clone --progress --verbose -b $GITLAB_VERSION https://gitlab.com/gitlab-org/gitlab-ce.git $TMPDIR && \
    cd $TMPDIR && \
    git remote add xhang https://gitlab.com/xhang/gitlab.git && \
    git fetch --progress --verbose xhang --tag $GITLAB_VERSION-zh && \
    git diff $GITLAB_VERSION..$GITLAB_VERSION-zh > $TMPDIR/$GITLAB_VERSION-zh.diff && \
    cd /opt/gitlab/embedded/service/gitlab-rails && git apply $TMPDIR/$GITLAB_VERSION-zh.diff && \
    rm -rf $TMPDIR

# Expose web & ssh
EXPOSE 443 80 22

# Define data volumes
VOLUME ["/etc/gitlab", "/var/opt/gitlab", "/var/log/gitlab"]
# Wrapper to handle signal, trigger runit and reconfigure GitLab
CMD ["/assets/wrapper"]
