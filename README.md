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

## Installing in K8s using Helm

### Build the Docker container

```bash
cd my-backstage-app
./start.sh 1.0.3
```

### Install in Kubernetes

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add backstage https://backstage.github.io/charts
kubectl create ns backstage
./create_k8s_secrets_for_backstage.sh
kubectl create secret generic google-creds \
  --from-file=google-creds.json=./packages/backend/google-creds.json \
  --namespace backstage
kubectl apply -f my-backstage-secrets.yaml
helm upgrade --install backstage backstage/backstage --namespace backstage -f values.yaml --set backstage.image.tag=v1.0.5
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

### ArgoCD Plugin

[Follow these instructions.](https://roadie.io/backstage/plugins/argo-cd/)

#### Add a K8s cluster to Argo

For GKE, first connect to the cluster:
```bash
gcloud container clusters get-credentials samgke-p4mhk --region us-central1 --project crossplaneprojects
```

Then use the Argo CLI to add the cluster:
```bash
argocd cluster add your-gke-cluster-context --name your-gke-cluster-for-argocd
```

Example:
```bash
argocd cluster add gke_crossplaneprojects_us-central1_samgke-p4mhk --name gke-dev
```

If you need to generate an API token by running the command or login with the cli using `argocd login argocd.tekanaid.com` and then run the command:
```bash
argocd account generate-token
```

### Launch the App Locally

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


## Demo Steps

### Full Workflow Demo

#### Persona: Platform Engineer
1. Use Backstage's template `New GKE Cluster` to create a new cluster
2. Show the flow from Backstage to the Repo to GitHub Actions to ArgoCD to GCP then wait for the cluster to come up
3. Register the GKE Cluster in ArgoCD Manually using the name of the cluster from GCP
```bash
gcloud container clusters get-credentials samgke-jrlzj --region us-central1 --project crossplaneprojects
argocd cluster add gke_crossplaneprojects_us-central1_samgke-jrlzj --name gke-dev
```
4. Check the ArgoCD UI to see the cluster registered and get the URL for the new cluster
5. Update the Go API template with the URL of the new GKE cluster in GitHub
6. Register this Go API template as a component from the Backstage UI using this URL: 
`https://github.com/samgabrail/backstage/blob/main/my-backstage-app/packages/backend/templates/go-api/template.yaml`

-- This marks the end of the Platform Engineer's job

#### Persona: Developer
7. Launch the Go API template from Backstage
8. Click on the new component to show that we're still waiting for it to be created
9. Check the ArgoCD Overview Widget in Backstage to see all is green
10. Click on the Name of the app in the widget for more info and see the destination K8s API server
11. Click on the App in Links to see it running
12. Check the Kubernetes Tab in Backstage
13. Make a change in the repo and push it to GitHub to watch ArgoCD sync and deploy the changes

-- This marks the end of the Developer's job

15. Show ArgoCD UI with the new API