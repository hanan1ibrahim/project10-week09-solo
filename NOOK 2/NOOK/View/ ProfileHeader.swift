//
//   ProfileHeader.swift
//  NOOK
//
//  Created by HANAN on 24/04/1443 AH.
//

import UIKit


protocol ProfileHeaderDelegate : class {
    func handleDismissal()
    func handleEditProfileFollow(_ header: ProfileHeader )
}

class  ProfileHeader: UICollectionReusableView {
    
 
    
    //properties
    
    var user : User? {
        didSet { configure()}
        
    }
    weak var delegate: ProfileHeaderDelegate?
    private let  filterBar = ProfileFilterView ()
    
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .NookBlue
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 42, paddingLeft: 16)
        backButton.setDimensions(width: 30, height: 30)
        
        return view
    }()
    
    private lazy var backButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "back")!.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        return iv
    }()
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.NookBlue.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.NookBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    }()
    
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
 
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray

        return label
    }()
    
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.text = " 🙋🏼‍♀️"
        return label
    }()
    
    private let underlineView : UIView = {
        let view = UIView()
        view.backgroundColor = .NookBlue
        return view
        
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.text = " 1Following "
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        label.text = " 2 Followers "
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)
        
        return label
    }()
    
   
    
    
    
    
    //lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        filterBar.delegate = self
        
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor,  height: 108)
        
        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor, left: leftAnchor,
        paddingTop: -24, paddingLeft: 118)
        profileImageView.setDimensions(width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: containerView.bottomAnchor,
                                       right: rightAnchor, paddingTop: 12,
                                       paddingRight: 12)
        
        editProfileFollowButton.setDimensions(width: 100, height: 36)
        editProfileFollowButton.layer.cornerRadius = 36 / 2
        
        let userDetailsStack = UIStackView(arrangedSubviews: [fullnameLabel,
                                                              usernameLabel,
                                                              bioLabel])
        userDetailsStack.axis = .vertical
        userDetailsStack.distribution = .fillProportionally
        userDetailsStack.spacing = 4
        
        addSubview(userDetailsStack)
        userDetailsStack.anchor(top: profileImageView.bottomAnchor, left: leftAnchor,
                                right: rightAnchor, paddingTop: 8, paddingLeft: 12,
                                paddingRight: 12)
        let followStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        followStack.axis = .horizontal
        followStack.spacing = 8
        followStack.distribution = .fillEqually
        
        addSubview(followStack)
        followStack.anchor(top: userDetailsStack.bottomAnchor, left: leftAnchor,
                           paddingTop: 8, paddingLeft: 12)
        
        addSubview(filterBar)
        filterBar.anchor( left: leftAnchor, bottom: bottomAnchor,right: rightAnchor, height: 50)
        
        addSubview(underlineView)
        underlineView.anchor( left: leftAnchor, bottom: bottomAnchor,width: frame.width / 3, height: 2)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // selector
    
    @objc func handleDismissal() {
        
        delegate?.handleDismissal()
    }
    @objc func handleEditProfileFollow() {
        delegate?.handleEditProfileFollow(self)
    }
    
    @objc func handleFollowingTapped() {
        
    }
    
    @objc func handleFollowersTapped() {
        
        
    }
//helpers
    
    func configure() {
        guard let user = user else { return }
                
        let viewModel = ProfileHeaderViewModel(user: user)
        
        profileImageView.sd_setImage(with: user.profileImageUrl)
        editProfileFollowButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        followingLabel.attributedText = viewModel.followingString
        followersLabel.attributedText = viewModel.followersString
        
        fullnameLabel.text = user.fullname
        usernameLabel.text = viewModel.usernameText
        
    }
}

extension ProfileHeader: ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {
        guard let cell = view.collectionView.cellForItem(at: indexPath)as? ProfileFilterCell else { return }
       
        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
    }
}

