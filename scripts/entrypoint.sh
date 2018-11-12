#!/bin/sh
set -e
echo "10.0.0.8  scitos" >> /etc/hosts
exec "$@"
