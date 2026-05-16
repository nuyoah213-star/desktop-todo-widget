# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

桌面待办事项组件，纯 HTML/CSS/JS 实现，无需框架或 Electron。两个版本共享相同的业务逻辑但面向不同运行时。

## 文件说明

| 文件 | 用途 |
|------|------|
| `todo.hta` | Windows 桌面 Widget 版，通过 HTA 引擎运行，支持窗口置顶 |
| `todo.html` | 浏览器版，无置顶功能，现代浏览器标准渲染 |
| `Setup-Startup.vbs` | 将 `todo.hta` 快捷方式写入 Windows 启动文件夹 |
| `Remove-Startup.vbs` | 从启动文件夹删除快捷方式 |

## 架构要点

- **两个文件独立维护** — `todo.hta` 和 `todo.html` 不共享代码。修改功能时需同步更新两个文件。
- **数据隔离** — HTA 版用 `localStorage` key `dtw_todos_v3`，浏览器版用 `desktop-todo-items`，二者不互通。
- **HTA 特殊性** — HTA 运行在旧版 IE 引擎中，不支持的 API：`Arrow functions`、`const/let`、`classList` 部分方法、CSS 变量、`includes()` 等。使用 `var`、`function` 声明和 IE 兼容 DOM API，文件头部有 IE11 polyfills。
- **浏览器版** — 标准 ES6+，CSS 变量 + 现代选择器，无 polyfill 负担。
- **窗口置顶** — HTA 版通过 VBScript 定时轮询设置 `window.dialogTop = True`（每 2 秒），需要用户点击"📌 置顶"按钮触发。
- **数据模型** — 每个 todo 对象结构：`{ id, title, completed, priority, dueDate }`。`priority` 为 `'high'|'medium'|'low'`。

## 开发注意事项

- 修改完 `todo.hta` 后直接双击即可测试，无需构建。
- 如果两个文件的业务逻辑需要保持一致，两个文件都要改。
- 配色方案定义在需求文件 `修改要求1` 中：`#EB9FAA #F7D2D5 #FCEFF0 #C0CEE4`。新增 UI 元素应沿用此色板。
- HTA 版不可使用 ES6 语法和现代 DOM API，需要验证 IE 兼容性。
