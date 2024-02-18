int decrementValueUpto0(int no, {int step = 1}) {
  if (no - step < 0) {
    return 0;
  } else {
    return no - step;
  }
}
