<template>
  <q-page>
    <q-card flat class="no-border-radius">
      <q-toolbar class="text-primary">
        <q-toolbar-title>{{ userName }} - Menu Access Control</q-toolbar-title>
      </q-toolbar>

      <q-card-section>
        <div class="row">
          <div class="col-4 q-mb-lg">
            <q-select
              v-model="selectedAccessLevel"
              label="Select Access Levels *"
              outlined
              emit-value
              clearable
              map-options
              option-label="name"
              :options="accessLevels"
              @clear="onClearClick"
              @update:model-value="onAccesslevelChanged"
            >
            </q-select>
          </div>
        </div>
        <q-tree
          ref="menuTree"
          class="col-12 col-sm-6"
          :nodes="menus"
          node-key="id"
          label-key="name"
          tick-strategy="leaf"
          v-model:ticked.sync="ticked"
        />
      </q-card-section>
      <q-card-section>
        <q-btn color="primary" label="Submit" @click="onSubmitClick"></q-btn>
      </q-card-section>
    </q-card>
  </q-page>
</template>
<script>
import { defineComponent, ref, onMounted } from "vue";
import { handleError } from "boot/utility";
import { api } from "boot/axios";
import { useRouter, useRoute } from "vue-router";
import { useQuasar } from "quasar";

export default defineComponent({
  name: "MenuManagement",
  setup() {
    const router = useRouter();
    const route = useRoute();
    let accessLevels = ref([]);
    let selectedAccessLevel = ref(null);
    let menus = ref([]);
    let menusByUser = ref([]);
    let userId = ref(null);
    let ticked = ref([]);
    let userName = ref(null);
    const $q = useQuasar();

    const getMenus = async () => {
      try {
        const response = await api.get("menus");
        menus.value = response.data;
      } catch (error) {
        $q.loading.hide();
        handleError(error);
      }
    };
    const onSubmitClick = async () => {
      try {
        $q.loading.show();
        menus.value.forEach((item) => {
          if (item.children.length > 0) {
            item.children.forEach((c_item) => {
              if (
                ticked.value.includes(c_item.id) &&
                !ticked.value.includes(c_item.parentId)
              ) {
                ticked.value.push(c_item.parentId);
              }
            });
          }
        });

        let uniqueMenuIdArray = ticked.value.filter(
          (value, index) => ticked.value.indexOf(value) === index
        );

        let response = await api.post("menus/user/update", {
          userId: userId.value,
          menuIds: uniqueMenuIdArray,
        });
        $q.loading.hide();
        $q.notify({
          color: "positive",
          message: response.data,
        });
      } catch (error) {
        $q.loading.hide();
        handleError(error);
      }
    };

    const getAccessLevels = async () => {
      try {
        const response = await api.get("general/accesslevels");
        accessLevels.value = response.data;
      } catch (error) {
        handleError(error);
      }
    };
    const onAccesslevelChanged = async (e) => {
      try {
        if (selectedAccessLevel.value == null) {
          return;
        }
        await getMenusByUser();
        let response = await api.get(
          `menus/accesslevel/${selectedAccessLevel.value.id}`
        );
        let menusByAccesslevels = response.data;
        menusByAccesslevels.forEach((item) => {
          if (item.isSelected) {
            ticked.value.push(item.id);
          }
        });
        $q.loading.hide();
      } catch (ex) {
        $q.loading.show();
        handleError(ex);
      }
    };

    const getMenusByUser = async () => {
      try {
        let result = await api.get(`menus-by-user/${userId.value}`);
        menusByUser.value = result.data;
        ticked.value = [];
        menusByUser.value.forEach(function (menu) {
          ticked.value.push(menu.id);
        });
      } catch (ex) {
        vm.$handleError(ex);
      }
    };
    const getUserName = async () => {
      try {
        const response = await api.get(`auth/username/${userId.value}`);
        userName.value = response.data;
      } catch (error) {
        handleError(error);
      }
    };
    const onClearClick = () => {
      alert("clear");
    };

    onMounted(async () => {
      $q.loading.show();
      userId.value = route.params.id;
      await getUserName();
      await getMenus();
      await getMenusByUser();
      await getAccessLevels();
      $q.loading.hide();
    });

    return {
      menus,
      ticked,
      accessLevels,
      selectedAccessLevel,
      getMenus,
      onSubmitClick,
      getAccessLevels,
      onClearClick,
      onAccesslevelChanged,
      userName,
      getUserName,
      getMenusByUser,
      userId,
      menusByUser,
    };
  },
});
</script>
