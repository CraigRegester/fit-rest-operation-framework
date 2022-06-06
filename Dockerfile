ARG IMAGE=intersystemsdc/irishealth-community
ARG IMAGE=intersystemsdc/iris-community
FROM $IMAGE


USER root   
## add git
RUN apt update && apt-get -y install git
        
USER irisowner
WORKDIR /home/irisowner/irisbuild
ARG TESTS=0
ARG MODULE="fitlib-rest-framework"
ARG NAMESPACE="FITLIB"

RUN --mount=type=bind,src=.,dst=. \
    iris start IRIS && \
	iris session IRIS < iris.script && \
    ([ $TESTS -eq 0 ] || iris session iris -U $NAMESPACE "##class(%ZPM.PackageManager).Shell(\"test $MODULE -v -only\",1,1)") && \
    iris stop IRIS quietly