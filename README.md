# pikachu
A tool which integrates stack, git and benefit from reusability of stack directory idea to reduce the compile time.

***PS: Still on it's early implementation. So please help by raising issues.***

## Scenarios:
- Switch to another branch, work for sometime and switch back then usually the compilation happens from first file. Pikachu would cache the data and reuses here, hence it doesn't compile any file.
- Recompilation usecase, when the type doesn't change ideally the dependencies shouldn't be compiled. but this is true only when the optimizations are not enabled (-O). [TBD, will mostly use `-fomit-interface-pragmas`]


## Usage:
`> pikachu build [--fast] [-j<N>]    # build haskell code using stack, where N is number of cores.`

`> pikachu <pull|push|checkout>      # git commands used by pikachu, this is required to make the copies of stack directory while changing branches.`

## TODO:
- complete support of stack, git (all options)
- use ipfs to share the first time stack directory from the creator of branch/repo. Need a commit vs hash map.
- rather than storing complete stack directory, see if possible to store only the diff.
