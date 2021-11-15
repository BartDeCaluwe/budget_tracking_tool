const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  mode: 'jit',
  purge: ['./js/**/*.js', '../lib/*_web/**/*.*ex'],
  theme: {
    extend: {
      fontFamily: {
        sans: ["'Inter'", ...defaultTheme.fontFamily.sans],
        mono: ["'Jetbrains Mono'", ...defaultTheme.fontFamily.mono],
      },
      gridTemplateRows: {
        layout: 'min-content 1fr',
      },
      gridTemplateColumns: {
        layout: 'minmax(100px, 100vw)'
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [require('@tailwindcss/forms'), require('@tailwindcss/typography')],
}
