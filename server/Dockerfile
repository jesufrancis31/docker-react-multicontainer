M node:alpine
WORKDIR "/app"
COPY ./package.json ./
RUN npm install
COPY . .
iCMD ["npm", "run", "start"]


