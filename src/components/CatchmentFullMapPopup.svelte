<script lang="ts">
  import BackButton from "./BackButton.svelte";
  import CatchmentInfo from "./CatchmentInfo.svelte";
  import CatchmentVideoCard from "./CatchmentVideoCard.svelte";
  import type { TCatchmentData, TNarrativeDetail } from "./types";

  export let narratives: TNarrativeDetail[];
  export let catchment: TCatchmentData;

  let current_video_element: HTMLVideoElement | null;
  function handlePlay(video_element: HTMLVideoElement) {
    if (current_video_element && current_video_element !== video_element) {
      current_video_element.pause();
    }
    current_video_element = video_element;
  }
</script>

<div class="container">
  <div class="title">
    <CatchmentInfo info={catchment.info} />
  </div>
  <div class="videos">
    {#each catchment.data as d (d.fullname)}
      <CatchmentVideoCard data={d} {narratives} onPlay={handlePlay} />
    {/each}
  </div>
</div>

<style>
  .container {
    display: flex;
    flex-direction: column;
    gap: 0.25rem;
  }

  .title {
    display: flex;
    justify-content: center;
    align-items: center;
  }

  .videos {
    max-height: 100%;
    overflow: auto;
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    justify-items: center;
    gap: 0.25rem;
    background-color: var(--light-color);
    border-radius: var(--border-radius);
    padding: 0.5rem;
  }

  @media (min-width: 600px) {
    .videos {
      grid-template-columns: repeat(
        auto-fit,
        minmax(300px, 1fr)
      ); /* Larger minimum width for larger screens */
    }
  }
</style>
