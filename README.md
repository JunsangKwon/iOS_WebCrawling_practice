iOS 에서 웹 크롤링을 하는 과정
========================


## 1. SwiftSoup 라이브러리 설치

- https://github.com/scinfu/SwiftSoup
- 위 링크에서 cocoapods를 이용하는 방식을 사용하였습니다.
- terminal을 이용하여 해당 프로젝트 폴더로 가서 pod init 하여 Podfile을 생성합니다.
- Podfile안에 pod 'SwiftSoup' 을 추가합니다.
- 그 후 pod install 하면 설치가 완료됩니다.



## 2. WebCrawling 준비하기

- 사용할 ViewController 에서 import SwiftSoup를 해줍니다.
- 웹 크롤링을 해올 함수를 선언합니다.
- 웹 크롤링을 해올 사이트 url을 String으로 들고와서 URL(string: url) 로 설정합니다.

~~~swift
let urlAddress = "https://auto.naver.com/car/main.nhn?yearsId=134453"
guard let url = URL(string: urlAddress) else { return }
~~~

- 혹시 모를 오류를 위해서 do ~ catch 문을 사용합니다.

~~~swift
let html = try String(contentsOf: url, encoding: .utf8)
let doc: Document = try SwiftSoup.parse(html)
~~~



## 3. 정보 가져오기 (text)

- 사이트에서 개발자 도구를 열어서 html 형식으로 된 코드를 확인합니다.
- 가져오고 싶은 정보가 있는 곳을 CSS의 선택자를 select 안에 넣어서 지정하는 방식으로 가져옵니다.

~~~swift
let title: Elements = try doc.select(".end_model").select("h3")
~~~
코드의 의미 => end_model이란 클래스를 가진 태그 안에 있는 h3 태그 정보를 title에 저장해라



## 4. 정보 가져오기 (image)

- Image는 text에 비해서 조금 과정이 복잡했습니다.
- text를 가져오는 것 처럼 가져온후, URL(string: stringImage)와 같이 설정해주고
- 다음과 같이 이미지를 설정해줍니다.

~~~swift
let imagesrc: Elements = try doc.select("div#carMainImgArea.img_group").select("div.main_img").select("img[src]")
let stringImage = try imagesrc.attr("src").description
let urlImage = URL(string: stringImage)
let data = try Data(contentsOf: urlImage!)
carImage.image = UIImage(data: data)
~~~



## 5. 가져온 결과
- 성공적으로 가져오게 되었습니다.

![webcrawling](https://user-images.githubusercontent.com/61138164/109742424-57400100-7c12-11eb-843d-879501c01120.gif)

reference: https://atelier-chez-moi.tistory.com/101
