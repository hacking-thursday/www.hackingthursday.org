


# 場地推薦


## [*<https://docs.google.com/forms/d/1FIQnkinwyJRVt6z0XJcAPF2S2Q_bjNFiMQdhWI6FHiw/viewform>   我要推薦]


[[html]]
<iframe src='<https://docs.google.com/spreadsheet/pub?key=0AqrEIr_g6NT4dGVlVzZoWjRtM1I4MDFqNWFXa2xDT0E&'>   width=675 height=400></iframe>
[[/html]]

# 常用的搜尋工具


無線上網店家搜尋
<http://www.qon.com.tw/hotsearch/>  

重要參考
<<http://oranges.idv.tw/2006/01/02/56.html>  >  
<http://tw.myblog.yahoo.com/jw>  !OopPO1aeHwIf_epHzpgO89vv/article?mid=514
<http://zh.restaurants.wikia.com/wiki/>  台北無線上網餐廳列表

餐廳尋找網站
<http://www.wakema.com.tw/>  
<http://www.coupon.com.tw/>  

[*<http://www.ipeen.com.tw/focus/739-%E9%96%B1%E8%AE%80%E3%80%82%E5%92%96%E5%95%A1%E9%A4%A8-%E6%96%87%E8%97%9D%E9%9D%92%E5%B9%B4%E7%9A%84%E7%A7%98%E5%AF%86%E5%9F%BA%E5%9C%B0>   閱讀。咖啡館　文藝青年的秘密基地－iPeen 愛評網－精選特輯]

# 大家各自在那裡?


Tsung 作的查經緯工具頁
<http://map.longwin.com.tw/addr_geo.php>  
Tsung 作的地圖路徑工具
<http://map.longwin.com.tw/direct.php>  

|| id || 經緯度 || 鄰近起點 ||交通方式 ||備註 ||
|| chihchun || 25.020984,121.527007 || 捷運台電大樓站 || 捷運 ||  ||
|| yurenju || 25.124616,121.46699 ||   ||   ||  ||
|| tsung || 25.040697558117174, 121.57540440559387 ||  ||  ||  ||
|| hychen || 25.064748, 121.581223 ||  ||  ||  ||
|| clyde_wu || 25.007798003006787, 121.52106285095215 ||  ||  ||  ||
|| kanru || 25.026328, 121.42396 ||  ||  ||  ||
|| Mat || 25.026328, 121.42396 || 捷運永安市場站 || 坐捷運 ||  ||
|| shengpo || 25.01346897994431, 121.54161393642426 || || || ||
|| $4 || 25.057625770025943, 121.61443054676056 || || || ||
|| yan || 25.22723, 121.451337 || 捷運淡水站+30分鐘 || 捷運+公車 || ||
|| Ducati || 25.043479, 121.615326 || || || ||
|| AceLan || 25.033630620436906, 121.56294822692871 || 市政府/國父紀念館捷運 || 機車 || ||


## 統計表

上方每人經緯度，對本頁所有咖啡店以 Google Maps [GDirections API](http://code.google.com/intl/zh-TW/apis/maps/documentation/reference.html#GDirections) 取行車路徑距離與時間。

[試算表於此](http://spreadsheets.google.com/pub?key=tkaLkCRhrAaFPWfQ6zWXB0A&gid=0)。


## 取得經緯度的方便方法

1. 先檢視網頁源始碼，將列表寫到 data.txt ，如:

    || id || 經緯度 || 鄰近起點 ||交通方式 ||備註 ||
    || chihchun || 25.020984,121.527007 || cell-content || cell-content || cell-content ||
    || yurenju || 25.124616,121.46699 || cell-content || cell-content || cell-content ||
    || tsung || 25.040697558117174, 121.57540440559387 || cell-content || cell-content || cell-content ||
    || hychen || 25.064748, 121.581223 || cell-content || cell-content || cell-content ||
    || clyde_wu || 25.007798003006787, 121.52106285095215 || cell-content || cell-content || cell-content ||
    || kanru || 25.026328, 121.42396 || cell-content || cell-content || cell-content ||
    || Mat || 25.026328, 121.42396 || 捷運永安市場站 || 坐捷運 ||  ||


2. 然後再執行 shell 指令

    cat data.txt | cut -d\| -f5


就可以拿到經緯度的欄位了


Mat: 我改了一個小小的 script ，可以用來抓這個 table 的資料，然後進一步處理 :-)
( 剛剛改好後，已經可以分別抓出名稱跟 x, y 兩個座標了 )
( 這支程式需要裝 **libxml2 for python** 還有 **htmltidy** 喔！！ )
<http://hackingthursday.wikidot.com/local--files/places/calc4.sh>  

執行結果如下:


    chihch  在      25.020984       121.527007
    yurenj  在      25.124616       121.46699
    tsung   在      25.040697558    121.57540440
    hychen  在      25.064748       121.581223
    clyde_  在      25.007798003    121.52106285
    kanru   在      25.026328       121.42396
    Mat     在      25.026328       121.42396
    shengp  在      25.013468979    121.54161393
    $4      在      25.057625770    121.61443054
    yan     在      25.22723        121.451337
    Ducati  在      25.043479       121.615326
    ====json data====
    [{"y": "121.527007", "x": "25.020984", "name": "chihchun"}, {"y": "121.46699", "x": "25.124616", "nam
    e": "yurenju"}, {"y": "121.57540440559387", "x": "25.040697558117174", "name": "tsung"}, {"y": "121.5
    81223", "x": "25.064748", "name": "hychen"}, {"y": "121.52106285095215", "x": "25.007798003006787", "
    name": "clyde_wu"}, {"y": "121.42396", "x": "25.026328", "name": "kanru"}, {"y": "121.42396", "x": "2
    5.026328", "name": "Mat"}, {"y": "121.54161393642426", "x": "25.01346897994431", "name": "shengpo"}, 
    {"y": "121.61443054676056", "x": "25.057625770025943", "name": "$4"}, {"y": "121.451337", "x": "25.22
    723", "name": "yan"}, {"y": "121.615326", "x": "25.043479", "name": "Ducati"}]


# git trac 建議的連結

<http://blog.xuite.net/cannonhu/jababa/3939744>  
<http://blog.udn.com/littlehand/2455625>  
<http://www.wretch.cc/blog/yellowbird54/8680505>  
<http://blog.yam.com/ddy1280/article/494092>  
http://oranges.idv.tw/2006/01/02/56.html
<http://mepopedia.com/?page=177>  