//
//  ProPlayerInfoViewController.swift
//  Dota2Stats
//
//  Created by Dinmukhammed Sagyntkan on 09.04.2022.
//

import UIKit

class PlayerDetailsViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var avatarImageView: UIImageView!
    
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerTeamLabel: UILabel!
    @IBOutlet var playerCountryFlagLabel: UILabel!
    
    @IBOutlet var winsAndLosesLabels: [UILabel]!
    @IBOutlet var rankLabels: [UILabel]!
    
    @IBOutlet var statsViews: [UIView]!
    @IBOutlet var topMainView: UIView!
    
    @IBOutlet var winsAndLosesSpinners: [UIActivityIndicatorView]!
    @IBOutlet var rankSpinners: [UIActivityIndicatorView]!
    
    //MARK: - Public Properties
    var player: Player!
    var playerAvatar: UIImage!
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topMainView.backgroundColor = UIColor(
            red: 0.56,
            green: 0.27,
            blue: 0.68,
            alpha: 1.00
        )
        
        setupAvatar()
        setupStatSquareViews()
        setupPlayerLabels()
        
        getPlayerDetails()
        getPlayerWinAndLoses()
        
        winsAndLosesSpinners.forEach { $0.hidesWhenStopped = true }
        rankSpinners.forEach { $0.hidesWhenStopped = true }
    }
}

//MARK: - UI Initial Settings
extension PlayerDetailsViewController {
    
    private func setupAvatar() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.layer.borderWidth = 4
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.image = playerAvatar
    }
    
    private func setupPlayerLabels() {
        playerNameLabel.text = player.personaname
        playerTeamLabel.text = player.team_name
        playerCountryFlagLabel.text = convertToEmoji(from: player.loccountrycode ?? "")
    }
    
    private func setupStatSquareViews() {
        statsViews.forEach { statView in
            statView.layer.shadowOffset = CGSize(width: 10, height: 10)
            statView.layer.shadowRadius = 5
            statView.layer.shadowOpacity = 0.3
            statView.layer.cornerRadius = 20
            
            statView.backgroundColor = UIColor(
                red: 0.61,
                green: 0.35,
                blue: 0.71,
                alpha: 1.00
            )
        }
    }
    
    private func convertToEmoji(from country: String) -> String {
        let baseIndex : UInt32 = 127397
        var emojiString = ""
        for scalar in country.uppercased().unicodeScalars {
            emojiString
                .unicodeScalars
                .append(UnicodeScalar(baseIndex + scalar.value)!)
        }
        return emojiString
    }
}

//MARK: - Networking
extension PlayerDetailsViewController {
    
    private func getPlayerDetails() {
        rankSpinners.forEach { $0.startAnimating() }
        NetworkManager
            .shared
            .fetchPlayerDetails(with: player.account_id) { playerInfo in
                DispatchQueue.main.async {
                    self.rankLabels.forEach { label in
                        switch label.tag {
                        case 0:
                            if let soloRank = playerInfo.solo_competitive_rank {
                                label.text = "\(String(soloRank)) MMR"
                            } else {
                                label.text = "No info"
                            }
                        default:
                            if let leaderboardRank = playerInfo.leaderboard_rank {
                                label.text = "Top \(String(leaderboardRank))"
                            } else {
                                label.text = "No info"
                            }
                        }
                    }
                    self.rankSpinners.forEach { $0.stopAnimating() }
                }
            }
    }
    
    private func getPlayerWinAndLoses() {
        winsAndLosesSpinners.forEach { $0.startAnimating() }
        NetworkManager
            .shared
            .fetchPlayerWinAndLoses(with: player.account_id) { playerWinAndLoses in
                DispatchQueue.main.async {
                    self.winsAndLosesLabels.forEach { label in
                        switch label.tag {
                        case 0:
                            if let wins = playerWinAndLoses.win {
                                label.text = String(wins)
                            } else {
                                label.text = "No info"
                            }
                        default:
                            if let loses = playerWinAndLoses.lose {
                                label.text = String(loses)
                            } else {
                                label.text = "No info"
                            }
                        }
                    }
                    self.winsAndLosesSpinners.forEach { $0.stopAnimating() }
                }
            }
    }
}
