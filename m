Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90FA32F99B
	for <lists+io-uring@lfdr.de>; Sat,  6 Mar 2021 12:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhCFLHF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 6 Mar 2021 06:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230520AbhCFLGX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 6 Mar 2021 06:06:23 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2DCC061760
        for <io-uring@vger.kernel.org>; Sat,  6 Mar 2021 03:06:23 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id t5-20020a1c77050000b029010e62cea9deso828751wmi.0
        for <io-uring@vger.kernel.org>; Sat, 06 Mar 2021 03:06:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=tvPZupPBRro7u0YSUVzdYpSgkLqhExfIBXer8wAcIyI=;
        b=TwoOme3tfEwMyqVhLyhs7JJ7VR8a+nkMm5pxGOyttbzBymQyyB3uM4XPtPZrGnpxr3
         Qr4Mbu4xOFlAPYzjgjhRgsyM67Rj40sUVsKRQXr8ji5tro+RH82JcnxuqHjapPPMm8yi
         pAksv6lPsQPhVuxonDzGsifxftXb66UEGNymlCP8KdLf2y8fkeTrBlkvSvjhppxxZPNa
         oiXDF8I3A7MFqVqDoRgWV2b71FhgkniM8dZFB8T53SjURSca+QGjScXqnXKhgj52nk1p
         0wOYEc1sv0XI332giW4bXcA+alR6HZ2zUbRku805LjE/mIZPAD4QZponUJVIpbwOL4bZ
         0hRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tvPZupPBRro7u0YSUVzdYpSgkLqhExfIBXer8wAcIyI=;
        b=lqNsxgpKsSfBgwnFUtPvKZm8ywezxVY3VmsuzaMLdVzv8wv0FI0Ig8oIVEglajxkO/
         MGNSr5sE5KhD38qWF5IypbEzwwgtcC4t1Qgxvg8z1xO1svIezOX9YXJGorEpUrAB3bfB
         Kshga+Ti2QpfZduh8pLFYB8sIKaKVD6pRnXM/P5dj9aTm9fSDVyIFEXFUz4tJKezxL1V
         sX3AgRv0UOCGr3tVAVbyha+0iP57dqXrCXIMTrAwwB6S7d2Emyz0B7gCMTWFve0pJn93
         9/++nGrbFyqC2xMqxR8ioNfA0GDJ53DvoCdi60oifbXhE28FK3dz1CCJCeyLM8UpHLhM
         gZng==
X-Gm-Message-State: AOAM531cWlqd5YQvxZ+nm+d2PhZGONa4H/wNL5TuFqp4gviOjB1HXEl/
        3IfHm8lKVMA5yAyidW9wfu4=
X-Google-Smtp-Source: ABdhPJyBnVsdf23VUkIZGeQKQPIziob2HBZwQrfDgAv/SB8e6irs8QUn1k5xyiYPe3HtLptWmJReKQ==
X-Received: by 2002:a1c:f702:: with SMTP id v2mr12831378wmh.131.1615028782203;
        Sat, 06 Mar 2021 03:06:22 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.8])
        by smtp.gmail.com with ESMTPSA id h2sm9442365wrq.81.2021.03.06.03.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 03:06:21 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 3/8] io_uring: do ctx initiated file note removal
Date:   Sat,  6 Mar 2021 11:02:13 +0000
Message-Id: <c616e1a1fcea0c59ae7a25120f8da93de4903469.1615028377.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615028377.git.asml.silence@gmail.com>
References: <cover.1615028377.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Another preparation patch. When full quiesce is done on ctx exit, use
task_work infra to remove corresponding to the ctx io_uring->xa entries.
For that we use the back tctx map. Also use ->in_idle to prevent
removing it while we traversing ->xa on cancellation, just ignore it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f26f8199e4ab..692096e85749 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -987,6 +987,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_UNLINKAT] = {},
 };
 
+static void io_uring_del_task_file(unsigned long index);
 static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
 					 struct files_struct *files);
@@ -8531,10 +8532,33 @@ static bool io_run_ctx_fallback(struct io_ring_ctx *ctx)
 	return executed;
 }
 
+struct io_tctx_exit {
+	struct callback_head		task_work;
+	struct completion		completion;
+	unsigned long			index;
+};
+
+static void io_tctx_exit_cb(struct callback_head *cb)
+{
+	struct io_uring_task *tctx = current->io_uring;
+	struct io_tctx_exit *work;
+
+	work = container_of(cb, struct io_tctx_exit, task_work);
+	/*
+	 * When @in_idle, we're in cancellation and it's racy to remove the
+	 * node. It'll be removed by the end of cancellation, just ignore it.
+	 */
+	if (!atomic_read(&tctx->in_idle))
+		io_uring_del_task_file(work->index);
+	complete(&work->completion);
+}
+
 static void io_ring_exit_work(struct work_struct *work)
 {
-	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
-					       exit_work);
+	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx, exit_work);
+	struct io_tctx_exit exit;
+	struct io_tctx_node *node;
+	int ret;
 
 	/*
 	 * If we're doing polled IO and end up having requests being
@@ -8545,6 +8569,26 @@ static void io_ring_exit_work(struct work_struct *work)
 	do {
 		io_uring_try_cancel_requests(ctx, NULL, NULL);
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
+
+	mutex_lock(&ctx->uring_lock);
+	while (!list_empty(&ctx->tctx_list)) {
+		node = list_first_entry(&ctx->tctx_list, struct io_tctx_node,
+					ctx_node);
+		exit.index = (unsigned long)node->file;
+		init_completion(&exit.completion);
+		init_task_work(&exit.task_work, io_tctx_exit_cb);
+		ret = task_work_add(node->task, &exit.task_work, TWA_SIGNAL);
+		if (WARN_ON_ONCE(ret))
+			continue;
+		wake_up_process(node->task);
+
+		mutex_unlock(&ctx->uring_lock);
+		wait_for_completion(&exit.completion);
+		cond_resched();
+		mutex_lock(&ctx->uring_lock);
+	}
+	mutex_unlock(&ctx->uring_lock);
+
 	io_ring_ctx_free(ctx);
 }
 
-- 
2.24.0

