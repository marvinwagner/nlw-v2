<template>
  <div id="app">
    <router-view/>
  </div>
</template>

<style lang="scss">

@import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;500&family=Ubuntu:wght@700&display=swap');

#app {
  font-family: Roboto, Arial, Helvetica, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  //background-color: #F0F0F5;
}

:root {
  --primary-color: #34CB79;
  --title-color: #322153;
  --text-color: #6C6C80;
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  background: #e8e8e8;
  color: var(--text-color);
}

body, input, button {
  font-family: Roboto, Arial, Helvetica, sans-serif;
}

h1, h2, h3, h4, h5, h6 {
  color: var(--title-color);
  font-family: Ubuntu;
}

</style>
