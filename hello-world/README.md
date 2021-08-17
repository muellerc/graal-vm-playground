

```bash
./mvnw clean package
```

```commandline
time java -jar ./hello-world/target/hello-world.jar
```

```commandline
0.08s user 
0.03s system 
123% cpu 
0.091 total
```


```bash
native-image -jar hello-world/target/hello-world.jar App
```


```commandline
time ./App
```

```commandline
0.00s user 
0.00s system 
70% cpu 
0.010 total
```