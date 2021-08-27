Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 779F83F9850
	for <lists+io-uring@lfdr.de>; Fri, 27 Aug 2021 12:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244836AbhH0K4b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 06:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244780AbhH0K4a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 06:56:30 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B848BC061757
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 03:55:41 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id d26so9849246wrc.0
        for <io-uring@vger.kernel.org>; Fri, 27 Aug 2021 03:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=01DvQr2cEuWNtb7tmK1WB9oVTzT3UJVtJBO5WH57Xf4=;
        b=nt3tVYntRh5K6byQmMHNI5MLbwf+LgCGKsaG1w7N2ZMkZFTDkJ8xiZVmp7uZIe3IzV
         ZbaqEAktRUNs4j7cxgGT17OI82qo8TWnhBOgfT3CV3vvY6zb116/6zWq+ch4ZWQYP2o3
         SR0eItpFRzD2RJYxDddbu3zbfP0rm6HgdLrGcwnNu0IBwoo0UxYHRtRZMQtUdA2NISm3
         raNeS5yZEGEiiyVJDzeTLxxKJM/o3a250v5MXU9M8S6SGrvQ9hC4g+1IaTJZITJwhEx5
         58uvCIIxzpm6+7AJ19bLwGzaJEkvbDh53g3bLB497dlJwBFdoiPG+rSSIzVGbxFHYAU1
         lzuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=01DvQr2cEuWNtb7tmK1WB9oVTzT3UJVtJBO5WH57Xf4=;
        b=mT77OZgdssMLCsfGcACK3ov9R23laNeAaqOETiuu1PZJv6atHLxra/2qDJlxv/PBuB
         bGL0lGJJdsgJGYr1jnv59JhIJpb3X3OcMkdd0d2hvHBRXpaV5kplwWgQLT0aBePyAuie
         WrMVIYNscE7uSfOK3FYMKnLDDGtQhgEibgG2nEarIK3yxeRj7WcMMW5u5HCGSheJFb35
         kfDCZ6G6yIc7xEsLFsE+iDtsI9irnI3rjEBsmRXeeC8+cDxo8b0e8YoGwAIHAu4h+7Q0
         DlRMpkrscHkhLNtLchnaEWspU/39QR41H/VPnjTt4o2J41bk1/80KzebAsKgv143qMsz
         wFjQ==
X-Gm-Message-State: AOAM531Mlkj9PiHbeGG894twcw0UqS6Xyo8gFE506ZSQmQK30YTkEl2E
        vNGwzUPMcOdwrVw8RBEinLVfVHo9YHo=
X-Google-Smtp-Source: ABdhPJx/UXyhPt3+CbL1K8RCSakPjPx0MWO3i2HQ5NFNyhSokK1uL5Z2ssB1mssewN+qf9ZtGESL9w==
X-Received: by 2002:adf:f7ce:: with SMTP id a14mr9491161wrq.174.1630061740340;
        Fri, 27 Aug 2021 03:55:40 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.94])
        by smtp.gmail.com with ESMTPSA id d9sm7468556wrb.36.2021.08.27.03.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 03:55:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH for-next] io_uring: add task-refs-get helper
Date:   Fri, 27 Aug 2021 11:55:01 +0100
Message-Id: <d9114d037f1c195897aa13f38a496078eca2afdb.1630023531.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As we have a more complicating task referencing, which apart from normal
task references includes taking tctx->inflight and caching all that, it
would be a good idea to have all that isolated in helpers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6112318a770c..af575053257d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1663,6 +1663,24 @@ static inline void io_put_task(struct task_struct *task, int nr)
 	}
 }
 
+static void io_task_refs_refill(struct io_uring_task *tctx)
+{
+	unsigned int refill = -tctx->cached_refs + IO_TCTX_REFS_CACHE_NR;
+
+	percpu_counter_add(&tctx->inflight, refill);
+	refcount_add(refill, &current->usage);
+	tctx->cached_refs += refill;
+}
+
+static inline void io_get_task_refs(int nr)
+{
+	struct io_uring_task *tctx = current->io_uring;
+
+	tctx->cached_refs -= nr;
+	if (unlikely(tctx->cached_refs < 0))
+		io_task_refs_refill(tctx);
+}
+
 static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 				     long res, unsigned int cflags)
 {
@@ -6854,25 +6872,15 @@ static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	__must_hold(&ctx->uring_lock)
 {
-	struct io_uring_task *tctx;
 	int submitted = 0;
 
 	/* make sure SQ entry isn't read before tail */
 	nr = min3(nr, ctx->sq_entries, io_sqring_entries(ctx));
 	if (!percpu_ref_tryget_many(&ctx->refs, nr))
 		return -EAGAIN;
+	io_get_task_refs(nr);
 
-	tctx = current->io_uring;
-	tctx->cached_refs -= nr;
-	if (unlikely(tctx->cached_refs < 0)) {
-		unsigned int refill = -tctx->cached_refs + IO_TCTX_REFS_CACHE_NR;
-
-		percpu_counter_add(&tctx->inflight, refill);
-		refcount_add(refill, &current->usage);
-		tctx->cached_refs += refill;
-	}
 	io_submit_state_start(&ctx->submit_state, nr);
-
 	while (submitted < nr) {
 		const struct io_uring_sqe *sqe;
 		struct io_kiocb *req;
-- 
2.33.0

