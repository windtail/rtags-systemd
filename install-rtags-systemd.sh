#!/bin/bash

SYSTEMD_USER_DIR=$HOME/.config/systemd/user
SOCKET_FILE=$SYSTEMD_USER_DIR/rdm.socket
SERVICE_FILE=$SYSTEMD_USER_DIR/rdm.service

mkdir -p $SYSTEMD_USER_DIR

echo "[Unit]
Description=RTags daemon socket

[Socket]
ListenStream=%t/rdm.socket

[Install]
WantedBy=default.target
" > $SOCKET_FILE

echo "[Unit]
Description=RTags daemon

Requires=rdm.socket

[Service]
Type=simple
ExecStart=$(which rdm) -v --inactivity-timeout 300 --log-flush
ExecStartPost=/bin/sh -c \"echo +19 > /proc/\$MAINPID/autogroup\"
Nice=19
CPUSchedulingPolicy=idle
" > $SERVICE_FILE

systemctl --user enable rdm.socket

systemctl --user start rdm.socket
