Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916CC2E87D6
	for <lists+io-uring@lfdr.de>; Sat,  2 Jan 2021 16:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbhABPWp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Jan 2021 10:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbhABPWo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Jan 2021 10:22:44 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC17FC0617A0;
        Sat,  2 Jan 2021 07:21:32 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id 190so13178531wmz.0;
        Sat, 02 Jan 2021 07:21:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ohSIp5ePWaz1w6S32NBHT2NvcCAqeYKdn5igq7tNqQI=;
        b=BEIk7nboPHlTUjalpiV3UauYsn/+YIZ6ApV/a38QtTCGDFE0O0B8g5OUqEAzD9RpBU
         4nEM1qUGqsT8eVyKzZAXQXLjn7IRF2yLm0LxjbPlM+YimGIAqRNVEsuQ5SFBU6Ft1eP4
         cnkJZMfEWLl0j8yTOmzIPIitBUzk5/8iLVC84bsdTjITUER+RBIa0ezp6VUSCi4cb/Jx
         Niag469Wd+k1znOnEhBPozfImiBQJERxwYLg2CO3Y5P4ILqQSf0atKKCFpPt79+xrbMs
         81XqOQ7+NWeMTOEogSAur2iWee0K7sd1Jo89zWpwI2d0LnbvIDpGg7hhk2E9oD0TGx8R
         pgYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ohSIp5ePWaz1w6S32NBHT2NvcCAqeYKdn5igq7tNqQI=;
        b=r2LGmWaE63WmKZMDJvJB8Yx3FSm0I8TVNSZRXLEMU9gvTEx6Ts7jcgsQgSBGaufUSV
         2JclfgLZiQ1TKwzHciYhaY01MvxJK+yjwhp8rdjxTqnkViOVECjC15iCIwbyk/0+DPqV
         kKQPw7CvXHVJF2SVEFFyGgePCU1buCP5m+AsiMI8HcOCvAofQkppqAaLdkvOFX1LCIcB
         pFwZ+OW9HUq/tr8n/fWLtVg4UCHDvg4DVcsbniHfOsmEQQNmRgPYBJQMtAZ/0RaVXu7L
         wYiyCB1Z93TwWlGrJg1sLh/rQvKyGuHHLl0RNR1nYKweysSwVCTiwNRdgOPkOWb+4rvn
         10eA==
X-Gm-Message-State: AOAM530at121qgHiITvtFOfvauHCF8J7cD7ELwNkZSB805JJWCHyG5oJ
        SW9G88A9TkyiRq4NlDsBEFMm2/Ia6m7ndA==
X-Google-Smtp-Source: ABdhPJzRenSPI7p3GZoaEGEzPmw1o/yknelNfIvXGv60hGl85AWy2eJbIcUd/1xqAOFCbX3npNieyw==
X-Received: by 2002:a7b:c35a:: with SMTP id l26mr19162941wmj.182.1609600891440;
        Sat, 02 Jan 2021 07:21:31 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.0])
        by smtp.gmail.com with ESMTPSA id h13sm78671243wrm.28.2021.01.02.07.21.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 07:21:31 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     linux-block@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Ming Lei <ming.lei@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 6/7] bio: add a helper calculating nr segments to alloc
Date:   Sat,  2 Jan 2021 15:17:38 +0000
Message-Id: <d99ddca2d89b9630a64b439a672d2513f77a221d.1609461359.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609461359.git.asml.silence@gmail.com>
References: <cover.1609461359.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a helper function calculating the number of bvec segments we need to
allocate to construct a bio. It doesn't change anything functionally,
but will be used to not duplicate special cases in the future.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/block_dev.c       |  7 ++++---
 fs/iomap/direct-io.c |  9 ++++-----
 include/linux/bio.h  | 10 ++++++++++
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 3e5b02f6606c..034e6c8cfcab 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -416,7 +416,7 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 		dio->size += bio->bi_iter.bi_size;
 		pos += bio->bi_iter.bi_size;
 
-		nr_pages = iov_iter_npages(iter, BIO_MAX_PAGES);
+		nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_PAGES);
 		if (!nr_pages) {
 			bool polled = false;
 
@@ -481,9 +481,10 @@ blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 {
 	int nr_pages;
 
-	nr_pages = iov_iter_npages(iter, BIO_MAX_PAGES + 1);
-	if (!nr_pages)
+	if (!iov_iter_count(iter))
 		return 0;
+
+	nr_pages = bio_iov_vecs_to_alloc(iter, BIO_MAX_PAGES + 1);
 	if (is_sync_kiocb(iocb) && nr_pages <= BIO_MAX_PAGES)
 		return __blkdev_direct_IO_simple(iocb, iter, nr_pages);
 
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 933f234d5bec..ea1e8f696076 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -250,11 +250,8 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 	orig_count = iov_iter_count(dio->submit.iter);
 	iov_iter_truncate(dio->submit.iter, length);
 
-	nr_pages = iov_iter_npages(dio->submit.iter, BIO_MAX_PAGES);
-	if (nr_pages <= 0) {
-		ret = nr_pages;
+	if (!iov_iter_count(dio->submit.iter))
 		goto out;
-	}
 
 	if (need_zeroout) {
 		/* zero out from the start of the block to the write offset */
@@ -263,6 +260,7 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 			iomap_dio_zero(dio, iomap, pos - pad, pad);
 	}
 
+	nr_pages = bio_iov_vecs_to_alloc(dio->submit.iter, BIO_MAX_PAGES);
 	do {
 		size_t n;
 		if (dio->error) {
@@ -308,7 +306,8 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 		dio->size += n;
 		copied += n;
 
-		nr_pages = iov_iter_npages(dio->submit.iter, BIO_MAX_PAGES);
+		nr_pages = bio_iov_vecs_to_alloc(dio->submit.iter,
+						 BIO_MAX_PAGES);
 		iomap_dio_submit_bio(dio, iomap, bio, pos);
 		pos += n;
 	} while (nr_pages);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 1edda614f7ce..d8f9077c43ef 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -10,6 +10,7 @@
 #include <linux/ioprio.h>
 /* struct bio, bio_vec and BIO_* flags are defined in blk_types.h */
 #include <linux/blk_types.h>
+#include <linux/uio.h>
 
 #define BIO_DEBUG
 
@@ -441,6 +442,15 @@ static inline void bio_wouldblock_error(struct bio *bio)
 	bio_endio(bio);
 }
 
+/*
+ * Calculate number of bvec segments that should be allocated to fit data
+ * pointed by @iter.
+ */
+static inline int bio_iov_vecs_to_alloc(struct iov_iter *iter, int max_segs)
+{
+	return iov_iter_npages(iter, max_segs);
+}
+
 struct request_queue;
 
 extern int submit_bio_wait(struct bio *bio);
-- 
2.24.0

