# Costanti fisiche e operative
MASSA_BUS_VUOTO = 12000          # kg
MASSA_PASSEGGERO_MEDIO = 75      # kg
EFFICIENZA_RIGENERATIVA = 0.65   # Efficienza media sistema frenata (inverter + motore)
CAPACITA_PASSEGGERI = 100

def calcola_energia_recuperata_kwh(fermate, corse, giorni, n_iterazioni=10000):
    risultati = []
    
    for _ in range(n_iterazioni):
        # Variabili stocastiche per simulare l'incertezza del percorso
        v_media = np.random.normal(30, 5)          # km/h
        tasso = np.random.uniform(0.3, 0.9)        # occupazione 30-90%
        
        # Fisica: M_totale * 0.5 * v^2
        v_ms = v_media / 3.6
        massa_totale = MASSA_BUS_VUOTO + (CAPACITA_PASSEGGERI * tasso * MASSA_PASSEGGERO_MEDIO)
        energia_cinetica_j = 0.5 * massa_totale * (v_ms**2)
        
        # Energia netta recuperata in Joule, convertita in kWh (1 kWh = 3.6e6 J)
        energia_recuperata_kwh = (energia_cinetica_j * EFFICIENZA_RIGENERATIVA) / 3.6e6
        
        # Risparmio totale per il periodo
        risparmio_totale = energia_recuperata_kwh * fermate * corse * giorni
        risultati.append(risparmio_totale)
        
    return np.array(risultati)

def main():
    # Parametri di input
    fermate_risparmiate = 31
    corse_giornaliere = 158
    giorni_attività = 250
    prezzo = 0.14
    
    dati = calcola_energia_recuperata_kwh(fermate_risparmiate, corse_giornaliere, giorni_attività)
    
    media = np.mean(dati)
    risparmio_euro = media * prezzo
    p5 = np.percentile(dati, 5)
    p95 = np.percentile(dati, 95)
    
    print(f'Risparmio energetico annuo stimato: {media:.2f} kWh')
    print(f'Intervallo di confidenza 90%: [{p5:.2f} - {p95:.2f}] kWh')
    print(f'Risparmio economico equivalente annuo stimato: {risparmio_euro:.2f} $')
    

if __name__ == "__main__":
    main()


