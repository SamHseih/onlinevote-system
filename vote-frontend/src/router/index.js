import { createRouter, createWebHistory } from 'vue-router';
import HomeView from '../views/HomeView.vue';
import VoteView from '../views/VoteView.vue';
import AdminView from '../views/AdminView.vue';

const routes = [
  { path: '/', name: 'home', component: HomeView },
  { path: '/vote', name: 'vote', component: VoteView },
  { path: '/admin', name: 'admin', component: AdminView },
  { path: '/:pathMatch(.*)*', redirect: '/' },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
