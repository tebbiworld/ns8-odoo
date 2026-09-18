# Changelog

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
