<script lang="ts">
  import MarkdownRenderer from "./MarkdownRenderer.svelte";

  export let explore2: string | null;
  export let sonification: string | null;
</script>

{#if explore2}
  <MarkdownRenderer markdown={explore2} />
{/if}

{#if sonification}
  <MarkdownRenderer markdown={sonification} />
{/if}
