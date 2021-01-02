Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 967272E87E8
	for <lists+io-uring@lfdr.de>; Sat,  2 Jan 2021 16:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbhABPW5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Jan 2021 10:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbhABPWq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Jan 2021 10:22:46 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C95BC0617A1;
        Sat,  2 Jan 2021 07:21:34 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id g185so13756370wmf.3;
        Sat, 02 Jan 2021 07:21:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3l7dQjIvN+V+hEfZaCkzKb+BBnG/zeqm2g1H963d/fU=;
        b=hKs4d/TU2wMEjpAXrytigQChKkUEsSDMoqcebeDllsKjoNG/spLXHO3ytny4jEZjuZ
         NcLxLnXZKDqEH9Uj2glbOUxlmtYSXcbYEEbzmRPtNysnmvxO4yeCEfgncm951hEtOUZ1
         hzlJX09+eupyD4mtHblxJyOVZVwMKlcxcxD9nbw8GLsoh0Xym5yPfV9pg84AivjTPr3M
         a/yRyBwqMg6H/mJJ7/smc9rug0a80eRO6vJufbqg30jGrxcEEzL17qwrBGvdMV3jX7RK
         bzucefWdFbQBUZa9GTb4HqOHSwqVZBOZ4y+ECy+X8wyJr0JlAbTMarl7wqY4+bShvhwm
         eYZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3l7dQjIvN+V+hEfZaCkzKb+BBnG/zeqm2g1H963d/fU=;
        b=PhV45bzipliA8mXI/XqaQM6i22c87cathRqUyufcW3oIkqu55WKM8UugZbhVq/k5rJ
         qMLgLA+Ux+bUTojEAIyeAzNIr4H5Wc0VbiO8vDex39Vkv8oZzLhP5Hq4W3GU72b3cS7m
         guXI9528lhEacJQSWGwjs36YVrah1L6cXK1/ltT1g6aLpODNGRpsaCYsq2HbRz006GIL
         +I6ZqLvH3kZYWuz5xFl9sQfaHWHxc6g8vrqRvuBHIb65s3wPWyjgceAFR2sa4ib9NaSb
         NdBf1Xelty81sxIkmivCHDUHAqg4mPSBmlwcOFjrkSbE5oQzKS4YZGuCggDKYgd8L94R
         Zm1w==
X-Gm-Message-State: AOAM530CBfJoevVAQqaN5+mtT6MvmEehDRy6n/thOO0ffJZ1zS7ZEJ77
        W2qyCEXMHcFeeGpODNXlMDa1aGNu3MlnDg==
X-Google-Smtp-Source: ABdhPJwGhnMFbzLGsmTiJIkT4AO1maR288iVD0rGXhF6tvzkOS5GoZ/R3t3iUBUVe2FW5oIam/JQSg==
X-Received: by 2002:a1c:43c6:: with SMTP id q189mr19936956wma.7.1609600893086;
        Sat, 02 Jan 2021 07:21:33 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.0])
        by smtp.gmail.com with ESMTPSA id h13sm78671243wrm.28.2021.01.02.07.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 07:21:32 -0800 (PST)
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
        linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH v2 7/7] bio: don't copy bvec for direct IO
Date:   Sat,  2 Jan 2021 15:17:39 +0000
Message-Id: <29ed343fa15eb4139f8ab9104d3f9b16fe025dfd.1609461359.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609461359.git.asml.silence@gmail.com>
References: <cover.1609461359.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The block layer spends quite a while in blkdev_direct_IO() to copy and
initialise bio's bvec. However, if we've already got a bvec in the input
iterator it might be reused in some cases, i.e. when new
ITER_BVEC_FLAG_FIXED flag is set. Simple tests show considerable
performance boost, and it also reduces memory footprint.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 Documentation/filesystems/porting.rst |  9 ++++
 block/bio.c                           | 67 ++++++++++++---------------
 include/linux/bio.h                   |  5 +-
 3 files changed, 42 insertions(+), 39 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index c722d94f29ea..1f8cf8e10b34 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -872,3 +872,12 @@ its result is kern_unmount() or kern_unmount_array().
 
 zero-length bvec segments are disallowed, they must be filtered out before
 passed on to an iterator.
+
+---
+
+**mandatory**
+
+For bvec based itererators bio_iov_iter_get_pages() now doesn't copy bvecs but
+uses the one provided. Anyone issuing kiocb-I/O should ensure that the bvec and
+page references stay until I/O has completed, i.e. until ->ki_complete() has
+been called or returned with non -EIOCBQUEUED code.
diff --git a/block/bio.c b/block/bio.c
index 9f26984af643..6f031a04b59a 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -960,21 +960,17 @@ void bio_release_pages(struct bio *bio, bool mark_dirty)
 }
 EXPORT_SYMBOL_GPL(bio_release_pages);
 
-static int __bio_iov_bvec_add_pages(struct bio *bio, struct iov_iter *iter)
+static int bio_iov_bvec_set(struct bio *bio, struct iov_iter *iter)
 {
-	const struct bio_vec *bv = iter->bvec;
-	unsigned int len;
-	size_t size;
-
-	if (WARN_ON_ONCE(iter->iov_offset > bv->bv_len))
-		return -EINVAL;
-
-	len = min_t(size_t, bv->bv_len - iter->iov_offset, iter->count);
-	size = bio_add_page(bio, bv->bv_page, len,
-				bv->bv_offset + iter->iov_offset);
-	if (unlikely(size != len))
-		return -EINVAL;
-	iov_iter_advance(iter, size);
+	WARN_ON_ONCE(BVEC_POOL_IDX(bio) != 0);
+
+	bio->bi_vcnt = iter->nr_segs;
+	bio->bi_max_vecs = iter->nr_segs;
+	bio->bi_io_vec = (struct bio_vec *)iter->bvec;
+	bio->bi_iter.bi_bvec_done = iter->iov_offset;
+	bio->bi_iter.bi_size = iter->count;
+
+	iov_iter_advance(iter, iter->count);
 	return 0;
 }
 
@@ -1088,12 +1084,12 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
  * This takes either an iterator pointing to user memory, or one pointing to
  * kernel pages (BVEC iterator). If we're adding user pages, we pin them and
  * map them into the kernel. On IO completion, the caller should put those
- * pages. If we're adding kernel pages, and the caller told us it's safe to
- * do so, we just have to add the pages to the bio directly. We don't grab an
- * extra reference to those pages (the user should already have that), and we
- * don't put the page on IO completion. The caller needs to check if the bio is
- * flagged BIO_NO_PAGE_REF on IO completion. If it isn't, then pages should be
- * released.
+ * pages. For bvec based iterators bio_iov_iter_get_pages() uses the provided
+ * bvecs rather than copying them. Hence anyone issuing kiocb based IO needs
+ * to ensure the bvecs and pages stay referenced until the submitted I/O is
+ * completed by a call to ->ki_complete() or returns with an error other than
+ * -EIOCBQUEUED. The caller needs to check if the bio is flagged BIO_NO_PAGE_REF
+ * on IO completion. If it isn't, then pages should be released.
  *
  * The function tries, but does not guarantee, to pin as many pages as
  * fit into the bio, or are requested in @iter, whatever is smaller. If
@@ -1105,27 +1101,22 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
  */
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 {
-	const bool is_bvec = iov_iter_is_bvec(iter);
-	int ret;
-
-	if (WARN_ON_ONCE(bio->bi_vcnt))
-		return -EINVAL;
+	int ret = 0;
 
-	do {
-		if (bio_op(bio) == REQ_OP_ZONE_APPEND) {
-			if (WARN_ON_ONCE(is_bvec))
-				return -EINVAL;
-			ret = __bio_iov_append_get_pages(bio, iter);
-		} else {
-			if (is_bvec)
-				ret = __bio_iov_bvec_add_pages(bio, iter);
+	if (iov_iter_is_bvec(iter)) {
+		if (WARN_ON_ONCE(bio_op(bio) == REQ_OP_ZONE_APPEND))
+			return -EINVAL;
+		bio_iov_bvec_set(bio, iter);
+		bio_set_flag(bio, BIO_NO_PAGE_REF);
+		return 0;
+	} else {
+		do {
+			if (bio_op(bio) == REQ_OP_ZONE_APPEND)
+				ret = __bio_iov_append_get_pages(bio, iter);
 			else
 				ret = __bio_iov_iter_get_pages(bio, iter);
-		}
-	} while (!ret && iov_iter_count(iter) && !bio_full(bio, 0));
-
-	if (is_bvec)
-		bio_set_flag(bio, BIO_NO_PAGE_REF);
+		} while (!ret && iov_iter_count(iter) && !bio_full(bio, 0));
+	}
 
 	/* don't account direct I/O as memory stall */
 	bio_clear_flag(bio, BIO_WORKINGSET);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index d8f9077c43ef..1d30572a8c53 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -444,10 +444,13 @@ static inline void bio_wouldblock_error(struct bio *bio)
 
 /*
  * Calculate number of bvec segments that should be allocated to fit data
- * pointed by @iter.
+ * pointed by @iter. If @iter is backed by bvec it's going to be reused
+ * instead of allocating a new one.
  */
 static inline int bio_iov_vecs_to_alloc(struct iov_iter *iter, int max_segs)
 {
+	if (iov_iter_is_bvec(iter))
+		return 0;
 	return iov_iter_npages(iter, max_segs);
 }
 
-- 
2.24.0

