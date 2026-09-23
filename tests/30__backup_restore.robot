*** Settings ***
Library     SSHLibrary
Resource    api.resource

*** Test Cases ***
Seed a probe row
    Run on node    runagent -m ${module_id} podman exec odoo-db psql -U odoo -d cidb -c "CREATE TABLE ci_probe (note text); INSERT INTO ci_probe VALUES ('pre-backup');"

Back up the module
    ${repo}    ${path} =    Back up the module to the cluster repository    ${module_id}
    Set Global Variable    ${BACKUP_REPO}    ${repo}
    Set Global Variable    ${BACKUP_PATH}    ${path}

Restore into a new instance
    ${rid} =    Restore the module from the cluster repository    ${BACKUP_REPO}    ${BACKUP_PATH}
    Set Global Variable    ${restored_id}    ${rid}
    Should Not Be Equal    ${restored_id}    ${module_id}

The restored instance has data, settings and secrets
    ${out} =    Wait Until Keyword Succeeds    40 times    10 seconds
    ...    Run on node    runagent -m ${restored_id} podman exec odoo-db psql -U odoo -d cidb -tAc "SELECT note FROM ci_probe"
    Should Contain    ${out}    pre-backup
    ${cfg} =    Run task    module/${restored_id}/get-configuration    {}
    Should Be Equal    ${cfg['timezone']}    Europe/Berlin
    Should Be True    ${cfg['master_password_set']}
    Secrets are kept out of the module environment    ${restored_id}
    # Odoo must be able to log in to the restored cluster with the restored password
    Wait Until Keyword Succeeds    40 times    10 seconds
    ...    Run on node    runagent -m ${restored_id} podman exec odoo-app odoo shell -d cidb --no-http --log-level=warn </dev/null
