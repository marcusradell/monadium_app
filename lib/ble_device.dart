import 'dart:async';
import 'package:rxdart/rxdart.dart';

enum BleStatus { initial, ready }

class BleState {
  final BleStatus status;
  final int pressure;

  const BleState(this.status, this.pressure);
}

const initialState = BleState(BleStatus.initial, 0);

increasePressureReducer(int pressure) => (BleState state) {
      var newPressure = state.pressure + pressure;
      var newStatus = state.status;
      if (newPressure > 15) {
        newStatus = BleStatus.ready;
      }
      return BleState(newStatus, newPressure);
    };

class BleDevice {
  StreamController<int> increasePressureController = StreamController();

  void increasePressure(int increment) {
    increasePressureController.add(increment);
  }

  Stream<BleState> stateStream() {
    Stream<BleState> stream = MergeStream(
            [increasePressureController.stream.map(increasePressureReducer)])
        .scan((state, actionFn, index) => actionFn(state), initialState);

    return stream.startWith(initialState);
  }
}
