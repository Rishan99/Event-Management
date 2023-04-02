<template>
  <q-page>
    <q-card
      flat
      class="no-border-radius q-mt-md q-mb-md q-ml-md q-mr-md bg-white"
    >
      <q-card-section>
        <q-toolbar class="text-primary q-mt-xs q-mb-sm" style="padding: 0">
          <q-toolbar-title class="">Menu Management</q-toolbar-title>
        </q-toolbar>
        <div class="row">
          <div class="col-4 q-mb-lg">
            <q-select
              v-model="selectedAccessLevel"
              label="Select Access Levels *"
              outlined
              emit-value
              map-options
              option-label="name"
              :options="accessLevels"
              clearable
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
import { useQuasar } from "quasar";

export default defineComponent({
  name: "MenuManagement",
  setup() {
    let menus = ref([]);
    let ticked = ref([]);
    let accessLevels = ref([]);
    let selectedAccessLevel = ref(null);
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
        let response = await api.post("menus/accesslevel/update", {
          id: selectedAccessLevel.value.id,
          menuIds: ticked.value,
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
    const onAccesslevelChanged = async () => {
      try {
        $q.loading.show();
        let response = await api.get(
          `menus/accesslevel/${selectedAccessLevel.value.id}`
        );
        let menus = response.data;
        $q.loading.hide();
        ticked.value = [];
        menus.forEach((item) => {
          if (item.isSelected) {
            ticked.value.push(item.id);
          }
        });
      } catch (ex) {
        $q.loading.hide();
        handleError(ex);
      }
    };
    const onClearClick = () => {
      alert("clear");
    };

    onMounted(async () => {
      $q.loading.show();
      await getMenus();
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
    };
  },
});
</script>
