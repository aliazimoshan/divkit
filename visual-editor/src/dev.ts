import './main.css';
import { DivProEditor, type DivProEditorInstance, type Locale } from './lib';
import {
  convertDictToPalette,
  convertPaletteToDict,
} from './lib/utils/convertPalette';
import langAuto from './auto/lang.json';
import {
  addTemplatesSuffix,
  removeTemplatesSuffix,
} from './lib/utils/renameTemplates';

const themeQuery = matchMedia('(prefers-color-scheme: dark)');

themeQuery.addListener(() => {
  editor.setTheme(themeQuery.matches ? 'dark' : 'light');
});

const AVAIL_LOCALES: Locale[] = ['ru', 'en'];
const detectLocale = (): Locale => {
  for (const item of navigator.languages) {
    const parts = item.split('-');
    const part = parts[0] as Locale;
    if (AVAIL_LOCALES.includes(part)) {
      return part;
    }
  }
  return 'en';
};

window.addEventListener('languagechange', () => {
  if (editor) {
    editor.setLocale(detectLocale());
  }
});

declare global {
  interface Window {
    editor: DivProEditorInstance;
    convertDictToPalette: typeof convertDictToPalette;
    convertPaletteToDict: typeof convertPaletteToDict;
    addTemplatesSuffix: typeof addTemplatesSuffix;
    removeTemplatesSuffix: typeof removeTemplatesSuffix;
  }
}

const editor = (window.editor = DivProEditor.init({
  renderTo: document.getElementById('app') as HTMLElement,
  locale: detectLocale(),
  rootConfigurable: true,
  card: {
    json: JSON.stringify({
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
        variables: [],
      },
    }),
    // "meta": {
    //     "tanker": {
    //         "props.lottie_url": {
    //             "ru": "Анимация",
    //             "en": "Animation"
    //         }
    //     }
    // }
  },
  theme: themeQuery.matches ? 'dark' : 'light',
  layout: [
    {
      items: ['new-component'],
      minWidth: 400,
    },
    {
      items: ['preview'],
      weight: 3,
    },
    {
      items: ['component-props:code'],
      minWidth: 360,
    },
  ],
  actionLogUrlVariable: 'on_click_log_url',
  paletteEnabled: true,
  cardLocales: [
    {
      id: 'ru',
      text: {
        ru: 'RU',
        en: 'RU',
      },
    },
    {
      id: 'en',
      text: {
        ru: 'EN',
        en: 'EN',
      },
    },
  ],
  sources: [
    {
      key: 'test',
      url: 'https://ya.ru/api',
      example: {
        logged: 1,
        login: 'Vasya',
        mailCount: 123,
      },
    },
  ],
  customActions: [
    {
      baseUrl: 'div-screen://close',
      text: {
        ru: 'Закрыть',
        en: 'Close',
      },
    },
    {
      baseUrl: 'div-screen://open',
      text: {
        ru: 'Открыть',
        en: 'Open',
      },
      args: [
        {
          type: 'string',
          name: 'id',
          text: {
            ru: 'ID',
            en: 'ID',
          },
        },
      ],
    },
    {
      baseUrl: 'div-screen://next_slide',
      text: {
        ru: 'Следующий',
        en: 'Next',
      },
    },
  ],
  // readOnly: true,
  api: {
    getTranslationKey(key) {
      return new Promise((resolve) => {
        setTimeout(() => {
          if (key in langAuto.en) {
            const res: Record<string, string> = {};

            res.en = String(langAuto.en[key as keyof typeof langAuto.en]);

            resolve(res);
          } else {
            resolve(undefined);
          }
        }, Math.random() * 500);
      });
    },
    getTranslationSuggest(query, locale) {
      return new Promise((resolve) => {
        setTimeout(() => {
          const obj = langAuto[locale as keyof typeof langAuto];
          const folders = [
            ...new Set(
              Object.keys(obj)
                .filter((key) => key.includes('.'))
                .map((key) => key.split('.')[0] + '.'),
            ),
          ];

          resolve(
            folders
              .concat(Object.keys(obj))
              .filter(
                (key) =>
                  key.startsWith(query) &&
                  !(query.endsWith('.') && key === query),
              )
              .map((key) => {
                return {
                  key,
                  text: String(obj[key as keyof typeof obj]),
                };
              }),
          );
        }, Math.random() * 500);
      });
    },
  },
}));

window.convertDictToPalette = convertDictToPalette;
window.convertPaletteToDict = convertPaletteToDict;

window.addTemplatesSuffix = addTemplatesSuffix;
window.removeTemplatesSuffix = removeTemplatesSuffix;
