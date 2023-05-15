import 'package:flutter/material.dart';

class PasswordCardShimmer extends StatelessWidget {
  const PasswordCardShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 12,
      separatorBuilder: (BuildContext context, int index) {
        return Card(
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Theme.of(context).highlightColor,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).cardColor,
                  radius: 23,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                    width: 200,
                    height: 12,
                  ),
                  const SizedBox(height: 2),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                    width: 250,
                    height: 10,
                  )
                ],
              )
            ],
          ),
        ));
      },
      itemBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 5,
        );
      },
    );
  }
}
