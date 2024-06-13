<script lang="ts">
  import type { TDataInfo } from "./process_station_data";

  export let info: TDataInfo;
</script>

<div class="sim-info">
  <div class="gcm" title={`Modèle climatique global (GCM): ${info.gcm}`}>
    {info.gcm}
  </div>
  <div class="proj" title={`Projection: ${info.proj}`}>
    {info.proj}
  </div>
  <div class="rcm" title={`Modèle climatique régional (RCM): ${info.rcm}`}>
    {info.rcm}
  </div>
  <div class="bc" title={`Correction des biais: ${info.bias_correction}`}>
    {info.bias_correction}
  </div>
  <div class="hm" title={`Modèle hydrologique: ${info.hydro_model}`}>
    {info.hydro_model}
  </div>
</div>

<style>
  .sim-info {
    padding: 0.25rem;
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
    font-weight: bold;
  }

  /* .sim-info > * {
    position: relative;
  }
  .sim-info > *:not(:first-child)::after {
    --w: 2px;
    position: absolute;
    content: "";
    height: 100%;
    width: var(--w);
    left: calc(-0.25rem - var(--w) / 2);
    background-color: var(--main-color);
  } */
</style>
