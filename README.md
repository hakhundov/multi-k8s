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

Build all our images, tag each one, push each to docker hub
Apply all configs in the 'k8s' folder
Imperatively set latest images on each deployment










Create a secret pod:

multi-server needs the pgpassword to access postgress

kubectl create secret generic pgpassword --from-literal PGPASSWORD=****


**we need to setup on the remote kubernetes cluster as well!**

configure the google shell
- gcloud config set project multi-k8s-278612
  - gcloud config set compute/zone europe-west3-b
  - gcloud container clusters get-credentials multi-cluster

kubectl create secret generic pgpassword --from-literal PGPASSWORD=mypassword

curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh


helm repo add stable https://kubernetes-charts.storage.googleapis.com/
helm install my-nginx stable/nginx-ingress --set rbac.create=true 
