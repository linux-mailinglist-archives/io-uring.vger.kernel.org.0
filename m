Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44BED38215C
	for <lists+io-uring@lfdr.de>; Sun, 16 May 2021 23:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhEPV7x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 May 2021 17:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhEPV7u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 May 2021 17:59:50 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E7BC061573
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:35 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id j14so2688900wrq.5
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=bKLos4oxsgVOB+++6jmjMoKAI67WJoZjIhtpwBgsdKw=;
        b=Q5r9fGy/AVohae/GI/5DmXUxaFH3Hw4Zli5SAWHgEAX6YDwY+0WaWrq5TO6ECaUppI
         +pydqyiIaiyDSP8nl2BXpTwm/RzoAdAicXjoyp7lsfqP1FMEThQTaVq+F/onSzc6Kcv9
         8iagWdpk/YxnQIBiEV4wMOx+fXz1A1/NAqZb+eepa/veJlbgQ9qirjMMSuCZm6so++l0
         WbrTnUrsxVo2LYRaDE4vZm/FiZFvqmjZie+UyXYIQ416OIsbcbQS5sndCG3UvT6g67Ms
         4MpkPR6Yvfg9MSG+NSOkvpE4eLKz0RM1a35mML+EnL04/KCvmQv12Hnk/q30UBNoPkJ7
         3xcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bKLos4oxsgVOB+++6jmjMoKAI67WJoZjIhtpwBgsdKw=;
        b=Uh+eKSbQNye3T5OdG/oJwegbJ6e+BAacwv88k2kKVQ76c77T+MYsmXIZzaPvJ2+YUR
         8eRhiQ4gs09+gbmYLGR9qfQ+R4dTLcQ6ggsgCX1rXRhN3Q6B0WaUL2oJcXP0R/UNkf2k
         npGLWeAx1d4/z6ECwfqvATX8nWqQRgOqNTlLtRmpOuf0PRx6JtyRAWsDO1j5t93cOFcH
         695wggaK50P8gazLhFOG/mNf83v5oPFJa586DBA+3U243yH8SqKIoo75HMaPHWESPwB0
         9hHEdpOH1Oy3t8sz4L94Jb0TPVwARr21wCvdA6biRfOzXcd3czdq/BoOTQ3KwOrOzB9I
         b/Cg==
X-Gm-Message-State: AOAM530SToyN0Bdvzg5VU5/lre71a0VsVStmoSshQ9vwYWru+71++ySc
        21bCi1G6M9d3e2MuqEYd7TLudYSmTrA=
X-Google-Smtp-Source: ABdhPJzsh+aMy3VdGoUPjCwuCAWFelsqWxMjgomrg58WZ+L8+Yr0HiCrRMrROHwdEf37Icc7n4kRfA==
X-Received: by 2002:a5d:5184:: with SMTP id k4mr25162417wrv.84.1621202314358;
        Sun, 16 May 2021 14:58:34 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.7])
        by smtp.gmail.com with ESMTPSA id p10sm13666365wmq.14.2021.05.16.14.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 14:58:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 09/13] io_uring: remove dependency on ring->sq/cq_entries
Date:   Sun, 16 May 2021 22:58:08 +0100
Message-Id: <745d31bc2da41283ddd0489ef784af5c8d6310e9.1621201931.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621201931.git.asml.silence@gmail.com>
References: <cover.1621201931.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have numbers of {sq,cq} entries cached in ctx, don't look up them in
user-shared rings as 1) it may fetch additional cacheline 2) user may
change it and so it's always error prone.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 10970ed32f27..f06bd4123a98 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1351,7 +1351,7 @@ static inline bool io_sqring_full(struct io_ring_ctx *ctx)
 {
 	struct io_rings *r = ctx->rings;
 
-	return READ_ONCE(r->sq.tail) - ctx->cached_sq_head == r->sq_ring_entries;
+	return READ_ONCE(r->sq.tail) - ctx->cached_sq_head == ctx->sq_entries;
 }
 
 static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
@@ -1369,7 +1369,7 @@ static inline struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
 	 * control dependency is enough as we're using WRITE_ONCE to
 	 * fill the cq entry
 	 */
-	if (__io_cqring_events(ctx) == rings->cq_ring_entries)
+	if (__io_cqring_events(ctx) == ctx->cq_entries)
 		return NULL;
 
 	tail = ctx->cached_cq_tail++;
@@ -1422,11 +1422,10 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 /* Returns true if there are no backlogged entries after the flush */
 static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 {
-	struct io_rings *rings = ctx->rings;
 	unsigned long flags;
 	bool all_flushed, posted;
 
-	if (!force && __io_cqring_events(ctx) == rings->cq_ring_entries)
+	if (!force && __io_cqring_events(ctx) == ctx->cq_entries)
 		return false;
 
 	posted = false;
-- 
2.31.1

