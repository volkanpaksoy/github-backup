FROM mcr.microsoft.com/powershell

RUN apt-get update && apt-get install -y git
RUN pwsh -command "Install-Module -Name AWSPowerShell.NetCore -Scope AllUsers -AllowClobber -Force -SkipPublisherCheck"

RUN echo "    IdentityFile ~/.ssh/id_rsa" >> /etc/ssh/ssh_config
RUN echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config

RUN mkdir -p /root/.ssh
RUN mkdir -p /home/gh-backup-config
RUN mkdir -p /home/gh-backup-data

WORKDIR /home
COPY ./backup-github.ps1 .
COPY ./config.psm1 .

ENTRYPOINT ["pwsh", "backup-github.ps1"]
