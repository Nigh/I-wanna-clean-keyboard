
<div align="center">
<img width="256" height="256" alt="logo" src="https://github.com/user-attachments/assets/56662a6c-ec9c-42b7-9e7a-4c59182c7901" />
<img alt="title" src="https://capsule-render.vercel.app/api?type=transparent&fontColor=dbdbdb&text=I%20Wanna%20Clean%20Keyboard&desc=and%20mouse&descAlignY=78&descAlign=76&height=80&fontSize=48"/>
<a href="https://hellogithub.com/repository/Nigh/I-wanna-clean-keyboard" target="_blank"><img src="https://abroad.hellogithub.com/v1/widgets/recommend.svg?rid=1b127af0ff114f17b796318d883515b0&claim_uid=fzFw5oyluD4xqHa&theme=dark" alt="Featured｜HelloGitHub" style="width: 250px; height: 54px;" width="250" height="54" /></a>
</div>

`iwck` could block the keyboard input while you were eating, writing or cleaning the key on your laptop keyboard. Now also supports blocking mouse input...  
`iwck`可以帮助你在笔记本键盘上吃泡面、做笔记或者擦键盘时屏蔽键盘的输入。现在也添加了对鼠标的支持。

## screenshot
<img width="437" height="307" alt="Screenshot 2025-09-28 204740" src="https://github.com/user-attachments/assets/025c8a1d-c072-4975-aab5-56ff6f8f025f" />


## usage / 使用说明

### Keyboard lock / 键盘屏蔽

- Click the **keyboard button** to block keyboard input immediately.
  点击 **键盘按钮**，立即开启键盘屏蔽。
- Click the **keyboard button** again to restore keyboard input.
  再次点击 **键盘按钮**，解除键盘屏蔽。

### Mouse lock / 鼠标屏蔽

- Click the **mouse button** to enter ready mode. Mouse input is not blocked yet.
  点击 **鼠标按钮** 进入准备状态。此时鼠标尚未被屏蔽。
- Press `Esc` to start blocking mouse input.
  按下 `Esc`，开始屏蔽鼠标输入。
- Press `Esc` again to restore mouse input.
  再次按下 `Esc`，解除鼠标屏蔽。
- To cancel before locking, click the **mouse button** again.
  如果尚未按下 `Esc`，再次点击 **鼠标按钮** 可取消准备状态。
- Keyboard lock and mouse lock cannot be active together. Selecting one mode disables the other mode first.
  键盘屏蔽和鼠标屏蔽不能同时开启。选择另一种屏蔽模式时，当前模式会先解除。

### Move and exit / 移动与退出

- Press and drag the `iwck` title to move the window.
  按住并拖动 `iwck` 标题，可移动窗口。
- Click the **exit button** to restore all input and exit IWCK.
  点击 **退出按钮**，解除所有输入屏蔽并退出 IWCK。

## requirements / 运行要求

- Windows 10 or Windows 11, x64 only. x86 and ARM64 are not supported.
  仅支持 x64 版 Windows 10 或 Windows 11，不支持 x86 和 ARM64。
- [Microsoft Edge WebView2 Evergreen Runtime](https://developer.microsoft.com/microsoft-edge/webview2/consumer/) must be installed. Windows 11 normally includes it.
  必须安装 Microsoft Edge WebView2 Evergreen Runtime；Windows 11 通常已预装。
- If the Runtime is missing or WebView2 cannot initialize, IWCK shows a startup error and exits instead of displaying a blank window.
  如果缺少 Runtime 或 WebView2 初始化失败，IWCK 会显示启动错误并退出，不会继续显示空白窗口。

## third-party dependency / 第三方依赖

`webview2/64bit/WebView2Loader.dll` comes from Microsoft's `Microsoft.Web.WebView2` NuGet package, version `1.0.2957.106`, under that package's license. Its SHA-256 is `271b57e3ec03c436a15d80cafeb9fd1618a43793233d8b05c9446f8de0a51be4`.

`webview2/64bit/WebView2Loader.dll` 来自 Microsoft 的 `Microsoft.Web.WebView2` NuGet 包 `1.0.2957.106`，遵循该包许可。SHA-256 为 `271b57e3ec03c436a15d80cafeb9fd1618a43793233d8b05c9446f8de0a51be4`。

## Behind the Code

Over a decade has passed since IWCK's initial release. This software was conceived during my university days, when eight of us shared one narrow desk in the dormitory. During chilly winters, we often resorted to using laptops on our beds, where the tiny foldable desks left no room for anything beyond the laptop itself.

We frequently wished we could write assignments directly on the keyboard or safely place a cup of instant noodles without triggering accidental keystrokes. And let's face it—eating near the keyboard inevitably leads to crumbs finding their way between the keys, yet no one wants to pause their game, work, or video just to clean it.

These everyday frustrations ultimately gave birth to IWCK.

The software's actual development predates its GitHub release. The first version used AutoHotKey's native GUI, later rebuilt with GDIp before going open-source. Now powered by WebView, its interface has undergone three major aesthetic upgrades. As someone passionate about GUI design, I've always believed AutoHotKey can transcend the "ugly system controls" stereotype—here's to more AHK developers creating visually appealing and functional software!


距离IWCK首次发布已过去十余年。这款软件的构思源于我的大学时光——那时我们八人宿舍共用一张狭长书桌，空间十分局促。寒冬时节，同学们更习惯蜷缩在床上使用电脑，而那块仅容得下笔记本电脑的折叠桌板，根本腾不出空间放置其他物品。

我们常常幻想：要是能在笔记本键盘上直接书写作业该多好；或是能把泡面碗稳妥地搁在键盘上，而不触发误触。更现实的问题是，当你在键盘旁大快朵颐时，食物碎屑总会悄然入侵键隙。可谁愿意为了清理键盘，中断正在酣战的游戏或精彩的视频呢？

这些日常痛点，最终催生了IWCK的诞生。

实际上，软件的实际开发时间早于GitHub发布时间。初版采用AutoHotKey原生GUI搭建，后来通过GDIp重构后才正式开源。如今它已升级为WebView架构，界面美观度实现了三级跳。作为GUI设计的执着追求者，我想证明：即便使用AutoHotKey，也能突破系统控件的审美局限——期待AHK开发者们创造出更多兼具功能与美感的作品。


## history

- `2025.09.28`
  - add mouse block
  - replaced text in UI with graphics
- `2023.07.26`
  - migrating to AHK v2.0.4
  - use the [Neutron.ahk](https://github.com/G33kDude/Neutron.ahk.git) instead of the GDIp
- `2020.05.25`
  - migrating to AHK v2-alpha
  - use the [new GDI+ lib](https://github.com/mmikeww/AHKv2-Gdip) instead of the old one
  - change to dark style
- `2014.10.25`
  - first release
