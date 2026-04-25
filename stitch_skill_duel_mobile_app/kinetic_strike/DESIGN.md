---
name: Kinetic Strike
colors:
  surface: '#1d1011'
  surface-dim: '#1d1011'
  surface-bright: '#463536'
  surface-container-lowest: '#170b0c'
  surface-container-low: '#261819'
  surface-container: '#2b1c1d'
  surface-container-high: '#362627'
  surface-container-highest: '#413031'
  on-surface: '#f7dcdd'
  on-surface-variant: '#e2bebf'
  inverse-surface: '#f7dcdd'
  inverse-on-surface: '#3d2c2d'
  outline: '#a9898a'
  outline-variant: '#5a4042'
  surface-tint: '#ffb2b7'
  primary: '#ffb2b7'
  on-primary: '#67001c'
  primary-container: '#fc536d'
  on-primary-container: '#5b0017'
  inverse-primary: '#b71d3f'
  secondary: '#bfc2ff'
  on-secondary: '#262a66'
  secondary-container: '#3f4380'
  on-secondary-container: '#afb3f8'
  tertiary: '#67dc9f'
  on-tertiary: '#003921'
  tertiary-container: '#25a46d'
  on-tertiary-container: '#00311c'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#ffdadb'
  primary-fixed-dim: '#ffb2b7'
  on-primary-fixed: '#40000e'
  on-primary-fixed-variant: '#91002b'
  secondary-fixed: '#e0e0ff'
  secondary-fixed-dim: '#bfc2ff'
  on-secondary-fixed: '#0f1250'
  on-secondary-fixed-variant: '#3d417e'
  tertiary-fixed: '#84f9ba'
  tertiary-fixed-dim: '#67dc9f'
  on-tertiary-fixed: '#002111'
  on-tertiary-fixed-variant: '#005232'
  background: '#1d1011'
  on-background: '#f7dcdd'
  surface-variant: '#413031'
typography:
  h1:
    fontFamily: Inter
    fontSize: 48px
    fontWeight: '800'
    lineHeight: '1.1'
    letterSpacing: -0.02em
  h2:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: '1.2'
    letterSpacing: -0.01em
  h3:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '700'
    lineHeight: '1.3'
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.6'
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.5'
  label-caps:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '700'
    lineHeight: '1'
    letterSpacing: 0.1em
  stats:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '700'
    lineHeight: '1'
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  unit: 8px
  container-padding: 24px
  gutter: 16px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 32px
---

## Brand & Style

This design system is built for high-stakes competition and elite gaming performance. The visual language balances the aggressive energy of first-person shooters with the analytical precision of grandmaster-level strategy games. 

The style is **High-Contrast / Bold**, utilizing deep, saturated backgrounds to make vibrant accent colors pop with radioactive intensity. Every element is designed to feel fast and responsive, favoring sleek surfaces and sharp clarity over unnecessary fluff. The interface evokes a sense of "the zone"—that state of hyper-focus where only the game matters. This is achieved through a "glass-on-metal" aesthetic, combining dark, technical surfaces with glowing functional highlights.

## Colors

The palette is strictly dark-mode, engineered to reduce eye strain during long sessions while maximizing the impact of the primary accent. 

- **Primary (#E94560):** A vibrant red-pink "Accent" used for critical actions, victory states, and call-to-buttons. It represents energy and urgency.
- **Secondary (#4A4E8C):** A muted indigo used for utility elements, secondary navigation, and interactive states that shouldn't distract from the main goal.
- **Background (#1A1A2E):** The foundation. A deep, midnight navy that provides more depth than pure black.
- **Surface (#16213E):** A slightly lighter, cooler navy used for cards and containers to create a sense of layering.

Functional colors should include a bright emerald for "Success/Ready" states and a sharp amber for "Warning/Waiting" states to ensure clear communication in high-pressure UI moments.

## Typography

This design system utilizes **Inter** for its technical precision and exceptional readability at small sizes. The typographic hierarchy is aggressive, with large, heavy-weight headlines that command attention.

To maintain the gaming aesthetic, use "Label-Caps" for all metadata and categories to create a clean, organized look. Headlines should use tight tracking (letter-spacing) to feel more "compact" and engineered. Statistical data and player counts should utilize the "Stats" style—bold and italicized—to convey movement and momentum.

## Layout & Spacing

The layout follows a **12-column fluid grid** for main dashboards and a **fixed-width central column** (1200px max) for settings and profile pages. 

The rhythm is based on an **8px linear scale**. This ensures that even dense information environments (like match brackets or leaderboards) maintain visual breathing room. Use "stack-lg" (32px) for separating major content sections and "stack-sm" (8px) for grouping related interactive elements, such as a player's avatar and their username. Margins should be generous on the outer edges of the screen (24px minimum) to keep the focus centered on the action.

## Elevation & Depth

This design system avoids traditional drop shadows in favor of **Tonal Layering** and **Subtle Inner Glows**. Depth is communicated through color value: the "higher" an object is in the stack, the lighter its surface color becomes.

To enhance the high-energy vibe, use a 1px solid border (#4A4E8C at 30% opacity) on all cards to define edges against the background. Active states or "Epic" items can utilize a soft outer glow (bloom effect) using the Primary Accent color (#E94560), creating a neon-like appearance that feels powered-on.

## Shapes

The shape language is modern and refined, avoiding both the clinical feel of sharp corners and the "bubbliness" of mobile apps. 

- **Cards:** Use a consistent 16px radius. This provides a substantial, premium feel for large content blocks.
- **Buttons:** Use a tighter 12px radius. This makes interactive elements feel more precise and targeted.
- **Avatars:** Strictly circular. This provides a necessary organic contrast to the predominantly rectangular and geometric layout of the gaming UI.

Secondary elements like tags or small chips should use a "pill" shape (full rounding) to clearly distinguish them from actionable buttons.

## Components

### Buttons
Primary buttons use the Accent (#E94560) with white text. Hover states should include a subtle scale-up (1.02x) and an increased inner glow. Secondary buttons use an outline style with the Secondary (#4A4E8C) color.

### Cards
Cards are the primary container. They use the Surface color (#16213E) and a 16px radius. For "Featured" matches or items, add a top-border of 4px in the Primary Accent color.

### Inputs
Text fields should have a dark fill (#0F172A) with a 1px border. When focused, the border should glow in the Secondary color. Labels are always "Label-Caps" positioned above the field.

### Icons
Use minimal, outlined icons with a 2px stroke weight. Icons should be monochrome (Secondary color) by default, switching to white or the Primary color only when active or highlighted.

### Gaming Specifics
- **XP Bars:** Thin, horizontal tracks using a dark background and a Primary Accent fill.
- **Status Indicators:** Small circular dots. Green for "Online", Grey for "Offline", and Red-Pink for "In-Match".
- **Match Tiles:** Use a split-surface design to show two competing players/teams, separated by a high-contrast "VS" graphic in the center.