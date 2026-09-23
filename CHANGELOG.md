# Changelog

## 1.1.1 — unreleased

- **Restore fix.** The database restore step no longer sources `passwords.env` as a shell script: a master or LDAP password containing a space or a shell metacharacter aborted the restore. Only the database password is read, line by line.
- Robot Framework tests (install, update from the previous release, backup and restore) run on real NS8 nodes through `stephdl/ns8-ci-actions`, as a job of the image build on every feature branch.

## 1.1.0 — 2026-09-19

Alignment with the NethServer module conventions (NethServer/agents skills).

- **Secrets moved out of the module environment.** The database password, the
  master password and the LDAP bind password are now kept in
  `state/passwords.env` (mode 0600) instead of `state/environment`, which NS8
  mirrors to Redis in plain text. Existing installations are migrated on update;
  the values do not change. The secrets are no longer passed on the podman
  command line either.
- **Consistent database backup.** `module-dump-state` writes a `pg_dump` of
  every database before the backup; the live PostgreSQL data directory is no
  longer copied file by file.
- **Working restore.** New `restore-module` steps rebuild the database from the
  dumps and re-apply every setting (host, Let's Encrypt, workers, directory
  login). Backups taken with 1.0.0 that only contain the raw data volume must
  be restored with 1.0.0.
- **Fully pinned images.** `odoo:19.0-20260908` and `postgres:16.14` instead of
  the rolling `19.0` and `16` tags; the weekly auto-release follows the dated
  19.0 builds.
- Service restarts list every unit of the pod explicitly; helper output goes to
  stderr; validation errors exit with status 3.

## 1.0.0 — 2026-09-18

- First release. Odoo 19 (community, official image) with a PostgreSQL 16
  database in one rootless Podman pod, behind a single Traefik route with
  Let's Encrypt.
- Threaded mode by default (one HTTP port, live-chat websocket works, one
  route); a worker count can be raised from the settings for bigger installs.
- Master password for the database manager, generated on install and editable
  in the settings; databases are created by the admin from Odoo's own database
  manager.
- Custom / OCA add-ons folder mounted at `/mnt/extra-addons` (the `odoo-addons`
  volume).
- **Directory login (AD/LDAP).** Store the directory settings in the module and
  apply them to a database, wiring Odoo's built-in `auth_ldap` against your
  existing AD/LDAP (for AD: port 389 with StartTLS, filter `(sAMAccountName=%s)`).
- Module backup includes the database, the filestore and the add-ons volumes.
- Not included by design: an automatic 16 → 19 (or any cross-major) data
  migration, and built-in LDAP (available later via the OCA `auth_ldap` module).
