<template>
    <div id="myChart0" :style="{width: '1000px', height: '350px'}"></div>
    <div id="myChart1" :style="{width: '1000px', height: '350px'}"></div>
  <div style="margin-left: 50px;margin-right:50px;text-align: left;width: 100%;">
    <div style="width: 250px;">
      <h1>Question2: 电信收费问题</h1>
      <el-upload
          class="upload-demo"
          action="http://localhost:5001/api/hw/telephone"
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
            label="序号"
            width="180">
        </el-table-column>
        <el-table-column
            prop=Minute
            label="本月通话的分钟数"
            width="180">
        </el-table-column>
        <el-table-column
            prop=FailTime
            label="通话时间段的最大容许不按时缴费次数">
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
import * as echarts from 'echarts';
export default {
  name: "CentryCalendar",
  data() {
    return {
      showData: [],
      tableData: [[]],
      fileList: [],
      filenum: 0,
      testtime: [],
      readtime: [],
      filename: [],
      passes: [],
      index:0
    };
  },
  methods: {
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
      this.updatelineChart();
      this.updatepieChart();
    },
    handlePreview(file) {
      this.$nextTick(() => {
        this.index = this.fileList.findIndex(f => f.name === file.name);
        if (this.index !== -1 && this.index <= this.filenum) {
          this.showData = this.tableData[this.index];
          console.log(this.showData)
        }
        console.log(this.passes[this.index]);
        this.updatelineChart();
        this.updatepieChart();
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
      this.updatelineChart();
      this.updatepieChart();

    },
    updatelineChart() {
      let myChart = echarts.init(document.getElementById("myChart0"));
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
        ]
      };
      myChart.setOption(option);
    },
    updatepieChart() {
      let myChart = echarts.init(document.getElementById("myChart1"));
      let option = {
        tooltip: {
          trigger: 'axis'
        },
        legend: {
          data: ['通过率', '不通过率']
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
        series: [
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
    },
  },
  mounted() {
    this.updatelineChart();
    this.updatepieChart();
  }
};
</script>

<style scoped>

</style>