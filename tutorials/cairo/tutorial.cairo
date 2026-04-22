fn main() {
    let latency1 = 100;
    let latency2 = 120;
    let latency3 = 90;
    let latency4 = 110;

    let sum = latency1 + latency2 + latency3 + latency4;
    let average = sum / 4;

    assert(average == 105, 'Calculation error');
}
