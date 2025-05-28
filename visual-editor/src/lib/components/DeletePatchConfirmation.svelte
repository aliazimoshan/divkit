<script lang="ts">
  import {
    deletePatchConfirmationModal,
    selectedPatch,
    selectedSystem,
  } from '../ctx/appContext';

  import type { PatchModel } from './models/PatchModel';
  import { deletePatch } from './services/patch_services';

  // export let patchModel: PatchModel | null;

  let isLoading = false;

  async function onConfirm() {
    if (!$selectedPatch) {
      console.error('No patch selected to delete.');
      return;
    }

    try {
      await deletePatch($selectedPatch, $selectedSystem?.id!);
      console.log('Patch deleted successfully.');
    } catch (err) {
      console.error('Error deleting patch:', err);
    } finally {
      isLoading = false;
      deletePatchConfirmationModal.set(false);
      selectedPatch.set(null);
    }
  }

  function onCancel() {
    deletePatchConfirmationModal.set(false);
  }

  // const dispatch = createEventDispatcher();
</script>

{#if isLoading}
  <div class="loading">
    <p>Processing...</p>
    <div class="spinner"></div>
  </div>
{:else}
  <!-- svelte-ignore a11y-click-events-have-key-events -->
  <!-- svelte-ignore a11y-no-static-element-interactions -->
  <div class="modal" on:click={onCancel}>
    <div class="modal-content" on:click|stopPropagation>
      <div class="modal-header">
        <h2>Confirm Action</h2>
        <span class="close" on:click={onCancel}>&times;</span>
      </div>

      <div class="modal-body">
        <p>
          Are you sure you want to delete the {$selectedPatch?.patchName} patch?
        </p>
      </div>

      <div class="modal-actions">
        <button class="button" on:click={onConfirm}>Yes</button>
        <button class="button" on:click={onCancel}>No</button>
      </div>
    </div>
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

  .modal-body p {
    font-size: 16px;
    color: #333;
  }

  .modal-actions {
    display: flex;
    justify-content: space-between;
  }

  .button {
    padding: 12px 20px;
    background-color: #5959e8;
    color: white;
    border: none;
    border-radius: 4px;
    font-size: 16px;
    cursor: pointer;
    transition: background-color 0.3s ease;
  }

  .button:hover {
    background-color: #4747c1;
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
