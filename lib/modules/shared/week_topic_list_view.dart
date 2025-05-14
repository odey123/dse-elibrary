import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:systems_app/utils/constant.dart';
import 'package:systems_app/utils/strings.dart';

class WeekTopicListView extends StatefulWidget {
  final Map<String, String> weekAndTopics;
  const WeekTopicListView({
    super.key,
    required this.weekAndTopics,
  });

  @override
  State<WeekTopicListView> createState() => _WeekTopicListViewState();
}

class _WeekTopicListViewState extends State<WeekTopicListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: kRegularPadding,
        right: kRegularPadding,
        top: kMicroPadding,
        bottom: kLargePadding,
      ),
      decoration: BoxDecoration(
        color: kGry300.withOpacity(0.6),
        borderRadius: const BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: kRegularPadding,
            ),
            child: Text(
              workPlan,
              style: textTheme.titleMedium!.copyWith(
                fontSize: (!kIsWeb || isPhoneWeb) ? 16 : 15,
                fontWeight: FontWeight.w500,
                color: kBlack,
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: (!kIsWeb || isPhoneWeb) ? 50 : 60,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(
                  bottom: kSmallPadding,
                ),
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: kBlack,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Text(
                  wEEK,
                  style: textTheme.titleMedium!.copyWith(
                    fontSize: (!kIsWeb || isPhoneWeb) ? 14 : 14,
                    fontWeight: FontWeight.w500,
                    color: kBlack,
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  width: screenSize.width,
                  padding: const EdgeInsets.only(
                    bottom: kSmallPadding,
                    left: kSmallPadding,
                  ),
                  decoration: const BoxDecoration(),
                  child: Text(
                    tOPIC,
                    style: textTheme.titleMedium!.copyWith(
                      fontSize: (!kIsWeb || isPhoneWeb) ? 14 : 14,
                      fontWeight: FontWeight.w500,
                      color: kBlack,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: widget.weekAndTopics.entries.map(
              (entry) {
                final week = entry.key;
                final topic = entry.value;
                return Row(
                  children: [
                    SizedBox(
                      width: (!kIsWeb || isPhoneWeb) ? 30 : 40,
                    ),
                    Container(
                      width: 20,
                      height: (!kIsWeb || isPhoneWeb) ? 50 : null,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(
                        top: kSmallPadding,
                        bottom: kSmallPadding,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: kBlack,
                            width: 1.0,
                          ),
                          right: BorderSide(
                            color: kBlack,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Text(
                        week,
                        style: textTheme.titleMedium!.copyWith(
                          fontSize: (!kIsWeb || isPhoneWeb) ? 14 : 14,
                          fontWeight: FontWeight.w500,
                          color: kBlack,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        width: screenSize.width,
                        height: (!kIsWeb || isPhoneWeb) ? 50 : null,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                          vertical: kSmallPadding,
                          horizontal: kSmallPadding,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: kBlack,
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Text(
                          topic,
                          overflow: TextOverflow.ellipsis,
                          maxLines: (!kIsWeb || isPhoneWeb) ? 3 : 1,
                          style: textTheme.titleMedium!.copyWith(
                            fontSize: (!kIsWeb || isPhoneWeb) ? 14 : 14,
                            fontWeight: FontWeight.w500,
                            color: kBlack,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
