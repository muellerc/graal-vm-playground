# 1. GraalVM Native Image examples

If you are going to build the Native Image on your local machine for you OS, follow the steps outlined under 1.1. You need to have GraalVM and the Native Image tool installed locally. 

If you are going to build the Native Image in a dockerized way for a different OS (Amazon Linux 2 in this case), follow the steps outlined under 1.2. You need to have Docker installed locally. 

## 1.1. Build the GraalVM Native Image locally

### 1.1.1 GraalVM Native Image "Hello World" example

In the project root directory, run the following command to build the entire project using Maven:

```bash
./mvnw clean package
```

After a successful build, you should see an output like this:
```commandline
...
[INFO] hello-world ........................................ SUCCESS [  2.237 s]
[INFO] hello-world-complex ................................ SUCCESS [  0.513 s]
[INFO] graal-vm-playground ................................ SUCCESS [  0.001 s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  2.866 s
```

Now let's build the native image called App, by running:
```commandline
native-image --no-fallback -jar hello-world/target/hello-world.jar hello-world/target/App
```

Your output should look like:
```commandline
[App:53714]    classlist:   1,146.37 ms,  0.96 GB
[App:53714]        (cap):   7,848.30 ms,  0.96 GB
[App:53714]        setup:  13,895.06 ms,  0.96 GB
[App:53714]     (clinit):     206.35 ms,  1.74 GB
[App:53714]   (typeflow):   3,526.75 ms,  1.74 GB
[App:53714]    (objects):   3,714.84 ms,  1.74 GB
[App:53714]   (features):     327.48 ms,  1.74 GB
[App:53714]     analysis:   8,038.32 ms,  1.74 GB
[App:53714]     universe:     667.41 ms,  1.74 GB
[App:53714]      (parse):   1,129.04 ms,  1.77 GB
[App:53714]     (inline):   1,643.00 ms,  2.35 GB
[App:53714]    (compile):   8,988.06 ms,  3.26 GB
[App:53714]      compile:  12,493.03 ms,  3.26 GB
[App:53714]        image:   1,816.87 ms,  3.26 GB
[App:53714]        write:     383.89 ms,  3.26 GB
[App:53714]      [total]:  38,645.05 ms,  3.26 GB
# Printing build artifacts to: /Users/cmr/workspaceGraalVM/graal-vm-playground/hello-world/target/App.build_artifacts.txt
```

After this is done, let's check the size of these artefacts:
```commandline
ls -lh ./hello-world/target/hello-world.jar
```

Our JAR file is about 3 kB, but it requires at least a JRE of several then's to one hundred MB to run:
```commandline
-rw-r--r--  1 cmr  1896053708   3.0K Aug 17 10:49 ./hello-world/target/hello-world.jar
```

Let's check our native image as well:
```commandline
ls -lh ./hello-world/target/App
```

With 11 MB, it's much bigger but doesn't need a JRE or JDK to be executed:
```commandline
-rwxr-xr-x  1 cmr  1896053708    11M Aug 17 22:50 ./hello-world/target/App
```

Let's execute the hello-world example to see, how long it takes to run:  
```commandline
time java -jar ./hello-world/target/hello-world.jar
```

You should see an output similar to the following one (formatted for easier readability), which shows that it takes about 91ms to run it:
```commandline
0.08s user 
0.03s system 
123% cpu 
0.091 total
```

Let's run our native image:
```commandline
time ./hello-world/target/App
```

Our native images executes in only 10ms and consumes less CPU than our Java application:
```commandline
0.00s user 
0.00s system 
70% cpu 
0.010 total
```

### 1.1.2 GraalVM Native Image "Hello World Complex" example

In this example, we are querying some weather data from `https://api.weather.gov`, convert the received JSON data string with Jackson into a JsonNode and then print it out as string.

> NOTE: You can skip the next command, if you already execute it in 1.2.1.

```commandline
./mvnw clean package
```

Now let's build the native image called App, by running:
```commandline
native-image --no-fallback --enable-url-protocols=https -jar hello-world-complex/target/hello-world-complex.jar hello-world-complex/target/App
```

First, let's compare the artefact sizes again, starting with the JAR file:
```commandline
ls -lh ./hello-world-complex/target/hello-world-complex.jar
```

With the additional dependencies, it grow to 1.8 MB:
```commandline
-rw-r--r--  1 cmr  1896053708   1.8M Aug 17 10:49 ./hello-world-complex/target/hello-world-complex.jar
```

Now let's check it for our native image as well:
```commandline
ls -lh ./hello-world-complex/target/App
```

It grow to 27 MB:
```commandline
-rwxr-xr-x  1 cmr  1896053708    27M Aug 17 23:38 ./hello-world-complex/target/App
```

Let's run the Java application in our JVM:
```commandline
time java -jar ./hello-world-complex/target/hello-world-complex.jar
```

The output should look like the one below. It reported, that it took 964ms to execute our program:
```commandline
HTTP status code: 200
...
1.10s user 
0.16s system 
130% cpu 
0.964 total
```

Now let's execute our native image and compare it:
```commandline
time ./hello-world-complex/target/App
```

Again, it is significant faster then the version running in the JVM, only taking 102ms to get executed:
```commandline
HTTP status code: 200
...
0.02s user 
0.01s system 
30% cpu 
0.102 total
```

## 1.2. Build the GraalVM Native Image in a dockerized way

### 1.2.1 GraalVM Native Image "Hello World" example

Execute the command below which will copy the workspace into an Amazon Linux 2 based container, where we also install GraalVM and the native tool. We use Maven to execute the build and generate the native images:
```bash
docker build --progress=plain -t hello-world-docker-build .
```

When this is done (after about 2 minutes), let's check the size of these artefacts:
```commandline
docker run --rm hello-world-docker-build /bin/bash -c "ls -lh ./hello-world/target/hello-world.jar"
```

Our JAR file is about 3 kB, but it requires at least a JRE of several then's to one hundred MB to run:
```commandline
-rw-r--r-- 1 root root 3.0K Aug 17 20:54 ./hello-world/target/hello-world.jar
```

Let's chekc our native image as well:
```commandline
docker run --rm hello-world-docker-build /bin/bash -c "ls -lh ./hello-world/target/App"
```

With 11 MB, it's much bigger but doesn't need a JRE or JDK to be executed:
```commandline
-rwxr-xr-x 1 root root 11M Aug 17 20:54 ./hello-world/target/App
```

Let's run the Java application in our container:
```commandline
docker run --rm hello-world-docker-build /bin/bash -c "time java -jar ./hello-world/target/hello-world.jar"
```

It takes about 119ms to execute it, based on the output we receive:
```commandline
real    0m0.509s
user    0m0.096s
sys     0m0.119s
```

Let's compare it with the native image, we will run in our container as well:
```commandline
docker run --rm hello-world-docker-build /bin/bash -c "time ./hello-world/target/App"
```

This was fast. It took only 2ms to run it:
```commandline
real    0m0.004s
user    0m0.002s
sys     0m0.002s
```

To extract the native image from your container, run:
```commandline
docker run --rm --entrypoint cat hello-world-docker-build ./hello-world/target/App > ./hello-world/target/App
```

### 1.2.2. GraalVM Native Image "Hello World Complex" example

In this example, we are querying some weather data from `https://api.weather.gov`, convert the received JSON data string with Jackson into a JsonNode and then print it out as string.

> NOTE: You can skip the next command, if you already execute it in 1.2.1.

```bash
docker build --progress=plain -t hello-world-docker-build .
```

First, let's compare the artefact sizes again, starting with the JAR file:
```commandline
docker run --rm hello-world-docker-build /bin/bash -c "ls -lh ./hello-world-complex/target/hello-world-complex.jar"
```

With the additional dependencies, it grow to 1.9 MB:
```commandline
-rw-r--r-- 1 root root 1.9M Aug 17 20:54 ./hello-world-complex/target/hello-world-complex.jar
```

Now let's check it for our native image as well:
```commandline
docker run --rm hello-world-docker-build /bin/bash -c "ls -lh ./hello-world-complex/target/App"
```

It grow to 27 MB:
```commandline
-rwxr-xr-x 1 root root 27M Aug 17 20:56 ./hello-world-complex/target/App
```

Let's run the Java application in our container:
```commandline
docker run --rm hello-world-docker-build /bin/bash -c "time java -jar ./hello-world-complex/target/hello-world-complex.jar"
```

The output should look like the one below. It reported, that it took 654ms to execute our program:
```commandline
HTTP status code: 200
...
real    0m1.402s
user    0m1.388s
sys     0m0.654s
```

Now let's execute our native image and compare it:
```commandline
docker run --rm hello-world-docker-build /bin/bash -c "time ./hello-world-complex/target/App"
```

Again, it is significant faster then the version running in the JVM, only taking 18ms to get executed:
```commandline
HTTP status code: 200
...
real    0m0.123s
user    0m0.030s
sys     0m0.018s
```

To extract the native image from your container, run:
```commandline
docker run --rm --entrypoint cat hello-world-docker-build ./hello-world-complex/target/App > ./hello-world-complex/target/App
```