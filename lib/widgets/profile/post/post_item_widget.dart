import 'package:buddymensia/models/chat_message.dart';
import 'package:buddymensia/models/post.dart';
import 'package:buddymensia/screens/home/speak_screen.dart';
import 'package:buddymensia/services/speak_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostItemWidget extends StatelessWidget {
  final Post post;
  final String fullname;
  const PostItemWidget({super.key, required this.post, required this.fullname});

  @override
  Widget build(BuildContext context) {
    final setupPrompt = '''
Anda adalah AI yang bertugas memulai percakapan berbasis kenangan untuk penderita demensia di platform Buddymensia. Setiap kali pengguna mengunggah gambar kenangan, berikan respon yang mendukung dan penuh empati berdasarkan informasi yang telah diinput di formulir unggahan kenangan.

Nama lawan bicara Anda: $fullname
Gambar: ${post.imageUrl}
Judul Postingan: ${post.judul}
Caption Postingan: ${post.caption}
Tanggal Foto: ${DateFormat('EEEE, d MMMM y', 'id_ID').format(post.date!)}
Anggota Keluarga/Kerabat dalam Foto: ${post.anggotaKeluarga}
Kata Memori yang Ditambahkan: ${post.kataMemory}

Mulai percakapan dengan memberikan komentar yang relevan dan tanyakan pertanyaan untuk memulai dialog tentang kenangan tersebut. Fokuslah pada membangkitkan emosi positif dan memberikan dukungan psikologis. Jangan terlalu panjang dalam memberikan tanggapan dan jangan menggunakan simbol ataupun hashtag.
''';

    return GestureDetector(
      onTap: () async {
        List<ChatMessage> setupChat = [
          ChatMessage(role: 'system', content: setupPrompt)
        ];

        final setupLine = await SpeakServices().sendToGPT(setupChat);

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SpeakScreen(
                  post: post,
                  setupVoice: setupLine!,
                  chat: setupChat,
                )));
      },
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(post.imageUrl!),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
