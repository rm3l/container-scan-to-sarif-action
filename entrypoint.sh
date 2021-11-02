#!/bin/sh -l

CONTAINER_SCAN_TO_SARIF_VERSION="$1"
echo "Installing container-scan-to-sarif (version $CONTAINER_SCAN_TO_SARIF_VERSION)..."
mkdir -p ~/var/opt/
curl -L "https://github.com/rm3l/container-scan-to-sarif/releases/download/${CONTAINER_SCAN_TO_SARIF_VERSION}/container-scan-to-sarif_${CONTAINER_SCAN_TO_SARIF_VERSION}_Linux_x86_64.tar.gz" \
  | tar zx -C /var/opt/ || exit 1
chmod +x /var/opt/container-scan-to-sarif

INPUT="$2"
echo "Now running container-scan-to-sarif against file $INPUT..."
OUTPUT_FILE="$2"
/var/opt/container-scan-to-sarif -input "$INPUT" -output "$OUTPUT_FILE" || exit 1
echo "::set-output name=sarif-report-path::$OUTPUT_FILE"
