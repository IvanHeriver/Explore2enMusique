<script lang="ts">
  export let narrative;

  let tooltip: boolean = false;

  let id: string = crypto.randomUUID();
</script>

<input type="checkbox" bind:checked={tooltip} {id} />
<label for={id}>
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
  <div class="tooltip" class:showtooltip={tooltip}>
    <button
      class="close"
      on:click={() => {
        tooltip = false;
      }}
    >
      &#10006;
    </button>
    <div class="title">
      {narrative.label}
    </div>
    <div class="desc">
      {"description détaillée du narratif"}
      Lorem ipsum, dolor sit amet consectetur adipisicing elit. Iure ipsa dignissimos
      deleniti dolorem architecto impedit fugit odit tenetur officiis eos, fuga mollitia
      placeat ratione eligendi neque temporibus possimus itaque, voluptas facilis.
      Ipsum saepe doloribus expedita animi accusantium ad eaque, ea
    </div>
  </div>
</label>

<style>
  input {
    width: 0px;
    height: 0px;
    opacity: 0;
    position: absolute;
  }

  label {
    position: relative;
  }

  .tooltip {
    position: absolute;
    background-color: white;
    padding: 1rem;
    inset: auto;
    top: 2rem;
    right: 0;
    border: 1px solid var(--main-color);
    border-radius: var(--border-radius);
    display: none;
    z-index: 99;
  }

  .tooltip .title {
    min-width: 150px;
    font-weight: bold;
  }
  .tooltip .desc {
    font-weight: 200;
  }

  .showtooltip {
    display: block;
  }

  .close {
    position: absolute;
    inset: 0.25rem 0.25rem auto auto;
    width: 1.2rem;
    height: 1.2rem;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: normal;
  }
</style>
