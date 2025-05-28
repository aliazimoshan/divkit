import { ScreenModel } from '../models/ScreenModel';
import { PatchModel } from '../models/PatchModel';
import toast from 'svelte-french-toast';
import { refreshScreens, systemsList } from '../../ctx/appContext';
import { SystemModel } from '../models/SystemModel';

interface LoginResponse {
  exists: boolean; // Whether the user exists
  canLogin: boolean; // Whether the user can login
  message?: string; // Optional message from the API, like error or success
}

// Add a logout function to handle unauthorized responses
export function logout() {
  fetchWithAuth('auth/logout', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
  }).catch((error) => {
    console.error('Error during logout service call:', error);
  });
  localStorage.removeItem('accessToken');
  localStorage.removeItem('refreshToken');
  localStorage.removeItem('loggedIn');
  window.location.reload(); // Refresh the page
}

// Add a method to refresh the access token
 async function refreshAccessToken(): Promise<boolean> {
  try {
    const refreshToken = localStorage.getItem('refreshToken');
    if (!refreshToken) {
      throw new Error('No refresh token available');
    }

    const response = await fetch('https://172.19.83.21:8444/api/auth/refresh', {
      method: 'POST',   
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ refreshToken }),
    });
    
    const data = await response.json();

    if (data.success) {
      localStorage.setItem('accessToken', data.data.accessToken);
      return true;
    } else {
      throw new Error('Failed to refresh access token');
    }
  } catch (error) {
    console.error('Error refreshing access token:', error);
    return false;
  }
}

// Wrap fetch calls to handle 401 responses
export async function fetchWithAuth(url: string, options: RequestInit): Promise<Response> {
  const accessToken = localStorage.getItem('accessToken');
  if (accessToken) {
    options.headers = {
      ...options.headers,
      Authorization: `Bearer ${accessToken}`,
    };
  }

  let response = await fetch(`https://172.19.83.21:8444/api/${url}`, options);

  if (response.status === 401) {
    const tokenRefreshed = await refreshAccessToken();
    if (tokenRefreshed) {
      const newAccessToken = localStorage.getItem('accessToken');
      if (newAccessToken) {
        options.headers = {
          ...options.headers,
          Authorization: `Bearer ${newAccessToken}`,
        };
        // Retry the original request with updated headers
        response = await fetchWithAuth(url, options);
      }
    }

    if (response.status === 401) {
      localStorage.clear();
      window.location.reload(); // Refresh the page
      throw new Error('Unauthorized: Redirecting to login page.');
    }
  }

  return response;
}

// Update login function to use fetchWithAuth
export async function login(username: string, password: string): Promise<any> {
  try {
    const response = await fetch('https://172.19.83.21:8444/api/auth/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ username, password }),
    });

    const data = await response.json();

    if (data.success) {
      console.log('Login successful:', data.data);
      // Save user data to storage
      localStorage.setItem('firstName', data.data.firstName);
      localStorage.setItem('lastName', data.data.lastName);
      localStorage.setItem('username', data.data.username);
      localStorage.setItem('phoneNumber', data.data.phoneNumber);
      localStorage.setItem('accessToken', data.data.accessToken);
      localStorage.setItem('refreshToken', data.data.refreshToken);
      return data; // Return the full response to the UI
    } else {
      console.error('Login failed:', data.message || 'Unknown error');
      return false;
    }
  } catch (error) {
    console.error('Login error:', error);
    return false;
  }
}


// Add a function to fetch systems
export async function fetchSystems(): Promise<SystemModel[]> {
  try {
    const response = await fetchWithAuth(`system/my`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    });

    if (!response.ok) {
      throw new Error('Failed to fetch systems');
    }

    const data = await response.json();
    console.log(data)

    const _systemList = data.data.map(
      (item: any) =>
        new SystemModel(
          item.id,
          item.systemName,
          item.idSystem,
          item.userPermissions,
        ),
    );
    systemsList.set(_systemList); 
    return _systemList;
  } catch (err) {
    console.error('Error fetching systems:', err);
    throw err;
  }
}



// Add a function to fetch screens
export async function fetchScreens(selectedSystemId: number): Promise<ScreenModel[]> {
  try {
    if (!selectedSystemId) {
      throw new Error('No selected system ID provided');
    }

    const response = await fetchWithAuth(`screen/system/${selectedSystemId}`,{},  
    );

    if (!response.ok) {
      throw new Error('Failed to fetch screens');
    }

    const data = await response.json();

    return data.data.map(
      (item: any) =>
        new ScreenModel(
          item.id,
          item.path,
          item.jsonObject,
          item.version,
          item.screenName,
          item.idSystem,
          item.appScreenPatches,
        ),
    );
  } catch (err) {
    console.error('Error fetching screens:', err);
    throw err;
  }
}

// Update saveScreen function to use fetchWithAuth
export async function saveScreen(screenModel: ScreenModel): Promise<void> {
  try {
    const response = await fetchWithAuth(
      'screen/save', 
      {
        headers: {
          'Content-Type': 'application/json',
        },
        method: 'POST',
        body: JSON.stringify(screenModel),
      },
    );

    console.log('Screen saved successfully:', response.status);

    if (response.ok) {
      // await fetchScreens(selectedSystemId);
      const result = await response.json();
      refreshScreens.update(n => n + 1);
      toast.success(result?.message || 'Screen saved successfully!');
    } else {
      const error = await response.json();
            throw new Error(`Failed to save screen: ${error.message}`);

    }


   
  } catch (err) {
    console.error('Error while saving screen:', err);
    throw err instanceof Error ? err : new Error('An unknown error occurred while saving the screen.');
  }
  
}

// Update deleteScreen function to use fetchWithAuth
export async function deleteScreen(screen: ScreenModel): Promise<void> {
  const url = `screen/${screen.id}`;
  try {
    const response = await fetchWithAuth(url, {
      method: 'DELETE',
    });

    if (response.ok) {
      const result = await response.json();
      refreshScreens.update(n => n + 1);
      toast.success(result?.message ?? `Screen with ID ${screen.id} deleted successfully.`);
    } else {
      const error = await response.json();
      throw new Error(`Failed to delete screen: ${error.message}`);
    }
  } catch (err) {
    console.error('Error deleting screen:', err);
    throw err;
  }
}


// Add a function to fetch a temporary screen JSON
export async function fetchTempJson(tempScreenId: string | null): Promise<ScreenModel | null> {
  if (!tempScreenId) {
    throw new Error('No temporary screen ID provided');
  }

  try {
    const response = await fetchWithAuth(`screen/temp/${tempScreenId}`, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    });

    if (!response.ok) {
      throw new Error('Failed to fetch temporary screen JSON');
    }

    const data = await response.json();

    return new ScreenModel(
      data.id,
      data.path,
      data.jsonObject,
      data.version,
      data.screenName,
      data.idSystem,
      data.appScreenPatches,
    );
  } catch (err) {
    console.error('Error fetching temporary screen JSON:', err);
    throw err;
  }
}




/* 
{{
  "card": {
    "log_id": "div2_sample_card",
    "states": [
      {
        "state_id": 0,
        "div": {
          "type": "gallery",
          "items": [
            {
              "type": "container",
              "items": [
                {
                  "type": "image",
                  "image_url": "divkit-asset://refresh-appbar.png",
                  "actions": [
                    {
                      "log_id": "update_visibility",
                      "url": "div-action://set_variable?name=variable_hoviat_visibility&value=gone"
                    }
                  ],
                  "width": {
                    "type": "fixed",
                    "value": 24
                  },
                  "height": {
                    "type": "fixed",
                    "value": 24
                  },
                  "preload_required": true,
                  "alignment_horizontal": "right",
                  "alignment_vertical": "center",
                  "margins": {
                    "right": 12
                  }
                },
                {
                  "type": "image",
                  "image_url": "divkit-asset://arrow-left.png",
                  "width": {
                    "type": "fixed",
                    "value": 24
                  },
                  "height": {
                    "type": "fixed",
                    "value": 24
                  },
                  "preload_required": true,
                  "alignment_horizontal": "left",
                  "alignment_vertical": "center",
                  "margins": {
                    "left": 12
                  }
                },
                {
                  "type": "text",
                  "text": "استعلام وسیله نقلیه",
                  "font_size": 16,
                  "line_height": 24,
                  "letter_spacing": 0,
                  "text_color": "#193d8d",
                  "text_alignment_horizontal": "center",
                  "text_alignment_vertical": "top",
                  "width": {
                    "type": "wrap_content"
                  },
                  "height": {
                    "type": "wrap_content"
                  },
                  "alignment_horizontal": "center",
                  "alignment_vertical": "center",
                  "margins": {
                    "left": 162,
                    "right": 162,
                    "top": 16,
                    "bottom": 16
                  }
                }
              ],
              "background": [
                {
                  "type": "solid",
                  "color": "#ffffff"
                }
              ],
              "height": {
                "type": "fixed",
                "value": 56
              },
              "width": {
                "type": "match_parent"
              },
              "orientation": "overlap",
              "content_alignment_vertical": "center",
              "content_alignment_horizontal": "center",
              "alignment_horizontal": "center",
              "alignment_vertical": "top"
            },
            {
              "type": "container",
              "items": [
                {
                  "type": "container",
                  "background": [
                    {
                      "type": "solid",
                      "color": "@{vehicle?'#e8ecf4':'#ffffff'}"
                    }
                  ],
                  "actions": [
                    {
                      "log_id": "open_camera",
                      "url": "div-action://set_variable?name=vehicle&value=false"
                    },
                    {
                      "log_id": "show_main",
                      "url": "div-action://show_toast?massage=در نسخه بعدی اضافه میشود"
                    }
                  ],
                  "items": [
                    {
                      "type": "text",
                      "text": "@{text___1}",
                      "font_size": 14,
                      "line_height": 32,
                      "letter_spacing": 0,
                      "text_color": "#757575",
                      "text_alignment_horizontal": "right",
                      "text_alignment_vertical": "top",
                      "width": {
                        "type": "wrap_content"
                      },
                      "height": {
                        "type": "wrap_content"
                      }
                    }
                  ],
                  "border": {
                    "corner_radius": 4
                  },
                  "height": {
                    "type": "wrap_content"
                  },
                  "width": {
                    "type": "match_parent"
                  },
                  "orientation": "horizontal",
                  "content_alignment_horizontal": "center",
                  "content_alignment_vertical": "center",
                  "paddings": {
                    "top": 8,
                    "bottom": 8,
                    "left": 12,
                    "right": 12
                  }
                },
                {
                  "type": "container",
                  "actions": [
                    {
                      "log_id": "open_camera",
                      "url": "div-action://set_variable?name=vehicle&value=true"
                    }
                  ],
                  "items": [
                    {
                      "type": "text",
                      "text": "@{text___2}",
                      "font_size": 14,
                      "line_height": 32,
                      "letter_spacing": 0,
                      "text_color": "#193d8d",
                      "text_alignment_horizontal": "right",
                      "text_alignment_vertical": "top",
                      "width": {
                        "type": "wrap_content"
                      },
                      "height": {
                        "type": "wrap_content"
                      }
                    }
                  ],
                  "background": [
                    {
                      "type": "solid",
                      "color": "@{vehicle? '#ffffff':'#e8ecf4'}"
                    }
                  ],
                  "border": {
                    "corner_radius": 4
                  },
                  "height": {
                    "type": "wrap_content"
                  },
                  "width": {
                    "type": "match_parent"
                  },
                  "orientation": "horizontal",
                  "content_alignment_horizontal": "center",
                  "content_alignment_vertical": "center",
                  "paddings": {
                    "top": 8,
                    "bottom": 8,
                    "left": 12,
                    "right": 12
                  },
                  "margins": {
                    "left": 16
                  }
                }
              ],
              "background": [
                {
                  "type": "solid",
                  "color": "#e8ecf4"
                }
              ],
              "border": {
                "corner_radius": 4,
                "stroke": {
                  "color": "#c8d0e4",
                  "width": 1
                }
              },
              "height": {
                "type": "wrap_content"
              },
              "width": {
                "type": "match_parent"
              },
              "orientation": "horizontal",
              "content_alignment_horizontal": "center",
              "content_alignment_vertical": "center",
              "paddings": {
                "top": 8,
                "bottom": 8,
                "left": 8,
                "right": 8
              },
              "alignment_horizontal": "center",
              "alignment_vertical": "top",
              "margins": {
                "left": 12,
                "right": 12,
                "top": 12
              }
            },
            {
              "type": "container",
              "items": [
                {
                  "type": "container",
                  "actions": [
                    {
                      "log_id": "plate change",
                      "url": "div-action://set_variable?name=tab_index&value=4"
                    },
                    {
                      "log_id": "update_visibility",
                      "url": "div-action://set_variable?name=hint&value=vin"
                    },
                    {
                      "log_id": "update_visibility",
                      "url": "div-action://set_variable?name=input_type&value=vin_num"
                    },
                    {
                      "log_id": "change plate text color",
                      "url": "div-action://change_color?name=vin_color&value=@{selected_tab}"
                    },
                    {
                      "log_id": "change plate text color",
                      "url": "div-action://change_color?name=vin_text_color&value=@{selected_tab_text}"
                    }
                  ],
                  "background": [
                    {
                      "type": "solid",
                      "color": "@{vin_color}"
                    }
                  ],
                  "items": [
                    {
                      "type": "text",
                      "text": "VIN",
                      "font_size": 14,
                      "line_height": 32,
                      "letter_spacing": 0,
                      "text_color": "@{vin_text_color}",
                      "text_alignment_horizontal": "right",
                      "text_alignment_vertical": "top",
                      "width": {
                        "type": "wrap_content"
                      },
                      "height": {
                        "type": "wrap_content"
                      }
                    }
                  ],
                  "border": {
                    "corner_radius": 4
                  },
                  "height": {
                    "type": "wrap_content"
                  },
                  "width": {
                    "type": "match_parent"
                  },
                  "orientation": "horizontal",
                  "content_alignment_horizontal": "center",
                  "content_alignment_vertical": "center",
                  "paddings": {
                    "top": 8,
                    "bottom": 8,
                    "left": 12,
                    "right": 12
                  },
                  "margins": {
                    "right": 4,
                    "left": 4
                  }
                },
                {
                  "type": "container",
                  "actions": [
                    {
                      "log_id": "plate change",
                      "url": "div-action://set_variable?name=tab_index&value=3"
                    },
                    {
                      "log_id": "update_visibility",
                      "url": "div-action://set_variable?name=hint&value=موتور"
                    },
                    {
                      "log_id": "update_visibility",
                      "url": "div-action://set_variable?name=input_type&value=shmarh_motor"
                    },
                    {
                      "log_id": "change plate text color",
                      "url": "div-action://change_color?name=motor_color&value=@{selected_tab}"
                    },
                    {
                      "log_id": "change plate text color",
                      "url": "div-action://change_color?name=motor_text_color&value=@{selected_tab_text}"
                    }
                  ],
                  "border": {
                    "corner_radius": 4
                  },
                  "height": {
                    "type": "wrap_content"
                  },
                  "width": {
                    "type": "match_parent"
                  },
                  "orientation": "horizontal",
                  "content_alignment_horizontal": "center",
                  "content_alignment_vertical": "center",
                  "paddings": {
                    "top": 8,
                    "bottom": 8,
                    "left": 12,
                    "right": 12
                  },
                  "background": [
                    {
                      "type": "solid",
                      "color": "@{motor_color}"
                    }
                  ],
                  "items": [
                    {
                      "type": "text",
                      "text": "موتور",
                      "font_size": 14,
                      "line_height": 32,
                      "letter_spacing": 0,
                      "text_color": "@{motor_text_color}",
                      "text_alignment_horizontal": "right",
                      "text_alignment_vertical": "top",
                      "width": {
                        "type": "wrap_content"
                      },
                      "height": {
                        "type": "wrap_content"
                      }
                    }
                  ],
                  "margins": {
                    "right": 4,
                    "left": 4
                  }
                },
                {
                  "type": "container",
                  "actions": [
                    {
                      "log_id": "plate change",
                      "url": "div-action://set_variable?name=tab_index&value=2"
                    },
                    {
                      "log_id": "update_visibility",
                      "url": "div-action://set_variable?name=hint&value=شاسی"
                    },
                    {
                      "log_id": "update_visibility",
                      "url": "div-action://set_variable?name=input_type&value=shmarh_shasi"
                    },
                    {
                      "log_id": "change plate text color",
                      "url": "div-action://change_color?name=shasi_color&value=@{selected_tab}"
                    },
                    {
                      "log_id": "change plate text color",
                      "url": "div-action://change_color?name=shasi_text_color&value=@{selected_tab_text}"
                    }
                  ],
                  "border": {
                    "corner_radius": 4
                  },
                  "height": {
                    "type": "wrap_content"
                  },
                  "width": {
                    "type": "match_parent"
                  },
                  "orientation": "horizontal",
                  "content_alignment_horizontal": "center",
                  "content_alignment_vertical": "center",
                  "paddings": {
                    "top": 8,
                    "bottom": 8,
                    "left": 12,
                    "right": 12
                  },
                  "background": [
                    {
                      "type": "solid",
                      "color": "@{shasi_color}"
                    }
                  ],
                  "items": [
                    {
                      "type": "text",
                      "text": "شاسی",
                      "font_size": 14,
                      "line_height": 32,
                      "letter_spacing": 0,
                      "text_color": "@{shasi_text_color}",
                      "text_alignment_horizontal": "right",
                      "text_alignment_vertical": "top",
                      "width": {
                        "type": "wrap_content"
                      },
                      "height": {
                        "type": "wrap_content"
                      }
                    }
                  ],
                  "margins": {
                    "right": 4,
                    "left": 4
                  }
                },
                {
                  "type": "container",
                  "actions": [
                    {
                      "log_id": "plate change",
                      "url": "div-action://set_variable?name=tab_index&value=1"
                    },
                    {
                      "log_id": "update_visibility",
                      "url": "div-action://set_variable?name=plate_visibility&value=visible"
                    },
                    {
                      "log_id": "update_visibility",
                      "url": "div-action://set_variable?name=input_type&value=plate"
                    },
                    {
                      "log_id": "update_visibility",
                      "url": "div-action://set_variable?name=input_visibility&value=gone"
                    },
                    {
                      "log_id": "change plate text color",
                      "url": "div-action://change_color?name=plate_color&value=@{selected_tab}"
                    },
                    {
                      "log_id": "change plate text color",
                      "url": "div-action://change_color?name=plate_text_color&value=@{selected_tab_text}"
                    }
                  ],
                  "items": [
                    {
                      "type": "text",
                      "text": "پلاک",
                      "font_size": 14,
                      "line_height": 32,
                      "letter_spacing": 0,
                      "text_color": "@{plate_text_color}",
                      "text_alignment_horizontal": "right",
                      "text_alignment_vertical": "top",
                      "width": {
                        "type": "wrap_content"
                      },
                      "height": {
                        "type": "wrap_content"
                      }
                    }
                  ],
                  "background": [
                    {
                      "type": "solid",
                      "color": "@{plate_color}"
                    }
                  ],
                  "border": {
                    "corner_radius": 4
                  },
                  "height": {
                    "type": "wrap_content"
                  },
                  "width": {
                    "type": "match_parent"
                  },
                  "orientation": "horizontal",
                  "content_alignment_horizontal": "center",
                  "content_alignment_vertical": "center",
                  "paddings": {
                    "top": 8,
                    "bottom": 8,
                    "left": 12,
                    "right": 12
                  },
                  "margins": {
                    "right": 4,
                    "left": 4
                  }
                }
              ],
              "background": [
                {
                  "type": "solid",
                  "color": "#e8ecf4"
                }
              ],
              "border": {
                "corner_radius": 4,
                "stroke": {
                  "color": "#c8d0e4",
                  "width": 1
                }
              },
              "height": {
                "type": "wrap_content"
              },
              "width": {
                "type": "match_parent"
              },
              "orientation": "horizontal",
              "content_alignment_horizontal": "center",
              "content_alignment_vertical": "center",
              "paddings": {
                "top": 8,
                "bottom": 8,
                "left": 8,
                "right": 8
              },
              "alignment_horizontal": "center",
              "alignment_vertical": "top",
              "margins": {
                "left": 12,
                "right": 12,
                "top": 12
              }
            },
            {
              "type": "container",
              "visibility": "@{tab_index!='1'?'visible':'gone'}",
              "items": [
                {
                  "type": "container",
                  "actions": [
                    {
                      "log_id": "plate change",
                      "url": "div-action://set_variable?name=vehicle_type_index&value=2"
                    },
                    {
                      "log_id": "change plate text color",
                      "url": "div-action://change_color?name=motor_color2&value=@{selected_tab}"
                    },
                    {
                      "log_id": "change plate text color",
                      "url": "div-action://change_color?name=motor_text_color2&value=@{selected_tab_text}"
                    },
                    {
                      "log_id": "change plate text color",
                      "url": "div-action://change_color?name=plate_color2&value=@{unselected_tab}"
                    },
                    {
                      "log_id": "change plate text color",
                      "url": "div-action://change_color?name=plate_text_color2&value=@{unselected_tab_text}"
                    }
                  ],
                  "border": {
                    "corner_radius": 4
                  },
                  "height": {
                    "type": "wrap_content"
                  },
                  "width": {
                    "type": "match_parent"
                  },
                  "orientation": "horizontal",
                  "content_alignment_horizontal": "center",
                  "content_alignment_vertical": "center",
                  "paddings": {
                    "top": 8,
                    "bottom": 8,
                    "left": 12,
                    "right": 12
                  },
                  "background": [
                    {
                      "type": "solid",
                      "color": "@{motor_color2}"
                    }
                  ],
                  "items": [
                    {
                      "type": "text",
                      "text": "موتور سیکلت",
                      "font_size": 14,
                      "line_height": 32,
                      "letter_spacing": 0,
                      "text_color": "@{motor_text_color2}",
                      "text_alignment_horizontal": "right",
                      "text_alignment_vertical": "top",
                      "width": {
                        "type": "wrap_content"
                      },
                      "height": {
                        "type": "wrap_content"
                      }
                    }
                  ],
                  "margins": {
                    "right": 4,
                    "left": 4
                  }
                },
                {
                  "type": "container",
                  "actions": [
                    {
                      "log_id": "plate change",
                      "url": "div-action://set_variable?name=vehicle_type_index&value=1"
                    },
                    {
                      "log_id": "change plate text color",
                      "url": "div-action://change_color?name=plate_color2&value=@{selected_tab}"
                    },
                    {
                      "log_id": "change plate text color",
                      "url": "div-action://change_color?name=plate_text_color2&value=@{selected_tab_text}"
                    },
                    {
                      "log_id": "change plate text color",
                      "url": "div-action://change_color?name=motor_color2&value=@{unselected_tab}"
                    },
                    {
                      "log_id": "change plate text color",
                      "url": "div-action://change_color?name=motor_text_color2&value=@{unselected_tab_text}"
                    }
                  ],
                  "items": [
                    {
                      "type": "text",
                      "text": "خودرو",
                      "font_size": 14,
                      "line_height": 32,
                      "letter_spacing": 0,
                      "text_color": "@{plate_text_color2}",
                      "text_alignment_horizontal": "right",
                      "text_alignment_vertical": "top",
                      "width": {
                        "type": "wrap_content"
                      },
                      "height": {
                        "type": "wrap_content"
                      }
                    }
                  ],
                  "background": [
                    {
                      "type": "solid",
                      "color": "@{plate_color2}"
                    }
                  ],
                  "border": {
                    "corner_radius": 4
                  },
                  "height": {
                    "type": "wrap_content"
                  },
                  "width": {
                    "type": "match_parent"
                  },
                  "orientation": "horizontal",
                  "content_alignment_horizontal": "center",
                  "content_alignment_vertical": "center",
                  "paddings": {
                    "top": 8,
                    "bottom": 8,
                    "left": 12,
                    "right": 12
                  },
                  "margins": {
                    "right": 4,
                    "left": 4
                  }
                }
              ],
              "background": [
                {
                  "type": "solid",
                  "color": "#e8ecf4"
                }
              ],
              "border": {
                "corner_radius": 4,
                "stroke": {
                  "color": "#c8d0e4",
                  "width": 1
                }
              },
              "height": {
                "type": "wrap_content"
              },
              "width": {
                "type": "match_parent"
              },
              "orientation": "horizontal",
              "content_alignment_horizontal": "center",
              "content_alignment_vertical": "center",
              "paddings": {
                "top": 8,
                "bottom": 8,
                "left": 8,
                "right": 8
              },
              "alignment_horizontal": "center",
              "alignment_vertical": "top",
              "margins": {
                "left": 12,
                "right": 12,
                "top": 12
              }
            },
            {
              "visibility": "@{plate_visibility}",
              "type": "container",
              "items": [
                {
                  "type": "container",
                  "items": [
                    {
                      "type": "image",
                      "image_url": "divkit-asset://arrow-down.png",
                      "height": {
                        "type": "fixed",
                        "value": 16
                      },
                      "width": {
                        "type": "fixed",
                        "value": 16
                      }
                    }
                  ],
                  "height": {
                    "type": "fixed",
                    "value": 16
                  },
                  "width": {
                    "type": "fixed",
                    "value": 16
                  },
                  "orientation": "overlap",
                  "content_alignment_vertical": "center",
                  "content_alignment_horizontal": "center"
                },
                {
                  "type": "container",
                  "items": [
                    {
                      "type": "text",
                      "text": "@{patch}",
                      "font_size": 14,
                      "line_height": 24,
                      "letter_spacing": 0,
                      "text_color": "#252424",
                      "text_alignment_horizontal": "right",
                      "text_alignment_vertical": "top",
                      "width": {
                        "type": "wrap_content"
                      },
                      "height": {
                        "type": "wrap_content"
                      }
                    }
                  ],
                  "height": {
                    "type": "wrap_content"
                  },
                  "width": {
                    "type": "match_parent"
                  },
                  "orientation": "vertical",
                  "content_alignment_vertical": "center",
                  "content_alignment_horizontal": "right",
                  "margins": {
                    "left": 120
                  }
                }
              ],
              "background": [
                {
                  "type": "solid",
                  "color": "#ffffff"
                }
              ],
              "actions": [
                {
                  "log_id": "show_bottom_sheet_list",
                  "url": "div-action://bottom_sheet_div?jsonName=vt/plates/bottomsheet"
                }
              ],
              "border": {
                "corner_radius": 4,
                "stroke": {
                  "color": "#dedede",
                  "width": 1
                }
              },
              "height": {
                "type": "wrap_content"
              },
              "width": {
                "type": "match_parent"
              },
              "orientation": "horizontal",
              "content_alignment_horizontal": "left",
              "content_alignment_vertical": "center",
              "paddings": {
                "top": 12,
                "bottom": 12,
                "left": 16,
                "right": 12
              },
              "alignment_horizontal": "center",
              "alignment_vertical": "top",
              "margins": {
                "top": 8,
                "right": 12,
                "left": 12
              }
            },
            {
              "type": "container",
              "items": [
                {
                  "type": "container",
                  "width": {
                    "type": "match_parent"
                  },
                  "height": {
                    "type": "wrap_content"
                  },
                  "items": [
                    {
                      "visibility": "@{plate_visibility}",
                      "type": "container",
                      "width": {
                        "type": "match_parent"
                      },
                      "height": {
                        "type": "wrap_content"
                      },
                      "items": [
                        {
                          "id": "vehiclePlate",
                          "type": "container",
                          "items": [
                            {
                              "type": "container",
                              "items": [
                                {
                                  "type": "image",
                                  "image_url": "divkit-asset://ir.png",
                                  "height": {
                                    "type": "match_parent"
                                  },
                                  "width": {
                                    "type": "fixed",
                                    "value": 37
                                  },
                                  "alignment_horizontal": "right",
                                  "alignment_vertical": "top",
                                  "margins": {
                                    "right": 3,
                                    "top": 4
                                  }
                                }
                              ],
                              "background": [
                                {
                                  "type": "solid",
                                  "color": "#003299"
                                }
                              ],
                              "border": {
                                "corner_radius": 4
                              },
                              "height": {
                                "type": "fixed",
                                "value": 56
                              },
                              "width": {
                                "type": "fixed",
                                "value": 44
                              },
                              "orientation": "overlap",
                              "content_alignment_vertical": "center",
                              "content_alignment_horizontal": "center"
                            },
                            {
                              "type": "container",
                              "items": [
                                {
                                  "id": "plateA",
                                  "type": "input",
                                  "text_variable": "variable_plateA",
                                  "hint_text": "@{variable_plateA_hint}",
                                  "keyboard_type": "number",
                                  "max_length": 2,
                                  "font_size": 32,
                                  "letter_spacing": 0,
                                  "border": {
                                    "corner_radius": 4
                                  },
                                  "text_color": "@{plate_text_color}",
                                  "text_alignment_vertical": "top",
                                  "background": [
                                    {
                                      "type": "solid",
                                      "color": "@{plate1_color}"
                                    }
                                  ],
                                  "width": {
                                    "type": "match_parent",
                                    "weight": 1
                                  },
                                  "height": {
                                    "type": "wrap_content"
                                  },
                                  "alignment_horizontal": "left",
                                  "alignment_vertical": "center",
                                  "text_alignment_horizontal": "center",
                                  "margins": {
                                    "right": 2,
                                    "left": 2
                                  },
                                  "focus": {
                                    "next_focus_ids": {
                                      "forward": "plateB"
                                    }
                                  }
                                },
                                {
                                  "id": "plateB",
                                  "type": "text",
                                  "text": "@{variable_plateB}",
                                  "font_size": 32,
                                  "letter_spacing": 0,
                                  "border": {
                                    "corner_radius": 4
                                  },
                                  "text_color": "@{plate_text_color}",
                                  "text_alignment_horizontal": "center",
                                  "text_alignment_vertical": "center",
                                  "width": {
                                    "type": "match_parent",
                                    "weight": 1.2
                                  },
                                  "height": {
                                    "type": "match_parent"
                                  },
                                  "background": [
                                    {
                                      "type": "solid",
                                      "color": "@{plate2_color}"
                                    }
                                  ],
                                  "actions": [
                                    {
                                      "log_id": "show_bottom_sheet_list",
                                      "url": "div-action://bottom_sheet_div?jsonName=vt/plate/letters/bottomsheet"
                                    }
                                  ],
                                  "margins": {
                                    "right": 2,
                                    "left": 2
                                  },
                                  "next_focus_ids": {
                                    "forward": "plateC"
                                  }
                                },
                                {
                                  "next_focus_ids": {
                                    "forward": "plateD"
                                  },
                                  "id": "plateC",
                                  "type": "input",
                                  "text_variable": "variable_plateC",
                                  "max_length": 3,
                                  "hint_text": "@{variable_plateC_hint}",
                                  "keyboard_type": "number",
                                  "font_size": 32,
                                  "letter_spacing": 0,
                                  "border": {
                                    "corner_radius": 4
                                  },
                                  "text_color": "@{plate_text_color}",
                                  "text_alignment_horizontal": "center",
                                  "text_alignment_vertical": "center",
                                  "width": {
                                    "type": "match_parent",
                                    "weight": 1.6
                                  },
                                  "background": [
                                    {
                                      "type": "solid",
                                      "color": "@{plate3_color}"
                                    }
                                  ],
                                  "height": {
                                    "type": "wrap_content"
                                  },
                                  "margins": {
                                    "right": 2,
                                    "left": 2
                                  }
                                },
                                {
                                  "id": "plateD",
                                  "type": "input",
                                  "text_variable": "variable_plateD",
                                  "hint_text": "@{variable_plateD_hint}",
                                  "keyboard_type": "number",
                                  "max_length": 2,
                                  "font_size": 32,
                                  "letter_spacing": 0,
                                  "border": {
                                    "corner_radius": 4
                                  },
                                  "text_color": "@{plate_text_color}",
                                  "text_alignment_horizontal": "center",
                                  "background": [
                                    {
                                      "type": "solid",
                                      "color": "@{plate4_color}"
                                    }
                                  ],
                                  "text_alignment_vertical": "top",
                                  "width": {
                                    "type": "match_parent",
                                    "weight": 1
                                  },
                                  "height": {
                                    "type": "wrap_content"
                                  },
                                  "margins": {
                                    "right": 2,
                                    "left": 2
                                  }
                                }
                              ],
                              "background": [
                                {
                                  "type": "solid",
                                  "color": "#ffffff"
                                }
                              ],
                              "border": {
                                "corner_radius": 4,
                                "has_shadow": 1,
                                "shadow": {
                                  "offset": {
                                    "x": {
                                      "value": 0
                                    },
                                    "y": {
                                      "value": 4
                                    }
                                  },
                                  "blur": 10,
                                  "color": "#000000",
                                  "alpha": 0.05000000074505806
                                }
                              },
                              "height": {
                                "type": "fixed",
                                "value": 56
                              },
                              "width": {
                                "type": "match_parent"
                              },
                              "orientation": "horizontal",
                              "content_alignment_vertical": "center",
                              "content_alignment_horizontal": "center",
                              "margins": {
                                "left": 8
                              }
                            }
                          ],
                          "background": [
                            {
                              "type": "solid",
                              "color": "#e8ecf4"
                            }
                          ],
                          "border": {
                            "corner_radius": 4
                          },
                          "height": {
                            "type": "fixed",
                            "value": 72
                          },
                          "width": {
                            "type": "match_parent"
                          },
                          "orientation": "horizontal",
                          "content_alignment_horizontal": "center",
                          "content_alignment_vertical": "center",
                          "paddings": {
                            "top": 8,
                            "right": 10,
                            "bottom": 8,
                            "left": 10
                          },
                          "alignment_horizontal": "center",
                          "alignment_vertical": "top",
                          "margins": {
                            "top": 8,
                            "right": 12,
                            "left": 12
                          }
                        },
                        {
                          "type": "text",
                          "visibility": "gone",
                          "text": "text",
                          "width": {
                            "type": "fixed",
                            "value": 100
                          }
                        }
                      ]
                    },
                    {
                      "type": "container",
                      "visibility": "@{input_visibility}",
                      "items": [
                        {
                          "type": "container",
                          "items": [
                            {
                              "type": "input",
                              "text_variable": "value",
                              "hint_text": "@{hint}",
                              "keyboard_type": "single_line_text",
                              "font_size": 14,
                              "line_height": 32,
                              "letter_spacing": 0,
                              "text_color": "#a3a3a3",
                              "text_alignment_horizontal": "right",
                              "text_alignment_vertical": "top",
                              "width": {
                                "type": "match_parent"
                              },
                              "height": {
                                "type": "wrap_content"
                              }
                            }
                          ],
                          "height": {
                            "type": "wrap_content"
                          },
                          "width": {
                            "type": "match_parent"
                          },
                          "orientation": "horizontal",
                          "content_alignment_horizontal": "right",
                          "content_alignment_vertical": "center",
                          "margins": {
                            "left": 120
                          }
                        }
                      ],
                      "background": [
                        {
                          "type": "solid",
                          "color": "#ffffff"
                        }
                      ],
                      "border": {
                        "corners_radius": {
                          "top-left": 39,
                          "top-right": 39,
                          "bottom-left": 39,
                          "bottom-right": 39
                        },
                        "stroke": {
                          "color": "#dedede",
                          "width": 1
                        }
                      },
                      "height": {
                        "type": "wrap_content"
                      },
                      "width": {
                        "type": "match_parent"
                      },
                      "orientation": "horizontal",
                      "content_alignment_horizontal": "left",
                      "content_alignment_vertical": "center",
                      "paddings": {
                        "top": 12,
                        "bottom": 12,
                        "left": 12,
                        "right": 12
                      },
                      "margins": {
                        "top": 8,
                        "bottom": 8
                      }
                    }
                  ]
                },
                {
                  "type": "container",
                  "items": [
                    {
                      "type": "container",
                      "items": [
                        {
                          "type": "container",
                          "items": [
                            {
                              "type": "image",
                              "image_url": "https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/8275bac8-4055-4ac8-b397-db38db980ee1",
                              "height": {
                                "type": "fixed",
                                "value": 13
                              },
                              "width": {
                                "type": "fixed",
                                "value": 16
                              }
                            },
                            {
                              "type": "image",
                              "image_url": "https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/7a86cc86-e1fe-4a6c-9336-12be138ad945",
                              "height": {
                                "type": "fixed",
                                "value": 14
                              },
                              "width": {
                                "type": "fixed",
                                "value": 9
                              }
                            },
                            {
                              "type": "image",
                              "image_url": "empty://",
                              "height": {
                                "type": "wrap_content"
                              },
                              "width": {
                                "type": "match_parent"
                              }
                            }
                          ],
                          "height": {
                            "type": "fixed",
                            "value": 24
                          },
                          "width": {
                            "type": "fixed",
                            "value": 24
                          },
                          "orientation": "overlap",
                          "content_alignment_vertical": "center",
                          "content_alignment_horizontal": "center"
                        }
                      ],
                      "background": [
                        {
                          "type": "solid",
                          "color": "#f3f5f9"
                        }
                      ],
                      "border": {
                        "corner_radius": 4
                      },
                      "height": {
                        "type": "wrap_content"
                      },
                      "width": {
                        "type": "fixed",
                        "value": 48
                      },
                      "orientation": "horizontal",
                      "content_alignment_horizontal": "center",
                      "content_alignment_vertical": "center",
                      "paddings": {
                        "top": 12,
                        "bottom": 12,
                        "left": 12,
                        "right": 12
                      }
                    },
                    {
                      "type": "container",
                      "items": [
                        {
                          "type": "container",
                          "items": [
                            {
                              "type": "image",
                              "image_url": "https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/afe449cd-edd1-4d7e-9da4-29dfc5a1a07a",
                              "height": {
                                "type": "fixed",
                                "value": 8
                              },
                              "width": {
                                "type": "fixed",
                                "value": 8
                              }
                            },
                            {
                              "type": "image",
                              "image_url": "https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/845acd2e-ce7e-4ebd-a081-aa7aeabd2b6c",
                              "height": {
                                "type": "fixed",
                                "value": 8
                              },
                              "width": {
                                "type": "fixed",
                                "value": 8
                              }
                            },
                            {
                              "type": "image",
                              "image_url": "https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/e2f015a5-6c1b-4766-b6e3-02dc5fb8db9a",
                              "height": {
                                "type": "fixed",
                                "value": 7
                              },
                              "width": {
                                "type": "fixed",
                                "value": 7
                              }
                            },
                            {
                              "type": "image",
                              "image_url": "https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/43c0c3f2-1c2d-4230-a66f-8a227d6dd624",
                              "height": {
                                "type": "fixed",
                                "value": 8
                              },
                              "width": {
                                "type": "fixed",
                                "value": 8
                              }
                            },
                            {
                              "type": "image",
                              "image_url": "https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/97bff7da-fe0a-4c88-9509-0474b581a8de",
                              "height": {
                                "type": "fixed",
                                "value": 2
                              },
                              "width": {
                                "type": "fixed",
                                "value": 14
                              }
                            },
                            {
                              "type": "image",
                              "image_url": "https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/210d7f88-ab9c-476c-ba60-49523673753a",
                              "height": {
                                "type": "fixed",
                                "value": 4
                              },
                              "width": {
                                "type": "fixed",
                                "value": 10
                              }
                            },
                            {
                              "type": "image",
                              "image_url": "https://figma-alpha-api.s3.us-west-2.amazonaws.com/images/bddadf7a-2a70-4c12-930c-6483f232cf8d",
                              "height": {
                                "type": "fixed",
                                "value": 4
                              },
                              "width": {
                                "type": "fixed",
                                "value": 10
                              }
                            },
                            {
                              "type": "image",
                              "image_url": "empty://",
                              "height": {
                                "type": "wrap_content"
                              },
                              "width": {
                                "type": "match_parent"
                              }
                            }
                          ],
                          "height": {
                            "type": "fixed",
                            "value": 24
                          },
                          "width": {
                            "type": "fixed",
                            "value": 24
                          },
                          "orientation": "overlap",
                          "content_alignment_vertical": "center",
                          "content_alignment_horizontal": "center"
                        }
                      ],
                      "background": [
                        {
                          "type": "solid",
                          "color": "#f3f5f9"
                        }
                      ],
                      "border": {
                        "corner_radius": 4
                      },
                      "height": {
                        "type": "wrap_content"
                      },
                      "width": {
                        "type": "fixed",
                        "value": 48
                      },
                      "orientation": "horizontal",
                      "content_alignment_horizontal": "center",
                      "content_alignment_vertical": "center",
                      "paddings": {
                        "top": 12,
                        "bottom": 12,
                        "left": 12,
                        "right": 12
                      },
                      "margins": {
                        "left": 8
                      }
                    },
                    {
                      "type": "container",
                      "actions": [
                        {
                          "log_id": "reset_phid",
                          "url": "div-action://reset_phid"
                        },
                        {
                          "is_enabled": "@{motor}",
                          "log_id": "call_service",
                          "url": "div-action://call_service?path=AgahiInquiry&ph/token=empty&sysName=agh&plateC=@{variable_plateC_motor}&plateD=@{variable_plateD_motor}&type=@{input_type}&plateType=@{plateType}&value=@{value}&vehicle=@{vehicle_type_index}"
                        },
                        {
                          "is_enabled": "@{car}",
                          "log_id": "call_service",
                          "url": "div-action://call_service?path=AgahiInquiry&ph/token=empty&sysName=agh&plateA=@{variable_plateA}&plateB=@{variable_plateB}&plateC=@{variable_plateC}&plateD=@{variable_plateD}&type=@{input_type}&plateType=@{plateType}&value=@{value}&vehicle=@{vehicle_type_index}"
                        }
                      ],
                      "items": [
                        {
                          "type": "text",
                          "text": "@{text___11}",
                          "font_size": 14,
                          "line_height": 24,
                          "letter_spacing": 0,
                          "text_color": "#ffffff",
                          "text_alignment_horizontal": "left",
                          "text_alignment_vertical": "top",
                          "width": {
                            "type": "wrap_content"
                          },
                          "height": {
                            "type": "wrap_content"
                          }
                        }
                      ],
                      "background": [
                        {
                          "type": "solid",
                          "color": "#193d8d"
                        }
                      ],
                      "border": {
                        "corner_radius": 4
                      },
                      "height": {
                        "type": "fixed",
                        "value": 48
                      },
                      "width": {
                        "type": "match_parent"
                      },
                      "orientation": "horizontal",
                      "content_alignment_horizontal": "center",
                      "content_alignment_vertical": "center",
                      "paddings": {
                        "top": 12,
                        "bottom": 12,
                        "left": 12,
                        "right": 12
                      },
                      "margins": {
                        "left": 8
                      }
                    }
                  ],
                  "height": {
                    "type": "wrap_content"
                  },
                  "width": {
                    "type": "match_parent"
                  },
                  "orientation": "horizontal",
                  "content_alignment_horizontal": "left",
                  "content_alignment_vertical": "top",
                  "margins": {
                    "top": 12
                  }
                }
              ],
              "height": {
                "type": "wrap_content"
              },
              "width": {
                "type": "match_parent"
              },
              "orientation": "vertical",
              "content_alignment_vertical": "top",
              "content_alignment_horizontal": "left",
              "alignment_horizontal": "center",
              "alignment_vertical": "bottom",
              "margins": {
                "left": 12,
                "right": 12,
                "bottom": 12
              }
            },
            {
              "id": "estelam",
              "type": "container",
              "width": {
                "type": "match_parent"
              },
              "height": {
                "type": "wrap_content"
              }
            }
          ],
          "background": [
            {
              "type": "solid",
              "color": "#ffffff"
            }
          ],
          "border": {
            "corner_radius": 4,
            "stroke": {
              "color": "#c8d0e4",
              "width": 1
            }
          },
          "height": {
            "type": "match_parent"
          },
          "width": {
            "type": "match_parent"
          },
          "orientation": "vertical",
          "content_alignment_vertical": "center",
          "content_alignment_horizontal": "center"
        }
      }
    ],
    "variables": [
      {
        "type": "dict",
        "name": "local_palette",
        "value": {
          "bg_primary": {
            "name": "Primary background",
            "light": "#fff",
            "dark": "#000"
          },
          "color0": {
            "name": "Secondary background",
            "light": "#eeeeee",
            "dark": "#000"
          }
        }
      },
      {
        "type": "string",
        "name": "variable_name_family",
        "value": "-"
      },
      {
        "type": "string",
        "name": "variable_nationalCode",
        "value": "-"
      },
      {
        "type": "string",
        "name": "variable_birthDate",
        "value": "-"
      },
      {
        "type": "string",
        "name": "variable_phoneNumber",
        "value": "-"
      },
      {
        "type": "string",
        "name": "variable_model",
        "value": "-"
      },
      {
        "type": "string",
        "name": "variable_usage",
        "value": "-"
      },
      {
        "type": "string",
        "name": "variable_color",
        "value": "-"
      },
      {
        "type": "string",
        "name": "variable_yearOfBuild",
        "value": "-"
      },
      {
        "type": "string",
        "name": "variable_shasi",
        "value": "-"
      },
      {
        "type": "string",
        "name": "variable_tip",
        "value": "-"
      },
      {
        "type": "string",
        "name": "variable_ticket_date",
        "value": "-"
      },
      {
        "type": "string",
        "name": "variable_ticket_title",
        "value": "-"
      },
      {
        "type": "string",
        "name": "variable_ticket_code",
        "value": "-"
      },
      {
        "type": "string",
        "name": "variable_ticket_type",
        "value": "-"
      },
      {
        "type": "string",
        "name": "variable_ticket_location",
        "value": "-"
      },
      {
        "type": "string",
        "name": "variable_agent_code",
        "value": "-"
      },
      {
        "type": "string",
        "name": "variable_ticket_price",
        "value": "-"
      },
      {
        "type": "string",
        "name": "variable_insurance_number",
        "value": "-"
      },
      {
        "type": "boolean",
        "name": "instruction",
        "value": true
      },
      {
        "type": "boolean",
        "name": "inquiry_agahi",
        "value": true
      },
      {
        "type": "string",
        "name": "variable_insurance_type",
        "value": "-"
      },
      {
        "type": "string",
        "name": "variable_insurance_name",
        "value": "-"
      },
      {
        "type": "string",
        "name": "variable_insurance_expire",
        "value": "-"
      },
      {
        "type": "string",
        "name": "variable_total_ticket",
        "value": "-"
      },
      {
        "type": "string",
        "name": "text___1",
        "value": "قطعات خودرو"
      },
      {
        "type": "string",
        "name": "text___2",
        "value": "خودرو"
      },
      {
        "type": "string",
        "name": "text___3",
        "value": "منطقه ای شخصی"
      },
      {
        "type": "string",
        "name": "text___4",
        "value": "پلاک"
      },
      {
        "type": "string",
        "name": "text_i_r__5",
        "value": "i.r."
      },
      {
        "type": "string",
        "name": "text_iran_6",
        "value": "iran"
      },
      {
        "type": "string",
        "name": "text___7",
        "value": "۱۲"
      },
      {
        "type": "string",
        "name": "text___8",
        "value": "ب"
      },
      {
        "type": "string",
        "name": "text___9",
        "value": "۷۵۰"
      },
      {
        "type": "string",
        "name": "text___10",
        "value": "۱۲"
      },
      {
        "type": "string",
        "name": "text___11",
        "value": "استعلام"
      },
      {
        "type": "string",
        "name": "variable_plateA",
        "value": ""
      },
      {
        "type": "string",
        "name": "variable_plateB",
        "value": "ب"
      },
      {
        "type": "string",
        "name": "variable_plateC",
        "value": ""
      },
      {
        "type": "string",
        "name": "variable_plateD",
        "value": ""
      },
      {
        "type": "string",
        "name": "selected_tab",
        "value": "ffffff"
      },
      {
        "type": "string",
        "name": "unselected_tab",
        "value": "e8ecf4"
      },
      {
        "type": "string",
        "name": "selected_tab_text",
        "value": "193d8d"
      },
      {
        "type": "string",
        "name": "unselected_tab_text",
        "value": "757575"
      },
      {
        "type": "string",
        "name": "plate_color",
        "value": "#ffffff"
      },
      {
        "type": "string",
        "name": "plate_color2",
        "value": "#ffffff"
      },
      {
        "type": "string",
        "name": "plate_text_color",
        "value": "#193d8d"
      },
      {
        "type": "string",
        "name": "plate_text_color2",
        "value": "#193d8d"
      },
      {
        "type": "string",
        "name": "shasi_color",
        "value": "#e8ecf4"
      },
      {
        "type": "string",
        "name": "shasi_text_color",
        "value": "#757575"
      },
      {
        "type": "string",
        "name": "motor_color",
        "value": "#e8ecf4"
      },
      {
        "type": "string",
        "name": "motor_text_color",
        "value": "#757575"
      },
      {
        "type": "string",
        "name": "motor_color2",
        "value": "#e8ecf4"
      },
      {
        "type": "string",
        "name": "motor_text_color2",
        "value": "#757575"
      },
      {
        "type": "string",
        "name": "vin_color",
        "value": "#e8ecf4"
      },
      {
        "type": "string",
        "name": "vin_text_color",
        "value": "#757575"
      },
      {
        "type": "string",
        "name": "tab_index",
        "value": "1"
      },
      {
        "type": "string",
        "name": "value",
        "value": ""
      },
      {
        "type": "string",
        "name": "hint",
        "value": ""
      },
      {
        "type": "string",
        "name": "input_visibility",
        "value": "gone"
      },
      {
        "type": "string",
        "name": "plate_visibility",
        "value": "visible"
      },
      {
        "type": "string",
        "name": "variable_personInfo_visibility",
        "value": "visible"
      },
      {
        "type": "string",
        "name": "variable_carInfo_visibility",
        "value": "visible"
      },
      {
        "type": "string",
        "name": "variable_lastTicket_visibility",
        "value": "visible"
      },
      {
        "type": "string",
        "name": "variable_violation_visibility",
        "value": "visible"
      },
      {
        "type": "string",
        "name": "variable_command_visibility",
        "value": "visible"
      },
      {
        "type": "string",
        "name": "variable_agahiInquiry_visibility",
        "value": "visible"
      },
      {
        "type": "string",
        "name": "variable_insurance_visibility",
        "value": "visible"
      },
      {
        "type": "string",
        "name": "variable_tecnical_visit_visibility",
        "value": "visible"
      },
      {
        "type": "string",
        "name": "input_type",
        "value": "plate"
      },
      {
        "type": "string",
        "name": "variable_plateA_hint",
        "value": "۱۱"
      },
      {
        "type": "string",
        "name": "variable_plateA_motor_hint",
        "value": "۱۱۱"
      },
      {
        "type": "boolean",
        "name": "variable_insurance",
        "value": false
      },
      {
        "type": "string",
        "name": "variable_plateC_motor_hint",
        "value": "۱۱۱۱۱"
      },
      {
        "type": "string",
        "name": "variable_plateB_hint",
        "value": "ب"
      },
      {
        "type": "string",
        "name": "variable_plateC_hint",
        "value": "۱۱۱"
      },
      {
        "type": "string",
        "name": "variable_plateD_hint",
        "value": "۱۱"
      },
      {
        "type": "string",
        "name": "variable_plateE_hint",
        "value": "۱۱"
      },
      {
        "type": "string",
        "name": "variable_plateF_hint",
        "value": "۱۱"
      },
      {
        "type": "string",
        "name": "patch",
        "value": "منطقه ای شخصی"
      },
      {
        "type": "string",
        "name": "plate1_color",
        "value": "#ffffff"
      },
      {
        "type": "string",
        "name": "plate2_color",
        "value": "#ffffff"
      },
      {
        "type": "string",
        "name": "plate3_color",
        "value": "#ffffff"
      },
      {
        "type": "string",
        "name": "plate4_color",
        "value": "#ffffff"
      },
      {
        "type": "string",
        "name": "plate_text_color",
        "value": "#4F4F4F"
      },
      {
        "type": "string",
        "name": "variable_plateC_motor",
        "value": ""
      },
      {
        "type": "string",
        "name": "variable_plateD_motor",
        "value": ""
      },
      {
        "type": "string",
        "name": "variable_plateA_motor_hint",
        "value": "111"
      },
      {
        "type": "string",
        "name": "vehicle_type_index",
        "value": "1"
      },
      {
        "type": "string",
        "name": "vehicle_type",
        "value": ""
      },
      {
        "type": "string",
        "name": "plateType",
        "value": "patchVehiclePlate"
      },
      {
        "type": "string",
        "name": "patch_title",
        "value": ""
      },
      {
        "type": "string",
        "name": "plate_type",
        "value": ""
      },
      {
        "type": "boolean",
        "name": "vehicle",
        "value": true
      },
      {
        "type": "boolean",
        "name": "car",
        "value": true
      },
      {
        "type": "boolean",
        "name": "motor",
        "value": false
      }
    ],
    "variable_triggers": [
      {
        "condition": "@{tab_index!='1'}a",
        "mode": "on_condition",
        "actions": [
          {
            "log_id": "change home text color",
            "url": "div-action://change_color?name=plate_color&value=@{unselected_tab}"
          },
          {
            "log_id": "change home line color",
            "url": "div-action://change_color?name=plate_text_color&value=@{unselected_tab_text}"
          },
          {
            "log_id": "update_visibility",
            "url": "div-action://set_variable?name=plate_visibility&value=gone"
          },
          {
            "log_id": "update_visibility",
            "url": "div-action://set_variable?name=input_visibility&value=visible"
          }
        ]
      },
      {
        "condition": "@{tab_index!='2'}",
        "mode": "on_condition",
        "actions": [
          {
            "log_id": "change home text color",
            "url": "div-action://change_color?name=shasi_color&value=@{unselected_tab}"
          },
          {
            "log_id": "change home line color",
            "url": "div-action://change_color?name=shasi_text_color&value=@{unselected_tab_text}"
          }
        ]
      },
      {
        "condition": "@{tab_index!='3'}",
        "mode": "on_condition",
        "actions": [
          {
            "log_id": "change home text color",
            "url": "div-action://change_color?name=motor_color&value=@{unselected_tab}"
          },
          {
            "log_id": "change home line color",
            "url": "div-action://change_color?name=motor_text_color&value=@{unselected_tab_text}"
          }
        ]
      },
      {
        "condition": "@{tab_index!='4'}",
        "mode": "on_condition",
        "actions": [
          {
            "log_id": "change home text color",
            "url": "div-action://change_color?name=vin_color&value=@{unselected_tab}"
          },
          {
            "log_id": "change home line color",
            "url": "div-action://change_color?name=vin_text_color&value=@{unselected_tab_text}"
          }
        ]
      },
      {
        "condition": "@{variable_plateA.length > 1}",
        "mode": "on_condition",
        "actions": [
          {
            "log_id": "focus_one",
            "typed": {
              "type": "focus_element",
              "element_id": "plateC"
            }
          }
        ]
      },
      {
        "condition": "@{variable_plateC.length > 1}",
        "mode": "on_condition",
        "actions": [
          {
            "log_id": "focus_one",
            "typed": {
              "type": "focus_element",
              "element_id": "plateD"
            }
          }
        ]
      },
      {
        "condition": "@{variable_plateD.length > 1}",
        "mode": "on_condition",
        "actions": [
          {
            "log_id": "focus_six",
            "typed": {
              "type": "focus_element",
              "element_id": "plateC"
            }
          }
        ]
      },
      {
        "condition": "@{variable_plateC.length > 1}",
        "mode": "on_condition",
        "actions": [
          {
            "log_id": "focus_six",
            "typed": {
              "type": "focus_element",
              "element_id": "plateA"
            }
          }
        ]
      },
      {
        "condition": "@{vehicle_type =='car' }",
        "mode": "on_condition",
        "actions": [
          {
            "log_id": "car change",
            "url": "div-action://set_variable?name=car&value=true"
          },
          {
            "log_id": "motor change",
            "url": "div-action://set_variable?name=motor&value=false"
          }
        ]
      },
      {
        "condition": "@{vehicle_type =='motor' }",
        "mode": "on_condition",
        "actions": [
          {
            "log_id": "car change",
            "url": "div-action://set_variable?name=motor&value=true"
          },
          {
            "log_id": "motor change",
            "url": "div-action://set_variable?name=car&value=false"
          }
        ]
      }
    ]
  },
  "templates": {
    "numbering_order_template": {
      "type": "container",
      "$id": "numbering_order_id",
      "items": [
        {
          "type": "container",
          "items": [
            {
              "type": "text",
              "$text": "text",
              "font_size": 12,
              "line_height": 24,
              "letter_spacing": 0,
              "$text_color": "text_color",
              "text_alignment_horizontal": "right",
              "text_alignment_vertical": "top",
              "width": {
                "type": "wrap_content"
              },
              "height": {
                "type": "wrap_content"
              }
            }
          ],
          "background": [
            {
              "type": "solid",
              "$color": "background_color"
            }
          ],
          "border": {
            "corner_radius": 4
          },
          "height": {
            "type": "wrap_content"
          },
          "width": {
            "type": "fixed",
            "value": 140
          },
          "orientation": "horizontal",
          "content_alignment_horizontal": "center",
          "content_alignment_vertical": "center",
          "paddings": {
            "left": 8,
            "right": 8
          },
          "alignment_horizontal": "left",
          "alignment_vertical": "center"
        },
        {
          "type": "text",
          "$text": "title",
          "font_size": 12,
          "line_height": 24,
          "letter_spacing": 0,
          "text_color": "#7f7f7f",
          "text_alignment_horizontal": "center",
          "text_alignment_vertical": "top",
          "width": {
            "type": "wrap_content"
          },
          "height": {
            "type": "wrap_content"
          },
          "alignment_horizontal": "right",
          "alignment_vertical": "center"
        }
      ],
      "height": {
        "type": "fixed",
        "value": 24
      },
      "width": {
        "type": "match_parent"
      },
      "orientation": "overlap",
      "content_alignment_horizontal": "left",
      "content_alignment_vertical": "center",
      "margins": {
        "top": 16
      }
    },
    "agh_template": {
      "type": "container",
      "width": {
        "type": "match_parent"
      },
      "height": {
        "type": "wrap_content"
      },
      "items": [
        {
          "type": "container",
          "items": [
            {
              "type": "container",
              "items": [
                {
                  "type": "text",
                  "$text": "agh_order",
                  "font_size": 12,
                  "line_height": 24,
                  "letter_spacing": 0,
                  "$text_color": "text_color",
                  "text_alignment_horizontal": "right",
                  "text_alignment_vertical": "top",
                  "width": {
                    "type": "wrap_content"
                  },
                  "height": {
                    "type": "wrap_content"
                  }
                }
              ],
              "background": [
                {
                  "type": "solid",
                  "$color": "order_background_color"
                }
              ],
              "border": {
                "corner_radius": 4
              },
              "height": {
                "type": "wrap_content"
              },
              "width": {
                "type": "fixed",
                "value": 140
              },
              "orientation": "horizontal",
              "content_alignment_horizontal": "center",
              "content_alignment_vertical": "center",
              "paddings": {
                "left": 8,
                "right": 8
              },
              "alignment_horizontal": "left",
              "alignment_vertical": "center"
            },
            {
              "type": "text",
              "text": "دستور",
              "font_size": 12,
              "line_height": 24,
              "letter_spacing": 0,
              "$text_color": "order_text_color",
              "text_alignment_horizontal": "center",
              "text_alignment_vertical": "top",
              "width": {
                "type": "wrap_content"
              },
              "height": {
                "type": "wrap_content"
              },
              "alignment_horizontal": "right",
              "alignment_vertical": "center"
            }
          ],
          "height": {
            "type": "fixed",
            "value": 24
          },
          "width": {
            "type": "match_parent"
          },
          "orientation": "overlap",
          "content_alignment_horizontal": "left",
          "content_alignment_vertical": "center",
          "margins": {
            "top": 16
          }
        },
        {
          "type": "container",
          "items": [
            {
              "type": "container",
              "items": [
                {
                  "type": "text",
                  "$text": "agh_order_date",
                  "font_size": 12,
                  "line_height": 24,
                  "letter_spacing": 0,
                  "text_color": "#2c2c2c",
                  "text_alignment_horizontal": "right",
                  "text_alignment_vertical": "top",
                  "width": {
                    "type": "wrap_content"
                  },
                  "height": {
                    "type": "wrap_content"
                  }
                }
              ],
              "border": {
                "corner_radius": 4
              },
              "height": {
                "type": "wrap_content"
              },
              "width": {
                "type": "fixed",
                "value": 140
              },
              "orientation": "horizontal",
              "content_alignment_horizontal": "center",
              "content_alignment_vertical": "center",
              "paddings": {
                "left": 8,
                "right": 8
              },
              "alignment_horizontal": "left",
              "alignment_vertical": "center"
            },
            {
              "type": "text",
              "text": "تاریخ دستور",
              "font_size": 12,
              "line_height": 24,
              "letter_spacing": 0,
              "text_color": "#7f7f7f",
              "text_alignment_horizontal": "center",
              "text_alignment_vertical": "top",
              "width": {
                "type": "wrap_content"
              },
              "height": {
                "type": "wrap_content"
              },
              "alignment_horizontal": "right",
              "alignment_vertical": "center"
            }
          ],
          "height": {
            "type": "fixed",
            "value": 24
          },
          "width": {
            "type": "match_parent"
          },
          "orientation": "overlap",
          "content_alignment_horizontal": "left",
          "content_alignment_vertical": "center",
          "margins": {
            "top": 16
          }
        },
        {
          "type": "container",
          "items": [
            {
              "type": "container",
              "items": [
                {
                  "type": "text",
                  "$text": "collision_type",
                  "font_size": 12,
                  "line_height": 24,
                  "letter_spacing": 0,
                  "text_color": "#2c2c2c",
                  "text_alignment_horizontal": "right",
                  "text_alignment_vertical": "top",
                  "width": {
                    "type": "wrap_content"
                  },
                  "height": {
                    "type": "wrap_content"
                  }
                }
              ],
              "border": {
                "corner_radius": 4
              },
              "height": {
                "type": "wrap_content"
              },
              "width": {
                "type": "fixed",
                "value": 140
              },
              "orientation": "horizontal",
              "content_alignment_horizontal": "center",
              "content_alignment_vertical": "center",
              "paddings": {
                "left": 8,
                "right": 8
              },
              "alignment_horizontal": "left",
              "alignment_vertical": "center"
            },
            {
              "type": "text",
              "text": "نوع برخورد",
              "font_size": 12,
              "line_height": 24,
              "letter_spacing": 0,
              "text_color": "#7f7f7f",
              "text_alignment_horizontal": "center",
              "text_alignment_vertical": "top",
              "width": {
                "type": "wrap_content"
              },
              "height": {
                "type": "wrap_content"
              },
              "alignment_horizontal": "right",
              "alignment_vertical": "center"
            }
          ],
          "height": {
            "type": "fixed",
            "value": 24
          },
          "width": {
            "type": "match_parent"
          },
          "orientation": "overlap",
          "content_alignment_horizontal": "left",
          "content_alignment_vertical": "center",
          "margins": {
            "top": 16
          }
        },
        {
          "type": "container",
          "items": [
            {
              "type": "container",
              "items": [
                {
                  "type": "text",
                  "$text": "announcement_date",
                  "font_size": 12,
                  "line_height": 24,
                  "letter_spacing": 0,
                  "text_color": "#2c2c2c",
                  "text_alignment_horizontal": "right",
                  "text_alignment_vertical": "top",
                  "width": {
                    "type": "wrap_content"
                  },
                  "height": {
                    "type": "wrap_content"
                  }
                }
              ],
              "border": {
                "corner_radius": 4
              },
              "height": {
                "type": "wrap_content"
              },
              "width": {
                "type": "fixed",
                "value": 140
              },
              "orientation": "horizontal",
              "content_alignment_horizontal": "center",
              "content_alignment_vertical": "center",
              "paddings": {
                "left": 8,
                "right": 8
              },
              "alignment_horizontal": "left",
              "alignment_vertical": "center"
            },
            {
              "type": "text",
              "text": "تاریخ اعلان ",
              "font_size": 12,
              "line_height": 24,
              "letter_spacing": 0,
              "text_color": "#7f7f7f",
              "text_alignment_horizontal": "center",
              "text_alignment_vertical": "top",
              "width": {
                "type": "wrap_content"
              },
              "height": {
                "type": "wrap_content"
              },
              "alignment_horizontal": "right",
              "alignment_vertical": "center"
            }
          ],
          "height": {
            "type": "fixed",
            "value": 24
          },
          "width": {
            "type": "match_parent"
          },
          "orientation": "overlap",
          "content_alignment_horizontal": "left",
          "content_alignment_vertical": "center",
          "margins": {
            "top": 16
          }
        },
        {
          "type": "container",
          "items": [
            {
              "type": "container",
              "items": [
                {
                  "type": "text",
                  "$text": "agh_order_location",
                  "font_size": 12,
                  "line_height": 24,
                  "letter_spacing": 0,
                  "text_color": "#2c2c2c",
                  "text_alignment_horizontal": "right",
                  "text_alignment_vertical": "top",
                  "width": {
                    "type": "wrap_content"
                  },
                  "height": {
                    "type": "wrap_content"
                  }
                }
              ],
              "border": {
                "corner_radius": 4
              },
              "height": {
                "type": "wrap_content"
              },
              "width": {
                "type": "fixed",
                "value": 140
              },
              "orientation": "horizontal",
              "content_alignment_horizontal": "center",
              "content_alignment_vertical": "center",
              "paddings": {
                "left": 8,
                "right": 8
              },
              "alignment_horizontal": "left",
              "alignment_vertical": "center"
            },
            {
              "type": "text",
              "text": "آدرس دستور ",
              "font_size": 12,
              "line_height": 24,
              "letter_spacing": 0,
              "text_color": "#7f7f7f",
              "text_alignment_horizontal": "center",
              "text_alignment_vertical": "top",
              "width": {
                "type": "wrap_content"
              },
              "height": {
                "type": "wrap_content"
              },
              "alignment_horizontal": "right",
              "alignment_vertical": "center"
            }
          ],
          "height": {
            "type": "fixed",
            "value": 24
          },
          "width": {
            "type": "match_parent"
          },
          "orientation": "overlap",
          "content_alignment_horizontal": "left",
          "content_alignment_vertical": "center",
          "margins": {
            "top": 16
          }
        },
        {
          "type": "container",
          "items": [
            {
              "type": "container",
              "items": [
                {
                  "type": "text",
                  "$text": "discover_location",
                  "font_size": 12,
                  "line_height": 24,
                  "letter_spacing": 0,
                  "text_color": "#2c2c2c",
                  "text_alignment_horizontal": "right",
                  "text_alignment_vertical": "top",
                  "width": {
                    "type": "wrap_content"
                  },
                  "height": {
                    "type": "wrap_content"
                  }
                }
              ],
              "border": {
                "corner_radius": 4
              },
              "height": {
                "type": "wrap_content"
              },
              "width": {
                "type": "fixed",
                "value": 140
              },
              "orientation": "horizontal",
              "content_alignment_horizontal": "center",
              "content_alignment_vertical": "center",
              "paddings": {
                "left": 8,
                "right": 8
              },
              "alignment_horizontal": "left",
              "alignment_vertical": "center"
            },
            {
              "type": "text",
              "text": "آدرس کشف ",
              "font_size": 12,
              "line_height": 24,
              "letter_spacing": 0,
              "text_color": "#7f7f7f",
              "text_alignment_horizontal": "center",
              "text_alignment_vertical": "top",
              "width": {
                "type": "wrap_content"
              },
              "height": {
                "type": "wrap_content"
              },
              "alignment_horizontal": "right",
              "alignment_vertical": "center"
            }
          ],
          "height": {
            "type": "fixed",
            "value": 24
          },
          "width": {
            "type": "match_parent"
          },
          "orientation": "overlap",
          "content_alignment_horizontal": "left",
          "content_alignment_vertical": "center",
          "margins": {
            "top": 16
          }
        },
        {
          "type": "container",
          "items": [
            {
              "type": "container",
              "items": [
                {
                  "type": "text",
                  "$text": "discover_date",
                  "font_size": 12,
                  "line_height": 24,
                  "letter_spacing": 0,
                  "text_color": "#2c2c2c",
                  "text_alignment_horizontal": "right",
                  "text_alignment_vertical": "top",
                  "width": {
                    "type": "wrap_content"
                  },
                  "height": {
                    "type": "wrap_content"
                  }
                }
              ],
              "border": {
                "corner_radius": 4
              },
              "height": {
                "type": "wrap_content"
              },
              "width": {
                "type": "fixed",
                "value": 140
              },
              "orientation": "horizontal",
              "content_alignment_horizontal": "center",
              "content_alignment_vertical": "center",
              "paddings": {
                "left": 8,
                "right": 8
              },
              "alignment_horizontal": "left",
              "alignment_vertical": "center"
            },
            {
              "type": "text",
              "text": "تاریخ کشف",
              "font_size": 12,
              "line_height": 24,
              "letter_spacing": 0,
              "text_color": "#7f7f7f",
              "text_alignment_horizontal": "center",
              "text_alignment_vertical": "top",
              "width": {
                "type": "wrap_content"
              },
              "height": {
                "type": "wrap_content"
              },
              "alignment_horizontal": "right",
              "alignment_vertical": "center"
            }
          ],
          "height": {
            "type": "fixed",
            "value": 24
          },
          "width": {
            "type": "match_parent"
          },
          "orientation": "overlap",
          "content_alignment_horizontal": "left",
          "content_alignment_vertical": "center",
          "margins": {
            "top": 16
          }
        },
        {
          "type": "container",
          "items": [
            {
              "type": "container",
              "items": [
                {
                  "type": "text",
                  "$text": "agh_description",
                  "font_size": 12,
                  "line_height": 24,
                  "letter_spacing": 0,
                  "text_color": "#2c2c2c",
                  "text_alignment_horizontal": "right",
                  "text_alignment_vertical": "top",
                  "width": {
                    "type": "wrap_content"
                  },
                  "height": {
                    "type": "wrap_content"
                  }
                }
              ],
              "border": {
                "corner_radius": 4
              },
              "height": {
                "type": "wrap_content"
              },
              "width": {
                "type": "fixed",
                "value": 140
              },
              "orientation": "horizontal",
              "content_alignment_horizontal": "center",
              "content_alignment_vertical": "center",
              "paddings": {
                "left": 8,
                "right": 8
              },
              "alignment_horizontal": "left",
              "alignment_vertical": "center"
            },
            {
              "type": "text",
              "text": "شرح برخورد",
              "font_size": 12,
              "line_height": 24,
              "letter_spacing": 0,
              "text_color": "#7f7f7f",
              "text_alignment_horizontal": "center",
              "text_alignment_vertical": "top",
              "width": {
                "type": "wrap_content"
              },
              "height": {
                "type": "wrap_content"
              },
              "alignment_horizontal": "right",
              "alignment_vertical": "center"
            }
          ],
          "height": {
            "type": "fixed",
            "value": 24
          },
          "width": {
            "type": "match_parent"
          },
          "orientation": "overlap",
          "content_alignment_horizontal": "left",
          "content_alignment_vertical": "center",
          "margins": {
            "top": 16
          }
        }
      ]
    },
    "nodata_template": {
      "type": "container",
      "width": {
        "type": "match_parent"
      },
      "height": {
        "type": "wrap_content"
      },
      "items": [
        {
          "type": "text",
          "text": "استعلامی وجود ندارد",
          "font_size": 12,
          "line_height": 24,
          "letter_spacing": 0,
          "text_color": "#d73333",
          "text_alignment_horizontal": "center",
          "text_alignment_vertical": "top",
          "width": {
            "type": "match_parent"
          },
          "height": {
            "type": "wrap_content"
          }
        }
      ]
    }
  }
}
  */