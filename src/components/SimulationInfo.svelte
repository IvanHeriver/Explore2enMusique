<script lang="ts">
  import { onMount } from "svelte";
  import type { TDataInfo, TNarrative } from "./types";

  export let info: TDataInfo;

  const narratives: TNarrative[] = [
    {
      gcm: ["MOHC", "HadGEM2-ES"],
      rcm: ["CNRM", "ALADIN63"],
      color: "green",
      label: "Réchauffement marqué et augmentation des précipitations",
    },
    {
      gcm: ["CNRM", "CERFACS", "CNRM-CM5"],
      rcm: ["CNRM", "ALADIN63"], // none (CNRM-CERFACS-CNRM-CM5/CNRM-ALADIN63)
      color: "yellow",
      label: "Changements futurs relativement peu marqués",
    },
    {
      gcm: ["ICHEC", "EC-EARTH"],
      rcm: ["MOHC", "HadREM3-GA7"],
      color: "orange",
      label: "Fort réchauffement et fort assèchement en été (et en annuel)",
    },
    {
      gcm: ["MOHC", "HadGEM2-ES"],
      rcm: ["CLMcom", "CCLM4-8-17"],
      color: "violet",
      label:
        "Fort réchauffement et forts contrastes saisonniers en précipitations",
    },
  ];

  let narrative: TNarrative = {
    gcm: [],
    rcm: [],
    color: "none",
    label: "",
  };

  onMount(() => {
    const n = narratives.find((n) => {
      if (n.gcm.length == 0 && n.rcm.length == 0) return false;
      return (
        n.gcm.some((s) => info.fullname.includes(s)) &&
        n.rcm.some((s) => info.fullname.includes(s))
      );
    });
    if (n) {
      narrative = n;
    }
  });
</script>

<div
  class="container"
  class:green={narrative.color === "green"}
  class:yellow={narrative.color === "yellow"}
  class:orange={narrative.color === "orange"}
  class:violet={narrative.color === "violet"}
>
  <div class="label">
    <div class="text">
      {narrative.label}
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
  .green {
    --color: hsl(140, 29%, 37%);
  }
  .yellow {
    --color: hsl(58, 87%, 62%);
  }
  .orange {
    --color: hsl(37, 74%, 55%);
  }
  .violet {
    --color: hsl(323, 64%, 26%);
  }
</style>
