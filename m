Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DBC4071C4
	for <lists+io-uring@lfdr.de>; Fri, 10 Sep 2021 21:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbhIJTQW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Sep 2021 15:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhIJTQV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Sep 2021 15:16:21 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B13C061574
        for <io-uring@vger.kernel.org>; Fri, 10 Sep 2021 12:15:10 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id q22so2752721pfu.0
        for <io-uring@vger.kernel.org>; Fri, 10 Sep 2021 12:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ux2EaODBAnWU9dQVWubns7QYYDnnQatPNAoTMBXwI3g=;
        b=M4VuY4wL63KPufo8vOcOVOSaV5ONJ4+CVpuDlRhjCACcOpsjeqBjtfurYP+0daROAD
         g1WyHdT5A8g/UL3Csry3O07FtDodzovz6SoU8jY3go7CRvSpwUbl35EsM4NxexQkkGLp
         BBlsAgrJbp2SxLlrflofzK1Rskcbzlx1TMCgB5rxGZiRYhe7MhXnEu7Nm8fvVkb/OgDd
         i/Y6SOzbL8j/n/zNMjOdVx0n0DkRC8l2tYgO11kW81PJdTHJdlOkGjZDt6V0v4Vbj/o9
         EIz7VhSD3lEmMln+C944udK6wm5b+ZR84DPRcJOe0tTl09j/rBtm2DYADtCugshwcvwC
         6Gsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ux2EaODBAnWU9dQVWubns7QYYDnnQatPNAoTMBXwI3g=;
        b=WdarEcJjXT0V9SMRzTLhT4+TzSKO9tV8hEC3ep+FbsW+4qCT1N8eqGm7iBuF4pIRkO
         9Ng8qEpjEl2eZCfaahMSW+rRIo94/DEoxkq2kScjld2MTjNGYeUm0jmB7cr2x4/DI0zx
         k4FPtfO8OcEstWE4Yp3mQxJm8qFTWQBnzREO67LioWuBJ3YSRf1rYUDEV6ghpX+XMefF
         S8tQaUw/Wc71xnOkk2VSrJZMCLzL3CHe1gF87Sum1kHOXULHTJvdNI58FgE2SY0AFXvy
         i2TwFiGDaYGvH53wcKoBRn21d1Oin7YGj4Dmy8JGFePn3qd0WI9DF1oj23yybzUaGTVj
         j4GQ==
X-Gm-Message-State: AOAM5305qq0qQm3Z2vRV1x/wVYera0evKrDOqRYGocvnfkCue6/ki7HH
        KJRZW8wOgmOR58jjaW4tvmfvo0LHQYOIPt1J
X-Google-Smtp-Source: ABdhPJxbMICZcTHLiC18gbdI0QSfp3APEszlLkYpK/JM2zXpVs19HF/I6s44QiUpYQ76i08BO0R/3g==
X-Received: by 2002:aa7:8426:0:b0:438:3550:f190 with SMTP id q6-20020aa78426000000b004383550f190mr202040pfn.19.1631301309800;
        Fri, 10 Sep 2021 12:15:09 -0700 (PDT)
Received: from ?IPv6:2600:380:4963:7106:aa8b:68a3:b10d:8c01? ([2600:380:4963:7106:aa8b:68a3:b10d:8c01])
        by smtp.gmail.com with ESMTPSA id m12sm6027747pjc.18.2021.09.10.12.15.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Sep 2021 12:15:09 -0700 (PDT)
Subject: [PATCH v2 1/3] iov_iter: add helper to save iov_iter state
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        torvalds@linux-foundation.org
References: <20210910182536.685100-1-axboe@kernel.dk>
 <20210910182536.685100-2-axboe@kernel.dk>
 <YTupAx9W2RcLJHGk@zeniv-ca.linux.org.uk>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <38e55b56-2546-c7f4-dd35-8453a611cc39@kernel.dk>
Date:   Fri, 10 Sep 2021 13:15:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YTupAx9W2RcLJHGk@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
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

V2: Don't assume bvec is the same size as iovec/kvec. Add a special
    case for it, and a BUILD_BUG_ON() for iovec/kvec sizing as well.

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
index f2d50d69a6c3..b46173eb61c7 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1972,3 +1972,45 @@ int import_single_range(int rw, void __user *buf, size_t len,
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

