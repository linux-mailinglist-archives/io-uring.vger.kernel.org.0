Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D09550DDD
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 02:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237314AbiFTA0m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 20:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235902AbiFTA0m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 20:26:42 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 877B9AE4C
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 17:26:40 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id g4so12446674wrh.11
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 17:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1sN/Gp9aHMJl2eMxU9Q8u380cMh6zn5WKKXCkShHB6A=;
        b=SqZIbgFlVJqolpHp2FNs/I2XMpEDijECmCw11e/uGqeF5gVFxCr5ZiGC6IJpfCYVBe
         9eoNIDgfSLYOI6R/yIOZ8si+ZB07cz4Lb2sZu8p8QN8VOM3WMhFcOcYSR0z++Kx9q7PI
         4EZBxPTL3z6yrJKrQZ34GvZDO2FOUvUAqr7Xrij+8xFESSj+5lT4P7oVusQxh/U3Jy5f
         dUzVnti//KXoRFUBfp5zgsQAyVIpsZ7JjIz7IGbY31eW6LnudBRp4GmTPuiZ8YlmghPg
         3bpXZVpvRAgdDaotQpl7DeM3PaTop4rA1nXA8+dl8YU+pUAkMrvh6PG3Is6mSG+aYDJh
         n4gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1sN/Gp9aHMJl2eMxU9Q8u380cMh6zn5WKKXCkShHB6A=;
        b=0Xf6bEOKv+CXnApCDiVREeeDXux27/XbhALicztHl8lumB+CwlBeHmAUb0tS9jThHp
         e9yanI7N6VzlJ/itE9cT9UKjGkT+PK0oAC2qMXHB2MM/kHP8pF71NT8WASxJ4VE6KsSw
         GBTvoUysMYcqRUiQKXYGbLLvIUYo54myleaLUy2vLmbgFZT1053F0vmTsveKa2vucdlo
         Q9cwoaJsdGqNOeyqv5hlJi6QOywjRlA/A0HfEaOPcr8mEJDpEW9/o/8m3RoZcl9J0M7h
         LKuH+tKsJ+tcWmKrUmiyT8+oq649U2SeqKCFFty1yU6YjUKunCh46ASt1zeQP3gHnb99
         ZHgA==
X-Gm-Message-State: AJIora9kXWZVft6Drm9erWZ7s2u42B8nBRasMBPpGPy9oCSIs1Mqs8CA
        hAj6eDL10wSL8K37REmPi0fcZ8cb4HdhLw==
X-Google-Smtp-Source: AGRyM1tZKySiMLd97/6KvTxesTpewNhavfFZ9wN/h3Amf5KwqjIxX6I0792ZUwZwi9Qm2M+gRev99A==
X-Received: by 2002:a5d:51c8:0:b0:21b:8c04:9756 with SMTP id n8-20020a5d51c8000000b0021b8c049756mr4642721wrv.618.1655684798858;
        Sun, 19 Jun 2022 17:26:38 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id h18-20020a5d4312000000b002167efdd549sm11543807wrq.38.2022.06.19.17.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 17:26:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 08/10] io_uring: move io_import_fixed()
Date:   Mon, 20 Jun 2022 01:25:59 +0100
Message-Id: <4d5becb21f332b4fef6a7cedd6a50e65e2371630.1655684496.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655684496.git.asml.silence@gmail.com>
References: <cover.1655684496.git.asml.silence@gmail.com>
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
index 03f26516e994..87f58315b247 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -64,6 +64,9 @@ int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 void io_rsrc_node_switch(struct io_ring_ctx *ctx,
 			 struct io_rsrc_data *data_to_kill);
 
+int io_import_fixed(int ddir, struct iov_iter *iter,
+			   struct io_mapped_ubuf *imu,
+			   u64 buf_addr, size_t len);
 
 void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
 int io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 4e5d96040cdc..9166d8166b82 100644
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

