<template>
  <div style="margin-left: 50px;margin-right:50px;text-align: left;width: 100%;">
    <div style="width: 250px;">
      <h1>单元测试</h1>
      <div class="select">
        <button @click="execUnitTest"> 执行 </button>
      </div>
      <allure-report></allure-report>
      <div>
        <input type="file" name="fileDemo" id="fileDemo" multep/>
        <input type="button" value="readAsText"  id="readAsText" @click="showDataByText"/>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import { ElSelect, ElOption } from 'element-plus';

export default {
  name: "unitTest",
  components: {
    "el-select": ElSelect,
    "el-option": ElOption,
    "allure-report": AllureReport
  },
  data() {
    return {
      options: ['User', 'Exam'],
      selectItem: '',
      ifUserDisplay: "none",
      fileList: []
    }
  },
  methods: {
    changeSelect() {
      console.log(this.selectItem);
      if(this.selectItem == "User")
      {
        this.ifUserDisplay = "block";
      }
      else if(this.selectItem == "Exam")
      {
        this.ifUserDisplay = "none";
      }
    },
    showDataByText() {
      var resultFile = document.getElementById("fileDemo").files[0];
      const fileReader = new FileReader();
      fileReader.readAsText(resultFile);
      fileReader.onload = function() {
        let data = this.result.split("\n");
        let variables = [];
        data.map(v => {
          if (v) {
            variables.push(v.split(","));
          }
        });
      console.log(data)
      console.log(variables)
      };
    },
    execUnitTest() {
      axios.get("http://localhost:5001/api/project/unit").then(res => {
        console.log(res);
      }, err => {
        console.log(err);
      });
    }
  }
}
</script>

<style>

</style>