# OpenShift + Ansible = :heart:

## Requirements

To run this project, you'll need at least:

- python 3.6 (should probably also work with python 2.7)
- Docker
- `oc`: the [OKD client](https://www.okd.io/download.html)

## Installation

Start by cloning this repository:

```
$ git clone git@github.com:jmaupetit/openshift-ansible-demo.git
```

And then install python requirements in a virtual environment:

```bash
$ cd openshift-ansible-demo

# Create a python virtual environment
$ python3 -m venv venv

# Activate the virtualenv you've created
$ source venv/bin/activate

# Install project dependencies
(venv) $ pip install -r requirements/deploy.txt
```

Optionally you may also want to install development dependencies to work on the
application itself:

```
(venv) $ pip install -r requirements/dev.txt
```

You are now ready to play with OpenShift and Ansible!

## Tutorial

### OpenShift

```bash
# (optional) Point to the latest oc release
alias oc="oc-3.10"

# Start local cluster
oc cluster up

# Create a new project for our apps
oc new-project yolo-apps

# Build our image with appropriate tags
DOCKER_IMAGE="yolocat:latest"
OPENSHIFT_DOCKER_REGISTRY="$(oc registry info)"
OPENSHIFT_PROJECT="yolo-apps"
OPENSHIFT_DOCKER_IMAGE="${OPENSHIFT_DOCKER_REGISTRY}/${OPENSHIFT_PROJECT}/${DOCKER_IMAGE}"

docker build -t "${DOCKER_IMAGE}" -t "${OPENSHIFT_DOCKER_IMAGE}" .

# Login to openshift's private docker registry
docker login -u developer -p "$(oc whoami -t)" "${OPENSHIFT_DOCKER_REGISTRY}"

# Push our docker image to the registry
docker push "${OPENSHIFT_DOCKER_IMAGE}"

# Create a Secret containing our API key
oc create -f openshift/secret.yml

# Create a DeploymentConfig...
oc create -f openshift/dc.yml

# ... and the related service
oc create -f openshift/svc.yml

# Now create a route to make our app live!
oc create -f openshift/route.yml
```

### Ansible

```bash
# Execute playbooks in ansible folder
(venv) $ cd ansible

# Set OpenShift environment
(venv) $ export K8S_AUTH_API_KEY="$(oc whoami -t)"
(venv) $ export K8S_AUTH_HOST=$(oc version | grep Server | awk '{print $2}')

# Start playing with OpenShift + Ansible
(venv) $ ansible-playbook deploy.yml

# Deploy another applications than the default one
(venv) $ ansible-playbook deploy.yml -e "app={{ unicorn_app }}"
(venv) $ ansible-playbook deploy.yml -e "app={{ dude_app }}"
```

## License

This work is released under the MIT License (see [LICENSE](./LICENSE)).
