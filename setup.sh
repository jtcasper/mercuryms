#!/bin/bash

mkdir -p /usr/share/mercuryms
groupadd mercuryms
useradd -g mercuryms -d /usr/share/mercuryms -s $(which nologin) mercuryms
chown mercuryms:mercuryms /usr/share/mercuryms
chmod 700 /usr/share/mercuryms
sqlite3 /usr/share/mercuryms/mercuryms.sqlite "$(cat migrations/*)"
chown mercuryms:mercuryms /usr/share/mercuryms/mercuryms.sqlite
python3 -m venv mercuryms . \
  && source bin/activate \
  && bin/pip install -r requirements.txt \
  && deactivate
cp mercuryms.service /etc/systemd/system/
cp mercuryms-listen* /etc/systemd/system/
cp mercuryms-send* /etc/systemd/system/
