FROM centos:centos7
MAINTAINER Steve Kluck "kevinliuca@gmail.com"

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Import EPEL
RUN yum --assumeyes install epel-release && \
    yum --assumeyes install yum-utils wget

# Import RPM Forge, ERL Solutions
RUN rpm -Uvh http://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm


################################################################################
# General
################################################################################

WORKDIR /tmp/
ENV HOME /root

RUN yum --assumeyes install \
    git-core tar bzip2 unzip net-tools which \
    && yum clean all

################################################################################
# Erlang
################################################################################

RUN yum --assumeyes install \
    erlang-18.1 \
    && yum clean all

################################################################################
# Elixir
################################################################################
# Reference: https://github.com/trenpixster/elixir-dockerfile

ENV HEX_UNSAFE_HTTPS 1

WORKDIR /elixir
RUN wget https://github.com/elixir-lang/elixir/releases/download/v1.2.3/Precompiled.zip && \
    unzip Precompiled.zip && \
    rm -f Precompiled.zip && \
    ln -s /elixir/bin/elixirc /usr/local/bin/elixirc && \
    ln -s /elixir/bin/elixir /usr/local/bin/elixir && \
    ln -s /elixir/bin/mix /usr/local/bin/mix && \
    ln -s /elixir/bin/iex /usr/local/bin/iex

# Install local Elixir hex and rebar
RUN /usr/local/bin/mix local.hex --force && \
    /usr/local/bin/mix local.rebar --force

################################################################################
# CLEAN UP
################################################################################

WORKDIR $HOME
RUN yum clean all