#EKS Sandbox Environment for Personal AWS Account

*This repo contains Terraform configs and K8s yml files to get an EKS managed cluster AND a stateful Jenkins CI instance using AWS Elastic File Storage (NFS)*


## Getting EKS Configured

Used the following as a reference to get EKS cluster up and running:
https://aws.amazon.com/blogs/startups/from-zero-to-eks-with-terraform-and-helm/
**Just follow instructions up to the point where they start talking about Helm and SA creaetion**
This will get you up to getting a k8s cluster ready and kubectl configured correctly.


### After destroying and recreating EKS clusters
ALWAYS Run this command after destroying and recreating EKS cluster:

``terraform output kubeconfig>~/.kube/config``

**Need to get rid of the additional EOT characters at the beginning and end of the config file mentioned.  Otherwise,you're going to get an error.**

Once the config is successfully applied, use the following commands:

terraform output config_map_aws_auth > configmap.yml

vi configmap.yml and then delete the extra characters "<<EOT>>"  and then save and quit

 The ConfigMap is a Kubernetes configuration, in this case for granting access to our EKS cluster. This ConfigMap allows our ec2 instances in the cluster to communicate with the EKS master, as well as allowing our user account access to run commands against the cluster. You’ll run the Terraform output command to a file, and the kubectl apply command to apply that file:

Now you can run apply with the configmap.yml:

kubectl apply -f configmap.yml


Now you're ready to install stuff using Helm charts...

## Stateful Jenkins Instructions

*Jenkins with a PV mounting an EFS drive as a PersistentVolume so if the Jenkins pod gets restarted, we don't lose configuration information**

This is the link to the reference used:

https://aws.amazon.com/blogs/storage/deploying-jenkins-on-amazon-eks-with-amazon-efs


You will have already had all necessary resources deployed by running the terraform configuration, so you can Start at *Deploy the Amazon EFS CSI driver to your Amazon EKS clsuter*.

The aforementioned terraform config deploys the VPC, subnets, EKS cluster, SGs, EFS, mount targets, access point.  

**Note that we ran into trouble when deploying the cluster with the EFS as a PV because we did not have DNS resolution enabled (set to true) on the VPC. Redeploying the EKS cluster with the correct settings *should* resolve the issue**

**Depending on the Helm chart you go with (Bitnami or Jenkins original), you will need to reprovision the EFS clsuters with the correct mount path (e.g., /data/jenkins-volume vs. /jenkins) in the efs-file-system.tf file**

# Bitnami Jenkins Information


So was throwing an error when using the jenkins helm chart from stable..used bitnami's instead and mapped it to the efs-claim with the following command:

```
helm install bitnami-jenkins bitnami/jenkins --namespace jenkins --set rbac.create=true,master.servicePort=80,master.serviceType=LoadBalancer,persistence.existingClaim=efs-claim

```
NAME: bitnami-jenkins
LAST DEPLOYED: Mon Mar 15 09:17:38 2021
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
** Please be patient while the chart is being deployed **

1. Get the Jenkins URL by running:

** Please ensure an external IP is associated to the bitnami-jenkins service before proceeding **
** Watch the status using: kubectl get svc --namespace default -w bitnami-jenkins **

  export SERVICE_IP=$(kubectl get svc --namespace default bitnami-jenkins --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")
  echo "Jenkins URL: http://$SERVICE_IP/"

2. Login with the following credentials

  echo Username: user
  echo Password: $(kubectl get secret --namespace default bitnami-jenkins -o jsonpath="{.data.jenkins-password}" | base64 --decode)


  ## Jenkins Install from jenkins.io

  Reference: https://www.jenkins.io/doc/book/installing/kubernetes/#install-jenkins-with-helm-v3



