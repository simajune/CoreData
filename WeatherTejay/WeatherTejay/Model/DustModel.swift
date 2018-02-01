//
//  DustModel.swift
//  WeatherTejay
//
//  Created by SIMA on 2018. 2. 1..
//  Copyright © 2018년 devtejay. All rights reserved.
//

import Foundation
struct DustModel {
    
    //var address: String?
    //측정일 2016-04-20 14:00 yyyy-MM-dd HH:mm
    var dataTime: Date?
    //측정망 정보 (국가배경, 교외대기, 도시대기, 도로변대기)
    var mangName: String?
    //아황산가스 농도 (단위 : ppm)
    var so2Value: String?
    //일산화탄소 농도 (단위 : ppm)
    var coValue: String?
    //오존 농도 (단위 : ppm)
    var o3Value: String?
    //이산화질소 농도 (단위 : ppm)
    var no2Value: String?
    //미세먼지(PM10) 농도 (단위 : ㎍/㎥)
    var pm10Value: String?
    //미세먼지(PM10) 24시간예측이동농도 (단위 : ㎍/㎥)
    var pm10Value24: String?
    //미세먼지(PM2.5)  농도 (단위 : ㎍/㎥)
    var pm25Value: String?
    //미세먼지(PM2.5) 24시간예측이동농도 (단위 : ㎍/㎥)
    var pm25Value24: String?
    //통합대기환경수치
    var khaiValue: String?
    //통합대기환경지수
    var khaiGrade: String?
    //아황산가스 지수
    var so2Grade: String?
    //일산화탄소 지수
    var coGrade: String?
    //오존 지수
    var o3Grade: String?
    //이산화질소 지수
    var no2Grade: String?
    //미세먼지(PM10) 24시간 등급자료
    var pm10Grade: String?
    //미세먼지(PM2.5) 24시간 등급자료
    var pm25Grade: String?
    //미세먼지(PM10) 1시간 등급
    var pm10Grade1h: String?
    //미세먼지(PM2.5) 1시간 등급
    var pm25Grade1h: String?
    
    init(dic: [String: Any]) {
        guard let
        
    }
}
