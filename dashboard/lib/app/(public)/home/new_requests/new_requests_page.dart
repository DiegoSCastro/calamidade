import 'package:dashboard/app/(public)/home/new_requests/widgets/new_requests_card.dart';
import 'package:dashboard/app/features/home/request/interactor/controller/request_controller.dart';
import 'package:dashboard/app/features/home/request/interactor/states/request_state.dart';

import 'package:dashboard/injector.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class NewRequestsPage extends StatefulWidget {
  const NewRequestsPage({
    super.key,
  });

  @override
  State<NewRequestsPage> createState() => _NewRequestsPageState();
}

class _NewRequestsPageState extends State<NewRequestsPage> {
  final controller = injector.get<RequestController>();

  @override
  void initState() {
    controller.fetchNewRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = CoopartilharColors.of(context);
    final texts = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colors.lightGrey,
      body: ValueListenableBuilder(
        valueListenable: controller,
        builder: (context, state, child) {
          if (state is NewRequestsInitialState) {
            return const Text('Inicial');
          }
          if (state is NewRequestsLoadingState) {
            return const Text('Loading');
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'Acesso administrativo',
                          style: texts.displayLarge
                              ?.copyWith(color: colors.textColor2),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Solicitações mais antigas',
                              style: texts.bodyMedium
                                  ?.copyWith(color: colors.textColor2),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Text(
                              'Filtrar',
                              style: texts.bodySmall?.copyWith(
                                  decoration: TextDecoration.underline,
                                  color: colors.textColor2),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //Lista de cards
                switch (state) {
                  NewRequestsSuccessState() => SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisExtent: 180,
                          crossAxisCount: 2,
                          childAspectRatio: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final entity = state.data.requests[index];

                            return NewRequestsCard(
                              title: entity.title,
                              name: 'entity.name',
                              city: 'entity.city',
                              phone: ' entity.phone',
                              date: 'entity.date',
                              status: entity.status,
                              requestedIncome: 'entity.requestedIncome',
                              isSelected: state.selectedId == entity.id,
                              onTap: () {
                                controller.selectItem(entity.id);
                              },
                            );
                          },
                          childCount: state.data.requests.length,
                        ),
                      ),
                    ),
                  NewRequestsErrorState() => SliverToBoxAdapter(
                      child: Center(
                        child: Text(state.exception.message),
                      ),
                    ),
                  _ => const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                },
                //Ultimo Card
                switch (state) {
                  NewRequestsSuccessState() => SliverVisibility(
                      visible: state.lastItem != null,
                      sliver: SliverToBoxAdapter(
                        child: NewRequestsCard(
                          title: state.lastItem?.description ?? '',
                          name: 'state.lastItem?.name',
                          city: 'state.lastItem?.city',
                          phone: 'state.lastItem?.phone',
                          date: 'state.lastItem?.date',
                          status: '',
                          requestedIncome: ' state.lastItem?.requestedIncome',
                          isSelected: state.selectedId == state.lastItem?.id,
                          onTap: () {
                            controller.selectItem(state.lastItem?.id);
                          },
                        ),
                      ),
                    ),
                  NewRequestsErrorState() => SliverToBoxAdapter(
                      child: Container(),
                    ),
                  _ => SliverToBoxAdapter(
                      child: Container(),
                    ),
                },
              ],
            ),
          );
        },
      ),
    );
  }
}
