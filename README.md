# Forkit-iOS

Util 메서드 사용 설명서

- UIColorFromRGB(rgbValue) : rgbValue 에 8진수 6자리를 넣으면 해당하는 UIColor 를 반환하는 전처리 메서드 ex) UIColorFromRGB(0xffffff) -> 흰색 UIColor 출력
- + (NSString *)changeCurrencyFormatFromNumber:(NSInteger)price : NSInteger price 를 넣으면 한국통화 포멧으로 변환된 NSString 값이 출력
- + (NSString *)changeCurrencyFormatFromNumber:(NSInteger)price : NSInteger withCurrencyCode:(NSString *)currencyCode : price 와 currencyCode 를 넣으면 한국통화 포멧으로 변환된 NSString 값이 출력, currencyCode 가 nil 일 시 한국통화 포멧으로 변환된 NSString 값이 출력

reference links : 
https://github.com/marcinolawski/StoryboardMerge - storyboard conflict solver

http://stackoverflow.com/questions/13233181/xcode-changes-unmodified-storyboard-and-xib-files - why storyboard some times go crazy

