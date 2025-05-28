<script lang="ts">
  import { getContext, createEventDispatcher } from 'svelte';
  import toast, { Toaster } from 'svelte-french-toast';

  import {
    APP_CTX,
    type AppContext,
    selectedScreen,
    showAddPatchModal,
    selectedPatch,
    isNewPatch,
  } from '../ctx/appContext';
  import { PatchModel } from './models/PatchModel';
  import { savePatch } from './services/patch_services';
  // import type { PatchModel } from './models/PatchModel';

  const BASE_PATCH = JSON.stringify({});
  let isAddPatchModalOpen = false; // Change variable name to match modal
  let patchPath = ''; // Change screenPath to patchPath for clarity
  let patchName = ''; // Change screenName to patchName for clarity
  let isLoading = false;

  const { state } = getContext<AppContext>(APP_CTX);
  const { divjsonStore } = state;

  showAddPatchModal.subscribe((value) => {
    isAddPatchModalOpen = value;
  });

  function openAddPatchModal(): void {
    showAddPatchModal.set(true);
  }

  // Refactor submitAddPatch function to improve readability and maintainability
  async function submitAddPatch(): Promise<void> {
    if (!validateForm(patchName)) return;

    isLoading = true;
    try {
      const json = isNewPatch ? BASE_PATCH : $selectedPatch!.jsonObject; // Use selectedPatch instead of divjsonStore
      const patchModel = createPatchModel(json, patchName);

      await savePatch(patchModel);
      // state.pushCommand(new SetJsonCommand(state, json));
      selectedPatch.set(patchModel);
      modalStore.close(); // Ensure modal is closed after submission
    } catch (error) {
      handleError(error);
    } finally {
      isLoading = false;
    }
  }

  // Helper function to create a ScreenModel instance
  function createPatchModel(jsonObject: string, patchName: string): PatchModel {
    const selectedSystem = localStorage.getItem('selectedSystem');
    const systemId = JSON.parse(selectedSystem!).id;
    const parsedSystemId = systemId ? parseInt(systemId, 10) : null;
    const idScreen = $selectedScreen!.id!;
    return new PatchModel(
      null,
      jsonObject,
      idScreen,
      patchName,
      parsedSystemId!,
    );
  }

  function closeAddPatchModal(): void {
    showAddPatchModal.set(false);
    isNewPatch.set(false);
  }

  function handleBackgroundClick(event: MouseEvent): void {
    const target = event.target as HTMLElement;
    if (target.classList.contains('modal')) {
      closeAddPatchModal(); // Updated to call closeAddPatchModal
    }
  }

  // Validate form inputs
  function validateForm(patchName: string): boolean {
    // Updated to remove patchPath parameter
    // Updated parameter names to match context
    if (!patchName) {
      // Updated condition to only check patchName
      toast.error('Please fill all required fields.');
      return false;
    }
    return true;
  }

  // Handle errors
  function handleError(error: unknown): void {
    console.error('Error:', error);
    toast.error(
      error instanceof Error ? error.message : 'An unknown error occurred.',
    );
  }

  // Define modalStore to handle modal state
  const modalStore = {
    close: () => {
      showAddPatchModal.set(false); // Updated to use showAddPatchModal
      isNewPatch.set(false); // Updated to use isNewPatch
    },
  };
</script>

{#if isAddPatchModalOpen}
  <!-- Updated to use isAddPatchModalOpen -->
  <!-- svelte-ignore a11y-click-events-have-key-events -->
  <!-- svelte-ignore a11y-no-static-element-interactions -->
  <div class="modal" on:click={handleBackgroundClick}>
    <div class="modal-content">
      {#if isLoading}
        <!-- Loading Indicator -->
        <div class="loading">
          <p>Creating Patch...</p>
          <div class="spinner"></div>
        </div>
      {:else}
        <div class="modal-header">
          <h2>Add New Patch</h2>
          <button
            class="close"
            on:click={closeAddPatchModal}
            aria-label="Close modal">&times;</button
          >
        </div>

        <div class="modal-body">
          <label class="label" for="screenName">Patch Name</label>
          <input
            id="screenName"
            class="inp"
            type="text"
            placeholder="Enter Screen Name"
            bind:value={patchName}
          />

          <button class="button" on:click={submitAddPatch}>Create Patch</button>
        </div>
      {/if}
    </div>
    <Toaster position="top-center" />
  </div>
{/if}

<style>
  .loading {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100%;
    text-align: center;
  }

  .spinner {
    margin-top: 1rem;
    width: 40px;
    height: 40px;
    border: 4px solid #ddd;
    border-top: 4px solid #333;
    border-radius: 50%;
    animation: spin 1s linear infinite;
  }

  @keyframes spin {
    from {
      transform: rotate(0deg);
    }
    to {
      transform: rotate(360deg);
    }
  }

  .inp {
    width: 100%;
    padding: 12px 8px;
    margin: 10px 0;
    font-size: 16px;
    border-radius: 4px;
    border: 1px solid #ccc;
    box-sizing: border-box;
  }

  .label {
    font-size: 14px;
    margin-bottom: 5px;
    display: block;
    color: #333;
  }

  .modal {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    backdrop-filter: blur(8px);
    background-color: rgba(0, 0, 0, 0.4);
    z-index: 1000;
    display: flex;
    justify-content: center;
    align-items: center;
    animation: fadeIn 0.3s ease-out;
  }

  .modal-content {
    background: white;
    padding: 20px;
    border-radius: 8px;
    max-width: 500px;
    width: 100%;
    position: relative;
    box-shadow: 0 10px 15px rgba(0, 0, 0, 0.1);
    animation: slideIn 0.4s ease-out;
  }

  .modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
  }

  .modal-header h2 {
    font-size: 24px;
    font-weight: 600;
    color: #333;
    margin: 0;
  }

  .close {
    font-size: 30px;
    cursor: pointer;
    color: #333;
    transition: color 0.3s;
  }

  .close:hover {
    color: #f00;
  }
  /* 
  .dropdown {
    width: 100%;
    padding: 12px 8px;
    margin: 10px 0;
    font-size: 16px;
    border-radius: 4px;
    border: 1px solid #ccc;
    box-sizing: border-box;
  } */

  .button {
    padding: 14px;
    background-color: #5959e8;
    color: white;
    border: none;
    border-radius: 4px;
    width: 100%;
    font-size: 16px;
    cursor: pointer;
    transition: background-color 0.3s ease;
  }

  .button:hover {
    background-color: #5959e8;
  }

  @keyframes fadeIn {
    0% {
      opacity: 0;
    }
    100% {
      opacity: 1;
    }
  }

  @keyframes slideIn {
    0% {
      transform: translateY(-50px);
      opacity: 0;
    }
    100% {
      transform: translateY(0);
      opacity: 1;
    }
  }
</style>
