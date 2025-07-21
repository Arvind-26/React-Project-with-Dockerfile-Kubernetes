FROM node:latest AS builder
WORKDIR /home/ubuntu
COPY . .
RUN npm install
RUN npm run build
FROM nginx AS final
COPY --from=builder /home/ubuntu/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
