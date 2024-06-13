<script lang="ts">
  import CatchmentInfo from "./CatchmentInfo.svelte";
  import type { TCatchmentInfo } from "./process_station_data";
  export let info: TCatchmentInfo;
  // export let close_cb: () => void;
</script>

<div class="container">
  <CatchmentInfo {info} />
  <!-- <button
    class="close"
    on:click={() => {
      close_cb();
    }}
  >
    &#10006;
  </button> -->
</div>

<style>
  .container {
    padding: 1rem;
    /* padding-top: 2rem; */
    /* background-color: white; */
    position: relative;
    max-width: 100vw;
    border-radius: var(--border-radius);
  }

  /* .close {
    position: absolute;
    inset: 0.25rem 0.25rem auto auto;
  } */
</style>
