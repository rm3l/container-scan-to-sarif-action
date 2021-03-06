# Container Scan To SARIF action

This action converts [Azure Container Scan Action](https://github.com/Azure/container-scan#action-output) output to [Static Analysis Results Interchange Format (SARIF)](https://sarifweb.azurewebsites.net/), for an easier integration with [GitHub Code Scanning](https://docs.github.com/en/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/about-code-scanning).

It uses the standalone converter executable from [container-scan-to-sarif](https://github.com/rm3l/container-scan-to-sarif).

## Inputs

### `converter-version`

**Optional** Version of the container-scan-to-sarif tool. See https://github.com/rm3l/container-scan-to-sarif/releases. Default `"0.7.3"`.

### `input-file`

**Required** Path to the input Container Scan report to convert.

### `output-file`

**Optional** Path to the output SARIF report to generate. Default `"scanreport.sarif"`

## Outputs

### `sarif-report-path`

Path to the SARIF report generated.

## Example usage

```yaml
jobs:
  scan:
    runs-on: ubuntu-latest
    permissions:
      #
      # Below are permissions required for the upload-sarif Action.
      # More details here: https://docs.github.com/en/code-security/code-scanning/integrating-with-code-scanning/uploading-a-sarif-file-to-github
      #

      # required for all workflows
      security-events: write
      # only required for workflows in private repositories
      actions: read
      contents: read
    steps:
      - name: Scan Container Image
        id: scan
        uses: Azure/container-scan@v0.1
        with:
          image-name: my-container-image
    
      - name: Convert Container Scan Report to SARIF
        id: scan-to-sarif
        uses: rm3l/container-scan-to-sarif-action@v1
        if: ${{ always() }}
        with:
          input-file: ${{ steps.scan.outputs.scan-report-path }}

      - name: Upload SARIF reports to GitHub Security tab
        uses: github/codeql-action/upload-sarif@v2
        if: ${{ always() }}
        with:
          sarif_file: ${{ steps.scan-to-sarif.outputs.sarif-report-path }}
```
