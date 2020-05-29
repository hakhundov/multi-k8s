These are basically my notes:

TODO:
1. Run this project with Skaffold
2. there have been changes made to the ingress service, will that still work with the local version?



This is a repo created for an exercise for the Docker and Kubernetes: The Complete Guide course on udemy.
https://www.udemy.com/course/docker-and-kubernetes-the-complete-guide/


To run the application
minikube start
kubectl apply -f k8s
minikube ip

open browser, type in ip

## Section 16: Kubernetes Production Deployment
Lesson 254:
Create this git repo

Lesson 255:
Tie the repo with Travis CI https://travis-ci.org/
Sync account -> Find this repo -> Enable this repo

Lesson 257 -262:
Create a new Google cloud project
console.cloud.google.com
Compute -> Kubernetes engine
Create Cluster

Lesson 263:
Put together a deployment file .travis.yaml:

1. Install Google Cloud SDK CLI
    update kubectl

2. Configure the SDK with our Google Cloud auth info
    a. Create Service account on Google cloud
        IAM -> Service account -> Give Cluster rights
    b. Download service account credentials in a json file: service-account.json
    c. Dowload and install the Travis CI CLI to encrypt the json file and upload it to our Travis account.
        i. github.com/travis-ci/travis.rb //requires Ruby to be installed locally
        or
        ii. Use a docker image that has Ruby pre-installed
        docker run -it -v $(pwd):/app ruby:2.4 sh
        use it, and then throw it away

        gem install travis --no-rdoc --no-ri
        travis login (--com)
        travis encrypt-file service-account.json -r hakhundov/multi-k8s (--com)

    e. In travis.yaml, add code to unencrypt the json file and load it into GCloud SDK
        - add encrypted json file to the repo, *delete the orignal json file*!

3. Login to Docker CLI
     - echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
     - env variables must be set in travis

4. Build the 'test' version of multi-client and run tests

--Actual Deployment--

If tests are successful, run a script to deploy newest images
 deploy.sh

no built in deployment provider for google kubernetes
thats why making our own custom script deploy.sh
- Build all our images, tag each one, push each to docker hub
- Apply all configs in the 'k8s' folder
- Imperatively set latest images on each deployment







Create a secret pod:

multi-server needs the pgpassword to access postgress

kubectl create secret generic pgpassword --from-literal PGPASSWORD=****


**we need to setup on the remote kubernetes cluster as well!**

configure the google shell
- gcloud config set project multi-k8s-278612
  - gcloud config set compute/zone europe-west3-b
  - gcloud container clusters get-credentials multi-cluster

kubectl create secret generic pgpassword --from-literal PGPASSWORD=mypassword

Install Helm - administer 3rd party software inside the cluster

Install ingress-nginx
github.com/kubernetes/ingress-nginx

helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm install my-nginx stable/nginx-ingress --set rbac.create=true 




# Section 17: HTTPS Setup with Kubernetes

In this section we will setup HTTPS for this project using Let's Encrypt and cert-manager.
 
## LetsEncrypt

Let’s Encrypt is a free, global Certificate Authority (CA) that offers Domain Valdiation (DV) certificates in an automated way.
Certificates issued by this CA have a short validity of 90 days. Hence, automated renewals are typically done every 60 days. Shorter lietime encourages automation and limits damage from key compromise or mississuance.

Let's Encrypt uses the ACME (Automated Certificate Management Environment) protocol to verify that you have the control over a certain domain.
Client software can automate this entire process. The recommended client is Certbot. However, if needed, the certificates can be obtained manually as well, although could be a tedious process. In general, there are various types of clients:
1. simple - drop a cert in the current dir
2. full-featured - configure server for you
3. built-in - web server just does it. e.g. https://caddyserver.com/

There are various challenge types specified in the ACME protocol. For example: HTTP, where a file needs to be placed on the server, or DNS, where you provision a DNS record for your domain. The assumption is that if you have control over your DNS settings, you have control over the server.

We are using the HTTP-01 challenge in this project.

In a nutshell, this is how Let's Encrypt authenticates you:
client -------------------------- server
        --> request certificate for *domain*
        <-- challenge // TOKEN
        --> challenge completed // Set-up a specific route handler, sign the TOKEN
        <-- verify challenge comletion // Request to endpoint on *domain*/.well-known/acme-challenge/TOKEN
        <-- certificate or denial


Reference:

https://letsencrypt.org/
https://www.youtube.com/watch?v=ksqTu7TX83g


## Cert-Manager

cert-manager is a x509 certificate management for Kubernetes.



Use Helm, that would do that automatically all that.
automatically set a route handler
automatically set up a secret
automatically renews before expiration

Install Cert Manager using Helm
https://cert-manager.io/docs/installation/kubernetes/




after succesfully installing cert-manager, and configuring it with issuer.yaml and certificate.yaml
we can run

kubectl get certificates
print out all different objects of type certificate

kubectl describe certificates
print information about the object, log information 

kubectl get secrets
double check that a secret with tlscert is created with the name specified in certificate.yaml

chang nginc ingress to use https

cert-manager.io/cluster-issuer: "letsencrypt-prod"


Reference:

https://cert-manager.io/
