import { vitePreprocess } from '@sveltejs/vite-plugin-svelte';

export default {
  preprocess: vitePreprocess({
    typescript: true, // Explicitly enable TypeScript preprocessing
  }),
};
