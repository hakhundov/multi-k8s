docker build -t hakhundov/multi-client:latest -t hakhundov/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t hakhundov/multi-server:latest -t hakhundov/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t hakhundov/multi-worker:latest -t hakhundov/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push hakhundov/multi-client:latest
docker push hakhundov/multi-server:latest
docker push hakhundov/multi-worker:latest

docker push hakhundov/multi-client:$SHA
docker push hakhundov/multi-server:$SHA
docker push hakhundov/multi-worker:$SHA

kubectl apply -f k8s

kubectl set image deployments/client-deployment client=hakhundov/multi-client:$SHA
kubectl set image deployments/server-deployment server=hakhundov/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=hakhundov/multi-worker:$SHA