# dotfiles

## 만든 이유 

* windows와 linux에서 동일한 설정파일을 사용하고 싶다.
* 내 PC가 아닌곳에서 작업할 때 원래 사용하던 개발 설정을 가지고 오고 싶다.
* 개발 설정을 안전한 곳에 보관하고 싶다.

## 특징

- line ending in cross-platform : [이 StackOveflow의 조언을 따름](https://stackoverflow.com/a/13154031/9457247)

## dotfile installation

Open a terminal and follow along!

1. Clone this repository: `git cloen https://github.com/honggaruy/dotfiles`
1. Change current directory into the folder: `cd dotfiles`
1. Run the bootstrap script
    -  For Windows :  
        1. Open an [elevated PowerShell](https://winaero.com/all-ways-to-open-powershell-in-windows-10/)
        1. [Dot source](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_scripts?view=powershell-7.2#script-scope-and-dot-sourcing) the `bootstrap.windows.exclude.ps1` script as follows
            ```sh
            > . .\bootstrap.windows.exclude.ps1
            ```

## 의존성

* `.ps1` 파일은 PowerShell 5.1 기준으로 작성함

## 참고한 링크

* [How to make your dotfile management a painless affair](https://www.freecodecamp.org/news/dive-into-dotfiles-part-2-6321b4a73608/)
* [Jay Harris's dotfiles for Windows](https://github.com/jayharris/dotfiles-windows)



