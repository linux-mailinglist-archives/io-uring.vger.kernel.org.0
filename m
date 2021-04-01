Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06E0935183A
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 19:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236319AbhDARoU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 13:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234706AbhDARjU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:39:20 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB00C00458C
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:37 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id m20-20020a7bcb940000b029010cab7e5a9fso2981053wmi.3
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=HLNGTEzvYLbEAo3ntTAXMGUhR/23pSiwjWAhwV93L3o=;
        b=VYuK2ruSs3aKK4JunOun2k3mb/fz1Rdxh1C5bs24Rk3jzwYP9oAVhmyjoPuliL2/FZ
         S/1lctxfUyj2JLUuh4UxLRtByCvoeSero7Kmu8DyOqCm76nCxii5uXnbKKgTmumZ6noj
         drQLOK8PS6i5EEBCvSI2hxisp9RyK5Y+NhEGvu5rLM++pi+hl4grYY9H0v6V5Zc5fulc
         gC8AYg9MZypQ/FFWyDDOPY37CI0MJcqwRXS+FBT5LL/3BtUpS+sT63WTTb52uag9Xe0T
         /3c4pGb3UKSzZqtlRS+4uB+vOURVsylIat1AGdHUm6OsqDQUZl2yur6qF7S9b5NZca9L
         yQrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HLNGTEzvYLbEAo3ntTAXMGUhR/23pSiwjWAhwV93L3o=;
        b=qWLtjIHkiENuDbA53tZbFfkFQKftRfGHIMv6hEhC5TqIYcZRWBU8zhu6pMegsTZAvS
         yOhSqAejfTV2AXNBO43x181JzIctqBmbs9CxXVhUhma6BI8KzH4yAtyA5LL5f/WbRlY+
         GzkLp2U0BspBqmAt0k7IoXihPpE7YQlxlTDnyTwJXYAqlR4ZmOXA19HXEsvfboMd2RXj
         l0j62FnYY9/PbZRzwrW/ZIm13CxP/bv9phwQKwZ5gnSmir7gbK8njR8IhI9AxcwHdSMV
         3znWk2of+DYYUGYmB744U9lpe5DbM44ZuntTDiYCwGzX12UV9lXdxvs9+KfL1ALK2+8r
         1Swg==
X-Gm-Message-State: AOAM530I27ZXrpk16T1wGbaYPlqEX1q7A9YJ31fzXpODFl9sNHoafPUM
        W+wmtsN57Qt6vMGktVr5LTFV1OAjbtUk8A==
X-Google-Smtp-Source: ABdhPJy/Y5siPItm+PsVi2PCKH3QFAJWA/hZStk9AvLsda6yWExob50DlL+CJsDvMwkqtmK8K+4K9A==
X-Received: by 2002:a05:600c:21ca:: with SMTP id x10mr8557168wmj.48.1617288516471;
        Thu, 01 Apr 2021 07:48:36 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 19/26] io_uring: simplify overflow handling
Date:   Thu,  1 Apr 2021 15:43:58 +0100
Message-Id: <5799867aeba9e713c32f49aef78e5e1aef9fbc43.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Overflowed CQEs doesn't lock requests anymore, so we don't care so much
about cancelling them, so kill cq_overflow_flushed and simplify the
code.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 683db49a766e..a621582a2f11 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -335,7 +335,6 @@ struct io_ring_ctx {
 	struct {
 		unsigned int		flags;
 		unsigned int		compat: 1;
-		unsigned int		cq_overflow_flushed: 1;
 		unsigned int		drain_next: 1;
 		unsigned int		eventfd_async: 1;
 		unsigned int		restricted: 1;
@@ -1522,8 +1521,7 @@ static bool __io_cqring_fill_event(struct io_kiocb *req, long res,
 		WRITE_ONCE(cqe->flags, cflags);
 		return true;
 	}
-	if (!ctx->cq_overflow_flushed &&
-	    !atomic_read(&req->task->io_uring->in_idle)) {
+	if (!atomic_read(&req->task->io_uring->in_idle)) {
 		struct io_overflow_cqe *ocqe;
 
 		ocqe = kmalloc(sizeof(*ocqe), GFP_ATOMIC | __GFP_ACCOUNT);
@@ -8468,6 +8466,8 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 
 	mutex_lock(&ctx->uring_lock);
 	io_sqe_files_unregister(ctx);
+	if (ctx->rings)
+		__io_cqring_overflow_flush(ctx, true);
 	mutex_unlock(&ctx->uring_lock);
 	io_eventfd_unregister(ctx);
 	io_destroy_buffers(ctx);
@@ -8669,8 +8669,6 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 
 	mutex_lock(&ctx->uring_lock);
 	percpu_ref_kill(&ctx->refs);
-	/* if force is set, the ring is going away. always drop after that */
-	ctx->cq_overflow_flushed = 1;
 	if (ctx->rings)
 		__io_cqring_overflow_flush(ctx, true);
 	xa_for_each(&ctx->personalities, index, creds)
-- 
2.24.0

