//
//  File.swift
//  
//
//  Created by 한상진 on 2022/11/26.
//

import UIKit
import Combine

import TogetherCore
import TogetherUI
import ThirdParty

import SwiftLayout
import ComposableArchitecture

public final class LoginViewController: UIViewController {
    
    private let store: StoreOf<Login>
    private let viewStore: ViewStoreOf<Login>
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let contentStackView: UIStackView = {
        let stackView: UIStackView = .init()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    private let iconView: UIView = {
        let view: UIView = .init()
        view.backgroundColor = .blue
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView: UIImageView = .init(image: .init(named: "투개더 아이콘"))
        imageView.backgroundColor = .cyan
        return imageView
    }()
    
    private let emailFieldView: TogetherInputFieldView = {
        let fieldView: TogetherInputFieldView = .init()
        fieldView.titleLabel.text = "이메일(아이디)"
        fieldView.inputTextField.placeholder = "예) example@togather.co.kr"
        return fieldView
    }()
    
    private let passwordFieldView: TogetherInputFieldView = {
        let fieldView: TogetherInputFieldView = .init()
        fieldView.titleLabel.text = "비밀번호"
        fieldView.inputTextField.placeholder = "0자리 ~ 00자리의 영어, 숫자 혹은 특수문자"
        return fieldView
    }()
    
    private let loginButton: UIButton = {
        let button: UIButton = .init(frame: .zero)
        button.setTitle("로그인", for: .init())
        button.setTitleColor(.black, for: .init())
        button.backgroundColor = .red
        return button
    }()
    
    private let findIDButton: UIButton = {
        let button: UIButton = .init(frame: .zero)
        button.setTitle("아이디 찾기", for: .init())
        button.setTitleColor(.black, for: .init())
        return button
    }()
    
    private let findPasswordButton: UIButton = {
        let button: UIButton = .init(frame: .zero)
        button.setTitle("비밀번호 찾기", for: .init())
        button.setTitleColor(.black, for: .init())
        return button
    }()
    
    @LayoutBuilder var layout: some Layout {
        view.sublayout {
            contentStackView.anchors { 
                Anchors.horizontal(offset: 24)
                Anchors.top.equalTo(view.safeAreaLayoutGuide)
            }
        }
        
        view.config { view in
            view.backgroundColor = .white
        }
        
        iconView
            .sublayout { 
                iconImageView.anchors { 
                    Anchors.center()
                    Anchors.size(width: 66.78, height: 48.76)
                }
            }.anchors {
                Anchors.height.equalTo(constant: 140)
            }
        
        loginButton.anchors { 
            Anchors.height.equalTo(constant: 54)
        }
        
        contentStackView.config { stackView in
            stackView.addArrangedSubview(iconView)
            stackView.addArrangedSubview(emailFieldView)
            stackView.setCustomSpacing(24, after: emailFieldView)
            stackView.addArrangedSubview(passwordFieldView)
            stackView.setCustomSpacing(24, after: passwordFieldView)
            stackView.addArrangedSubview(loginButton)
        }
    }
    
    public init(store: StoreOf<Login>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
        layout.finalActive()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        bindState()
        bindAction()
    }
    
    private func bindState() {
        store
            .scope(state: \.optionalOnboarding, action: Login.Action.optionalOnboarding)
            .ifLet(
                then: { store in
                    UIApplication.shared.appKeyWindow?.rootViewController = OnboardingViewController(store: store)
                }
            )
            .store(in: &cancellables)
        
        store
            .scope(state: \.optionalTab, action: Login.Action.optionalTab)
            .ifLet(
                then: { store in
                    UIApplication.shared.appKeyWindow?.rootViewController = TabViewController(store: store)
                }
            )
            .store(in: &cancellables)
    }
    
    private func bindAction() {
        emailFieldView.inputTextField
            .textPublisher
            .sink { emailText in
                print(emailText)
            }
            .store(in: &cancellables)
        
        passwordFieldView.inputTextField
            .textPublisher
            .sink { passwordText in
                print(passwordText)
            }
            .store(in: &cancellables)
        
        loginButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                self?.viewStore.send(.loginButtonDidTapped)        
            }
            .store(in: &cancellables)
    }
}
