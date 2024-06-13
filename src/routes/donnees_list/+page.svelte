<script lang="ts">
  export let data;
</script>

<div>
  <ul>
    {#each data.data.entries() as catchment}
      <li>
        {#if catchment[1]}
          <a href={`/#code=${catchment[1].info.code}`}>
            {catchment[1].info.name}
          </a>
          <ul>
            {#each catchment[1].data as catch_data}
              <li>
                {catch_data.fullname}
              </li>
            {/each}
          </ul>
        {:else}
          <div class="error">no data (1)</div>
        {/if}
      </li>
    {/each}
  </ul>
</div>
