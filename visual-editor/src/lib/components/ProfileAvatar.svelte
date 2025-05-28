<script lang="ts">
  import { faUser } from '@fortawesome/free-solid-svg-icons';
  import { FontAwesomeIcon } from '@fortawesome/svelte-fontawesome';
  export let firstName: string = '';
  export let lastName: string = '';
  export let size: string = '32px';
  export let fontSize: string = '16px';
</script>

<span
  class="profile-avatar"
  style="width: {size}; height: {size}; font-size: {fontSize};"
>
  {#if firstName || lastName}
    {firstName.charAt(0)}&#8194;{lastName.charAt(0)}
  {:else}
    <FontAwesomeIcon icon={faUser} style="font-size: 18px;" />
  {/if}
</span>

<style>
  .profile-avatar {
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    background: var(--fill-transparent-2, #f0f0f0);
    color: var(--accent-purple, #5959e8);
    border: 2px solid var(--fill-transparent-2, #f0f0f0);
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.03);
    transition:
      background 0.2s,
      color 0.2s;
  }
</style>
