# Worked Example: Bilbao

## 1. Observe the problem

```bash
kubectl get pods
```

Output:

```
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-6b9f6b9d8c-xxxxx   0/1     Pending   0          45s
```

The pod is stuck in `Pending` — it can't be scheduled onto a node.

## 2. Investigate with `kubectl describe`

```bash
kubectl describe pod -l app=nginx
```

The Events section shows the scheduling failures:

```
Events:
  Type     Reason            Age   From               Message
  ----     ------            ----  ----               -------
  Warning  FailedScheduling  30s   default-scheduler  0/1 nodes are available: 1 node(s) didn't match Pod's node affinity/selector, 1 Insufficient memory.
```

Two problems are listed:
1. **Node selector mismatch** — no node has `disk=ssd`
2. **Insufficient memory** — the requested `2000Mi` exceeds what's available

Scrolling up in the describe output confirms both issues in the pod spec:

```
  nodeSelector:
    disk: ssd
  ...
  resources:
    requests:
      memory: 2000Mi
    limits:
      memory: 2000Mi
```

## 3. Fix the node selector

```bash
kubectl label node node1 disk=ssd
```

Output:

```
node/node1 labeled
```

## 4. Fix the memory request

```bash
kubectl edit deployment nginx-deployment
```

Change both `memory: 2000Mi` entries (under `limits` and `requests`) to `memory: 200Mi`.

Save and exit. The deployment controller will delete the old pod and create a new one with the updated spec.

## 5. Verify

```bash
kubectl get pods -w
```

Output:

```
NAME                                READY   STATUS   RESTARTS   AGE
nginx-deployment-<new-hash>-xxxxx   1/1     Running  0          10s
```

The pod is now `Running`.

## 6. Test the service

```bash
curl 10.43.216.196
```

You should see the default Nginx welcome page (contains "Welcome to nginx!").

## 7. Run the official check

```bash
sh /home/admin/agent/check.sh
```

Expected output:

```
OK
```

> **Key insight:** `kubectl describe pod` is the single most useful command for diagnosing why a pod isn't running. It surfaces scheduling failures (node selectors, taints, resource constraints), image pull errors, and CrashLoopBackOff reasons in a single view. When you see `Pending`, always start here.
