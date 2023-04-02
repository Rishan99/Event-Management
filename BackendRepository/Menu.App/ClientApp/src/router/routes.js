const routes = [
  {
    path: "/",
    component: () => import("layouts/MainLayout.vue"),
    meta: { requiresAuth: true },
    children: [
      { path: "", component: () => import("pages/Index.vue") },
      { path: "dashboard", component: () => import("pages/Dashboard.vue") },
      {
        path: "event",
        component: () => import("pages/Event/Index.vue"),
        meta: { requiresAuth: true, menuId: 1 },
        children: [
          {
            path: "list",
            component: () => import("pages/Event/List.vue"),
            meta: { menuId: 1, requiresAuth: true },
          },
          {
            path: "new",
            component: () => import("pages/Event/New.vue"),
            meta: { menuId: 1, requiresAuth: true },
          },
          {
            path: ":id/edit",
            component: () => import("pages/Event/New.vue"),
            meta: { menuId: 1, requiresAuth: true },
          },
        ],
      },
      {
        path: "ticket-payment",
        component: () => import("pages/TicketPayment/Index.vue"),
        meta: { requiresAuth: true, menuId: 1 },
        children: [
          {
            path: "list",
            component: () => import("pages/TicketPayment/List.vue"),
            meta: { menuId: 1, requiresAuth: true },
          }
        ],
      },

    ],
  },
  {
    path: "/login",
    component: () => import("pages/Login.vue"),
  },

  // Always leave this as last one,
  // but you can also remove it
  {
    path: "/:catchAll(.*)*",
    component: () => import("pages/Error404.vue"),
  },
];

export default routes;
