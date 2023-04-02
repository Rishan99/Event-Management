<template>
  <q-page>
    <q-card flat class="no-border-radius">
      <q-card-section>
        <div class="row q-col-gutter-md q-mt-md dashboard-card">
          <div class="col-12 col-md-3">
            <q-item clickable v-ripple class="bg-white text-black q-py-lg">
              <q-item-section>
                <p class="q-my-none">Users</p>
                <h5 class="q-my-none text-weight-bolder">
                  {{ dashBoardData.noOfUser }}
                </h5>
              </q-item-section>
              <q-item-section avatar>
                <q-icon
                  color="accent"
                  style="font-size: 3rem"
                  name="supervisor_account"
                />
              </q-item-section>
            </q-item>
          </div>
          <div class="col-12 col-md-3">
            <q-item clickable v-ripple class="bg-white text-black q-py-lg">
              <q-item-section>
                <p class="q-my-none">No Of Events</p>
                <h5 class="q-my-none text-weight-bolder">
                  {{ dashBoardData.noOfEvents }}
                </h5>
              </q-item-section>
              <q-item-section avatar>
                <q-icon color="positive" style="font-size: 3rem" name="quiz" />
              </q-item-section>
            </q-item>
          </div>
          <div class="col-12 col-md-3">
            <q-item clickable v-ripple class="bg-white text-black q-py-lg">
              <q-item-section>
                <p class="q-my-none">Tickets Sold</p>
                <h5 class="q-my-none text-weight-bolder">
                  {{ dashBoardData.noOfTicketsSold }}
                </h5>
              </q-item-section>
              <q-item-section avatar>
                <q-icon color="amber-14" style="font-size: 3rem" name="category" />
              </q-item-section>
            </q-item>
          </div>
        </div>
        <div class="q-mt-md">
          <q-separator></q-separator>
        </div>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script>
import { defineComponent, onMounted, ref } from "vue";
import { api } from "boot/axios";
import { handleError, dateFormat } from "boot/utility";
import { useStore } from "vuex";
import { useQuasar } from "quasar";
import { useRouter } from "vue-router";

export default defineComponent({
  setup() {
    const $q = useQuasar();
    const store = useStore();
    const router = useRouter();
    let temp = ref({});
    let dashBoardData = ref({
      noOfUser: 0,
      noOfEvents: 0,
      noOfTicketsSold: 0,
    });

    const getData = async () => {
      $q.loading.show({});
      try {
        let response = await api.get("general/dashboard-data");
        dashBoardData.value = response.data;
      } catch (error) {
        handleError(error);
      } finally {
        $q.loading.hide({});
      }
    };



    onMounted(async () => {
      $q.loading.show({});
      await getData();
      $q.loading.hide({});
    });
    return {
      dashBoardData,
    };
  },
});
</script>
