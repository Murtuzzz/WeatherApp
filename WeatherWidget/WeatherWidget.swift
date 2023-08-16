//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by Мурат Кудухов on 06.08.2023.
//

import WidgetKit
import SwiftUI
import Intents

//предоставляет таймлайн из слепков для виджета;
struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(),cityName: "Moscow", cityTemp: "24˚", weatherImage: UIImage(systemName: "sun.max")!)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let cityName = "Moscow"
        let cityTemp = "24˚"
        let weatherImage = UIImage(systemName: "sun.max")!
        let entry = SimpleEntry(date: Date(), configuration: configuration,cityName: cityName, cityTemp: cityTemp, weatherImage: weatherImage)
        
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let cityName = UserDefaults(suiteName: "group.com.MK.WeatherApp")?.string(forKey: "cityName") ?? "No data"
            let cityTemp = UserDefaults(suiteName: "group.com.MK.WeatherApp")?.string(forKey: "cityTemp") ?? "No data"
            let weatherImage = (UserDefaults(suiteName: "group.com.MK.WeatherApp")?.data(forKey: "weatherImage"))!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, cityName: cityName, cityTemp: cityTemp, weatherImage: UIImage(data: weatherImage)!)
            WidgetCenter.shared.reloadTimelines(ofKind: "com.yourapp.examplewidget")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

//слепок, который содержит данные для отображения их на виджете;
struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let cityName: String
    let cityTemp: String
    let weatherImage: UIImage
    
}

//View для виджета, тут определяется как будет выглядеть виджет;
struct WeatherWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Spacer()
        Spacer()
        Text(entry.cityName)
            .font(Font.system(size: 16, weight: .medium))
        Text(entry.cityTemp)
            .bold()
            .font(.title)
        Spacer()
        Image(uiImage: entry.weatherImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
        Spacer()
        Spacer()
       
    }
}

//наследник Widget, это непосредственно и есть наш виджет.
struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium, .systemSmall])
    }
}

struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), cityName: "Loading", cityTemp: "Loading", weatherImage: UIImage(systemName: "sun.max")!))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
