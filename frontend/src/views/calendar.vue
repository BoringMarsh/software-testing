<template>

  <div style="margin-left: 50px;margin-right:50px;text-align: left;width: 100%;">
    <div style="width: 250px;">
      
      <h1>Question4: 万年历问题</h1>
      <el-upload
          class="upload-demo"
          action="http://localhost:5001/api/hw/calendar"
          :on-preview="handlePreview"
          :on-remove="handleRemove"
          :before-remove="beforeRemove"
          multiple
          :limit="100"
          :on-exceed="handleExceed"
          :on-success="Success"
          :file-list="fileList">
        <el-button size="small" type="primary">上传测试用例</el-button>
        <div class="el-upload__tip">只能上传csv文件，且不超过500kb</div>
      </el-upload>
    </div>
    <div>
      <el-table
          :data="showData"
          stripe
          style="width: 100%">
        <el-table-column
            prop=ID
            label="序号">
        </el-table-column>
        <el-table-column
            prop=Year
            label="年">
        </el-table-column>
        <el-table-column
            prop=Month
            label="月">
        </el-table-column>
        <el-table-column
            prop=Day
            label="日">
        </el-table-column>
        <el-table-column
            prop=ExpectOutput
            label="预期输出">
        </el-table-column>
        <el-table-column
            prop=ActualOutput
            label="实际输出">
        </el-table-column>
        <el-table-column
            prop=Result
            label="是否通过">
        </el-table-column>

      </el-table>
    </div>
  </div>

</template>

<script>
import { ElUpload, ElButton, ElTable, ElTableColumn } from 'element-plus';
//import { Line } from 'vue-chartjs'
export default {
  name: "computerSell",
  components: {
    "el-upload": ElUpload,
    "el-button": ElButton,
    "el-table": ElTable,
    "el-table-column": ElTableColumn
  },
  data() {
    return {
      showData:[],
      tableData: [[]],
      fileList: [],
      filenum:0,
      chartData: {
        labels: ['测试1', '测试2', '测试3', '测试4', '测试5'], // 标签
        datasets: [
          {
            label: '测试时间',
            data: this.testTime, // 数据
            fill: false,
            borderColor: '#2554FF',
            tension: 0.1
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false
      }
    };
  },
  methods: {

    handleRemove(file, fileList) {
     this.$nextTick(() => {
     const index = this.fileList.findIndex(f => f.name === file.name);
     if (index !== -1 && index <= this.file_num) {
      this.tableData[index]=[];
      this.fileList.splice(index,1)
      this.file_num--;
    }
    console.log(index, this.fileList);
  });
  this.showData=[]
       console.log(file,fileList)
},
      
    handlePreview(file) {
  this.$nextTick(() => {
    // 假设我们使用文件的 name 属性来匹配
    const index = this.fileList.findIndex(f => f.name === file.name);
    if (index !== -1 && index <= this.file_num) {
      this.showData = this.tableData[index];
    }
    console.log(index, this.fileList);
  });
},
    handleExceed(files, fileList) {
      this.$message.warning(`当前限制选择 100 个文件，本次选择了 ${files.length} 个文件，共选择了 ${files.length + fileList.length} 个文件`);
    },
    // eslint-disable-next-line no-unused-vars
    beforeRemove(file, fileList) {
      return this.$confirm(`确定移除 ${file.name}？`);
    },

    // eslint-disable-next-line no-unused-vars
    Success(response, file, fileList) {
      this.tableData[this.file_num]= response.data;
      this.showData=response.data;
      this.fileList.push(file);
      this.file_num=this.file_num+1;
      console.log(response)
      //console.log(this.file_num,fileList)

    }
  }
}
</script>

<style scoped>

</style>
