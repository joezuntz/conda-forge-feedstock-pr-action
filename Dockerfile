# Container image that runs your code
FROM python:3.10.2
MAINTAINER joezuntz@googlemail.com

RUN pip  install pygithub

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY entrypoint.sh /entrypoint.sh
COPY make-pr.py /make-pr.py

# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
