import dayjs from "dayjs";
import { Notify } from "quasar";
const { serializeError } = require("serialize-error");

const handleError = function (error) {
  const serialized = serializeError(error);
  if (error.hasOwnProperty("response")) {
    Notify.create({
      message: error.response.data,
      color: "negative",
      icon: "warning",
    });
  } else if (serialized.hasOwnProperty("message")) {
    Notify.create({
      message: serialized.message,
      color: "negative",
      icon: "warning",
    });
  } else alert("3");
  Notify.create({
    message: error.response.data,
    color: "negative",
    icon: "warning",
  });
};

const dateFormat = function (date, format) {
  return dayjs(`${date}`).format(format);
};

export { handleError, dateFormat };
