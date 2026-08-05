<template>
  <div class="password-input-container">
    <input
      ref="inputRef"
      v-bind="$attrs"
      :type="showPassword ? 'text' : 'password'"
      :value="modelValue"
      @input="$emit('update:modelValue', ($event.target as HTMLInputElement).value)"
      class="input input--password"
    />
    <button
      type="button"
      class="password-toggle-btn"
      @click="toggleShow"
      tabindex="-1"
      :aria-label="showPassword ? 'Hide password' : 'Show password'"
    >
      <i class="material-icons">{{ showPassword ? 'visibility_off' : 'visibility' }}</i>
    </button>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from "vue";

defineOptions({
  inheritAttrs: false,
});

defineProps<{
  modelValue: string;
}>();

defineEmits<{
  (e: "update:modelValue", value: string): void;
}>();

const inputRef = ref<HTMLInputElement | null>(null);
const showPassword = ref(false);
const toggleShow = () => {
  showPassword.value = !showPassword.value;
};

onMounted(() => {
  if (inputRef.value && inputRef.value.parentElement) {
    inputRef.value.parentElement.focus = () => {
      inputRef.value?.focus();
    };
  }
});

defineExpose({
  focus: () => inputRef.value?.focus(),
});
</script>

<style scoped>
.password-input-container {
  position: relative;
  display: block;
  width: 100%;
}

.input--password {
  padding-right: 2.5em !important;
}

.password-toggle-btn {
  position: absolute;
  right: 0.5em;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  cursor: pointer;
  padding: 0.25em;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--textPrimary);
  opacity: 0.85;
  transition: opacity 0.2s ease, color 0.2s ease, transform 0.2s ease;
}

.password-toggle-btn:hover {
  opacity: 1;
  transform: translateY(-50%) scale(1.05);
}

.password-toggle-btn .material-icons {
  font-size: 1.5rem;
  user-select: none;
}
</style>
