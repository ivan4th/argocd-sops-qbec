FROM argoproj/argocd:v1.4.2

# Switch to root for the ability to perform install
USER root

RUN apt-get update && \
    apt-get install -y \
        curl \
        gpg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    curl -sSL https://github.com/splunk/qbec/releases/download/v0.10.4/qbec-linux-amd64.tar.gz | \
      tar -C /usr/local/bin -xvz qbec && \
      echo '2db046f39119bbf4ce51e13502359625ccc0fba24c8d8a65b44385414ac0b8e6  /usr/local/bin/qbec' | sha256sum -c && \
      curl -sSL -o /usr/local/bin/sops https://github.com/mozilla/sops/releases/download/v3.5.0/sops-v3.5.0.linux && \
      echo '610fca9687d1326ef2e1a66699a740f5dbd5ac8130190275959da737ec52f096  /usr/local/bin/sops' | sha256sum -c && \
      chmod +x /usr/local/bin/sops

COPY qbec.sh /usr/local/bin/qbec.sh

# Switch back to non-root user
USER argocd
