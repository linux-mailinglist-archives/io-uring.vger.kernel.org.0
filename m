Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D1632E09E
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 05:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhCEEW2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 23:22:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhCEEW2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 23:22:28 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B6FC061574
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 20:22:28 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id w11so594105wrr.10
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 20:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7DgGWOlRCs3G7JD9sGeeDW/VKLb/rwF/h0oAT/pa71s=;
        b=cjL05H8uX3n/z+kSl/oamz19gRbWbH644lfU6xrQis0D3OarmaYMAOhb5yTCNzN2ha
         +rhSRTssjtkPNTLVp/e7HJ+KjKbHeUqJT4EFN6mE7BWBQ7lZhC/pcx6ZRBRN8blEsMkI
         BelbPK92pFg2ankrIUMNEwFnf2ndBh+hNIEZqAAd7JtK6HZKDKNcNJZOpWdYep7/0l8r
         wWhWYex7ADCzmw8dSjVshTRbVWGQn7ieVC3vxQjnIptTCaU6VPcWzBWqpD3l6646ubxz
         upvQgulI/j1qFE+mLnrUSO/RjU57NNOLhuaOEj1R5uEvES4ovpcVe2xlU0zsurIy3RFw
         ibrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7DgGWOlRCs3G7JD9sGeeDW/VKLb/rwF/h0oAT/pa71s=;
        b=kwEwuIqDS32hWKck0DEQ3ePgdpoQxk6gjSDLptfxL3k1cwTW5ziIsNiz4JedvnTexg
         lPwMD6zx4D08T5WANROqx9+o5b01X9mRgGlbCIAoc82O2m2H0TzYQJnQfefWuFcvLfn5
         /7DMgX1kppt/wTG00uLSW0d3+7UuZW70ms5S8hpQP+XG6zZ9YnTx3KiciEo+JMjQDjqW
         N9uOnpz1l2Oe+/8k5snpHbYUMJkjbi4ZBUxrMD5ZwIr+H6ReKBTw7SajqD/ru8m9w9kP
         Yu0JGhdFDybfXA4C1J5gV5yzzrH9XspNWocIzZJI223ykY1CgDhqZvm+Su8wKLyliupa
         debw==
X-Gm-Message-State: AOAM530f6oq84/zPN7K/LUx9sgqY8EdtOQP8K97CeI8cVZp94AuRNf9I
        E5qSW3uVcWv2z7yIzsdJkHrTAJCqommABQ==
X-Google-Smtp-Source: ABdhPJzKP7csH768o7kzEM29RDvBAmuVpCJqmN8YX8r+X8pmRKvseXPcOBSBm5wMkCsg2Uq01SaCqw==
X-Received: by 2002:adf:ed46:: with SMTP id u6mr7153660wro.350.1614918146876;
        Thu, 04 Mar 2021 20:22:26 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id z3sm2170446wrs.55.2021.03.04.20.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 20:22:26 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 3/6] io_uring: do ctx initiated file note removal
Date:   Fri,  5 Mar 2021 04:18:21 +0000
Message-Id: <5a3fc5d9f446b4ec7f3a34ae466b63d14dda8d30.1614917790.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614917790.git.asml.silence@gmail.com>
References: <cover.1614917790.git.asml.silence@gmail.com>
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
index e62f28512cc4..9865b2c708c2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -987,6 +987,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_UNLINKAT] = {},
 };
 
+static void io_uring_del_task_file(unsigned long index);
 static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
 					 struct files_struct *files);
@@ -8528,10 +8529,33 @@ static bool io_run_ctx_fallback(struct io_ring_ctx *ctx)
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
@@ -8542,6 +8566,26 @@ static void io_ring_exit_work(struct work_struct *work)
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

