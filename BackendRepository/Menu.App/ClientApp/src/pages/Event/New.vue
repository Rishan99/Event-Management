<template>
  <q-page>
    <q-card flat class="no-border-radius">
      <q-toolbar class="bg-grey-2">
        <q-toolbar-title class="text-primary">New Event</q-toolbar-title>
      </q-toolbar>
      <q-separator />
      <q-card-section>
        <q-form @submit="onSubmit">
          <div class="row q-col-gutter-lg">
            <div class="col-md-6">
              <q-input
                square
                outlined
                dense
                label="Name *"
                v-model="eventDetail.name"
                :rules="[(val) => (val && val.trim().length > 0) || 'Name is required']"
              ></q-input>

              <q-input
                v-model="eventDetail.city"
                outlined
                square
                dense
                label="City"
                :rules="[(val) => (val && val.trim().length > 0) || 'City is required']"
              />

              <q-input
                v-model="eventDetail.address"
                outlined
                square
                dense
                label="Address"
                :rules="[
                  (val) => (val && val.trim().length > 0) || 'Address is required',
                ]"
              />

              <q-input
                v-model="eventDetail.ticketPrice"
                outlined
                square
                dense
                step="any"
                type="number"
                label="Ticket Price *"
                :rules="[(val) => (val && val >= 0) || 'Value is required']"
              />
              <q-select
                square
                outlined
                dense
                v-model="eventDetail.ticketTypeId"
                label="Ticket Type"
                input-debounce="0"
                :options="ticketTypeList"
                option-label="name"
                emit-value
                map-options
                behavior="menu"
                :rules="[(val) => val || 'Value is required']"
                :loading="loading"
                option-value="id"
              />
              <q-input
                filled
                v-model="eventDetail.startDate"
                label="Event Start Date"
                mask="date"
                :rules="['date']"
              >
                <template v-slot:append>
                  <q-icon name="event" class="cursor-pointer">
                    <q-popup-proxy>
                      <q-date
                        v-model="eventDetail.startDate"
                        :options="startDatePickerLimit"
                      ></q-date>
                    </q-popup-proxy>
                  </q-icon>
                </template>
              </q-input>
              <q-input
                filled
                v-model="eventDetail.endDate"
                label="Event End Date"
                mask="date"
                :rules="['date']"
              >
                <template v-slot:append>
                  <q-icon name="event" class="cursor-pointer">
                    <q-popup-proxy>
                      <q-date
                        v-model="eventDetail.endDate"
                        :options="expiryDatePickerLimit"
                      ></q-date>
                    </q-popup-proxy>
                  </q-icon>
                </template>
              </q-input>
            </div>
            <div style="width: 50%">
              <q-input
                v-model="eventDetail.description"
                outlined
                square
                dense
                type="textarea"
                label="Description"
              />
              <q-file
                style="margin-top: 20px"
                v-model="images"
                accept="image/*"
                multiple
                outlined
                square
                dense
                label="Select Event Images"
                clearable
              />
              <div style="margin-top: 20px">
                <q-list bordered v-for="item in preSelectedImages" :key="item.id">
                  <q-item>
                    <q-item-section avatar>
                      <img :src="item.imageName" style="height: 60px; width: 80px" />
                    </q-item-section>
                    <q-item-section>{{ item.imageName.split("/").pop() }}</q-item-section>
                    <q-item-section avatar>
                      <q-icon
                        @click="onPreselectedImageDelete(item.id)"
                        color="red"
                        name="delete"
                      />
                    </q-item-section>
                  </q-item>
                </q-list>
              </div>
            </div>
          </div>
          <q-btn
            style="margin-top: 20px"
            unelevated
            type="submit"
            color="primary"
            label="Submit"
            square
          ></q-btn>
        </q-form>
      </q-card-section>
    </q-card>
  </q-page>
</template>

<script>
import { defineComponent, ref, onMounted, watch } from "vue";
import { handleError } from "boot/utility";
import { api } from "boot/axios";
import { useQuasar, Loading, Notify } from "quasar";
import { useRouter, useRoute } from "vue-router";
import { useStore } from "vuex";
import dayjs from "dayjs";

export default defineComponent({
  setup() {
    const router = useRouter();
    const route = useRoute();
    const $q = useQuasar();
    const store = useStore();
    let loading = ref(false);
    let ticketTypeList = ref([]);
    let images = ref([]);
    let preSelectedImages = ref([]);
    let deletedImages = ref([]);

    let eventDetail = ref({
      id: null,
      name: null,
      city: null,
      address: null,
      startDate: dayjs().format(),
      endDate: null,
      ticketTypeId: null,
      ticketPrice: null,
      description: null,
    });

    const getTicketTypeList = async () => {
      const response = await api.get(`general/ticket-type`);
      ticketTypeList.value = response.data;
    };
    function getNullOrParseInt(value) {
      let tempInt = value;
      tempInt = parseInt(tempInt);
      if (isNaN(tempInt)) {
        return null;
      } else {
        return tempInt;
      }
    }
    async function onSubmit() {
      try {
        $q.loading.show();
        let tempValue = eventDetail.value;
        let temp = dayjs(tempValue.startDate).format("YYYY-MM-DD");
        if (eventDetail.value.endDate) {
          const temp2 = dayjs(tempValue.endDate).format("YYYY-MM-DD");
          tempValue.endDate = temp2;
        }
        if (dayjs(tempValue.endDate).isBefore(dayjs(tempValue.startDate))) {
          throw new Error("End date must be after start date of an event");
        }
        tempValue.startDate = temp;
        let formData = new FormData();
        for (let p = 0; p < images.value.length; p++) {
          formData.append("files", images.value[p]);
        }
        if (deletedImages.value.length > 0) {
          formData.append("deletedImages", JSON.stringify(deletedImages.value));
        }
        formData.append("data", JSON.stringify(tempValue));
        let response = await api.post(
          route.params.id ? `event/${route.params.id}/update` : "event/insert",
          formData,
          {
            headers: {
              "Content-Type": "multipart/form-data",
            },
          }
        );
        $q.notify({
          type: "positive",
          message: "Event has been Added",
        });
        $q.loading.hide();
        router.push("/event/list");
      } catch (e) {
        $q.loading.hide();
        handleError(e);
      }
    }
    const getEventDetailById = async () => {
      const promocodeId = route.params.id;
      if (promocodeId == null) {
        return;
      }
      const response = await api.get(`event/${promocodeId}`);
      preSelectedImages.value = response.data.eventImages;
      eventDetail.value.id = response.data.id;
      eventDetail.value.name = response.data.name;
      eventDetail.value.city = response.data.city;
      eventDetail.value.address = response.data.address;
      eventDetail.value.startDate = response.data.startDate;
      eventDetail.value.endDate = response.data.endDate;
      eventDetail.value.startDate = response.data.startDate;
      eventDetail.value.ticketTypeId = response.data.ticketTypeId;
      eventDetail.value.ticketPrice = response.data.ticketPrice;
      eventDetail.value.description = response.data.description;
    };
    function startDatePickerLimit(date) {
      return true;
    }
    function onPreselectedImageDelete(id) {
      preSelectedImages.value = preSelectedImages.value.filter((x) => x.id != id);
      deletedImages.value.push(id);
    }
    function expiryDatePickerLimit(date) {
      return dayjs(date).isAfter(eventDetail.value.startDate);
    }

    onMounted(async () => {
      try {
        $q.loading.show();
        eventDetail.value.startDate = dayjs().format("YYYY-MM-DD");
        await Promise.all([getTicketTypeList(), getEventDetailById()]);
        $q.loading.hide();
      } catch (ex) {
        $q.loading.hide();
        handleError(ex);
      }
    });

    return {
      onSubmit,
      eventDetail,
      loading,
      ticketTypeList,
      startDatePickerLimit,
      onPreselectedImageDelete,
      expiryDatePickerLimit,
      preSelectedImages,
      images,
    };
  },
});
</script>

<style scoped>
body {
  margin: 40px;
}

.wrapper {
  display: grid;
  grid-template-columns: 100px 100px 100px;
  grid-gap: 10px;
  background-color: #fff;
  height: 100px;
  width: 100px;
  color: #444;
}

.box {
  background-color: #444;
  color: #fff;
  border-radius: 5px;
  padding: 20px;
  font-size: 150%;
}
</style>
