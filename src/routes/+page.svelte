<script lang="ts">
  import Map from "../components/Map.svelte";
  export let data;
</script>

<div class="map">
  <Map catchments={[...data.data.values()]} />
</div>
