# Dev Container for Kubernetes

A concise guide for configuring a **Dev Container** with `kubectl` to manage a local or remote **Kubernetes / K3s cluster** directly from VS Code.

> **Note:** This setup was created and tested on an **ARM-based architecture** (e.g., Apple Silicon / Raspberry Pi).

---

### 1. Prepare the setup
1. Create a new project folder and open it in **VS Code**.  
2. Inside that folder, create a directory named `.devcontainer`.  
3. Within `.devcontainer`, create a file called `devcontainer.json`.

---

### 2. Add the configuration
Copy the following content into your `devcontainer.json` file:

```json
{
  "name": "K3s Dev",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "postCreateCommand": "curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl && curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl.sha256 && sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && mkdir -p ~/.kube && touch ~/.kube/config && chmod 600 ~/.kube/config"
}
```

---

### 3. Launch the Dev Container
Before running, make sure you have the **Dev Containers** extension from Microsoft installed.  

Click the blue `><` icon in the bottom-left corner of VS Code,  
then select **“Reopen in Dev Container”**.  

This will build and open your project inside a ready-to-use container environment.

![Opening Dev Container Demo](./helpers/demo.gif)

---

### 4. Retrieve your cluster configuration
On your control-plane node, run the following command to display your cluster configuration:

``` sudo cat /etc/rancher/k3s/k3s.yaml ```

The output should look like this:
![Example kubeconfig file](./helpers/cluster-info-example.png)
>parts of my cluster are covered for security purposes. you should not share it with other people.


Copy the entire output and save it temporarily to a text file.

---

### 5. Edit the kubeconfig inside the container
Inside the Dev Container, open the config file:
```bash
nano ~/.kube/config
```

Paste the content you copied earlier into this file.  

Locate the line that looks like this:
```
server: https://127.0.0.1:6443
```

Replace the IP address with the **actual IP of your control-plane node**.  
You can find it using:
```bash
ifconfig
```

---

### 6. Verify the setup
Run the following command to confirm that `kubectl` is connected to your cluster:
```bash
kubectl get nodes
```

If you see your cluster nodes listed — everything is configured correctly.
