Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B588C55046E
	for <lists+io-uring@lfdr.de>; Sat, 18 Jun 2022 14:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbiFRM1y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jun 2022 08:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbiFRM1y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jun 2022 08:27:54 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FE718350
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 05:27:52 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id hj18so12585516ejb.0
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 05:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+e+fmJWWdvfPKIMPA/AS7O0wOoV+0TnHdg68jY7sjUk=;
        b=ODUEBAQ9TDGEPVSYeQKii/ODGm+lWPxa9CYcSihqDZjNsavQn0u6wWnpmpTF4QwImE
         qNzwFKR4Yfly6D4hPod5PmvgXTWcqDA1g4NDKJ2qgK8yz9ylqtlk5f4qK+fwL3ICZZfV
         uIJgHYLDwutDuO8hzRqa9vgt2cdmsZXEcG3AcuXSaRiDwIl+wT6seD7p/H5NmxMDLRj0
         SCT6oQ52JwpPas+N5EQoP9cfa289fdyVpBp6Z21Mth38drYQasJwThQ3cvpqQ1i06MZT
         inDvL06hTKz3brqA5XUKsTcAk16l8Eoe6aSzhyIfRU2L87Llp77SHr+ZmxfZb9NQeRXR
         Yj1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+e+fmJWWdvfPKIMPA/AS7O0wOoV+0TnHdg68jY7sjUk=;
        b=N0XMdBXWyutI4AtLJida8sjLK9bS+pZiBR3gI5eGtmOGEUOQ1FKM8ZFh1T5oeWbo8Y
         l48ae1RbV0bJdtHxJDE7jN8yhDwBxPzFBneooM2bMC6XfeXfoG5Sf4zpCOb2yR3hwmkx
         YjfZksryhjQZNo5yQJ61Ec7n8LCZvRoZeJpJDwbfO4lp9ipOg+1I5dlt7aFcU+zwl69t
         xVKF8gH/dXoV/+pgoGitLoneGadT9QYrDt5RtXWClP2cLXTi8tc1c9h60Ic6tnan43Si
         wUCiVaGFADOT5pRzLXpVMkr3gYSkLlj45ORTKytnwdJrvxJYG++YFNlQ1aPv/YpNOiP9
         n4Xg==
X-Gm-Message-State: AJIora8e6KeGIiIplCqxgfcUK9FE2XuJzgVtSIn0sza09/cnJg4y0YU2
        8VyOGnYGCzTjj0ywc9hDYsXhP6Ughp6iYQ==
X-Google-Smtp-Source: AGRyM1swHMWEvxSnYMa2bXTRsD22aRv129e/mEEs/u69tjd7aEjO6UkaVugEHrao/LChrgjTTeanrQ==
X-Received: by 2002:a17:906:9c84:b0:6e0:7c75:6f01 with SMTP id fj4-20020a1709069c8400b006e07c756f01mr13155423ejc.103.1655555271206;
        Sat, 18 Jun 2022 05:27:51 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id u23-20020a056402111700b0042dd792b3e8sm5771523edv.50.2022.06.18.05.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 05:27:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 2/4] io_uring: move io_import_fixed()
Date:   Sat, 18 Jun 2022 13:27:25 +0100
Message-Id: <6a416192bf4322c1adf6e528faa7c0b84c22d940.1655553990.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655553990.git.asml.silence@gmail.com>
References: <cover.1655553990.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move io_import_fixed() into rsrc.c where it belongs.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++
 io_uring/rsrc.h |  3 +++
 io_uring/rw.c   | 60 -------------------------------------------------
 3 files changed, 63 insertions(+), 60 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index c10c512aa71b..3a2a5ef263f0 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1307,3 +1307,63 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		io_rsrc_node_switch(ctx, NULL);
 	return ret;
 }
+
+int io_import_fixed(int ddir, struct iov_iter *iter,
+			   struct io_mapped_ubuf *imu,
+			   u64 buf_addr, size_t len)
+{
+	u64 buf_end;
+	size_t offset;
+
+	if (WARN_ON_ONCE(!imu))
+		return -EFAULT;
+	if (unlikely(check_add_overflow(buf_addr, (u64)len, &buf_end)))
+		return -EFAULT;
+	/* not inside the mapped region */
+	if (unlikely(buf_addr < imu->ubuf || buf_end > imu->ubuf_end))
+		return -EFAULT;
+
+	/*
+	 * May not be a start of buffer, set size appropriately
+	 * and advance us to the beginning.
+	 */
+	offset = buf_addr - imu->ubuf;
+	iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, offset + len);
+
+	if (offset) {
+		/*
+		 * Don't use iov_iter_advance() here, as it's really slow for
+		 * using the latter parts of a big fixed buffer - it iterates
+		 * over each segment manually. We can cheat a bit here, because
+		 * we know that:
+		 *
+		 * 1) it's a BVEC iter, we set it up
+		 * 2) all bvecs are PAGE_SIZE in size, except potentially the
+		 *    first and last bvec
+		 *
+		 * So just find our index, and adjust the iterator afterwards.
+		 * If the offset is within the first bvec (or the whole first
+		 * bvec, just use iov_iter_advance(). This makes it easier
+		 * since we can just skip the first segment, which may not
+		 * be PAGE_SIZE aligned.
+		 */
+		const struct bio_vec *bvec = imu->bvec;
+
+		if (offset <= bvec->bv_len) {
+			iov_iter_advance(iter, offset);
+		} else {
+			unsigned long seg_skip;
+
+			/* skip first vec */
+			offset -= bvec->bv_len;
+			seg_skip = 1 + (offset >> PAGE_SHIFT);
+
+			iter->bvec = bvec + seg_skip;
+			iter->nr_segs -= seg_skip;
+			iter->count -= bvec->bv_len + offset;
+			iter->iov_offset = offset & ~PAGE_MASK;
+		}
+	}
+
+	return 0;
+}
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 872c86312cbc..b5ebd7ea8126 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -56,6 +56,9 @@ int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 			 struct io_rsrc_data *data_to_kill);
 
+int io_import_fixed(int ddir, struct iov_iter *iter,
+			   struct io_mapped_ubuf *imu,
+			   u64 buf_addr, size_t len);
 
 void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
 int io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 70d474954e20..d013db39b555 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -273,66 +273,6 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 	return IOU_ISSUE_SKIP_COMPLETE;
 }
 
-static int io_import_fixed(int ddir, struct iov_iter *iter,
-			   struct io_mapped_ubuf *imu,
-			   u64 buf_addr, size_t len)
-{
-	u64 buf_end;
-	size_t offset;
-
-	if (WARN_ON_ONCE(!imu))
-		return -EFAULT;
-	if (unlikely(check_add_overflow(buf_addr, (u64)len, &buf_end)))
-		return -EFAULT;
-	/* not inside the mapped region */
-	if (unlikely(buf_addr < imu->ubuf || buf_end > imu->ubuf_end))
-		return -EFAULT;
-
-	/*
-	 * May not be a start of buffer, set size appropriately
-	 * and advance us to the beginning.
-	 */
-	offset = buf_addr - imu->ubuf;
-	iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, offset + len);
-
-	if (offset) {
-		/*
-		 * Don't use iov_iter_advance() here, as it's really slow for
-		 * using the latter parts of a big fixed buffer - it iterates
-		 * over each segment manually. We can cheat a bit here, because
-		 * we know that:
-		 *
-		 * 1) it's a BVEC iter, we set it up
-		 * 2) all bvecs are PAGE_SIZE in size, except potentially the
-		 *    first and last bvec
-		 *
-		 * So just find our index, and adjust the iterator afterwards.
-		 * If the offset is within the first bvec (or the whole first
-		 * bvec, just use iov_iter_advance(). This makes it easier
-		 * since we can just skip the first segment, which may not
-		 * be PAGE_SIZE aligned.
-		 */
-		const struct bio_vec *bvec = imu->bvec;
-
-		if (offset <= bvec->bv_len) {
-			iov_iter_advance(iter, offset);
-		} else {
-			unsigned long seg_skip;
-
-			/* skip first vec */
-			offset -= bvec->bv_len;
-			seg_skip = 1 + (offset >> PAGE_SHIFT);
-
-			iter->bvec = bvec + seg_skip;
-			iter->nr_segs -= seg_skip;
-			iter->count -= bvec->bv_len + offset;
-			iter->iov_offset = offset & ~PAGE_MASK;
-		}
-	}
-
-	return 0;
-}
-
 #ifdef CONFIG_COMPAT
 static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
 				unsigned int issue_flags)
-- 
2.36.1

