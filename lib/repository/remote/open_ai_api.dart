import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record_to_talk/common/app_logger.dart';
import 'package:record_to_talk/models/app_setting.dart';
import 'package:record_to_talk/models/result.dart';

final openAiApiProvider = Provider((ref) => _OpenAiApi(ref));
final _dioProvider = Provider((_) => Dio());

class _OpenAiApi {
  const _OpenAiApi(this.ref);

  final Ref ref;

  ///
  /// 音声データを文字起こしする。
  /// セグメント単位に文字起こししてもらうので結果はセグメント単位の配列で返す
  ///
  Future<List<RecordToTextResult>> speechToText(String filePath) async {
    final dio = ref.read(_dioProvider);
    final apiKey = ref.read(appSettingProvider).apiKey;

    try {
      dio.options.headers = {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'multipart/form-data',
      };
      final response = await dio.post(
        'https://api.openai.com/v1/audio/transcriptions',
        data: FormData.fromMap({
          'file': await MultipartFile.fromFile(filePath, filename: _extractFileName(filePath)),
          'model': 'whisper-1',
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.data);
      final segments = responseData['segments'] as List<dynamic>;
      final results = <RecordToTextResult>[];
      for (final segment in segments) {
        final text = segment['text'] as String;
        final startAt = segment['start'] as double;
        results.add(RecordToTextResult(text, DateTime.fromMillisecondsSinceEpoch((startAt * 1000).toInt())));
      }
      return results;
    } on DioException catch (e) {
      AppLogger.e('WhisperAPIでエラー header=${e.response?.headers} \n data=${e.response?.data}', error: e);
      throw HttpException('音声変換処理でエラーが発生しました。\n ${e.response?.data}');
    }
  }

  String _extractFileName(String filePath) => path.basename(filePath);

  Future<String> requestSummary(String text) async {
    final dio = ref.read(_dioProvider);
    final appSetting = ref.read(appSettingProvider);

    try {
      dio.options.headers = {
        'Authorization': 'Bearer ${appSetting.apiKey}',
        'Content-Type': 'application/json',
      };
      final response = await dio.post(
        'https://api.openai.com/v1/chat/completions',
        data: {
          'model': 'gpt-4o',
          'messages': [
            {'role': 'user', 'content': '${appSetting.summaryPrompt} $text'},
          ],
        },
      );
      return response.data['choices'][0]['message']['content'].trim();
    } on DioException catch (e) {
      AppLogger.e('GPT APIでエラー header=${e.response?.headers} \n data=${e.response?.data}', error: e);
      throw HttpException('サマリー処理でエラーが発生しました。\n ${e.response?.data}');
    }
  }
}
