#!/bin/bash

echo "Starting mongodb using supervisord..."
exec /usr/bin/supervisord -n
