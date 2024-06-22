<template>
   <button @click="test()">测试按钮</button>
 <div class='container'>
   <el-container style="width: 100%; height: 5000px">
    <h1 style="font-size:18px" class="header">Question1:判断三角形类型</h1>
    <el-footer style="margin-left: 30px">
       <el-tabs type="border-card" style="width: 70%; height: 350px">
        <el-tab-pane label="单个测试" name="first">
          <h4>单个测试</h4>
          <el-form ref="form" :model="form" label-width="80px" class="input-form">
            <el-form-item label="edge1" class="input-text">
              <el-input v-model="form.edge1"></el-input>
            </el-form-item>
            <el-form-item label="edge2" class="input-text">
              <el-input v-model="form.edge2"></el-input>
            </el-form-item>
            <el-form-item label="edge3" class="input-text">
              <el-input v-model="form.edge3"></el-input>
            </el-form-item>
            <el-form-item class="button">
              <el-button type="primary" @click="onClick">提交</el-button>
            </el-form-item>
          </el-form>
        </el-tab-pane>
        <el-tab-pane label="批量测试" name="second">
          <h4>批量测试</h4>
          <el-upload
            class="upload-demo"
            action="http://localhost:5001/api/hw/triangle"
            :on-preview="handlePreview"
            :on-remove="handleRemove"
            :before-remove="beforeRemove"
            multiple
            :limit="100"
            :on-exceed="handleExceed"
            :on-success="Success"
            :file-list="fileList">
            <el-button size="small" type="primary">上传测试用例</el-button>
            <div class="el-upload__tip">只能csv文件，且不超过500kb</div>
          </el-upload>
        </el-tab-pane>
      </el-tabs>

      <div>
        <el-table
          :data="showData"
          stripe
          style="width: 100%">
          <el-table-column
              prop=ID
              label="序号"
              width="180">
          </el-table-column>
          <el-table-column
              prop=A
              label="输入第一条边"
              width="180">
          </el-table-column>
          <el-table-column
              prop=B
              label="输入第二条边"
              width="180">
          </el-table-column>
          <el-table-column
              prop=C
              label="输入第三条边"
              width="180">
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
    </el-footer>
   </el-container>

 </div>

</template>
<script>
import { ElUpload, ElButton, ElTable, ElTableColumn, ElForm, ElFormItem, ElFooter, ElContainer, ElTabs, ElTabPane, ElInput } from 'element-plus';
import axios from 'axios';

export default {
  name: "triangle",
  components: {
    "el-upload": ElUpload,
    "el-button": ElButton,
    "el-table": ElTable,
    "el-table-column": ElTableColumn,
    "el-form": ElForm,
    "el-form-item": ElFormItem,
    "el-footer": ElFooter,
    "el-container": ElContainer,
    "el-tabs": ElTabs,
    "el-tab-pane": ElTabPane,
    "el-input": ElInput
  },
  data() {
    return {
      file_num:0,
      uploadActionUrl:'',
      tableData:[[]],
      showData:[],
      fileList: [],
      form: {
        edge1: '',
        edge2: '',
        edge3: '',
      },
    }
  },
  methods: {
    test(){
      axios.get('http://localhost:5001/api/test').
  then(res=>{
    console.log(res)
  })


    },
    onClick() {
      var a = parseFloat(this.form.edge1)
      var b = parseFloat(this.form.edge2)
      var c = parseFloat(this.form.edge3)
      if (a < 0)
          this.$message.warning ("a不能为0")
      if (b < 0)
          this.$message.warning ("b不能为0")
      if (c < 0)
          this.$message.warning ("c不能为0")
      if (a >= 800)
          this.$message.warning ("a不在取值范围内")
      if (b >= 800)
          this.$message.warning ("b不在取值范围内")
      if (c >= 800)
          this.$message.warning ("c不在取值范围内")
      if (a + c > b && a + b > c && b + c > a)
      {
          if (a == b && b == c)
              this.$message.warning ("等边三角形")
          else if( a == b || b == c || a == c)
              this.$message.warning ("等腰三角形")
          else
              this.$message.warning ("普通三角形")
      }
      else
          this.$message.warning ("不是三角形")
    },
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
.header{
  margin-left: 50px;
  margin-bottom: 30px;
  text-align: left;
}
.upload-demo {
  margin-top: 50px;
}
.input-form{
  padding-right: 20px;
}

</style>
