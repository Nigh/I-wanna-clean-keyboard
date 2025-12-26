
<div align="center">
<img width="256" height="256" alt="logo" src="https://github.com/user-attachments/assets/56662a6c-ec9c-42b7-9e7a-4c59182c7901" />
<img alt="title" src="https://capsule-render.vercel.app/api?type=transparent&fontColor=dbdbdb&text=I%20Wanna%20Clean%20Keyboard&desc=and%20mouse&descAlignY=78&descAlign=76&height=80&fontSize=48"/>
<a href="https://hellogithub.com/repository/Nigh/I-wanna-clean-keyboard" target="_blank"><img src="https://abroad.hellogithub.com/v1/widgets/recommend.svg?rid=1b127af0ff114f17b796318d883515b0&claim_uid=fzFw5oyluD4xqHa&theme=dark" alt="Featured｜HelloGitHub" style="width: 250px; height: 54px;" width="250" height="54" /></a>
</div>

`iwck` could block the keyboard input while you were eating, writing or cleaning the key on your laptop keyboard. Now also supports blocking mouse input...  
`iwck`可以帮助你在笔记本键盘上吃泡面、做笔记或者擦键盘时屏蔽键盘的输入。现在也添加了对鼠标的支持。

## screenshot
<img width="437" height="307" alt="Screenshot 2025-09-28 204740" src="https://github.com/user-attachments/assets/025c8a1d-c072-4975-aab5-56ff6f8f025f" />


## usage

- press **keyboard button** to block or unblock your keyboard input.  
点击 **键盘按钮** 切换键盘屏蔽状态
- press **mouse button** then press `Esc` to block or unblock your mouse input.  
点击 **鼠标按钮** 然后按 `ESC` 键切换鼠标屏蔽状态
- press **exit button** to unblock your input and exit the app.  
点击 **退出按钮** 解除屏蔽并退出
- click the title `iwck` to drag the window.  
点击标题 `iwck` 可以拖动窗口位置

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
