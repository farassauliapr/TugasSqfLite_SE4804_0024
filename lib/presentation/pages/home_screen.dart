import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugassqflite/model/barang.dart';
import 'package:tugassqflite/presentation/controller/barang_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showFormDialog(BarangController ctr, {Barang? barang}) {
    final isEdit = barang != null;
    final namaC = TextEditingController(text: barang?.nama ?? '');
    final stokC = TextEditingController(text: barang?.stok.toString() ?? '');

    Get.dialog(
      AlertDialog(
        title: Text(isEdit ? 'Edit Barang' : 'Tambah Barang'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaC,
              decoration: const InputDecoration(
                labelText: 'Nama Barang',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: stokC,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Stok',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final nama = namaC.text.trim();
              final stok = int.tryParse(stokC.text.trim());

              if (nama.isEmpty || stok == null) {
                Get.snackbar(
                  'Peringatan',
                  'Nama barang dan stok (angka) wajib diisi',
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
                return;
              }

              if (isEdit) {
                ctr.updateBarang(
                  barang.copyWith(nama: nama, stok: stok),
                );
              } else {
                ctr.tambahBarang(
                  Barang(nama: nama, stok: stok),
                );
              }
              Get.back();
            },
            child: Text(isEdit ? 'Update' : 'Simpan'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirm(BarangController ctr, Barang barang) {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Barang'),
        content: Text('Yakin ingin menghapus "${barang.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              if (barang.id != null) {
                ctr.hapusBarang(barang.id!);
              }
              Get.back();
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctr = Get.find<BarangController>();
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(ctr),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "LIST BARANG",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Obx(() {
                if (ctr.barangList.isEmpty) {
                  return const Center(child: Text("Data Belum Ada"));
                }

                return ListView.builder(
                  itemCount: ctr.barangList.length,
                  itemBuilder: (context, index) {
                    final barang = ctr.barangList[index];
                    return Card(
                      child: ListTile(
                        title: Text(barang.nama),
                        subtitle: Text("Stok Barang: ${barang.stok}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () =>
                                  _showFormDialog(ctr, barang: barang),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  _showDeleteConfirm(ctr, barang),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}