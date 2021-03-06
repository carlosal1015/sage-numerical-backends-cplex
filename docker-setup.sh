#! /bin/bash
# Download cplex installer into .private/
# Then run this file to create a docker image
#
# https://www.ibm.com/support/knowledgecenter/SSSA5P_12.7.0/ilog.odms.studio.help/Optimization_Studio/topics/td_silent_install.html
cat > .private/cplex-install.properties <<EOF
# generated by docker-setup.sh
INSTALLER_UI=silent
LICENSE_ACCEPTED=true
INSTALLER_LOCALE=en
EOF
docker build -t private/sage-cplex -f - .private <<EOF
 # Image mkoeppe/conda-sagemath-coinor built by https://github.com/mkoeppe/sage-numerical-backends-coin/blob/master/.github/workflows/build.yml
FROM mkoeppe/conda-sagemath-coinor
ADD cplex_studio1210.linux-x86-64.bin /tmp
ADD cplex-install.properties /tmp
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --yes unzip
RUN sh /tmp/cplex_studio1210.linux-x86-64.bin -f /tmp/cplex-install.properties
EOF
