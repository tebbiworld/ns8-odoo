<!--
  Copyright (C) 2026 tebbi
  SPDX-License-Identifier: GPL-3.0-or-later
-->
<template>
  <cv-grid fullWidth>
    <cv-row>
      <cv-column class="page-title">
        <h2>{{ $t("settings.title") }}</h2>
      </cv-column>
    </cv-row>
    <cv-row v-if="error.getConfiguration">
      <cv-column>
        <NsInlineNotification
          kind="error"
          :title="$t('action.get-configuration')"
          :description="error.getConfiguration"
          :showCloseButton="false"
        />
      </cv-column>
    </cv-row>
    <cv-row>
      <cv-column>
        <cv-tile light>
          <cv-form @submit.prevent="configureModule">
            <cv-text-input
              :label="$t('settings.host')"
              v-model.trim="host"
              :placeholder="$t('settings.host_placeholder')"
              :helper-text="$t('settings.host_helper')"
              :disabled="loading.getConfiguration || loading.configureModule"
              :invalid-message="$t(error.host)"
              ref="host"
            ></cv-text-input>
            <cv-toggle
              value="lets_encrypt"
              :label="$t('settings.lets_encrypt')"
              v-model="lets_encrypt"
              :disabled="loading.getConfiguration || loading.configureModule"
              class="toggle"
            >
              <template slot="text-left">{{ $t("settings.disabled") }}</template>
              <template slot="text-right">{{ $t("settings.enabled") }}</template>
            </cv-toggle>
            <cv-toggle
              value="http2https"
              :label="$t('settings.http2https')"
              v-model="http2https"
              :disabled="loading.getConfiguration || loading.configureModule"
              class="toggle"
            >
              <template slot="text-left">{{ $t("settings.disabled") }}</template>
              <template slot="text-right">{{ $t("settings.enabled") }}</template>
            </cv-toggle>
            <cv-text-input
              :label="$t('settings.timezone')"
              v-model.trim="timezone"
              :placeholder="$t('settings.timezone_placeholder')"
              :helper-text="$t('settings.timezone_helper')"
              :disabled="loading.getConfiguration || loading.configureModule"
              :invalid-message="$t(error.timezone)"
              ref="timezone"
            ></cv-text-input>
            <cv-number-input
              :label="$t('settings.workers')"
              v-model="workers"
              :min="0"
              :helper-text="$t('settings.workers_helper')"
              :disabled="loading.getConfiguration || loading.configureModule"
              :invalid-message="$t(error.workers)"
              ref="workers"
              class="number-input"
            ></cv-number-input>
            <h4 class="section-title">{{ $t("settings.database_title") }}</h4>
            <div class="section-help">{{ $t("settings.database_help") }}</div>
            <cv-toggle
              value="list_db"
              :label="$t('settings.list_db')"
              v-model="list_db"
              :disabled="loading.getConfiguration || loading.configureModule"
              class="toggle"
            >
              <template slot="text-left">{{ $t("settings.disabled") }}</template>
              <template slot="text-right">{{ $t("settings.enabled") }}</template>
            </cv-toggle>
            <cv-text-input
              :label="$t('settings.master_password')"
              type="password"
              v-model="master_password"
              :helper-text="
                master_password_set
                  ? $t('settings.master_password_helper_set')
                  : $t('settings.master_password_helper_unset')
              "
              :disabled="loading.getConfiguration || loading.configureModule"
              :invalid-message="$t(error.master_password)"
              ref="master_password"
              class="master-password"
            ></cv-text-input>
            <h4 class="section-title">{{ $t("settings.ldap_title") }}</h4>
            <div class="section-help">{{ $t("settings.ldap_help") }}</div>
            <cv-toggle
              value="ldap_enabled"
              :label="$t('settings.ldap_enabled')"
              v-model="ldap_enabled"
              :disabled="loading.getConfiguration || loading.configureModule"
              class="toggle"
            >
              <template slot="text-left">{{ $t("settings.disabled") }}</template>
              <template slot="text-right">{{ $t("settings.enabled") }}</template>
            </cv-toggle>
            <template v-if="ldap_enabled">
              <cv-text-input
                :label="$t('settings.ldap_server')"
                v-model.trim="ldap_server"
                :placeholder="$t('settings.ldap_server_placeholder')"
                :disabled="loading.getConfiguration || loading.configureModule"
                :invalid-message="$t(error.ldap_server)"
                ref="ldap_server"
                class="ldap-field"
              ></cv-text-input>
              <cv-number-input
                :label="$t('settings.ldap_port')"
                v-model="ldap_port"
                :min="0"
                :disabled="loading.getConfiguration || loading.configureModule"
                :invalid-message="$t(error.ldap_port)"
                ref="ldap_port"
                class="ldap-field"
              ></cv-number-input>
              <cv-toggle
                value="ldap_tls"
                :label="$t('settings.ldap_tls')"
                v-model="ldap_tls"
                :disabled="loading.getConfiguration || loading.configureModule"
                class="toggle"
              >
                <template slot="text-left">{{
                  $t("settings.disabled")
                }}</template>
                <template slot="text-right">{{
                  $t("settings.enabled")
                }}</template>
              </cv-toggle>
              <cv-text-input
                :label="$t('settings.ldap_binddn')"
                v-model.trim="ldap_binddn"
                :placeholder="$t('settings.ldap_binddn_placeholder')"
                :disabled="loading.getConfiguration || loading.configureModule"
                :invalid-message="$t(error.ldap_binddn)"
                ref="ldap_binddn"
                class="ldap-field"
              ></cv-text-input>
              <cv-text-input
                :label="$t('settings.ldap_password')"
                type="password"
                v-model="ldap_password"
                :helper-text="
                  ldap_password_set
                    ? $t('settings.ldap_password_helper_set')
                    : $t('settings.ldap_password_helper_unset')
                "
                :disabled="loading.getConfiguration || loading.configureModule"
                :invalid-message="$t(error.ldap_password)"
                ref="ldap_password"
                class="ldap-field"
              ></cv-text-input>
              <cv-text-input
                :label="$t('settings.ldap_base')"
                v-model.trim="ldap_base"
                :placeholder="$t('settings.ldap_base_placeholder')"
                :disabled="loading.getConfiguration || loading.configureModule"
                :invalid-message="$t(error.ldap_base)"
                ref="ldap_base"
                class="ldap-field"
              ></cv-text-input>
              <cv-text-input
                :label="$t('settings.ldap_filter')"
                v-model.trim="ldap_filter"
                :placeholder="$t('settings.ldap_filter_placeholder')"
                :helper-text="$t('settings.ldap_filter_helper')"
                :disabled="loading.getConfiguration || loading.configureModule"
                :invalid-message="$t(error.ldap_filter)"
                ref="ldap_filter"
                class="ldap-field"
              ></cv-text-input>
              <cv-toggle
                value="ldap_create_user"
                :label="$t('settings.ldap_create_user')"
                v-model="ldap_create_user"
                :disabled="loading.getConfiguration || loading.configureModule"
                class="toggle"
              >
                <template slot="text-left">{{
                  $t("settings.disabled")
                }}</template>
                <template slot="text-right">{{
                  $t("settings.enabled")
                }}</template>
              </cv-toggle>
              <NsInlineNotification
                kind="info"
                :title="$t('settings.ldap_ad_hint_title')"
                :description="$t('settings.ldap_ad_hint_desc')"
                :showCloseButton="false"
                class="ldap-hint"
              />
            </template>
            <cv-row v-if="error.configureModule">
              <cv-column>
                <NsInlineNotification
                  kind="error"
                  :title="$t('action.configure-module')"
                  :description="error.configureModule"
                  :showCloseButton="false"
                />
              </cv-column>
            </cv-row>
            <NsButton
              kind="primary"
              :icon="Save20"
              :loading="loading.configureModule"
              :disabled="loading.getConfiguration || loading.configureModule"
              >{{ $t("settings.save") }}</NsButton
            >
          </cv-form>
          <div class="ldap-apply">
            <h4 class="section-title">{{ $t("settings.ldap_apply_title") }}</h4>
            <div class="section-help">
              {{ $t("settings.ldap_apply_help") }}
            </div>
            <div v-if="!databases.length" class="section-help">
              {{ $t("settings.ldap_apply_no_db") }}
            </div>
            <template v-else>
              <cv-dropdown
                :label="$t('settings.ldap_apply_select')"
                v-model="selectedDatabase"
                :disabled="loading.getConfiguration || loading.applyLdap"
                class="ldap-field"
              >
                <cv-dropdown-item
                  v-for="db in databases"
                  :key="db"
                  :value="db"
                  >{{ db }}</cv-dropdown-item
                >
              </cv-dropdown>
              <NsButton
                kind="secondary"
                :icon="Password20"
                :loading="loading.applyLdap"
                :disabled="loading.getConfiguration || loading.applyLdap"
                @click="applyLdap"
                class="ldap-apply-button"
                >{{ $t("settings.ldap_apply_button") }}</NsButton
              >
            </template>
            <NsInlineNotification
              v-if="error.applyLdap"
              kind="error"
              :title="$t('action.apply-ldap')"
              :description="error.applyLdap"
              :showCloseButton="false"
              class="ldap-apply-result"
            />
            <NsInlineNotification
              v-if="applyLdapMessage"
              :kind="applyLdapFailed ? 'warning' : 'success'"
              :title="$t('action.apply-ldap')"
              :description="applyLdapMessage"
              :showCloseButton="false"
              class="ldap-apply-result"
            />
          </div>
        </cv-tile>
      </cv-column>
    </cv-row>
  </cv-grid>
</template>

<script>
import to from "await-to-js";
import { mapState } from "vuex";
import Password20 from "@carbon/icons-vue/es/password/20";
import {
  QueryParamService,
  UtilService,
  TaskService,
  IconService,
  PageTitleService,
} from "@nethserver/ns8-ui-lib";

export default {
  name: "Settings",
  mixins: [
    TaskService,
    IconService,
    UtilService,
    QueryParamService,
    PageTitleService,
  ],
  pageTitle() {
    return this.$t("settings.title") + " - " + this.appName;
  },
  data() {
    return {
      q: {
        page: "settings",
      },
      urlCheckInterval: null,
      Password20,
      host: "",
      lets_encrypt: false,
      http2https: false,
      timezone: "UTC",
      workers: 0,
      list_db: false,
      master_password: "",
      master_password_set: false,
      ldap_enabled: false,
      ldap_server: "",
      ldap_port: 389,
      ldap_tls: false,
      ldap_binddn: "",
      ldap_password: "",
      ldap_password_set: false,
      ldap_base: "",
      ldap_filter: "",
      ldap_create_user: false,
      databases: [],
      selectedDatabase: "",
      applyLdapMessage: "",
      applyLdapFailed: false,
      loading: {
        getConfiguration: false,
        configureModule: false,
        applyLdap: false,
      },
      error: {
        getConfiguration: "",
        configureModule: "",
        host: "",
        timezone: "",
        workers: "",
        master_password: "",
        ldap_server: "",
        ldap_port: "",
        ldap_binddn: "",
        ldap_password: "",
        ldap_base: "",
        ldap_filter: "",
        applyLdap: "",
      },
    };
  },
  computed: {
    ...mapState(["instanceName", "core", "appName"]),
  },
  beforeRouteEnter(to, from, next) {
    next((vm) => {
      vm.watchQueryData(vm);
      vm.urlCheckInterval = vm.initUrlBindingForApp(vm, vm.q.page);
    });
  },
  beforeRouteLeave(to, from, next) {
    clearInterval(this.urlCheckInterval);
    next();
  },
  created() {
    this.getConfiguration();
  },
  methods: {
    async getConfiguration() {
      this.loading.getConfiguration = true;
      this.error.getConfiguration = "";
      const taskAction = "get-configuration";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.getConfigurationAborted
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.getConfigurationCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          extra: {
            title: this.$t("action." + taskAction),
            isNotificationHidden: true,
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.getConfiguration = this.getErrorMessage(err);
        this.loading.getConfiguration = false;
        return;
      }
    },
    getConfigurationAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.getConfiguration = this.$t("error.generic_error");
      this.loading.getConfiguration = false;
    },
    getConfigurationCompleted(taskContext, taskResult) {
      this.loading.getConfiguration = false;
      const config = taskResult.output;

      this.host = config.host || "";
      this.lets_encrypt = !!config.lets_encrypt;
      this.http2https = !!config.http2https;
      this.timezone = config.timezone || "UTC";
      this.workers = config.workers || 0;
      this.list_db = !!config.list_db;
      this.master_password_set = !!config.master_password_set;
      // never prefill the master password; empty means "keep current"
      this.master_password = "";

      this.ldap_enabled = !!config.ldap_enabled;
      this.ldap_server = config.ldap_server || "";
      this.ldap_port = config.ldap_port || 389;
      this.ldap_tls = !!config.ldap_tls;
      this.ldap_binddn = config.ldap_binddn || "";
      this.ldap_password_set = !!config.ldap_password_set;
      // never prefill the LDAP password; empty means "keep stored"
      this.ldap_password = "";
      this.ldap_base = config.ldap_base || "";
      this.ldap_filter = config.ldap_filter || "";
      this.ldap_create_user = !!config.ldap_create_user;

      this.databases = config.databases || [];
      if (
        this.selectedDatabase &&
        !this.databases.includes(this.selectedDatabase)
      ) {
        this.selectedDatabase = "";
      }
      if (!this.selectedDatabase && this.databases.length) {
        this.selectedDatabase = this.databases[0];
      }

      this.focusElement("host");
    },
    validateConfigureModule() {
      this.clearErrors(this);
      let isValidationOk = true;

      if (!this.host) {
        this.error.host = "common.required";
        if (isValidationOk) {
          this.focusElement("host");
          isValidationOk = false;
        }
      }
      return isValidationOk;
    },
    configureModuleValidationFailed(validationErrors) {
      this.loading.configureModule = false;
      let focusAlreadySet = false;

      for (const validationError of validationErrors) {
        const field = validationError.field;

        if (field !== "(root)") {
          // set i18n error message
          this.error[field] = this.$t("settings." + validationError.error);

          if (!focusAlreadySet) {
            this.focusElement(field);
            focusAlreadySet = true;
          }
        }
      }
    },
    async configureModule() {
      const isValidationOk = this.validateConfigureModule();
      if (!isValidationOk) {
        return;
      }

      this.loading.configureModule = true;
      const taskAction = "configure-module";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.configureModuleAborted
      );

      // register to task validation
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.configureModuleValidationFailed
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.configureModuleCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            host: this.host,
            lets_encrypt: this.lets_encrypt,
            http2https: this.http2https,
            timezone: this.timezone || "UTC",
            workers: Number(this.workers) || 0,
            list_db: this.list_db,
            master_password: this.master_password,
            ldap_enabled: this.ldap_enabled,
            ldap_server: this.ldap_server,
            ldap_port: Number(this.ldap_port) || 389,
            ldap_tls: this.ldap_tls,
            ldap_binddn: this.ldap_binddn,
            ldap_password: this.ldap_password,
            ldap_base: this.ldap_base,
            ldap_filter: this.ldap_filter,
            ldap_create_user: this.ldap_create_user,
          },
          extra: {
            title: this.$t("settings.configure_instance", {
              instance: this.instanceName,
            }),
            description: this.$t("common.processing"),
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.configureModule = this.getErrorMessage(err);
        this.loading.configureModule = false;
        return;
      }
    },
    configureModuleAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.configureModule = this.$t("error.generic_error");
      this.loading.configureModule = false;
    },
    configureModuleCompleted() {
      this.loading.configureModule = false;

      // reload configuration
      this.getConfiguration();
    },
    async applyLdap() {
      this.error.applyLdap = "";
      this.applyLdapMessage = "";
      this.applyLdapFailed = false;

      if (!this.selectedDatabase) {
        this.error.applyLdap = this.$t("settings.no_database_selected");
        return;
      }

      this.loading.applyLdap = true;
      const taskAction = "apply-ldap";
      const eventId = this.getUuid();

      // register to task error
      this.core.$root.$once(
        `${taskAction}-aborted-${eventId}`,
        this.applyLdapAborted
      );

      // register to task validation
      this.core.$root.$once(
        `${taskAction}-validation-failed-${eventId}`,
        this.applyLdapValidationFailed
      );

      // register to task completion
      this.core.$root.$once(
        `${taskAction}-completed-${eventId}`,
        this.applyLdapCompleted
      );

      const res = await to(
        this.createModuleTaskForApp(this.instanceName, {
          action: taskAction,
          data: {
            database: this.selectedDatabase,
          },
          extra: {
            title: this.$t("action." + taskAction),
            description: this.$t("common.processing"),
            eventId,
          },
        })
      );
      const err = res[0];

      if (err) {
        console.error(`error creating task ${taskAction}`, err);
        this.error.applyLdap = this.getErrorMessage(err);
        this.loading.applyLdap = false;
        return;
      }
    },
    applyLdapAborted(taskResult, taskContext) {
      console.error(`${taskContext.action} aborted`, taskResult);
      this.error.applyLdap = this.$t("error.generic_error");
      this.loading.applyLdap = false;
    },
    applyLdapValidationFailed(validationErrors) {
      this.loading.applyLdap = false;

      for (const validationError of validationErrors) {
        // show a readable message for the known error codes
        this.error.applyLdap = this.$t("settings." + validationError.error);
      }
    },
    applyLdapCompleted(taskContext, taskResult) {
      this.loading.applyLdap = false;
      const output = taskResult.output || {};
      const applied = output.applied || {};
      this.applyLdapFailed = !!output.failed;

      // build a per-database summary line, e.g. "mydb: ok"
      const parts = Object.keys(applied).map(
        (db) => `${db}: ${applied[db]}`
      );
      const summary = parts.join(", ");

      if (output.failed) {
        this.applyLdapMessage = this.$t("settings.ldap_apply_failed", {
          detail: summary,
        });
      } else {
        this.applyLdapMessage = this.$t("settings.ldap_apply_ok", {
          detail: summary,
        });
      }
    },
  },
};
</script>

<style scoped lang="scss">
@import "../styles/carbon-utils";
.toggle {
  margin-top: $spacing-06;
}
.number-input {
  margin-top: $spacing-06;
}
.section-title {
  margin-top: $spacing-07;
}
.section-help {
  margin-bottom: $spacing-05;
  color: $text-02;
}
.master-password {
  margin-top: $spacing-06;
}
.ldap-field {
  margin-top: $spacing-06;
}
.ldap-hint {
  margin-top: $spacing-06;
}
.ldap-apply {
  margin-top: $spacing-07;
}
.ldap-apply-button {
  margin-top: $spacing-06;
}
.ldap-apply-result {
  margin-top: $spacing-06;
}
</style>
