#!/bin/bash

mkdir -p /usr/share/mercuryms
groupadd mercuryms
useradd -g mercuryms -d /usr/share/mercuryms -s $(which nologin) mercuryms
chown mercuryms:mercuryms /usr/share/mercuryms
chmod 700 /usr/share/mercuryms
