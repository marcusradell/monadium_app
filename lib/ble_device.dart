import 'dart:async';
import 'package:rxdart/rxdart.dart';

enum BleStatus { initial, ready }

class BleState {
  BleStatus status;
  int pressure;

  BleState(this.status, this.pressure);
}

class BleDevice {
  StreamController<int> increasePressureController = StreamController();

  void increasePressure(int increment) {
    increasePressureController.add(increment);
  }

  Stream<BleState> stateStream() {
    Stream<BleState> stream = MergeStream([
      increasePressureController.stream.map((pressure) => (BleState state) {
            var newPressure = state.pressure + pressure;
            var newStatus = state.status;
            if (newPressure > 15) {
              newStatus = BleStatus.ready;
            }
            return BleState(newStatus, newPressure);
          })
    ]).scan((state, actionFn, index) => actionFn(state),
        BleState(BleStatus.initial, 0));

    return stream.startWith(BleState(BleStatus.initial, 0));
  }
}
