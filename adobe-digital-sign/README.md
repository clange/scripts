These scripts perform digital signatures in Adobe Reader.

# Usage

Alternative ways of usage:
* with the cursor placed over a clickable signature field, invoke adobe-digital-sign-click.ahk, or
* with the cursor somewhere else in a PDF document, invoke adobe-digital-sign-draw.ahk.

The common logic of the actual signing process is implemented in adobe-digital-sign.ahk.

# Prerequisites

* in Preferences / Signatures / Creation and Appearance, uncheck "Use modern user interface for signing and Digital ID configuration"
* search adobe-digital-sign.ahk for `issuer` to adapt the logic that matches certificate issuers in the list of available signatures.
