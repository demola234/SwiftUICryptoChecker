//
//  PreviewProvider.swift
//  Crypto App
//
//  Created by Ademola Kolawole on 14/07/2024.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}

class DeveloperPreview {
    static let instance = DeveloperPreview()
    private init() {
        
    }
    
    let homeVM = HomeViewModel()
    
    let coin = CoinModel(id: "bitcoin", symbol: "btc", name: "Bitcoin", image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1696501400", currentPrice: 60016, marketCap: 1183570984788.0, marketCapRank: 1, blockTimeInMinutes: 23394, fullyDilutedValuation: 1260376721725, totalVolume: 20468577159, high24H: 60373, low24H: 58338, priceChange24H: 1483.52, priceChangePercentage24H: 2.53451, marketCapChange24H: 32086612291, marketCapChangePercentage24H: 2.78654, circulatingSupply: 19720287, totalSupply: 21000000, maxSupply: 21000000, ath: 73738, athChangePercentage: -18.60643, athDate: "2024-07-14T00:00:00.000Z", atl: 67.81, atlChangePercentage: 88410.28496, atlDate: "2024-07-14T00:00:00.000Z", lastUpdated: "2024-07-14T00:00:00.000Z", sparklineIn7D: SparklineIn7D(
        price: [
        57614.244419987604,
                57698.3289289013,
                57477.74226329975,
                57660.391301077514,
                57729.20597341802,
                57485.89154547834,
                57414.5867866749,
                57309.967428440556,
                56741.41303442024,
                56848.64612147306,
                56809.69911110347,
                57108.63346902946,
                57238.73383879574,
                57057.44481551815,
                57093.86317750543,
                57296.96660345792,
                56809.94416008742,
                56389.651047822634,
                55665.50758753673,
                54694.86459884712,
                55213.38815490327,
                55396.519708519016,
                55025.22260368881,
                55785.061610609024,
                55354.01899007526,
                55578.32904619587,
                55870.11485741787,
                57830.63033797767,
                57543.02710593034,
                57098.05571310766,
                57174.52369637582,
                57113.30392938364,
                57174.761027458735,
                56147.667667750386,
                55900.07293813785,
                55788.06515828271,
                56262.0759371943,
                56269.95063365189,
                56422.52552168747,
                56189.472665363304,
                56575.6391876632,
                56629.642680243116,
                56656.077519140876,
                56652.670180661175,
                56537.89393298765,
                57046.177208635614,
                57249.33058293234,
                57350.80626484425,
                57203.67043538741,
                57445.96050089266,
                57035.29781246321,
                57569.56359723347,
                57609.835223134076,
                57365.17967731459,
                57430.07503978041,
                57314.81306241486,
                57299.48245282225,
                57046.93007318228,
                57498.42673511476,
                57735.56914114846,
                57482.99678227092,
                57747.37126323914,
                57853.374358103756,
                57881.227013618976,
                57805.457000784845,
                58104.584924006485,
                58024.67810475922,
                57433.663488226885,
                57794.01316908335,
                57862.37966313371,
                58416.74800356028,
                59322.44639497513,
                58959.98538431959,
                59224.95641433284,
                58934.74397520808,
                58726.68262157396,
                58525.43229642345,
                58637.352649726825,
                58471.76288258034,
                58243.61956733745,
                57741.71178853094,
                57727.28810615516,
                57890.025190256805,
                57693.63099937461,
                57727.36032267409,
                57606.155494774655,
                57424.563982140964,
                57360.11575688227,
                57500.295458246415,
                57641.731671041474,
                57602.44949167954,
                57533.162961846465,
                58119.41406016719,
                57860.78551998178,
                57589.06887441622,
                57768.44382293428,
                58076.91671631687,
                57989.5194491571,
                58297.18918785991,
                58256.651035990544,
                58217.333484961615,
                58436.02488593827,
                58765.42029888775,
                58840.32992799079,
                58604.825054720255,
                57774.331554442106,
                57329.457940100125,
                57668.66994067551,
                57912.59210688968,
                57822.78440051746,
                57421.80533459587,
                57574.581649158696,
                57478.910091199745,
                57326.79288021803,
                57338.42217109978,
                57216.44460565351,
                56936.17300287056,
                57192.455603272676,
                56936.720942246706,
                56965.33819815058,
                57038.86797735148,
                57209.35935761241,
                57115.19554576349,
                57260.47198887669,
                56930.13742657175,
                57182.36962822978,
                57072.07994343006,
                57372.5993447411,
                57774.712259476575,
                57978.398184404345,
                58208.3158678381,
                58039.52322800936,
                58094.47666252344,
                58310.980967776224,
                57724.6294394471,
                57564.47481376711,
                57601.242232101686,
                57741.78760598596,
                57876.37384720089,
                57818.993836784706,
                57875.27087694104,
                57965.91700566508,
                57834.463134063,
                57795.28976894547,
                58079.32469343483,
                58051.95310684931,
                58143.43107347114,
                58031.620969251846,
                58713.8547786192,
                58409.624456662576,
                58516.533287708495,
                58775.55485087848,
                58600.15872525685,
                58788.63907304515,
                58799.39040493895,
                58620.62628856922,
                58775.69500096371,
                58667.7987229473,
                58607.32407797006,
                58611.52229196427,
                58697.87243688947,
                59468.70435751196,
                59243.90724033287,
                59853.44861354578,
                59743.941788773656,
                59379.36393666037,
                59488.175182718296,
                60150.163597970684
    ]), currentHoldings: 1.5)
}
