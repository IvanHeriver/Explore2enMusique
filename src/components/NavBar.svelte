<script lang="ts">
  import { base } from "$app/paths";

  import Icon from "./Icon.svelte";

  import { page } from "$app/stores";
</script>

<nav>
  <ul>
    <li>
      <a
        href="{base}/"
        title="carte"
        aria-label="afficher la carte"
        class:selected={$page.url.pathname === `${base}/`}
      >
        <Icon id="map" />
      </a>
    </li>
    <li>
      <a
        href="{base}/a_propos"
        title="à propos"
        aria-label="afficher les informations sur le site web"
        class:selected={$page.url.pathname === `${base}/a_propos`}
      >
        <Icon id="question" />
      </a>
    </li>
    <li>
      <a
        href="{base}/narratifs"
        title="Quatre visions contrastées du futur issue d'Explore2"
        aria-label="Quatre visions contrastées du futur issue d'Explore2"
        class:selected={$page.url.pathname === `${base}/narratifs`}
      >
        <Icon id="narratives" />
      </a>
    </li>
  </ul>
</nav>

<style>
  /* navigation button */
  a {
    background-color: transparent;
    /* border: 1px solid var(--main-color); */
    border-radius: var(--border-radius);
    padding: 0.5rem;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    color: black;
  }
  a.selected {
    background-color: var(--main-color);
  }
  /* Navigation Styles */
  nav {
    display: flex;
    align-items: center;
    font-size: 1.25rem;
    padding: 0.5rem;
  }

  nav ul {
    list-style-type: none;
    display: flex;
    gap: 0.5rem;
    justify-content: center;
    align-items: center;
  }

  nav ul li {
    display: block;
  }
</style>
