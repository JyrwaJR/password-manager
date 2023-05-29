import 'package:flutter/material.dart';
import 'package:password_manager/export.dart';

class NoteGroupCardShimmer extends StatelessWidget {
  const NoteGroupCardShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        childAspectRatio: 4 / 5,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        crossAxisCount: 2,
        children: List.generate(
          20,
          (index) => Card(
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        PopupMenuButton(
                          enabled: false,
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: '0',
                              child: Text('Rename'),
                            ),
                            const PopupMenuItem(
                              value: '1',
                              child: Text('Get Key'),
                            ),
                            const PopupMenuItem(
                              value: '2',
                              child: Text('Delete'),
                            ),
                          ],
                        )
                      ],
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Theme.of(context).highlightColor,
                          ),
                          const BrandSizeBox(height: 10),
                          Container(
                            height: 15,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Theme.of(context).highlightColor,
                                borderRadius: BorderRadius.circular(12)),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ));
  }
}
