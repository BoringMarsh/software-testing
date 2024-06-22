<template>
  <div style="margin-left: 50px;margin-right:50px;text-align: left;width: 100%;">
    <div style="width: 250px;">
      <h1>Question3: 电脑销售系统</h1>
      <el-upload
          class="upload-demo"
          action="http://localhost:5001/api/hw/computer"
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
            prop=Id
            label="序号"
            width="180">
        </el-table-column>
        <el-table-column
            prop=Host
            label="主机"
            width="180">
        </el-table-column>
        <el-table-column
            prop=Monitor
            label="外设">
        </el-table-column>
        <el-table-column
            prop=Peripheral
            label="显示器">
        </el-table-column>
        <el-table-column
            prop=ExpectedOutput
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
      tableData: [],
      fileList: []
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
      console.log(this.file_num,fileList)

    }
  }
}
</script>

<style scoped>

</style>
