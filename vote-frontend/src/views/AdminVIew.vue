<script setup>
import { ref, onMounted } from 'vue';
import { listItems, addItem, updateItem, deleteItem } from '../api';

const items = ref([]);
const name = ref('');
const msg = ref('');
const loading = ref(false);

onMounted(reload);

async function reload() {
  loading.value = true;
  msg.value = '';
  try { items.value = await listItems(); }
  catch { msg.value = '載入失敗'; }
  finally { loading.value = false; }
}

async function doAdd() {
  if (!name.value.trim()) return msg.value = '名稱必填';
  try {
    await addItem(name.value.trim());
    name.value = '';
    await reload();
  } catch (e) { msg.value = '新增失敗'; }
}

async function doToggle(it) {
  const en = it.enabled ? 0 : 1;
  try { await updateItem(it.id, it.name, en); await reload(); }
  catch { msg.value = '更新失敗'; }
}

async function doDelete(id) {
  try { await deleteItem(id); await reload(); }
  catch { msg.value = '刪除失敗'; }
}
</script>

<template>
  <div>
    <h2>後台管理</h2>
    <div style="margin:8px 0">
      <input v-model="name" placeholder="新項目名稱" />
      <button @click="doAdd">新增</button>
      <span style="margin-left:8px;color:#c00">{{ msg }}</span>
    </div>

    <div v-if="loading">載入中...</div>
    <table v-else border="1" cellpadding="6" cellspacing="0">
      <thead>
        <tr><th>ID</th><th>名稱</th><th>票數</th><th>啟用</th><th>操作</th></tr>
      </thead>
      <tbody>
        <tr v-for="it in items" :key="it.id">
          <td>{{ it.id }}</td>
          <td>{{ it.name }}</td>
          <td>{{ it.total ?? 0 }}</td>
          <td>{{ it.enabled ? '是' : '否' }}</td>
          <td>
            <button @click="doToggle(it)">{{ it.enabled ? '停用' : '啟用' }}</button>
            <button @click="doDelete(it.id)" style="margin-left:6px">刪除</button>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
