# build environment
FROM node:20.5.0-slim as react_build
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install
COPY . ./
RUN yarn build

# production environment
FROM node:20.5.0-slim
WORKDIR /app
COPY --from=react_build /app/.next ./.next
COPY --from=react_build /app/node_modules ./node_modules
COPY --from=react_build /app/package.json ./package.json
COPY --from=react_build /app/yarn.lock ./yarn.lock
COPY --from=react_build /app/public ./public 
EXPOSE 8080
CMD ["yarn", "start"]