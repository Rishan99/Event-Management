<template>
  <q-page>
    <q-card flat class="no-border-radius">
      <q-toolbar class="bg-grey-2">
        <q-toolbar-title class="text-primary">Ticket Payments</q-toolbar-title>
      </q-toolbar>
      <q-separator />
      <q-card-section>
        <q-table
          square
          :rows="ticketPayments"
          :loading="tableLoading"
          :filter="filter"
          :columns="columns"
          :pagination="pagination"
          style="table-layout: fixed"
          binary-state-sort
        >
          <template v-slot:body="props">
            <tr :key="props.row.id">
              <td class="text-center">{{ ticketPayments.indexOf(props.row) + 1 }}</td>
              <td class="text-center">
                {{ props.row.event?.name ?? "" }}
              </td>
              <td class="text-center">
                {{ props.row.aspNetUser?.userName ?? props.row.aspNetUser?.userName }}
              </td>
              <td class="text-center">{{ props.row.amount }}</td>
              <td class="text-center">
                {{
                  props.row.createdDate == null ? "" : props.row.createdDate.split("T")[0]
                }}
              </td>
              <td class="text-center">
                {{ props.row.ticketStatus?.name }}
              </td>
              <td class="text-center" v-if="props.row.ticketStatusId == 1">
                <q-btn
                  unelevated
                  round
                  class="q-ml-xs"
                  size="xs"
                  color="primary"
                  icon="mdi-thumb-up"
                  @click="onApprove(props.row.id)"
                >
                  <q-tooltip> Edit </q-tooltip> </q-btn
                ><q-btn
                  unelevated
                  round
                  class="q-ml-xs"
                  size="xs"
                  color="orange"
                  icon="mdi-thumb-down"
                  @click="onReject(props.row.id)"
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
    let ticketPayments = ref([]);
    const $q = useQuasar();
    const route = useRoute();
    const router = useRouter();
    let tableLoading = ref(false);
    let filter = ref("");
    const getAllticketPayments = async () => {
      const response = await api.get(`ticket/list`);
      ticketPayments.value = response.data;
    };

    const onDelete = async (id) => {
      $q.dialog({
        title: "Confirm",
        message: `Are you sure you want to delete this Ticket Payment?`,
        cancel: true,
        persistent: true,
      }).onOk(async () => {
        try {
          $q.loading.show();
          let response = await api.post(`ticket/delete`, {
            id: id,
          });
          await getAllticketPayments();
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
    const onApprove = async (id) => {
      $q.dialog({
        title: "Confirm",
        message: `Are you sure you want to approve this Ticket Payment?`,
        cancel: true,
        persistent: true,
      }).onOk(async () => {
        try {
          $q.loading.show();
          let response = await api.post(`ticket/approve`, {
            id: id,
          });
          await getAllticketPayments();
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
    const onReject = async (id) => {
      $q.dialog({
        title: "Confirm",
        message: `Are you sure you want to reject this Ticket Payment?`,
        cancel: true,
        persistent: true,
      }).onOk(async () => {
        try {
          $q.loading.show();
          let response = await api.post(`ticket/reject`, {
            id: id,
          });
          await getAllticketPayments();
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
        await getAllticketPayments();
      } catch (ex) {
        handleError(ex);
      }
      $q.loading.hide();
    });

    return {
      getAllticketPayments,
      ticketPayments,
      tableLoading,
      onDelete,
      onApprove,
      onReject,
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
          name: "Event Name",
          label: "Event Name",
          field: (row) => row.name,
          align: "center",
          sortable: false,
        },
        {
          name: "Bought By",
          label: "Bought By",
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
          name: "Bought Date",
          label: "Bought Date",
          field: (row) => row.createdDate,
          align: "center",
          sortable: false,
        },

        {
          name: "Status",
          label: "Status",
          field: (row) => row.ticketStatus?.name
          ,
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
