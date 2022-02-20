# anejil

## Abstract
anejil automatically activates a Python venv  with ![pyvenv](https://github.com/jorgenschaefer/pyvenv) .
When you open a Python file, it searches for the venv directory near the file, and activates it.

## Installation
Put `anejil.el` in a directory that `load-path` contains.

## Usage
You can enable anejil as below.

```
(anejil-mode t)
```

When you open a Python file, anejil searches for a venv directory with a name in `anejil-venv-dirnames`.
The search behavior is similar to that of `locate-dominating-file`.
The directory name with a smaller index has higher priority than that with a greater index.
