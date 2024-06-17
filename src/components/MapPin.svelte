<script lang="ts">
  import { base } from "$app/paths";
  import type { TCatchmentInfo } from "./types";

  export let info: TCatchmentInfo;
  export let onHover: (
    info: TCatchmentInfo
  ) => (info: TCatchmentInfo) => void | undefined;

  let onHoverDone: (info: TCatchmentInfo) => void | undefined;
</script>

<!-- svelte-ignore a11y-no-static-element-interactions -->
<!-- svelte-ignore a11y-mouse-events-have-key-events -->
<div
  class="pin"
  on:mouseover={() => {
    onHoverDone = onHover(info);
  }}
  on:mouseout={() => {
    if (onHoverDone) {
      onHoverDone(info);
    }
  }}
>
  <a
    class="pin"
    href={`${base}/station/${info.code}`}
    title={info.name}
    aria-label={`Page de la station ${info.name}`}
  >
    <svg
      width="290"
      height="290"
      version="1.1"
      viewBox="0 0 290 290"
      xml:space="preserve"
      xmlns="http://www.w3.org/2000/svg"
    >
      <g transform="translate(-230.66 38.958)">
        <path
          d="m375.66-33.539s-12.454 28.419-26.102 50.865c-13.647 22.447-42.156 56.843-54.824 83.551s-16.771 72.659-0.2207 99.551c16.55 26.892 40.79 45.183 81.146 45.195 40.357 0.0126 64.596-18.278 81.146-45.17s12.446-72.843-0.22266-99.551c-12.668-26.708-41.175-61.104-54.822-83.551s-26.102-50.891-26.102-50.891zm-65.68 179.68c1.3173 27.431 6.3793 36.047 19.25 50.936 12.871 14.888 29.737 19.81 51.008 24.662-25.378 1.9852-44.295-1.9971-57.314-14.809-13.019-12.812-20.072-32.815-12.943-60.789z"
        />
      </g>
    </svg>
  </a>
</div>

<style>
  .pin {
    --size: 2rem;
    width: var(--size);
    height: var(--size);
    background-color: transparent;
  }
  svg {
    width: 100%;
    height: 100%;
  }

  .pin path {
    fill: #33c9ff;
  }
  .pin:hover path {
    fill: orange;
  }
</style>
