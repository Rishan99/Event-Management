import { handleError } from "boot/utility";
import { api } from "boot/axios";

export async function login(context, user) {
  try {
    context.commit("auth_request");
    var response = await api.post("auth/admin-login", user);
    const token = response.data.accessToken;
    if (!token) throw new Error("Unable to get token from response.");
    window.localStorage.setItem("token", token);
    api.defaults.headers.common["Authorization"] = `Bearer ${token}`;
    var userResponse = await api.get("auth/me");
    context.commit("auth_success", { token: token, user: userResponse.data });
  } catch (ex) {
    context.commit("auth_error");
    localStorage.removeItem("token");
    handleError(ex);
    throw new Error(ex);
  }
}

export function logout(context, user) {
  context.commit("logout");
  localStorage.removeItem("token");
  delete api.defaults.headers.common["Authorization"];
}
