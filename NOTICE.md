# NOTICE — 经文文本的来源、版权与使用须知

## 一句话总结

**这个仓库不包含任何圣经原文。** 代码是 MIT；经文文本由使用者自行获取或提供，
请自己确认所用译本的授权状态。仓库里只有：代码、书卷名对照表、以及一张
「引用 → 标签」的索引表（只有节号和标签，没有经文正文）。

---

## 仓库里有什么 / 没有什么

| 内容 | 是否包含 | 说明 |
| --- | --- | --- |
| zsh 代码、主题、补全 | ✅ | 以 MIT 授权（见 [`LICENSE`](LICENSE)） |
| 书卷名对照表 `tools/books.tsv` | ✅ | 只有书卷名与代码，属事实性数据 |
| 精选标签表 `tools/curated-tags.txt` | ✅ | 只有「书卷 章:节 → #标签」的索引，**不含经文正文** |
| 圣经经文正文 | ❌ | 由使用者运行 `tools/fetch-verses.sh` 或自备文件生成 |
| 生成出来的 `lib/bible/verses-*` | ❌ | 已被 `lib/bible/.gitignore` 忽略，不会进入版本库 |

> 一句话：标签表是「哪里在讲安慰」的索引，不是经文本身的复制；经文正文永远不进仓库。

---

## 推荐的公有领域来源

`tools/fetch-verses.sh` 内置的四个来源都来自 [eBible.org](https://ebible.org/)，
该站将其标注为 Public Domain：

| 来源命令 | 语种 | 译本 | 版权状态 |
| --- | --- | --- | --- |
| `tools/fetch-verses.sh cuv` | 简体中文 | 新标点和合本（`cmn-cu89s`） | eBible.org 标注 Public Domain |
| `tools/fetch-verses.sh cuvt` | 繁體中文 | 新標點和合本（`cmn-cu89t`） | eBible.org 标注 Public Domain |
| `tools/fetch-verses.sh kjv` | English | King James Version (1611) | 多数国家公有领域；**英国例外，见下** |
| `tools/fetch-verses.sh web` | English | World English Bible | 公有领域（名称是 eBible.org 的商标） |

其他可自行获取的公有领域文本：Project Gutenberg 的 KJV（[#10](https://www.gutenberg.org/ebooks/10)）、
ASV 1901、Douay-Rheims 1899、Young's Literal Translation、文理和合本等。
这些都可以用 `tools/fetch-verses.sh from-file` 导入。

### KJV 的英国例外

KJV 在美国及其他多数国家属于公有领域，但在**英国**享有**永久 Crown copyright**
（由皇家特许状授予，权利由 Cambridge University Press / Oxford University Press /
the King's Printer for Scotland 等行使）。英国境内复制 KJV 严格来说需要许可；
非商业引用一般不会被追究，但若你打算在英国商业分发，请改用 World English Bible
或 ASV 1901，或先取得许可。

### 和合本：注意「版本」而不是「年代」

- **官话和合本（1919）** 与 eBible 收录的 **新标点和合本（1989）** 属公有领域，
  可以直接使用。
- **和合本修订版（RCUV，2010）**、**现代标点和合本**、**新译本**、**现代中文译本** 等
  较新的译本仍在版权保护期内，部分版本由香港圣经公会 / 联合圣经公会等机构主张权利，
  需授权才能复制。
- 所以：**不要**从圣经网站或电子书里复制粘贴新译本的正文，也不要把上述文本提交进仓库。
  用 `tools/fetch-verses.sh` 获取，或导入你确认过授权的文本。

其他常见受版权保护的译本：NIV、ESV、NASB、NLT、新普及译本等——同样需要授权。

---

## 引用与署名

- 输出经文时保留出处（`gosh` 默认显示 `— 诗篇 23:4`）既是好习惯，也符合署名权要求
  （署名权在中文语境下通常是永久的，不随财产权到期而消失）。
- 少量引用受版权保护的译本时，通常属于合理使用 / 合理使用范围的引用；
  但把上百节经文固化成数据文件再分发，就超出「少量引用」了——这正是本项目
  只提供公有领域来源的原因。
- 若你把本项目再分发（fork、打包、做成插件市场条目），请保留 `NOTICE.md` 与
  生成数据文件头部的来源信息。

---

## 你自己的责任

1. 生成的数据只在你本地使用；不要把 `lib/bible/verses-*` 提交到任何公开仓库。
2. 在导入任何第三方文本前，确认你有权使用，并遵守其授权条款。
3. 如果你所在司法辖区的规定与此处描述不同，以当地法律为准。

## 免责声明

本文件是项目维护者整理的公开信息，**不构成法律意见**。商业分发或大批量复制前，
请咨询专业律师。

---

## English summary

This repository ships **no Bible text**. It contains only code (MIT), a book-name
table, and a reference-to-tag index that contains no scripture. You generate the
verse data yourself with `tools/fetch-verses.sh` (eBible.org public-domain sources:
Chinese Union Version 新标点和合本, KJV, World English Bible) or by importing your own
licensed text. Generated files under `lib/bible/` are git-ignored and must not be
committed. Note that the KJV is subject to perpetual Crown copyright in the United
Kingdom, and that modern Chinese versions such as 和合本修订版 (RCUV) are still under
copyright. Nothing here is legal advice.
