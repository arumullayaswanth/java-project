# Jenkins Pipeline for Java based application using Maven, SonarQube, Argo CD, Helm and Kubernetes

![](https://user-images.githubusercontent.com/43399466/228301952-abc02ca2-9942-4a67-8293-f76647b6f9d8.png)

## 🔗 BLOG URL HERE: https://harshhaa.hashnode.dev/streamlining-cicd-workflow-with-github-jenkins-sonarqube-docker-argocd-and-gitops

Here are the step-by-step details to set up an **end-to-end Jenkins pipeline for a Java application using SonarQube, Argo CD, Helm, and Kubernetes:**

## ✅ Step 1: Clone the GitHub Repository

1. Open **VS Code**.
2. Open the terminal in VS Code.
3. Clone the project:

```bash
git clone https://github.com/arumullayaswanth/java-project.git
```

---

## 🔐 Step 2: Configure AWS Keys

Make sure you have your AWS credentials configured. Run:

```bash
aws configure
```

Enter your:
- Access Key ID
- Secret Access Key
- Region (like `us-east-1`)
- Output format (leave it as `json`)

---

## 📁 Step 3: Navigate into the Project

```bash
ls
cd java-project
ls
```

---

## ☁️ Step 4: Create S3 Buckets for Terraform State

These buckets will store `terraform.tfstate` files.

```bash
cd s3-buckets/
ls
terraform init
terraform plan
terraform apply -auto-approve
```

---

## 🌐 Step 5: Create Network 

1. Navigate to Terraform EC2 folder:

```bash
cd ../terraform
```

2. Run Terraform:

```bash
terraform init
terraform plan
terraform apply -auto-approve
```
3. example output :
```bash
Apply complete! Resources: 24 added, 0 changed, 0 destroyed.

Outputs:

jumphost_public_ip = "18.208.229.108"
region = "us-east-1"
```
4. The command terraform state list is used to list all resources tracked in your current Terraform state file.
```bash
terraform state list
```
output :
```bash
$ terraform state list
aws_iam_instance_profile.instance-profile
aws_iam_policy.eks_policy
aws_iam_role.iam-role
aws_iam_role_policy_attachment.cloudformation_full_access
aws_iam_role_policy_attachment.ec2_full_access
aws_iam_role_policy_attachment.eks_cluster_policy
aws_iam_role_policy_attachment.eks_policy_attachment
aws_iam_role_policy_attachment.eks_worker_node_policy
aws_iam_role_policy_attachment.iam-policy
aws_iam_role_policy_attachment.iam_full_access
aws_instance.ec2
aws_internet_gateway.igw
aws_route_table.private_rt
aws_route_table.rt
aws_route_table_association.private_rt_association1
aws_route_table_association.private_rt_association2
aws_route_table_association.rt-association
aws_route_table_association.rt-association2
aws_security_group.security-group
aws_subnet.private-subnet1
aws_subnet.private-subnet2
aws_subnet.public-subnet1
aws_subnet.public-subnet2
aws_vpc.vpc
```
---

## 💻 Step 6: Connect to EC2 and Access Jenkins

1. Go to **AWS Console** → **EC2**
2. Click your instance → Connect
3. Once connected, switch to root:

```bash
sudo -i
```

4. DevOps Tool Installation Check & Version Report

```bash
  [Git]="git --version"
  [Java]="java -version"
  [Jenkins]="jenkins --version"
  [Terraform]="terraform -version"
  [Maven]="mvn -v"
  [kubectl]="kubectl version --client --short"
  [eksctl]="eksctl version"
  [Helm]="helm version --short"
  [Docker]="docker --version"
  [Trivy]="trivy --version"
  [SonarQube]="docker ps | grep sonar"
  [Grafana]="kubectl get pods -A | grep grafana"
  [Prometheus]="kubectl get pods -A | grep prometheus"
  [AWS_CLI]="aws --version"
  [MariaDB]="mysql --version"
```

5. Get the initial Jenkins admin password:

```bash
cat /var/lib/jenkins/secrets/initialAdminPassword
```
- example output :
``` bash
0c39f23132004d508132ae3e0a7c70e4
```

Copy that password!

---

## 🌐 Step 7: Jenkins Setup in Browser

1. Open browser and go to:

```bash
http://<EC2 Public IP>:8080
```

2. Paste the password from last step.
3. Click **Install suggested plugins**
4. Create first user:

| Field     | Value       |
|-----------|-------------|
| Username  | yaswanth    |
| Password  | yaswanth    |
| Full Name | yaswanth    |
| Email     | yash@example.com |

Click through: **Save and Continue → Save and Finish → Start using Jenkins**

---

## 🔐 Step 8: it is a (Optional) 
## 🔐 Step 8: Add AWS Credentials in Jenkins

1. In Jenkins Dashboard → **Manage Jenkins**
2. Go to: **Credentials → System → Global Credentials (unrestricted)**
3. Click **Add Credentials**

### Add Access Key:
- Kind: Secret Text
- Secret: _your AWS Access Key_
- ID: `accesskey`
- Description: AWS Access Key

### Add Secret Key:
- Kind: Secret Text
- Secret: _your AWS Secret Key_
- ID: `secretkey`
- Description: AWS Secret Key

Click **Save** for both.

---


## 🔹 Step 9: Install Required Jenkins Plugins

1. Go to **Jenkins Dashboard** → **Manage Jenkins** → **Plugins**.
2. Click the **Available** tab.
3. Search and install the following:
   - ✅ **Pipeline: stage view**
   - ✅ **Eclipse Temurin installer**
   - ✅ **SonarQube Scanner**
   - ✅ **Maven Integration**
   - ✅ **NodeJS**
   - ✅ **Docker**
   - ✅ **Docker Commons**
   - ✅ **Docker pipeline**
   - ✅ **Docker API**
   - ✅ **Docker-build-step**
   - ✅ **Amazon ECR**
   - ✅ **Kubernetes Client API**
   - ✅ **Kubernetes**
   - ✅ **Kubernetes Cerdentials**
   - ✅ **Kubernetes CLI**
   - ✅ **Kubernetes Cerdentials Provider**
   - ✅ **Config File Provider**
   - ✅ **OWASP Dependency-check**
   - ✅ **Prometheus metrics**
   - ✅ **Slack Notification**
   - ✅ **Global Slack Notifier**
4. when installation is compete:
   - ✅ **Restart jenkins when installation is complete and no job are running**


---

## 🌐 Step 10: SonarQube Setup in Browser

1. Open browser and go to:

```bash
http://<EC2 Public IP>:9000
```
Log in with:
      - Username: `admin`
      - Password: `admin` (change after first login)
2. Update your password
  - **Old Password**: `admin`    
  - **New Password**: `yaswanth`
  - **Confirm Password**:`yaswanth`   
  - **update**

## 🧪 SonarQube & Jenkins Integration 
This guide will walk you through integrating **SonarQube** with **Jenkins** for static code analysis, from setting up the project in SonarQube to configuring Jenkins plugins and credentials.

## 🔹 Step 10.2: Generate a Token in SonarQube for Your Project

1. **Open the SonarQube Dashboard** in your browser  
   - Example: `http://localhost:9000` or your server's URL.

2. Navigate to: **Administration** → Under **Security** → click **Users**

3. click the **Tokens** down Icon button.

5. Click **Generate Token** and fill in:
   - **Token name**: `token`
   - **Expires in**: `No expiration`

5. Click **Generate** and **copy the token**.  
   ⚠️ **Important:** You will not be able to view this token again, so copy and save it securely.

6. Done – this token will be used in **Jenkins** for authentication with SonarQube.



## 🔹 Step 10.2: Add SonarQube Token as Jenkins Credential

1. Go to **Jenkins Dashboard** → **Manage Jenkins** → **Credentials**.
2. Click **System** → **Global credentials (unrestricted)**.
3. Click **Add Credentials**.
4. Fill in:
   - **Kind**: `Secret text`
   - **Secret**: *(paste your SonarQube token)*
   - **ID**: `sonarqube-token`
   - **Description**: `sonarqube-token`
5. Click **Create**.

## 🔹 Step 10.3: Configure SonarQube Server in Jenkins

1. Go to **Jenkins Dashboard** → **Manage Jenkins** → **System**.
2. Scroll down to the **SonarQube servers** section.
3. Click **Add SonarQube** and fill:
   - **Name**: `sonar-server`
   - **Server URL**: `http://localhost:9000` *(or your actual Sonar IP)*
   - **Server Authentication Token**: Select `sonarqube-token` (from credentials)
4. ✅ Check **Environment variables injection**.
5. Click **Save**.


## 🔹 Step 10.4: Configure Webhook in SonarQube

1. Go to **SonarQube Dashboard** → **Administration**
2. Under **Configuration**, click **Webhooks**
3. Click **Create**
4. Fill:
   - **Name**: `jenkins`
   - **Server URL**: `http://localhost:8080/sonarqube-webhook/` *(or your actual jenkins IP)*
5. Click **Create**

This allows SonarQube to notify Jenkins after analysis is complete.


## 🔹 Step 10.5: Configure Tools

1. Go to **Jenkins Dashboard** → **Manage Jenkins** → **Tool**.

2. Scroll to **JDK installations** section:
   - Click **Add JDK**
   - **Name**: `jdk`
   - ✅ Check **Install automatically**
     - Add Installer
       - select `install from adoptium.net`
          - version : `jdk-17.0.8.1+1

3. Scroll to **SonarQube Scanner installations** section:
   - Click **Add SonarQube Scanner**
   - **Name**: `sonar-scanner`
   - ✅ Check **Install automatically**
     - version : `SonarQube Scanner 7.0.1.4817` 
      - it is least version


5. Scroll to **Dependency-check installation** section:
   - Click **Add Dependency-check**
   - **Name**: `DP-check`
   - ✅ Check **Install automatically**
     - Add Installer
       - select `install from github.com`
          - version : `dependency-check-12.0.2`
             - it is least version

4. Click **Save**.
---

## 🔹 Step 11: 📧 Jenkins Slack Notification
- Send a Slack notification when the Jenkins pipeline successfully deploys to Kubernetes.

### **11.1 Create a Slack Incoming Webhook**

1. Go to your Slack workspace: [https://api.slack.com/apps](https://api.slack.com/apps)
2. Click **Create an App**
3. Choose **From Scratch**, name it something like `JenkinsNotifier`
4. Choose your **workspace** and click **Create App**
5. Under **"Incoming Webhooks"**, click **Activate Incoming Webhooks**
6. Click **“Add New Webhook to Workspace”**
7. Select the **channel** (e.g., `#devops` or `#alerts`) where you want to post
8. Click **Allow**
9. Copy the **Webhook URL** (e.g., `https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXXXXXXXXXXXXXX`)


---

### **🔑11.2: Add Bot Permissions (Scopes)**

1. In your app, go to **OAuth & Permissions**
2. Scroll to **“Bot Token Scopes”**
3. Click **“Add an OAuth Scope”** and add the following:

| Scope           | What It Does                            |
| --------------- | --------------------------------------- |
| `chat:write`    | Send messages to Slack channels         |
| `files:write`   | Upload files (like reports, logs, etc.) |
| `channels:read` | (Optional) To access channel info       |

✅ After adding scopes → **Click “Install App to Workspace”** at the top
➡️ Approve the permissions

---

### **🧪11.3: Get Your Bot Token**

After installing, you’ll see your **Bot User OAuth Token**:

```
xoxb-1234567890-abcdefg...
```

🔒 This is your **`SLACK_BOT_TOKEN`** — copy it and **do NOT share it** publicly.

---

### **🔐11.4: Store the Token in Jenkins Credentials**

1. Open **Jenkins**
2. Go to **Manage Jenkins > Credentials**
3. Choose **(global)** domain
4. Click **“Add Credentials”**
5. Fill in:

| Field       | Value                                       |
| ----------- | ------------------------------------------- |
| Kind        | `Secret text`                               |
| Secret      | Paste your `xoxb-...` bot token             |
| ID          | `SLACK_BOT_TOKEN`                           |
| Description | Slack bot token for file uploads (optional) |

Click **OK** ✅


### **11.5. Store the Webhook in Jenkins as a Secret**

> So you don’t hardcode it in your Jenkinsfile.

#### 🔐 Store it as a **secret environment variable**:

1. Go to your Jenkins dashboard
2. Click on **"Manage Jenkins"**
3. Click **"Manage Credentials"**
4. Select your credential **system** (e.g., `(global)`)
5. Click **"Add Credentials"**

* **Kind:** Secret text
* **Secret:** Paste the Slack Webhook URL
* **ID:** `SLACK_WEBHOOK_URL` (You must use this exact ID or change it in your Jenkinsfile)
* **Description:** `Slack Webhook for Jenkins Notifications`

---

### 🛠️ **11.6. Invite the Bot**

1. Open your Slack workspace.

2. Go to the `#devops-alert` channel.

3. In the message box, type:

   ```
   /invite @YourBotName
   ```

   Replace `@YourBotName` with the actual name of your app (e.g., `JenkinsNotifier`).

4. Hit Enter.


## ✅  Use Slack UI (Easiest)

1. **Open** the `#devops-alert` channel in your Slack app or browser.

2. Click the **channel name at the top** to open details.

3. Select **“More” > “Copy channel ID”**
   OR
   Look at your browser’s URL:

   ```
   https://app.slack.com/client/T012ABCDEF/C01234567
                                       ↑ this is the channel ID
   ```

---

## 🛠️ Step 12: Create a Jenkins Pipeline Job (Create EKS Cluster)

1. Go to Jenkins Dashboard
2. Click **New Item**
3. Name it: `eks-terraform`
4. Select: **Pipeline**
5. Click **OK**
 - Pipeline:
   - Definition : `Pipeline script from SCM`
   - SCM : `Git`
   - Repositories : `https://github.com/arumullayaswanth/java-project.git`
   - Branches to build : `*/master`
   - Script Path : `eks-terraform/eks-jenkinsfile`
   - Apply
   - Save
6. click **Build with Parameters**
   - ACTION :
    - Select Terraform action : `apply`
    - **Build** 

- To verify your EKS cluster, connect to your EC2 jumphost server ands run:
```bash
aws eks --region us-east-1 update-kubeconfig --name project-eks
kubectl get nodes
```
---

## 🛠️ Step 13: Create a Jenkins Pipeline Job (Create Elastic Container Registry (ecr))

1. Go to Jenkins Dashboard
2. Click **New Item**
3. Name it: `ecr-terraform`
4. Select: **Pipeline**
5. Click **OK**
 - Pipeline:
   - Definition : `Pipeline script from SCM`
   - SCM : `Git`
   - Repositories : `https://github.com/arumullayaswanth/java-project.git`
   - Branches to build : `*/master`
   - Script Path : `ecr-terraform/ecr-jenkinfine`
   - Apply
   - Save
6. click **Build with Parameters**
   - ACTION :
    - Select Terraform action : `apply`
    - **Build** 

7. To verify your EKS cluster, connect to your EC2 jumphost server and run:
```bash
aws ecr describe-repositories --region us-east-1
```

8. ✅ Verify Amazon ECR Repositories in AWS Console (us-east-1)
This guide shows how to verify if your ECR repositories exist using the AWS Console UI.

#### 🔹 manual process 

**Amazon ECR → Private registry → Repositories**

#### 🛠 Prerequisites

- AWS Console access
- IAM permissions to view Amazon ECR
- Repositories to verify:
  - `javaapp`

#### 📘 Step-by-Step Instructions

##### 1. Log in to AWS Console  
🔗 [https://us-east-1.console.aws.amazon.com/](https://us-east-1.console.aws.amazon.com/)

##### 2. Go to Elastic Container Registry  
- In the top search bar, type: `ECR`
- Click on **Elastic Container Registry**

##### 3. Navigate to Repositories  
- In the left sidebar, click:  
  **Private registry → Repositories**  
- Or go directly here:  
  🔗 [https://us-east-1.console.aws.amazon.com/ecr/repositories](https://us-east-1.console.aws.amazon.com/ecr/repositories)

##### 4. Verify Repositories  
- Use the search bar to search each repository name:

---
## Step 14: Create a Jenkins Pipeline Job for Build and Push Docker Images to ECR

### 🔐 Step 12.1: Add GitHub PAT to Jenkins Credentials

1. Navigate to **Jenkins Dashboard** → **Manage Jenkins** → **Credentials** → **(global)** → **Global credentials (unrestricted)**.
2. Click **“Add Credentials”**.
3. In the form:
   - **Kind**: `Secret text`
   - **Secret**: `ghp_HKMTPOmxnnl5d1f73zh`
   - **ID**: `my-git-pattoken`
   - **Description**: `git credentials`
4. Click **“OK”** to save.

### 🚀 Step 12.2: ⚖️ Jenkins Pipeline Setup: Build frontend images and Push and update Docker Images to ECR

1. Go to Jenkins Dashboard
2. Click **New Item**
3. Name it: `javaapp`
4. Select: **Pipeline**
5. Click **OK**
 - Pipeline:
   - Definition : `Pipeline script from SCM`
   - SCM : `Git`
   - Repositories : `https://github.com/arumullayaswanth/java-project.git`
   - Branches to build : `*/master`
   - Script Path : `jenkinsfiles/JenkinsFile`
   - Apply
   - Save
6. click **Build**


## 🖥️ step 13 : 🎉 Install ArgoCD in Jumphost EC2

### 13.1: Create Namespace for ArgoCD

```bash
kubectl create namespace argocd
```

### 13.2: Install ArgoCD in the Created Namespace

```bash
kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

### 13.3: Verify the Installation

```bash
kubectl get pods -n argocd
```

Ensure all pods are in `Running` state.

### 13.4: Validate the Cluster

Check your nodes and create a test pod if necessary:

```bash
kubectl get nodes
```

### 13.5: List All ArgoCD Resources

```bash
kubectl get all -n argocd
```

Sample output:

```
NAME                                                    READY   STATUS    RESTARTS   AGE
pod/argocd-application-controller-0                     1/1     Running   0          106m
pod/argocd-applicationset-controller-787bfd9669-4mxq6   1/1     Running   0          106m
pod/argocd-dex-server-bb76f899c-slg7k                   1/1     Running   0          106m
pod/argocd-notifications-controller-5557f7bb5b-84cjr    1/1     Running   0          106m
pod/argocd-redis-b5d6bf5f5-482qq                        1/1     Running   0          106m
pod/argocd-repo-server-56998dcf9c-c75wk                 1/1     Running   0          106m
pod/argocd-server-5985b6cf6f-zzgx8                      1/1     Running   0          106m
```
### 14.6: 🚀 Expose ArgoCD Server Using LoadBalancer

### 14.6.1: Edit the ArgoCD Server Service

```bash
kubectl edit svc argocd-server -n argocd
```

### 14.6.2: Change the Service Type

Find this line:

```yaml
type: ClusterIP
```

Change it to:

```yaml
type: LoadBalancer
```

Save and exit (`:wq` for `vi`).

### 14.6.3: Get the External Load Balancer DNS

```bash
kubectl get svc argocd-server -n argocd
```

Sample output:

```bash
NAME            TYPE           CLUSTER-IP     EXTERNAL-IP                           PORT(S)                          AGE
argocd-server   LoadBalancer   172.20.1.100   a1b2c3d4e5f6.elb.amazonaws.com        80:31234/TCP,443:31356/TCP       2m
```

### 14.6.4: Access the ArgoCD UI

Use the DNS:

```bash
https://<EXTERNAL-IP>.amazonaws.com
```

---

### 14.7: 🔐 Get the Initial ArgoCD Admin Password

```bash
kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath="{.data.password}" | base64 -d && echo
```

### Login Details:

* **Username:** `admin`
* **Password:** (The output of the above command)

---

## Step 15:  Deploying with ArgoCD and Configuring Route 53 (Step-by-Step)

### Step 15.1: Create Namespace in EKS (from Jumphost EC2)
Run these commands on your jumphost EC2 server:
```bash
kubectl create namespace dev
kubectl get namespaces
```

### Step 15.2: Create New Applicatio with ArgoCD
1. Open the **ArgoCD UI** in your browser.
2. Click **+ NEW APP**.
3. Fill in the following:
   - **Application Name:** `project`
   - **Project Name:** `default`
   - **Sync Policy:** `Automatic`
   - **Repository URL:** `https://github.com/arumullayaswanth/java-project.git`
   - **Revision:** `HEAD`
   - **Path:** `kubernetes-files`
   - **Cluster URL:** `https://kubernetes.default.svc`
   - **Namespace:** `dev`
4. Click **Create**.









https://medium.com/@yaswanth.arumulla/kubernetes-monitoring-for-everyone-step-by-step-with-prometheus-grafana-b8582f0cf808