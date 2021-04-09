# SSH Stuff

## Create a new SSH key

Adapted from [Github's instructions](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh).

```bash
ssh-keygen \
    -t ed25519 \
    -C "your_email@example.com" \
    -f "~/keys/github_username.pem"
```

## Add key to ssh config

Add the following block to `~/.ssh/config`:

```
Host github.com
  Hostname github.com
  user username
  IdentityFile ~/keys/github_username.pem
```

## The public key

The public key will be created at `~/keys/github_username.pem`.

ONLY EVER GIVE OUT THE PUBLIC KEY!!!  THE ONE THAT ENDS IN `.pub`!!!
