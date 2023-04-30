abstract class IEnum<T> {
  final T _value;
  T get value => _value;

  const IEnum(this._value);

  @override
  String toString() => _value.toString();

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(dynamic other) {
    if (other is IEnum<T>) {
      return other._value == _value;
    }
    if (other is T) {
      return other == _value;
    }
    return false;
  }
}