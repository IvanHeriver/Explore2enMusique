<script lang="ts">
  import CatchmentInfo from "./CatchmentInfo.svelte";
  import CatchmentVideoCard from "./CatchmentVideoCard.svelte";
  import type { TCatchmentData, TNarrativeDetail } from "./types";

  export let narratives: TNarrativeDetail[];
  export let catchment: TCatchmentData;
  export let close_cb: () => void;

  let current_video_element: HTMLVideoElement | null;
  function handlePlay(video_element: HTMLVideoElement) {
    if (current_video_element && current_video_element !== video_element) {
      current_video_element.pause();
    }
    current_video_element = video_element;
  }
</script>

<div class="container">
  <button
    class="close"
    on:click={() => {
      close_cb();
    }}
  >
    &#10006;
  </button>
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
    /* padding: 0.5rem;
    background-color: rgba(255, 255, 255, 0.8);
    border-radius: var(--border-radius);
    position: absolute;
    inset: 0; */

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
        minmax(500px, 1fr)
      ); /* Larger minimum width for larger screens */
    }
  }

  .close {
    position: fixed;
    /* inset: 0.5rem 0.5rem auto auto; */
    inset: calc(var(--header-height) + 1rem) auto auto 1rem;
    width: 2rem;
    height: 2rem;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: large;
  }
</style>
