<template>
  <div class="bg">
    <div class="row justify-center">
      <div class="col-12 col-md-3">
        <q-card flat square class="login">
          <q-toolbar dense class="bg-none text-center text-black">
            <q-toolbar-title>
              <q-img src="../../public/images/logo.png" width="400px" height="230px" />
            </q-toolbar-title>
          </q-toolbar>
          <q-card-section class="text-center q-mt-md loginForm">
            <q-form @submit="onLoginFormSubmit">
              <q-input
                v-model="user.username"
                label="Username"
                outlined
                :rules="[(val) => !!val || 'Username is required']"
              >
                <template v-slot:prepend>
                  <q-icon name="mdi-account-box" />
                </template>
              </q-input>

              <q-input
                :type="isPwd ? 'password' : 'text'"
                class="q-mt-xs"
                v-model="user.password"
                label="Password"
                outlined
                :rules="[(val) => !!val || 'Password is required']"
              >
                <template v-slot:prepend>
                  <q-icon name="mdi-lock" />
                </template>
                <template v-slot:append>
                  <q-icon
                    :name="isPwd ? 'visibility_off' : 'visibility'"
                    class="cursor-pointer"
                    @click="isPwd = !isPwd"
                  />
                </template>
              </q-input>
              <q-btn
                class="q-mt-xs"
                :disabled="formPosting"
                :loading="formPosting"
                type="submit"
                color="primary"
                label="LOGIN"
                square
              ></q-btn>
            </q-form>
          </q-card-section>
        </q-card>
      </div>
    </div>
  </div>
</template>

<script>
import { defineComponent, ref, onMounted } from "vue";
import { handleError } from "boot/utility";
import { useStore } from "vuex";
import { useRouter } from "vue-router";
import { useQuasar } from "quasar";

export default defineComponent({
  name: "PageIndex",
  setup() {
    const store = useStore();
    const router = useRouter();
    const $q = useQuasar();

    let user = ref({
      username: "",
      password: "",
    });
    let formPosting = ref(false);

    const onLoginFormSubmit = async () => {
      try {
        formPosting.value = true;
        await store.dispatch("auth/login", user.value);
        $q.notify({
          type: "positive",
          message: `Logged In Successfully!`,
        });
        router.push("/");
      } catch (ex) {
        formPosting.value = false;
        handleError(ex);
      }
    };

    return {
      isPwd: ref(true),

      user,
      onLoginFormSubmit,
      formPosting,
    };
  },
});
</script>
