# Note Taking in Terminal

A simple yet powerful bash script which makes note taking easier. It takes notes in every format, but in a simple way, which makes it convenient to manage knowledge and take notes in the long term.

## How to install?

clone the repo and execute this

```bash
cd note
sudo make install
note i # to initialize the directory
```

## How to use?

#### Add note
```bash
note a [press enter] [write your note] [press ctrl+d when finished]
```

#### Add notes using VIM
```bash
note ae [press enter]

[write note in vim]
```

#### Edit notes using VIM
```bash
# find note's line number
note s keywords # choose the line number from the outputs

# edit the note using its line number
note e <line_number>
```

#### Print all notes
```bash
note s .
```

#### Search between notes

```bash
note s keyword1 keyword2 keyword3 ...
```

#### Remove notes by line number
```bash
note r <line_number>
```

## How to store/sync notes with a private github repository?
```bash
# 1. create a private repository in github to use as a database
# 2. copy its SSH address
# 3. sync it using the following command 
note --sync # follow the prompts
# use note --sync from now on
```

## Bugs and new features

Notify me about bugs or suugest new features by opening an issue!
