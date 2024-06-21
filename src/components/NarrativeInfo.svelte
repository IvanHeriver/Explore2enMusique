<script lang="ts">
  import MarkdownRenderer from "./MarkdownRenderer.svelte";
  import type { TNarrativeDetail } from "./types";

  export let narrative: TNarrativeDetail;
</script>

<div class="narrative">
  <h2>
    <div class="circle" style={`background-color: ${narrative.color}`}></div>
    {narrative.title}
  </h2>
  <div class="desc">
    <MarkdownRenderer markdown={narrative.markdown} />
  </div>
</div>

<style>
  h2 {
    --size: 1.5rem;
    display: grid;
    grid-template-columns: var(--size) auto;
    align-items: center;
    gap: 1rem;
  }
  .circle {
    width: var(--size);
    height: var(--size);
    border-radius: 50%;
  }
</style>
