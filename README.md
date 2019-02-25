# GitHub Backup
Powershell script to back up all (public and private) repositories in a GitHub account.

It can be run directly or a Docker image can be built by using the Dockerfile in the repo.


Dockerized my GitHub backup script.
Blog post: https://volkan
Source code: https://
Docker image: hub.docker/,.,,




## Pre-requisities

- General personal access token github
- Generate SSH keys 

https://help.github.com/en/articles/adding-a-new-ssh-key-to-your-github-account

confirm the fingerprint:
ssh-add -l -E md5

list the keys:
ssh-add -l


### Optional: Enable notifications (Email and/or AWS SNS) 



## Powershell


## Docker image

Pull the image from Docker hub:

```
docker pull volkanx/github-backup
```

and start a container from the image:

```
docker run --rm -d -v /host/path/to/data:/home/gh-backup-data -v /host/path/to/config:/home/gh-backup-config -v ~/.ssh:/root/.ssh:ro volkanx/github-backup -ConfigPath /home/gh-backup-config/config.json
```

The command above runs the backup and deletes the container automatically.


## Build your own image

Open a terminal in the root of the repo

```
docker build . -t {image name}
```




## Running it on Windows

Windows container


## Running it on Raspberry Pi

ARM image


## Scheduling the runs



