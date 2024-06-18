<script lang="ts">
  import About from "../../components/About.svelte";
  import MarkdownRenderer from "../../components/MarkdownRenderer.svelte";

  export let data;
</script>

<About
  explore2={data.explore2}
  narratives={data.narratives}
  sonification={data.sonification}
/>
