# Test application that runs inside the VM and uses /dev/debugcon.

{ writeShellScriptBin }:

writeShellScriptBin "test_app" ''
  set -e

  echo "Running test_app"

  echo "Hello from User App via /dev/debugcon!" > /dev/debugcon
''
