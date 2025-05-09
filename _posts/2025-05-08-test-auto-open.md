---
layout: post
title: Test Auto-Open
date: 2025-05-08 20:52 -0600
category: [tutorial]
tags: [jekyll, ruby]
---

# H1
## H2

*Italic*
**Bold**

- First Item
- Second Item
  - First nested item
  - Second nested item
- Third Item

1. First Item
2. Second Item
   1. First nested item
   2. Second nested item
3. Third Item

A link to [Google](https://www.google.com)

---

'''jekyll_compose:
  auto_open: true
  default_front_matter:
    drafts:
      category: []
      tags: []
    posts:
      category: []
      tags: []
'''
