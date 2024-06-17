<script lang="ts">
  import Icon from "./Icon.svelte";

  import { page } from "$app/stores";
  // let page: string = "map";
</script>

<nav>
  <ul>
    <li>
      <a
        href="/"
        title="carte"
        aria-label="afficher la carte"
        class:selected={$page.url.pathname === "/"}
      >
        <Icon id="map" />
      </a>
    </li>
    <li>
      <a
        href="/a_propos"
        title="à propos"
        aria-label="afficher les informations sur le site web"
        class:selected={$page.url.pathname === "/a_propos"}
      >
        <Icon id="question" />
      </a>
    </li>
    <li>
      <a
        href="/stations"
        title="list des données"
        aria-label="afficher la liste des données / simulations disponibles"
        class:selected={$page.url.pathname === "/stations"}
      >
        <Icon id="list" />
      </a>
    </li>
  </ul>
  <!-- <ul>
    <li>
      <input
        type="radio"
        name="page_selector"
        id="map_nav"
        value="map"
        checked
        bind:group={page}
        on:change={handlePageChange}
      />
      <label for="map_nav" title="carte" aria-label="afficher la carte">
        <Icon id="map" />
      </label>
    </li>
    <li>
      <input
        type="radio"
        name="page_selector"
        id="about_nav"
        value="about"
        bind:group={page}
        on:change={handlePageChange}
      />
      <label
        for="about_nav"
        title="à propos"
        aria-label="afficher les informations sur le site web"
      >
        <Icon id="question" />
      </label>
    </li>
    <li>
      <input
        type="radio"
        name="page_selector"
        id="sim_list_nav"
        value="sim_list"
        bind:group={page}
        on:change={handlePageChange}
      />
      <label
        for="sim_list_nav"
        title="list des données"
        aria-label="afficher la liste des données / simulations disponibles"
      >
        <Icon id="list" />
      </label>
    </li>
  </ul> -->
</nav>

<style>
  /* navigation button */
  a {
    background-color: transparent;
    border: 1px solid var(--main-color);
    border-radius: var(--border-radius);
    padding: 0.5rem;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
  }
  a.selected {
    background-color: var(--main-color);
  }
  /* navigation button */
  /* input[type="radio"] {
    width: 0;
    height: 0;
    position: absolute;
    opacity: 0;
  }
  input[type="radio"] + label {
    background-color: transparent;
    border: 1px solid var(--main-color);
    border-radius: var(--border-radius);
    padding: 0.5rem;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
  }
  input[type="radio"]:checked + label {
    background-color: var(--main-color);
  } */

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
