# These scripts deploy code server to a remote server via scp and ssh.

## Usage

```bash
./deploy-code-server.sh root@IP [PORT] [PASSWORD]
```

## Notes

deploy-code-server.sh script is called on local with optional PORT and PASSWORD arguments, by default PORT=8080 and PASSWORD=changeme123
    It copies install-code-server.sh and setup-caddy-selfsigned.sh to the remote server and runs them.

install-code-server.sh script runs on the remote and installs the code server

setup-caddy-selfsigned.sh script runs on the remote and sets up a self-signed HTTPS proxy with Caddy

Setting up the HTTPS proxy is optional, but recommended for security and ease of use. Since HTTPS proxy is self-signed, you may need to click through a browser warning (self-signed cert).