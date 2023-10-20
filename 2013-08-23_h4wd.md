# H4 無線投影 (Wireless Display)

[source](http://hackingthursday.wikidot.com/h4wd)

## 需求要件

假設:
- 聚會環境固定有 Wi-Fi 無線上網基地台
- 固定有 LED 投影機，支援 VGA/HDMI 投影

希望能達成:
- 投影的人，不需要接線，僅需連 Wifi 即可無線投影
- 投影的人，能一邊投影，一邊正常上網
- 投影的人，作業系統為 Linux / OS X / Win 的人也能使用 ( 依順位列 )
- 投影的人，需要安裝的東西，跨平台、越少越好



## DIY 發想-1

用 VLC 來作 screencast

- 投影的人，先安裝 VLC 軟體
- 啟動 VLC 擷取筆電畫面的功能
- 告訴工作人員筆電的 LAN IP

然後:

- 在 server 端，會有工作人員先準備 VLC 跟 stream display 的 script ，並接好投影機
- 收到投影的人的 IP 後，執行 script
- 開始接收投影的人的 screencast 畫面，並透過投影機投影出來。

![](./files/illus01.png)


## 參考資料

### 關鍵字

* WIDI
* Wifi Display
* Miracast
* Wireless Display
* DLNA

### 市面上無線投影相關產品


* <http://shopping.pchome.com.tw/?mod=item&func=exhibit&IT_NO=DCAD57-A60320157>
* <http://www.amazon.com/Wireless-300Mbps-Adapter-Compatible-Projector/dp/B00DQ1QFUY>
* <http://www.benq.us/product/projector/wirelessdongle/>
* <http://accessories.us.dell.com/sna/productdetail.aspx?c=us&l=en&s=gen&sku=331-2359>
* <http://shopping.pchome.com.tw/DCAM0A-A73824237>
* (Amos) <http://m.buy.yahoo.com.tw/gdsale/gdinfo.asp?gdid=4287650&zno=3&subno=197&gdname=Netgear+PTV3000+%E7%84%A1%E7%B7%9AHD%E5%BD%B1%E9%9F%B3%E5%82%B3%E9%80%81+Miracast+WIDI>

### 相關連結

* <http://www.2cm.com.tw/technologyshow_content.asp?sn=1304260008>
* <http://en.wikipedia.org/wiki/Miracast>
* <http://www.mem.com.tw/article_content.asp?sn=1102100010>
* <http://www.digitimes.com.tw/tw/rpt/rpt_show.asp?cnlid=3&pro=y&proname=%A6%B8%A5%40%A5NWi-Fi%B5o%AEi%B0%CA%A6V&cat=BWC&v=20120814-465>


## 測試與討論串


### yan

```
$ ffmpeg -f x11grab -s 1280x800 -r 30 -i :0.0 -f alsa -i hw:0,0 -acodec flac -vcodec ffvhuff /tmp/test.mkv
```

- <http://www.organicdesign.co.nz/Simple_video_streaming_with_ffserver>
- <http://www.alkannoide.com/2013/07/04/play-with-ffserver-a-quick-overview/>
- <http://hpc.serc.iisc.ernet.in/~sree/code/ffmpeg/doc/ffserver.conf>
- <http://forrst.com/posts/Command_line_screen_capture_using_VLC-COl>
- <https://wiki.videolan.org/Documentation>  :Streaming_HowTo/Command_Line_Examples
- <http://blog.nostdal.org/2012/10/vlc-h264-desktop-and-audio-recording-or.html>

```
$ cvlc  screen:// --screen-fps=25 --screen-width=640 --screen-height=480  --screen-top=100 --screen-left=200 --screen-caching=100 --sout  '#transcode{venc=x264{bframes=0,nocabac,ref=1,nf,level=13,crf=24,partitions=none},vcodec=h264,fps=25,vb=3000,width=648,height=480,acodec=none}:duplicate{dst=std{mux=mp4,access=http,dst=192.168.24.139:8080}}'
```

```
$ cvlc  screen:// --screen-fps=10 --sout  '#transcode{venc=x264,vcodec=h264,fps=10,,vb=600,acodec=none}:std{access=http,mux=ts,dst=192.168.24.139:8080}'
```

```
$ cvlc  screen://--screen-fps=30  --sout  '#transcode{venc=x264,vcodec=mp4v,vb=4096,ab=256,scale=,1acodec=none}:std{access=http,mux=ts,dst=192.168.24.139:8080}'
```

to file

```
$ cvlc   screen:// --screen-fps=10 --input-slave=pulse:// --sout   "#transcode{venc=x264,vcodec=h264,fps=10,vb=600,acodec=mp3,channels=2,ab=128,audio-sync}:std{access=file,mux=mp4,dst=desktop-cap-$(date   -u +%Y-%m-%d-%s).mp4}"
```

### Mat

Windows 的 screen capture 的設定可以參考這一篇
- <http://wiki.vidblaster.com/index.php/Streaming_a_remote_desktop_into_VidBlaster>
- <http://stackoverflow.com/questions/16369745/stream-desktop-over-rtp-using-vlc-with-the-lowest-latency-possible>
- <http://foxdogstudios.com/peepers.html>
- <http://www.waitwut.info/blog/2013/06/07/desktop-streaming-with-vlc/>
- <http://www.waitwut.info/blog/2013/06/09/desktop-streaming-with-ffmpeg-for-lower-latency/>

keyword: rtsp-caching network-caching live-caching sout-mux-caching clock-jitter


### BT

vlc 串流會有約 5 秒的延遲
可以試著調整 buffer (server、client 都要)


### Rex

ScreenCasting 技術比較
<https://speakerdeck.com/chihchun/screencasting>