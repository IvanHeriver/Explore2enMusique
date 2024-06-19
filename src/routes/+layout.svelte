<script lang="ts">
  import Map from "../components/Map.svelte";
  import type { TCatchmentData } from "../components/types";
  import NavBar from "../components/NavBar.svelte";

  import { page } from "$app/stores";
  import Welcome from "../components/Welcome.svelte";
  import { base } from "$app/paths";
  import BackButton from "../components/BackButton.svelte";

  export let data;
  let catchments: TCatchmentData[] = [...data.data.values()];
</script>

<link rel="icon" href="{base}/water_drop.svg" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="stylesheet" href="{base}/styles.css" />
<link rel="stylesheet" href="{base}/markdown.styles.css" />
<link rel="stylesheet" href="{base}/ol.styles.css" />

<div class="wrapper" class:root={$page.url.pathname === `${base}/`}>
  <header>
    <div class="logo">
      <a href="{base}/"
        ><img src="{base}/explore2_logo_color.png" alt="Logo" /></a
      >
    </div>
    <NavBar />
  </header>
  <Welcome
    short={data.short}
    explore2={data.explore2}
    sonification={data.sonification}
  />
  <div class="map">
    <div class="map-overlay"></div>
    <Map {catchments} />
  </div>
  <main>
    <div class="container">
      <BackButton />
      <slot />
    </div>
  </main>
  <footer>
    <div class="copyright">&copy; 2024 Explore2</div>
    <!-- <div class="source">
      code source: <a
        href="https://github.com/IvanHeriver/explore2enmusique/"
        target="_blank"
      >
        https://github.com/IvanHeriver/explore2enmusique/
      </a>
    </div> -->
    <!-- <div class="developer">
      Siteweb développé par <a href="https://www.ihdev.fr" target="_blank">
        ihdev.fr
      </a>
    </div> -->
  </footer>
</div>

<style>
  /* general structure */
  .wrapper {
    min-height: 100dvh;
    display: flex;
    flex-direction: column;
    align-items: center;

    --header-height: 4rem;
    --footer-height: 1.5rem;
  }
  main {
    height: 100%;
    flex-grow: 1;
    width: 100%;
    padding: 1rem;
    position: relative;
    background-color: color-mix(
      in srgb,
      white,
      transparent var(--transparency_pc)
    );
    z-index: 2;
    display: grid;
    justify-items: center;
  }
  main .container {
    max-width: 900px;
    width: 100%;
  }

  header,
  footer {
    z-index: 100;
    background-color: color-mix(
      in srgb,
      white,
      transparent var(--transparency_pc)
    );
    width: 100%;
  }
  /* header */
  header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding-inline: 0.5rem;
    width: 100%;
    height: var(--header-height);
    position: sticky;
    top: 0;
    box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.5);
  }
  .logo img {
    max-height: var(--header-height);
  }

  /* footer */
  footer {
    padding: 0.25rem;
    display: grid;
    place-items: center;
    font-size: small;
    height: var(--footer-height);
  }

  /* special root case */
  .wrapper.root main {
    z-index: -2;
  }
</style>
