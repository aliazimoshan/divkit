<script lang="ts">
  import {
    buttonValue,
    refreshScreens,
    selectedSystem,
    showAddScreenModal,
  } from './../ctx/appContext';
  import { getContext, onDestroy, onMount } from 'svelte';
  import { capitalize } from '../utils/capitalize';
  import { ScreenModel } from './models/ScreenModel';

  import {
    APP_CTX,
    type AppContext,
    selectedScreen,
    isNewScreen,
  } from '../ctx/appContext';
  import { SetJsonCommand } from '../data/commands/setJson';
  import { fetchScreens } from './services/services';

  const { state } = getContext<AppContext>(APP_CTX);

  // const {
  //   divjsonStore,
  //   selectedLeaf,
  //   highlightLeaf,
  //   highlightElem,
  //   highlightRanges,
  //   selectedRanges,
  //   highlightLoc,
  //   readOnly,
  //   themeStore,
  // } = state;

  // let selectedSystem: PageModel | null = null;
  // let systemList: PageModel[] = [];
  let screenList: ScreenModel[] = [];
  let isLoading: boolean = true;
  let error: string | null = null;
  let unsubscribe: () => void;

  unsubscribe = refreshScreens.subscribe(() => {
    loadScreens();
  });

  onDestroy(() => {
    if (unsubscribe) unsubscribe();
  });

  onMount(() => {
    loadScreens();
  });

  async function loadScreens() {
    isLoading = true;
    try {
      if ($selectedSystem?.id == undefined) {
        return;
      }
      const screens = await fetchScreens($selectedSystem?.id);
      screenList = screens;
    } catch (err) {
      error =
        err instanceof Error
          ? err.message
          : 'Failed to fetch systems from server. Please try again.';
    } finally {
      isLoading = false;
    }
  }
  function handleScreenSelect(item: ScreenModel) {
    const urlParams = new URLSearchParams(window.location.search);
    urlParams.delete('id');
    const newQueryString = urlParams.toString();
    const newUrl = newQueryString
      ? `${window.location.pathname}?${newQueryString}`
      : window.location.pathname;
    window.history.replaceState({}, '', newUrl);
    buttonValue.set('Update');

    selectedScreen.set(item);
    // console.log(item.jsonObject);
    // console.log($selectedScreen);

    state.pushCommand(new SetJsonCommand(state, item.jsonObject));
  }

  // async function handleSystemSelect(system: PageModel) {
  //   selectedSystem = system;
  // }
</script>

<div class="scrollable-list">
  <!-- Header with title and add button -->
  <div style="display: flex; justify-content: space-between">
    <h3 class="title">Pages</h3>
    {#if $selectedSystem?.userPermissions && $selectedSystem.userPermissions.includes('edit')}
      <button
        class="btn"
        type="button"
        on:click={() => {
          showAddScreenModal.set(true);
          isNewScreen.set(true);
        }}
      >
        +
      </button>
    {/if}
  </div>

  <!-- Loading and error states -->
  {#if isLoading}
    <p class="loading">Loading...</p>
  {:else if error}
    <p class="error">{error}</p>
  {:else}
    <div>
      <!-- Loop through screenList -->
      {#each screenList as screen (screen.id)}
        <div
          class="list-item"
          class:list-item_selected={$selectedScreen === screen}
          role="button"
          tabindex="0"
          on:click={() => handleScreenSelect(screen)}
          on:keydown={(event) => {
            if (event.key === 'Enter' || event.key === ' ') {
              handleScreenSelect(screen);
            }
          }}
        >
          <h4 class="system-name-title">
            {capitalize(
              screen.screenName != '' ? screen.screenName : 'No Name',
            )}
          </h4>
        </div>
      {/each}
    </div>
  {/if}
</div>

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

  .btn {
    margin-top: 16px;
    cursor: pointer;
    font-size: 30px;
    font-weight: bolder;
    background: none; /* Remove background color */
    border: none; /* Remove border */
  }

  div {
    list-style-type: none;
    padding: 0;
    margin: 0;
  }

  .list-item {
    padding: 8px;
    cursor: default;
    font-size: 14px;
    border-bottom: 1px solid var(--fill-transparent-2);
    direction: rtl; /* If you need RTL layout, this stays */
  }

  .list-item:last-child {
    border-bottom: none;
  }

  .list-item:hover:not(.list-item_selected) {
    opacity: 0.5;
    cursor: pointer;
  }

  .list-item_selected {
    cursor: default;
    background-color: var(--bg-secondary);
    transition:
      background-color 0.15s ease-in-out,
      color 0.15s ease-in-out;
  }

  .system-name-title {
    text-align: left;
    font-size: 14px;
    font-weight: 500;
  }
</style>
