Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F0038215E
	for <lists+io-uring@lfdr.de>; Sun, 16 May 2021 23:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhEPV7y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 May 2021 17:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbhEPV7x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 May 2021 17:59:53 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48EFEC061573
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:37 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id j14so2688930wrq.5
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Qbgt4WWHRNe8+Z4dN3kKYnYVS6/xAlekxzvz1jM7ucQ=;
        b=vS3BsV7U4LRtOtn3oUjBrtmdG/Nng6fLnJxj2xFnzjSA31gcztLeTC/AvjXREIci/4
         2JNW1sRSqkP7HcyPN38441octRR+s2ncSXoMwj/QA5dqD07+j/iYJb+NazEzjdKtK/CA
         XxqhB6zZJhBI9ADH46nYri+Anip0t+R7WaW4ncKgP+AmEPQ+frvzKdYFj0kjJfHu+I/v
         PkifzoSB+Y0Jyeia6MYHRquWV6e/lshpt1w+c+M8n/GN4RALKHRZo0cCmNdsWKS77LfS
         rTuJw9ZrOuIYtb+P6eZBDLi/bP8B7GbqcuWtsgeH2fFltlwVQ2kZL03R7+xm6Ip4C9Gu
         AFgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qbgt4WWHRNe8+Z4dN3kKYnYVS6/xAlekxzvz1jM7ucQ=;
        b=QCx6lu3CkkC7jtIBFgzvtJzAmuTQTaK6jvUjO0vTUMMvW09IqmxTovX5c6hxBLgbCo
         I/pa9zh0JePalYKoeuVZNscF4ksLEOeV95SO+OlsOOPsaCxJPhzm3Hs3aoVXMhwJgBYv
         c65WeQuEcFd/PRmU8oWMfMV2nJtPeipGgbVgpukNwSe60R9MKKa7GTOoo1tR4uHb4zJj
         zD4Optsgxk3P5NqAge/FHd2jXbupN3X7U5LnMgPj7hbLPkD6lP67gsEf5A6FxYdlTqZi
         Yfw9g1UmbyX5m/ZYvsmMujMsR0ZXFu7nBF+xtkaL1jbUG9eqBJPqT1AJe7jg0ANFnAYy
         +ajg==
X-Gm-Message-State: AOAM530mqvahd3MMwBF49OakgkqjwpXINjBa8QkrFLw4WWHuFZlS3Yt5
        sXYyucGMhQm0Hcx66SJo+ydna6G1xeo=
X-Google-Smtp-Source: ABdhPJw4nkLPdY88W+w6cCDMqOwQ959REc8ZHQmFfxfIIqPqt/GRvsvbvjeD319ibc5RNZFuVOEeMA==
X-Received: by 2002:adf:ce09:: with SMTP id p9mr25689793wrn.114.1621202316087;
        Sun, 16 May 2021 14:58:36 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.7])
        by smtp.gmail.com with ESMTPSA id p10sm13666365wmq.14.2021.05.16.14.58.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 14:58:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 11/13] io_uring: kill cached_cq_overflow
Date:   Sun, 16 May 2021 22:58:10 +0100
Message-Id: <8427965f5175dd051febc63804909861109ce859.1621201931.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621201931.git.asml.silence@gmail.com>
References: <cover.1621201931.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are two copies of cq_overflow, shared with userspace and internal
cached one. It was needed for DRAIN accounting, but now we have yet
another knob to tune the accounting, i.e. cq_extra, and we can throw
away the internal counter and just increment the one in the shared ring.

If user modifies it as so never gets the right overflow value ever
again, it's its problem, even though before we would have restored it
back by next overflow.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2bdc30ebf708..df5d407a3ca2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -364,7 +364,6 @@ struct io_ring_ctx {
 		unsigned		sq_entries;
 		unsigned		sq_thread_idle;
 		unsigned		cached_sq_dropped;
-		unsigned		cached_cq_overflow;
 		unsigned long		sq_check_overflow;
 
 		struct list_head	defer_list;
@@ -1194,13 +1193,20 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	return NULL;
 }
 
+static void io_account_cq_overflow(struct io_ring_ctx *ctx)
+{
+	struct io_rings *r = ctx->rings;
+
+	WRITE_ONCE(r->cq_overflow, READ_ONCE(r->cq_overflow) + 1);
+	ctx->cq_extra--;
+}
+
 static bool req_need_defer(struct io_kiocb *req, u32 seq)
 {
 	if (unlikely(req->flags & REQ_F_IO_DRAIN)) {
 		struct io_ring_ctx *ctx = req->ctx;
 
-		return seq + ctx->cq_extra != ctx->cached_cq_tail
-				+ READ_ONCE(ctx->cached_cq_overflow);
+		return seq + READ_ONCE(ctx->cq_extra) != ctx->cached_cq_tail;
 	}
 
 	return false;
@@ -1439,8 +1445,8 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 		if (cqe)
 			memcpy(cqe, &ocqe->cqe, sizeof(*cqe));
 		else
-			WRITE_ONCE(ctx->rings->cq_overflow,
-				   ++ctx->cached_cq_overflow);
+			io_account_cq_overflow(ctx);
+
 		posted = true;
 		list_del(&ocqe->list);
 		kfree(ocqe);
@@ -1524,7 +1530,7 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 		 * or cannot allocate an overflow entry, then we need to drop it
 		 * on the floor.
 		 */
-		WRITE_ONCE(ctx->rings->cq_overflow, ++ctx->cached_cq_overflow);
+		io_account_cq_overflow(ctx);
 		return false;
 	}
 	if (list_empty(&ctx->cq_overflow_list)) {
-- 
2.31.1

