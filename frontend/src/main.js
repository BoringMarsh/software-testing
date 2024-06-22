import {
  createApp
} from 'vue'
import App from './App.vue'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css';
//import 'dayjs/locale/zh-cn'
import locale from 'element-plus/es/locale/lang/zh-cn'
import router from '@/router'

//createApp(App).mount('#app')
const app = createApp(App)
app.use(ElementPlus, {
  locale
})
app.use(router)
app.mount('#app')