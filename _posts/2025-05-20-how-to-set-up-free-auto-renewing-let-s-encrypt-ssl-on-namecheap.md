---
layout: post
title: How to Set Up Free Auto-Renewing Let's Encrypt SSL on Namecheap
date: 2025-05-20 20:46 -0600
category: [tutorial]
tags: [namecheap, cpanel, acme.sh, ssh, ssl, cron, free, api]
image: /assets/img/https.png
---

**Let's Encrypt** provides free SSL certificates, but some shared hosting providers like Namecheap don't support it natively. The good news is, with a little command-line work and the `acme.sh` client, you can set up fully automated SSL issuance and renewal, including automatic deployment via the cPanel API.

---

## 📦 What You'll Need:
- A **Namecheap** account with a shared hosting plan which includes cPanel (it might work for other types of Namecheap hosting but I haven't tested it)
- Basic **command line** familiarity or at least the ability to follow instructions really well

---

## ✅ Step 1: Install `acme.sh`
1. Log into your Namecheap account and access the cPanel associated with your hosting plan, you can do this by going to your account **Dashboard**, selecting **Hosting List** on the left panel, then find the hosting plan you want to enable this for. On the right there is a down arrow that will show you a drop menu and select **Go to cPanel**.

2. Unless you've already done this, you will need to click **Manage Shell** in the **Exclusive for Namecheap Customers** section of your cPanel, and toggle **Enable SSH access** to the on position. Then navigate back to the cPanel tools, your **Terminal** should now be accessible under the **Advanced** section.

3. Open the terminal and type:

    ```bash
    curl https://get.acme.sh | sh
    ```

4. After installation, type:

    ```bash
    ls -a
    ```

    This will show the files, including hidden files, in your root directory, just verify that you can see **`.acme.sh`** present.

---

## ✅ Step 2: Set Let's Encrypt as the default certificate authority

```bash
acme.sh --set-default-ca --server letsencrypt
```

You should get a message back similar to this:
```bash
Changed default CA to: https://acme-v02.api.letsencrypt.org/directory
```

---

## ✅ Step 3: Issue the SSL Certificate

Issue a new certificate for your domain from your terminal:

```bash
acme.sh --issue -d example.com -d www.example.com -w /home/username/example.com
```

- Replace `example.com` with your actual domain and `username` with your cPanel username.
- If you are not sure of your username, you can check it under "General Information" on the cPanel dashboard.

This uses Webroot HTTP-01 challenge issuance and will issue your SSL certificates. You should receive a message indicating that a certification, certification key, intermediate CA certificate, and full chain certification have been created, along with their file locations.

## ✅ Step 4: Create a cPanel API Token

Back on your cPanel dashboard:

1. Go to **Security > Manage API Tokens**.
2. Click **Create**.
3. Give it a name like `acme-deploy_token`.
4. Make sure **The API Token will not expire** is selected.
5. Copy the token to a temporary notepad file or something- **it's only visible once**.

---

## ✅ Step 5: Configure API Credentials

Back in the **Terminal**, open your `acme.sh` configuration file:

```bash
nano ~/.acme.sh/account.conf
```

Add these lines:

```bash
ACCOUNT_EMAIL="your-email@example.com"
DEPLOY_CPANEL_USER="username"
DEPLOY_CPANEL_TOKEN="api-token"
```

- Note: Email is optional but recommended for expiry notifications.
- Replace the `username` with your username and `api-token` with the API token you pasted into a notepad earlier.

Save and exit (`CTRL + O`, `Enter`, then `CTRL + X` in Nano).

---

## ✅ Step 6: Deploy the SSL Certificate to cPanel

Once issued, deploy it using:

```bash
acme.sh --deploy -d example.com --deploy-hook cpanel_uapi
```

This command uses your stored API credentials to install the certificate into your cPanel account and also saves the hook so it runs automatically with future renewals.

---

## ✅ Step 7: Automatic Renewal with Cron Job

A cron job should have been created automatically by `acme.sh` on installation.

Just check existing cron jobs:

```bash
crontab -l
```

It should return something like this:

```bash
41 0 * * * "/home/yourusername/.acme.sh"/acme.sh --cron --home "/home/yourusername/.acme.sh" > /dev/null
```

- Replace `yourusername` with your hosting account username.
  
If you don't see that you should add that line, you can use this command to open the file and add it:

```bash
crontab -e
```

This will:
- Check daily for expiring certificates
- Renew them if within 30-days of expiry
- Auto-deploy to cPanel using your API token

---

## ✅ Step 8: Verification of configuration

In your **Terminal** type:

```bash
cat ~/.acme.sh/example.com_ecc/example.com.conf
```

- For this whole section always replace `example.com` with your website domain and `username` with your username.
- Also, make sure you add the _ecc as indicated after the domain.

Just check that you can see the following configuration items, don't worry about the rest:

```bash
Le_Domain='example.com'
Le_Alt='www.example.com'
Le_Webroot='/home/username/example.com'
Le_API='https://acme-v02.api.letsencrypt.org/directory'
Le_DeployHook='cpanel_uapi'
```

If not, you should add/update those using nano, as usual replacing `example.com` with your domain:

```bash
nano ~/.acme.sh/example.com_ecc/example.com.conf
```

Save and exit (`CTRL + O`, `Enter`, then `CTRL + X` in Nano).

---

If you've verified the config, you're done! Now you have free, auto-renewing and auto-installing SSL certificates set up with one of the cheapest shared hosting plans on the web.

If you run into any problems using this tutorial, please email me. While I might not be able to troubleshoot for everyone, I will try to update the tutorial if there were any oversights.

Thanks for visiting- and congrats on saving some money on web hosting!

---