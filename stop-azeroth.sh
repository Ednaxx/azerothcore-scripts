#!/bin/bash

echo "=========================="
echo "== Stopping AzerothCore =="
echo "=========================="

./stop-world.sh
echo ""

./stop-auth.sh
echo ""

echo "=========================="
echo "== All shutdowns sent.  =="
echo "=========================="
