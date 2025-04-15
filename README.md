# HomeLab - Getting Started

I began this HomeLab as a way to deepen my computer networking knowledge. In order to get something interesting, and substantial I ended up going with Kubernetes - initially the k3s distribution as I'd heard that this is excellent for learning the fundamentals.

## Whilst I wait... for hardware.

While I wait for some hardware to arrive my current setup involves a two VM's which run on my Macbook Pro M1: specifically, 2 x Ubuntu 24.042 LTS.

### Initial steps

1. `ssh` into your VM (Ubuntu) nodes.
2. Run `curl -sfL https://get.k3s.io | sh -` on my 'Master' node or 'Server' VM.
3. Config is located at `/etc/rancher/k3s/k3s.yaml`

   1. Copy this configuration to your home folder (do this): `
sudo mkdir ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config.yaml
chown $USER:$USER ~/.kube/config.yaml
chmod 600 ~/.kube/config.yaml`

4. Run this on the master: `export K3S_TOKEN=$(ssh user@$SERVER_IP "sudo -S cat /var/lib/rancher/k3s/server/node-token")` - this will set the cluster token.
5. Head over to your Agent and run: `curl -sfL https://get.k3s.io | sh -s - server --server https://$SERVER_IP:6443 --token $K3S_TOKEN` - make sure that you use the same token as from the previous step.
   1. I had some issues with the above - which were resolved with ```curl -sfL https://get.k3s.io | K3S_URL=https://192.168.4.133:6443 K3S_TOKEN=K101137bd30acadb4716151c9e0327a3f92a7b7f04da5f537538e85d23267ce7514::server:41ccbe9f469920db798fb75f6ebe9229 sh -

```
6. I ended up copying the master node configuration over so that I can run kubectl commands on the Agent / Worker. So from the Master run the following: `scp ~/.kube/config.yaml user@agent-ip:~/.kube/config.yaml`
7. In the Server and the Agent you'll need to make sure kubectl knows which config you're using, so do this: `export KUBECONFIG=~/.kube/config.yaml` - now you'll be able to run kubectl commands.

### Flux Setup

1. Head over to your github developer settings and add a new key / token, make sure you copy it.
2. Run the following to install Flux on your cluster:

```

# Install flux first

curl -s https://fluxcd.io/install.sh | sudo bash
export GITHUB_TOKEN=$TOKEN

```

```

flux bootstrap github --owner=$GITHUB_USER --repository=repo-name --branch=main --path=clusters/your-cluster --personal

```

Now you should be able to add manifests inside of your-cluster push it up and flux will take care of the rest.

### Apps

I have an app folder within the relevant namespace. As an exercise I've created a simple blog - using a slightly adjusted nextjs starter.

My thinking is that I should be able to:

- push my application code up to github
- github actions automatically builds this docker container and places it within the GHCR - Which is Github Container Registry
- Flux automatically recognises this new build and then applies it to my HomeLab
- Flux will automatically update the image version inside of the deployment file.

#### Things to note

When adding apps to the GHCR built images need to follow this convention:

- ghcr.io/github-user-name/name-of-container:version

#### Ensure automation after image build

1. Ensure you install the following components `flux install --components-extra=image-reflector-controller,image-automation-controller`
2. Ensure that you've configured GitHub Registry Authentication:
```

kubectl create secret docker-registry ghcr-credentials \
 --namespace=web \
 --docker-server=ghcr.io \
 --docker-username=$GITHUB_USERNAME \
   --docker-password=$GITHUB_TOKEN

````
3. For each image that will be updated you'll need to create the following manifests: ImageRepository, ImagePolicy and ImageUpdateAutomation - see personal-blog-image-automation.yaml as an example.
4. If you're having issues with the image controllers here are some useful commands: ```
kubectl get deployments -n flux-system # this will show you whether relevant components are installed.
kubectl get crds | grep image.toolkit.fluxcd.io # this are required.

````

5. I encountered an issue with the architecture. As I'm using ARM64, buildx which is used within Github Actions needs to perform a multiplatform build (or at least ARM64). Refer to the Github Actions section see `with: platforms: linux/arm64, linux/amd64`

6. More commands that I found useful:

```
kubectl get secrets -n namespace # confirms if you've saved the secret or not
kubectl logs pod-name -n namespace # an logs from your bod
kubectl describe pod pod-name -n namespace # additional pod information
sudo journalctl -u k3s -f # good for checking logs on server





```

7. Uninstall notes:

```
sudo /usr/local/bin/k3s-uninstall.sh # will uninstall server


```

### Scripts

I created some scripts with the help of AI to run uninstalls of my cluster and reinstall as needed, due to my ongoing learning and mistakes. Scripts are located in the scripts folder at the root of the repo.

I found the best most reliable way to execute these programs was to do the following:

```
scp uninstall-k3s.sh lewi0231@192.168.0.76:/tmp/script.sh # copy to the remote server or agent
ssh -tt lewi0231@192.168.0.76 'bash /tmp/script.sh' # run it interactively
```
