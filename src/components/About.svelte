<script lang="ts">
  import MarkdownRenderer from "./MarkdownRenderer.svelte";
  import NarrativeInfo from "./NarrativeInfo.svelte";
  import type { TNarrativeDetail } from "./types";

  export let explore2: string | null;
  export let sonification: string | null;
  export let narratives: TNarrativeDetail[] | null;
</script>

{#if explore2}
  <MarkdownRenderer markdown={explore2} />
{/if}

{#if sonification}
  <MarkdownRenderer markdown={sonification} />
{/if}

{#if narratives}
  <h1>Plusieurs narratifs</h1>
  {#each narratives as narrative}
    <NarrativeInfo {narrative} />
  {/each}
{/if}
