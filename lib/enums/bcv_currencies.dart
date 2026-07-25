/// Currencies used in BCV (Central Bank of Venezuela) operations.
///
/// - `dolar`: US Dollar (dolar)
/// - `euro`: Euro (euro)
/// - `yuan`: Yuan (yuan)
/// - `lira`: Turkish Lira (lira)
/// - `rublo`: Russian Ruble (rublo)
enum BcvCurrency {
  dolar('dolar'),
  euro('euro'),
  yuan('yuan'),
  lira('lira'),
  rublo('rublo');

  final String value;
  const BcvCurrency(this.value);
}
