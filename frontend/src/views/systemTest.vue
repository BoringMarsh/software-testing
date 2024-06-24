<template>
  <div>
    <button @click="executeCommand">执行命令</button>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'CommandExecutor',

  methods: {
    executeCommand() {
      const relativeFolderPath = 'SoftwareTesting-Project\\frontend';
      const command = 'selenium-side-runner JiTicket.side';

      axios.post('http://localhost:5001/api/execute_command', {
        relative_folder_path: relativeFolderPath,
        command: command
      })
      .then(response => {
        console.log(response.data);
      })
      .catch(error => {
        console.error(error);
      });
    }
  }
}
</script>
