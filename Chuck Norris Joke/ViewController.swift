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
    var like = UIButton()
    var dislike = UIButton()
    
    var bestJokesView = UIView()
    var tableView = UITableView()
    private var bestJokesArray = Array<String>()
    var titleTableView = UILabel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() { // метод вызова других методов setup<Views>
        setupViewUI()
        
        setupLabelUI()
        setupButtonsUI()
        setupTableViewUI()
        
        
        
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
        
        titleTableView = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        titleTableView.text = "Liked jokes"
        titleTableView.textAlignment = .center
        titleTableView.backgroundColor = .lightGray
        
    }
    private func setupButtonsUI() {
        getJokeButton.setTitle("get joke", for: .normal)
        getJokeButton.setTitleColor(.white, for: .normal)
        getJokeButton.backgroundColor = .black
        
        like.setImage(UIImage(systemName: "hand.thumbsup",
                             withConfiguration: UIImage.SymbolConfiguration(scale: .medium)),
                      for: .normal)
        dislike.setImage(UIImage(systemName: "hand.thumbsdown",
                                 withConfiguration: UIImage.SymbolConfiguration(scale: .medium)),
                      for: .normal)
        like.setImage(UIImage(systemName: "hand.thumbsup.fill",
                             withConfiguration: UIImage.SymbolConfiguration(scale: .medium)),
                      for: .highlighted)
        dislike.setImage(UIImage(systemName: "hand.thumbsdown.fill",
                             withConfiguration: UIImage.SymbolConfiguration(scale: .medium)),
                      for: .highlighted)
    }
    private func setupViewsSubviews() {
        view.addSubview(getJokeButton)
        view.addSubview(jokeView)
        view.addSubview(bestJokesView)
        jokeView.addSubview(joke)
        jokeView.addSubview(like)
        jokeView.addSubview(dislike)
        bestJokesView.addSubview(tableView)
        bestJokesView.addSubview(titleTableView)
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
            make.height.equalTo(320)
            make.width.equalToSuperview()
        }
        like.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(80)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }
        dislike.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(80)
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        bestJokesView.snp.makeConstraints { make in
            make.height.equalTo(360)
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        like.layer.borderWidth = 1
        dislike.layer.borderWidth = 1
        jokeView.layer.borderWidth = 1
        bestJokesView.layer.borderWidth = 1
        
        like.layer.borderColor = UIColor.black.cgColor
        dislike.layer.borderColor = UIColor.black.cgColor
        jokeView.layer.borderColor = UIColor.black.cgColor
        bestJokesView.layer.borderColor = UIColor.black.cgColor
        
    }
    private func setupViewsActions() {
        getJokeButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        like.addTarget(self, action: #selector(likePressed), for: .touchUpInside)
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

extension ViewController {
    @objc func likePressed() {
        guard let jokeStr = joke.text else {
            return
        }
        if bestJokesArray.contains(jokeStr) {
            return
        } else {
            bestJokesArray.append(jokeStr)
            tableView.reloadData()
        }
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource  {
    private func setupTableViewUI() {
        tableView.frame = CGRect(x: 0,
                                 y: titleTableView.frame.height,
                                 width: view.frame.width,
                                 height: view.frame.height - titleTableView.frame.height)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bestJokesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        // Настройка ячейки и установка данных
        cell.textLabel?.text = bestJokesArray[indexPath.row]

        return cell
    }
}
