FROM debian:sid-slim AS builder

WORKDIR /root

RUN apt-get update \
  && apt-get install -y \
    build-essential \
    git \
    libsecret-1-dev \
    fakeroot \
    rpm \
    libx11-dev \
    libxkbfile-dev \
    curl \
    python2 \
    procps \
    libgtk-3-0 \
    libgtk-3-dev \
    libxss1 \
    libgtk2.0-0 \
    gconf-gsettings-backend \
    libasound2 \
    libnss3 \
    libxtst6

RUN ln -s /usr/bin/python2.7 /usr/bin/python

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash

RUN export NVM_DIR="/root/.nvm" \
  && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
  && [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" \
  && nvm install $(nvm ls-remote --lts|grep "Latest LTS" |tail -n 1) \
  && npm install -g npm \
  && npm config set python /usr/bin/python2 -g \
  && git clone https://github.com/atom/atom.git \
  && cd atom && script/build --create-debian-package \
  && pwd && ls -l out/


FROM debian:sid-slim

WORKDIR /root

COPY --from=builder /root/atom/out/*.deb .
RUN apt-get update && apt-get install -y \
  git \
  libgconf-2-4 \
  libgtk-3-0 \
  libnotify4 \
  libxtst6 \
  libnss3 \
  python \
  gvfs-bin \
  xdg-utils \
  libx11-xcb1 \
  libxss1 \
  libasound2 \
  libxkbfile1 \
  libcurl4 \
  policykit-1\
  sudo \
  libcanberra-gtk0 \
  libcanberra-gtk3-module \
  && rm -rf /var/lib/apt/lists/*

RUN dpkg -i /root/atom*.deb

RUN export uid=1000 gid=1000 \
    && mkdir -p /home/atom \
    && echo "atom:x:${uid}:${gid}:atom,,,:/home/atom:/bin/bash" >> /etc/passwd \
    && echo "atom:x:${uid}:" >> /etc/group \
    && echo "atom ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/atom \
    && chmod 0440 /etc/sudoers.d/atom \
    && chown ${uid}:${gid} -R /home/atom

USER atom
ENV HOME /home/atom
WORKDIR $HOME

RUN /usr/share/atom-dev/resources/app/apm/bin/apm install \
  git-plus \
  git-time-machine \
  language-terraform \
  language-ansible \
  language-puppet \
  git-time-machine \
  autocomplete-python \
  autocomplete-ansible \
  ansible-vault

ENTRYPOINT ["/usr/share/atom-dev/atom"]
CMD ["."]
