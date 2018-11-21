# Kubernetes NGINX Ingress Controller Meets Logstalgia

Use https://logstalgia.io to display realtime logs streamed from all NGINX ingress controllers pods running within your Kubernetes cluster.

[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/HeWfkPeDQbY/0.jpg)](https://www.youtube.com/watch?v=HeWfkPeDQbY)

# Requirements

* A logstalgia binary that was built for your platform. The one part of this repo has been built on Mac OSX.

  The following packages were required on my laptop (OSX):
```bash
 brew install glew glm sdl2 SDL2_image boost
```
* [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl) commandline tool;
* Valid `KUBECONFIG` that points to an account that can watch logs from the NGINX ingress controller pods. That may require some `RBAC` adjustments. Check the Roles/RoleBindings of the service account that the `KUBECONFIG` context is linked to;
* Change files permissions:
 ```bash
 chmod +x formater.rb logstalgia run.sh
 ```

# Files and Scripts

* `formater.rb`: parses NGINX ingress controller's logs and pipe then to `logstalgia`;
* `logstalgia`: binary that will receive all the parsed logs and display them in the graphical application;
* `run.sh`: script that will initiate the streaming of the NGINX logs from the remote pods to the local filesystem. In addition it will tail all received logs to the following pipe flow:

  ```bash
  tail -f ingress-*.log | ./formater.rb | ./logstalgia -
  ```

# Execute

```bash
# start the streaming of the logs and pipe them to logstalgia
# the argument is basically any string to be used by grep on every log line.
./run.sh "\[app-svc]" #optional
```

The log line below will be passed to `logstalgia` because the string `[app-svc]` is present. Lines that don't match the pattern will not be passed to `logstalgia`, consequently not displayed in the graphical mode.

```
176.108.233.253 - [176.108.233.253] - - [21/Nov/2018:20:39:37 +0000] "POST /api/v1/products HTTP/1.1" 200 165 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36" 2545 0.027 [app-svc-9001] 100.124.223.145:7001 165 0.028 422```
