<script lang="ts">
  import About from "../../components/About.svelte";
  export let data;
</script>

<About explore2={data.explore2} links={true} sonification={data.sonification} />
