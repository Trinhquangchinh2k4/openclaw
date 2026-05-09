# Apple Watch Assistant App Skeleton

This lightweight skeleton is safe to create on Linux/VPS without heavy build steps.

## What can be done now on Linux/VPS
- backend mock
- API contract
- runtime/session/logging structure
- config examples

## What still needs Mac/Xcode/signing
- watchOS simulator build
- real Apple Watch device build
- TestFlight packaging and signing

## Security rules
- Do not hardcode secrets in source files.
- API keys and environment-specific config must come from env vars or local secret files outside source control.
- `shared/config.example.json` is example-only and must not contain real credentials.
