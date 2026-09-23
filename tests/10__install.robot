*** Settings ***
Library     SSHLibrary
Resource    api.resource

*** Variables ***
${CONFIG}    {"host":"odoo.ci.test","lets_encrypt":false,"http2https":true,"timezone":"Europe/Berlin","workers":0,"list_db":true,"master_password":"Master#Pass 1","ldap_enabled":false}

*** Test Cases ***
Install the module
    # The update scenario starts from the last published release and reaches
    # the image under test through update-module below.
    IF    '${SCENARIO}' == 'update'
        ${output}  ${rc} =    Execute Command    add-module ${UPDATE_FROM} 1    return_rc=True
    ELSE
        ${output}  ${rc} =    Execute Command    add-module ${IMAGE_URL} 1    return_rc=True
    END
    Should Be Equal As Integers    ${rc}  0
    &{output} =    Evaluate    ${output}
    Set Global Variable    ${module_id}    ${output.module_id}

Configure the module
    Run task    module/${module_id}/configure-module    ${CONFIG}    decode_json=${FALSE}

Odoo answers behind Traefik
    Wait Until Keyword Succeeds    60 times    10 seconds    Database selector is served

Create a database
    Run on node    runagent -m ${module_id} podman exec odoo-app odoo -d cidb -i base --stop-after-init --without-demo=all --no-http --log-level=warn
    ${dbs} =    Run task    module/${module_id}/list-databases    {}
    Should Contain    ${dbs['databases']}    cidb

Update to the image under test
    Skip If    '${SCENARIO}' != 'update'    scenario is ${SCENARIO}
    Run on node    api-cli run update-module --data '{"force":true,"module_url":"${IMAGE_URL}","instances":["${module_id}"]}'
    Wait Until Keyword Succeeds    60 times    10 seconds    Database selector is served
    ${dbs} =    Run task    module/${module_id}/list-databases    {}
    Should Contain    ${dbs['databases']}    cidb

Configuration reads back
    ${cfg} =    Run task    module/${module_id}/get-configuration    {}
    Should Be Equal    ${cfg['host']}    odoo.ci.test
    Should Be Equal    ${cfg['timezone']}    Europe/Berlin
    Should Be True    ${cfg['master_password_set']}
    Should Be True    ${cfg['running']}

Secrets are stored in passwords.env only
    Secrets are kept out of the module environment    ${module_id}

*** Keywords ***
Database selector is served
    ${out} =    Run on node    curl -fsSkL -H 'Host: odoo.ci.test' https://127.0.0.1/web/database/selector
    Should Contain    ${out}    odoo
