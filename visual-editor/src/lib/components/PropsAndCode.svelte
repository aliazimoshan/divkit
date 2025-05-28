<script lang="ts">
  import RadioSelector from './controls/RadioSelector.svelte';
  import Props from './Props.svelte';
  import TextEditor from './TextEditor.svelte';
  import PatchList from './PatchList.svelte';
  import { LANGUAGE_CTX, type LanguageContext } from '../ctx/languageContext';
  import propsIcon from '../../assets/props.svg?url';
  import complexPropsIcon from '../../assets/complexProps.svg?url';
  import codeIcon from '../../assets/code.svg?url';
  import patchIcon from '../../assets/add.svg?url';
  import { getContext, onMount } from 'svelte';
  import ProfileAvatar from './ProfileAvatar.svelte';
  // import profileIcon from '../../assets/profile.svg?url';

  let showProfileDropdown = false;
  let firstName = '';
  let lastName = '';

  onMount(() => {
    firstName = localStorage.getItem('firstName') || '';
    lastName = localStorage.getItem('lastName') || '';
  });

  function toggleProfileDropdown() {
    showProfileDropdown = !showProfileDropdown;
  }

  function handleLogout() {
    logout();
    // window.location.reload();
  }

  import SystemSelectModal from './SystemSelectModal.svelte';
  import { fetchSystems, logout } from './services/services';
  import { selectedSystem } from '../ctx/appContext';
  import type { SystemModel } from './models/SystemModel';
  import toast from 'svelte-french-toast';

  let showSystemModal = false;
  let loadingSystems = false;

  async function handleSelectSystem() {
    loadingSystems = true;
    try {
      const systems = await fetchSystems();
      if (systems && systems.length > 0) {
        // Set systemsList store if needed, or pass as prop if modal expects it
        showSystemModal = true;
      } else {
        toast.error('No systems found');
      }
    } catch (e) {
      toast.error('Failed to fetch systems');
    } finally {
      loadingSystems = false;
    }
  }
  function handleSystemConfirm(system: SystemModel) {
    localStorage.setItem('selectedSystem', JSON.stringify(system));
    selectedSystem.set(system);
    showSystemModal = false;
    //reload page
    window.location.reload();
  }

  function handleScreenHistory() {
    // You can implement screen history logic here
    alert('Screen history clicked');
  }

  const { l10n } = getContext<LanguageContext>(LANGUAGE_CTX);

  let panel = 'props';
</script>

<div class="props-and-code-row">
  <div class="props-and-code">
    <RadioSelector
      bind:value={panel}
      name="props-code"
      options={[
        {
          text: $l10n('componentProperties'),
          value: 'props',
          icon: propsIcon,
        },
        {
          text: $l10n('complexComponentProperties'),
          value: 'complexProps',
          icon: complexPropsIcon,
        },
        {
          text: $l10n('code'),
          value: 'code',
          icon: codeIcon,
        },
        {
          text: $l10n('patchList'),
          value: 'patch',
          icon: patchIcon,
        },
      ]}
      theme="normal"
    />
  </div>
  <div class="profile-dropdown-container">
    <button
      class="profile-btn"
      on:click={toggleProfileDropdown}
      aria-label="Profile"
    >
      <ProfileAvatar {firstName} {lastName} size="32px" fontSize="16px" />
    </button>
    {#if showProfileDropdown}
      <div class="profile-dropdown">
        <div class="profile-dropdown-header">
          <ProfileAvatar {firstName} {lastName} size="36px" fontSize="16px" />
          <div class="profile-fullname">{firstName} {lastName}</div>
        </div>
        <button
          class="profile-dropdown-btn"
          on:click={handleSelectSystem}
          disabled={loadingSystems}
        >
          {#if loadingSystems}
            Loading systems...
          {:else}
            Select System
          {/if}
        </button>
        {#if showSystemModal}
          <SystemSelectModal
            open={showSystemModal}
            onConfirm={handleSystemConfirm}
            onClosed={() => (showSystemModal = false)}
            closable={true}
          />
        {/if}
        <button
          class="profile-dropdown-btn"
          on:click={handleScreenHistory}
          disabled={loadingSystems}
        >
          Screen History
        </button>
        <button
          class="profile-dropdown-btn logout"
          on:click={handleLogout}
          disabled={loadingSystems}
        >
          Logout
        </button>
      </div>
    {/if}
  </div>
</div>

{#if panel === 'props' || panel === 'complexProps'}
  <Props showComplex={panel === 'complexProps'} />
{:else if panel === 'patch'}
  <PatchList />
{:else}
  <TextEditor />
{/if}

<style>
  .props-and-code {
    margin: 16px 16px 4px;
  }

  .props-and-code-row {
    display: flex;
    align-items: flex-end;
    justify-content: space-between;
    margin: 16px 16px 4px;
  }
  .props-and-code {
    flex: 1;
  }
  .profile-dropdown-container {
    position: relative;
    margin-left: 24px;
    display: flex;
    align-items: center;
  }
  .profile-btn {
    display: flex;
    align-items: center;
    background: none;
    border: none;
    cursor: pointer;
    margin-bottom: 4px;
    border-radius: 6px;
    transition: background 0.2s;
  }
  .profile-btn:hover {
    background: var(--fill-transparent-2, #f0f0f0);
  }

  /* Removed unused .profile-icon and .profile-name selectors */
  .profile-dropdown {
    position: absolute;
    right: 0;
    top: 44px;
    min-width: 180px;
    background: white;
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
    z-index: 100;
    padding: 12px 0 8px 0;
    display: flex;
    flex-direction: column;
    gap: 4px;
  }
  .profile-dropdown-header {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 0 16px 8px 16px;
    border-bottom: 1px solid #f0f0f0;
    margin-bottom: 8px;
  }

  .profile-fullname {
    font-size: 16px;
    font-weight: 600;
    color: #222;
  }
  .profile-dropdown-btn {
    background: none;
    border: none;
    text-align: left;
    padding: 10px 20px;
    font-size: 15px;
    color: #333;
    cursor: pointer;
    border-radius: 4px;
    transition: background 0.2s;
  }
  .profile-dropdown-btn:hover {
    background: #f5f5f5;
  }
  .logout {
    color: #c00;
    font-weight: 500;
  }
</style>
