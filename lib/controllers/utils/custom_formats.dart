String toCOP(double value) {
  return "\$ ${value.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      )}";
}

String toPercentage(double value) {
  return "${(value * 100).toStringAsFixed(0)}%";
}
