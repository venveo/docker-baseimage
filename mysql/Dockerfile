FROM mysql:5.7
MAINTAINER Ransom Roberson <ransom@venveo.com>

# add custom my.conf to remove the ONLY_FULL_GROUP_BY sql mode
# TODO when Craft 3.x is released, this can be removed
COPY build/my.cnf /etc/mysql/
