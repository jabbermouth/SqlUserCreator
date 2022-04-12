FROM node

RUN npm install -g sql-cli

WORKDIR /createuser
COPY ./create-user.sh .

ENTRYPOINT ["/bin/bash", "create-user.sh"]