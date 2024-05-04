import 'package:flutter/material.dart';
//models
import 'package:mi_tienda_app/models/product.dart';
//widgets
import 'package:mi_tienda_app/views/widgets/edit_product.dart';
import 'package:provider/provider.dart';

import '../../controllers/providers/app__data_provider.dart';
import '../../controllers/utils/amount_details.dart';
import '../../controllers/utils/custom_formats.dart';

class ProductGrid extends StatefulWidget {
  final List<Product> products;
  final ScrollController controller;
  const ProductGrid(
      {required this.products, super.key, required this.controller});
  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: widget.controller,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 155 / 190,
      ),
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        return ProductAdminCard(product: widget.products[index]);
      },
    );
  }
}

class ProductAdminCard extends StatefulWidget {
  final Product product;
  const ProductAdminCard({super.key, required this.product});

  @override
  State<ProductAdminCard> createState() => _ProductAdminCardState();
}

class _ProductAdminCardState extends State<ProductAdminCard> {
  @override
  Widget build(BuildContext context) {
    final AppDataProvider appDataProvider = context.watch<AppDataProvider>();
    final Map<String, double> dcValues =
        discountValues(widget.product.price, widget.product.discount);

    double finalPrice = dcValues['finalPrice']!;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              flex: 2,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(widget.product.imageUrl),
                    fit: BoxFit.fill,
                  ),
                ),
                child: const SizedBox(
                  height: double.maxFinite,
                  width: double.maxFinite,
                ),
              ),
            ),
            const Divider(),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: Column(children: [
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5, bottom: 6),
                    child: Row(
                      children: [
                        Text(
                          toCOP(widget.product.price),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                            color: appDataProvider.accentColor,
                            decoration: widget.product.discount != 0
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        if (widget.product.discount != 0)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Text(
                              toCOP(finalPrice),
                              style: TextStyle(
                                fontSize: 11,
                                color: appDataProvider.accentColor,
                              ),
                            ),
                          ),
                        if (widget.product.discount != 0)
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: appDataProvider.accentColor,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                toPercentage(widget.product.discount),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: appDataProvider.backgroundColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      widget.product.description,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit,
                        color: appDataProvider.accentColor, size: 20),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditProduct(product: widget.product),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                        widget.product.hidden ? Icons.public_off : Icons.public,
                        color: appDataProvider.accentColor,
                        size: 20),
                    onPressed: () {
                      setState(() {
                        widget.product.hidden = !widget.product.hidden;
                      });
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
