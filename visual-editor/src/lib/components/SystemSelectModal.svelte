<script lang="ts">
  import { systemsList, selectedSystem } from '../ctx/appContext';
  import type { SystemModel } from './models/SystemModel';
  import { toast } from 'svelte-french-toast';
  import { createEventDispatcher } from 'svelte';

  export let open = false;
  export let onConfirm: (system: SystemModel) => void;
  /**
   * If true, the modal can be closed by user (via close button or backdrop click).
   * Default: false (not closable)
   */
  export let closable: boolean = false;
  /**
   * Optional callback when modal is closed (via close button or backdrop click)
   */
  export let onClosed: (() => void) | undefined;

  let selectedSystemDraft: SystemModel | null = null;
  const dispatch = createEventDispatcher();

  function confirmSystemSelection() {
    if (selectedSystemDraft) {
      localStorage.setItem(
        'selectedSystem',
        JSON.stringify(selectedSystemDraft),
      );
      selectedSystem.set(selectedSystemDraft);
      onConfirm(selectedSystemDraft);
      dispatch('close');
    } else {
      toast.error('Please select a system.');
    }
  }

  function close() {
    if (closable) {
      dispatch('close');
      if (onClosed) onClosed();
    }
  }
</script>

{#if open}
  <div
    class="modal-backdrop"
    on:click={() => closable && close()}
    aria-hidden="true"
  ></div>
  <div class="modal">
    <!-- svelte-ignore a11y-click-events-have-key-events -->
    <!-- svelte-ignore a11y-no-static-element-interactions -->
    <div class="modal-content" on:click|stopPropagation>
      <div class="modal-title">Select System</div>
      <select bind:value={selectedSystemDraft}>
        <option value="" disabled selected>Select a system</option>
        {#each $systemsList as system}
          <option value={system}>{system.systemName}</option>
        {/each}
      </select>
      <button on:click={confirmSystemSelection} disabled={!selectedSystemDraft}
        >Confirm</button
      >
      {#if closable}
        <button
          class="modal-close-btn"
          on:click={close}
          aria-label="Close modal">&times;</button
        >
      {/if}
    </div>
  </div>
{/if}

<style>
  .modal-backdrop {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.2);
    z-index: 1000;
  }
  .modal {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    background: white;
    border-radius: 8px;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.12);
    z-index: 1001;
    min-width: 320px;
  }
  .modal-content {
    padding: 2rem 1.5rem 1.5rem 1.5rem;
    display: flex;
    flex-direction: column;
    gap: 1rem;
    position: relative;
  }
  select {
    padding: 0.5rem;
    border-radius: 4px;
    border: 1px solid #ddd;
    font-size: 1rem;
  }
  button {
    padding: 0.5rem;
    background-color: #5959e8;
    color: white;
    border: none;
    border-radius: 4px;
    font-size: 1rem;
    cursor: pointer;
    transition: background-color 0.3s ease;
  }
  button:disabled {
    background-color: gray;
    cursor: not-allowed;
  }

  .modal-title {
    font-size: 1.2rem;
    font-weight: 600;
    text-align: center;
    padding: 1.25rem 1.5rem 1.5rem 1.5rem;
    color: #222;
  }
  .modal-close-btn {
    position: absolute;
    top: 0.5rem;
    right: 0.75rem;
    background: none;
    border: none;
    font-size: 1.5rem;
    color: #888;
    cursor: pointer;
    z-index: 10;
    padding: 0;
    line-height: 1;
    transition: color 0.2s;
  }
  .modal-close-btn:hover {
    color: #222;
  }
</style>
