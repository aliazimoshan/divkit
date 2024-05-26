import Root from "./components/Root.svelte";
import { SizeProvider } from "./extensions/sizeProvider";
import { lottieExtensionBuilder } from "./extensions/lottie";
import type { DivExtensionClass } from "../typings/common";
import Lottie from "lottie-web/build/player/lottie";
import { initComponents } from "./devCustomComponents";

const json = {
  templates: {
    text_block: {
      type: "text",
      font_size: 12,
      line_height: 15,
      text_alignment_horizontal: "center",
      text_alignment_vertical: "center",
      alignment_horizontal: "center",
      text_color: "#000000",
      paddings: {
        top: 4,
        bottom: 4,
        left: 8,
        right: 8,
      },
      width: {
        type: "fixed",
        value: 80,
      },
      height: {
        type: "fixed",
        value: 104,
      },
      background: [
        {
          type: "solid",
          color: "#0E000000",
        },
      ],
      border: {
        corner_radius: 16,
      },
    },
    title: {
      type: "text",
      font_size: 20,
      line_height: 24,
      font_weight: "bold",
      paddings: {
        left: 24,
        right: 24,
        bottom: 16,
      },
    },
    subtitle: {
      font_size: 15,
      line_height: 20,
      type: "text",
      paddings: {
        left: 24,
        right: 24,
      },
    },
  },
  card: {
    log_id: "sample_card",
    states: [
      {
        state_id: 0,
        div: {
          type: "container",
          orientation: "vertical",
          margins: {
            top: 24,
            bottom: 24,
          },
          items: [
            {
              type: "title",
              text: "Gallery",
            },
            {
              type: "subtitle",
              text: "Displays elements with any content, not just images. It lets you set the distance between adjacent elements.",
              margins: {
                bottom: 24,
              },
            },
            {
              type: "gallery",
              height: {
                type: "fixed",
                value: 104,
              },
              paddings: {
                left: 16,
                right: 16,
              },
              item_spacing: 16,
              items: [
                {
                  type: "text_block",
                  text: "Item 0",
                },
                {
                  type: "text_block",
                  text: "Item 1",
                },
                {
                  type: "text_block",
                  text: "Item 2",
                },
                {
                  type: "text_block",
                  text: "Item 3",
                },
                {
                  type: "text_block",
                  text: "Item 4",
                },
                {
                  type: "text_block",
                  text: "Item 4",
                },
                {
                  type: "text_block",
                  text: "Item 4",
                },
                {
                  type: "text_block",
                  text: "Item 4",
                },
              ],
            },
          ],
        },
      },
    ],
  },
};

window.root = new Root({
  target: document.body,
  props: {
    id: "abcde",
    json,
    onStat(arg) {
      console.log(arg);
    },
    extensions: new Map<string, DivExtensionClass>([
      ["size_provider", SizeProvider],
      ["lottie", lottieExtensionBuilder(Lottie.loadAnimation)],
    ]),
    customComponents: new Map([
      [
        "old_custom_card_1",
        {
          element: "old-custom-card1",
        },
      ],
      [
        "old_custom_card_2",
        {
          element: "old-custom-card2",
        },
      ],
      [
        "new_custom_card_1",
        {
          element: "new-custom-card",
        },
      ],
      [
        "new_custom_card_2",
        {
          element: "new-custom-card",
        },
      ],
      [
        "new_custom_container_1",
        {
          element: "new-custom-container",
        },
      ],
    ]),
    store: {
      getValue(name, type) {
        try {
          const json = localStorage.getItem("divkit:" + name);
          if (json) {
            const parsed = JSON.parse(json);
            if (
              type === parsed.type &&
              Date.now() < parsed.lifetime &&
              parsed.value
            ) {
              return parsed.value;
            }
          }
        } catch (err) {
          //
        }
      },
      setValue(name, type, value, lifetime) {
        try {
          localStorage.setItem(
            "divkit:" + name,
            JSON.stringify({
              value,
              type,
              lifetime: Date.now() + lifetime * 1000,
            })
          );
        } catch (err) {
          //
        }
      },
    },
  },
});

initComponents();
