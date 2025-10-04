<script setup>
import { ref, onMounted } from 'vue';
import { listItems, castVotes } from '../api';

const items = ref([]);
const voter = ref('');
const selected = ref(new Set());
const loading = ref(false);
const msg = ref('');

onMounted(async () => {
  await reload();
});

async function reload() {
  loading.value = true;
  msg.value = '';
  try {
    items.value = await listItems();
  } catch (e) {
    msg.value = '載入清單失敗';
  } finally {
    loading.value = false;
  }
}

function toggle(id) {
  if (selected.value.has(id)) selected.value.delete(id);
  else selected.value.add(id);
}

async function submit() {
  msg.value = '';
  const ids = Array.from(selected.value);
  if (!voter.value.trim() || ids.length === 0) {
    msg.value = '請輸入投票人名，並且至少選一個項目';
    return;
  }
  loading.value = true;
  try {
    await castVotes(voter.value.trim(), ids);
    msg.value = '投票成功！';
    selected.value.clear();
    await reload();
  } catch (e) {
    msg.value = e?.response?.data?.error || '投票失敗';
  } finally {
    loading.value = false;
  }
}
</script>

<template>
  <div>
    <h2>使用者投票</h2>
    <div style="margin:8px 0">
      <label>投票人：</label>
      <input v-model="voter" placeholder="請輸入姓名" />
      <button :disabled="loading" @click="submit">送出投票</button>
      <span style="margin-left:8px;color:#c00">{{ msg }}</span>
    </div>

    <div v-if="loading">載入中...</div>
    <table v-else border="1" cellpadding="6" cellspacing="0">
      <thead>
        <tr><th>選項</th><th>票數</th><th>啟用</th><th>勾選</th></tr>
      </thead>
      <tbody>
        <tr v-for="it in items" :key="it.id">
          <td>{{ it.name }}</td>
          <td>{{ it.total ?? 0 }}</td>
          <td>{{ it.enabled ? '是' : '否' }}</td>
          <td>
            <input type="checkbox"
                   :disabled="!it.enabled"
                   :checked="selected.has(it.id)"
                   @change="toggle(it.id)" />
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>
