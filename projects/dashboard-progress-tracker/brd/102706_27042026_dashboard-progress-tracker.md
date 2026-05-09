# Dashboard Progress Tracker BRD Update - Memory Guard Phase 2

## Priority

- Priority: P1 support for P0 Apple Watch work.
- Memory guard must run before any further dashboard/Apple Watch task work.

## Requirement

- Diagnose high physical RAM usage before running more work.
- Do not run heavy builds, broad filesystem grep, or parallel agents while memory is tight.
- Do not kill SSH, cloudflared, ops-cockpit, or gateway blindly.
- If safe, reduce real RSS through service-managed graceful restart.
- Dashboard must expose memory truth:
  - RAM used / total.
  - RAM available.
  - Swap used / total.
  - Top memory processes.
  - Memory risk state.

## Evidence Summary

- Before restart: RAM around `3.6Gi / 3.8Gi`, available around `277Mi`, swap active around `116Mi`.
- Main RSS sources: `openclaw-gateway` around `1.9GB`, VS Code extensionHost around `1.0GB`.
- Gateway is systemd user service `openclaw-gateway.service`, not a stray process.
- Action taken: graceful `systemctl --user restart openclaw-gateway.service`.
- After restart: RAM around `2.0Gi / 3.8Gi`, available around `1.8Gi`; gateway RSS around `447MB`.

## Dashboard Patch

- API adds top-level `memory` object with RAM, swap, top processes, and risk fields.
- UI RAM card now shows risk, available memory, swap usage, and top memory consumers.
- Ops Cockpit session parsing changed from full-file read to bounded tail read for session JSONL.

## Status

- Status: in_progress for ongoing memory observation.
- Current state is safer because RSS decreased and swap is active, but heavy builds/parallel agent work should still be avoided unless memory remains stable.
