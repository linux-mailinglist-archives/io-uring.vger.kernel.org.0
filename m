Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C402F0140
	for <lists+io-uring@lfdr.de>; Sat,  9 Jan 2021 17:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbhAIQIK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Jan 2021 11:08:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbhAIQII (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Jan 2021 11:08:08 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C274C0617A6;
        Sat,  9 Jan 2021 08:06:54 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id i9so11920379wrc.4;
        Sat, 09 Jan 2021 08:06:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RwZZxMhI82qZ1NGjjWs3i9PNzY6l2vY31jXhvq/2jzI=;
        b=Ttko+RVGU3n5aJcKu+1ljJRmO0ZoHSASRWTCu9NUBLQwvAMVtJm4xDctv0HVgar+fN
         j1+FVNn31Se10pLKpcqpfLj8k/U/bCPpLxmbmyG9XhOQyBjS0P2EzY+bpgmi+CuQUrhJ
         WIGEIL+T1d4wzj8RPH1EjE4HYVpzd83UevIJJNOzJAvvhyRCV9gTTPu/DFakNUBhjPUE
         6YAc1X5PQF2GEWeLQfCtAjB499ILo9qLgoWgjQm1uq5kYEoxQ6UI0jSz1HOqcEDSpjJd
         uY01F6EMQsqPI6ykkfpm8TNw/LNJIbIiD1vvLsZRCX6bzgxA5GWTjxPV4bsYNY4Ny2/9
         EEYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RwZZxMhI82qZ1NGjjWs3i9PNzY6l2vY31jXhvq/2jzI=;
        b=fLFT8G3T/77dDHC+cFDrKkF1EG+/9I/IJ4lTztV4/r5D1H+7Y3jRtoajbsurVSWJ2f
         W5raIE9/GDGDeWVZYd47sTHa9dqKRY1qp/YaGFLoZqbwKNSfAJSzKKpGa1GUSIV0x9ai
         mPn0YWOAfysDskRRoFeMNTEzjTddoeJTgR2V0tieJSAyycH/i/eYS0k3h+jH0c4R4fEw
         U8V3yXSKZoPtmI1+rvyqhtO9++QHbYfTZtm03wWaBFvTgPeJcB5ydet/mTSu0GWAA6GO
         KjKjeOnns01Nv9mYsN2qx15vo7qALiV3rq3OyVa1l2PQXgd8CcY2gYzBL+zz9quzgVlW
         zn8w==
X-Gm-Message-State: AOAM530ZIUsnWvTA29TU4Qn5NUjtMO5Dtzut524QEOGriHtEIbkBRe8T
        ZUJaU5l0PP1zV0spzizLFiB3n9DUC9Fa1sxM
X-Google-Smtp-Source: ABdhPJzoUjsfyBMMnqeq2r+2TVEKl5UD3aKgPfvVrdJFCjILudq2jNC955I3gsW4LTeZMtylLSyYdw==
X-Received: by 2002:a5d:4a44:: with SMTP id v4mr8956687wrs.106.1610208412908;
        Sat, 09 Jan 2021 08:06:52 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id j9sm17403866wrm.14.2021.01.09.08.06.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 08:06:52 -0800 (PST)
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
Subject: [PATCH v3 6/7] bio: add a helper calculating nr segments to alloc
Date:   Sat,  9 Jan 2021 16:03:02 +0000
Message-Id: <cde94f6cc32bd8a899129575678c4195f7cb187b.1610170479.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610170479.git.asml.silence@gmail.com>
References: <cover.1610170479.git.asml.silence@gmail.com>
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
index 3b8963e228a1..6f5bd9950baf 100644
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

