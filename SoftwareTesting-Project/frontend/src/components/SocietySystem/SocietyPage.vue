<html class="dark">
  <head></head>
  <body></body>
</html>


<template>
    <el-dialog v-model="dialogVisible" title="公告发布" width="30%" draggable>
    <el-input
    v-model="text"
    class="w-50 m-2"
    type="textarea"
    placeholder="请输入公告内容"
    style="width: 450px"
    maxlength="400"
    show-word-limit
    autosize
  />
    <template #footer>
      <span class="dialog-footer">
        <el-button @click="noticeNotUpload">取消</el-button>
        <el-button type="danger" @click="noticeUpload">
          发布
        </el-button>
      </span>
    </template>
  </el-dialog>
<el-container>
    <!-- 头部区域 -->
    <el-header height="80px">
      <div>
        <img src="Logo.png" alt="" style="width: 150px; padding-right: 10px;"/>
        <span id="society-home-title">社团系统</span>
      </div>
      <!-- <el-button type="info"  @click="dialogVisible = true">发布公告</el-button> -->
      <el-button type="danger" style="background-color:rgb(222, 214, 187);"  @click="logout">退出登录</el-button>
    </el-header>
	<el-container >
    <div class="layout-container-demo">
    <el-aside>
          <el-menu
          background-color="#f89898"
          text-color="#fff"
          active-text-color="#ce7438"
        >
          <!-- 一级菜单 -->
          <el-menu
        active-text-color="#ce7438"
        background-color=" #eee5da"
        class="el-menu-vertical-demo"
        default-active="2"
        text-color="#712727"
        @open="handleOpen"
        @close="handleClose"
      >
      <el-menu-item-group style="background-color: #fffbf7;">

      </el-menu-item-group>
        <el-sub-menu index="1">
          <template #title>
            <el-icon><location /></el-icon>
            <span>社团信息</span>
          </template>
          <el-menu-item-group>
            <el-menu-item @click="router.push({path:'/UserInfoPage',query:{socId:socId}})" index="1-1">社团信息</el-menu-item>
            <el-menu-item @click="router.push({path:'/ModifySocietyInfoPage',query:{socId:socId}})" index="1-2">修改信息</el-menu-item>
          </el-menu-item-group>
          <el-menu-item-group>
            <el-menu-item index="1-3" @click="dialogVisible = true">公告发布</el-menu-item>
          </el-menu-item-group>
          <el-sub-menu index="1-4">
            <template #title>聊天相关</template>
            <el-menu-item @click="router.push({path:'/ChatPage',query:{stuId:1000000, socId:socId, userType:1}})" index="1-4-1">聊天入口</el-menu-item>
          </el-sub-menu>
        </el-sub-menu>
        <el-menu-item index="2" @click="router.push({path:'/detail',query:{socId:socId}})">
          <el-icon><document /></el-icon>
          <span>活动总览</span>
        </el-menu-item>
        <el-menu-item index="3" @click="router.push({path:'/upload',query:{socId:socId}})">
          <el-icon><edit /></el-icon>
          <span>发布活动</span>
        </el-menu-item>

        <el-menu-item index="4" @click="router.push({path:'/verification',query:{socId:socId}})">
          <el-icon><Warning /></el-icon>
          <span>待核销活动</span>
        </el-menu-item>

        <el-menu-item index="5" @click="router.push({path:'/refund',query:{socId:socId}})">
          <el-icon><CircleClose /></el-icon>
          <span>已退款订单</span>
        </el-menu-item>
      </el-menu>
        </el-menu>

        </el-aside>
      </div>
        <!-- 右侧主体区域 -->
        <el-main >
          <div>
            <router-view v-slot="{ Component,route }">
              <keep-alive >
                <component v-if="route.meta.keepAlive" :is="Component" />
              </keep-alive>
              <component v-if="!route.meta.keepAlive" :is="Component" />
            </router-view>
          </div>
        </el-main>
    
	</el-container>
</el-container>
</template>
  
  <script lang="ts" setup>
  import { Options, Vue } from 'vue-class-component';
  import{ref,onMounted}from 'vue';
  import { useRouter,useRoute } from 'vue-router';
  import { ArrowLeft } from '@element-plus/icons-vue'
  import { ElMessage, ElMessageBox,ElNotification } from 'element-plus'
  import axios from 'axios';
  const goodsList=ref([]);
  const router=useRouter();
  const route=useRoute();
  const dialogVisible = ref(false)
  const text=ref('');
  const socId=ref('');
  import {
  Document,
  Menu as IconMenu,
  Location,
  Setting,
} from '@element-plus/icons-vue'
  const noticeNotUpload=()=>{
    dialogVisible.value = false;
    ElNotification({
        title: 'Info',
        message: '操作取消',
        type: 'info',
        duration: 2000
      })
      text.value='';
    
  }
  const noticeUpload=()=>{
    axios.post('api/uploadNotice',{
      STO_ID:socId.value,
      NTC_CONTENT:text.value})
    .then(response=>{
      ElNotification.success({
            title: 'Success',
            message: '发布成功',
            duration: 2000
          })
          dialogVisible.value=false;
          text.value='';
    })
    .catch(error=>{
      ElNotification({
            title: 'Error',
            message: '发布失败',
            type: 'error',
            duration: 2000
          })
    })
  }
  onMounted(() => {
    //socId.value = route.query.socId as string;
    socId.value = sessionStorage.getItem('socId') as string;
    console.log(router.currentRoute.value.path);
    if (router.currentRoute.value.path === '/') {
      router.push('/store/detail');
    }
  });
  const goBack=()=>{
    history.back();
    console.log(history.state.current);
    switch(history.state.current.split('?')[0]){
      case '/store/detail':
        getContent.value='商品总览'
        break;
      case '/store/view':
        getContent.value='商品详情'
        break;
    }
    // getContent.value='222';
  }
  const logout=()=>{
    router.push('/login');
    console.log('success jump');
  }
  const getContent=ref('商品总览');

  const check=(Component)=>{
    return Component.meta.keepAlive;
  }

  const viewUserInfo=()=>{
    router.push({
      path:'/UserInfoPage',
      query:{
        id:socId.value
      }
    });
  }

  const viewChatInfo=()=>{
      router.push({
        path:'/ChatPage',
        query:{
          cus_id:"1000000",
          socId:socId.value,
          user_type:"1"
        }
      })
    }

  const modifyStoreInfo=()=>{
    router.push({
      path:'/ModifySocietyInfoPage',
      query:{
        id:socId.value
      }
    })
  }
  </script>
  
  <!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
.el-row {
  margin-bottom: 20px;
}
.el-row:last-child {
  margin-bottom: 0;
}
.el-col {
  border-radius: 4px;
}

/* .el-main{
  margin-top: 20px; */
  /* background-color: #F0F2F5;
} */
.grid-content {
  border-radius: 4px;
  min-height: 36px;
}
  .home_container {
      height:100%;
  }

  /* .el-sub-menu{
    background-color: #606266;
    color: #fff;
  } */
  .el-header {
  background-color: #eeebe4;
  display: flex;
  justify-content: space-between;
  /* padding-left: 100px; */
  align-items: center;
  color: #5a0808;
  font-size: 22px;
  > div {
    display: flex;
    align-items: center;
    span {
      padding-left: 15px;
    }
  }
}

/* 
.aside{
  >el-aside{
    >el-menu{
    background-color:#fff;
    }
  }
} */
/* .aside{
  background-color: #606266;

  align-items: center;
}
.el-menu {
  background-color: #606266;
    height: 100%;
    color: #fff;
} 
.el-menu-item{
  background-color: #606266;

  align-items: center;
} */
.el-main{
  background-color :  #fffbf7
}
.layout-container-demo{
  height: 100%;
}
.layout-container-demo .el-header {
  position: relative;
  background-color: var(--el-color-primary-light-8);
  color: var(--el-text-color-primary);
  border: #373d41;
}
.layout-container-demo .el-aside {
  /* margin-right: 5px; */
  height: 820px;
  width: 250px;
  background-color:  #eeebe4;
}

.layout-container-demo .el-menu {
  border-right: none;
  background-color:  #eeebe4;
}
.layout-container-demo .toolbar {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  right: 20px;
}

</style>

  
  