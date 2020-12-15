Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F8C2DA4AD
	for <lists+io-uring@lfdr.de>; Tue, 15 Dec 2020 01:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728115AbgLOAZe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Dec 2020 19:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728755AbgLOAZY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Dec 2020 19:25:24 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C80DFC061282;
        Mon, 14 Dec 2020 16:24:11 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id y17so18129652wrr.10;
        Mon, 14 Dec 2020 16:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=atVGnGnKX0+QWRcHgwbeiUpqoMrtsuGF8OD/ap3yMV0=;
        b=u+zjC4RjWtSd1EVEtSggrw5x/fzyJXtB05ocK2DmCyHbvHdbAjSYxqLG/aQQ/1SN7+
         v8zcHxWf3G+8vVngFW8HMhPd4JY2HkvboHm3n5Pb04oWacCx+zManfJ+/QEd3911HPgi
         5VgZYb+6nxuhmIlsEbRI8AUA0I1FGrZZlsVfA5jTjyqLOp/nV2w29yuWXPkRlUcJWDpP
         4d7OeUsozBCiZNZFfhlcizeVjluwsy8qgAwJf3Y/uJOLfdRI7DjoIRBGKd2S+0Yv9ddS
         nhAy6A+Ovk//nWdeGQ/vYQc5ldTzOEXOsG45nqJlWDD4IABVlHzYKw6sdiv00OUaDbOo
         oTlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=atVGnGnKX0+QWRcHgwbeiUpqoMrtsuGF8OD/ap3yMV0=;
        b=P4b0RQrWgJOlf89pTppOa6bd58Ig4/i9gNEELgnL2ndcqrypiHf62srVG6cEhD0rzB
         tgHUAVsUeEt2YikzzToYTAxO0J4utwCDVNcu09m/lLYrLiz0wi3KDSmxMM9yv39qdvlC
         o4S7hEJPsPmbGX2QO0Je2zPCZKcQ+fU6MSnOiNPLUimpSxrj6CW2Xc2faqhkCTuDRVXh
         f7/aeHLyWr7VwTbLuNJ9seutqYaT5hsYxG6M3XpqWcSBnisP7BNimczqSwk6EIPPDZEC
         VrROe5dakfiEjFNDa53iNcccrC0tdET9jCsgG3i+2UXvCRXqXSMxfDj09HtgxBdRJD8r
         g3Tg==
X-Gm-Message-State: AOAM53262akUQov4R5/c2dtwtkg7s5/8CtK1FGeG2oTHR2USIeFcbz1e
        9bg2Qd0Dphtlp8ggyxGjHbERX3tQdCAOBeID
X-Google-Smtp-Source: ABdhPJzD6TNgMT/l5rfeMAyPUUuqa5EHPZa+zhYb6kKMMDi0EGqLG8qd52Qk85eB5WU9zWrxCo1MOg==
X-Received: by 2002:adf:f18a:: with SMTP id h10mr33264191wro.244.1607991850205;
        Mon, 14 Dec 2020 16:24:10 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.163])
        by smtp.gmail.com with ESMTPSA id b19sm5362012wmj.37.2020.12.14.16.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 16:24:09 -0800 (PST)
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
Subject: [PATCH v1 6/6] block/iomap: don't copy bvec for direct IO
Date:   Tue, 15 Dec 2020 00:20:25 +0000
Message-Id: <498b34d746627e874740d8315b2924880c46dbc3.1607976425.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1607976425.git.asml.silence@gmail.com>
References: <cover.1607976425.git.asml.silence@gmail.com>
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
 block/bio.c                           | 64 +++++++++++----------------
 include/linux/bio.h                   |  3 ++
 3 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/Documentation/filesystems/porting.rst b/Documentation/filesystems/porting.rst
index 867036aa90b8..47a622879952 100644
--- a/Documentation/filesystems/porting.rst
+++ b/Documentation/filesystems/porting.rst
@@ -865,3 +865,12 @@ no matter what.  Everything is handled by the caller.
 
 clone_private_mount() returns a longterm mount now, so the proper destructor of
 its result is kern_unmount() or kern_unmount_array().
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
index 3192358c411f..f8229be24562 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -960,25 +960,16 @@ void bio_release_pages(struct bio *bio, bool mark_dirty)
 }
 EXPORT_SYMBOL_GPL(bio_release_pages);
 
-static int __bio_iov_bvec_add_pages(struct bio *bio, struct iov_iter *iter)
+static int bio_iov_bvec_set(struct bio *bio, struct iov_iter *iter)
 {
-	const struct bio_vec *bv = iter->bvec;
-	struct page *page = bv->bv_page;
-	bool same_page = false;
-	unsigned int off, len;
-
-	if (WARN_ON_ONCE(iter->iov_offset > bv->bv_len))
-		return -EINVAL;
-
-	len = min_t(size_t, bv->bv_len - iter->iov_offset, iter->count);
-	off = bv->bv_offset + iter->iov_offset;
-
-	if (!__bio_try_merge_page(bio, page, len, off, &same_page)) {
-		if (bio_full(bio, len))
-			return -EINVAL;
-		bio_add_page_noaccount(bio, page, len, off);
-	}
-	iov_iter_advance(iter, len);
+	WARN_ON_ONCE(BVEC_POOL_IDX(bio) != 0);
+	bio->bi_vcnt = iter->nr_segs;
+	bio->bi_max_vecs = iter->nr_segs;
+	bio->bi_io_vec = (struct bio_vec *)iter->bvec;
+	bio->bi_iter.bi_bvec_done = iter->iov_offset;
+	bio->bi_iter.bi_size = iter->count;
+
+	iov_iter_advance(iter, iter->count);
 	return 0;
 }
 
@@ -1092,12 +1083,13 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
  * This takes either an iterator pointing to user memory, or one pointing to
  * kernel pages (BVEC iterator). If we're adding user pages, we pin them and
  * map them into the kernel. On IO completion, the caller should put those
- * pages. If we're adding kernel pages, and the caller told us it's safe to
- * do so, we just have to add the pages to the bio directly. We don't grab an
- * extra reference to those pages (the user should already have that), and we
- * don't put the page on IO completion. The caller needs to check if the bio is
- * flagged BIO_NO_PAGE_REF on IO completion. If it isn't, then pages should be
- * released.
+ * pages. If we're adding kernel pages, it doesn't take extra page references
+ * and reuses the provided bvec, so the caller must ensure that the bvec isn't
+ * freed and page references remain to be taken until I/O has completed. If
+ * the I/O is completed asynchronously, the bvec must not be freed before
+ * ->ki_complete() has been called. The caller needs to check if the bio is
+ * flagged BIO_NO_PAGE_REF on IO completion. If it isn't, then pages should
+ * be released.
  *
  * The function tries, but does not guarantee, to pin as many pages as
  * fit into the bio, or are requested in @iter, whatever is smaller. If
@@ -1109,27 +1101,23 @@ static int __bio_iov_append_get_pages(struct bio *bio, struct iov_iter *iter)
  */
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 {
-	const bool is_bvec = iov_iter_is_bvec(iter);
 	int ret;
 
-	if (WARN_ON_ONCE(bio->bi_vcnt))
-		return -EINVAL;
+	if (iov_iter_is_bvec(iter)) {
+		if (WARN_ON_ONCE(bio_op(bio) == REQ_OP_ZONE_APPEND))
+			return -EINVAL;
+		bio_iov_bvec_set(bio, iter);
+		bio_set_flag(bio, BIO_NO_PAGE_REF);
+		return 0;
+	}
 
 	do {
-		if (bio_op(bio) == REQ_OP_ZONE_APPEND) {
-			if (WARN_ON_ONCE(is_bvec))
-				return -EINVAL;
+		if (bio_op(bio) == REQ_OP_ZONE_APPEND)
 			ret = __bio_iov_append_get_pages(bio, iter);
-		} else {
-			if (is_bvec)
-				ret = __bio_iov_bvec_add_pages(bio, iter);
-			else
-				ret = __bio_iov_iter_get_pages(bio, iter);
-		}
+		else
+			ret = __bio_iov_iter_get_pages(bio, iter);
 	} while (!ret && iov_iter_count(iter) && !bio_full(bio, 0));
 
-	if (is_bvec)
-		bio_set_flag(bio, BIO_NO_PAGE_REF);
 	return bio->bi_vcnt ? 0 : ret;
 }
 EXPORT_SYMBOL_GPL(bio_iov_iter_get_pages);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 2a9f3f0bbe0a..337f4280b639 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -444,6 +444,9 @@ static inline void bio_wouldblock_error(struct bio *bio)
 
 static inline int bio_iov_vecs_to_alloc(struct iov_iter *iter, int max_segs)
 {
+	/* reuse iter->bvec */
+	if (iov_iter_is_bvec(iter))
+		return 0;
 	return iov_iter_npages(iter, max_segs);
 }
 
-- 
2.24.0

