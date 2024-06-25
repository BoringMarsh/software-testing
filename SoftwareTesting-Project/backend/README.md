# SoftwareTesting-Backend
这里是被测项目：济票坊——校园社团活动票务平台的后端

## Allure相关脚本
- report-generate.cmd：将java项目的target文件夹中测试结果生成allure报告到文件夹中.\src\test\resources\test-result\unit
- report-open.cmd：将上面生成的allure报告打开（直接点击index.html无内容）
- report-serve.cmd：将java项目的target文件夹中测试结果生成临时allure报告并直接显示到浏览器中

## 测试相关脚本
- test_overall.cmd：对maven项目clean然后test（运行所有单元测试代码），同时将java项目的target文件夹中测试结果生成临时allure报告并直接显示到浏览器中