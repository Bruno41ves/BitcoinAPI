//
//  ViewController.swift
//  Bitcoin
//
//  Created by Bruno Alves da Silva on 08/07/20.
//  Copyright © 2020 Bruno Alves da Silva. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var precoBitcoins: UILabel!
    @IBOutlet weak var botaoAtualizar: UIButton!
    
    @IBAction func atualizatBitcoin(_ sender: Any) {
        self.recuperarPrecoBitcoins()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.recuperarPrecoBitcoins()
    }
    
    func formatarPreco(preco: NSNumber) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = Locale(identifier: "pt_BR")
        
        if let precoFinal = numberFormatter.string(from: preco) {
            return precoFinal
        }
        return "0,00"
    }
    
    func recuperarPrecoBitcoins() {
        
        self.botaoAtualizar.setTitle("Atualizando...", for: .normal)
        
        //Criando uma variavel responsavel pela consulta
        if let url = URL(string: "https://blockchain.info/ticker") {
                   
                   // 1 - E necessario criar uma requisicao
                   // SHARED - Retorna um objeto e através desse objeto conseguimos fazer uma consulta
                   // CompletionHendler - permite recuperar os dados da requisicao
                   //Abaixo estamos utilizando o metodo dataTask para fazer uma requisicao na API
                   let tarefa = URLSession.shared.dataTask(with: url) { (dados, resquisicao, erro) in
                    
                    if erro == nil {
                        
                        //Retorno do JSON
                        // 1 - Tratando os dados (por conta de ser um optional)
                        if let dadosRetorno = dados {
                            do {
                                //Fazendo a conversao para o swift entender o JSON
                                if let objetoJSON = try JSONSerialization.jsonObject(with: dadosRetorno, options: []) as? [String: Any] {
                                    
                                    //Pegando somente a informacao do Brazil
                                    if let brl = objetoJSON["BRL"] as? [String: Any]{
                                        if let preco = brl["buy"] as? Double {
                                            let precoFormatado = self.formatarPreco(preco: NSNumber(value: preco))
                                            DispatchQueue.main.async (execute: {
                                                self.precoBitcoins.text = "R$ " + precoFormatado
                                                self.botaoAtualizar.setTitle("Atualizar", for: .normal)
                                            })
                                        }
                                    }
                                }
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    } else {
                        print("Nao deu certo :(")
                    }
                   }
            
            // responsavel por iniciar a consulta
            tarefa.resume()
        }
    }
}

