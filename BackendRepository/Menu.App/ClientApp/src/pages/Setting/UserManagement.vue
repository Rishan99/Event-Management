<template>
  <q-page>
    <q-card flat class="no-border-radius">
      <q-card-section>
        <q-toolbar class="bg-white q-mt-xs">
          <q-toolbar-title class="text-primary"
            >User Management</q-toolbar-title
          >
          <q-btn
            unelevated
            size="sm"
            outline
            color="positive"
            label="New"
            @click="openRegisterUserDialog"
            icon="add"
          />
        </q-toolbar>
        <q-table square :rows="users" :loading="tableLoading">
          <template v-slot:header>
            <tr>
              <th class="text-left noLeftSpace">S.No</th>
              <th class="text-left">Name</th>
              <th class="text-center">Role</th>
              <th class="text-center">Actions</th>
            </tr>
          </template>
          <template v-slot:body="props">
            <tr :key="props.row.id">
              <td class="text-left">{{ props.rowIndex + 1 }}</td>
              <td class="text-left">{{ props.row.userName }}</td>
              <td class="text-center">{{ props.row.role }}</td>

              <td class="text-center">
                <q-btn
                  unelevated
                  round
                  size="sm"
                  dense
                  outline
                  color="primary"
                  icon="lock_reset"
                  @click="openResetPasswordDialog(props.row)"
                >
                  <q-tooltip> Reset Password </q-tooltip>
                </q-btn>
                <q-btn
                  unelevated
                  round
                  class="q-ml-xs"
                  dense
                  outline
                  size="sm"
                  color="light-blue"
                  icon="mdi-account-arrow-right"
                  :to="`/setting/${props.row.userId}/menu-access-control`"
                >
                  <q-tooltip> Menu Access Control </q-tooltip>
                </q-btn>
                <q-btn
                  unelevated
                  round
                  class="q-ml-xs"
                  size="sm"
                  dense
                  outline
                  color="negative"
                  icon="person_remove_alt_1"
                  @click="unregisteruser(props.row)"
                >
                  <q-tooltip> Unregister User </q-tooltip>
                </q-btn>
              </td>
            </tr>
          </template>
        </q-table>
        <q-dialog v-model="resetPasswordDialog" persistent position="top">
          <q-card>
            <q-toolbar style="padding: 0 15px">
              <q-toolbar-title class="text-primary"
                >Reset Password</q-toolbar-title
              >
              <q-btn
                color="primary"
                flat
                round
                dense
                icon="close"
                v-close-popup
              />
            </q-toolbar>
            <q-card-section>
              <q-form @submit="onResetPassword">
                <q-input
                  v-model="resetPasswordModel.password"
                  outlined
                  lazy-rules
                  label="Password *"
                  dense
                  :rules="[
                    (val) =>
                      (val && val.length > 0) || 'Password cannot be empty',
                  ]"
                  :type="isPwd ? 'password' : 'text'"
                >
                  <template v-slot:append>
                    <q-icon
                      :name="isPwd ? 'visibility_off' : 'visibility'"
                      class="cursor-pointer"
                      @click="isPwd = !isPwd"
                    />
                  </template>
                </q-input>
                <q-input
                  v-model="resetPasswordModel.confirmPassword"
                  outlined
                  lazy-rules
                  label="Confirm Password *"
                  dense
                  :rules="[
                    (val) =>
                      (val && val.length > 0) ||
                      'Confirm Password cannot be empty',
                  ]"
                  :type="isConfirmPwd ? 'password' : 'text'"
                >
                  <template v-slot:append>
                    <q-icon
                      :name="isConfirmPwd ? 'visibility_off' : 'visibility'"
                      class="cursor-pointer"
                      @click="isConfirmPwd = !isConfirmPwd"
                    />
                  </template>
                </q-input>
                <q-btn color="primary" type="submit" label="Submit" />
              </q-form>
            </q-card-section>
          </q-card>
        </q-dialog>
        <q-dialog v-model="userRegisterModel" persistent position="top">
          <q-card square>
            <q-toolbar class="q-pl-md q-pr-md">
              <q-toolbar-title class="text-primary"
                >Register User</q-toolbar-title
              >
              <q-btn
                color="primary"
                flat
                round
                dense
                icon="close"
                v-close-popup
              />
            </q-toolbar>
            <q-card-section>
              <q-form @submit="onRegisterUser">
                <q-input
                  outlined
                  dense
                  label="Username *"
                  v-model="registerUserModel.username"
                  :rules="[
                    (val) =>
                      (val && val.length > 0) || 'Username cannot be empty',
                  ]"
                ></q-input>
                <q-input
                  v-model="registerUserModel.password"
                  outlined
                  lazy-rules
                  label="Password *"
                  dense
                  :rules="[
                    (val) =>
                      (val && val.length > 0) || 'Password cannot be empty',
                  ]"
                  :type="!isPwd ? 'password' : 'text'"
                >
                  <template v-slot:append>
                    <q-icon
                      :name="!isPwd ? 'visibility_off' : 'visibility'"
                      class="cursor-pointer"
                      @click="isPwd = !isPwd"
                    />
                  </template>
                </q-input>
                <q-input
                  v-model="registerUserModel.confirmPassword"
                  outlined
                  lazy-rules
                  label="Confirm Password *"
                  dense
                  :rules="[
                    (val) =>
                      (val && val.length > 0) ||
                      'Confirm Password cannot be empty',
                  ]"
                  :type="!isConfirmPwd ? 'password' : 'text'"
                >
                  <template v-slot:append>
                    <q-icon
                      :name="!isConfirmPwd ? 'visibility_off' : 'visibility'"
                      class="cursor-pointer"
                      @click="isConfirmPwd = !isConfirmPwd"
                    />
                  </template>
                </q-input>
                <q-select
                  outlined
                  dense
                  v-model="registerUserModel.role"
                  label="Role *"
                  clearable
                  input-debounce="0"
                  :options="roles"
                  option-label="name"
                  emit-value
                  map-options
                  behavior="menu"
                  option-value="id"
                  lazy-rules
                  :rules="[
                    (val) =>
                      (val !== null && val !== '') || 'Role  is required',
                  ]"
                />
                <q-btn color="primary" type="submit" label="Submit" />
              </q-form>
            </q-card-section>
          </q-card>
        </q-dialog>
      </q-card-section>
    </q-card>
  </q-page>
</template>
<script>
import { defineComponent, onMounted, ref } from "vue";
import { api } from "boot/axios";
import { handleError } from "boot/utility";
import { useStore } from "vuex";
import { useQuasar } from "quasar";
import { useRouter } from "vue-router";

export default defineComponent({
  name: "UserManagement",
  setup() {
    let users = ref([]);
    const $q = useQuasar();
    const store = useStore();
    const router = useRouter();
    let tableLoading = ref(false);
    let resetPasswordModel = ref({
      username: "",
      password: "",
      confirmPassword: "",
    });
    let registerUserModel = ref({
      username: "",
      password: "",
      confirmPassword: "",
      role: null,
    });

    let userRegisterModel = ref(false);
    let roles = ref([]);
    let resetPasswordDialog = ref(false);
    let password = ref("");
    let isPwd = ref(false);
    let isConfirmPwd = ref(false);

    const getUsers = async () => {
      try {
        const response = await api.get("auth/user-with-role");
        users.value = response.data;
      } catch (error) {
        $q.loading.hide({});
        handleError(error);
      }
    };
    const openResetPasswordDialog = (userModel) => {
      $q.loading.show({});
      resetPasswordDialog.value = true;
      resetPasswordModel.value.username = userModel.userName;
      resetPasswordModel.value.password = "";
      resetPasswordModel.value.confirmPassword = "";
      isPwd.value = true;
      isConfirmPwd.value = true;
      $q.loading.hide();
    };

    const openRegisterUserDialog = () => {
      $q.loading.show({});
      userRegisterModel.value = true;
      registerUserModel.value.username = "";
      registerUserModel.value.password = "";
      registerUserModel.value.confirmPassword = "";
      registerUserModel.value.role = null;
      isPwd.value = false;
      isConfirmPwd.value = false;
      $q.loading.hide();
    };
    const getRoles = async () => {
      try {
        const response = await api.get("auth/roles");
        roles.value = response.data;
      } catch (error) {
        $q.loading.hide({});
        handleError(error);
      }
    };
    const unregisteruser = async (user) => {
      try {
        $q.dialog({
          title: "Confirm",
          message: `Are you sure you want to unregister the user ${user.userName} ?`,
          cancel: true,
          persistent: true,
        }).onOk(async () => {
          $q.loading.show();
          try {
            let response = await api.post("auth/unregister-user", {
              username: user.userName,
            });
            $q.notify({
              type: "positive",
              message: `${response.data}`,
            });
            await getUsers();
            $q.loading.hide();
          } catch (error) {
            $q.loading.hide();
            handleError(error);
          }
        });
      } catch (error) {
        handleError(error);
      }
    };
    const onResetPassword = async () => {
      try {
        $q.loading.show({});
        const response = await api.post(
          "auth/reset-password",
          resetPasswordModel.value
        );
        resetPasswordDialog.value = false;
        $q.loading.hide({});
        if (response.data) {
          store.dispatch("auth/logout");
          router.push("/login");
        }
        $q.notify({
          type: "positive",
          message: `The Password has been reset`,
        });
      } catch (error) {
        $q.loading.hide({});
        handleError(error);
      }
    };
    const onRegisterUser = async () => {
      try {
        $q.loading.show({});
        const response = await api.post(
          "auth/user/register",
          registerUserModel.value
        );
        userRegisterModel.value = false;
        $q.loading.hide({});
        if (response.data) {
          $q.notify({
            type: "positive",
            message: `${response.data}`,
          });
          await getUsers();
        }
      } catch (error) {
        $q.loading.hide({});
        handleError(error);
      }
    };

    onMounted(async () => {
      $q.loading.show({});
      await getUsers();
      await getRoles();
      $q.loading.hide({});
    });
    return {
      users,
      tableLoading,
      getUsers,
      resetPasswordModel,
      resetPasswordDialog,
      onResetPassword,
      openResetPasswordDialog,
      password,
      isPwd,
      isConfirmPwd,
      unregisteruser,
      registerUserModel,
      userRegisterModel,
      openRegisterUserDialog,
      roles,
      onRegisterUser,
    };
  },
});
</script>
