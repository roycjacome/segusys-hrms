import type { Config } from 'tailwindcss';

const config: Config = {
  content: ['./src/**/*.{ts,tsx,mdx}'],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        segusys: {
          bg:        '#0A1628',
          surface:   '#14233D',
          surface2:  '#1F3252',
          accent:    '#F59E0B',
          accent2:   '#00B4D8',
          success:   '#10B981',
          danger:    '#EF4444',
          text:      '#E5E7EB',
          muted:     '#94A3B8',
        },
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        mono: ['JetBrains Mono', 'Menlo', 'monospace'],
      },
    },
  },
  plugins: [],
};
export default config;
