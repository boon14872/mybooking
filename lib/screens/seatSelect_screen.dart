import 'package:book_my_seat/book_my_seat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mybooking/provider.dart';
import 'package:provider/provider.dart';

const pathDisabledSeat = 'svg/disable.svg';
const pathSelectedSeat = 'svg/vip.svg';
const pathSoldSeat = 'svg/sold.svg';
const pathUnSelectedSeat = 'svg/available.svg';

const rows = 10;
const cols = 4;

class SeatSelectScreen extends StatefulWidget {
  const SeatSelectScreen({Key? key}) : super(key: key);

  @override
  State<SeatSelectScreen> createState() => _SeatSelectScreenState();
}

class _SeatSelectScreenState extends State<SeatSelectScreen> {
  Set<SeatNumber> selectedSeats = Set();

  @override
  Widget build(BuildContext context) {
    // seat generator
    List<List<SeatState>> generateSeats() {
      final List<List<SeatState>> seats = [];
      for (var i = 0; i < rows; i++) {
        final List<SeatState> row = [];
        for (var j = 0; j < cols; j++) {
          if (i == 0) {
            row.add(SeatState.disabled);
          } else if (i == 1 || i == 2) {
            row.add(SeatState.sold);
          } else if (i == rows - 1) {
            row.add(SeatState.sold);
          } else {
            row.add(SeatState.unselected);
          }
        }
        seats.add(row);
      }

      return seats;
    }

    final ticket = Provider.of<MyTicketProvider>(context);

    return Expanded(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 16,
            ),
            const Text(
              "เลือกที่นั่งที่คุณต้องการ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(16),
              child: Flexible(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 500,
                  child: SeatLayoutWidget(
                    onSeatStateChanged: (rowI, colI, seatState) {
                      if (seatState == SeatState.selected) {
                        selectedSeats.add(SeatNumber(rowI: rowI, colI: colI));
                      } else {
                        selectedSeats
                            .remove(SeatNumber(rowI: rowI, colI: colI));
                      }

                      ticket.setSelectedSeat(selectedSeats);
                    },
                    stateModel: SeatLayoutStateModel(
                      pathDisabledSeat: pathDisabledSeat,
                      pathSelectedSeat: pathSelectedSeat,
                      pathSoldSeat: pathSoldSeat,
                      pathUnSelectedSeat: pathUnSelectedSeat,
                      rows: rows,
                      cols: cols,
                      seatSvgSize: 50,
                      currentSeatsState: generateSeats(),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        pathDisabledSeat,
                        width: 15,
                        height: 15,
                      ),
                      const Text('ปิดการใช้งาน')
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        pathSoldSeat,
                        width: 15,
                        height: 15,
                      ),
                      const Text('ขายแล้ว')
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        pathUnSelectedSeat,
                        width: 15,
                        height: 15,
                      ),
                      const Text('ว่าง')
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        pathSelectedSeat,
                        width: 15,
                        height: 15,
                      ),
                      const Text('ที่นั่งของคุณ')
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            )
          ],
        ),
      ),
    );
  }
}

class SeatNumber {
  final int rowI;
  final int colI;

  const SeatNumber({required this.rowI, required this.colI});

  @override
  bool operator ==(Object other) {
    return rowI == (other as SeatNumber).rowI &&
        colI == (other as SeatNumber).colI;
  }

  @override
  int get hashCode => rowI.hashCode;

  @override
  String toString() {
    return '[$rowI][$colI]';
  }
}
