# Overview
This is an automated tutorial instructing hot to use Kubernetes to achieve horizontal auto-scaling. The technology stack heavily involves Ansible, Kubernetes, Docker etc. For simplicity, we will first use Minikube to demonstrate the power of Kubernetes on local machine.


# Minimum Requirement
For the best user experience, please prepare:
* Ubuntu (v16.04.2)
* Python2 / 3
* Git
* Ansible (v2.3.2)

# Ansible Roles
There are some packages that will be automatically installed, some with a fixed stable version.
* docker-ce (*for reference v17.06* )
* virtualbox (*for reference v5.1*)
* minikube (**fixed v0.24.1**)
* kubernetes (**fixed v1.8.5**)

# Command Line Tool
There is a `operate` provided to operate the Ansible playbook. Here is the example usage
```bash
>$./operate
Usage: ./operate {play|try} {playbook}

This always run on localhost
```
1. Execute a playbook
```bash
>$./operate play {playbook-file}
...
SUDO password: <enter-your-sudo-password>
```
2. Clean up a kubernetes cluster
```bash
./operate play shutdown-playbook.yml
...
SUDO password: <enter-your-sudo-password>
```
3. (Experimental) Dry-run a playbook
```bash
>$./operate try {playbook-file}
```
Run Ansible in Check-Mode will not make any changes to the target systems. Some modules that do not support check mode may take no action or return error (and simulation would stop).

# Example Summary
Here are some services that Kubernetes assists to scale horizontally to a predefined replication definition based on observed resource utilization.

| Service Name         | Container Repository | Resource Type    | Resource Threshold | Replication (From -> To)  |  Note    |
| ---------------------|:--------------------:|:----------------:| :----------------: | :------------------------:| :------: |
| Official PHP Apache  | Google Container Repo| CPU              | 50%                |  1 -> 2      |            |          |
| Apache (Httpd)       | Docker Hub Repository| CPU              | 50%                |  1 -> 2      |            |          |


## Official PHP Apache Server
This is the [official example](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/) to demonstrate Horizontal Pod Autoscaler. The example uses an PHP server image which performs some CPU intensive computations so that it is easier to reach our goal.
1. Start Official PHP Apache Playbook :
```bash
./operate play official-php-apache-autoscaler-playbook.yml`
```
After a few minutes, we will see Official PHP Apache service / pod launched as below ![](docs/img/apache_via_cpu/Before_Dashboard_One_Pod.png)

2. Start Official PHP Apache DDOS Playbook:
```bash
./operate play official-php-apache-ddos-playbook.yml
```
Within seconds, we will observe increase in CPU consumption. As a results, the deployment will resize to 2 replicas as predefined.
![](docs/img/apache_via_cpu/After_Dashboard_Two_Pods.png)

3. Stop the load by pressing `Ctrl-C`
After a short while, CPU utilization drops to 0. HPA auto-scaler removes one replica.
![](docs/img/apache_via_cpu/After_Back_To_One_Pod.png)

4. Grafana as Monitor Server
Grafana shows the resource trend as a observability tool.
![](docs/img/apache_via_cpu/Grafana_CPU_Spike.png)

## Apache Server
This example is (a lot) less CPU-intensive than to the 'Official PHP Apache' example, thus it may takes longer (minutes) for Kubernetes to trigger the pod replication. Further, this example leverages Docker Hub repository.
1. Start Apache Playbook :
```bash
./operate play httpd-autoscaler-playbook.yml
```
2. Start Apache DDOS Playbook:
```bash
./operate play httpd-ddos-playbook.yml
```
3. Stop the load by pressing `Ctrl-C`

# Troubleshooting Guide

## Minikube Troubleshooting

We should check minikube logs by
```bash
minikube logs
```
Here are some possible scenarios:

1.

## Pod Troubleshooting
We should check pod status by
```bash
kubectl describe pod <pod-name>
```

Here are some possible scenarios:

1.