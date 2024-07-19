import Foundation

// MARK: - CoinDetailsModel
struct CoinDetailsModel: Codable {
    let id, symbol, name, webSlug: String?
    let assetPlatformID: String? // Change NSNull? to String?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let categories: [String]?
    let previewListing: Bool?
    let description: Description?
    let links: Links?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name
        case webSlug = "slug"
        case assetPlatformID = "asset_platform_id"
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hashing_algorithm"
        case categories
        case previewListing = "public_notice"
        case description, links
    }
    
    var readableDescription: String {
        return description?.en?.removingHTMLOccurances ?? ""
    }
}

// MARK: - Description
struct Description: Codable {
    let en: String?
    
    enum CodingKeys: String, CodingKey {
        case en = "en"
    }
}

// MARK: - Links
struct Links: Codable {
    let homepage: [String]?
    let whitepaper: String?
    let subredditURL: String?
    let blockchainSite, officialForumURL: [String]?
    
    enum CodingKeys: String, CodingKey {
        case homepage, whitepaper
        case blockchainSite = "blockchain_site"
        case officialForumURL = "official_forum_url"
        case subredditURL = "subreddit_url"
    }
}
