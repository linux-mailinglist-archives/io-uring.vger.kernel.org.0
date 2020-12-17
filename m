Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F81A2DC9F0
	for <lists+io-uring@lfdr.de>; Thu, 17 Dec 2020 01:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbgLQA2u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Dec 2020 19:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbgLQA2t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Dec 2020 19:28:49 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46ADBC0617B0
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 16:28:09 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id t30so6824020wrb.0
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 16:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=WJWelS19Pnkm6bDhRGfPKXWx5LY/vzMna0xMwioO/YA=;
        b=Rs63iU9mRtI7hrhNNgaxGYxd4JV5AX2tbdRiLoESOMFiUy2vgEAsPqkLZypYvPBrgO
         /k93YfCdP4ReCpoEnRlTk+CEI3UzFFVFmO5VlrIoM3VgIl3y6Kd/CkI5w5xy47pGV95j
         NhSzkg29Cr9mWrhh8DIjH0rufIesklNV87zYjPzDnW/kS6xrva4zJaZ0jiFIYIQ0jKw1
         qsnJ8yAYJ9t54ECJ4BnY4+HvuanfB/MlXfmWtXO72k9xyOuRP2NlCb9sVxhYBXv6y/WJ
         ivTn1aGBR1jbh8ziNFEFkgr0Q40s5D7bL/k2SO++Dl3+DWVSHaLnta7/3JAVpiECI2sU
         e7ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WJWelS19Pnkm6bDhRGfPKXWx5LY/vzMna0xMwioO/YA=;
        b=my6NapRN9lMJYgQdwU6stvuLxZtqlPYPmGSgkiLZ8FEdleyZXVzwhMqg/ByHp0AE1E
         cjT8PA29CnatQky5XfVMzvtv2UITsaKUKngE/iS9RyFaVpzHS+r85tpqNk+QKKC4rse1
         ADlK2VC+298ALYRjpiwCLwMn9Rw+TWK2eX2qzX223IBHRabSCbESVviZ67TsaZFJJveR
         xfTd9r1EzkYEd0/I+kVH9tdNOi7Obx5NJBEiMGLRH25L5HiTEW+zYkgXADqysrJDb63l
         zEeKYmJU9uniyh0pWjRQ4XHWEB0G2/iNHGy/sMLkpO+/hGPWoH1vRQmQcCkAnlGFgEuR
         xgvg==
X-Gm-Message-State: AOAM533IAvBJ54kPEh6A/jMuP3frio5NN4kBUh30X4q8P/lykqmcqTki
        rqxfRPLhu6ME62LEKGBBeCxZULv7IiEVng==
X-Google-Smtp-Source: ABdhPJynQHdI7f+2YimECgccoPC9lbKfRmtOXoFFiTIGsRdjViIfrJVLcDMVM2zUdvuJOwHxjgvHTw==
X-Received: by 2002:a5d:6cc2:: with SMTP id c2mr29894687wrc.374.1608164886816;
        Wed, 16 Dec 2020 16:28:06 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.225])
        by smtp.gmail.com with ESMTPSA id h29sm5711161wrc.68.2020.12.16.16.28.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 16:28:06 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/5] io_uring: consolidate CQ nr events calculation
Date:   Thu, 17 Dec 2020 00:24:37 +0000
Message-Id: <c62909101304bd7b530c81c5a5aac39c7477f4b4.1608164394.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1608164394.git.asml.silence@gmail.com>
References: <cover.1608164394.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a helper which calculates number of events in CQ. Handcoded version
of it in io_cqring_overflow_flush() is not the clearest thing, so it
makes it slightly more readable.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3c8134be4a05..8f3588f4cb38 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1694,6 +1694,11 @@ static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
 	return io_wq_current_is_worker();
 }
 
+static inline unsigned __io_cqring_events(struct io_ring_ctx *ctx)
+{
+	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
+}
+
 static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 {
 	if (waitqueue_active(&ctx->wait))
@@ -1724,14 +1729,10 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 	unsigned long flags;
 	LIST_HEAD(list);
 
-	if (!force) {
-		if ((ctx->cached_cq_tail - READ_ONCE(rings->cq.head) ==
-		    rings->cq_ring_entries))
-			return false;
-	}
+	if (!force && __io_cqring_events(ctx) == rings->cq_ring_entries)
+		return false;
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
-
 	cqe = NULL;
 	list_for_each_entry_safe(req, tmp, &ctx->cq_overflow_list, compl.list) {
 		if (!io_match_task(req, tsk, files))
@@ -2315,8 +2316,6 @@ static void io_double_put_req(struct io_kiocb *req)
 
 static unsigned io_cqring_events(struct io_ring_ctx *ctx, bool noflush)
 {
-	struct io_rings *rings = ctx->rings;
-
 	if (test_bit(0, &ctx->cq_check_overflow)) {
 		/*
 		 * noflush == true is from the waitqueue handler, just ensure
@@ -2331,7 +2330,7 @@ static unsigned io_cqring_events(struct io_ring_ctx *ctx, bool noflush)
 
 	/* See comment at the top of this file */
 	smp_rmb();
-	return ctx->cached_cq_tail - READ_ONCE(rings->cq.head);
+	return __io_cqring_events(ctx);
 }
 
 static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
-- 
2.24.0

