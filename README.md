# ns8-odoo

An unofficial [NethServer 8](https://github.com/NethServer/ns8-core) module that
runs [Odoo](https://www.odoo.com) 19 (community edition) with a PostgreSQL
database, self-built from the official Odoo image.

It is **not affiliated with Odoo SA**. It packages the upstream image for NS8; it
does not modify Odoo.

## What it installs

- **Odoo 19** (a dated build of the 19.0 branch, e.g.
  `docker.io/library/odoo:19.0-20260908`) and **PostgreSQL 16** (a pinned minor,
  e.g. `docker.io/library/postgres:16.14`) in a single rootless Podman pod. Odoo reaches
  PostgreSQL on `127.0.0.1:5432` inside the pod.
- One **Traefik route** for the host name, with Let's Encrypt and HTTP→HTTPS
  redirection. Odoo runs in `proxy_mode`.

## First run

Odoo starts with **no database**. Open the module, then the **database manager**
(`https://<host>/web/database/manager`), enter the **master password** (set your own
in the module settings first) and create your first database: pick a name, set the admin
e-mail and password, and choose whether to load demo data.

## Settings

- **Host name** — the FQDN, published through Traefik.
- **Let's Encrypt / HTTP→HTTPS** — certificate and redirect.
- **Timezone** — the container OS time zone (Odoo also keeps per-user zones).
- **Worker processes** — `0` keeps Odoo in threaded mode (one HTTP port, the
  live-chat websocket works on it, a single route is enough). Raise it for
  multiprocess on bigger installs.
- **Show the database manager** — expose the database list/manager (still
  behind the master password).
- **Master password** — protects the database manager (create / duplicate /
  drop / backup / restore). Like every secret of the module (database
  password, LDAP bind password) it is stored in `state/passwords.env`, mode
  0600, and not in the module environment, which NS8 mirrors to Redis. Leave
  the field empty to keep the current one.

## Directory login (AD / LDAP)

Odoo Community ships the built-in **LDAP Authentication** (`auth_ldap`). This
module lets you configure it from the NS8 Settings and apply it to a database:

- Enter the **server**, **port**, **StartTLS**, **bind DN + password**, **base
  DN** and a **login filter**. For **Active Directory** use **port 389 with
  StartTLS on** (AD refuses plain 389) and the filter `(sAMAccountName=%s)`; for
  OpenLDAP use `(uid=%s)`.
- Because Odoo stores the LDAP configuration **per database**, create your
  database first, then **apply** the LDAP settings to it (a button in Settings,
  or the `apply-ldap` action). New matching users can be auto-created on first
  login.

## Custom and OCA add-ons

Drop extra modules into the **`odoo-addons`** volume (mounted at
`/mnt/extra-addons`), then update the apps list / install them from Odoo.

## Backup

Before each backup run the module dumps every Odoo database with `pg_dump`
(custom format) plus the role definitions into `state/pgdump/`. The NS8 module
backup contains these dumps, `state/passwords.env`, and the `odoo-data`
(filestore) and `odoo-addons` volumes. The live PostgreSQL data directory is
not copied. On restore the module rebuilds the database volume from the dumps
and re-applies all settings, including the host name and the directory login.

## Not included (by design)

- An automatic cross-major data migration (e.g. 16 → 19). Odoo's own upgrade
  path / OpenUpgrade is the tool for that; the weekly auto-release follows the
  dated builds of the 19.0 branch and never bumps across majors.
- Built-in directory login. Add it later with the OCA `auth_ldap` module.

## Licence

The module is GPL-3.0-or-later. Odoo Community Edition is LGPL-3.0; the official
image is pulled unmodified at runtime.
