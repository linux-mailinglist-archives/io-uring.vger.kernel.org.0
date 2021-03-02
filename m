Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F9732B54F
	for <lists+io-uring@lfdr.de>; Wed,  3 Mar 2021 07:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345353AbhCCGnt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 01:43:49 -0500
Received: from smtp01.tmcz.cz ([93.153.104.112]:33440 "EHLO smtp01.tmcz.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1581887AbhCBT2o (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 2 Mar 2021 14:28:44 -0500
Received: from leontynka.twibright.com (109-183-129-149.customers.tmcz.cz [109.183.129.149])
        by smtp01.tmcz.cz (Postfix) with ESMTPS id 81892405A8;
        Tue,  2 Mar 2021 20:05:56 +0100 (CET)
Received: from debian-a64.vm ([192.168.208.2])
        by leontynka.twibright.com with smtp (Exim 4.92)
        (envelope-from <mpatocka@redhat.com>)
        id 1lHALD-0003kH-7p; Tue, 02 Mar 2021 20:05:56 +0100
Received: by debian-a64.vm (sSMTP sendmail emulation); Tue, 02 Mar 2021 20:05:54 +0100
Message-Id: <20210302190553.961608080@debian-a64.vm>
User-Agent: quilt/0.65
Date:   Tue, 02 Mar 2021 20:05:16 +0100
From:   Mikulas Patocka <mpatocka@redhat.com>
To:     JeffleXu <jefflexu@linux.alibaba.com>,
        Mike Snitzer <msnitzer@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, axboe@kernel.dk,
        caspar@linux.alibaba.com, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
        dm-devel@redhat.com, hch@lst.de
Cc:     Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/4] dm: use submit_bio_noacct_mq_direct
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=dm-submit-bio-mq-direct.patch
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use submit_bio_noacct_mq_direct and pass the returned cookie through the
device mapper stack. The cookie and queue is stored in the structure
clone_info.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2021-03-02 19:24:13.000000000 +0100
+++ linux-2.6/drivers/md/dm.c	2021-03-02 19:25:54.000000000 +0100
@@ -72,6 +72,8 @@ struct clone_info {
 	struct dm_io *io;
 	sector_t sector;
 	unsigned sector_count;
+	blk_qc_t poll_cookie;
+	struct request_queue *poll_queue;
 };
 
 /*
@@ -1294,14 +1296,13 @@ static noinline void __set_swap_bios_lim
 	mutex_unlock(&md->swap_bios_lock);
 }
 
-static blk_qc_t __map_bio(struct dm_target_io *tio)
+static void __map_bio(struct clone_info *ci, struct dm_target_io *tio)
 {
 	int r;
 	sector_t sector;
 	struct bio *clone = &tio->clone;
 	struct dm_io *io = tio->io;
 	struct dm_target *ti = tio->ti;
-	blk_qc_t ret = BLK_QC_T_NONE;
 
 	clone->bi_end_io = clone_endio;
 
@@ -1328,7 +1329,14 @@ static blk_qc_t __map_bio(struct dm_targ
 	case DM_MAPIO_REMAPPED:
 		/* the bio has been remapped so dispatch it */
 		trace_block_bio_remap(clone, bio_dev(io->orig_bio), sector);
-		ret = submit_bio_noacct(clone);
+		if (clone->bi_opf & REQ_HIPRI &&
+		    test_bit(QUEUE_FLAG_POLL, &clone->bi_bdev->bd_disk->queue->queue_flags)) {
+			ci->poll_queue = clone->bi_bdev->bd_disk->queue;
+			ci->poll_cookie = submit_bio_noacct_mq_direct(clone);
+		} else {
+			ci->poll_cookie = BLK_QC_T_NONE;
+			submit_bio_noacct(clone);
+		}
 		break;
 	case DM_MAPIO_KILL:
 		if (unlikely(swap_bios_limit(ti, clone))) {
@@ -1350,8 +1358,6 @@ static blk_qc_t __map_bio(struct dm_targ
 		DMWARN("unimplemented target map return value: %d", r);
 		BUG();
 	}
-
-	return ret;
 }
 
 static void bio_setup_sector(struct bio *bio, sector_t sector, unsigned len)
@@ -1438,8 +1444,8 @@ static void alloc_multiple_bios(struct b
 	}
 }
 
-static blk_qc_t __clone_and_map_simple_bio(struct clone_info *ci,
-					   struct dm_target_io *tio, unsigned *len)
+static void __clone_and_map_simple_bio(struct clone_info *ci,
+				       struct dm_target_io *tio, unsigned *len)
 {
 	struct bio *clone = &tio->clone;
 
@@ -1449,7 +1455,7 @@ static blk_qc_t __clone_and_map_simple_b
 	if (len)
 		bio_setup_sector(clone, ci->sector, *len);
 
-	return __map_bio(tio);
+	__map_bio(ci, tio);
 }
 
 static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
@@ -1463,7 +1469,7 @@ static void __send_duplicate_bios(struct
 
 	while ((bio = bio_list_pop(&blist))) {
 		tio = container_of(bio, struct dm_target_io, clone);
-		(void) __clone_and_map_simple_bio(ci, tio, len);
+		__clone_and_map_simple_bio(ci, tio, len);
 	}
 }
 
@@ -1507,7 +1513,7 @@ static int __clone_and_map_data_bio(stru
 		free_tio(tio);
 		return r;
 	}
-	(void) __map_bio(tio);
+	__map_bio(ci, tio);
 
 	return 0;
 }
@@ -1614,6 +1620,7 @@ static void init_clone_info(struct clone
 	ci->map = map;
 	ci->io = alloc_io(md, bio);
 	ci->sector = bio->bi_iter.bi_sector;
+	ci->poll_cookie = BLK_QC_T_NONE;
 }
 
 #define __dm_part_stat_sub(part, field, subnd)	\
@@ -1622,11 +1629,10 @@ static void init_clone_info(struct clone
 /*
  * Entry point to split a bio into clones and submit them to the targets.
  */
-static blk_qc_t __split_and_process_bio(struct mapped_device *md,
-					struct dm_table *map, struct bio *bio)
+static void __split_and_process_bio(struct mapped_device *md,
+				    struct dm_table *map, struct bio *bio)
 {
 	struct clone_info ci;
-	blk_qc_t ret = BLK_QC_T_NONE;
 	int error = 0;
 
 	init_clone_info(&ci, md, map, bio);
@@ -1643,7 +1649,7 @@ static blk_qc_t __split_and_process_bio(
 		ci.sector_count = bio_sectors(bio);
 		while (ci.sector_count && !error) {
 			error = __split_and_process_non_flush(&ci);
-			if (ci.sector_count && !error) {
+			if (ci.sector_count && !error && ci.poll_cookie == BLK_QC_T_NONE) {
 				/*
 				 * Remainder must be passed to submit_bio_noacct()
 				 * so that it gets handled *after* bios already submitted
@@ -1670,7 +1676,7 @@ static blk_qc_t __split_and_process_bio(
 
 				bio_chain(b, bio);
 				trace_block_split(b, bio->bi_iter.bi_sector);
-				ret = submit_bio_noacct(bio);
+				submit_bio_noacct(bio);
 				break;
 			}
 		}
@@ -1678,13 +1684,11 @@ static blk_qc_t __split_and_process_bio(
 
 	/* drop the extra reference count */
 	dec_pending(ci.io, errno_to_blk_status(error));
-	return ret;
 }
 
 static blk_qc_t dm_submit_bio(struct bio *bio)
 {
 	struct mapped_device *md = bio->bi_bdev->bd_disk->private_data;
-	blk_qc_t ret = BLK_QC_T_NONE;
 	int srcu_idx;
 	struct dm_table *map;
 
@@ -1714,10 +1718,10 @@ static blk_qc_t dm_submit_bio(struct bio
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

