<script lang="ts">
  // import { onMount } from 'svelte';
  import {
    isNewPatch,
    refreshPatches,
    selectedPatch,
    selectedScreen,
    selectedSystem,
    showAddPatchModal,
  } from '../ctx/appContext';
  import { writable } from 'svelte/store';
  import type { PatchModel } from './models/PatchModel';
  import PatchTextEditor from './PatchTextEditor.svelte';
  import { fetchPatchesByScreenId } from './services/patch_services';
  import AddButton from './controls/AddButton.svelte'; // for the add icon
  import { onDestroy } from 'svelte';

  let patches = writable<PatchModel[]>([]);
  let isLoading = writable(true);
  let error = writable<string | null>(null);

  // let selectedPatch = writable<PatchModel | null>(null);

  // Patch refresh logic (like refreshScreens in ExamplePages)
  let unsubscribePatchRefresh = refreshPatches.subscribe(() => {
    if ($selectedScreen && $selectedScreen.id) {
      fetchPatches($selectedScreen.id);
    }
  });

  onDestroy(() => {
    if (unsubscribePatchRefresh) unsubscribePatchRefresh();
  });

  async function fetchPatches(screenId: string) {
    console.log('Start getting patch...');
    isLoading.set(true);
    error.set(null);
    try {
      const data = await fetchPatchesByScreenId(screenId, $selectedSystem?.id!);
      patches.set(data);
    } catch (err) {
      error.set(err instanceof Error ? err.message : 'Failed to fetch patches');
    } finally {
      isLoading.set(false);
    }
  }

  $: if ($selectedScreen && $selectedScreen.id) {
    fetchPatches($selectedScreen.id);
  } else {
    patches.set([]);
    error.set('Selected screen is null or does not have an ID');
  }

  function handlePatchSelect(patch: PatchModel) {
    console.log('Patch selected:', patch);
    selectedPatch.set(patch);
    // if (patch.jsonObject) {
    //   const parsedJson = JSON.parse(patch.jsonObject);
    //   const formattedJson = JSON.stringify(parsedJson, null, 2);

    //   selectedPatchJson.set(formattedJson); // Format JSON before setting it
    // } else {
    //   selectedPatchJson.set(''); // Clear if no JSON found
    // }
  }

  let isAddPatchModalOpen = false;

  function openAddPatchModal() {
    showAddPatchModal.set(true);
    isNewPatch.set(true);
  }
  function closeAddPatchModal() {
    isAddPatchModalOpen = false;
  }
</script>

{#if $selectedPatch}
  <PatchTextEditor />
{:else}
  <div class="scrollable-list">
    <!-- Header with title -->
    <div style="display: flex; justify-content: space-between">
      <h3 class="title">Patches</h3>
      <button class="btn" type="button" on:click={openAddPatchModal}>
        +
      </button>
    </div>

    <!-- Loading and error states -->
    {#if $isLoading}
      <p class="loading">Loading...</p>
    {:else if $error}
      <p class="error">{$error}</p>
    {:else}
      <div>
        <!-- Loop through patches -->
        {#each $patches as patch (patch.id)}
          <div
            class="list-item"
            role="button"
            tabindex="0"
            on:click={() => handlePatchSelect(patch)}
            on:keydown={(event) => {
              if (event.key === 'Enter' || event.key === ' ') {
                handlePatchSelect(patch);
              }
            }}
          >
            <h4 class="patch-name-title">
              {patch.patchName}
            </h4>
          </div>
        {/each}
      </div>
    {/if}
  </div>
{/if}

<style>
  .scrollable-list {
    overflow-y: auto;
    padding: 0 16px;
  }

  .title {
    margin-top: 18px;
    margin-left: 8px;
    font-size: 18px;
    font-weight: 500;
  }

  .list-item {
    padding: 8px;
    cursor: default;
    font-size: 14px;
    border-bottom: 1px solid var(--fill-transparent-2);
    direction: ltr; /* Change to LTR layout */
  }

  .list-item:last-child {
    border-bottom: none;
  }

  .list-item:hover {
    opacity: 0.5;
    cursor: pointer;
  }

  .patch-name-title {
    text-align: left; /* Align text to the left */
    font-size: 14px;
    font-weight: 500;
  }

  .loading {
    font-size: 14px;
    color: var(--text-secondary);
  }

  .error {
    font-size: 14px;
    color: red;
  }

  .btn {
    margin-top: 16px;
    cursor: pointer;
    font-size: 30px;
    font-weight: bolder;
    background: none; /* Remove background color */
    border: none; /* Remove border */
  }
</style>
