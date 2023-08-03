//
//  ViewController.swift
//  Chuck Norris Joke
//
//  Created by macbook on 31.07.2023.
//

import UIKit
import SnapKit
import Alamofire

class ViewController: UIViewController {
    
    var jokeView = UIView()
    var joke = UILabel()
    var getJokeButton = UIButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() { // метод вызова других методов setup<Views>
        setupViewUI()
        
        setupLabelUI()
        setupButtonsUI()
        
        
        
        setupViewsSubviews()
        setupViewsConstrains()
        setupViewsActions()
    }

    private func setupViewUI() {view.backgroundColor = .white}
    private func setupLabelUI() {
        joke.font = UIFont.systemFont(ofSize: 20)
        joke.textAlignment = .center
        joke.center = view.center
        joke.textColor = .black
        joke.numberOfLines = 10
    }
    private func setupButtonsUI() {
        getJokeButton.setTitle("get joke", for: .normal)
        getJokeButton.setTitleColor(.darkText, for: .normal)
        getJokeButton.backgroundColor = .purple
    }
    private func setupViewsSubviews() {
        view.addSubview(getJokeButton)
        view.addSubview(jokeView)
        jokeView.addSubview(joke)
    }
    private func setupViewsConstrains() {
        getJokeButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalTo(120)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        jokeView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(360)
            make.width.equalToSuperview()
        }
        joke.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalToSuperview()
        }
        jokeView.layer.borderColor = UIColor.black.cgColor
        jokeView.layer.borderWidth = 1
    }
    private func setupViewsActions() {
        getJokeButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
}

extension ViewController {
    
    @objc func buttonPressed() {
        let url = "https://api.chucknorris.io/jokes/random"
        
        AF.request(url).responseDecodable(of: ChuckNorrisJoke.self, decoder: JSONDecoder()) { response in
            switch response.result {
            case .success(let jokeValue):
                self.joke.text = jokeValue.value
            case .failure(let error):
                print("Ошибка: \(error)")
            }
        }
    }
    
}
