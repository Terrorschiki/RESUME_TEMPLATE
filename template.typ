// ============================================================
//  template.typ —— 版式与样式层
//
//  这里定义简历“长什么样”。日常改简历内容请编辑 main.typ；
//  只有想调整字体、字号、条目样式时才需要动本文件。
// ============================================================

#import "@preview/resume-ng:1.0.0": project

// ------------------------------------------------------------
//  可调参数
// ------------------------------------------------------------

// 正文字体候选：Typst 按顺序取第一个系统里装了的字体。
// 列表里没装的字体只会打印 “unknown font family” 警告，不影响输出，
// 想换字体把想要的写到第一位即可，例如：
//   macOS      → ("Songti SC", "STSong", "Noto Serif SC")
//   Windows 自带宋体 → ("SimSun",)
#let default-fonts = (
  "Noto Serif SC",
  "Noto Serif CJK SC",
  "SimSun",
)

// 条目标题（学校 / 单位 / 项目名）与右侧时间、备注的字号
#let entry-size = 12pt

// ------------------------------------------------------------
//  内部工具
// ------------------------------------------------------------

// 日期格式化：留空表示“至今”；已是字符串就原样输出
#let format-date(date) = {
  if type(date) == datetime { date.display() }
  else if type(date) == str and date.len() == 0 { "今" }
  else if type(date) == str { date }
  else { "" }
}

// 起止时间。两端都为空时不显示，因此“荣誉奖项”这类无日期的条目不会出现多余的横线
#let resume-date(start, end: "") = {
  if start == "" and end == "" { "" }
  else { format-date(start) + " " + $dash.en$ + " " + format-date(end) }
}

// 一条经历：左侧标题 + 右侧时间，换行后是正文（通常写 - 列表）
#let resume-entry(left: "", right: "", body) = {
  if right != "" { text(size: entry-size, place(end, right)) }
  if left != "" {
    text(size: entry-size, left)
    linebreak()
  }
  body
}

// 把若干段文字用 " | " 连起来，自动跳过空值
// （避免 duty 留空时出现 “标题 | ” 这种悬空的分隔符）
#let join-parts(parts) = {
  let kept = parts.filter(p => p != none and p != "")
  kept.join(" | ")
}

// ------------------------------------------------------------
//  章节标题
// ------------------------------------------------------------

#let resume-section(title) = {
  v(-8pt)
  heading(level: 1, title)
  line(length: 100%)
  v(-2pt)
}

// ------------------------------------------------------------
//  经历条目
//
//  三者结构一致：左「主标题 | 副标题」，右「起止时间」。
//  note 用于放不适合写成日期的右侧内容（例如“专利号 ZLxxxx”），
//  传入 note 后 start / end 会被忽略。
// ------------------------------------------------------------

// 教育经历：左「学校 | 专业 | 学位」
#let resume-education(
  university: "",
  degree: "",
  school: "",
  start: "",
  end: "",
  body,
) = {
  resume-entry(
    left: join-parts((strong(university), school, degree)),
    right: resume-date(start, end: end),
    body,
  )
}

// 工作 / 学生工作：左「单位 | 职务」
#let resume-work(
  company: "",
  duty: "",
  start: "",
  end: "",
  note: "",
  body,
) = {
  resume-entry(
    left: join-parts((strong(company), duty)),
    right: if note != "" { note } else { resume-date(start, end: end) },
    body,
  )
}

// 项目 / 比赛 / 荣誉：左「项目名 | 角色」
#let resume-project(
  title: "",
  duty: "",
  start: "",
  end: "",
  note: "",
  body,
) = {
  resume-entry(
    left: join-parts((strong(title), duty)),
    right: if note != "" { note } else { resume-date(start, end: end) },
    body,
  )
}

// ------------------------------------------------------------
//  文档顶层
//
//  用法（main.typ 的第一条指令）：
//      #show: resume.with(name: "【姓名】", contacts: (…))
// ------------------------------------------------------------

#let resume(
  name: "【姓名】",
  contacts: (),
  fonts: default-fonts,
  body,
) = {
  show: project.with(title: name, author: (name: name), contacts: contacts)
  set text(font: fonts, lang: "zh")
  body
}
