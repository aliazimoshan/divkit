<script lang="ts">
  import { toast } from 'svelte-french-toast';
  import { login } from './services/services';
  // import type { SystemModel } from './models/SystemModel';
  import { systemsList, selectedSystem } from '../ctx/appContext';
  import type { SystemModel } from './models/SystemModel';
  import SystemSelectModal from './SystemSelectModal.svelte';

  export let onLogin: (status: boolean) => void;
  let username = '';
  let password = '';
  let loading = false;
  let showSystemModal = false;

  async function handleLogin(event: Event) {
    try {
      event.preventDefault();
      toast.dismiss();

      if (!username || !password) {
        toast.error('Please enter both username and password.');
        onLogin(false);
        return;
      }

      loading = true;

      const response = await login(username, password);
      loading = false;

      if (response != false) {
        localStorage.setItem('loggedIn', 'true');
        systemsList.set(
          response.data.systems.map((system: any) => ({
            id: system.id,
            systemName: system.systemName,
            userPermissions: system.userPermissions,
          })),
        );

        if ($systemsList.length === 1) {
          selectedSystem.set($systemsList[0]);
          localStorage.setItem(
            'selectedSystem',
            JSON.stringify($selectedSystem),
          );
          toast.success('Logged in successfully');
          onLogin(true);
        } else {
          showSystemModal = true;
        }
      } else {
        toast.error(response?.message || 'Invalid username or password.');
        onLogin(false);
      }
    } catch (error) {
      console.log(error);
      onLogin(false);
    }
  }

  function handleSystemConfirm(system: SystemModel) {
    localStorage.setItem('selectedSystem', JSON.stringify(system));
    selectedSystem.set(system);
    onLogin(true);
    showSystemModal = false;
  }

  // Retrieve selected system from localStorage on component initialization
  const storedSystem = localStorage.getItem('selectedSystem');
  if (storedSystem) {
    try {
      selectedSystem.set(JSON.parse(storedSystem));
    } catch (error) {
      console.log('Error parsing selectedSystem from localStorage:', error);
    }
  }
</script>

<div class="login-wrapper">
  <div class="login-container">
    <form class="login-form" on:submit={handleLogin}>
      <h2>Login</h2>

      <label for="username">Username</label>
      <input
        type="text"
        id="username"
        bind:value={username}
        placeholder="Enter your username"
        required
      />

      <label for="password">Password</label>
      <input
        type="password"
        id="password"
        bind:value={password}
        placeholder="Enter your password"
        required
      />

      <button type="submit" disabled={loading}>
        {#if loading}
          Logging in...
        {:else}
          Login
        {/if}
      </button>
    </form>

    <SystemSelectModal
      open={showSystemModal}
      onConfirm={handleSystemConfirm}
      closable={false}
      onClosed={() => (showSystemModal = false)}
    />
  </div>
</div>

<style>
  /* Wrapper ensures centering on all screens */
  /* Wrapper ensures centering on all screens */
  .login-wrapper {
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    height: 100vh;
    background-color: #f5f5f5;
  }

  .login-container {
    width: 100%;
    max-width: 400px;
    padding: 2rem;
    background: white;
    border-radius: 8px;
    box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.1);
  }

  h2 {
    text-align: center;
    color: #333;
  }

  label {
    display: block;
    font-size: 0.9rem;
    margin-top: 10px;
    color: #333;
  }

  input,
  button {
    width: 100%;
    box-sizing: border-box; /* Include padding and border in element's total width */
  }

  input {
    padding: 0.5rem;
    margin-top: 5px;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 1rem;
  }

  button {
    padding: 0.5rem;
    margin-top: 25px;
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

  button:hover {
    background-color: #4949d3;
  }
</style>
