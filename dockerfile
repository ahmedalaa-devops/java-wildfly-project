FROM jboss/wildfly:latest

COPY target/kitchensink.war /opt/jboss/wildfly/standalone/deployments/