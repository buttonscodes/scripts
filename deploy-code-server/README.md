# These scripts deploy code server to a remote server via scp and ssh.

This has been tested on DigitalOcean Droplet with Ubuntu 24.10

Note that you may still get errors due to limitations of self-signed cert. The editor, terminal, and basic file browsing should still work — but WebViews and clipboard may not work reliably unless caddy is reconfigured with a domain name instead of an IP address.

### Warning about settings.json
I am setting a theme I like in the set-up-theme.sh script, by overwriting code-server/User/settings.json. If for some reason you deploy to an existing code-server installation, this will clear all of your settings. I don't know why you would do that though.

## Usage

```bash
./deploy-code-server.sh root@IP [--port <PORT>] [--password <PASSWORD>]
```

## Notes

deploy-code-server.sh script is called on local with optional PORT and PASSWORD arguments, by default PORT=8080 and PASSWORD=changeme123
    It copies install-code-server.sh and setup-caddy-selfsigned.sh to the remote server and runs them.

install-code-server.sh script runs on the remote and installs the code server

setup-caddy-selfsigned.sh script runs on the remote and sets up a self-signed HTTPS proxy with Caddy

set-up-theme.sh script runs on the remote and sets up a default theme for code-server

Setting up the HTTPS proxy is optional, but recommended for security and ease of use. Since HTTPS proxy is self-signed, you may need to click through a browser warning (self-signed cert).