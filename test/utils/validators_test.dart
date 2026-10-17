import 'package:flutter_test/flutter_test.dart';
import 'package:intera_edu/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('rejeita vazio ou nulo', () {
      expect(Validators.email(null), 'Email é obrigatório');
      expect(Validators.email(''), 'Email é obrigatório');
      expect(Validators.email('   '), 'Email é obrigatório');
    });

    test('aceita email válido', () {
      expect(Validators.email('aluno@universidade.edu.br'), isNull);
    });

    test('aceita email com espaços nas bordas', () {
      expect(Validators.email(' aluno@universidade.edu.br '), isNull);
    });

    test('rejeita formato inválido', () {
      expect(Validators.email('aluno@'), 'Informe um email válido');
      expect(Validators.email('aluno.universidade.edu'), 'Informe um email válido');
    });
  });

  group('Validators.password', () {
    test('aceita senha forte', () {
      expect(Validators.password('Senha@123'), isNull);
    });

    test('aponta cada requisito ausente', () {
      expect(Validators.password(''), 'Senha é obrigatória');
      expect(Validators.password('Ab@1'), 'A senha deve ter pelo menos 8 caracteres');
      expect(Validators.password('senha@123'), 'Deve conter uma letra maiúscula');
      expect(Validators.password('SENHA@123'), 'Deve conter uma letra minúscula');
      expect(Validators.password('Senha@abc'), 'Deve conter um número');
      expect(Validators.password('Senha1234'), 'Deve conter um caractere especial');
    });
  });

  group('Validators.required', () {
    test('usa nome do campo na mensagem', () {
      expect(Validators.required('  ', 'Nome'), 'Nome é obrigatório');
      expect(Validators.required(null), 'Este campo é obrigatório');
      expect(Validators.required('Ana'), isNull);
    });
  });

  group('Validators.otpCode', () {
    test('aceita 6 dígitos, inclusive com espaços nas bordas', () {
      expect(Validators.otpCode('123456'), isNull);
      expect(Validators.otpCode(' 123456 '), isNull);
    });

    test('rejeita tamanho ou caracteres inválidos', () {
      expect(Validators.otpCode(''), 'Informe o código de verificação');
      expect(Validators.otpCode('12345'), 'O código deve ter 6 dígitos');
      expect(Validators.otpCode('12a456'), 'O código deve conter apenas números');
    });
  });
}
