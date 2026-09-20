# oh-my-gosh 🐋📖

把圣经带进你的 zsh：**每条命令结束后随机输出一节经文**，命令失败时自动给一节「安慰」经文，还带主题系统、按标签抽取、祈祷模式和多语言圣经版本。

```
✝ kass@Typhon · ~/code
❯ npm test
📖  凡劳苦担重担的人可以到我这里来，我就使你们得安息。  — 马太福音 11:28
✝ kass@Typhon · ~/code
❯
```

> ### 📖 经文原文不在本仓库
>
> 本仓库只包含代码、书卷名对照表和「引用 → 标签」索引（不含经文正文）。
> 经文数据由你运行一条命令自己生成，默认来源是 [eBible.org](https://ebible.org/) 的公有领域文本：
>
> ```bash
> gosh setup cuv kjv      # 简体和合本 + KJV
> ```
>
> 版权状态、各译本注意事项与免责声明见 **[`NOTICE.md`](NOTICE.md)**。

---

## 安装

### 方式一：当成插件加载（推荐，配合你已有的 zsh）

```bash
git clone <repo-url> oh-my-gosh
cd oh-my-gosh
./install-gosh.sh                # 装到 ~/.gosh，并往 ~/.zshrc 写一行 source
```

装完后**先获取经文数据**（仓库里没有）：

```bash
gosh setup cuv          # 新标点和合本（简体，公有领域）
gosh setup kjv          # King James Version（公有领域）
gosh setup              # 不带参数：列出可用来源和当前状态
```

然后 `source ~/.zshrc` 或重开终端，随便跑一条命令就能看到经文。

安装脚本会：把 `lib/ themes/ tools/ bin/ zdotdir/` 复制到 `$GOSH_HOME`（默认 `~/.gosh`）、往 `~/.zshrc` 写一段带标记的配置（自动备份原文件，`--no-rc` 可跳过）、跑一次自检。它**不会**自动下载经文，也不会把经文写进你的仓库。

其他用法：

```bash
./install-gosh.sh --dir /opt/gosh   # 换安装目录
./install-gosh.sh --no-rc           # 不动 ~/.zshrc
GOSH_HOME=/opt/gosh ./install-gosh.sh
```

### 方式二：手动 source（最简单）

```bash
git clone <repo-url> oh-my-gosh
tools/fetch-verses.sh cuv           # 生成经文数据
echo 'source ~/oh-my-gosh/gosh.plugin.zsh' >> ~/.zshrc
```

oh-my-zsh / zinit / antigen 用户也可以把仓库目录当插件，插件名用 `gosh` 或 `oh-my-gosh`（已提供 `gosh.plugin.zsh` 和 `oh-my-gosh.plugin.zsh`）。

### 方式三：独立 shell（`gosh` 启动器）

```bash
~/.gosh/bin/gosh        # 自带 zdotdir 的 zsh，不影响你的 ~/.zshrc
```

---

## 获取经文数据

```bash
tools/fetch-verses.sh list       # 看可用来源 / 已装数据
tools/fetch-verses.sh cuv        # 新标点和合本（简体）
tools/fetch-verses.sh cuvt       # 新標點和合本（繁體）
tools/fetch-verses.sh kjv        # King James Version (1611)
tools/fetch-verses.sh web        # World English Bible

# 只装某几卷，省内存
tools/fetch-verses.sh cuv --books PSA,PRO,MAT,JHN

# 用自己手上的文本
tools/fetch-verses.sh from-file 我的清单.txt --id my-ver --lang zh --name "我的摘录"
tools/fetch-verses.sh from-file 我的清单.txt --id my-ver --lang en --format tsv

tools/fetch-verses.sh clean --yes   # 删除本工具生成的数据
```

在 zsh 里 `gosh setup cuv` 等价于调用上面这个脚本。数据落在 `$GOSH_HOME/lib/bible/`，这两个文件都被 `.gitignore` 忽略：

| 文件 | 内容 |
| --- | --- |
| `verses-<id>.txt` | 每行 `出处<TAB>#tags<TAB>正文`，惰性加载 |
| `verses-<id>.meta` | `name` / `lang` / `count` / `source` / `date` |

格式细节、以及「手写小数据集」用的 `.zsh` 格式，见 [`lib/bible/README.md`](lib/bible/README.md)。

导入时，脚本会自动套用 [`tools/curated-tags.txt`](tools/curated-tags.txt)（只有节号和标签，没有经文）：

```
PSA 23:1|#provision #psalm #shepherd #trust
LAM 3:22|#comfort #hope #mercy
```

所以换任何译本，`gosh bless psalm`、失败彩蛋的 `#comfort` 都照样能用；其余经文按书卷归类（`#law` `#psalm` `#gospel` `#epistle` …）。

---

## 功能

### 1. 每条命令结束随机输出经文

用 `precmd` 钩子在提示符出现前抽一节经文。节奏可调：

```zsh
gosh freq 3          # 每 3 条命令输出一次（0 = 不自动输出）
gosh prob 60         # 60% 概率触发
gosh off / gosh on   # 总开关
```

连续抽到同一节会被避开（记住最近 8 节，`GOSH_VERSE_NO_REPEAT` 可调）。

### 2. 主题系统 `theme-*.zsh`

```zsh
export GOSH_THEME=revelation     # 环境变量方式
gosh theme revelation            # 或者运行时切换
gosh themes                      # 列出全部主题
```

| 主题 | 风格 |
| --- | --- |
| `default` | 经典两行提示符 + 📖 前缀 |
| `minimal` | 极简：纯文本经文，安静提示符 |
| `revelation` | 启示录：烈焰配色 + 经文边框 + 金色十字架 |
| `heaven` | 天堂：云白与柔蓝 |
| `none` | 只输出经文，完全不改动你的提示符 |

每个主题就是 `themes/theme-<name>.zsh`，可以自己加一个（见下方「写主题」）。

### 3. 按分类抽取（`#tag`）

```zsh
gosh bless psalm         # 只抽诗篇
gosh bless 诗篇           # 中文别名也行
gosh bless comfort       # 安慰类
gosh bless psalm -n 3    # 抽 3 节
gosh tag psalm           # 之后每条命令都从诗篇里抽
gosh tag all             # 清除过滤
gosh tags                # 看当前数据的全部标签和数量
```

可用标签取决于你装的数据和精选标签表（`gosh tags` 会带数量列出）：

> blessing · comfort · courage · creation · discipleship · epistle · eternal-life · faith · fear-of-god · forgiveness · friendship · generosity · gospel · grace · guidance · healing · history · holiness · hope · humility · identity · joy · justice · kingdom · law · light · love · mercy · obedience · patience · peace · praise · prayer · promise · prophecy · protection · provision · psalm · repentance · rest · salvation · shepherd · strength · thanksgiving · tongue · trust · truth · victory · wait · wisdom · work

别名表在 [`lib/tags.zsh`](lib/tags.zsh)，支持中英、单复数、常见写法（`诗篇/詩篇/psalms/psalm-of-david → psalm`）。加新别名只改那一处。

### 4. 彩蛋：命令失败必出「安慰」经文

`$? != 0` 时无视频率与概率，直接给一节 `#comfort`：

```
❯ make build
make: *** [build] Error 2
📖  耶和华靠近伤心的人，拯救灵性痛悔的人。  — 诗篇 34:18
```

```zsh
gosh comfort off         # 关掉彩蛋
GOSH_COMFORT_TAG=mercy   # 换一个标签（比如 mercy / hope）
```

### 5. 祈祷模式 `gosh pray`

十字架 + 一串随机经文 + 收尾阿们：

```
❯ gosh pray

─────────  祈禱 · PRAYER  ─────────
        ##
        ##
        ##
  ##############
        ##
        ##
        ##
        ##

📖  我虽然行过死荫的幽谷，也不怕遭害，因为你与我同在。  — 诗篇 23:4
📖  神所赐、出人意外的平安，必在基督耶稣里保守你们的心怀意念。  — 腓立比书 4:7
...
          阿們 · Amen
```

```zsh
gosh pray                # 默认 5 节
gosh pray psalm -n 7     # 7 节诗篇
gosh pray --slow         # 每节之间停顿 0.6 秒
```

### 6. 多语言圣经版本

```zsh
gosh setup cuv           # 装简体
gosh setup cuvt          # 装繁體
gosh version zh-Hant     # 切换
gosh versions            # 列出已装版本（名字、语言、节数）
gosh lang zh             # 界面语言与经文语言解耦
gosh lang auto           # 跟随圣经版本的语言
```

版本 id 由你自己决定（内置来源用 `zh-Hans` / `zh-Hant` / `en-KJV` / `en-WEB`），
只要 `lib/bible/verses-<id>.txt` 存在就能 `gosh version <id>`。

---

## 命令一览

| 命令 | 作用 |
| --- | --- |
| `gosh setup [来源...]` | 获取经文数据（cuv / cuvt / kjv / web） |
| `gosh bless [标签] [-n N]` | 立即抽经文，可按标签过滤 |
| `gosh pray [标签] [-n N] [--slow]` | 祈祷模式：经文 + 十字架 |
| `gosh tags` | 列出当前数据的标签与数量 |
| `gosh tag [标签\|all]` | 查看 / 设置 / 清除全局标签过滤 |
| `gosh themes` / `gosh theme [名字]` | 列出 / 查看 / 切换主题 |
| `gosh versions` / `gosh version [id]` | 列出 / 查看 / 切换圣经版本 |
| `gosh lang [zh\|en\|auto]` | 界面语言 |
| `gosh on` / `gosh off` | 开关随机经文 |
| `gosh freq N` / `gosh prob P` | 频率 / 概率 |
| `gosh comfort on\|off` | 失败彩蛋开关 |
| `gosh status` | 当前配置一览 |
| `gosh save` | 把当前设置写入 `$GOSH_HOME/goshrc` |
| `gosh shell` | 打开一个嵌套的 gosh shell |
| `gosh help` | 帮助 |

`gosh save` 生成的 `$GOSH_HOME/goshrc` 会在下次启动时自动加载，所以 `gosh theme revelation && gosh save` 就是永久换主题。

---

## 配置项

写在 `~/.zshrc`、`$GOSH_HOME/goshrc` 或直接 export：

| 变量 | 默认 | 说明 |
| --- | --- | --- |
| `GOSH_ENABLE_VERSE` | `1` | 总开关 |
| `GOSH_VERSE_FREQUENCY` | `1` | 每 N 条命令输出一次；`0` = 不自动输出 |
| `GOSH_VERSE_PROBABILITY` | `100` | 触发概率（%） |
| `GOSH_VERSE_TAG` | 空 | 全局标签过滤，如 `psalm` |
| `GOSH_VERSE_NO_REPEAT` | `8` | 记住最近 N 节，避免连续重复 |
| `GOSH_COMFORT_ON_ERROR` | `1` | 命令失败必出安慰经文 |
| `GOSH_COMFORT_TAG` | `comfort` | 失败时抽取的标签 |
| `GOSH_THEME` | `default` | 主题名，或 `none` |
| `GOSH_SET_PROMPT` | `1` | `0` = 只输出经文，绝不碰提示符 |
| `GOSH_BIBLE_VERSION` | `zh-Hans` | 圣经版本 id |
| `GOSH_LANG` | 跟随版本 | 界面语言 `zh` / `en` |
| `GOSH_VERSE_SHOW_REF` | `1` | 是否显示出处 |
| `GOSH_VERSE_SHOW_TAGS` | `0` | 是否把 `#tags` 也打出来（调试用） |
| `GOSH_VERSE_PREFIX` / `_COLOR` / `_REF_COLOR` / `_SEP` | 主题决定 | 显示样式 |
| `GOSH_PRAY_COUNT` | `5` | 祈祷模式默认节数 |
| `GOSH_PRAY_DELAY` | `0` | 祈祷模式每节间隔（秒） |
| `GOSH_HOME` | `~/.gosh` | 安装目录 |

---

## 写一个主题

新建 `themes/theme-mytheme.zsh`：

```zsh
GOSH_THEME_NAME="mytheme"
GOSH_VERSE_PREFIX="✧  "
GOSH_VERSE_COLOR=177          # 256 色
GOSH_VERSE_REF_COLOR=96
GOSH_VERSE_SEP="  · "
GOSH_CROSS_COLOR=177
typeset -ga GOSH_CROSS_ART=(
  '        ##       '
  '  ############## '
  '        ##       '
)

# 可选：自定义经文渲染（不然用默认样式）
_gosh_theme_render_verse() {
  local text=${1//\%/%%} ref=$2
  print -P "%F{${GOSH_VERSE_COLOR}}${GOSH_VERSE_PREFIX}${text}%f%F{${GOSH_VERSE_REF_COLOR}}${GOSH_VERSE_SEP}${ref}%f"
}

# 可选：自定义祈祷标题
_gosh_theme_banner() { print -P "%F{177}✧  $(_gosh_t prayer_title) ✧%f" }

if [[ -o interactive ]] && [[ $GOSH_SET_PROMPT == 1 ]]; then
  PROMPT='%F{177}✧%f %F{yellow}%~%f
%F{177}❯%f '
  RPROMPT='%F{240}%D{%H:%M}%f'
fi
```

然后 `gosh theme mytheme` 就能用了。可用的钩子：`_gosh_theme_render_verse`、`_gosh_theme_render_cross`、`_gosh_theme_banner`。

---

## 兼容性与注意事项

- 需要 zsh 5.x，支持 macOS / Linux / WSL。
- 全本圣经数据（约 3–5 MB、3 万节）采用**惰性加载**：启动 shell 时不读数据，第一次真的要输出经文时才读进内存（一次性约 0.3 秒，之后就没有开销）。想更省内存可以只导入部分书卷（`--books PSA,PRO`）或用 `.zsh` 格式手写小清单。
- 主题会设置 `PROMPT` / `RPROMPT`。如果你用 starship、p10k 等接管提示符，设 `GOSH_SET_PROMPT=0` 或 `GOSH_THEME=none`，只保留经文功能。
- `gosh` 函数会优先于 `$GOSH_HOME/bin/gosh` 启动器；在 gosh 子 shell 里想再套一层用 `gosh shell`。
- 独立 shell 默认不读你原来的 `~/.zshrc`：设 `GOSH_INHERIT_ZDOTDIR=1` 可以把原来的配置一起 source 进来。
- 输出走 `precmd`，所以管道、脚本等非交互场景不受影响。
- 仓库不含经文原文；`lib/bible/` 里的数据被 `.gitignore` 忽略，不要提交。

## 版权与数据来源

代码 MIT（见 [`LICENSE`](LICENSE)）；经文文本由你自行获取，各来源的授权状态见
**[`NOTICE.md`](NOTICE.md)**（含 KJV 在英国属永久 Crown copyright、和合本修订版等
新译本仍受版权保护等注意事项）。本文件不构成法律意见。

## 自测

```bash
zsh tests/run.zsh
```

测试会在临时目录里搭一个 `GOSH_HOME`，用 `tools/fetch-verses.sh` 导入一份**假经文
fixture**（正文是占位文字，只有出处和标签是真的），然后验证导入、惰性加载、标签
抽取、失败彩蛋、主题、版本切换、祈祷模式、设置持久化等 85 项；同时检查仓库里
没有经文数据、`.gitignore` 确实挡住了它。

## 卸载

```bash
rm -rf ~/.gosh                       # 删除安装目录（含你生成的数据）
# 再删掉 ~/.zshrc 里 # >>> oh-my-gosh >>> ... # <<< oh-my-gosh <<< 这几行
```
