FROM gitlab/gitlab-ce:8.8.3-ce.0

MAINTAINER beginor <beginor@qq.com>

ENV TMPDIR=/tmp/gitlab-zh
ENV GITLAB_BRUNCH=8-8

# clone && apply zh patch.
RUN git clone --progress https://gitlab.com/larryli/gitlab.git -b $GITLAB_BRUNCH-zh $TMPDIR && \
    cd $TMPDIR && \
    git diff origin/$GITLAB_BRUNCH-stable..$GITLAB_BRUNCH-zh > $TMPDIR/$GITLAB_BRUNCH-zh.diff && \
    cd /opt/gitlab/embedded/service/gitlab-rails && git apply $TMPDIR/$GITLAB_BRUNCH-zh.diff &&\
    rm -rf $TMPDIR

# Expose web & ssh
EXPOSE 443 80 22

# Define data volumes
VOLUME ["/etc/gitlab", "/var/opt/gitlab", "/var/log/gitlab"]
# Wrapper to handle signal, trigger runit and reconfigure GitLab
CMD ["/assets/wrapper"]
