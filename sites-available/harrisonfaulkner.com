server {

    server_name request.harrisonfaulkner.com www.request.harrisonfaulkner.com;

    location / {
        proxy_pass http://192.168.1.25:5055;
        include proxy_params;
    }

    # listen [::]:443 ssl ipv6only=on; # managed by Certbot
    # listen 443 ssl; # managed by Certbot
    # ssl_certificate /etc/letsencrypt/live/request.harrisonfaulkner.com/fullchain.pem; # managed by Certbot
    # ssl_certificate_key /etc/letsencrypt/live/request.harrisonfaulkner.com/privkey.pem; # managed by Certbot
    # include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    # ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot




    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/plex.harrisonfaulkner.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/plex.harrisonfaulkner.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot




}
server {
    if ($host = www.request.harrisonfaulkner.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    if ($host = request.harrisonfaulkner.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80;
    listen [::]:80;

    server_name request.harrisonfaulkner.com www.request.harrisonfaulkner.com;
    return 404; # managed by Certbot




}

    server {
        server_name plex.harrisonfaulkner.com;
        set $plex http://192.168.1.15:32400;
        gzip on;
        gzip_vary on;
        gzip_min_length 1000;
        gzip_proxied any;
        gzip_types text/plain text/css text/xml application/xml text/javascript application/x-javascript image/svg+xml;
        gzip_disable "MSIE [1-6]\.";

        # Forward real ip and host to Plex
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        #When using ngx_http_realip_module change $proxy_add_x_forwarded_for to '$http_x_forwarded_for,$realip_remote_addr'
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Sec-WebSocket-Extensions $http_sec_websocket_extensions;
        proxy_set_header Sec-WebSocket-Key $http_sec_websocket_key;
        proxy_set_header Sec-WebSocket-Version $http_sec_websocket_version;

        # Websockets
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";

        # Buffering off send to the client as soon as the data is received from Plex.
        proxy_redirect off;
        proxy_buffering off;

        location / {
            proxy_pass $plex;
        }

    # listen 443 ssl; # managed by Certbot
    # ssl_certificate /etc/letsencrypt/live/plex.harrisonfaulkner.com/fullchain.pem; # managed by Certbot
    # ssl_certificate_key /etc/letsencrypt/live/plex.harrisonfaulkner.com/privkey.pem; # managed by Certbot
    # include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    # ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot




    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/plex.harrisonfaulkner.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/plex.harrisonfaulkner.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


}

    server {
    if ($host = plex.harrisonfaulkner.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


        listen 80;
        server_name plex.harrisonfaulkner.com;
    return 404; # managed by Certbot
}

server {

    server_name rss.harrisonfaulkner.com;

    location / {
        proxy_pass http://192.168.1.25:8585;
        include proxy_params;
    }

    # listen [::]:443 ssl; # managed by Certbot
    # listen 443 ssl; # managed by Certbot
    # ssl_certificate /etc/letsencrypt/live/rss.harrisonfaulkner.com/fullchain.pem; # managed by Certbot
    # ssl_certificate_key /etc/letsencrypt/live/rss.harrisonfaulkner.com/privkey.pem; # managed by Certbot
    # include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    # ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot



    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/plex.harrisonfaulkner.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/plex.harrisonfaulkner.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


}


server {
    if ($host = rss.harrisonfaulkner.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


    listen 80;
    listen [::]:80;

    server_name rss.harrisonfaulkner.com;
    return 404; # managed by Certbot


}

map $http_upgrade $connection_upgrade {
    default upgrade;
    '' close;
}


    server {
    if ($host = plex.harrisonfaulkner.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot


        server_name plex.harrisonfaulkner.com;
    listen 80;
    return 404; # managed by Certbot


}server {
    if ($host = request.harrisonfaulkner.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot



    server_name request.harrisonfaulkner.com www.request.harrisonfaulkner.com;
    listen 80;
    return 404; # managed by Certbot


}

server {
    if ($host = rss.harrisonfaulkner.com) {
        return 301 https://$host$request_uri;
    } # managed by Certbot



    server_name rss.harrisonfaulkner.com;
    listen 80;
    return 404; # managed by Certbot


}