# chatgpt_image
 chatgpt image generate macos app
 
ChatGPT Plus Web网页上绘画会有次数限制，所以写一个利用接口生成图片的macos app

## 功能
1. 调用DALL E 3接口生成图片
2. 自定义API Key
3. 自定义API Host
4. 可选择图片尺寸，图片质量，图片风格（DALL E 3一次只能生成一个图片）

## 其他
Dall E 接口不能实现像网页端一样的多轮对话，貌似官方不支持，可能的方案是用GPT识别图片描述，然后再用Dall E生成图片