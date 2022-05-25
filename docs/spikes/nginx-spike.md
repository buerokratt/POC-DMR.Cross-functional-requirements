# NGINX spike

This document captures the rough notes from a spike undertaken by Rainer Türner to showcase how NGINX can be used to do the routing required for DMR in the context of the overall Burokratt solution.

The spike was intended to address the following objectives

-  Work out mapping between ministry and bot forward URL
-  A demo on how the mapping table gets updated
- How DMR handles when classifier service is not available. Switch classifier off and ensure messages are not dropped. i.e, what happens when:
  1. Bot sends message to DMR
  2. DMR responds with 202
  3. DMR tries to send message to Classifier, but network is now failing / Classifier is not working
     Do we lose the message?

## Use different backends based on headers

https://sites.psu.edu/jasonheffner/2015/06/19/nginx-use-different-backend-based-on-http-header/

## Accept POST requests

By default, Nginx accepts GET requests. A quick hack to allow POST requests as well is as following:

```
server {
    # ...

    error_page  405     =200 $uri;

    # ...
}
```

## Load balancing

In case we have 5k participants and mapping them within 1 Nginx conf is not an option, load balancing comes to play. See https://docs.nginx.com/nginx/admin-guide/load-balancer/http-load-balancer/ for more.

## Down for maintenance

*"If one of the servers needs to be temporarily removed from the load‑balancing rotation, it can be marked with the [down](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#down) parameter in order to preserve the current hashing of client IP addresses. Requests that were to be processed by this server are automatically sent to the next server in the group:"*

```
upstream backend {
    server backend1.example.com;
    server backend2.example.com;
    server backend3.example.com down;
}
```

## Using server weights

*"By default, NGINX distributes requests among the servers in the group according to their weights using the Round Robin method. The [weight](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#weight) parameter to the [server](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server) directive sets the weight of a server; the default is 1."*

```
upstream backend {
    server backend1.example.com weight=5;
    server backend2.example.com;
    server 192.0.0.1 backup;
}
```

## Define a fallback server

- Report errors;
- Respond to participant that made the initial request.

https://serverfault.com/questions/765483/how-to-add-a-fallback-to-my-proxy-in-nginx

## Define `max_fails` and `fail_timeout` and a fallback

http://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream

```
upstream backend {
    server backend1.example.com weight=5;
    server 127.0.0.1:8080       max_fails=3 fail_timeout=30s;
    server unix:/tmp/backend3;

    server backup1.example.com  backup;
}
```

*"By default, requests are distributed between the servers using a weighted round-robin balancing method. In the above example, each 7 requests will be distributed as follows: 5 requests go to backend1.example.com and one request to each of the second and third servers. If an error occurs during communication with a server, the request will be passed to the next server, and so on until all of the functioning servers will be tried. If a successful response could not be obtained from any of the servers, the client will receive the result of the communication with the last server."*

## Transferring files from CentOps

1. Use `docker cp` command to transfer files from CentOps to DMRs. See https://docs.docker.com/engine/reference/commandline/cp/ for more.
2. Reload Nginx container with `docker exec <CONTAINER NAME> nginx -s reload` for changes to take effect.

## Benchmarks

Rainer (Guest) rainert@rainert-tuxedo:~$ ab -T application/json -H 'X-Server-Select: b' -c 1000 -n 1000 http://localhost:8081/redir/
 This is ApacheBench, Version 2.3 <$Revision: 1843412 $>
 Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
 Licensed to The Apache Software Foundation, http://www.apache.org/ Benchmarking localhost (be patient)
 Completed 100 requests
 Completed 200 requests
 Completed 300 requests
 Completed 400 requests
 Completed 500 requests
 Completed 600 requests
 Completed 700 requests
 Completed 800 requests
 Completed 900 requests
 Completed 1000 requests
 Finished 1000 requests 
 Server Software:     nginx/1.21.4
 Server Hostname:     localhost
 Server Port:       8081 Document Path:      /redir/
 Document Length:     37 bytes Concurrency Level:    1000
 Time taken for tests:  0.121 seconds
 Complete requests:    1000
 Failed requests:     0
 Total transferred:    268000 bytes
 HTML transferred:    37000 bytes
 Requests per second:   8239.06 [#/sec] (mean)
 Time per request:    121.373 [ms] (mean)
 Time per request:    0.121 [ms] (mean, across all concurrent requests)
 Transfer rate:      2156.32 [Kbytes/sec] received Connection Times (ms)
        min  mean[+/-sd] median  max
 Connect:     0  14  2.5   13    20
 Processing:   8  64  20.4   68    92
 Waiting:     1  64  20.4   68    92
 Total:     21  78  18.0   81   105 Percentage of the requests served within a certain time (ms)
  50%   81
  66%   88
  75%   94
  80%   95
  90%   98
  95%   100
  98%   102
  99%   103
  100%   105 (longest request)