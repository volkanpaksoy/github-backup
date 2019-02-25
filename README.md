# GitHub Backup
Powershell script to back up all (public and private) repositories in a GitHub account. It can be run directly as script or a Docker image can be built by using the Dockerfile in the repo.

## Pre-requisities

### Personal access token
To be able to get a list of private repositories in your GitHub account you'd need a Personal Access Token. Generating one is quite straightforward:

1. Go to this page: https://github.com/settings/tokens/new
2. Tick repo checkbox so that token has access to private repositories
3. Click Generate token button at the bottom of the page

### SSH key
If you don't have already you'd need a SSH key that has been added to your GitHub account. You can follow this guide for that: https://help.github.com/en/articles/adding-a-new-ssh-key-to-your-github-account

### [Optional] Enable notifications (Email and/or AWS SNS) 
You can choose to receive notifications via Email or let the script publish the result to an SNS topic you provide. 

If you choose to receive notifications create the IAM accounts with required permissions and populate the config.json with those values. Make sure you set the enabled flag to true

```
    "sns": {
        "enabled": false,
        "topicArn": "",
        "accessKey": "",
        "secretKey": "",
        "region": ""
    },
    "email": {
        "enabled": false,
        "fromEmailAddress": "",
        "toEmailAddress": "",
        "smtpHost": "",
        "smtpUsername": "",
        "smtpPassword": "",
        "smtpPort": 0
    }
```


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



