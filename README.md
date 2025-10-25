# Map Navigator App

Um aplicativo Flutter para tracking de localização em tempo real com mapa, velocímetro e monitoramento de alguns sensores.

## Funcionalidades

- 📍 **Tracking GPS em tempo real** - Monitora sua localização com alta precisão
- 🗺️ **Mapa interativo** - Visualiza sua posição e trilha percorrida usando Google Maps
- 🚗 **Velocímetro** - Mostra velocidade atual
- **Aceleração** - Mostra a aceleração atual do dispositivo
- **Heading/Bússula** - Aponta a direçao que se está indo baseando-se no dispositivo


## Tecnologias Utilizadas

- **Flutter** - Framework principal
- **Provider** - Gerenciamento de estado
- **GoRouter** - Navegação entre páginas
- **Geolocator** - Serviços de localização GPS
- **Google Maps Flutter** - Mapas interativos
- **Sensors Plus** - Acesso aos sensores do dispositivo
- **Permission Handler** - Gerenciamento de permissões
- **Flutter Compass** - Eventos de heading
- **GetIt** - Injeção de dependencias
- **Flutter dotenv** - .env para projeto flutter e injetar api credentials no código (repo publico)
- **Google Fonts** - ...fontes.

## Configuração

### 1. Google Maps API Key

Para usar o Google Maps, você precisa configurar uma API key:

1. Acesse o [Google Cloud Console](https://console.cloud.google.com/)
2. Crie um novo projeto ou selecione um existente
3. Ative a API "Maps SDK for Android" e "Maps SDK for iOS"
4. Crie uma API key
5. Para android, apenas coloque a api key no .env seguindo o exemplo (nao deu tempo de configurar automático no ios também)

Este app foi feito no flutter 3.35 e dart 3.9.2

```xml
<meta-data android:name="com.google.android.geo.API_KEY"
           android:value="SUA_API_KEY_AQUI"/>
```

### 2. Instalação das Dependências

```bash
flutter pub get
```

### 3. Permissões
O app solicita automaticamente as seguintes permissões:
- Localização precisa (GPS)
- Localização aproximada (Wi-Fi/Rede)
- Internet (para carregar mapas)
- Localização em background (para tracking contínuo)

## Como Usar
**Entre no app**
Ele tem um mapa, e um botão para iniciar ou parar o monitoramento. Have fun.

## Executar o Projeto

```bash
# Debug
flutter run

flutter run -d iphone (app está configurado para iphone também)
# Release
flutter run --release

# Dispositivo específico
flutter run -d <device_id>
```



## Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

