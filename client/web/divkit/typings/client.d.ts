import type {
    DivJson,
    StatCallback,
    ErrorCallback,
    DivkitInstance,
    Platform,
    CustomActionCallback,
    Theme,
    Customization,
    DivExtensionClass,
    TypefaceProvider,
    FetchInit,
    Direction
} from './common';
import type { CustomComponentDescription } from './custom';
import type { Store } from './store';
import type { GlobalVariablesController } from './variables';

export function render(opts: {
    target: HTMLElement;
    json: DivJson;
    id: string;
    globalVariablesController?: GlobalVariablesController;
    mix?: string;
    onStat?: StatCallback;
    onCustomAction?: CustomActionCallback;
    onError?: ErrorCallback;
    typefaceProvider?: TypefaceProvider;
    platform?: Platform;
    customization?: Customization;
    builtinProtocols?: string[];
    extensions?: Map<string, DivExtensionClass>;
    /** @deprecated */
    theme?: Theme;
    fetchInit?: FetchInit;
    tooltipRoot?: HTMLElement;
    customComponents?: Map<string, CustomComponentDescription> | undefined;
    direction?: Direction;
    store?: Store;
    weekStartDay?: number;
    pagerChildrenClipEnabled?: boolean;
}): DivkitInstance;

export { createVariable, createGlobalVariablesController } from './variables';

export {
    SizeProvider,
    Gesture,
    lottieExtensionBuilder,
    markdownExtensionBuilder
} from './extensions';
