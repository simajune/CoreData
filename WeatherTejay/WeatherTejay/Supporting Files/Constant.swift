
import Foundation
import Alamofire

//세팅화면에 접근하기 위한 URL
let url:URL = URL(string: "App-Prefs:root=")!

//전체적으론 API는 두개를 쓸 예정
//1. 날씨에 관한 API (openweather)
//2. 미세먼지 관한 API (airkorea)

//Constant
//openWeather REST API
//파라미터  lon=   lat=    appid=
let currentWeatherURL = "http://api.openweathermap.org/data/2.5/weather"

let weatherURL = "http://api.openweathermap.org/data/2.5/forecast"
let weatherAPIKey = "89e4a79cf2b99a9f6ac5d5654d83a51b"
let weatherFullURL = "http://api.openweathermap.org/data/2.5/forecast?q=Seoul&APPID=89e4a79cf2b99a9f6ac5d5654d83a51b"

let yesterdayWeatherURL = "http://api.openweathermap.org/data/2.5/history"
let yesterdayWeatherFullURL = "http://api.openweathermap.org/data/2.5/history?q=Seoul&APPID=89e4a79cf2b99a9f6ac5d5654d83a51b"

//AirKorea 미세먼지 REST API
var dustAPIKey = "euqSW5cVBaDnDWe3igb9/5IVzX7o6eZ+A+PAxQL2tMbeJQ9eTjvtSz2hhXSd3rHvr0UawJy5xQeTumALlgnL5Q=="
var originalAPIKey = "XAWRkvW8j4qL4z5I7ZPkoWGlaXKMiHpNU97qNjk+l+sfoNK72CEkLzuRO7WgnIOdFQYDivbQW9+H/fzXJKyNJA=="
//anotherAPIKey = "euqSW5cVBaDnDWe3igb9/5IVzX7o6eZ+A+PAxQL2tMbeJQ9eTjvtSz2hhXSd3rHvr0UawJy5xQeTumALlgnL5Q=="
//근처 측정소 위치
//파라미터  tmX, tmY, pageNo=1, numOfRows=10, _returnType=json, ServiceKey=XAWRkvW8j4qL4z5I7ZPkoWGlaXKMiHpNU97qNjk%2Bl%2BsfoNK72CEkLzuRO7WgnIOdFQYDivbQW9%2BH%2FfzXJKyNJA%3D%3D
let dustMeasuringStationURL = "http://openapi.airkorea.or.kr/openapi/services/rest/MsrstnInfoInqireSvc/getNearbyMsrstnList"
//측정소에 따른 데이터 값
//파라미터 stationName, dataTerm, pageNo=1 ,numOfRows=10, ServiceKey, ver=1.3, _returnType=json
let dustDataURL = "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getMsrstnAcctoRltmMesureDnsty"
//해당 날짜에 정보와 예측 정보
//파라미터 ["searchDate": currentdate, "ServiceKey": dustAPIKey, "_returnType": "json"]
let forecastDustURL = "http://openapi.airkorea.or.kr/openapi/services/rest/ArpltnInforInqireSvc/getMinuDustFrcstDspth"
//카카오 REST API사용
let kakaoHeaders: HTTPHeaders = ["Authorization": "KakaoAK 709086004e1cdbed5393c28e4571cb95"]
let kakaoAPIKey = "709086004e1cdbed5393c28e4571cb95"



//파라미터  x=160710.37729270622    y=-4388.879299157299    input_coord=WTM     output_coord=WGS84
let kakaoCoordinateURL = "https://dapi.kakao.com/v2/local/geo/transcoord.json"

//주소 검색을 통해 좌표 값 가져오기
let kakaoSearchAddressURL = "https://dapi.kakao.com/v2/local/search/address.json"

//좌표를 통해 행정구역 가져오기
//파라미터 z, y, input_coord=WTM     output_coord=WGS84
let kakaoGetAddressURL = "https://dapi.kakao.com/v2/local/geo/coord2regioncode.json"

/////////SK 날씨/////////////
var SKAppKey = "bb7d0c16-812c-4aba-b86e-9f0583eff4cc"
var SKAppKey1 = "ec755550-98f5-458b-860e-723732ad23fa"
var SKAppKey2 = "41fd39e9-7e07-47c8-a7a3-ef717ddc0ae3"

var SKWeatherHeader: HTTPHeaders = ["Accept": "application/json", "Content-Type": "application/json; charset=UTF-8", "appKey": "bb7d0c16-812c-4aba-b86e-9f0583eff4cc"]
var temp1SKWeatherHeader: HTTPHeaders = ["Accept": "application/json", "Content-Type": "application/json; charset=UTF-8", "appKey": "ec755550-98f5-458b-860e-723732ad23fa"]
var temp2SKWeatherHeader: HTTPHeaders = ["Accept": "application/json", "Content-Type": "application/json; charset=UTF-8", "appKey": "41fd39e9-7e07-47c8-a7a3-ef717ddc0ae3"]



let currentSKWeatherURL = "https://api2.sktelecom.com/weather/current/minutely"
let forecastSKWeatherURL = "https://api2.sktelecom.com/weather/forecast/3days"
let historySKWeatherURL = "https://api2.sktelecom.com/weather/yesterday"




