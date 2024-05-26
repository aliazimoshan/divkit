import type { BooleanInt } from '../../typings/common';
import type { Dimension } from './sizes';

export interface Stroke {
    width?: number;
    color: string;
    // unit
}

export interface CornersRadius {
    'top-left'?: number;
    'top-right'?: number;
    'bottom-left'?: number;
    'bottom-right'?: number;
}

export interface Point {
    x: Dimension;
    y: Dimension;
}

export interface Shadow {
    color?: string;
    offset: Point;
    blur?: number;
    alpha?: number;
}

export interface Border {
    has_shadow?: BooleanInt;
    shadow?: Shadow;
    stroke?: Stroke;
    corner_radius?: number;
    corners_radius?: CornersRadius;
}
