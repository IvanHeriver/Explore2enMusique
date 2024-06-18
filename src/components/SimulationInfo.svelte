<script lang="ts">
  import { onMount } from "svelte";
  import type { TDataInfo, TNarrativeConfig, TNarrativeDetail } from "./types";

  export let narratives: TNarrativeDetail[];
  export let info: TDataInfo;

  function identifyNarrative(info: TDataInfo): TNarrativeDetail | undefined {
    const narrative_configs: TNarrativeConfig[] = [
      {
        gcm: ["MOHC", "HadGEM2-ES"],
        rcm: ["CNRM", "ALADIN63"],
        name: "euphorbe",
      },
      {
        gcm: ["CNRM", "CERFACS", "CNRM-CM5"],
        rcm: ["CNRM", "ALADIN63"], // none (CNRM-CERFACS-CNRM-CM5/CNRM-ALADIN63)
        name: "narcisse",
      },
      {
        gcm: ["ICHEC", "EC-EARTH"],
        rcm: ["MOHC", "HadREM3-GA7"],
        name: "dahlia",
      },
      {
        gcm: ["MOHC", "HadGEM2-ES"],
        rcm: ["CLMcom", "CCLM4-8-17"],
        name: "aster",
      },
    ];
    const narrative_config = narrative_configs.find((n) => {
      if (n.gcm.length == 0 && n.rcm.length == 0) return false;
      return (
        n.gcm.some((s) => info.fullname.includes(s)) &&
        n.rcm.some((s) => info.fullname.includes(s))
      );
    });
    if (narrative_config) {
      return narratives.find((n) => n.name === narrative_config.name);
    }
  }

  onMount(() => {
    narrative = identifyNarrative(info);
  });

  let narrative: TNarrativeDetail | undefined;
</script>

{#if narrative}
  <div class="container" style={`--color: ${narrative.color}`}>
    <div class="label">
      <div class="text">
        {narrative.title}
      </div>
    </div>
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
  </div>
{/if}

<style>
  .sim-info {
    padding: 0.25rem;
    display: flex;
    flex-wrap: wrap;
    gap: 0.5rem;
    font-weight: 200;
    font-size: small;
    justify-content: center;
  }
  .label {
    font-weight: bold;
    text-align: center;
    border-bottom: 5px solid var(--color, transparent);
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
  }
  .label .text {
    font-size: 1.2rem;
  }
</style>
