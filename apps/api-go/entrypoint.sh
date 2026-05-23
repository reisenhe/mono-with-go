#!/bin/sh
set -e

echo "==> Running go mod tidy..."
go mod tidy

echo "==> Starting air hot-reload..."
exec air -c .air.toml
