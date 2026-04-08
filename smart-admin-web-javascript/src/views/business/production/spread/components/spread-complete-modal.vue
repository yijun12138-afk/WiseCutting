<template>
  <a-modal v-model:open="visible" title="完成确认" @cancel="hide" @ok="hide">
    <div>该功能暂未启用。</div>
  </a-modal>
</template>

<script setup>
import { ref } from 'vue';

const visible = ref(false);

function show() {
  visible.value = true;
}

function hide() {
  visible.value = false;
}

defineExpose({
  show,
  hide,
  open: show,
});
</script>
