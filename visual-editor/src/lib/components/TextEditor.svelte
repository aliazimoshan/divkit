<script lang="ts">
  import {
    getContext,
    onDestroy,
    onMount,
    createEventDispatcher,
  } from 'svelte';
  import { combineRanges } from '../data/highlightChannel';
  import type { createEditor } from '../data/editor';
  import { saveScreen } from './services/services';
  import {
    APP_CTX,
    type AppContext,
    buttonValue,
    showAddScreenModal,
    selectedScreen,
    json,
    isNewScreen,
    isYesNoModalOpen,
    deletingScreen,
  } from '../ctx/appContext';
  import { SetJsonCommand } from '../data/commands/setJson';
  import toast from 'svelte-french-toast';
  import { faEdit, faSave, faTrash } from '@fortawesome/free-solid-svg-icons';
  import { ScreenModel } from './models/ScreenModel';
  import { FontAwesomeIcon } from '@fortawesome/svelte-fontawesome';

  let node: HTMLElement;
  let editor: ReturnType<typeof createEditor> | undefined;
  let isSelfClick = false;
  let prevVal = '';
  const dispatch = createEventDispatcher();
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

  const BASE_VIEW_JSON = JSON.stringify({
    card: {
      log_id: 'div2_sample_card',
      states: [
        {
          state_id: 0,
          div: {
            items: [
              {
                items: [
                  {
                    accessibility: {
                      description: 'Hello Naji',
                    },
                    font_size: 32,
                    line_height: 40,
                    text: 'Hello Naji',
                    font_weight: 'medium',
                    text_color: '#000',
                    type: 'text',
                  },
                ],
                height: {
                  type: 'match_parent',
                },
                margins: {
                  bottom: 0,
                  top: 50,
                  left: 40,
                  right: 40,
                },
                type: 'container',
              },
            ],
            visibility_action: {
              log_id: 'visible',
            },
            background: [
              {
                color:
                  "@{getDictOptColor('#00ffffff', local_palette, 'bg_primary', theme)}",
                type: 'solid',
              },
            ],
            height: {
              type: 'match_parent',
            },
            orientation: 'overlap',
            type: 'container',
          },
        },
      ],
      variables: [
        {
          type: 'dict',
          name: 'local_palette',
          value: {
            bg_primary: {
              name: 'Primary background',
              light: '#fff',
              dark: '#000',
            },
            color0: {
              name: 'Secondary background',
              light: '#eeeeee',
              dark: '#000',
            },
          },
        },
        {
          type: 'dict',
          name: 'test',
          value: {
            logged: 1,
            login: 'Vasya',
            mailCount: 123,
          },
        },
      ],
    },
  });

  // Function to handle update button click
  async function handleUpdate() {
    if ($buttonValue === 'Save') {
      showAddScreenModal.set(true); // Open modal
    } else {
      if (!editor) return;
      try {
        isLoading = true; // Start loading
        const updatedScreen: ScreenModel = {
          id: $selectedScreen!.id ?? '',
          path: $selectedScreen!.path ?? '',
          version: $selectedScreen!.version ?? '',
          screenName: $selectedScreen!.screenName ?? '',
          idSystem: $selectedScreen!.idSystem ?? 0,
          appScreenPatches: $selectedScreen!.appScreenPatches ?? [],
          jsonObject: $divjsonStore.fullString, // Explicitly assign the updated jsonObject
        };

        console.log('Updated ScreenModel:', updatedScreen);

        const saveResult = await saveScreen(updatedScreen);

        state.pushCommand(new SetJsonCommand(state, BASE_VIEW_JSON));
        buttonValue.set('Save');

        console.log('Screen saved successfully:', saveResult);

        isLoading = false;
        toast.success('Screen created successfully!');

        showAddScreenModal.set(false);
        console.log('Modal closed after success');
      } catch (err) {
        isLoading = false;

        if (err instanceof Error) {
          console.error('Save screen failed:', err);
          toast.error(err.message);
        } else {
          console.error('Save screen failed with unknown error:', err);
          toast.error('An unknown error occurred while saving.');
        }
      }
    }
  }

  $: if (prevVal !== $divjsonStore.fullString && !editor?.isFocused()) {
    editor?.setValue($divjsonStore.fullString);
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
      value: $divjsonStore.fullString,
      theme: $themeStore,
      readOnly: $readOnly,
      shadowRoot,
      onChange(value) {
        if (value !== $divjsonStore.fullString) {
          let json;
          try {
            json = JSON.parse(value);
          } catch (err) {
            console.log(
              err instanceof Error ? err.message : 'Something happened',
            );
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
  });

  onDestroy(() => {
    if (editor) {
      editor.destroy();
      editor = undefined;
    }
  });
</script>

<div class="editor-container">
  {#if isLoading}
    <div class="loading-overlay">Loading...</div>
  {/if}

  <div class="text-editor" bind:this={node} class:blurred={isLoading}></div>

  <!-- Buttons Section -->
  <div class="button-container">
    <!-- Delete Button -->
    <button
      class="styled-button delete-button"
      on:click={(event) => {
        event.stopPropagation(); // Prevent triggering any other events
        const screen = $selectedScreen; // Extract the value from the store
        if (!screen) {
          toast.error('No screen selected for deletion.');
          return;
        }
        isYesNoModalOpen.set(true);
        deletingScreen.set(screen); // Ensure proper type
      }}
      class:blurred={isLoading}
    >
      <FontAwesomeIcon icon={faTrash} />
      Delete
    </button>

    <!-- Update/Save Button -->
    <button
      class="styled-button update-button"
      on:click={handleUpdate}
      class:blurred={isLoading}
    >
      {#if $buttonValue === 'Save'}
        <FontAwesomeIcon icon={faSave} />
        Save
      {:else}
        <FontAwesomeIcon icon={faEdit} />
        Update
      {/if}
    </button>
  </div>
</div>

<style>
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

  .styled-button {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem; /* Add spacing between icon and text */
    padding: 0.75rem 1.5rem;
    font-size: 16px;
    border-radius: 4px;
    border: none;
    cursor: pointer;
    transition: background-color 0.3s ease;
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

  .blurred {
    opacity: 0.6;
    cursor: not-allowed;
  }
</style>
