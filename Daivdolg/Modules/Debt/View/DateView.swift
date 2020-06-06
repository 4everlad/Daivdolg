//
//  DateView.swift
//  Daivdolg
//
//  Created by Dmitry Bakulin on 30/05/2020.
//  Copyright © 2020 Dmitry Bakulin. All rights reserved.
//

import Foundation

import UIKit
import SnapKit

protocol DateViewConfiguration {
  var title: String? { get set }
}

class DateView: UIView, DateViewConfiguration {
  
  var onDidSelect: VoidClosure? 
  
  // MARK: - Properties
  private let containerView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.white
    view.layer.cornerRadius = 7
    return view
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.body
    label.textColor = UIColor.mainGreen
    label.textAlignment = .left
    return label
  }()
  
  var title: String? {
    didSet {
      titleLabel.text = title
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
    configureTitleLabel()
    configureSelectButton()
  }
  
  private func configureContainerView() {
    addSubview(containerView)
    containerView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview()
      make.top.bottom.equalToSuperview()
    }
  }
  
  private func configureTitleLabel() {
    containerView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(8)
      make.trailing.equalToSuperview().inset(16)
    }
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
