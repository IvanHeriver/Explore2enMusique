<script lang="ts">
  function handleGoBack() {
    history.back();
  }
</script>

<!-- <a
  class="back"
  href={url}
  title="retour à la page précédente"
  aria-label="retour à la page précédente"
>
  &#10140;
</a> -->

<button
  class="back"
  title="retour à la page précédente"
  aria-label="retour à la page précédente"
  on:click={handleGoBack}
>
  &#10140;
</button>

<style>
  .back {
    position: fixed;
    inset: calc(var(--header-height) + 0.5rem) auto auto 1rem;
    width: 2rem;
    height: 2rem;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: large;
    transform: scale(-1, 1);
    text-decoration: none;
    color: black;

    padding: 0.25rem;
    border: none;
    background-color: var(--main-color);
    cursor: pointer;
    border-radius: var(--border-radius);
  }

  .back:hover {
    background-color: var(--light-color);
  }
</style>
