<!--
First community post for the NS8 Odoo module, written in the style
of https://community.nethserver.org/t/ns8-forgejo-testing/28554 (first post).
Paste into a new topic on community.nethserver.org, category "App", tag "ns8".
This is the module I offered in the "Any plans to upgrade Odoo 16?" thread.
Fill in the wiki link once the page is published.
-->

# NS8 Odoo (testing)

Hi all,

Following the "Any plans to upgrade Odoo 16?" thread, I've built an NS8 module for [Odoo](https://www.odoo.com) 19 (community edition), self-built from the official Odoo image with a PostgreSQL database. It is unofficial and not affiliated with Odoo SA.

It's in my community repository. To try it, add the repo once:

```
api-cli run add-repository --data '{"name":"tebbiworld","url":"https://raw.githubusercontent.com/tebbiworld/ns8-repo/main/ns8/updates/","status":true,"testing":false}'
```

then install **Odoo** from the Software Center. (Or straight from the image: `add-module ghcr.io/tebbiworld/odoo:latest 1`.)

What it does:

* Odoo 19 + PostgreSQL 16 in one rootless pod, behind a single Traefik route with Let's Encrypt
* threaded mode by default, so the live-chat websocket works on the one route; a worker count is configurable for bigger installs
* a master password for the database manager (generated on install, editable in the settings); you create your databases from Odoo's own manager
* a folder for custom / OCA add-ons at `/mnt/extra-addons`
* module backup covers the database, the filestore and the add-ons

A few things to know:

* it ships a **fresh** Odoo — there is **no automatic 16 → 19 migration**. Moving an existing v16 database across majors is a separate job (Odoo's upgrade path / OpenUpgrade); this module gives you a clean, current Odoo to migrate *into*.
* **AD/LDAP login**: configure your existing directory in the module settings and apply it to a database — it wires Odoo's built-in `auth_ldap` (for AD: port 389 + StartTLS, filter `(sAMAccountName=%s)`)
* Odoo starts empty: open the database manager, enter the master password, and create your first database

Feedback very welcome, especially on real-world add-ons and on the AD/LDAP login against different directory setups.

Docs: NethServer wiki (tebbiworld repository) · Source: [github.com/tebbiworld/ns8-odoo](https://github.com/tebbiworld/ns8-odoo)

Thanks!

*Category: App · Tags: ns8*
