
import Foundation

//전체적으론 API는 두개를 쓸 예정
//1. 날씨에 관한 API (openweather)
//2. 미세먼지 관한 API (airkorea)

//Constant
let weatherURL = "http://api.openweathermap.org/data/2.5/forecast"
let weatherAPIKey = "89e4a79cf2b99a9f6ac5d5654d83a51b"
let weatherFullURL = "http://api.openweathermap.org/data/2.5/forecast?q=Seoul&APPID=89e4a79cf2b99a9f6ac5d5654d83a51b"

let yesterdayWeatherURL = "http://api.openweathermap.org/data/2.5/history"
let yesterdayWeatherFullURL = "http://api.openweathermap.org/data/2.5/history?q=Seoul&APPID=89e4a79cf2b99a9f6ac5d5654d83a51b"

let dustURL = ""
let dustApiKey = ""
let dustFullURL = ""

