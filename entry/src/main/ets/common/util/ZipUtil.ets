/*
import zlib from '@ohos.zlib';

export default class ZipUtil {
  public static async unzip(compressedData: Uint8Array): Promise<Uint8Array> {
    let options: zlib.Options = {
      level: zlib.CompressLevel.COMPRESS_LEVEL_DEFAULT_COMPRESSION,
      memLevel: zlib.MemLevel.MEM_LEVEL_DEFAULT,
      strategy: zlib.CompressStrategy.COMPRESS_STRATEGY_DEFAULT_STRATEGY
    };
    let unzipResult: zlib.ZlibResult = await zlib.decompressFile(compressedData.toString(), options);
    return unzipResult.data;
  }
}
*/
