# FROM - specify the base container you want to start your build from 
#
# example:
#  FROM CONTAINER_NAME:tag
# 
# Recommended base images
#  nodejs - node:6.9-onbuild -- https://hub.docker.com/_/node/
#  python - python:3-onbuild -- https://hub.docker.com/_/python/ 
#  ruby on rails -  rails:onbuild -- https://hub.docker.com/_/rails/
#  django - python:3.4 -- https://hub.docker.com/_/django/; official repo is depcrecated 
#  mysql - mysql:5 -- https://hub.docker.com/_/mysql/
#  postgres - postgres:9 -- https://hub.docker.com/_/postgres/
#  redis - redis:3.0 -- https://hub.docker.com/r/_/redis/

FROM ubuntu:latest

# RUN - Set up your container 
# 
# note: you can have multiple RUN blocks for configuration
# 
# example: 
#   RUN apt-get update && apt-get install -y mongodb (note: you can have multiple RUN blocks for configuration)
RUN apt-get -y update && apt-get install -y PACKAGE_NAME_1 PACKAGE_NAME_2

# WORKDIR - Set your working directory
#
# example:
#   WORKDIR /SOME_DIRECTORY

# CP - copy files from directory docker build is run, usually the repo directory.
#      CP . .  copies out the files from the current directory into the container
CP . .

# CMD - Run the command for your service or job
# if you are running a service, you'll want to make sure the process
# writes its output to stdout (e.g., you could tail -f your service's logs)
# 
# example:
# CMD ["COMMAND_NAME", "ARGS"] 
CMD ["/bin/bash", "/usr/local/bin/start-all.sh"]
