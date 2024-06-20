<script lang="ts">
  import About from "../../components/About.svelte";
  export let data;
</script>

<h1>À propos</h1>
<About explore2={data.explore2} links={true} sonification={data.sonification} />
