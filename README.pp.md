
## Tasks

### I. Up & Running

#### task 1

I added an alias to run the app locally with a more specific host name.
It's handy when it comes to saving the user/password of the local user.

For it to work, I added an alias in the `host` /etc/hosts file:

```
$ sudo -- sh -c 'echo 127.0.0.1 jenkins.localhost >> /etc/hosts'
```

and an alias for the default network in the `jenkins` service.

```
git diff HEAD~                                        
diff --git a/docker-compose.yml b/docker-compose.yml                                                 
index 200e12e..44c34b7 100644                                                                        
--- a/docker-compose.yml                                                                             
+++ b/docker-compose.yml                                                                             
@@ -4,6 +4,10 @@ services:                                                                           
         image: jenkins/jenkins:lts                                                                  
         ports:                                                                                      
             - '127.0.0.1:8080:8080'                                                                 
+        networks:                                                                                   
+            default:                                                                                
+                aliases:                                                                            
+                    - jenkins.localhost                                                             
     db:                                                                                             
         image: mysql:5.7                                                                            
         environment:                                                                                
@@ -11,3 +15,6 @@ services:                                                                          
         ports:                                                                                      
             - '127.0.0.1:3306:3306'                                                                 
                                                                                                     
+networks:                                                                                           
+    default:                                                                                        
+                                                      
```

Added a `named` volume to persist the changes to the data.

A handy way to run a manual backup of the data:

```
$ docker run --rm --volumes-from  dev-automation-test_jenkins_1_41f12198fbcd -v $(pwd):/backup ubuntu tar cvf  /backup/backup.tar /var/jenkins_home
```

#### task 2

Changed to `jenkins/jenkins:lts-alpine` docker image. This one has a smaller size, plus I found an example
of how to install python 3 that was using it :-)

https://github.com/manycoding/jenkins-python/blob/master/Dockerfile

Found a good tutorial, for newbies :-), on how to remove docker images and containers:

https://www.digitalocean.com/community/tutorials/how-to-remove-docker-images-containers-and-volumes

