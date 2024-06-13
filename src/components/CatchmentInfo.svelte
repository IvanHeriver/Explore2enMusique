<script lang="ts">
  import type { TCatchmentInfo } from "./process_station_data";

  export let info: TCatchmentInfo;
</script>

<div class="catchment-info">
  <div class="name">{info.name}</div>
  <div class="code">{`(${info.code})`}</div>
</div>

<style>
  .catchment-info {
    display: flex;
    flex-direction: column;
    align-items: center;
    background-color: var(--light-color);
    border-radius: var(--border-radius);
    gap: 0.25rem;
    padding: 0.5rem;
  }

  .catchment-info > * {
    text-align: center;
  }

  .name {
    font-weight: bold;
    /* text-wrap: nowrap; */
  }
</style>
