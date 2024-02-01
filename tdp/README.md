# TDP Phoenix QueryServer Notes

The version 6.0.0-2.0 of Phoenix QueryServer is based on the `master` branch at the commit `3a7ffde42ae19fd31de986b6475fce4f977c4c26` of the Apache [repository](https://github.com/apache/phoenix-queryserver).


# Build a queryserver with TDP versions

```
mvn clean package -Dpackage.phoenix.client -pl '!phoenix-queryserver-it' -DskipTests
```


This command generates a `tar.gz` file of the release at `phoenix-queryserver-assembly/target/phoenix-queryserver-6.0.0-2.0-bin.tar.gz`

## Testing parameters

```
mvn verify
```

Phoenix QueryServer doesn't support running integrations tests against non-default Phoenix and HBase versions.
