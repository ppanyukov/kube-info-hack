# Kubernetes Info Hacky Hack

This is the kind of app which could be useful for DevOps/SRE people
that need to monitor the Kubernetes cluster. The key here is that
the app runs within the cluster itself (well where else would you
run it?). Here is a demo how it can be done.

Purpose: 

- Get information about the running Kubernetes cluster: deployments, running pods etc.

- Deploy this app within the cluster itself.


Main ideas:

- Use Kubernetes client API: https://github.com/kubernetes/client-go

- Authentication for our app to be able to talk to the cluster. See further on this.

Minikube:

- This app uses minikube and it's docker engine. See https://kubernetes.io/docs/setup/learning-environment/minikube/

- This allows us to test this without the need to images to any external repos. See https://kubernetes.io/docs/setup/learning-environment/minikube/#use-local-images-by-re-using-the-docker-daemon 


Building and running:

- Requirements:
    - Docker
    - Minikube (tested with v1.15.2)
    - Kubectl
    - Bash (hopefully also works on Windows but not tested)
    - No need for local installation of `go` toolchain

- Build and run:

    ```
    # build the binaries
    USE_DOCKER=yes ./build.sh

    # Build image and deploy
    ./deploy-minikube.sh
    ```

- Checking the results:

    The `./deploy-minikube.sh` should give the instructions, but generally get the logs from the running deployed pod to see output.


Dependencies:

- Using `go-dep` at the mo, see https://github.com/golang/dep. In general nothing extra needs to be done to build and run the app, all dependencies are with the source code.

- Might consider moving to modules, seems like everyone is doing that.


Kubernetes RBAC:

- A challenge for an app like this is the authorisation required to talk to Kubernetes cluster to get anything from it.

- By default any running app has zero permissions to do so.

- I have overcome this by:

    - Create `ServiceAccount` object.
    - Create `Role` with required permissions.
    - Create `RoleBinding` to assign the the `Role` to the `ServiceAccount`
    - Create `Deployment` and assign `ServiceAccount` to it in the spec.

- For details see `deploy-minikube.yaml`, everything is there.

- For further docs etc see:
    - RBAC: https://kubernetes.io/docs/reference/access-authn-authz/rbac/

    - Service accounts: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/





