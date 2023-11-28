import 'package:flutter/material.dart';
import 'package:flutter_metalk/components/image_padding.dart';

class ContainerWidget extends StatelessWidget {
  final String? image;
  final String title;
  final VoidCallback onTap;
  final bool isChecked;

  const ContainerWidget({super.key,
    required this.title,
    this.image,
    required this.onTap,
    required this.isChecked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            100,
          ),
          color: isChecked ? const Color.fromARGB(255, 230, 250, 249,) : const Color.fromARGB(255, 250, 250, 250,),
          border: Border.all(
            color: isChecked ? const Color.fromARGB(255, 3, 201, 195) : const Color.fromARGB(255, 245, 245, 245),
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (image != null)...[
              ImagePadding(
                image!,
                width: 16,
                height: 16,
                fit: BoxFit.contain,
                isNetwork: true,
              ),
              const SizedBox(
                width: 5,
              ),
            ],
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
