List<List<T>> transpose<T>(final List<List<T>> matrix) {
  final int rowLength = matrix.length;
  if (rowLength == 0) return matrix;

  final int colLength = matrix[0].length;

  final List<List<T>> ret = new List(colLength);
  for (int col = 0; col < colLength; col++) {
    ret[col] = new List(rowLength);
  }

  for (int row = 0; row < rowLength; row++) {
    for (int col = 0; col < colLength; col++) {
      ret[col][row] = matrix[row][col];
    }
  }
  return ret;
}

bool isSeriesN<T>(
    final List<T> list, final int count, final bool Function(T) valid) {
  int hitCount = 0;
  return list.firstWhere((v) {
        if (valid(v)) {
          hitCount++;
        } else {
          hitCount = 0;
        }
        return hitCount >= count;
      }, orElse: () => null) !=
      null;
}

bool isCrossSeriesN<T>(
    final List<List<T>> matrix, final int count, final bool Function(T) valid) {
  final int rowLength = matrix.length;
  if (rowLength == 0) return false;
  final int colLength = matrix[0].length;

  for (int r = 0; r < rowLength; r++) {
    int hitCount = 0;
    for (int c = 0; c < colLength - r; c++) {
      if (rowLength <= r + c) {
        hitCount = 0;
        continue;
      }
      if (!valid(matrix[r + c][c])) {
        hitCount = 0;
        continue;
      }

      hitCount++;
      if (count <= hitCount) {
        return true;
      }
    }

    hitCount = 0;
    for (int c = 0; c < colLength - (r + 1); c++) {
      if (colLength <= r + c + 1) {
        hitCount = 0;
        continue;
      }
      if (!valid(matrix[c][r + c + 1])) {
        hitCount = 0;
        continue;
      }

      hitCount++;
      if (count <= hitCount) {
        return true;
      }
    }

    hitCount = 0;
    for (int c = 0; c < colLength - r; c++) {
      if (r + c < 0) {
        hitCount = 0;
        continue;
      }
      if (!valid(matrix[r + c][(colLength - 1) - c])) {
        hitCount = 0;
        continue;
      }

      hitCount++;
      if (count <= hitCount) {
        return true;
      }
    }

    hitCount = 0;
    for (int c = 0; c < colLength - (r + 1); c++) {
      if (colLength - 2 - (c + r) < 0) {
        hitCount = 0;
        continue;
      }
      if (!valid(matrix[c][colLength - 2 - (c + r)])) {
        hitCount = 0;
        continue;
      }

      hitCount++;
      if (count <= hitCount) {
        return true;
      }
    }
  }

  return false;
}

bool isMatrixSeriesN<T>(
    final List<List<T>> matrix, final int count, final bool Function(T) valid) {
  if (matrix.firstWhere((row) => isSeriesN(row, count, valid),
          orElse: () => null) !=
      null) return true;

  final transposed = transpose(matrix);
  if (transposed.firstWhere((row) => isSeriesN(row, count, valid),
          orElse: () => null) !=
      null) return true;

  if (isCrossSeriesN(matrix, count, valid)) return true;
  return false;
}
