<script lang="ts">
  import { onMount } from "svelte";
  import type { TCatchmentData } from "../../../components/types.js";
  import CatchmentFullMapPopup from "../../../components/CatchmentFullMapPopup.svelte";

  export let data;

  let catchment: TCatchmentData | undefined;
  onMount(() => {
    const catchments: TCatchmentData[] = [...data.data.values()];
    const c = catchments.find((c) => c.info.code === data.code);
    if (!c) {
      return;
    }
    catchment = c;
  });
</script>

{#if catchment}
  <CatchmentFullMapPopup
    {catchment}
    close_cb={() => {
      history.back();
    }}
  />
{/if}
