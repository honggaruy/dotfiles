# PowerShell 5.1용 ternary operator :  https://stackoverflow.com/a/25682508/9457247
# PowerShell 7.0 은 공식 ternary operator가 따로 있음.
Function IIf($If, $Then, $Else) {
    If ($If -IsNot "Boolean") {$_ = $If}
    If ($If) {If ($Then -is "ScriptBlock") {&$Then} Else {$Then}}
    Else {If ($Else -is "ScriptBlock") {&$Else} Else {$Else}}
}
function MakeSymLinks {
    <#
    .SYNOPSIS
    설정파일들을 사용자 홈에 링크를 걸어 사용할 수 있도록 한다.
    .DESCRIPTION
    dotfiles에 있는 설정파일들에 대해 home 폴더에 심볼릭 링크를 생성한다.
    같은 폴더에 있는 SymLinks.csv 파일에 등록된 파일만을 대상으로 심볼릭 링크를 생성한다.
    SymLInks.csv 형식은 다음과 같다.
    Target 컬럼 : 현재 폴더인 dotfiels 폴더에 존재하면서 링크를 걸어줄 대상
    LinkFolder 컬럼 : 링크를 생성할 폴더. 대부분의 경우 사용자의 homde 폴더이다. 예) c:\User\hongg
    PathType 컬럼 : 파일(leaf)인지 폴더(Container) 형식인지 알려줌. 참고) help Test-Path -OnLine > Parameters > -PathType 참조
    .PARAMETER NotForLinks
    무시할 파일명을 array 형태로 입력한다.
    .EXAMPLE
    MakeLinks -NotForLinks "*.un~", ".gitignore", "*exclude*" -Verbose
    기본값 NotForLinks를 사용하지 않고 사용자 지정한다. 
    Verbose 옵션으로 좀 더 자세한 내용을 확인한다.
    .EXAMPLE
    Get-Help MakeSymLinks -Detailed
    연습삼아 만들어본 comment-based-help를 출력한다.
    #>
    [CmdletBinding()]
    param (
        # [How to set the default argument to an array](https://stackoverflow.com/a/44750445/9457247)
        # 굳이 파라메터로 할 필요는 없었으나 연습삼아 해봄.
        # dotfiles 폴더에서 LinK 만들기를 제외해야할 파일이 생긴다면 이곳에 등록한다.
        [array]$NotForLinks = @("*.un~", ".gitignore", "*.exclude.*", "*.csv")
    )
    BEGIN {
        # "현재 폴더에서 NotForLinks를 제외한 등록대상 파일들을 읽어온다."
        # "또한 'SymLinks.csv'에 등록된 링크대상목록을 읽어온다."
        # 해시 테이블 만들기 : https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/group-object?view=powershell-7#example-6--group-objects-in-a-hash-table
        $currentItems = Get-Item * -Exclude $NotForLinks | Group-Object -Property PSChildName -AsHashTable
        # csv 파일에서 Symbolic Link를 만들 대상을 가져온다. 
        $symLinks = Import-Csv -Path .\SymLinks.csv
        $symLinkHashTable = $symLinks | Group-Object -Property Target -AsHashTable
    }
    PROCESS {
        # 현재 dotfiles에 있는 파일중에 SymLink를 만들어야 하는데 누락된 파일이 없는지 검사한다.
        # 즉, SymLinks.csv 파일에 등록된 내역이 최신 상태인지 검사한다.
        # 참고 : https://docs.microsoft.com/ko-kr/powershell/scripting/learn/deep-dives/everything-about-hashtable?view=powershell-7#getenumerator
        $currentItems.GetEnumerator() | ForEach-Object{
            if (!$symLinkHashTable.ContainsKey($_.key)){
                Write-Verbose "$($_.key) 는 'SymLink.csv'에 등록되지 않았습니다. 등록여부 확인 요망. "
            }
        }
        $symLinks | ForEach-Object{
            # cmdlet에서 해시 테이블 스플래팅 : https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/group-object?view=powershell-7#example-6--group-objects-in-a-hash-table
            $linkPath= @{ Path = "$($_.LinkFolder)\$($_.Target)" }
            $isExist = Test-Path @linkPath -PathType $($_.PathType)
            $typeString = $(IIF ($_.PathType -eq "Container") "폴더가" "파일이")
            if ($isExist) { Write-Verbose " '$($linkPath.Path)' $($typeString) '$($_.LinkFolder)'에 이미 존재함." } 
            # windows에서 Symbolic link 설정 : https://winaero.com/create-symbolic-link-windows-10-powershell/
            else { 
                New-Item -ItemType SymbolicLink @linkPath -Target "$($_.Target)" 
                Write-Verbose " $($linkPath.Path)에 '$($_.Target)' 링크 생성 "
            }
        }
    }
    END {}
}

MakeSymLinks -Verbose