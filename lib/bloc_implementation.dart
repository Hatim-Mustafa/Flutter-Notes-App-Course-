import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CounterBloc(),
        child: Scaffold(
            appBar: AppBar(
              title: Text("Counter"),
            ),
            body: BlocConsumer<CounterBloc, counterState>(
              builder: (context, state) {
                final invalidValue = (state is counterStateInvalidNumber)
                    ? state.invalidValue
                    : '';
                return Column(
                  children: [
                    Text("Current Value is ${state.value}"),
                    Visibility(
                      child: Text("Invalid Input, ${invalidValue}"),
                      visible: state is counterStateInvalidNumber,
                    ),
                    TextField(
                      controller: _controller,
                      decoration:
                          InputDecoration(hintText: "Enter a number here.."),
                      keyboardType: TextInputType.number,
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            context
                                .read<CounterBloc>()
                                .add(decrementValue(value: _controller.text));
                          },
                          child: Text("-"),
                        ),
                        TextButton(
                          onPressed: () {
                            context
                                .read<CounterBloc>()
                                .add(incrementValue(value: _controller.text));
                          },
                          child: Text("+"),
                        )
                      ],
                    )
                  ],
                );
              },
              listener: (context, state) {
                _controller.clear();
              },
            )));
  }
}

abstract class counterState {
  final value;
  const counterState(this.value);
}

class counterStateValid extends counterState {
  const counterStateValid(int value) : super(value);
}

class counterStateInvalidNumber extends counterState {
  final String invalidValue;
  const counterStateInvalidNumber(
      {required this.invalidValue, required int previousValue})
      : super(previousValue);
}

abstract class counterEvent {
  final String value;
  counterEvent({required this.value});
}

class incrementValue extends counterEvent {
  incrementValue({required String value}) : super(value: value);
}

class decrementValue extends counterEvent {
  decrementValue({required String value}) : super(value: value);
}

class CounterBloc extends Bloc<counterEvent, counterState> {
  CounterBloc() : super(const counterStateValid(0)) {
    on<incrementValue>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(counterStateInvalidNumber(
          invalidValue: event.value,
          previousValue: state.value,
        ));
      } else {
        emit(counterStateValid(state.value + integer));
      }
    });
    on<decrementValue>((event, emit) {
      final integer = int.tryParse(event.value);
      if (integer == null) {
        emit(counterStateInvalidNumber(
          invalidValue: event.value,
          previousValue: state.value,
        ));
      } else {
        emit(counterStateValid(state.value - integer));
      }
    });
  }
}
