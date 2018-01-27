
import Foundation

//전체적으론 API는 두개를 쓸 예정
//1. 날씨에 관한 API (openweather)
//2. 미세먼지 관한 API (airkorea)

//Constant
//openWeather REST API
//파라미터  lon=   lat=    appid=
let weatherURL = "http://api.openweathermap.org/data/2.5/forecast"
let weatherAPIKey = "89e4a79cf2b99a9f6ac5d5654d83a51b"
let weatherFullURL = "http://api.openweathermap.org/data/2.5/forecast?q=Seoul&APPID=89e4a79cf2b99a9f6ac5d5654d83a51b"

let yesterdayWeatherURL = "http://api.openweathermap.org/data/2.5/history"
let yesterdayWeatherFullURL = "http://api.openweathermap.org/data/2.5/history?q=Seoul&APPID=89e4a79cf2b99a9f6ac5d5654d83a51b"

//AirKorea 미세먼지 REST API
//파라미터  addr=서울     stationName=종로구 pageNo=1    numOfRows=10    ServiceKey=XAWRkvW8j4qL4z5I7ZPkoWGlaXKMiHpNU97qNjk%2Bl%2BsfoNK72CEkLzuRO7WgnIOdFQYDivbQW9%2BH%2FfzXJKyNJA%3D%3D
let dustURL = "http://openapi.airkorea.or.kr/openapi/services/rest/MsrstnInfoInqireSvc/getMsrstnList"
let dustAPIKey = "XAWRkvW8j4qL4z5I7ZPkoWGlaXKMiHpNU97qNjk%2Bl%2BsfoNK72CEkLzuRO7WgnIOdFQYDivbQW9%2BH%2FfzXJKyNJA%3D%3D"
let dustFullURL = ""

//카카오 REST API사용
//파라미터  x=160710.37729270622    y=-4388.879299157299    input_coord=WTM     output_coord=WGS84
let kakaoURL = "https://dapi.kakao.com/v2/local/geo/transcoord.json"
let kakaoAPIKey = "709086004e1cdbed5393c28e4571cb95"




