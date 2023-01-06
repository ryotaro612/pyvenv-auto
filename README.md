# pyvenv-auto

## Abstract
pyvenv-auto automatically activates a Python venv  with [pyvenv](https://github.com/jorgenschaefer/pyvenv).
When you open a file in `python-mode`, it searches for the venv directory near the file, and activates it.

## Installation
You can install the package from Melpa:

M-x package-install RET pyvenv-auto

## Usage
You can enable pyvenv-auto as below.

```
(use-package pyvenv-auto
  :hook ((python-mode . pyvenv-auto-run)))
```

When you open a Python file, pyvenv-auto searches for a venv directory with a name in `pyvenv-auto-venv-dirnames`.
The default value of the variable is `(list "venv" ".venv")`.
The search behavior is similar to that of `locate-dominating-file`.
The directory name with a smaller index has higher priority than that with a greater index.
