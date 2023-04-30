Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349706F2859
	for <lists+io-uring@lfdr.de>; Sun, 30 Apr 2023 11:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbjD3Jhm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 30 Apr 2023 05:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbjD3Jhl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 30 Apr 2023 05:37:41 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60EE10E7
        for <io-uring@vger.kernel.org>; Sun, 30 Apr 2023 02:37:39 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f3331f928cso5641385e9.2
        for <io-uring@vger.kernel.org>; Sun, 30 Apr 2023 02:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682847458; x=1685439458;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O2cYuHgnWZu3gBAdMg79GUuiwYo9/wRt2GmSInH2TC8=;
        b=giMHTccZkrsVwm2bPGHOsUiDOKEvfXvlRWK5XNxK3RtjZlnDARVrDyACUhZEH5Z0Ex
         gJnCtPrTETXh6Dujb+/CREicFRwYtwRqPH+XTBDH9LuDGpL+J9zLKGkxYgR+0DD6jl6V
         gLy9cb2qVTFVJ6QK04kCLvEc1UN4IXS/kP3YFI6UdQYWKVx7f1S7VF9slbeMaP3k3PiF
         +JBb7ABLWdNJZiLyNXn0BY2fGWa9N1J9xIr8HAHpWkCQMff/EdQ2y8FEsqncMxFFOMDn
         0gHAvfdUWwIKOaLt+UoGehx07UFrwGwvwPMC14x9bgh03TPHwylyZcppcK7n2tQJmGGk
         PcsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682847458; x=1685439458;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O2cYuHgnWZu3gBAdMg79GUuiwYo9/wRt2GmSInH2TC8=;
        b=Zwl58YeJmt/r0UhKaAi/ACzsCK0rSDDd0wsV+pn8QIXzEBRBILasNt19xEk5M/wMBe
         Tq49sWIvp7VDrj8KiOnvY1u8sGXQtX335Z5jYoT06x8TXIejz8e34OyaY5ZV5GestUcu
         24gMo6Tx2au6cRJrtIIgPrEM1qbTCJXKBBOH/PNzI42oS0O2db/1SXOsiMnqMZrnfwhe
         XuApj9BgflyHHn+ko/8KnuJvoliKaOGa8v8PmrC1w9s8fXcJd0Rx0A7mJKtHiuLG3FA9
         upsVGeI6fPPhc+r6D33GXfyejsrvCvVISIhZYHfv/XUB/R5rjeunmywkdi6q5TG7odyK
         5Hig==
X-Gm-Message-State: AC+VfDz3e5VDbMbue7kZVCSXJU/56dlCeFAQfsJKd8+qZNj+a7jiAxdd
        J/49mrMrJ8plsEzbYY2K0qul09PrjHA=
X-Google-Smtp-Source: ACHHUZ676VdVLcIy8GwGxy/HOom5QtXOXqNuvMy2W0ynzUaxl5aFKGfEBOx+vJt7CZBU7QJdP4Li3w==
X-Received: by 2002:a7b:c8c3:0:b0:3f1:6f53:7207 with SMTP id f3-20020a7bc8c3000000b003f16f537207mr7379933wml.17.1682847458124;
        Sun, 30 Apr 2023 02:37:38 -0700 (PDT)
Received: from 127.0.0.1localhost (188.31.116.198.threembb.co.uk. [188.31.116.198])
        by smtp.gmail.com with ESMTPSA id u19-20020a05600c00d300b003f17eaae2c9sm29473170wmm.1.2023.04.30.02.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 02:37:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, ming.lei@redhat.com
Subject: [RFC 4/7] io_uring/rsrc: introduce struct iou_buf_desc
Date:   Sun, 30 Apr 2023 10:35:26 +0100
Message-Id: <a2b80cf8a8fee8cfc8840f45ece4c0842ad48d74.1682701588.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1682701588.git.asml.silence@gmail.com>
References: <cover.1682701588.git.asml.silence@gmail.com>
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

Add struct iou_buf_desc, which will be used for new get_buf operations.
It'll be handed over to a file with via new operation to be filled.
After the content should eventually end up in struct io_mapped_ubuf,
and so to not make extra copies just place the descriptor inside struct
io_mapped_ubuf.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring.h |  6 ++++++
 io_uring/rsrc.c          | 13 +++++++------
 io_uring/rsrc.h          | 11 +++++------
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 35b9328ca335..fddb5d52b776 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -22,6 +22,12 @@ enum io_uring_cmd_flags {
 	IO_URING_F_IOPOLL		= (1 << 10),
 };
 
+struct iou_buf_desc {
+	unsigned		nr_bvecs;
+	unsigned		max_bvecs;
+	struct bio_vec		*bvec;
+};
+
 struct io_uring_cmd {
 	struct file	*file;
 	const void	*cmd;
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index b6305ae3538c..0edcebb6b5cb 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -84,7 +84,7 @@ static void io_put_reg_buf(struct io_ring_ctx *ctx, struct io_mapped_ubuf *imu)
 {
 	lockdep_assert_held(&ctx->uring_lock);
 
-	if ((imu->max_bvecs != IO_BUF_CACHE_MAX_BVECS) ||
+	if ((imu->desc.max_bvecs != IO_BUF_CACHE_MAX_BVECS) ||
 	    !io_alloc_cache_put(&ctx->reg_buf_cache, &imu->cache))
 		kvfree(imu);
 }
@@ -109,7 +109,8 @@ static struct io_mapped_ubuf *io_alloc_reg_buf(struct io_ring_ctx *ctx,
 			goto do_alloc;
 		imu = container_of(entry, struct io_mapped_ubuf, cache);
 	}
-	imu->max_bvecs = nr_bvecs;
+	imu->desc.bvec = imu->bvec;
+	imu->desc.max_bvecs = nr_bvecs;
 	return imu;
 }
 
@@ -168,7 +169,7 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slo
 	unsigned int i;
 
 	if (imu != ctx->dummy_ubuf) {
-		for (i = 0; i < imu->nr_bvecs; i++)
+		for (i = 0; i < imu->desc.nr_bvecs; i++)
 			unpin_user_page(imu->bvec[i].bv_page);
 		if (imu->acct_pages)
 			io_unaccount_mem(ctx, imu->acct_pages);
@@ -1020,7 +1021,7 @@ static bool headpage_already_acct(struct io_ring_ctx *ctx, struct page **pages,
 	for (i = 0; i < ctx->nr_user_bufs; i++) {
 		struct io_mapped_ubuf *imu = ctx->user_bufs[i];
 
-		for (j = 0; j < imu->nr_bvecs; j++) {
+		for (j = 0; j < imu->desc.nr_bvecs; j++) {
 			if (!PageCompound(imu->bvec[j].bv_page))
 				continue;
 			if (compound_head(imu->bvec[j].bv_page) == hpage)
@@ -1184,7 +1185,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	/* store original address for later verification */
 	imu->ubuf = (unsigned long) iov->iov_base;
 	imu->ubuf_end = imu->ubuf + iov->iov_len;
-	imu->nr_bvecs = nr_pages;
+	imu->desc.nr_bvecs = nr_pages;
 	imu->dir_mask = (1U << ITER_SOURCE) | (1U << ITER_DEST);
 	*pimu = imu;
 	ret = 0;
@@ -1292,7 +1293,7 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 	 * and advance us to the beginning.
 	 */
 	offset = buf_addr - imu->ubuf;
-	iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, offset + len);
+	iov_iter_bvec(iter, ddir, imu->bvec, imu->desc.nr_bvecs, offset + len);
 
 	if (offset) {
 		/*
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 10daa25d9194..9ac10b3d25ac 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -54,12 +54,11 @@ struct io_mapped_ubuf {
 		struct io_cache_entry		cache;
 		u64				ubuf;
 	};
-	u64		ubuf_end;
-	unsigned int	nr_bvecs;
-	unsigned int	max_bvecs;
-	unsigned int	dir_mask;
-	unsigned long	acct_pages;
-	struct bio_vec	bvec[];
+	u64			ubuf_end;
+	struct iou_buf_desc	desc;
+	unsigned int		dir_mask;
+	unsigned long		acct_pages;
+	struct bio_vec		bvec[];
 };
 
 void io_rsrc_put_tw(struct callback_head *cb);
-- 
2.40.0

