<script setup>
// 可放全域 layout，例如 Navbar
</script>

<template>
  <div style="padding:16px">
    <nav style="margin-bottom:12px">
      <a href="/" style="margin-right:12px">首頁</a>
      <a href="/vote" style="margin-right:12px">投票頁</a>
      <a href="/admin">後台</a>
    </nav>
    <router-view />
  </div>
</template>

<style>
/* 先不要用 scoped，避免白畫面時什麼都看不到 */
</style>