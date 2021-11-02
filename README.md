# Container Scan To SARIF action

This action prints "Hello World" or "Hello" + the name of a person to greet to the log.

## Inputs

## `converter-version`

**Optional** Version of the container-scan-to-sarif tool. See https://github.com/rm3l/container-scan-to-sarif/releases. Default `"0.2.2"`.

## `input-file`

**Required** Path to the input Container Scan report to convert. Default `"scanreport.json"`

## Outputs

## `sarif-report-path`

Path to the SARIF report generated

## Example usage

```yaml
- name: Scan Container Image
  id: scan
  continue-on-error: true
  uses: Azure/container-scan@v0.1
  with:
    image-name: my-container-image
    
- name: Convert Container Scan Report to SARIF
  id: container-scan-to-sarif
  uses: actions/container-scan-to-sarif@v1
  if: ${{ always() }}
  with:
    converter-version: 0.2.2
    input-file: ${{ steps.scan.outputs.scan-report-path }}

- name: Upload SARIF reports to GitHub Security tab
  uses: github/codeql-action/upload-sarif@v1
  if: ${{ always() }}
  with:
    sarif_file: ${{ steps.container-scan-to-sarif.outputs.scan-report-path }}
```
