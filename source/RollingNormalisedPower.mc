class RollingNP {
    var windowSize;
    var powerBuffer;
    var sumPower4;
    var currentIndex;
    var count;

    function initialize(frameLength) {
        windowSize = frameLength;
        powerBuffer = new Array(windowSize);
        for (var i = 0; i < windowSize; i++) {
            powerBuffer[i] = 0.0;
        }
        sumPower4 = 0.0;
        currentIndex = 0;
        count = 0;
    }

    // Update met nieuwe powerwaarde (per seconde)
    function update(power) {
        var power4 = Math.pow(power, 4);

        // Verwijder oudste waarde uit som
        sumPower4 -= powerBuffer[currentIndex];
        // Voeg nieuwe waarde toe
        sumPower4 += power4;
        // Schrijf nieuwe waarde in buffer op huidige positie
        powerBuffer[currentIndex] = power4;

        // Verplaats index circulair binnen buffer
        currentIndex = (currentIndex + 1) % windowSize;

        // Houd bij hoeveel metingen er zijn geweest (maximaal windowSize)
        if (count < windowSize) {
            count += 1;
        }

        // Bereken rolling NP met juiste deling bij start
        var rollingNP = Math.pow(sumPower4 / count, 0.25);
        return rollingNP;
    }
}

var rollingNP = new RollingNP();
rollingNP.initialize(30);  // Kies hier 10 of 30 seconden bijvoorbeeld

// Elke seconde (bijv. in onUpdate functie):
var currentPower = ... // powerwaarde van sensor
var currentNP = rollingNP.update(currentPower);

// currentNP is nu je rolling Normalized Power over de laatste 30 seconden (of minder als het nog opstart)
