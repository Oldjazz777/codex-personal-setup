# Codex Personal Setup

Portable personal setup for Codex: custom skills and global working rules.

## What is included

- `.agents/skills/` — 33 personal skills from the source laptop.
- `.codex/AGENTS.md` — global Russian-language working rules.

System skills bundled with Codex, plugins, credentials, API keys, and project files are deliberately not included.

## Install on a new Windows laptop

1. Clone this repository somewhere convenient:

   ```powershell
   git clone <YOUR_PRIVATE_REPOSITORY_URL>
   cd codex-personal-setup
   ```

2. Run the installer:

   ```powershell
   powershell -ExecutionPolicy Bypass -File .\scripts\Install-CodexPersonalSetup.ps1
   ```

   It copies the skills to `%USERPROFILE%\.agents\skills` and the global rules to `%USERPROFILE%\.codex\AGENTS.md`.

3. Restart Codex. If a skill does not appear, open a new Codex session after the restart.

The installer stops before overwriting an existing skill directory or `AGENTS.md`. Review or back up those files first; then use `-Force` only when replacement is intentional.

## Updating

On the source laptop, commit and push changes to this repository. On the new laptop, run `git pull` and invoke the installer again.

## Manual installation

Copy `.agents\skills` into `%USERPROFILE%\.agents\skills`, then copy `.codex\AGENTS.md` into `%USERPROFILE%\.codex\AGENTS.md`. Do not copy the `.codex\skills` cache: Codex discovers skills from `.agents\skills` automatically.
