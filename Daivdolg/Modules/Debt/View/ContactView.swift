//
//  ContactView.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 27/04/2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import UIKit
import SnapKit

protocol ContactViewConfiguration {
  var image: UIImage? { get set }
  var title: String? { get set }
  var subtitle: String? { get set }
}

class ContactView: UIView, ContactViewConfiguration {
  
  var onDidSelect: VoidClosure? 
  
  // MARK: - Properties
  private let containerView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.mainGreen
    view.layer.cornerRadius = 7
    return view
  }()
  
  private var imageView = UIImageView()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.body
    label.textColor = UIColor.white
    label.textAlignment = .left
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.subtitleBody
    label.textColor = UIColor.yellow
    label.textAlignment = .left
    label.numberOfLines = 0
    return label
  }()
  
  var image: UIImage? {
    didSet {
      imageView.image = image
    }
  }
  
  var title: String? {
    didSet {
      titleLabel.text = title
    }
  }
  
  var subtitle: String? {
    didSet {
      subtitleLabel.text = subtitle
    }
  }
  
  private let selectButton = UIButton()
  
  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configure()
  }
  
  // MARK: - Configure
  private func configure() {
    configureContainerView()
    configureImageView()
    configureTitleLabel()
    configureSubtitleLabel()
    configureSelectButton()
  }
  
  private func configureContainerView() {
    addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.bottom.equalToSuperview()
    }
  }
  
  private func configureImageView() {
    containerView.addSubview(imageView)
    imageView.snp.makeConstraints { make in
      make.width.height.equalTo(40)
      make.top.equalToSuperview().offset(8)
      make.leading.equalToSuperview().offset(8)
    }
  }
  
  private func configureTitleLabel() {
    containerView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(8)
      make.leading.equalTo(imageView.snp.trailing).offset(16)
      make.trailing.equalToSuperview().inset(16)
    }
  }
  
  private func configureSubtitleLabel() {
    containerView.addSubview(subtitleLabel)
    subtitleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(8)
      make.leading.equalTo(imageView.snp.trailing).offset(16)
      make.trailing.equalToSuperview().inset(16)
      make.bottom.equalToSuperview().inset(8)
    }
    subtitleLabel.sizeToFit()
  }
  
  private func configureSelectButton() {
    containerView.addSubview(selectButton)
    selectButton.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    selectButton.addTarget(self, action: #selector(onDidTapSelectButton(_:)), for: .touchUpInside)
  }
  
  // MARK: - Actions
  @objc private func onDidTapSelectButton(_ sender: UIButton) {
    onDidSelect?()
  }
}
