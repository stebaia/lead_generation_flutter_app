# Test della Gestione Errori di Login

## Come testare gli errori di login

### 1. Modalità Debug
L'app include una modalità debug per testare facilmente gli errori di login senza dover inserire credenziali realmente sbagliate.

### 2. Credenziali di test che falliscono sempre
Per testare la visualizzazione degli errori, usa queste credenziali:

- **Email di test**: `test@fail.com`
- **Password di test**: `wrongpassword`

### 3. Cosa aspettarsi
Quando inserisci le credenziali di test sopra:

1. L'app mostrerà il loading spinner
2. Dopo 1 secondo (simulazione ritardo di rete), apparirà un messaggio di errore rosso
3. Il messaggio mostrerà: "Credenziali non valide. Controlla email e password."

### 4. Test con credenziali reali sbagliate
Puoi anche testare con credenziali realmente sbagliate. L'app ora:

- Rileva automaticamente le risposte di errore dal server
- Mostra messaggi di errore appropriati
- Distingue tra errori di rete ed errori di credenziali

### 5. Tipi di errore gestiti

#### Errori di Credenziali
- Credenziali non valide
- User ID = 0 o -1 nella risposta
- Valori mancanti o nulli nella risposta
- UserType non valido

#### Errori di Rete
- Problemi di connessione
- Timeout
- Errori SSL

### 6. Logging
L'app ora include logging dettagliato per il debug:
- Risposta completa del server
- Valori parsati
- Tipo di errore rilevato

### 7. Disabilitare la modalità debug
Per disabilitare la modalità debug in produzione, modifica `lib/utils/debug_helper.dart`:

```dart
static const bool enableDebugMode = false; // Cambia a false
```

## Test Automatici
Esegui i test automatici con:
```bash
flutter test test/login_error_test.dart
```

Questi test verificano:
- Impostazione corretta dei messaggi di errore
- Cancellazione degli errori
- Validazione delle credenziali 