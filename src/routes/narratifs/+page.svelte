<script lang="ts">
  import NarrativeInfo from "../../components/NarrativeInfo.svelte";
  export let data;
</script>

<h1>Quatre visions contrastées du futur issues d'<b>Explore2</b></h1>
{#each data.narratives as narrative}
  <NarrativeInfo {narrative} />
{/each}
