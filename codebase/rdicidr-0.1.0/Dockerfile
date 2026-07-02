FROM node:15-alpine as builder
WORKDIR /app
# node-sass@5 has no prebuilt binary for Alpine/musl, so it compiles from
# source during install — which needs python3, make and a C++ toolchain.
RUN apk add --no-cache python3 make g++
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:1.21-alpine
WORKDIR /usr/share/nginx/html
COPY --from=builder /app/build .
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"]
