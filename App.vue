<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'

const items = ref([])
const selected = ref([])
const voter = ref('Sandy') // 測試用

const api = 'http://localhost:8080'

async function load() {
  const { data } = await axios.get(`${api}/vote/items`)
  items.value = data
}

async function submitVote() {
  await axios.post(`${api}/vote`, { voter: voter.value, itemIds: selected.value })
  selected.value = []
  await load()
}

onMounted(load)
</script>

<template>
  <main style="max-width:720px;margin:2rem auto;">
    <h2>線上投票</h2>
    <div v-for="it in items" :key="it.id" style="display:flex;gap:1rem;align-items:center">
      <input type="checkbox" :value="it.id" v-model="selected" />
      <span>{{ it.name }}</span>
      <b>票數：{{ it.votes }}</b>
    </div>
    <div style="margin-top:1rem">
      <input v-model="voter" placeholder="你的名字" />
      <button @click="submitVote">投票</button>
    </div>
  </main>
</template>

<style scoped>
.logo {
  height: 6em;
  padding: 1.5em;
  will-change: filter;
  transition: filter 300ms;
}
.logo:hover {
  filter: drop-shadow(0 0 2em #646cffaa);
}
.logo.vue:hover {
  filter: drop-shadow(0 0 2em #42b883aa);
}
</style>
