# cake
Backend para envio de WhatsApp e SMS pelo Twilio


Requisitos 
--------------

Instalação:
 - Para instalação do  webframework Horse preferencialmente usar o [boss](https://github.com/HashLoad/boss) (Dependency Manager for Delphi).
 - De forma fácil e simplificada para gerenciador a instalação e dependências de pacotes: `boss install github.com/leogregianin/cake`

Backend:
 - Usar qualquer uma das versões abaixo:
   * Delphi 10.0 (Seattle)
   * Delphi 10.1 (Berlin)
   * Delphi 10.2 (Tokyo)
   * Delphi 10.3 (Rio) 
   * Delphi Free Community Edition (https://www.embarcadero.com/products/delphi/starter/free-download).

 - Aplicação console para hospedagem em cloud.

 - Instalação do Docker (https://www.docker.com) para Windows ou Linux (conforme seu gosto).


Configuração
--------------
* Criar conta no Twilio (https://www.twilio.com)
* Renomear o arquivo config-exemplo.ini para config.ini
* Inserir no arquivo config.ini os valores do SID, Token e número do telefone fornecidos pelo Twilio.


Rotas
--------------
* `GET  /`
* `POST /sendsms`
* `POST /sendwhats`


Exemplo de uso no frontend
--------------

* Exemplo do JSON que deve ser enviado ao backend:
```json
{
  "phone": "+5511999999999",
  "msg": "send sms by cake"
}
```

* Parâmetros da requisição:
   * Header: `Content-Type: application/json`
   * Request: POST
   * Dados: JSON no exemplo acima
   * Rotas: /sendsms ou /sendwhats

* Exemplo de uso com cURL:
```
   curl --header "Content-Type: application/json" --request GET http://localhost:5000/`
   
   curl --header "Content-Type: application/json" --request POST --data "{\"phone\":\"+5511999999999\",\"msg\":\"send sms by cake\"}" http://localhost:5000/sendsms`
   
   curl --header "Content-Type: application/json" --request POST --data "{\"phone\":\"+5511999999999\",\"msg\":\"send whatsup by cake\"}" http://localhost:5000/sendwhats`
```

Docker
--------------
```
docker image build -t cake:api .
docker container run -it --rm -p 5000:5000 cake:api

docker ps
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' ff20c18b0c05
```

Exemplo de Docker para Windows:
  - https://fabiorogeriosj.com.br/2018/02/20/Trabalhando-com-Docker-container-de-Windows/


Agradecimentos
--------------
O backend foi desenvolvido utilizando o web framework [Horse](https://github.com/HashLoad/horse) da [HashLoad](https://github.com/HashLoad).


Autor
--------------
Leonardo Gregianin (leogregianin@gmail.com)


Licença
--------------
MIT
