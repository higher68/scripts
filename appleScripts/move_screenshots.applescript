-- alias取得
--set screenshotBasedir to (folder "Pictures" of (path to home folder))

set screenshotBaseDirPosix to POSIX path of (path to home folder) & "Pictures/" & "ScreenShots/"
set screenshotBaseDirHFS to POSIX file screenshotBaseDirPosix
set screenshotBaseDirAliasHFS to (alias (screenshotBaseDirHFS as string))

-- sub directory取得
tell application "Finder"
  set subDirs to (every folder of screenshotBaseDirAliasHFS)
end tell

repeat with subDir in subDirs
  -- get only image files
  tell application "Finder"
    set imageFiles to (every file of subDir whose name extension is in {"jpg", "png", "jpeg", "gif"})
  end tell
  -- image file ごとにループ
  repeat with imageFile in imageFiles
    -- メタデータをtext classで取得
    set creationDate to (creation date of imageFile)
    set {year:y, month:m, day:d} to creation date of imageFile
    -- https://discussions.apple.com/thread/253547282?sortBy=rank
    -- http://tonbi.jp/AppleScript/Dictionary/Basic/Value/date.html
    set day_str to text -1 thru -2 of ("00" & d)
    set mon_str to text -1 thru -2 of ("00" & (m * 1))
    set y_str to y as string
    -- 保存先directory取得
    -- make dir	http://applescript-guide.com/folder-management/
    tell application "Finder"
      -- yearのfolder作成
      set parentFolderName to subDir as string
      if not (exists folder (parentFolderName & y)) then
        make new folder at parentFolderName with properties {name:y_str}
        -- display dialog "[debug]フォルダを作成しました: " & parentFolderName & y
      else
        --display dialog "[debug]フォルダはすでにあります: " & parentFolderName & y
      end if
      -- monthのfolder作成(mm形式)
      -- NOTE 実在するfolderにしかofは使えない
      set parentFolderName2 to (folder y_str of subDir) as string
      if not (exists folder (parentFolderName2 & mon_str)) then
        make new folder at parentFolderName2 with properties {name:mon_str}
        -- display dialog "[debug]フォルダを作成しました: " & parentFolderName2 & mon_str
      else
        --display dialog "[debug]フォルダはすでにあります: " & parentFolderName2 & mon_str
      end if
      -- dayのfolder作成(dd形式)
      set parentFolderName3 to (folder mon_str of folder y_str of subDir) as string
      if not (exists folder (parentFolderName3 & day_str)) then
        make new folder at parentFolderName3 with properties {name:day_str}
        -- display dialog "[debug]フォルダを作成しました: " & parentFolderName3 & day_str
      else
        -- display dialog "[debug]フォルダはすでにあります: " & parentFolderName3 & day_str
      end if

      -- 画像ファイル移動
      set destinationPath to (folder day_str of folder mon_str of folder y_str of subDir) as string
      move imageFile to folder destinationPath
    end tell
  end repeat
end repeat

