Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB3D4070E0
	for <lists+io-uring@lfdr.de>; Fri, 10 Sep 2021 20:25:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbhIJS0y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Sep 2021 14:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbhIJS0y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Sep 2021 14:26:54 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25493C061756
        for <io-uring@vger.kernel.org>; Fri, 10 Sep 2021 11:25:43 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id b8so1237844ilh.12
        for <io-uring@vger.kernel.org>; Fri, 10 Sep 2021 11:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z6UwIALlp9qFlZishysLlnF/vgKBUJjar/sdwLm2E1E=;
        b=dZNcocqASUiy5jZRVU/TLOfAW20otqYOWfpooJe7vmHZKfhSewUK6KS/7P0pXPdQkj
         3+kOdyBWMLIcswcXQboYRShW8nOsOOELdi5HMqDZPeQyshM1j+sswMZ1KCMC5ShW7dBG
         mTWGU7AILv7ZuSOV/NXEHeg+4R3tIxaZoSJbfHXdNottnd28sep4Kz4+a1hfF4UvZJdw
         v9jisaknKnG5XOtcoeLmvt/CXOUlc1yxHBYRoESgUNocsM/gUevm5VxmMBU5Rz881zpG
         8/rtFwN/Kq18uUqUEIwLGRwkbSHNbcSR3hMB1wlaiA27t2G9k61TMe151hG6CRYzbqEZ
         NPNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z6UwIALlp9qFlZishysLlnF/vgKBUJjar/sdwLm2E1E=;
        b=tL0DmD4YjM3JtEeU4SuPoUulmxRD1Rfp4cMhrhteVyPN8NIXwil5ZyuOLuC+wvfsOT
         UzlNrrtFgRNSkKg4OMWwWgY5Qr5QEreuht9n7Us79iM6dnNQCAp6rXHwlwqhWsfLr/9R
         uMFX4vtLdXUfZ63nXUSmX7tVqF5iXYwaU+58gEkX5bUCZTLrtHEGPjyv0cYHJ4+KLywE
         mMANp5686y6NeDijy2ThAXx2soCnbzAEKJ8rEfkqpNU1ftDn8nLRJxjxDbmyexB78m1s
         AO5Vjlk1apYnw6d9gHm+oI07VmFNtDAxYbvHvlfepHFASVoj0lo0Ay56SvYgEWhySucn
         xmJQ==
X-Gm-Message-State: AOAM530nn78DsmfI7H/t4WO6SvZbyH+atW5iT5znd2mhpdSDxfcMFWOE
        3KjtkykYSryOJnttPUwVWdmgFFccNN6MNtj7mE0=
X-Google-Smtp-Source: ABdhPJy2Ap63JgqGT3VbYB8Taw2Cw11n5y6v9q7+DWOw06alp0GHbt1eQtzV6CWLUNZVYmQUXvF9WA==
X-Received: by 2002:a05:6e02:8f2:: with SMTP id n18mr7268839ilt.256.1631298342339;
        Fri, 10 Sep 2021 11:25:42 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id c20sm2575149ili.42.2021.09.10.11.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 11:25:42 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] iov_iter: add helper to save iov_iter state
Date:   Fri, 10 Sep 2021 12:25:34 -0600
Message-Id: <20210910182536.685100-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910182536.685100-1-axboe@kernel.dk>
References: <20210910182536.685100-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In an ideal world, when someone is passed an iov_iter and returns X bytes,
then X bytes would have been consumed/advanced from the iov_iter. But we
have use cases that always consume the entire iterator, a few examples
of that are iomap and bdev O_DIRECT. This means we cannot rely on the
state of the iov_iter once we've called ->read_iter() or ->write_iter().

This would be easier if we didn't always have to deal with truncate of
the iov_iter, as rewinding would be trivial without that. We recently
added a commit to track the truncate state, but that grew the iov_iter
by 8 bytes and wasn't the best solution.

Implement a helper to save enough of the iov_iter state to sanely restore
it after we've called the read/write iterator helpers. This currently
only works for IOVEC/BVEC/KVEC as that's all we need, support for other
iterator types are left as an exercise for the reader.

Link: https://lore.kernel.org/linux-fsdevel/CAHk-=wiacKV4Gh-MYjteU0LwNBSGpWrK-Ov25HdqB1ewinrFPg@mail.gmail.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/uio.h | 16 ++++++++++++++++
 lib/iov_iter.c      | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 5265024e8b90..6eaedae5ea2f 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -27,6 +27,12 @@ enum iter_type {
 	ITER_DISCARD,
 };
 
+struct iov_iter_state {
+	size_t iov_offset;
+	size_t count;
+	unsigned long nr_segs;
+};
+
 struct iov_iter {
 	u8 iter_type;
 	bool data_source;
@@ -55,6 +61,14 @@ static inline enum iter_type iov_iter_type(const struct iov_iter *i)
 	return i->iter_type;
 }
 
+static inline void iov_iter_save_state(struct iov_iter *iter,
+				       struct iov_iter_state *state)
+{
+	state->iov_offset = iter->iov_offset;
+	state->count = iter->count;
+	state->nr_segs = iter->nr_segs;
+}
+
 static inline bool iter_is_iovec(const struct iov_iter *i)
 {
 	return iov_iter_type(i) == ITER_IOVEC;
@@ -233,6 +247,8 @@ ssize_t iov_iter_get_pages(struct iov_iter *i, struct page **pages,
 ssize_t iov_iter_get_pages_alloc(struct iov_iter *i, struct page ***pages,
 			size_t maxsize, size_t *start);
 int iov_iter_npages(const struct iov_iter *i, int maxpages);
+void iov_iter_restore(struct iov_iter *i, struct iov_iter_state *state,
+			ssize_t did_bytes);
 
 const void *dup_iter(struct iov_iter *new, struct iov_iter *old, gfp_t flags);
 
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index f2d50d69a6c3..280dbcc523e5 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1972,3 +1972,39 @@ int import_single_range(int rw, void __user *buf, size_t len,
 	return 0;
 }
 EXPORT_SYMBOL(import_single_range);
+
+/**
+ * iov_iter_restore() - Restore a &struct iov_iter to the same state as when
+ *     iov_iter_save_state() was called.
+ *
+ * @i: &struct iov_iter to restore
+ * @state: state to restore from
+ * @did_bytes: bytes to advance @i after restoring it
+ *
+ * Used after iov_iter_save_state() to bring restore @i, if operations may
+ * have advanced it. If @did_bytes is a positive value, then after restoring
+ * @i it is advanced accordingly. This is useful for handling short reads or
+ * writes for retry, if lower down the stack @i was advanced further than the
+ * returned value. If @did_bytes is negative (eg an error), then only the
+ * state restore is done.
+ *
+ * Note: only works on ITER_IOVEC, ITER_BVEC, and ITER_KVEC
+ */
+void iov_iter_restore(struct iov_iter *i, struct iov_iter_state *state,
+		      ssize_t did_bytes)
+{
+	if (WARN_ON_ONCE(!iov_iter_is_bvec(i) && !iter_is_iovec(i)) &&
+			 !iov_iter_is_kvec(i))
+		return;
+	i->iov_offset = state->iov_offset;
+	i->count = state->count;
+	/*
+	 * For the *vec iters, nr_segs + iov is constant - if we increment
+	 * the vec, then we also decrement the nr_segs count. Hence we don't
+	 * need to track both of these, just one is enough and we can deduct
+	 * the other from that. ITER_{BVEC,IOVEC,KVEC} all have their pointers
+	 * unionized, so we don't need to handle them individually.
+	 */
+	i->iov -= state->nr_segs - i->nr_segs;
+	i->nr_segs = state->nr_segs;
+}
-- 
2.33.0

