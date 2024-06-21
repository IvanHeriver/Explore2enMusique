<script lang="ts">
  function handleGoBack() {
    history.back();
  }
</script>

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
    width: 1.75rem;
    height: 1.75rem;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: large;
    transform: scale(-1, 1);
    text-decoration: none;
    color: black;

    padding: 0.125rem;
    border: none;
    background-color: var(--main-color);
    cursor: pointer;
    border-radius: var(--border-radius);

    font-size: small;
  }

  .back:hover {
    background-color: var(--light-color);
  }
</style>
