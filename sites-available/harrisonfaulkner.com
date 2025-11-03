# WebSocket upgrade map (must be at top level, outside server blocks)
map $http_upgrade $connection_upgrade {
    default upgrade;
    '' close;
}

# ============================================
# request.harrisonfaulkner.com
# ============================================
server {
    listen 80;
    listen [::]:80;
    server_name request.harrisonfaulkner.com www.request.harrisonfaulkner.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name request.harrisonfaulkner.com www.request.harrisonfaulkner.com;

    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/request.harrisonfaulkner.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/request.harrisonfaulkner.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    location / {
        proxy_pass http://192.168.1.25:5055;
        include proxy_params;

        # WebSocket support
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        proxy_read_timeout 86400;
    }
}

# ============================================
# plex.harrisonfaulkner.com
# ============================================
server {
    listen 80;
    listen [::]:80;
    server_name plex.harrisonfaulkner.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name plex.harrisonfaulkner.com;

    # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/plex.harrisonfaulkner.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/plex.harrisonfaulkner.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    # Plex-specific settings
    client_max_body_size 100M;

    # Gzip compression
    gzip on;
    gzip_vary on;
    gzip_min_length 1000;
    gzip_proxied any;
    gzip_types text/plain text/css text/xml application/xml text/javascript application/x-javascript image/svg+xml;
    gzip_disable "MSIE [1-6]\.";

    location / {
        proxy_pass http://192.168.1.15:32400;

        # Forward real IP and host to Plex
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # WebSocket support
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        proxy_set_header Sec-WebSocket-Extensions $http_sec_websocket_extensions;
        proxy_set_header Sec-WebSocket-Key $http_sec_websocket_key;
        proxy_set_header Sec-WebSocket-Version $http_sec_websocket_version;

        # Buffering settings
        proxy_redirect off;
        proxy_buffering off;
    }
}

# ============================================
# rss.harrisonfaulkner.com
# ============================================
server {
    listen 80;
    listen [::]:80;
    server_name rss.harrisonfaulkner.com;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name rss.harrisonfaulkner.com;

 
   # SSL Configuration
    ssl_certificate /etc/letsencrypt/live/rss.harrisonfaulkner.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/rss.harrisonfaulkner.com/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    location / {
        proxy_pass http://192.168.1.25:8585;
        include proxy_params;

        # WebSocket support
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
    }
}
