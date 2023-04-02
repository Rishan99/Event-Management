<template>
  <q-page>
    <q-card flat class="no-border-radius">
      <q-toolbar class="bg-grey-2">
        <q-toolbar-title class="text-primary">Events</q-toolbar-title>
      </q-toolbar>
      <q-separator />
      <q-card-section>
        <q-table
          square
          :rows="events"
          :loading="tableLoading"
          :filter="filter"
          :columns="columns"
          :pagination="pagination"
          style="table-layout: fixed"
          binary-state-sort
        >
          <template v-slot:body="props">
            <tr :key="props.row.id">
              <td class="text-center">{{ events.indexOf(props.row) + 1 }}</td>
              <td class="text-center">
                {{ props.row.name }}
              </td>
              <td class="text-center">{{ props.row.city }}</td>
              <td class="text-center">{{ props.row.ticketPrice }}</td>
              <td class="text-center">
                {{ props.row.startDate == null ? "" : props.row.startDate.split("T")[0] }}
              </td>
              <td class="text-center">
                {{ props.row.endDate == null ? "" : props.row.endDate.split("T")[0] }}
              </td>
              <td class="text-center">
                <q-btn
                  unelevated
                  round
                  class="q-ml-xs"
                  size="xs"
                  color="primary"
                  icon="mdi-circle-edit-outline"
                  @click="onEditTap(props.row.id)"
                >
                  <q-tooltip> Edit </q-tooltip>
                </q-btn>
                <q-btn
                  round
                  unelevated
                  size="xs"
                  color="negative"
                  class="q-ml-xs"
                  icon="mdi-delete-circle-outline"
                  @click="onDelete(props.row.id)"
                >
                  <q-tooltip> Delete </q-tooltip>
                </q-btn>
              </td>
            </tr>
          </template>
          <template v-slot:top-right>
            <q-input borderless dense clearable v-model="filter" placeholder="Search">
              <template v-slot:append>
                <q-icon name="search" />
              </template>
            </q-input>
          </template>
        </q-table>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script>
import { defineComponent, onMounted, ref } from "vue";
import { api } from "boot/axios";
import { handleError } from "boot/utility";
import { useQuasar } from "quasar";
import { useRoute, useRouter } from "vue-router";

export default defineComponent({
  setup() {
    let events = ref([]);
    const $q = useQuasar();
    const route = useRoute();
    const router = useRouter();
    let tableLoading = ref(false);
    let filter = ref("");
    const getAllEvents = async () => {
      const response = await api.get(`event/list`);
      events.value = response.data;
    };

    function onEditTap(eventId) {
      router.push(`/event/${eventId}/edit`);
    }

    const onDelete = async (id) => {
      $q.dialog({
        title: "Confirm",
        message: `Are you sure you want to delete this Event?`,
        cancel: true,
        persistent: true,
      }).onOk(async () => {
        try {
          $q.loading.show();
          let response = await api.post(`event/delete`, {
            id: id,
          });
          await getAllEvents();
          $q.loading.hide();
          $q.notify({
            type: "positive",
            message: `${response.data}`,
          });
        } catch (error) {
          $q.loading.hide();
          handleError(error);
        }
      });
    };
    onMounted(async () => {
      $q.loading.show();
      try {
        await getAllEvents();
      } catch (ex) {
        handleError(ex);
      }
      $q.loading.hide();
    });

    return {
      getAllEvents,
      events,
      tableLoading,
      onDelete,
      onEditTap,
      filter,
      pagination: {
        rowsPerPage: 15,
      },
      columns: [
        {
          name: "S.No",
          label: "S.No",
          sortable: true,
          align: "center",
        },
        {
          name: "Name",
          label: "Name",
          field: (row) => row.name,
          align: "center",
          sortable: false,
        },
        {
          name: "City",
          label: "City",
          field: (row) => row.city,
          sortable: true,
          align: "center",
        },
        {
          name: "Ticket Price",
          label: "Ticket Price",
          field: (row) => row.ticketPrice,
          align: "center",
          sortable: true,
        },
        {
          name: "Start Date",
          label: "Start Date",
          field: (row) => row.startDate,
          align: "center",
          sortable: false,
        },

        {
          name: "End Date",
          label: "End Date",
          field: (row) => row.endDate,
          align: "center",
          sortable: false,
        },
        {
          name: "Actions",
          label: "Actions",
          field: "Actions",
          align: "center",
          sortable: false,
        },
      ],
    };
  },
});
</script>
