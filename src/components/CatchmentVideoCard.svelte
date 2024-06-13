<script lang="ts">
  import SimulationInfo from "./SimulationInfo.svelte";
  import type { TDataInfo } from "./process_station_data";

  export let data: TDataInfo;
  export let onPlay: (video_element: HTMLVideoElement) => void;
  let video_element: HTMLVideoElement;
</script>

<div class="container">
  <div class="info"><SimulationInfo info={data} /></div>
  <div class="video">
    <!-- svelte-ignore a11y-media-has-caption -->
    <video
      bind:this={video_element}
      controls
      width="640"
      height="360"
      on:play={() => onPlay(video_element)}
    >
      <source
        src={`https://explore2enmusique.s3.sbg.io.cloud.ovh.net/${data.fullname}.mp4`}
        type="video/mp4"
      />
      Your browser does not support the video tag.
    </video>
  </div>
</div>

<style>
  .container {
    border: 1px solid var(--main-color);
    padding: 0.25rem;
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
    background-color: white;
    border-radius: var(--border-radius);
  }
  video {
    max-width: 100%;
    height: auto;
  }
</style>
