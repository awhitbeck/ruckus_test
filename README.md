# ruckus_test

Initial setup of repository is done in a standard manner.  Consider adding 
a `.gitignore` file to make sure you are not clogging your repo with unnecessary files 
from Vivado.   Track your ignore file: 

`git add .gitignore`

Set up your directory structure: 

```
mkdir software
mkdir firmware
cd firmware
mkdir submodules
mkdir build
mkdir common
mkdir targets
cd -
git add firmware/
git add firmware/submodules
git add software/
```

Minimally, you need the ruckus and surf repos as submodules:

```
cd firmware/submodules
git submodule add git@github.com:slaclab/ruckus.git
git submodule add git@github.com:slaclab/surf.git
cd -
```

Then, add any other submodules that you need. Now, set up your `Makefile`
by editing the one in this directory.

Add your target directories and the corresponding `Makefile` and `ruckus.tcl` file. You can 
follow the one in the zCCM example here. 

If you did everything correctly, 
you should see a directory structure like this: 

```
#tree -L 3
.
├── firmware
│   ├── build
│   │   ├── ruckus_test
│   │   └── zCCM
│   ├── common
│   ├── release
│   ├── submodules
│   │   ├── ruckus
│   │   └── surf
│   └── targets
│       └── zCCM
├── images
├── README.md
└── software
```

A quick way to get started is to just fork this repo or copy it into a new repo.  If you clone this repo, be sure to 
do so with the `--recurse-submodules` option.  Once you copy this repo, you can edit the target directory and 
the corresponding `Makefile` and `ruckus.tlk` files.    
