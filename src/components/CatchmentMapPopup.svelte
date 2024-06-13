<script lang="ts">
  import CatchmentInfo from "./CatchmentInfo.svelte";
  import type { TCatchmentInfo } from "./process_station_data";
  export let info: TCatchmentInfo;
</script>

<div class="container">
  <CatchmentInfo {info} />
</div>

<style>
  .container {
    padding: 1rem;
    position: relative;
    max-width: 100vw;
    border-radius: var(--border-radius);
  }
</style>
