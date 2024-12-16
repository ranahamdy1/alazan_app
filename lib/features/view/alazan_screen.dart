import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alazan_app/features/controller/alazan_cubit.dart';
import 'package:alazan_app/features/controller/alazan_state.dart';

class AlazanScreen extends StatelessWidget {
  const AlazanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AlazansCubit()..getAlazan(),
      child: BlocConsumer<AlazansCubit, AlazanState>(
        listener: (context, state) {
          if (state is AlazanInitialState) {
            print("CounterInitialState");
          } else if (state is AlazanSuccessState) {
            print("ReelsSuccessState");
          } else if (state is AlazanFailedState) {
            print("ReelsFailedState: ${state.msg}");
          }
        },
        builder: (context, state) {
          if (state is AlazanLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AlazanSuccessState) {
            final prayerTimesResponse = state.alazanModel;
            if (prayerTimesResponse != null) {
              final timings = prayerTimesResponse.data?.timings;
              if (timings != null) {
                return Scaffold(
                  backgroundColor: Colors.black,
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Fajr: ${timings.fajr ?? 'Not available'}",
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          "Sunrise: ${timings.sunrise ?? 'Not available'}",
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          "Dhuhr: ${timings.dhuhr ?? 'Not available'}",
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          "Asr: ${timings.asr ?? 'Not available'}",
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          "Maghrib: ${timings.maghrib ?? 'Not available'}",
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        Text(
                          "Isha: ${timings.isha ?? 'Not available'}",
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
          }

          if (state is AlazanFailedState) {
            return Center(child: Text("Failed to load data: ${state.msg}"));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
