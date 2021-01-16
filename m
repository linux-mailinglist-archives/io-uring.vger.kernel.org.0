Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D88F2F8FE4
	for <lists+io-uring@lfdr.de>; Sun, 17 Jan 2021 00:41:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbhAPXle (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Jan 2021 18:41:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbhAPXlc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Jan 2021 18:41:32 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B90C061573
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 15:40:51 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id 6so5654256wri.3
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 15:40:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F6G+QZGlYfJYukfe5EqDROrUNvjlw0fpgAPQZe34V1k=;
        b=DrzeHzLtz4DiGypqCTUdRKC9s+ijRgErcriftNuQJZd716L7ZigCjTp3lDwdGLpdSp
         Cn97MLjflX0/PBCIaStaxxaIYIJE2w0VISCfr13KjWRsFhq2PjGa331/CzJc9qdzQ9zP
         InXaMVEmBBB5ik/q1LfEpvKjeJJP8qUPLWH8N7gy1VeJkv/CIGxoGGk7kc6WLmtxDJo2
         X41KuUUkWTS0I3Ex79Rw5ElKJpdwesjh8vaUmDw6TD0jnaOoy2BP+pwJaHxIpbshCeAl
         XUlm+frPZt0Dx6kUgfRB6OXiPbAFqx2jOA+qrzK4yv7bTVj6KRTI2NIbAlnoyOe1WJHM
         ML0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F6G+QZGlYfJYukfe5EqDROrUNvjlw0fpgAPQZe34V1k=;
        b=nSf00uf26pBx5FZStJvfqf2dZVGhvZ4eyl8WpWTMMGrJZYHCM6U+A400YKXN1b46lk
         tORo40jmQjXiLqq99x4/5t5dDtsb1Z6BzpuA5OesohBdz5hA14S9pMItBHx/5ULSRlSR
         htFoPUqMNNQ85ZtcS76ZqVa5ap7BVHNA3f4qBf63fNGQm771mpMh/DjJ2dhD8U0q7Fc+
         AffdyI80Bsm36aELn/Dk2lctuSLIGR42eazaQfYpJnfnJy8gSwKAYUNJmuF9zHGze+mo
         qQDDYh9Eu9zNCFYm5JvdvCXk/u9t8yuTg4gCV7vcRMy552DF8ZQFIbatjdKKLlYQYujB
         9oGQ==
X-Gm-Message-State: AOAM5307EsfOTW3pALZq8pTAJxlGMVon9tvg30nUupYZNaTYckJxUWIM
        bYzRRm+X9wAZKAuQ9+WhQsU=
X-Google-Smtp-Source: ABdhPJzzbSCdD4JCxjnfGyRSEj8r/DzFfXeSKptlmcZoPiBzZd+k2YR2rZ+mZqaFCJS98+rWB6GyMA==
X-Received: by 2002:adf:e704:: with SMTP id c4mr19693481wrm.355.1610840450543;
        Sat, 16 Jan 2021 15:40:50 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.150])
        by smtp.gmail.com with ESMTPSA id l11sm19815181wrt.23.2021.01.16.15.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 15:40:49 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH] io_uring: fix skipping disabling sqo on exec
Date:   Sat, 16 Jan 2021 23:37:07 +0000
Message-Id: <3148c408259dd9f2e12a1877cbe8ca9c29325c5a.1610840103.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If there are no requests at the time __io_uring_task_cancel() is called,
tctx_inflight() returns zero and and it terminates not getting a chance
to go through __io_uring_files_cancel() and do
io_disable_sqo_submit(). And we absolutely want them disabled by the
time cancellation ends.

Also a fix potential false positive warning because of ctx->sq_data
check before io_disable_sqo_submit().

Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

To not grow diffstat now will be cleaned for-next

 fs/io_uring.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d494c4269fc5..0d50845f1f3f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8937,10 +8937,12 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 {
 	struct task_struct *task = current;
 
-	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
+	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		/* for SQPOLL only sqo_task has task notes */
 		WARN_ON_ONCE(ctx->sqo_task != current);
 		io_disable_sqo_submit(ctx);
+	}
+	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
 		task = ctx->sq_data->thread;
 		atomic_inc(&task->io_uring->in_idle);
 		io_sq_thread_park(ctx->sq_data);
@@ -9085,6 +9087,10 @@ void __io_uring_task_cancel(void)
 	/* make sure overflow events are dropped */
 	atomic_inc(&tctx->in_idle);
 
+	/* trigger io_disable_sqo_submit() */
+	if (tctx->sqpoll)
+		__io_uring_files_cancel(NULL);
+
 	do {
 		/* read completions before cancelations */
 		inflight = tctx_inflight(tctx);
-- 
2.24.0

