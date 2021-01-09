Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A8E2F0150
	for <lists+io-uring@lfdr.de>; Sat,  9 Jan 2021 17:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbhAIQIL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 9 Jan 2021 11:08:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbhAIQII (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 9 Jan 2021 11:08:08 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1482C0617A7;
        Sat,  9 Jan 2021 08:06:55 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id e25so11051015wme.0;
        Sat, 09 Jan 2021 08:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yD8zYkali7maLviDx2WTi8i72ihDIWnJKSJbAu6xfJ0=;
        b=Ts4OoM5bqISNbtmG5sPDsmpk3BTHhh/QjboJ9FjJbTRW6os44a6JWrPaQeIq9a4gzB
         ytPoZ/GW+c8ZRLyy3+gy3UFzrpFfiklRK34zsaVHar6VPLoh+t6didLQ79On2YaXPI61
         pJYMvy+biZXWpv873DXVw0VcAA4BWzd8gzcFFTJKXfdRrqQ5DS5I/WBs9CIv7jzQeFMI
         Hq3iECPsMcVtJgXRMv4wn1o2Hlj3wnnkuWosFYpHehQe35KojPpv+ALObFOb9wY8RLyx
         lHcnE4uGyPIaA5yYJvbSruf6mQkaPTFCw8BRrqy91Lzpf7zZilpiDzluyMd0xwOv21xY
         uFYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yD8zYkali7maLviDx2WTi8i72ihDIWnJKSJbAu6xfJ0=;
        b=oeBGYqW+EAhOqFqgxPFX6WJCGqHZ+JDX1EsheS3j67f4MhBWYTIiiTY9KB5CDWa/QG
         X+tXP0vw+Jncwg8KrXpIyQnb4lt5YS+30VHVVA883M0jTkIx1ylyXFndEK92PXxam2mq
         sCQazQVcFUsJ9XgJ0vNrCpwmdleYMqeMHpiR1PAYODWze1ntqKMj8qGR8DnRuDBvmueD
         h+1WEhQUDR/P0eYGfBRM/7rMEMAwPgvy77c/dnRVcR/3RSuMOAv+efWW3nuxMJABSosr
         Jo9i+rJIFBmAbkkGea5ZPEDIjrkHS3mQQRyyHOhdCFY6PxTDvlsK4cR7sao3APTZcicS
         hjSQ==
X-Gm-Message-State: AOAM53204fXKCtpTwPObRcJPb2FH/gWzxkmLYwDz8CGiVqwcdkYXJbfX
        P8dhy1JfCBMUi8UkTmutV+aBbiqLyusg13AY
X-Google-Smtp-Source: ABdhPJyDJ7ivMuFntSJFW5N+/HuavTp+fJKVSfLb/Mv/WA3X5yhkivHrCndukCuTwkfjMzb7+EAADg==
X-Received: by 2002:a1c:1d1:: with SMTP id 200mr7900279wmb.98.1610208414381;
        Sat, 09 Jan 2021 08:06:54 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id j9sm17403866wrm.14.2021.01.09.08.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 08:06:53 -0800 (PST)
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
Subject: [PATCH v3 7/7] bio: don't copy bvec for direct IO
Date:   Sat,  9 Jan 2021 16:03:03 +0000
Message-Id: <69fef253b37fc44dd28c43398715e27cee5e0fe0.1610170479.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610170479.git.asml.silence@gmail.com>
References: <cover.1610170479.git.asml.silence@gmail.com>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

