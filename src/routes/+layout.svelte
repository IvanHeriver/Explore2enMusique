<script>
</script>

<div class="wrapper">
  <header>
    <div class="logo">
      <a href="./"><img src="explore-2-en-musique.png" alt="Logo" /></a>
    </div>
    <nav>
      <ul>
        <li>
          <a href="./" title="carte">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="feather feather-map"
            >
              <polygon points="1 6 1 22 8 18 16 22 23 18 23 2 16 6 8 2 1 6"
              ></polygon>
              <line x1="8" y1="2" x2="8" y2="18"></line>
              <line x1="16" y1="6" x2="16" y2="22"></line>
            </svg>
          </a>
        </li>
        <li>
          <a href="./a_propos" title="à propos">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="feather feather-help-circle"
            >
              <circle cx="12" cy="12" r="10"></circle>
              <path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"></path>
              <line x1="12" y1="17" x2="12.01" y2="17"></line>
            </svg>
          </a>
        </li>
        <li>
          <a
            href="./donnees_list"
            title="list des bassins versant et simulations"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="feather feather-list"
            >
              <line x1="8" y1="6" x2="21" y2="6"></line>
              <line x1="8" y1="12" x2="21" y2="12"></line>
              <line x1="8" y1="18" x2="21" y2="18"></line>
              <line x1="3" y1="6" x2="3.01" y2="6"></line>
              <line x1="3" y1="12" x2="3.01" y2="12"></line>
              <line x1="3" y1="18" x2="3.01" y2="18"></line>
            </svg>
          </a>
        </li>
      </ul>
    </nav>
  </header>

  <main>
    <slot />
  </main>
  <footer>
    <div class="copyright">
      &copy; 2024 Explore 2 les futurs de l'eau. Tout droits réservés
    </div>
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
  }
  main {
    height: 100%;
    flex-grow: 1;
    width: 100%;
    max-width: 1200px;
    padding: 1rem;
  }

  header,
  footer {
    z-index: 10000;
    /* background-color: color-mix(in srgb, var(--main-color), transparent 20%); */
    background-color: color-mix(in srgb, white, transparent 20%);
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
  }
  .logo img {
    max-height: var(--header-height);
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
    gap: 1rem;
    justify-content: center;
    align-items: center;
  }

  nav ul li {
    display: block;
  }
  /* footer */
  footer {
    padding: 0.25rem;
    display: grid;
    place-items: center;
    font-size: small;
  }
</style>
