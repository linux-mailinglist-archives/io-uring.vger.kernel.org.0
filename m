Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5477814E78C
	for <lists+io-uring@lfdr.de>; Fri, 31 Jan 2020 04:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727862AbgAaDYc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jan 2020 22:24:32 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:36962 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727827AbgAaDYc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jan 2020 22:24:32 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00V3OF1U103343;
        Fri, 31 Jan 2020 03:24:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=l9hUgRK0V/NRr4OBeHPntBsGqb1NSJaEDc6zkT+aOCY=;
 b=rwKSSenVWu+mtFmLb/oeqVPv8Ee95LieNUKKIxP4PJqp0EY8DIkcHvhkhnEHiWQaZU/l
 c/vG8oaZSbtxM1RxBAJ8QqXlP857vWceBeL41cYs9mlGZMHFJAVf6UbBQcPi7uwZcGT+
 7IMjEHxmFRMnZqSTgl3LrNic4d4FBCAaYypOfESjIcbHCQSMBbHRM9guppQzIDLfcP+3
 w+tFL+kZv+E3f9Ms/u6UCkiyp5+3XL4DuOnLoULTeStKS1TWVGG0fee9GsL3zdl/kwtb
 uOcHyUXN2InuicJpsQ16zgyc5cY0hiDGLvfQQ9thsLcBsPkXtb2MVvG2cBoJrtz41dWK ow== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xrdmqyya5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 03:24:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00V3OJmZ155599;
        Fri, 31 Jan 2020 03:24:28 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xv9bvmbbh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 03:24:22 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00V3NuLq023706;
        Fri, 31 Jan 2020 03:23:56 GMT
Received: from ca-ldom147.us.oracle.com (/10.129.68.131)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Jan 2020 19:23:56 -0800
From:   Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH 1/1] block: Manage bio references so the bio persists until necessary
Date:   Thu, 30 Jan 2020 19:23:42 -0800
Message-Id: <1580441022-59129-2-git-send-email-bijan.mottahedeh@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1580441022-59129-1-git-send-email-bijan.mottahedeh@oracle.com>
References: <1580441022-59129-1-git-send-email-bijan.mottahedeh@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001310028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001310028
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Get a reference to a bio, so it won't be freed if end_io() gets to
it before submit_io() returns.  Defer the release of the first bio
in a mult-bio request until the last end_io() since the first bio is
embedded in the dio structure and must therefore persist through an
entire multi-bio request.

Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
---
 fs/block_dev.c | 78 ++++++++++++++++++++++++++++++----------------------------
 1 file changed, 40 insertions(+), 38 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 69bf2fb..19fff6b 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -303,7 +303,9 @@ static void blkdev_bio_end_io(struct bio *bio)
 	if (bio->bi_status && !dio->bio.bi_status)
 		dio->bio.bi_status = bio->bi_status;
 
-	if (!dio->multi_bio || atomic_dec_and_test(&dio->ref)) {
+	if (atomic_dec_and_test(&dio->ref)) {
+		if (dio->multi_bio)
+			bio_put(&dio->bio);
 		if (!dio->is_sync) {
 			struct kiocb *iocb = dio->iocb;
 			ssize_t ret;
@@ -316,8 +318,6 @@ static void blkdev_bio_end_io(struct bio *bio)
 			}
 
 			dio->iocb->ki_complete(iocb, ret, 0);
-			if (dio->multi_bio)
-				bio_put(&dio->bio);
 		} else {
 			struct task_struct *waiter = dio->waiter;
 
@@ -348,6 +348,7 @@ static void blkdev_bio_end_io(struct bio *bio)
 	loff_t pos = iocb->ki_pos;
 	blk_qc_t qc = BLK_QC_T_NONE;
 	int ret = 0;
+	int nr_bios = 1;
 
 	if ((pos | iov_iter_alignment(iter)) &
 	    (bdev_logical_block_size(bdev) - 1))
@@ -357,16 +358,15 @@ static void blkdev_bio_end_io(struct bio *bio)
 
 	dio = container_of(bio, struct blkdev_dio, bio);
 	dio->is_sync = is_sync = is_sync_kiocb(iocb);
-	if (dio->is_sync) {
+	if (dio->is_sync)
 		dio->waiter = current;
-		bio_get(bio);
-	} else {
+	else
 		dio->iocb = iocb;
-	}
 
 	dio->size = 0;
 	dio->multi_bio = false;
 	dio->should_dirty = is_read && iter_is_iovec(iter);
+	atomic_set(&dio->ref, 1);
 
 	/*
 	 * Don't plug for HIPRI/polled IO, as those should go straight
@@ -375,7 +375,7 @@ static void blkdev_bio_end_io(struct bio *bio)
 	if (!is_poll)
 		blk_start_plug(&plug);
 
-	for (;;) {
+	do {
 		bio_set_dev(bio, bdev);
 		bio->bi_iter.bi_sector = pos >> 9;
 		bio->bi_write_hint = iocb->ki_hint;
@@ -403,62 +403,64 @@ static void blkdev_bio_end_io(struct bio *bio)
 		pos += bio->bi_iter.bi_size;
 
 		nr_pages = iov_iter_npages(iter, BIO_MAX_PAGES);
-		if (!nr_pages) {
-			bool polled = false;
+		if (!nr_pages && is_poll)
+			bio_set_polled(bio, iocb);
 
-			if (iocb->ki_flags & IOCB_HIPRI) {
-				bio_set_polled(bio, iocb);
-				polled = true;
-			}
+		/*
+		 * Get a reference to a bio, so it won't be freed
+		 * if end_io() gets to it before submit_io() returns.
+		 * Defer the release of the first bio in a mult-bio
+		 * request until the last end_io() since the first bio
+		 * is embedded in the dio structure and must therefore
+		 * persist through an entire multi-bio request.
+		 */
+		bio_get(bio);
 
-			qc = submit_bio(bio);
+		qc = submit_bio(bio);
 
-			if (polled)
-				WRITE_ONCE(iocb->ki_cookie, qc);
-			break;
-		}
+		if (bio->bi_opf & REQ_HIPRI)
+			WRITE_ONCE(iocb->ki_cookie, qc);
 
-		if (!dio->multi_bio) {
-			/*
-			 * AIO needs an extra reference to ensure the dio
-			 * structure which is embedded into the first bio
-			 * stays around.
-			 */
-			if (!is_sync)
-				bio_get(bio);
-			dio->multi_bio = true;
-			atomic_set(&dio->ref, 2);
-		} else {
+		if (nr_pages) {
+			if (++nr_bios == 2)
+				dio->multi_bio = true;
+			else
+				bio_put(bio);
+			bio = bio_alloc(GFP_KERNEL, nr_pages);
 			atomic_inc(&dio->ref);
 		}
-
-		submit_bio(bio);
-		bio = bio_alloc(GFP_KERNEL, nr_pages);
-	}
+	} while (nr_pages);
 
 	if (!is_poll)
 		blk_finish_plug(&plug);
 
-	if (!is_sync)
-		return -EIOCBQUEUED;
+	if (!is_sync) {
+		ret = -EIOCBQUEUED;
+		goto done;
+	}
+
+	if (!blk_qc_t_valid(qc))
+		goto done;
 
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		if (!READ_ONCE(dio->waiter))
 			break;
 
-		if (!(iocb->ki_flags & IOCB_HIPRI) ||
+		if (!is_poll ||
 		    !blk_poll(bdev_get_queue(bdev), qc, true))
 			io_schedule();
 	}
 	__set_current_state(TASK_RUNNING);
 
+done:
 	if (!ret)
 		ret = blk_status_to_errno(dio->bio.bi_status);
 	if (likely(!ret))
 		ret = dio->size;
 
-	bio_put(&dio->bio);
+	if (!dio->multi_bio)
+		bio_put(&dio->bio);
 	return ret;
 }
 
-- 
1.8.3.1

