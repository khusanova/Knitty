# Knitty

**An iOS app for people who knit without a plan — count rows, repeat sections, and write the pattern as you go.**

## Why I built this

I knit, but I rarely follow a pattern to the letter — I'll grab one as a loose starting point and then change things as I go: a different heel, a tweak to the shaping, an extra repeat because I liked how it looked. The part I could never keep straight was the bookkeeping. Which row am I on? How many times have I worked this repeat? What did I do differently last time so I can do it again on the second sock?

Socks are the worst offender. Getting a pair to fit *exactly* right means small, deliberate adjustments — and then remembering them. Paper notes get lost, and a plain row counter gives you nowhere to scribble "decreased one extra stitch here" next to the row it actually happened on. 

Knitty is the tracker I wanted: built for the way I knit, where the pattern is something you *discover* row by row rather than download up front.

## What it does

Knitty has reached **MVP** — the core knitting workflow is fully usable. The first pair of socks knitted with Knitty's help is currently a work in progress (the app is further along than the socks 🧦).

### 🧶 Build the pattern while you knit
No pre-planning, no PDF to import. Knit a row, type what you just did, move on. Your project takes shape as you make it, and it's all saved for next time.

### ✏️ Every row is yours to write
A row isn't a fixed code you have to look up — it's **free-form text you can write whatever you want into**. Real stitch instructions, a reminder to yourself, a note about a change you made — anything. And you can edit it any time, so your notes stay with the exact row they belong to.

### 🔢 Row groups, each with its own counter
This is the heart of it. Knitting is full of repetition — work *this* section 6 times, then *that* section 12 times. In Knitty those are **row groups**, and each repeat carries its **own independent counter**. So when you're three rounds into the fourth repeat of the leg, Knitty knows exactly that. The knitting screen always shows the current row and lets you advance (**Next Row**) or back up (**Unravel**) one row at a time.

### 🧦 Organize a project into parts
Split a project into named parts — cuff, leg, heel, foot, toe — and track each one separately. 

### 🛠️ Edit as you change your mind
The editor shows each row group in big brackets with a `× N` repeat badge. Bump the repeat count with a stepper, add rows, or delete a group. Change the plan halfway through — Knitty keeps up.

## Built with

- **SwiftUI** for the interface
- **SwiftData** for persistence — projects, parts, row groups, and progress are stored locally and restored on launch

## Roadmap

Next up: reordering parts and row groups, dedicated per-group notes, a richer built-in knitting vocabulary, and eventually multi-device sync.
