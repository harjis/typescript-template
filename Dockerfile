FROM node:22.5-alpine AS build

# More info about dumb-init here #5: https://snyk.io/blog/10-best-practices-to-containerize-nodejs-web-applications-with-docker/

RUN apk upgrade --no-cache && \
    apk add dumb-init=1.2.5-r3

WORKDIR /typescript-template
COPY . .
RUN npm ci  \
    && npm run build

FROM node:22.5-alpine

WORKDIR /typescript-template
ENV NODE_ENV=production
COPY --from=build /usr/bin/dumb-init /usr/bin/dumb-init

COPY --chown=node:node --from=build /typescript-template/package* ./
RUN npm ci --omit=dev

COPY --chown=node:node --from=build /typescript-template/dist/ ./dist/
COPY --chown=node:node --from=build /typescript-template/.env.example ./

USER node
CMD ["dumb-init", "node", "/typescript-template/dist/src/index.js"]
