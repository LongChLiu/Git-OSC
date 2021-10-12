# gitee-iphone-swift

#### 介绍
使用Swift语言重构的码云iOS客户端，采用MVVM设计模式与POP(面向协议编程)，核心框架为RxSwift。
原项目地址：https://gitee.com/oschina/git-osc-iphone

#### 安装教程
1. 打开终端 cd到项目目录
2. 执行carthage update --platform iOS --no-use-binaries（未安装carthage需先安装，过程百度）
3. 等待库的安装完成（Realm的安装时间可能比较长）
4. 打开目录下Git@OSC.xcodeproj build即可


#### 第三方库说明
1. RxSwift：本项目核心框架，用于产生与控制数据流。
2. RxDataSource：RxSwift的扩展，支持数据源的数据流绑定。
3. Alamofire：网络请求。
4. ObjectMapper：JSON转对象。
5. AlamofireObjectMapper：Alamofire与ObjectMapper的桥接。
6. Realm：持久化存储。
7. MonkeyKing：社交平台分享。
8. SnapKit：自动布局。
9. SwiftDate：日期转换。
10. SwiftyJSON：JSON解析。
11. SDWebImage：图片下载与缓存。
12. MBProgressHUD：提示信息与菊花。
13. MJRefresh：下拉刷新。
14. DNSPageView：视图分页滑动。
15. HCDropdownView：下拉菜单。
16. TextAttributes：链式调用生成TextAttributes。

#### 界面预览
![项目列表](https://images.gitee.com/uploads/images/2019/0604/143441_707e0de6_2222478.png "ProjectList.png")
![项目详情](https://images.gitee.com/uploads/images/2019/0604/143513_7d225927_2222478.png "ProjectDetails.png")
![我的](https://images.gitee.com/uploads/images/2019/0604/143524_76f3ede9_2222478.png "Mine.png")
