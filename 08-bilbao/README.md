Scenario: "Bilbao": Basic Kubernetes Problems

Level: Easy

Type: Fix

Tags: kubernetes  

Access: Email

Description: There's a Kubernetes Deployment with an Nginx pod and a Load Balancer declared in the manifest.yml file. The pod is not coming up. Fix it so that you can access the Nginx container through the Load Balancer.

There's no "sudo" (root) access.

Root (sudo) Access: False

Test: Running curl 10.43.216.196 returns the default Nginx Welcome page.

See /home/admin/agent/check.sh for the test that "Check My Solution" runs.

Time to Solve: 10 minutes.
