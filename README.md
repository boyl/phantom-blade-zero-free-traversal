# Charm-Free Traversal — 免符穿行

版本：0.1.2-preview。独立 UE4SS 运行时 Mod，通过原生地图向已解锁铃铛穿行时无需消耗穿行符。零符查询会在地图作用范围内放行，不增加真实库存，不覆盖 Map.js。保留原生剧情、战斗、目的地和附近铃铛检查。

## 前置与安装
先安装 [UE4SS for Phantom Blade Zero](https://www.nexusmods.com/phantombladezero/mods/5)，遵循该页面适配当前游戏版本的安装说明。本包不包含框架。

1. 完全退出游戏，在 Steam 中浏览本地文件。
2. 将包内 PBZFreeTraversal 文件夹复制到 `platform/steam/ue4ss/Mods/`。
3. 在 `Mods/mods.txt` 增加 `PBZFreeTraversal : 1`。若使用 mods.json，同名项目的 mod_enabled 设为 true。
4. 启动游戏，正常打开地图选择已解锁铃铛。

入口：`platform/steam/ue4ss/Mods/PBZFreeTraversal/Scripts/main.lua`。游戏程序为 `platform/steam/PBZ.exe`，共享框架加载器位于同目录。

## 升级与卸载
退出游戏后覆盖本 Mod 文件夹即可升级。停用时将配置改为 0 / false，重启生效；卸载时移除 PBZFreeTraversal 文件夹。保留共享 UE4SS 和其他 Mod。

## 语言与兼容
新增确认文案自动跟随游戏文本语言：中文显示“确认穿行？本次穿行不消耗穿行符。”；英文及其他语言回退显示“Travel now? No traversal charm will be consumed.”。每次打开确认框重新读取语言。

已在 Steam build 26367565 验证有符穿行不扣符；新版免费确认和零消耗回调已有运行日志。零库存分支通过代码与模拟验证，真实零库存未单独实测。地图指引同时启用。其他修改相同接口的 Mod 及未来游戏版本未保证兼容。日志出现 DISABLED 或 INCOMPATIBLE 时补丁已停用，可能恢复原生消耗。

## English
Standalone UE4SS runtime mod for charm-free travel to unlocked bells. No Map.js replacement. Vanilla story and state restrictions remain. Custom confirmation text follows the game text language: Chinese for zh locales, English for other languages. Native buttons follow the game language.

Requires the game-specific UE4SS linked above. Exit the game, copy PBZFreeTraversal into platform/steam/ue4ss/Mods, and add PBZFreeTraversal : 1 to mods.txt. Disable with 0 and restart; remove only this mod folder to uninstall. Zero-charm logic is covered by code review and simulation, but a real empty-inventory scenario has not been tested.

## License
MIT，Copyright (c) 2026 boyl。见 LICENSE。独立编写，不包含游戏脚本或第三方传送 Mod 代码。

