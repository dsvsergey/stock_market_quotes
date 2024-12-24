import 'dart:math';

class _Heap {
  final List<double> _items = [];
  final bool _isMinHeap;

  _Heap({bool isMinHeap = true}) : _isMinHeap = isMinHeap;

  void add(double value) {
    _items.add(value);
    _siftUp(_items.length - 1);
  }

  double removeTop() {
    if (_items.isEmpty) throw StateError('Heap is empty');
    final top = _items[0];
    final last = _items.removeLast();
    if (_items.isNotEmpty) {
      _items[0] = last;
      _siftDown(0);
    }
    return top;
  }

  double get top => _items.isEmpty ? 0.0 : _items[0];

  int get length => _items.length;
  bool get isEmpty => _items.isEmpty;

  void _siftUp(int index) {
    while (index > 0) {
      final parentIndex = (index - 1) ~/ 2;
      if (_compare(_items[index], _items[parentIndex])) {
        _swap(index, parentIndex);
        index = parentIndex;
      } else {
        break;
      }
    }
  }

  void _siftDown(int index) {
    while (true) {
      var smallest = index;
      final leftChild = 2 * index + 1;
      final rightChild = 2 * index + 2;

      if (leftChild < _items.length &&
          _compare(_items[leftChild], _items[smallest])) {
        smallest = leftChild;
      }
      if (rightChild < _items.length &&
          _compare(_items[rightChild], _items[smallest])) {
        smallest = rightChild;
      }

      if (smallest != index) {
        _swap(index, smallest);
        index = smallest;
      } else {
        break;
      }
    }
  }

  bool _compare(double a, double b) {
    return _isMinHeap ? a < b : a > b;
  }

  void _swap(int i, int j) {
    final temp = _items[i];
    _items[i] = _items[j];
    _items[j] = temp;
  }

  void clear() {
    _items.clear();
  }
}

class OnlineStatistics {
  int _count = 0;
  double _mean = 0.0;
  double _m2 = 0.0; // Для обчислення дисперсії
  final Map<double, int> _frequencyMap = {};
  final _minHeap = _Heap(isMinHeap: true);
  final _maxHeap = _Heap(isMinHeap: false);
  int _lastId = -1;
  int _lostQuotes = 0;

  int get count => _count;
  double get mean => _mean;
  double get standardDeviation => _count > 1 ? sqrt(_m2 / (_count - 1)) : 0.0;

  double get mode {
    if (_frequencyMap.isEmpty) return 0.0;
    return _frequencyMap.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  double get median {
    if (_count == 0) return 0.0;
    if (_minHeap.isEmpty) return 0.0;

    if (_minHeap.length == _maxHeap.length) {
      return (_minHeap.top + _maxHeap.top) / 2;
    }
    return _minHeap.top;
  }

  int get lostQuotes => _lostQuotes;

  void addValue(double value, int id) {
    // Перевірка втрачених котирувань
    if (_lastId != -1 && id > _lastId + 1) {
      _lostQuotes += id - _lastId - 1;
    }
    _lastId = id;

    // Оновлення середнього та M2 для стандартного відхилення
    _count++;
    double delta = value - _mean;
    _mean += delta / _count;
    double delta2 = value - _mean;
    _m2 += delta * delta2;

    // Оновлення моди
    _frequencyMap[value] = (_frequencyMap[value] ?? 0) + 1;

    // Оновлення медіани
    _updateMedian(value);
  }

  void _updateMedian(double value) {
    if (_minHeap.isEmpty || value >= _minHeap.top) {
      _minHeap.add(value);
    } else {
      _maxHeap.add(value);
    }

    // Балансування куп
    if (_minHeap.length > _maxHeap.length + 1) {
      _maxHeap.add(_minHeap.removeTop());
    } else if (_maxHeap.length > _minHeap.length) {
      _minHeap.add(_maxHeap.removeTop());
    }
  }

  void reset() {
    _count = 0;
    _mean = 0.0;
    _m2 = 0.0;
    _frequencyMap.clear();
    _minHeap.clear();
    _maxHeap.clear();
    _lastId = -1;
    _lostQuotes = 0;
  }
}
