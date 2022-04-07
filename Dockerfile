FROM node

RUN npm install -g sql-cli

WORKDIR /createuser
COPY ./create-user.sh .

ENTRYPOINT ["/bin/sh", "create-user.sh"]