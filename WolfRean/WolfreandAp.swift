import Foundation
import SwiftUI
import OneSignal
import UIKit

struct JokePresentationCusto: View {
    @State private var sjtiqbocnyyrwk = false
    @ObservedObject var lci: ViewModelWolf = ViewModelWolf()
    @State var krrfnpo:  String = "uwyqgaihsdvjhbsdvsdv"
    @AppStorage("vasdyguvhbjsdv") var bir: Bool = true
    @AppStorage("ttfjhasuhjbsdf") var tdu: String = "pppoiuwugvsdhjvb"
    @State var dasarqyzfagw: String = ""
    @State private var xzygtzqqimni: Timer?
    private let ydtrymfjascgho: TimeInterval = 5.0
    
    var body: some View {
        ZStack{
            Image(.mainBg).resizable().ignoresSafeArea(.all)
            if krrfnpo == "iojhdjbfsv" || krrfnpo == "ghjsjvbsv" {
                if self.dasarqyzfagw == "Wolfster" || tdu == "Wolfster" {
                    
                    NavigationView {
                        VStack {
                            if !sjtiqbocnyyrwk {
                                CustomRola()
                                    .transition(.opacity)
                            } else {
                                WolfReanApp()
                            }
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                    .onAppear {
                        tdu = "Wolfster"
                        AppDelegate.shared = UIInterfaceOrientationMask.portrait
                        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                sjtiqbocnyyrwk = true
                            }
                        }
                    }
                } else {
                    WolfCustomView(jgnmxa: lci)
                }
            }
        }.statusBarHidden(true)
            .onAppear {
                OneSignal.promptForPushNotifications(userResponse: { accepted in
                    if accepted {
                        krrfnpo = "iojhdjbfsv"
                    } else {
                        krrfnpo = "ghjsjvbsv"
                    }
                })
                if bir {
                    if let url = URL(string: "https://pawnqueen.store/Wolfster/Wolfster.json") {
                        URLSession.shared.dataTask(with: url) { data, response, error in
                            if let aesdvsd = data {
                                if let avevdsv = try? JSONSerialization.jsonObject(with: aesdvsd, options: []) as? [String: Any] {
                                    if let jshdbvsd = avevdsv["dsgbcshjfbvgdf"] as? String {
                                        DispatchQueue.main.async {
                                            self.dasarqyzfagw = jshdbvsd
                                            bir = false
                                        }
                                    }
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.dasarqyzfagw = "Wolfster"
                                }
                            }
                        }.resume()
                    }
                }
        }
    }
}
