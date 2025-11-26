import Foundation
import SwiftUI
import WebKit

class OtherClass {
    var cvxuoztq: String?
    static let shared = OtherClass()
    var zzrqhr: String?
    var vdhhf: String?
}
struct LoadPres: View {
    @ObservedObject var tvbabssffav: ViewModelWolf = ViewModelWolf()
    @State var tdzgjikvnzfucc: Bool = true
    var body: some View {
        ZStack{
            Image(.mainBg).resizable()
                .edgesIgnoringSafeArea(.all)
            
            if let url = URL(string: OtherClass.shared.vdhhf ?? "") {
                WoloadtLoadind(jfbbzp: $tdzgjikvnzfucc) {
                    StrucJokeV(url: url, zcjuz: tvbabssffav)
                        .background(Color.black.ignoresSafeArea())
                        .edgesIgnoringSafeArea(.bottom)
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0){
                                tdzgjikvnzfucc = false
                            }
                        }
                }
            } else {
                ZStack{
                    WoloadtLoadind(jfbbzp: $tdzgjikvnzfucc) {
                        StrucJokeV(url:  URL(string: tvbabssffav.qyrfwcuvjkt)!, zcjuz: tvbabssffav) .background(Color.black.ignoresSafeArea()).edgesIgnoringSafeArea(.bottom).onAppear{
                        }
                    }
                }.onAppear{
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4.0){
                        tdzgjikvnzfucc = false
                    }
                }
            }
        }
    }
}
