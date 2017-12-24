This project ships two MirageOS unikernels to keep track of my server which has a dynamic IP.

The sender just opens and close a connexion to an other server with a fixed IP which has the receiver unikernel running.
To compile the two unikernels (e.g. using the unix backend) simply execute in each directories:
```
$ mirage configure -t unix --net=socket
$ make
```

Enjoy :-)
