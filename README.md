# quiz2022
A quiz for new members learning Swift in MMSLAB

## 驗收項目
- 能夠依據給出的response格式串接API資料
- 熟悉地圖、表格視圖、集合視圖、圖片等元件以及本地資料庫和各類操作手勢
- 理解如何在不同的頁面之間傳遞資料

## API 網址
- Http Get
- https://android-quiz-29a4c.web.app/


## 最低支援 iOS 版本
- iOS 13.0

## 功能要求 – 主頁面
- 一開啟 app 就會跳出地圖權限請求
- 接到 API 資料後在地圖上依照座標插上大頭針
- 點擊右上角的刷新按鈕後將地圖視角移動到用戶當前位置
- 標題字體大小為20，字體選用 Medium，色碼：#468EE6
- Navigation bar 色碼：# F7F7F7 (白色)

![image](https://user-images.githubusercontent.com/62243142/156123938-72b5bcc4-f8b3-4bae-b8e8-b2389c81286f.png)
![image](https://user-images.githubusercontent.com/62243142/156123975-f0491617-7c92-4d81-9c66-5c12bfc6b72b.png)

- 左上方的搜尋欄輸入文字後，點擊右方搜尋按鈕或是鍵盤上的搜尋皆會跳出搜尋結果，若沒有結果則以 toast 顯示 ”查無結果”
- 點擊搜尋結果視圖後，儲存選取的景點至搜尋紀錄並移動地圖視角至對應景點
- 點擊搜尋紀錄按鈕會跳出視圖顯示曾經搜尋過的景點，若沒有紀錄則以 toast 顯示 “無歷史紀錄”
- 搜尋紀錄頁面點擊清除紀錄後返回主頁面並以 toast 顯示 “已清除紀錄”

[Demo gif](https://imgur.com/7yORUFY)

![image](https://user-images.githubusercontent.com/62243142/156124127-04858cb9-1635-4843-b649-5efd94d34cb3.png)

## 景點資料
- 點擊地圖上的大頭針跳出對應景點資料的視圖
- 點擊旅店導航跳轉至內建地圖規劃路徑
- 點擊旅店資訊前往詳細資訊頁面
- 在本頁面使用下滑手勢或是點擊景點名稱可以取消頁面顯示
- 綠底的視圖和橘底的按鈕都要修圓角，半徑自訂即可
- 色碼：# 55CFAD (綠色)；# FFD580 (橘色)

![image](https://user-images.githubusercontent.com/62243142/156125423-447fa866-b8f2-4742-a53f-4b8f22969083.png)
![image](https://user-images.githubusercontent.com/62243142/156125437-a26830d1-b8aa-49c2-8245-fc1588145079.png)

## 詳細資訊
- 景點評級按照不同的星數顯示對應星星
- 點擊景觀圖後跳轉至新頁面看全圖
- 全圖頁面標題為<當前圖是第幾張> / <景觀圖總數>
- 全圖頁面可以左右滑動切換圖片觀看，切換圖片後標題也會隨之改變
- 色碼：# ECC733 (黃色)

![image](https://user-images.githubusercontent.com/62243142/156125615-d66c15ed-c460-42ef-a2aa-ceec9c4f23d0.png)
![image](https://user-images.githubusercontent.com/62243142/156125635-b03b691c-9b1a-48e5-abcd-66c63cc22cd9.png)






