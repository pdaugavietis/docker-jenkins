FROM jenkins/jenkins

MAINTAINER Peter Daugavietis <peter.daugavietis@rbc.com>

ENV http_proxy http://172.17.0.1:3128
ENV https_proxy http://172.17.0.1:3128

# Install Jenkins plugins
RUN install-plugins.sh \
    # Core plugins
    blueocean \
    docker-workflow \
    locale \

    # Pipeline related
    workflow-aggregator \
    pipeline-stage-view \
    delivery-pipeline-plugin \
    embeddable-build-status \
    workflow-multibranch \
    pipeline-github \
    jira-steps \
    jenkins-flowdock-plugin \

    # VCS related
    git \
    github \
    github-organization-folder \
    artifactory \

    # Other plugins
    jira

# Install Docker binaries
# see: https://docs.docker.com/engine/installation/binaries/
USER root
RUN cd \
    && set -x \
    && curl -fSL "https://get.docker.com/builds/Linux/x86_64/docker-latest.tgz" -o docker.tgz \
    && tar -xzvf docker.tgz \
    && mv docker/* /usr/local/bin/ \
    && rmdir docker \
    && rm docker.tgz

RUN groupadd docker \
    && usermod -aG docker,staff jenkins

USER jenkins

VOLUME /var/run/docker.sock
