import axios from 'axios';

// 後端跑在 8080
export const api = axios.create({
  baseURL: 'http://localhost:8080',
  timeout: 10000,
});

// 清單
export const listItems = async () => {
  const { data } = await api.get('/api/items');
  return data;
};

// 投票
export const castVotes = async (voter, itemIds) => {
  const { data } = await api.post('/api/votes', { voter, itemIds });
  return data;
};

// 後台
export const addItem = async (name) => {
  const { data } = await api.post('/api/admin/items', null, { params: { name } });
  return data;
};

export const updateItem = async (id, name, enabled) => {
  const { data } = await api.put(`/api/admin/items/${id}`, null, {
    params: { name, enabled }
  });
  return data;
};

export const deleteItem = async (id) => {
  const { data } = await api.delete(`/api/admin/items/${id}`);
  return data;
};
