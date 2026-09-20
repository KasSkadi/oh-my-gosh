# oh-my-gosh 🐋📖

把圣经带进你的 zsh：**每条命令结束后随机输出一节经文**，命令失败时自动给一节「安慰」经文，还带主题系统、按标签抽取、祈祷模式和多语言圣经版本。

```
✝ kass@Typhon · ~/code
❯ npm test
📖  凡劳苦担重担的人可以到我这里来，我就使你们得安息。  — 马太福音 11:28
✝ kass@Typhon · ~/code
❯
```

---

## 安装

### 方式一：装成独立 shell（`gosh`）

```bash
git clone <repo-url> oh-my-gosh
cd oh-my-gosh
./install-gosh.sh                # 装到 ~/.gosh
```

安装脚本会：

1. 把 `lib/ themes/ bin/ zdotdir/` 复制到 `$GOSH_HOME`（默认 `~/.gosh`）；
2. 往 `~/.zshrc` 写一段带标记的配置（自动备份原文件，`--no-rc` 可跳过）；
3. 跑一次自检，确认能抽到经文。

其他用法：

```bash
./install-gosh.sh --dir /opt/gosh   # 换安装目录
./install-gosh.sh --no-rc           # 不动 ~/.zshrc
GOSH_HOME=/opt/gosh ./install-gosh.sh
```

### 方式二：当成插件加载（推荐给已有 zsh 配置的人）

在 `~/.zshrc` 里加一行即可，不需要独立 shell：

```zsh
source "$HOME/.gosh/gosh.plugin.zsh"
```

oh-my-zsh / zinit / antigen 用户也可以把这个目录当插件，插件名用 `gosh` 或 `oh-my-gosh`（已提供 `gosh.plugin.zsh` 和 `oh-my-gosh.plugin.zsh`）。

### 方式三：临时体验

```bash
source /path/to/oh-my-gosh/gosh.plugin.zsh
gosh bless psalm
```

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

经文条目自带 `#tag` 后缀，标签跨语言统一用英文规范名：

```zsh
gosh bless psalm         # 只抽诗篇
gosh bless 诗篇           # 中文别名也行
gosh bless comfort       # 安慰类
gosh bless psalm -n 3    # 抽 3 节
gosh tag psalm           # 之后每条命令都从诗篇里抽
gosh tag all             # 清除过滤
gosh tags                # 看当前版本的全部标签和数量
```

当前版本里可用的标签（`gosh tags` 会带数量列出）：

> blessing · comfort · courage · creation · discipleship · eternal-life · faith · fear-of-god · forgiveness · friendship · generosity · gospel · grace · guidance · healing · holiness · hope · humility · identity · joy · justice · kingdom · law · light · love · mercy · obedience · patience · peace · praise · prayer · promise · protection · provision · psalm · repentance · rest · salvation · shepherd · strength · thanksgiving · tongue · trust · truth · victory · wait · wisdom · work

别名表在 [`lib/tags.zsh`](lib/tags.zsh)，支持中英、单复数、常见写法（`诗篇/詩篇/psalms/psalm-of-david → psalm`）。加新别名只要改那一处。

### 4. 彩蛋：命令失败必出「安慰」经文

`$? != 0` 时无视频率与概率，直接给一节 `#comfort`：

```
❯ make build
make: *** [build] Error 2
📖  耶和华靠近伤心的人，拯救灵性痛悔的人。  — 诗篇 34:18
```

```zsh
gosh comfort off     # 关掉彩蛋
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
export GOSH_BIBLE_VERSION=en-KJV   # 环境变量方式
gosh version en-KJV               # 运行时切换
gosh versions                     # 列出版本
gosh lang zh                      # 界面语言与经文语言解耦
gosh lang auto                    # 跟随圣经版本的语言
```

| 版本 id | 内容 | 语言 |
| --- | --- | --- |
| `zh-Hans` | 和合本 · 简体中文（默认） | zh |
| `zh-Hant` | 和合本 · 繁體中文 | zh |
| `en-KJV` | King James Version (1611) | en |

想加自己的版本？丢一个 `lib/bible/verses-<id>.zsh` 进去就会被自动识别：

```zsh
typeset -ga GOSH_VERSES=(
  "In the beginning God created the heaven and the earth.|Genesis 1:1|#creation #light"
  "The LORD is my shepherd; I shall not want.|Psalms 23:1|#psalm #shepherd #provision"
)
```

格式：`"正文|出处|#tag #tag"`（第三段可省略；标签必须来自规范标签表，才能跨语言过滤）。

---

## 命令一览

| 命令 | 作用 |
| --- | --- |
| `gosh bless [标签] [-n N]` | 立即抽经文，可按标签过滤 |
| `gosh pray [标签] [-n N] [--slow]` | 祈祷模式：经文 + 十字架 |
| `gosh tags` | 列出当前版本的标签与数量 |
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
- 主题会设置 `PROMPT` / `RPROMPT`。如果你用 starship、p10k 等接管提示符，设 `GOSH_SET_PROMPT=0` 或 `GOSH_THEME=none`，只保留经文功能。
- `gosh` 函数会优先于 `$GOSH_HOME/bin/gosh` 启动器；在 gosh 子 shell 里想再套一层用 `gosh shell`。
- 独立 shell 默认不读你原来的 `~/.zshrc`：设 `GOSH_INHERIT_ZDOTDIR=1` 可以把原来的配置一起 source 进来。
- 输出走 `precmd`，所以管道、脚本等非交互场景不受影响。
- 经文文本：和合本（1919，公有领域）与 KJV（1611，公有领域）；部分长句按分句截取。

## 自测

```bash
zsh tests/run.zsh
```

会检查数据完整性、标签抽取、失败彩蛋、主题切换、版本切换、祈祷模式、设置持久化等。

## 卸载

```bash
rm -rf ~/.gosh                       # 删除安装目录
# 再删掉 ~/.zshrc 里 # >>> oh-my-gosh >>> ... # <<< oh-my-gosh <<< 这几行
```

## License

MIT（见 [`LICENSE`](LICENSE)）。圣经文本为公有领域版本。
