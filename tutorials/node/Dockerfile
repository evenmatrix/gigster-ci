#---README---#
# 
# Type "docker build . -t YOUR_REPO_NAME:latest" in your local repo directory to create the docker container.
# This file will build successfully without modification, though it won't do anything
# useful at that point.
#
# Please customize the commands in each of the four stages below to your apps specifications
# before checking in.

#---SECTION 1: SET THE BASE CONTAINER---#
# FROM - specify the base container you want to start your build from 
#
# example:
#  FROM CONTAINER_NAME:tag
# 
# recommended base images
#  nodejs - node:6.9 -- https://hub.docker.com/_/node/
#  python - python:3-onbuild -- https://hub.docker.com/_/python/ 
#  ruby on rails -  rails:onbuild -- https://hub.docker.com/_/rails/
#  django - python:3.4 -- https://hub.docker.com/_/django/; official repo is depcrecated 
#  mysql - mysql:5 -- https://hub.docker.com/_/mysql/
#  postgres - postgres:9 -- https://hub.docker.com/_/postgres/
#  redis - redis:3.0 -- https://hub.docker.com/r/_/redis/

FROM node:6.9

# ---SECTION 2: SETUP THE CONTAINER---# 
#
# Container setup uses RUN, WORKDIR, and CP directives
#
# RUN - Run a series of commands in sequence
# note: you can have multiple RUN blocks for configuration
# 
# example: 
#   RUN apt-get update && apt-get install -y mongodb

RUN apt-get -y update
RUN npm install mocha -g
RUN mkdir /node-tutorial

# WORKDIR - Set your working directory
#
# example:
#   WORKDIR /SOME_DIRECTORY

WORKDIR /node-tutorial
# COPY - copy files from directory docker build is run, usually your local copy of the repo
#      COPY . .  copies out the files from the current directory into the container

COPY . .

#---SECTION 3. INSTALL OR PATCH YOUR CODE---#
#
# note: you can have multiple RUN blocks
#
# install example:
#   RUN npm install
# 
# patch example:
#   RUN cp patches/SOME_FILE.js node_modules/restify/lib/SOME_FILE.js 

RUN npm install

#---SECTION 4. EXPOSE PORTS---#
# 
# EXPOSE informs Docker that the container listens on the specified network ports at runtime. 
# You can expose one port number and publish it externally under another number.

EXPOSE 3000:3000

#---SECTION 5. INITIATE THE JOB / SERVICE---#
#
# CMD - Run the command for your service or job
# if you are running a service, you'll want to make sure the process
# writes its output to stdout (e.g., you could tail -f your service's logs)
# 
# example 1: this is the general format for the command
#   CMD ["COMMAND_NAME", "ARGS"] 
#
# example 2: your CMD command will likely look like this
#   CMD ["/bin/bash", "/usr/local/bin/start-all.sh"]
#
# example 3: 
#   CMD ["tail","-f","/etc/hosts"]
# 
#    This will execute a command that will keep your container running after
#    run it. this does nothing useful, but ensures that PID 1 exists. Docker stops when 
#    PID 1 is gone, which occurs when the CMD command terminates  

CMD ["npm","run", "start"]
