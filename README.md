# Overview

This is a getting started with Backstage Tutorial.

## Instructions

### Install the App

Run this command:

```bash
npx @backstage/create-app@latest
```

you may get an error with the `yarn install` command

```
executing     yarn install ✖ 

Error: Could not execute command yarn install

It seems that something went wrong when creating the app 🤔

🔥  Failed to create app!
```

Just run the `yarn install` command again.

Output:

```
@samgabrail ➜ /workspaces/backstage (main) $ yarn install
yarn install v1.22.19
info No lockfile found.
[1/4] Resolving packages...
[2/4] Fetching packages...
[3/4] Linking dependencies...
[4/4] Building fresh packages...
success Saved lockfile.
Done in 0.05s.
```

### Update the Node Version Requirement

Run:

```
nvm use 18
```

### Launch the App

```bash
cd backstage
yarn install
yarn dev
```

