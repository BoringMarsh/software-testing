<template>
   <button @click="test()">测试按钮</button>
 <div class='container'>
   <el-container style="width: 100%; height: 500px">
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
   <div id="myChart123" :style="{width: '1500px', height: '350px'}"></div>
 </div>

</template>
<script>
import { ElUpload, ElButton, ElTable, ElTableColumn, ElForm, ElFormItem, ElFooter, ElContainer, ElTabs, ElTabPane, ElInput } from 'element-plus';
import axios from 'axios';
import * as echarts from 'echarts';
export default {
  name: "trianGle",
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
      uploadActionUrl:'',
      showData: [],
      tableData: [[]],
      fileList: [],
      filenum: 0,
      testtime: [],
      readtime: [],
      filename: [],
      passes: [],
      index:0,
      form: {
        edge1: '',
        edge2: '',
        edge3: '',
      },
    }
  },
  methods: {
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
        this.index = this.fileList.findIndex(f => f.name === file.name);
        if (this.index !== -1 && this.index <= this.filenum) {
          this.tableData[this.index] = [];
          this.fileList.splice(this.index, 1);
          this.filenum--;
        }
        console.log(this.index, this.fileList);
      });
      this.showData = [];
      console.log(file, fileList);
      this.updateChart();
    },
    handlePreview(file) {
      this.$nextTick(() => {
        this.index = this.fileList.findIndex(f => f.name === file.name);
        if (this.index !== -1 && this.index <= this.filenum) {
          this.showData = this.tableData[this.index];
          console.log(this.showData)
        }
        console.log(this.passes[this.index]);
        this.updateChart();
      });
    },
    handleExceed(files, fileList) {
      this.$message.warning(`当前限制选择 100 个文件，本次选择了${files.length} 个文件，共选择了 ${files.length + fileList.length} 个文件`);
    },
    beforeRemove(file, fileList) {
      return this.$confirm(`确定移除${file.name}？`);
    },
    Success(response, file, fileList) {
      this.tableData[this.filenum]=(response.data);
      this.showData = response.data;
      this.fileList.push(file);
      this.index=this.filenum = this.filenum + 1;
      this.filename.push(this.filenum);
      this.testtime.push(response.testTime);
      this.readtime.push(response.readTime);
      this.passes.push(response.passRate);      
      this.updateChart();

    },
    updateChart() {
      let myChart = echarts.init(document.getElementById("myChart123"));
      let option = {
        tooltip: {
          trigger: 'axis'
        },
        legend: {
          data: ['测试时间', '读取时间', '通过率', '不通过率']
        },
        toolbox: {
          feature: {
            saveAsImage: {},
            dataView: {},
            magicType: {
              type: ['line', 'bar', 'stack', 'tiled', 'pie']
            }
          }
        },
        xAxis: {
          type: 'category',
          boundaryGap: false,
          data: this.filename
        },
        yAxis: {
          type: 'value'
        },
        series: [
          {
            name: '测试时间',
            type: 'line',
            data: this.testtime
          },
          {
            name: '读取时间',
            type: 'line',
            data: this.readtime
          },
          {
            name: '通过率',
            type: 'pie',
            radius: '50%',
            center: ['25%', '50%'],
            data: [
              { value: this.passes[this.index], name: '通过率' },
              { value: 1 - this.passes[this.index], name: '不通过率' }
            ],
            label: {
              formatter: '{b}: {d}%'
            },
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: 'rgba(0, 0, 0, 0.5)'
              }
            }
          }
        ]
      };
      myChart.setOption(option);
    }
  },
  mounted() {
    this.updateChart();
  }
};
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
