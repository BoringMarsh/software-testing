<template>
  <div>
    <button @click="runSelenium">运行Selenium</button>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'CommandButton',
  methods: {
    runSelenium() {
      axios.post('http://localhost:5001/api/run_command', {
        directory: 'D:\\software\\software-testing\\SoftwareTesting-Project\\frontend',
        command: 'selenium-side-runner JiTicket.side'
      })
      .then(response => {
        if (response.data.output) {
          console.log(response.data.output);
        }
        if (response.data.error) {
          console.error(response.data.error);
        }
      })
      .catch(error => {
        console.error(error);
      });
    }
  }
};
</script>
