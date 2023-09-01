//
//  WeatherDetailsViewModel.swift
//  Weather
//
//  Created by Fredy Lopez on 28/08/23.
//

import Foundation
import Combine

enum WeatherForCastType: String {
    case hourly = "hourly"
    case daily = "daily"
}

enum ViewState {
    case loading
    case loaded
    case error
}

protocol WeatherDetailsViewModelType {
    var dailyItemCount:Int{ get }
    var hourlyItemCount:Int{ get }
    var filterOptions:[WeatherForCastType] { get }
    func getWeather(_ location:String?)
    func getDailyForcast(for index:Int)-> DailyForCastDetails?
    func getHourlyForcast()-> [HourlyForCastDetails]
    func getCurrentWeatherDetails()-> WeatherDetails?
}

class WeatherDetailsViewModel: ObservableObject, WeatherDetailsViewModelType {
    
    @Published var weatherForcastType: WeatherForCastType = .hourly
    
    var currentWeatherForcast: WeatherForcast? {
        return weatherForcast
    }

    var filterOptions: [WeatherForCastType] {
        return [.hourly, .daily]
    }
    var dailyItemCount: Int {
        return weatherForcast?.daily?.count ?? 0
    }
    var hourlyItemCount: Int {
        return 1
    }
    
    
    // MARK: - private properties
    var weatherForcast: WeatherForcast?
    private var weatherResponse: WeatherResponse?
    
    @Published var viewState: ViewState = .loading

    
    private var repository:WeatherRepository
    var subscriptions: Set<AnyCancellable> = []

    init(repository:WeatherRepository = WeatherRepositoryImpl()) {
        self.repository = repository
    }
    
    func getWeather(_ location: String?) {
        guard  let location = location else {
            return
        }
        repository.search(location: location,modelType: WeatherResponse.self).map({ weatherResponse -> WeatherResponse in
            self.weatherResponse = weatherResponse
            return weatherResponse
        })
            .flatMap {[unowned self] weatherResponse in
                self.repository.searchWeatherForcast(lat:"\( weatherResponse.coord.lat)", lon: "\( weatherResponse.coord.lon)", exclude:"", modelType:WeatherForcast.self)
        }
        .sink { [weak self] completion in
            switch completion {
            case .finished: break
            case .failure(_):
                self?.viewState = .error
            }
        }receiveValue: { [weak self] response in
            self?.weatherForcast = response
            self?.viewState = .loaded

        }
        .store(in: &subscriptions)
    }
    
    func getDailyForcast(for index: Int)-> DailyForCastDetails? {
        guard let dailyForCasts = weatherForcast?.daily,  index >= 0 , index < dailyForCasts.count else {
            return nil
        }
        let daily = dailyForCasts[index]
        
        let date = Date.getDate(milliSec:(daily.dt!), format: Constatns.dayDateFormat)
        
        return  DailyForCastDetails(date:date, tempHigh:String(format:"%0.2f\(Constatns.centigrade)",daily.temp.max.KelvinToDegreeCelcius()), tempLow: String(format:"%0.2f\(Constatns.centigrade)",daily.temp.min.KelvinToDegreeCelcius()))
    }
    
    func getHourlyForcast() -> [HourlyForCastDetails] {
        guard  let hourlyForCasts = weatherForcast?.hourly else {
            return []
        }
        return hourlyForCasts.map { HourlyForCastDetails(date: Date.getHr(milliSec:($0.dt!), format: Constatns.hourlyDateFormat), temp: String(format:"%0.2f\(Constatns.centigrade)",$0.temp.KelvinToDegreeCelcius()))}
    }
    
    func getCurrentWeatherDetails()-> WeatherDetails? {
       
        guard  let weatherResponse = weatherForcast?.current, let weather = weatherResponse.weather?.first else { return nil }
        
        return WeatherDetails(cityName:"",
                              type:weather.main,
                              descripton:weather.weatherDescription,
                              temprature: weatherResponse.temp,
                              pressure: weatherResponse.humidity,
                              humadity: weatherResponse.pressure
           )
    }
}
