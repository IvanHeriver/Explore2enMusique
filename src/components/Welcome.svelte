<script lang="ts">
  import { onMount } from "svelte";
  import About from "./About.svelte";
  import MarkdownRenderer from "./MarkdownRenderer.svelte";
  import { base } from "$app/paths";

  export let short: string;
  export let explore2: string;
  export let sonification: string;

  let show: boolean = true;
  onMount(() => {
    // should show?
    // I could store a date and time in LocaleStorage so I do not show the message if less than a day elapsed.
  });
</script>

{#if show}
  <div class="disabler">
    <button
      class="close"
      on:click={() => {
        show = false;
      }}
    >
      &#10006;
    </button>
    <div class="welcome">
      <img src="{base}/explore2_logo_color.png" alt="" />
      <h1>
        Bienvenue dans <b>Explore 2</b> <i>en musique</i>
      </h1>
      <div class="short">
        <MarkdownRenderer markdown={short} />
      </div>
      <About {explore2} {sonification} />
      <button
        class="access"
        on:click={() => {
          show = false;
        }}
      >
        Acceder au siteweb
      </button>
    </div>
  </div>
{/if}

<style>
  .disabler {
    position: absolute;
    inset: 0;
    background-color: rgba(255, 255, 255, 0.452);
    z-index: 101;
  }
  .welcome {
    position: absolute;
    top: 0.5rem;
    left: 50%;
    width: calc(100% - 1rem);
    max-width: 900px;
    transform: translateX(-50%);
    height: calc(100svh - 1rem);

    background-color: white;
    z-index: 102;
    border: 1px solid var(--main-color);
    border-radius: var(--border-radius);
    padding: 0.5rem;
    overflow: auto;

    display: flex;
    flex-direction: column;
    align-items: center;
  }

  img {
    width: 200px;
  }

  button {
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: large;
  }

  .access {
    padding: 1rem;
  }

  .close {
    z-index: 103;
    position: fixed;
    top: 2rem;
    left: max(2rem, calc(50% - 450px + 1rem));
    width: 2rem;
    height: 2rem;
  }
</style>
