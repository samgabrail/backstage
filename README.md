# Overview

This is a getting started with Backstage Tutorial. It's part of [this blog post.](https://tekanaid.com/posts/unlocking-developer-bliss-a-first-look-at-backstage-io)

## Instructions

I couldn't get it to work in codespaces, so working on my own machine.

### Install the App

Run this command:

```bash
nvm use 18 # to pin the version of node
npx @backstage/create-app@latest
```

Output:

```bash
npx @backstage/create-app@latest
Need to install the following packages:
@backstage/create-app@0.5.4
Ok to proceed? (y) y
? Enter a name for the app [required] my-backstage-app

Creating the app...

 Checking if the directory is available:
  checking      my-backstage-app ✔ 

 Creating a temporary app directory:
  creating      temporary directory ✔ 

 Preparing files:
  copying       .dockerignore ✔ 
  templating    .eslintrc.js.hbs ✔ 
  templating    .gitignore.hbs ✔ 
  copying       .prettierignore ✔ 
  copying       README.md ✔ 
  copying       app-config.local.yaml ✔ 
  copying       app-config.production.yaml ✔ 
  templating    app-config.yaml.hbs ✔ 
  templating    backstage.json.hbs ✔ 
  templating    catalog-info.yaml.hbs ✔ 
  copying       lerna.json ✔ 
  templating    package.json.hbs ✔ 
  copying       tsconfig.json ✔ 
  copying       yarn.lock ✔ 
  copying       README.md ✔ 
  copying       entities.yaml ✔ 
  copying       org.yaml ✔ 
  copying       template.yaml ✔ 
  copying       catalog-info.yaml ✔ 
  copying       index.js ✔ 
  copying       package.json ✔ 
  copying       README.md ✔ 
  templating    .eslintrc.js.hbs ✔ 
  copying       Dockerfile ✔ 
  copying       README.md ✔ 
  templating    package.json.hbs ✔ 
  copying       index.test.ts ✔ 
  copying       index.ts ✔ 
  copying       types.ts ✔ 
  copying       app.ts ✔ 
  copying       auth.ts ✔ 
  copying       catalog.ts ✔ 
  copying       proxy.ts ✔ 
  copying       scaffolder.ts ✔ 
  templating    search.ts.hbs ✔ 
  copying       techdocs.ts ✔ 
  copying       .eslintignore ✔ 
  templating    .eslintrc.js.hbs ✔ 
  copying       cypress.json ✔ 
  templating    package.json.hbs ✔ 
  copying       android-chrome-192x192.png ✔ 
  copying       apple-touch-icon.png ✔ 
  copying       favicon-16x16.png ✔ 
  copying       favicon-32x32.png ✔ 
  copying       favicon.ico ✔ 
  copying       index.html ✔ 
  copying       manifest.json ✔ 
  copying       robots.txt ✔ 
  copying       safari-pinned-tab.svg ✔ 
  copying       .eslintrc.json ✔ 
  copying       app.js ✔ 
  copying       App.test.tsx ✔ 
  copying       App.tsx ✔ 
  copying       apis.ts ✔ 
  copying       index.tsx ✔ 
  copying       setupTests.ts ✔ 
  copying       LogoFull.tsx ✔ 
  copying       LogoIcon.tsx ✔ 
  copying       Root.tsx ✔ 
  copying       index.ts ✔ 
  copying       EntityPage.tsx ✔ 
  copying       SearchPage.tsx ✔ 

 Moving to final location:
  moving        my-backstage-app ✔ 

 Installing dependencies:
  determining   yarn version ✔ 
  executing     yarn install ✔ 
  executing     yarn tsc ✔ 

🥇  Successfully created my-backstage-app


 All set! Now you might want to:
  Install the dependencies: cd my-backstage-app && yarn install
  Run the app: cd my-backstage-app && yarn dev
  Set up the software catalog: https://backstage.io/docs/features/software-catalog/configuration
  Add authentication: https://backstage.io/docs/auth/
```


### The Kubernetes Plugin

You will need to update the `app-config.yaml` file with your K8s cluster config.

#### Cluster URL

Get the K8s cluster URL using the following command:

```bash
kubectl cluster-info
```

#### K8s CA Data

Get your K8s CA Data from your kube config file for the cluster you are using

#### Create a Service Account

Run the following in my K8s cluster to create a service account with wide cluster permissions, this is for demo purposes only, don't use in production.

```yaml
kubectl apply -f service_account_wide.yaml
```

To get the service account token run the following:
```bash
export K8S_SA_TOKEN=$(kubectl get secret super-user-secret -n default -o jsonpath="{.data.token}" | base64 --decode)
```

Also run a test deployment:

```bash
kubectl apply -f deployment_nginx.yaml
```

##### Will need to try again with minikube

Install metrics-server in minikube

```bash
minikube addons enable metrics-server
```

### Launch the App

```bash
cd my-backstage-app
./secrets.sh
```

Or:

```bash
cd my-backstage-app
export GITHUB_TOKEN=your-github-token
export AUTH_GITHUB_CLIENT_ID=your-github-client-id
export AUTH_GITHUB_CLIENT_SECRET=your-github-client-secret
export K8S_CONFIG_CA_DATA=<your-ca-data-from-K8s-cluster>
export K8S_SA_TOKEN=<your-token-from-K8s-cluster>
yarn dev
```

Now you can open the frontend on port http://localhost:3000. 