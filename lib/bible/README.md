# 经文数据目录

**本仓库不包含任何圣经原文。** 这个目录是数据落地的地方，里面的
`verses-*.txt` / `verses-*.meta` / `verses-*.zsh` 都被 `.gitignore` 忽略，
不会被提交，也不会随仓库分发。

## 怎么获得数据

```bash
# 仓库里运行
tools/fetch-verses.sh list        # 看可用来源
tools/fetch-verses.sh cuv         # 新标点和合本（简体）
tools/fetch-verses.sh kjv         # King James Version

# 装好之后在 zsh 里运行（等价，帮你调用上面这个脚本）
gosh setup cuv kjv
```

详细说明与版权信息见仓库根目录的 [`NOTICE.md`](../../NOTICE.md)。

## 文件格式

### `verses-<id>.txt`（推荐，惰性加载）

每行一节，字段用 **TAB** 分隔：

```
出处 <TAB> #tags <TAB> 正文
```

例如（下面是格式示例，不是经文）：

```
Genesis 1:1	#law #creation	<正文>
诗篇 23:1	#psalm #provision	<正文>
Psalms 23:4	#psalm #comfort	<正文>
```

- 第 2 段可以是空的（写成 `出处 <TAB><TAB> 正文`），此时只按书卷归类。
- 正文里不能出现 TAB 或换行。
- 大文件（全本圣经约 3–5 MB）用这种格式：zsh 侧只在第一次要用经文时读入，
  不会拖慢 shell 启动。

### `verses-<id>.meta`（可选）

```
name=新标点和合本（简体）
lang=zh
id=zh-Hans
count=31021
source=eBible.org (cmn-cu89s) · Public Domain
date=2026-09-20
```

没有这个文件也能用，只是 `gosh status` / `gosh versions` 显示的信息少一些，
语言按 id 前缀（`zh-*` / `en-*`）推断。

### `verses-<id>.zsh`（手写小数据集时方便）

```zsh
typeset -ga GOSH_VERSES=(
  "正文|出处|#tag #tag"
  "正文|出处"          # 第三段可省略
)
```

这种格式会在 shell 启动时直接 source 进内存，适合几十到几百节的个人清单；
全本圣经请用 `.txt`。

## 自己写经文

只要格式对，任何文本都能用（你自己的摘录、其他语言、其他公有领域译本）：

```bash
tools/fetch-verses.sh from-file 我的清单.txt --id my-ver --lang zh --name "我的摘录"
# 或者在 zsh 里
gosh version my-ver
```

导入前请自行确认你有权使用这些文本——`NOTICE.md` 里有各译本的版权状态说明。
