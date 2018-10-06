FROM node:10
RUN useradd -m myuser
USER myuser
WORKDIR /home/myuser
COPY --chown=myuser:myuser . .
RUN npm install
RUN npm run build
CMD ["npm", "start"]
