Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13CA135D51C
	for <lists+io-uring@lfdr.de>; Tue, 13 Apr 2021 04:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241515AbhDMCD3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Apr 2021 22:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241565AbhDMCD3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Apr 2021 22:03:29 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26689C061574
        for <io-uring@vger.kernel.org>; Mon, 12 Apr 2021 19:03:10 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id p6so8077723wrn.9
        for <io-uring@vger.kernel.org>; Mon, 12 Apr 2021 19:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=StHXl76RqwS/zlknVsZDrFoac/r4juYYV00MZDBFMZA=;
        b=MzBUekHUmbs8EZ4h+h0XOw0Df6FAnCMVoevEpJZjSL1Fhp6W6EZHwBCI77gDdljsjk
         89hYcPikcBMb3W6P30MRD69RvlPprI7Ib+0JCC93iWlaThIo7GZDegzul5YhjY9n7Y0J
         anS03660ALqfOWCAu1I5S1MooObZIBBiLgXTF5k1LN5/Qxjhiw3Mzp6dOLP9HbJ30DRY
         3zjZTTDd0DR7bvbUdV22sXXnJQhK1WhMvN74eCA9vfwyhxRFdUymIn3JonfJgJia2Rxz
         t1rsue+3RgZiz+MoE4xpxt1wspR2+FBhPy0/FvlBVaYis91msjyX0r6tz8cEUD8++e6H
         dp4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=StHXl76RqwS/zlknVsZDrFoac/r4juYYV00MZDBFMZA=;
        b=Y62BwBN7oS3l2y/8KZSe86Dq6mjVCqNm7OR2y5jNW5t0cwKVdwBFQjP0PLy08lbtFM
         Ty0ZmgPmyq002Hm50z8TPeJbQZEm10Kljme1ZBmzHX8b8xP2dU1arIutMbTpR3VfnYDL
         AEJMclACHSfWkp/cxceq5sUorAPSeZ9R8jiOTtHWwShaw59GrD+QVMM5YQq/qLrvmtb5
         pGFgzbCJZBrcG0Mr26JAOSAfBFPMUjrtNkezZGAjlv3yPIiP6FScS6YQwYmqB334BcNm
         fac9Fs/QY5fRLbt8furlAk/oiUcCmMQeWgLsxCJH7M7RZMJGwEDBFKkP8XH0eRFXkRz+
         SWJA==
X-Gm-Message-State: AOAM533GXvFw28Q6MQPC0w6PA4NLNbxZ3+D4qY6n6B+qA8Fg948SykcY
        0WARqxAT5fUZlFucqS7Ed9M=
X-Google-Smtp-Source: ABdhPJz3kfwIYogUiKtra9IsQwVfvlgSgx1Krn/LKoTnNE/hbztZwQwB9SWsccLFwucAEdhbG17HOQ==
X-Received: by 2002:adf:cd82:: with SMTP id q2mr19464609wrj.255.1618279388964;
        Mon, 12 Apr 2021 19:03:08 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.208])
        by smtp.gmail.com with ESMTPSA id k7sm18771331wrw.64.2021.04.12.19.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 19:03:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 7/9] io_uring: don't fail overflow on in_idle
Date:   Tue, 13 Apr 2021 02:58:44 +0100
Message-Id: <d873b7dab75c7f3039ead9628a745bea01f2cfd2.1618278933.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618278933.git.asml.silence@gmail.com>
References: <cover.1618278933.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As CQE overflows are now untied from requests and so don't hold any
ref, we don't need to handle exiting/exec'ing cases there anymore.
Moreover, it's much nicer in regards to userspace to save overflowed
CQEs whenever possible, so remove failing on in_idle.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 4407ebc8f8d3..cc6a44533802 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1515,32 +1515,28 @@ static bool io_cqring_event_overflow(struct io_kiocb *req, long res,
 				     unsigned int cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_overflow_cqe *ocqe;
 
-	if (!atomic_read(&req->task->io_uring->in_idle)) {
-		struct io_overflow_cqe *ocqe;
-
-		ocqe = kmalloc(sizeof(*ocqe), GFP_ATOMIC | __GFP_ACCOUNT);
-		if (!ocqe)
-			goto overflow;
-		if (list_empty(&ctx->cq_overflow_list)) {
-			set_bit(0, &ctx->sq_check_overflow);
-			set_bit(0, &ctx->cq_check_overflow);
-			ctx->rings->sq_flags |= IORING_SQ_CQ_OVERFLOW;
-		}
-		ocqe->cqe.user_data = req->user_data;
-		ocqe->cqe.res = res;
-		ocqe->cqe.flags = cflags;
-		list_add_tail(&ocqe->list, &ctx->cq_overflow_list);
-		return true;
+	ocqe = kmalloc(sizeof(*ocqe), GFP_ATOMIC | __GFP_ACCOUNT);
+	if (!ocqe) {
+		/*
+		 * If we're in ring overflow flush mode, or in task cancel mode,
+		 * or cannot allocate an overflow entry, then we need to drop it
+		 * on the floor.
+		 */
+		WRITE_ONCE(ctx->rings->cq_overflow, ++ctx->cached_cq_overflow);
+		return false;
 	}
-overflow:
-	/*
-	 * If we're in ring overflow flush mode, or in task cancel mode,
-	 * or cannot allocate an overflow entry, then we need to drop it
-	 * on the floor.
-	 */
-	WRITE_ONCE(ctx->rings->cq_overflow, ++ctx->cached_cq_overflow);
-	return false;
+	if (list_empty(&ctx->cq_overflow_list)) {
+		set_bit(0, &ctx->sq_check_overflow);
+		set_bit(0, &ctx->cq_check_overflow);
+		ctx->rings->sq_flags |= IORING_SQ_CQ_OVERFLOW;
+	}
+	ocqe->cqe.user_data = req->user_data;
+	ocqe->cqe.res = res;
+	ocqe->cqe.flags = cflags;
+	list_add_tail(&ocqe->list, &ctx->cq_overflow_list);
+	return true;
 }
 
 static inline bool __io_cqring_fill_event(struct io_kiocb *req, long res,
-- 
2.24.0

