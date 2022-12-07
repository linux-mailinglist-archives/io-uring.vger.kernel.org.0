Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEEA96452B7
	for <lists+io-uring@lfdr.de>; Wed,  7 Dec 2022 04:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiLGDyj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 22:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiLGDyi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 22:54:38 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D072E52158
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 19:54:37 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id m19so23146411edj.8
        for <io-uring@vger.kernel.org>; Tue, 06 Dec 2022 19:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=upWUPmaa90glqBHyBCUCAkABecCY2H8UcpgigVm/aNs=;
        b=qu9WVmVS8eJtEyD8wcCi8/HZsOcZ1r20TqH4yNFApx1C2nKtuml1Dgics7/43YX0N9
         8zDABfFflaTxf/+eHPDSLymC/n125+/P4NHbcgQTugJD13K10G0J/UNVhqQEaejN3gC8
         Jh3Z8dixikgNdoBTFah2wxiISmTxLk887wbZgpO6OmxgUikJEy3Xnsv0sQXkZMRBtLhw
         lP2Zxkko26kM9fnmOTdQVEDOYNiCgTKzxAzdCm7kD9lxQ4fbVCAIDe/rUcsWI3HuaNEj
         fIg6jTc0emcGI58ytq16kifuJK64hfs/jhEqY4HrohccH/+HV6NzfwuqNlIB6ZLj3v7f
         DNuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=upWUPmaa90glqBHyBCUCAkABecCY2H8UcpgigVm/aNs=;
        b=bL24SG4Qre1KOqOC7jyaSib1PPXMXNfFUtRmGAEhoFEGUkeXPzhOzObUOMHf1l6ONp
         WW5j/PTM8vYmR/Zql3WEwSAGBPrQ6oiF7MNE8oU1QwpKvNa2vSlFnGL4jZi4+TaMLSCz
         jB9Sv6eJFF7+hl5TaKb7eXWodk3FpvtaSV7eG2CFrQlCfeO1pC6uGscKLd9ttnUFVaFE
         6nkiwaEhC4ignPlOWIM0V9oFdXcJSN158VB70GlZrV2hRDvmjJaD9eS3yce5aOJJtzJe
         5wAJIkxdvssPZ3SRM5aZryGcZpQnHVjr9Zp9jSaYXYOxeHGrM7YsCnBWqXRgwd9RG9Qv
         MlNg==
X-Gm-Message-State: ANoB5pn1RRposRK68VJAtJMlafaAqHg2ZNZug/fFUWHqYSM/KVIPVXhu
        GmLi+hJ5Rb3GRlK+TdiRxZVYGwg3vWw=
X-Google-Smtp-Source: AA0mqf7Dk6HAnQ596PCaShzI9F9YzDCgaNiUtCMPD61zboCGbiIeOMpwwcb/GrDMpEKQ/hzVCyHsHw==
X-Received: by 2002:aa7:c415:0:b0:46c:4b56:8c06 with SMTP id j21-20020aa7c415000000b0046c4b568c06mr16391533edq.230.1670385276131;
        Tue, 06 Dec 2022 19:54:36 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.241.58.threembb.co.uk. [94.196.241.58])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906210900b0073de0506745sm7938939ejt.197.2022.12.06.19.54.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 19:54:35 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 04/12] io_uring: don't check overflow flush failures
Date:   Wed,  7 Dec 2022 03:53:29 +0000
Message-Id: <6b720a45c03345655517f8202cbd0bece2848fb2.1670384893.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670384893.git.asml.silence@gmail.com>
References: <cover.1670384893.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The only way to fail overflowed CQEs flush is for CQ to be fully packed.
There is one place checking for flush failures, i.e. io_cqring_wait(),
but we limit the number to be waited for by the CQ size, so getting a
failure automatically means that we're done with waiting.

Don't check for failures, rarely but they might spuriously fail CQ
waiting with -EBUSY.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5c0b3ba6059e..7bebca5ed950 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -629,13 +629,12 @@ static void io_cqring_overflow_kill(struct io_ring_ctx *ctx)
 }
 
 /* Returns true if there are no backlogged entries after the flush */
-static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx)
+static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 {
-	bool all_flushed;
 	size_t cqe_size = sizeof(struct io_uring_cqe);
 
 	if (__io_cqring_events(ctx) == ctx->cq_entries)
-		return false;
+		return;
 
 	if (ctx->flags & IORING_SETUP_CQE32)
 		cqe_size <<= 1;
@@ -654,30 +653,23 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 		kfree(ocqe);
 	}
 
-	all_flushed = list_empty(&ctx->cq_overflow_list);
-	if (all_flushed) {
+	if (list_empty(&ctx->cq_overflow_list)) {
 		clear_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq);
 		atomic_andnot(IORING_SQ_CQ_OVERFLOW, &ctx->rings->sq_flags);
 	}
-
 	io_cq_unlock_post(ctx);
-	return all_flushed;
 }
 
-static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx)
+static void io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 {
-	bool ret = true;
-
 	if (test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq)) {
 		/* iopoll syncs against uring_lock, not completion_lock */
 		if (ctx->flags & IORING_SETUP_IOPOLL)
 			mutex_lock(&ctx->uring_lock);
-		ret = __io_cqring_overflow_flush(ctx);
+		__io_cqring_overflow_flush(ctx);
 		if (ctx->flags & IORING_SETUP_IOPOLL)
 			mutex_unlock(&ctx->uring_lock);
 	}
-
-	return ret;
 }
 
 void __io_put_task(struct task_struct *task, int nr)
@@ -2505,11 +2497,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
-		/* if we can't even flush overflow, don't wait for more */
-		if (!io_cqring_overflow_flush(ctx)) {
-			ret = -EBUSY;
-			break;
-		}
+		io_cqring_overflow_flush(ctx);
 		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
 		ret = io_cqring_wait_schedule(ctx, &iowq, timeout);
-- 
2.38.1

