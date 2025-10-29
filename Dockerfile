# If the upstream uses pnpm or yarn, swap the install commands accordingly.
FROM node:20 AS build
WORKDIR /app
# Pull source at build time
RUN git clone --depth=1 https://github.com/nostrocket/relayexplorer /src
WORKDIR /src
# Try npm first; if it fails, use: corepack enable && pnpm i && pnpm build
RUN npm ci || npm install
RUN npm run build

FROM nginx:alpine
COPY --from=build /src/dist /usr/share/nginx/html
# Optional: small index fallback (often fine for SPA)
RUN printf "try_files \$uri /index.html;" > /etc/nginx/conf.d/default.conf || true
