# MercuryMS

## Purpose

This tool provides a way to text images to a Twilio webhook and store them on a NextCloud instance that you have access to.

## Requirements

- systemd
- sqlite3

## Usage

After setting up your Twilio account, configure the webhook for an incoming message to the route where you are running the `mercuryms.service` service. This could be something like `www.my-vps.com/mms`.

That server will store the Twilio Media URIs in a SQLite database. The `mercuryms-send.service` will poll that database on a configurable timer, and send it to the `mercuryms-listen.service`, which will download the media, and upload it to a NextCloud instance in a folder associated with the phone number that sent the number, and named after the Twilio Media URI.

## Installation

- Download the released tarfile and untar it to /opt/mercuryms. Or, if you untar it elsewhere, handle your systemd configs.
- Run `sudo setup.sh`. You can verify all of the commands in there, it's just a bootstrap script.
- Start/enable the relevant systemd units. If you have all of the services running on the same machine, that would be `systemctl start [mercuryms.service|mercuryms-listen.socket|mercuryms-send.timer]`. If you're running it across multiple machines, the ingress machine should be running `mercuryms.service` and `mercuryms-send.timer`, and the receiving machine should run the `mercuryms-list.socket` unit.

## Configuration

You can create configuration files that override the systemd units to supply your own environment variables. They should live in `/etc/systemd/system/mercuryms-$UNIT.d/mercuryms-$UNIT.conf`. The environment variable `$PW_COMMAND` should be a command that produces the NextCloud user's password and puts it on stdout. Should behave similarly to `printf`.
