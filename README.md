<p align="center">
  <img src="Resources/icons/Icon.png" width="128" height="128" alt="iiBar 图标" />
</p>

<h1 align="center">iiBar</h1>

<p align="center">面向 macOS 的菜单栏管理工具：隐藏杂乱图标、整理布局，并按你的工作方式自动切换。</p>

<p align="center">
  <a href="https://github.com/Joker311223/iiBar/actions/workflows/ci.yml"><img alt="CI" src="https://img.shields.io/github/actions/workflow/status/Joker311223/iiBar/ci.yml?branch=main&style=flat-square"></a>
  <a href="https://joker311223.github.io/iiBar/"><img alt="官方文档" src="https://img.shields.io/badge/docs-官方文档-246bfd?style=flat-square"></a>
  <a href="https://github.com/Joker311223/iiBar/releases/latest/download/iiBar.dmg"><img alt="下载 iiBar" src="https://img.shields.io/badge/download-iiBar.dmg-2b7cff?style=flat-square"></a>
  <a href="LICENSE"><img alt="GPL-3.0" src="https://img.shields.io/badge/license-GPL--3.0-5b35b5?style=flat-square"></a>
  <img alt="macOS 26+" src="https://img.shields.io/badge/macOS-26%2B-111827?style=flat-square">
</p>

## 简介

iiBar 可以把不常用的菜单栏项目收进隐藏区或始终隐藏区，并通过悬停、点击、滚动、手势或快捷键快速唤出。它还提供独立的 iiBar Bar、菜单栏外观定制、项目搜索、间距控制、布局档案和自动切换能力。

## 下载与安装

从[官网](https://joker311223.github.io/iiBar/)或 [GitHub Releases](https://github.com/Joker311223/iiBar/releases/latest) 下载 `iiBar.dmg`，打开后将 iiBar 拖入“应用程序”文件夹。

当前公开安装包采用 ad-hoc 签名。如果 macOS 阻止首次启动，请前往“系统设置 → 隐私与安全性”，在 iiBar 提示旁选择“仍要打开”。

## 主要功能

- 隐藏、始终隐藏和重新显示菜单栏项目
- 拖放调整项目顺序，并保存多套布局档案
- 在刘海屏或空间不足时通过独立的 iiBar Bar 展示项目
- 搜索菜单栏项目，支持多种快捷键与自动重新隐藏规则
- 自定义菜单栏颜色、渐变、阴影、边框和形状
- 针对不同显示器保存独立配置
- 通过 `iibar://` URL Scheme 与自动化工具联动

完整说明请查看 [iiBar 官方文档](https://joker311223.github.io/iiBar/)。

## 系统要求

- macOS 26 或更高版本
- Xcode 26 或更高版本（仅源码构建需要）

## 从源码构建

```bash
git clone git@github.com:Joker311223/iiBar.git
cd iiBar
open iiBar.xcodeproj
```

在 Xcode 中选择 `iiBar` Scheme 和 `My Mac` 目标，然后运行项目。首次启动时，按照引导授予辅助功能和屏幕录制权限。

## 基本使用

1. 打开“设置 → 菜单栏布局”。
2. 将项目拖入“隐藏”或“始终隐藏”区域。
3. 在“常规”和“快捷键”中选择唤出方式与自动隐藏规则。
4. 如需按场景切换布局，可在“档案”中保存并绑定前台应用。

## 自动化

iiBar 注册了 `iibar://` URL Scheme。例如：

```bash
open "iibar://toggle-hidden"
open "iibar://search"
open "iibar://open-settings"
```

更多动作、读写设置和回调格式请查看[自动化文档](https://joker311223.github.io/iiBar/automation.html)。

## 开发与测试

```bash
xcodebuild test \
  -project iiBar.xcodeproj \
  -scheme iiBar \
  -destination 'platform=macOS' \
  CODE_SIGN_IDENTITY="" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO
```

仓库同时包含 `iiBarCtl` 调试工具，可用于测试 URL Scheme 和回调。

## 项目来源

iiBar 基于 [Thaw](https://github.com/stonerl/Thaw) 开发，而 Thaw 源自 Jordan Baird 的 [Ice](https://github.com/jordanbaird/Ice)。感谢原项目作者与所有贡献者。原有版权声明已保留在源码中。

## 许可证

本项目依据 [GNU GPL v3](LICENSE) 发布。
