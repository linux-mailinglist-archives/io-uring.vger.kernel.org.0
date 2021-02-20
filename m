Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118203204FE
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 12:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhBTLHm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 06:07:42 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:58577 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229804AbhBTLHa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 06:07:30 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UP0sPUY_1613819205;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UP0sPUY_1613819205)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 20 Feb 2021 19:06:46 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com, axboe@kernel.dk
Cc:     hch@lst.de, ming.lei@redhat.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, io-uring@vger.kernel.org,
        joseph.qi@linux.alibaba.com, caspar@linux.alibaba.com
Subject: [PATCH v4 08/12] dm: always return BLK_QC_T_NONE for bio-based device
Date:   Sat, 20 Feb 2021 19:06:33 +0800
Message-Id: <20210220110637.50305-9-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
References: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently the returned cookie of bio-based device is not used at all.

Cookie of bio-based device will be refactored in the following patch.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8a3d73efb9dd..c2945c90745e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1252,14 +1252,13 @@ void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors)
 }
 EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
 
-static blk_qc_t __map_bio(struct dm_target_io *tio)
+static void __map_bio(struct dm_target_io *tio)
 {
 	int r;
 	sector_t sector;
 	struct bio *clone = &tio->clone;
 	struct dm_io *io = tio->io;
 	struct dm_target *ti = tio->ti;
-	blk_qc_t ret = BLK_QC_T_NONE;
 
 	clone->bi_end_io = clone_endio;
 
@@ -1278,7 +1277,7 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
 	case DM_MAPIO_REMAPPED:
 		/* the bio has been remapped so dispatch it */
 		trace_block_bio_remap(clone, bio_dev(io->orig_bio), sector);
-		ret = submit_bio_noacct(clone);
+		submit_bio_noacct(clone);
 		break;
 	case DM_MAPIO_KILL:
 		free_tio(tio);
@@ -1292,8 +1291,6 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
 		DMWARN("unimplemented target map return value: %d", r);
 		BUG();
 	}
-
-	return ret;
 }
 
 static void bio_setup_sector(struct bio *bio, sector_t sector, unsigned len)
@@ -1380,7 +1377,7 @@ static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
 	}
 }
 
-static blk_qc_t __clone_and_map_simple_bio(struct clone_info *ci,
+static void __clone_and_map_simple_bio(struct clone_info *ci,
 					   struct dm_target_io *tio, unsigned *len)
 {
 	struct bio *clone = &tio->clone;
@@ -1391,7 +1388,7 @@ static blk_qc_t __clone_and_map_simple_bio(struct clone_info *ci,
 	if (len)
 		bio_setup_sector(clone, ci->sector, *len);
 
-	return __map_bio(tio);
+	__map_bio(tio);
 }
 
 static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
@@ -1405,7 +1402,7 @@ static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
 
 	while ((bio = bio_list_pop(&blist))) {
 		tio = container_of(bio, struct dm_target_io, clone);
-		(void) __clone_and_map_simple_bio(ci, tio, len);
+		__clone_and_map_simple_bio(ci, tio, len);
 	}
 }
 
@@ -1450,7 +1447,7 @@ static int __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti,
 		free_tio(tio);
 		return r;
 	}
-	(void) __map_bio(tio);
+	__map_bio(tio);
 
 	return 0;
 }
@@ -1565,11 +1562,10 @@ static void init_clone_info(struct clone_info *ci, struct mapped_device *md,
 /*
  * Entry point to split a bio into clones and submit them to the targets.
  */
-static blk_qc_t __split_and_process_bio(struct mapped_device *md,
+static void __split_and_process_bio(struct mapped_device *md,
 					struct dm_table *map, struct bio *bio)
 {
 	struct clone_info ci;
-	blk_qc_t ret = BLK_QC_T_NONE;
 	int error = 0;
 
 	init_clone_info(&ci, md, map, bio);
@@ -1613,7 +1609,7 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 
 				bio_chain(b, bio);
 				trace_block_split(b, bio->bi_iter.bi_sector);
-				ret = submit_bio_noacct(bio);
+				submit_bio_noacct(bio);
 				break;
 			}
 		}
@@ -1621,13 +1617,11 @@ static blk_qc_t __split_and_process_bio(struct mapped_device *md,
 
 	/* drop the extra reference count */
 	dec_pending(ci.io, errno_to_blk_status(error));
-	return ret;
 }
 
 static blk_qc_t dm_submit_bio(struct bio *bio)
 {
 	struct mapped_device *md = bio->bi_disk->private_data;
-	blk_qc_t ret = BLK_QC_T_NONE;
 	int srcu_idx;
 	struct dm_table *map;
 
@@ -1657,10 +1651,10 @@ static blk_qc_t dm_submit_bio(struct bio *bio)
 	if (is_abnormal_io(bio))
 		blk_queue_split(&bio);
 
-	ret = __split_and_process_bio(md, map, bio);
+	__split_and_process_bio(md, map, bio);
 out:
 	dm_put_live_table(md, srcu_idx);
-	return ret;
+	return BLK_QC_T_NONE;
 }
 
 /*-----------------------------------------------------------------
-- 
2.27.0

