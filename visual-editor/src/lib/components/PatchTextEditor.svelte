<script lang="ts">
  import { getContext, onDestroy, onMount } from 'svelte';
  import { combineRanges } from '../data/highlightChannel';
  import type { createEditor } from '../data/editor';
  import {
    APP_CTX,
    deletePatchConfirmationModal,
    selectedPatch,
    selectedScreen,
    type AppContext,
  } from '../ctx/appContext';
  import { SetJsonCommand } from '../data/commands/setJson';
  import { FontAwesomeIcon } from '@fortawesome/svelte-fontawesome';
  import { faEdit, faSave, faTrash } from '@fortawesome/free-solid-svg-icons';
  import { PatchModel } from './models/PatchModel';
  import { savePatch } from './services/patch_services';
  import toast from 'svelte-french-toast';

  let node: HTMLElement;
  let editor: ReturnType<typeof createEditor> | undefined;
  let isSelfClick = false;
  let prevVal = '';
  let originalJson = ''; // Backup of original JSON

  const { editorFabric, shadowRoot, state } = getContext<AppContext>(APP_CTX);

  const {
    divjsonStore,
    selectedLeaf,
    highlightLeaf,
    highlightElem,
    highlightRanges,
    selectedRanges,
    highlightLoc,
    readOnly,
    themeStore,
  } = state;

  let isLoading = false;

  function applyPatch() {
    if (!$selectedPatch || !$divjsonStore.fullString) return;

    try {
      let selectedJson = JSON.parse($divjsonStore.fullString);
      let patch = JSON.parse($selectedPatch.jsonObject);

      function applyChanges(obj: any, changes: any[]): any {
        if (!obj || typeof obj !== 'object') return obj;

        if (obj.id && changes.some((change) => change.id === obj.id)) {
          const patchData = changes.find((change) => change.id === obj.id);
          return { ...obj, items: patchData.items };
        }

        if (Array.isArray(obj)) {
          return obj.map((item) => applyChanges(item, changes));
        } else {
          let newObj = { ...obj };
          for (let key in newObj) {
            newObj[key] = applyChanges(newObj[key], changes);
          }
          return newObj;
        }
      }

      if (patch.patch && patch.patch.mode === 'partial') {
        selectedJson = applyChanges(selectedJson, patch.patch.changes);
      }

      state.pushCommand(
        new SetJsonCommand(state, JSON.stringify(selectedJson, null, 2)),
      );
    } catch (err) {
      console.error('Error applying patch:', err);
    }
  }

  function undoPatch() {
    if (!originalJson) return; // Prevent undo if there's no backup

    state.pushCommand(new SetJsonCommand(state, originalJson));
  }

  function handleBack() {
    undoPatch();
    selectedPatch.set(null);
  }

  // Function to handle update button click
  async function handleUpdate() {
    // Add your update logic here
    if (!$selectedPatch) {
      console.error('No patch selected to save.');
      return;
    }

    try {
      const patchModel = createPatchModel();
      await savePatch(patchModel);
      deletePatchConfirmationModal.set(false);
    } catch (err) {
      console.error('Unexpected error while saving patch:', err);
      toast.error('Error happened while updating patch');
    }
  }

  // Function to handle delete button click
  async function handleDelete() {
    if (!$selectedPatch) {
      console.error('No patch selected to delete.');
      return;
    }

    const patch = $selectedPatch; // Extract the value from the store
    if (!patch) {
      toast.error('No patch selected for deletion.');
      return;
    }
    deletePatchConfirmationModal.set(true);
    undoPatch();
  }

  // Helper function to create a ScreenModel instance
  function createPatchModel(): PatchModel {
    const selectedSystem = localStorage.getItem('selectedSystem');
    const systemId = JSON.parse(selectedSystem!).id;
    const parsedSystemId = systemId ? parseInt(systemId, 10) : null;
    const idScreen = $selectedScreen!.id!;
    return new PatchModel(
      $selectedPatch?.id!,
      $selectedPatch?.jsonObject!,
      idScreen,
      $selectedPatch?.patchName!,
      parsedSystemId!,
    );
  }

  // $: if ($selectedPatchJson) {
  //   editor?.setValue($selectedPatchJson); // Update editor with selected patch JSON
  // }

  $: if (prevVal !== $selectedPatch?.jsonObject && !editor?.isFocused()) {
    editor?.setValue($selectedPatch?.jsonObject ?? '');
  }

  $: editor?.setTheme($themeStore);

  $: editor?.setReadOnly($readOnly);

  $: editor?.decorateRanges(combineRanges($highlightRanges, $selectedRanges));

  $: if ($highlightLoc) {
    if (isSelfClick) {
      isSelfClick = false;
    } else {
      editor?.revealLoc($highlightLoc);
    }
  }

  onMount(() => {
    editor = editorFabric({
      node,
      value: $selectedPatch?.jsonObject ?? '',
      theme: $themeStore,
      readOnly: $readOnly,
      shadowRoot,
      onChange(value) {
        if (value !== $selectedPatch?.jsonObject) {
          let json;
          try {
            json = JSON.parse(value);
            // Update selected patch with new JSON
            selectedPatch.update(
              (patch) => ({ ...patch, jsonObject: value }) as PatchModel,
            );
          } catch (err) {
            console.log('JSON parse error:', err);
          }
          if (json) {
            prevVal = value;
            state.pushCommand(new SetJsonCommand(state, value));
          }
        }
      },
      onOver(offset) {
        const leaf = offset === null ? null : state.findBestLeaf(offset);
        const range = leaf?.props.range;
        const node = leaf?.props.node;

        if (range && node) {
          highlightLeaf.set([leaf]);
          highlightElem.set([node]);
          highlightRanges.set([range]);
        } else {
          highlightLeaf.set(null);
          highlightElem.set(null);
          highlightRanges.set(null);
        }
      },
      onClick(offset) {
        const leaf = state.findBestLeaf(offset);

        isSelfClick = true;
        selectedLeaf.set(leaf || null);
      },
    });

    // Save the original JSON when the component is mounted
    if ($selectedPatch && $divjsonStore.fullString) {
      originalJson = JSON.stringify(
        JSON.parse($divjsonStore.fullString),
        null,
        2,
      );
    }
  });

  onDestroy(() => {
    if (editor) {
      editor.destroy();
      editor = undefined;
    }
  });
</script>

<div class="button-row-container">
  <button class="back-button" on:click={handleBack}>← Back</button>
  <div class="right-buttons">
    <button class="secondary-button undo-button" on:click={undoPatch}>
      Reset
    </button>
    <button class="styled-button apply-button" on:click={applyPatch}>
      Apply
    </button>
  </div>
</div>

<div class="editor-container">
  {#if isLoading}
    <div class="loading-overlay">Loading...</div>
  {/if}

  <div class="text-editor" bind:this={node} class:blurred={isLoading}></div>
  <!-- Buttons Section -->
  <div class="button-container">
    <!-- Delete Button -->
    <button
      class="full-width-button delete-button"
      on:click={handleDelete}
      class:blurred={isLoading}
    >
      <FontAwesomeIcon icon={faTrash} />
      Delete
    </button>

    <!-- Update/Save Button -->
    <button
      class="full-width-button update-button"
      on:click={handleUpdate}
      class:blurred={isLoading}
    >
      <FontAwesomeIcon icon={faEdit} />
      Update
    </button>
    <!-- </div> -->
  </div>
</div>

<style>
  .button-row-container {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 1rem;
    padding-right: 5px;
  }
  .editor-container {
    display: flex;
    flex-direction: column;
    height: 100%; /* Adjust based on your needs */
    border: 1px solid #ccc;
    border-radius: 8px;
    overflow: hidden; /* Keeps button and text editor within boundaries */
  }
  .text-editor {
    flex: 1 1 auto;
    white-space: pre;
    overflow: auto;
    min-height: 0;
    width: 0;
    min-width: 100%;
    margin-top: 12px;
    font-size: 80%;
  }

  :global(.cm-highlight) {
    background: var(--fill-transparent-1);
  }

  :global(.cm-select) {
    background: var(--fill-transparent-2);
  }

  /* Button styling */
  .styled-button {
    padding: 10px 14px;
    font-size: 14px;
    /* font-weight: bold; */
    color: #fff;
    background-color: var(--accent-purple);
    border: none;
    border-radius: 8px;
    outline: none;
    cursor: pointer;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
    transition:
      background-color 0.3s,
      box-shadow 0.3s;
  }

  .styled-button:hover {
    background-color: var(--accent-purple-hover);
    box-shadow: 0 6px 8px rgba(0, 0, 0, 0.3);
  }

  .styled-button:active {
    background-color: var(--accent-purple-active);
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  }

  .styled-button:focus {
    outline: 2px solid var(--accent-purple-focus);
  }

  .secondary-button {
    padding: 10px 14px;
    font-size: 14px;
    margin: 5px;
    /* font-weight: bold; */
    color: var(--accent-purple); /* Change font color to purple */
    background-color: var(--accent-purple-light);
    border: 1px solid var(--accent-purple);
    border-radius: 8px;
    outline: none;
    cursor: pointer;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
    transition:
      background-color 0.3s,
      box-shadow 0.3s;
  }

  .secondary-button:hover {
    background-color: var(--accent-gray-hover);
    box-shadow: 0 6px 8px rgba(0, 0, 0, 0.3);
  }

  .secondary-button:active {
    background-color: var(--accent-gray-active);
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  }

  .secondary-button:focus {
    outline: 2px solid var(--accent-gray-focus);
  }
  .editor-container {
    position: relative;
  }

  .blurred {
    filter: blur(5px);
    pointer-events: none; /* Prevent interaction while loading */
  }

  .loading-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 9999;
    color: white;
    font-size: 1.5rem;
  }

  .button-container {
    display: flex;
    justify-content: flex-end;
    gap: 3px; /* Add spacing between buttons */
    margin-top: 1rem; /* Add spacing from the content above */
  }

  .back-button {
    padding: 8px 16px;
    font-size: 14px;
    font-weight: bold;
    color: var(--accent-purple);
    background-color: transparent;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s;
  }

  .back-button:hover {
    background-color: var(--text-tertiary);
  }

  .blurred {
    opacity: 0.6;
    cursor: not-allowed;
  }

  .full-width-button {
    width: 100%; /* Stretches button to full width */
    padding: 12px 16px;
    font-size: 16px;
    font-weight: bold;
    color: #fff;
    background-color: var(--accent-purple);
    border: none;
    outline: none;
    cursor: pointer;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
    transition:
      background-color 0.3s,
      box-shadow 0.3s;
  }

  .update-button {
    background-color: #4caf50; /* Green */
    color: white;
  }

  .update-button:hover {
    background-color: #45a049;
  }

  .delete-button {
    background-color: #f44336; /* Red */
    color: white;
  }

  .delete-button:hover {
    background-color: #d32f2f;
  }
</style>
