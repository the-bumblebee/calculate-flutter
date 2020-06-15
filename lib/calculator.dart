const String INTEGER = 'INTEGER',
    PLUS = 'PLUS',
    MINUS = 'MINUS',
    MUL = 'MUL',
    DIV = 'DIV',
    LPAREN = '(',
    RPAREN = ')',
    EOF = 'EOF';

class Token {

  final type, value;

  const Token({this.type, this.value});

}

class Lexer {

  String text;
  int charIndex;
  String currentChar;

  Lexer(String text) {
    this.text = text;
    this.charIndex = 0;
    this.currentChar = this.text[charIndex];
  }

  void advance() {
    this.charIndex += 1;
    if (this.charIndex > this.text.length - 1)
      this.currentChar = null;
    else
      this.currentChar = this.text[charIndex];
  }

  void skipSpace() {
    while (this.currentChar != null && this.currentChar == ' ')
      this.advance();
  }

  int integer() {
    String number = '';
    while (this.currentChar != null && int.tryParse(this.currentChar) != null) {
      number += this.currentChar;
      this.advance();
    }
    return int.tryParse(number);
  }

  Token getNextToken() {

    while (this.currentChar != null) {

      if (int.tryParse(this.currentChar) != null)
        return Token(type: INTEGER, value: this.integer());

      if (this.currentChar == ' ')
        this.skipSpace();

      if (this.currentChar == '+') {
        this.advance();
        return Token(type: PLUS, value: null);
      }

      if (this.currentChar == '-') {
        this.advance();
        return Token(type: MINUS, value: null);
      }

      if (this.currentChar == '*') {
        this.advance();
        return Token(type: MUL, value: null);
      }

      if (this.currentChar == '/') {
        this.advance();
        return Token(type: DIV, value: null);
      }

      if (this.currentChar == '(') {
        this.advance();
        return Token(type: LPAREN, value: null);
      }

      if (this.currentChar == ')') {
        this.advance();
        return Token(type: RPAREN, value: null);
      }
    }

    return Token(type: EOF, value: null);
  }
}

class Interpreter {
  Lexer lexer;
  Token currentToken;

  Interpreter(String text) {
    lexer = Lexer(text);
    this.currentToken = this.lexer.getNextToken();
  }

  void error() {
    throw new Exception('Parsing Error.');
  }

  void expect(String tokenType) {
    if (this.currentToken.type == tokenType)
      currentToken = this.lexer.getNextToken();
    else
      this.error();
  }

  num factor() {
    num result = 1;

    if (this.currentToken.type == MINUS) {
      this.expect(MINUS);
      result = -1;
    }

    Token token = this.currentToken;

    if (token.type == INTEGER) {
      this.expect(INTEGER);
      result *= token.value;
      return result;
    }
    else if (token.type == LPAREN) {
      this.expect(LPAREN);
      result = result * this.expr();
      this.expect(RPAREN);
      return result;
    }
    else
      this.error();
  }

  num term() {
    num result = this.factor();

    while (currentToken.type != EOF && (currentToken.type == MUL || currentToken.type == DIV)) {
      Token token = this.currentToken;
      if (token.type == MUL) {
        this.expect(MUL);
        result *= this.factor();
      }
      else if (token.type == DIV) {
        this.expect(DIV);
        result = result / this.factor();
      }
    }

    return result;
  }

  num expr() {
    num result = this.term();

    while (currentToken.type != EOF && (currentToken.type == PLUS || currentToken.type == MINUS)) {
      Token token = this.currentToken;
      if (token.type == PLUS) {
        this.expect(PLUS);
        result += this.factor();
      }
      else if (token.type == MINUS) {
        this.expect(MINUS);
        result -= this.factor();
      }
    }

    return result;
  }
}