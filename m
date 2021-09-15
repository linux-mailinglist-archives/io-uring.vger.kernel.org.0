Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC7C40CA12
	for <lists+io-uring@lfdr.de>; Wed, 15 Sep 2021 18:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhIOQbD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Sep 2021 12:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbhIOQbC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Sep 2021 12:31:02 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC75C061574
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 09:29:43 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id i13so3558802ilm.4
        for <io-uring@vger.kernel.org>; Wed, 15 Sep 2021 09:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z7c8syQSjn5yBCKSSFtxNAKMp+iDYztMNgRmqIUn/y4=;
        b=PiU+nnUpAHaZ2egnr4Y6Og19L9h+iQxOFSfQGXttAgxIGB0T2Zl5XuQ2TZfWoeIrlB
         TzZ6or5kAVslXP9nEJrrgsmNXEiItJspGXdlPBBEuuV8zma4J+cj2LXq8Ur1TB5VKEUC
         nKJSo+jzgcdBl74MbRHBNOf8Y4GuJVM3DueaOTX7eAuavrDR0zkmm4duR2AzNs9CHdes
         ZNWHman2lxU7Qy6GfkmG3jrt98JbCOWouIkQUaH8rN5+dUsaC5EL2h9cmKS7mq1IRtUw
         gpa+1iRAW1HTOsocZAPnMiFZdp+wVj6TfMa+KKtl5rxwY8f4MH/VPmlnEBI2I5B88lEa
         pVCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z7c8syQSjn5yBCKSSFtxNAKMp+iDYztMNgRmqIUn/y4=;
        b=XlkEX4xU/4vy9L48YSxUyRuTaoqeKs0I51fzJIpFoKhWDxAu6HNk2mf375tlxAjgOJ
         mTZKWuZanxvKRaCBeHvalgOvcgm7dEopOPhjIVYoxkjZYlW/JF1saMu6u2HBsIh4D8BK
         oHqe2+DuCihv0q3+9CD8VbOGuFH4zsMFKIlIO5haBbvLkUtTcxyxpGKex+txnfWLuk7+
         gnp4kBxqq7C9I5qC6BOzsfRo2dmFVD4rrdXvUTOpzjxiHlmjUzL3iCpFblZ6VVrGT+ti
         Hr6PKk+9KgK9+X+s3Sq7VN+w1kjhvt1j97w+gW0KHGXY/IPcwNZDagNOS9xgPJxxkB+U
         9Akw==
X-Gm-Message-State: AOAM530RkIp2U0g1IFlIVwrA2qo+2NrUhbULEWo10Yb1yQNIlVF694qE
        7lWvU23y62l2CnPABcfETb5gMDYky5wOI22WtO4=
X-Google-Smtp-Source: ABdhPJxrdp+4RJX6C0QJPf3ojBGViVv5PLprSG4/eGOZhSyA1Mea+hZm2zPuqH0Rv6IsVHPYRrm0KQ==
X-Received: by 2002:a92:d12:: with SMTP id 18mr637015iln.287.1631723383001;
        Wed, 15 Sep 2021 09:29:43 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t15sm227160ioi.7.2021.09.15.09.29.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 09:29:42 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] iov_iter: add helper to save iov_iter state
Date:   Wed, 15 Sep 2021 10:29:35 -0600
Message-Id: <20210915162937.777002-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210915162937.777002-1-axboe@kernel.dk>
References: <20210915162937.777002-1-axboe@kernel.dk>
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
 include/linux/uio.h | 15 +++++++++++++++
 lib/iov_iter.c      | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index 5265024e8b90..984c4ab74859 100644
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
@@ -233,6 +247,7 @@ ssize_t iov_iter_get_pages(struct iov_iter *i, struct page **pages,
 ssize_t iov_iter_get_pages_alloc(struct iov_iter *i, struct page ***pages,
 			size_t maxsize, size_t *start);
 int iov_iter_npages(const struct iov_iter *i, int maxpages);
+void iov_iter_restore(struct iov_iter *i, struct iov_iter_state *state);
 
 const void *dup_iter(struct iov_iter *new, struct iov_iter *old, gfp_t flags);
 
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index f2d50d69a6c3..755c10c5138c 100644
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
+ *
+ * Used after iov_iter_save_state() to bring restore @i, if operations may
+ * have advanced it.
+ *
+ * Note: only works on ITER_IOVEC, ITER_BVEC, and ITER_KVEC
+ */
+void iov_iter_restore(struct iov_iter *i, struct iov_iter_state *state)
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
+	 * the other from that. ITER_KVEC and ITER_IOVEC are the same struct
+	 * size, so we can just increment the iov pointer as they are unionzed.
+	 * ITER_BVEC _may_ be the same size on some archs, but on others it is
+	 * not. Be safe and handle it separately.
+	 */
+	BUILD_BUG_ON(sizeof(struct iovec) != sizeof(struct kvec));
+	if (iov_iter_is_bvec(i))
+		i->bvec -= state->nr_segs - i->nr_segs;
+	else
+		i->iov -= state->nr_segs - i->nr_segs;
+	i->nr_segs = state->nr_segs;
+}
-- 
2.33.0

