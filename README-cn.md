*阅读本文的其他语言版本：[English](README.md)。*
# 利用 Watson Visual Recognition 和 Core ML 创建基于增强现实的简历

要想在全球范围内寻找某个人和与之联系，最简单的方法就是通过 Facebook、Twitter 和 LinkedIn 等社交媒体应用。但是，这些应用仅提供基于文本的搜索功能。不过，通过最近发布的 iOS ARKit 工具包版本，可以完成使用人脸识别进行搜索的功能。通过将使用 Vision API 的 iOS 人脸识别技术、使用 IBM 视觉识别的分类技术以及使用分类图像和数据的个人识别技术相结合，可以构建应用来搜索人脸并进行识别。使用视觉识别构建基于增强现实的简历，就是其中一个用例。

本 Code Pattern 主要演示如何使用增强现实和视觉识别来识别个人及其详细信息。iOS 应用可以识别人脸，为您呈现增强现实视图，以相机视图显示个人简历。该应用利用 Watson Visual Recognition 和 Core ML 对人脸进行分类。使用经过视觉识别训练的深度神经网络脱机对图像进行分类。

学完本 Code Pattern 之后，用户将掌握如何：

* 配置 ARKit
* 使用 iOS Vision 模块
* 创建使用 Watson Swift SDK 的 Swift iOS 应用
* 利用 [Watson Visual Recognition](https://www.ibm.com/watson/services/visual-recognition/) 和 [Core ML](https://developer.apple.com/machine-learning/) 对图像进行分类

# 操作流程
![ARResume 架构](images/architecture.png)

1. 用户在移动设备上打开该应用
2. 使用 iOS Vision 模块检测到人脸
3. 将人脸图像发送到 Watson Visual Recognition 进行分类
4. 根据来自 Watson Visual Recognition 的分类，从 Cloudant 数据库检索有关此人的其他信息。
5. 将来自数据库的信息放在移动设备相机视图中原始人脸的前面。

# 包含的组件

* [ARKit](https://developer.apple.com/arkit/)：ARKit 是用于 iOS 应用的增强现实框架。
* [Watson Visual Recognition](https://www.ibm.com/watson/developercloud/visual-recognition.html)：视觉识别可以理解图像的内容 - 为图像添加视觉概念标记，查找人脸、大约年龄和性别，并在图库中查找类似图像。
* [Core ML](https://developer.apple.com/documentation/coreml)：通过 Core ML，您可以将经过训练的机器学习模型整合到您的应用中。
* [Cloudant 非关系型数据库](https://console.ng.bluemix.net/catalog/services/cloudant-nosql-db)：完全托管的数据层，专为采用灵活 JSON 模式的现代 Web 和移动应用而设计。

# 技术

* [人工智能](https://medium.com/ibm-data-science-experience)：人工智能可应用于不同的解决方案领域来提供颠覆性技术。
* [移动技术](https://mobilefirstplatform.ibmcloud.com/)：互动参与体系越来越多地开始使用移动技术作为交付平台。

# 步骤

1. 在命令行，用以下命令克隆数据库：
```
git clone https://github.com/IBM/ar-resume-with-visual-recognition
```

2. 登录到 [IBM Cloud](http://bluemix.net/) 帐户，创建 [Watson Visual Recognition](https://console.bluemix.net/catalog/services/visual-recognition) 服务。创建一系列的凭证并识别 API 密钥。

3. 加载应用时，将为以下每个 zip 文件创建 3 个分类器：[`ResumeAR/sanjeev.zip`](ResumeAR/sanjeev.zip)、 [`ResumeAR/steve.zip`](ResumeAR/steve.zip) 和 [`ResumeAR/scott.zip`](ResumeAR/scott.zip)。
> 使用 [Watson Visual Recognition 工具](https://watson-visual-recognition.ng.bluemix.net/)创建新的分类器。分类器将训练视觉识别服务，它将能够识别同一个人的多张不同图像。这需要至少使用十张大头照，同时通过使用不是自己的大头照来创建反面数据集训练。

4. 创建 [IBM Cloudant 非关系型数据库](https://console.bluemix.net/catalog/services/cloudant-nosql-db)并保存凭证。该数据库中的每个 JSON 文档都表示**一个**人。可在 [`schema.json`](ResumeAR/schema.json) 中找到 JSON 模式。加载应用时，也会为第 3 步中完成的 3 个分类创建 3 个文档。 
> 要在同一数据库中创建新文档，请使用提供的 [`schema.json`](ResumeAR/schema.json) 来填充详细信息。Watson Visual Recognition 模型训练成功之后，使用从分类器收到的 `classificationId` 替换该模式中的 `classificationId`。此 ID 将用于检索有关经过分类的个人的详细信息。

5. 转至 `ios_swift` 目录并使用 `Xcode` 打开项目。

6. 在项目中创建 `BMSCredentials.plist` 并替换凭证。`plist` 文件类似如下：
```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>visualrecognitionApi_key</key>
	<string>VR_API_KEY</string>
	<key>cloudantUrl</key>
	<string>CLOUDANT_URL</string>	
</dict>
</plist>
```

7. 在命令行中，运行 `pod install` 以安装依赖项。![Pod 安装输出](images/pod-install-output.png)

8. 运行 `carthage bootstrap --platform iOS` 以安装 Watson 相关依赖项。![Carthage 安装输出](images/carthage-output.png)

9. 完成前面的步骤后，返回到 Xcode，通过单击 `Build` 和 `Run` 菜单选项来运行应用。![Xcode 构建和运行](images/build-and-run.png)

注意：Watson Visual Recognition 中的训练可能需要几分钟时间。如果状态为 `training`，那么 AR 将在您的 AR 视图中显示 `Training in progress`。您可以通过使用以下 curl 命令来检查分类器的状态：

```
curl "https://gateway-a.watsonplatform.net/visual-recognition/api/v3/classifiers?api_key={API_KEY}&verbose=true&version=2016-05-20"
```

使用 Watson Visual Recognition API 密钥替换 `API_KEY`。

10. 要进行测试，您可以使用 [`images/TestImages`](images/TestImages) 文件夹中提供的测试图像。

# 添加到数据库

要在数据库中创建新的条目，请执行以下步骤： 

1. 使用[联机工具](https://watson-visual-recognition.ng.bluemix.net/)为希望能够识别的每个人创建新的 Watson Visual Recognition 分类器，使用至少十张此人的图像。

2. 使用从前一步获得的分类器 ID 更新 Cloudant 数据库。要更新该数据库，请如下所示执行 `POST` 命令：

```
data='{"classificationId":"Watson_VR_Classifier_ID","fullname":"Joe Smith","linkedin":"jsmith","twitter":"jsmith","facebook":"jsmith","phone":"512-555-1234","location":"San Francisco"}'

curl -H "Content-Type: application/json" -X POST -d $data https://$ACCOUNT.cloudant.com/$DATABASE
```

> `$ACCOUNT` 变量是 URL，可在设置 Cloudant 时所创建的凭证中找到。

> `$DATABASE` 变量是在 IBM Cloudant 中所创建的数据库名称。

> 请参阅 [`ResumeAR/schema.json`](ResumeAR/schema.json)，了解有关 Cloudant 数据库配置的其他信息。

3. 运行应用，将相机视图指向您的图像。

# 样本输出

| | | |
|-|-|-|
| <img src="images/sanjeev_sample_output.png" height=250px width=140px> | <img src="images/steve_sample_output.png" height=250px width=140px> | <img src="images/scott_sample_output.png" height=250px width=140px> |

# 了解更多信息

* **人工智能 Code Pattern**：喜欢本 Code Pattern？请查阅我们的其他 [AI Code Pattern](https://developer.ibm.com/cn/technologies/artificial-intelligence/)。
* **AI 和数据 Code Pattern 播放列表**：将我们的[播放列表](http://i.youku.com/i/UNTI2NTA2NTAw/videos?spm=a2hzp.8244740.0.0)以及所有 Code Pattern 视频加入书签。
* **With Watson**：想要进一步改进您的 Watson 应用？正在考虑使用 Watson 品牌资产？[加入 With Watson 计划](https://www.ibm.com/watson/with-watson/)，以便利用独家品牌、营销和技术资源来增强和加速开发 Watson 嵌入式商业解决方案。
* **利用 Watson Visual Recognition 和 Core ML 脱机对图像进行分类** [视觉识别示例](https://github.com/watson-developer-cloud/visual-recognition-coreml)

# 故障排除
* 要想从头开始，您需要删除 Watson Visual Recognition 训练的模型，删除来自 Cloudant 数据库的数据，并删除应用以删除已下载的模型。

# 链接

* [ARKit](https://developer.apple.com/arkit)
* [Watson Swift SDK](https://github.com/watson-developer-cloud/swift-sdk)
* [IBM 视觉识别](https://www.ibm.com/watson/services/visual-recognition-4)
* [IBM Cloudant](https://www.ibm.com/cloud/cloudant) 

# 许可

[Apache 2.0](LICENSE)
