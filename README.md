<h2>Cloud-Native 微服務架構：Terraform + GKE + Ansible + GitHub Actions</h2>
<h3>本專案以 IaC（Infrastructure as Code） 與 Kubernetes 為核心，組成一個能自動化建置、部署、擴展的現代化微服務平台</h3>

<strong>1. 基礎建設層（Infrastructure Layer）— Terraform + Google Cloud</strong>
<p>使用 Terraform 自動化建立雲端基礎設施，包含：</p>
<ul>
   <li style="padding-left: 40px">GKE Autopilot Cluster（自動節點管理、自動彈性伸縮)</li>
   <li>Artifact Registry（部署用的私有容器映像倉庫)</li>
   <li>IAM 權限、地區設定、Cluster 連線端點等</li>
</ul>
<a href="tf-gke-autopilot/main.tf">Terraform配置檔</a>
<br>
<br>
<p>
    配置的指令<br>
    terraform init<br>
    terraform apply
</p>
<hr>
<strong>2. CI/CD Pipeline — GitHub Actions</strong>
<p>採用 GitHub Actions 建立全自動部署流程：</p>
<ul>
<li>Build：自動建置 client / server / worker Docker image</li>
<li>Push：將 image 推送至 Artifact Registry（tag=GITHUB_SHA)</li>
<li>Auth：使用 GCP SA（Service Account）登入 Google Cloud</li>
<li>push/pull image 到 Artifact Registry</li>
<li>取得 github 上的 secret variables</li>
<li>Generate Kubeconfig：透過 gcloud 自動取得 GKE 憑證</li>
<li>Deploy：執行 Ansible Playbook 中的任務</li>
</ul>
<a href=".github/workflows/deploy.yaml">GitHub Actions配置檔</a>
<hr>
<strong>3. 部屬的服務介紹</strong>
<p>服務構成：</p>
<strong>Client（React + Nginx)</strong>
<ul>
   <li>靜態前端網頁</li>
   <li>透過 / 路徑由 Ingress 對外提供</li>
</ul>
<strong>Server（Node.js Express API)</strong>
<ul>
   <li>管理 Fibonacci 任務</li>
   <li>串接 Redis（即時計算）</li>
   <li>串接 Postgres（歷史輸入資料）</li>
</ul>
<strong>Worker（背景計算服務）</strong>
<ul>
   <li>透過 Redis Pub/Sub 接受任務任務</li>
   <li>執行 Fibonacci 計算</li>
   <li>將結果寫回 Redis</li>
</ul>
<strong>Redis</strong>
<ul>
   <li>作為 caching 與任務 queue</li>
   <li>Server/Worker 都會使用</li>
</ul>
<strong>Postgres</strong>
<ul>
   <li>永久儲存使用者輸入</li>
   <li>使用 PVC（PersistentVolumeClaim）避免 pod 重啟資料遺失</li>
</ul>
<strong>Ingress (Nginx)</strong>
<ul>
   <li>/ → client</li>
   <li>/api → server</li>
   <li>Kubernetes LoadBalancer 對外曝光 IP</li>
</ul>
<a href="client">client Dockerfile</a>
<br>
<a href="server">server Dockerfile</a>
<br>
<a href="worker">worker Dockerfile</a>
<hr>
<strong>4. Kubernetes 物件（Deployment / Service / Ingress / PVC）統一由 Ansible 管理</strong>
<p>Terraform 建置 cluster，但 Kubernetes 物件（Deployment / Service / Ingress / PVC）統一由 Ansible 管理</p>
<p>Ansible 在 CI/CD pipeline 中負責</p>
<ul>
   <li> 建立Namespace</li>
   <li>建立 Secrets（如 PG 密碼</li>
   <li>部署 Postgres + PVC</li>
   <li>部署 Redis</li>
   <li>部署 Server / Worker / Client</li>
   <li>建立 Nginx Ingress</li>
   <li>滾動更新 Deployment 到最新 image</li>
</ul>
<a href="ansible/deploy-all.yaml">Ansible配置檔(all)</a>
<br>
<a href="ansible/tasks">Ansible配置檔(independent task)</a>
<hr>
<strong>部署完驗證</strong>
<p>kubectl get deployment -n  multi-app</p>
<p>看部屬服務狀況</p>
<img src=""></img>
