FROM node:latest
LABEL name="srini"  email="srini91@gmail.com"
ENV PORT=3000


COPY . /app/nodeTestApp
WORKDIR /app/nodeTestApp

# VOLUME [ "/app/nodeTestApp" ]

RUN npm config set always-auth true
RUN npm config set strict-ssl true
RUN npm config set registry ""
RUN npm config set cafile ""
RUN npm config set _auth ""

RUN npm install

EXPOSE $PORT

CMD [ "npm","start" ]
