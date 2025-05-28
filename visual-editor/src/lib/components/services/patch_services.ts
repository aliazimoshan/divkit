import { fetchWithAuth } from './services';
import { PatchModel } from '../models/PatchModel';
import { refreshPatches } from '../../ctx/appContext';
import toast from 'svelte-french-toast';

export async function fetchPatchesByScreenId(screenId: string,systemId: number): Promise<PatchModel[]> {
  try {
    const response = await fetchWithAuth(`screen/getScreenPatches`, {
      method: 'POST',   
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ systemId, screenId }),
    });

    if (!response.ok) {
      throw new Error('Failed to fetch patches');
    }

    const data: PatchModel[] = (await response.json()).data;;
    return data;
  } catch (err) {
    console.error('Error fetching patches:', err);
    throw err;
  }
}
// Update savePatch function to use fetchWithAuth
export async function savePatch(patchModel: PatchModel): Promise<void> {
  try {
    const response = await fetchWithAuth(
      `screen/savePatch?systemId=${patchModel.systemId}&screenId=${patchModel.idScreen}`,
      {
        headers: {
          'Content-Type': 'application/json',
        },
        method: 'POST',
        body: JSON.stringify(patchModel),
      },
    );

    console.log('Patch saved successfully:', response.status);

    if (response.ok) {
      const result = await response.json();
      refreshPatches.update(n => n + 1);
      toast.success(result?.message || 'Patch saved successfully!');
    } else {
      const error = await response.json();
      throw new Error(`Failed to save patch: ${error.message}`);
    }
  } catch (err) {
    console.error('Error while saving patch:', err);
    throw err instanceof Error ? err : new Error('An unknown error occurred while saving the patch.');
  }
}

// Update deletePatch function to use fetchWithAuth
export async function deletePatch(patch: PatchModel,systemId:number): Promise<void> {
  const url = `screen/patch`;
  try {
    const response = await fetchWithAuth(url, {
      method: 'DELETE',
      body: JSON.stringify({patchId:patch.id, systemId}),
    });

    if (response.ok) {
      const result = await response.json();
      refreshPatches.update(n => n + 1);
      // toast.success(result?.message ?? `Patch with ID ${patch.id} deleted successfully.`);
    } else {
      const error = await response.json();
      throw new Error(`Failed to delete patch: ${error.message}`);
    }
  } catch (err) {
    console.error('Error deleting patch:', err);
    throw err;
  }
}
