//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Pradeep on 10/05/20.
//  Copyright © 2020 Pradeep. All rights reserved.
//

import SwiftUI

final class User: ObservableObject, Codable {
    @Published var firstName = "Pradeep sagar"
    
    enum CodingKeys: CodingKey {
        case firstName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        firstName = try container.decode(String.self, forKey: .firstName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(firstName, forKey: .firstName)
    }
}

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}
/*
struct ContentView: View {
     
    @State private var results = [Result]()
    
    var body: some View {
        
        List(results, id: \.trackId) { item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
        }
    .onAppear(perform: loadData)
    }
    
    func loadData() {

        guard let url = URL(string: "https://itunes.apple.com/search?term=taylor+swift&entity=song") else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data{
                
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data){
                    
                    DispatchQueue.main.async {
                        self.results = decodedResponse.results
                    }
                    
                    return
                }
            }
            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }
    .resume()
    }
}
*/

struct ContentView: View {
    @ObservedObject var order = Order()
   
    var body: some View {
        
        NavigationView{
            Form{
                Section{
                    Picker("Select your cake type", selection: $order.type){
                        ForEach(0..<Order.types.count){
                            Text(Order.types[$0])
                        }
                    }
                    Stepper(value: $order.quantity, in: 3...20){
                        Text("Number of cakes: \(order.quantity)")
                    }
                }
                Section{
                    Toggle(isOn: $order.specialRequestEnabled.animation()){
                        Text("Any Special Request?")
                    }
                    if order.specialRequestEnabled{
                        Toggle(isOn: $order.extraFrosting){
                            Text("Add extra Frosting")
                        }
                        Toggle(isOn: $order.addSprinkles){
                            Text("Add extra Sprinkles")
                        }
                    }
                }
                Section{
                    NavigationLink(destination: AddressView(order: order)){
                        Text("Delivery details")
                    }
                }
            }
            .navigationBarTitle("Cupcake Corner", displayMode: .large)
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
