//
//  Player.swift
//  Dota2Stats
//
//  Created by Dinmukhammed Sagyntkan on 08.04.2022.
//

import UIKit

struct ProPlayer: Decodable {
    let account_id: Int?
    let personaname: String
    let avatarfull: String
    let loccountrycode: String?
    let team_name: String?
    let proPlayerInfo: ProPlayerInfo?
}

struct ProPlayerInfo: Decodable {
    let solo_competitive_rank: Int
    let competitive_rank: Int
    let leaderboard_rank: Int
}