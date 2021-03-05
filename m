Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF3932EBDB
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 14:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbhCENDG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 08:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbhCENCr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Mar 2021 08:02:47 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF58FC061574
        for <io-uring@vger.kernel.org>; Fri,  5 Mar 2021 05:02:46 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id m7so1409615wmq.0
        for <io-uring@vger.kernel.org>; Fri, 05 Mar 2021 05:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7DgGWOlRCs3G7JD9sGeeDW/VKLb/rwF/h0oAT/pa71s=;
        b=GjFrXnayYRBsD7W4kvaHuv4Xmvmoruic8YN+z/9nO3G0c99EFdEJcau5t3Mf356eG/
         ViGMMNwSifR6KkQ5FAkCRqVAA+zeooQmcF1iwZuXLsBQFzoBJA0xjOIrSxqArrHTPXw/
         tgMjs1jK6QrYT29KK5W3+PSLrUEs+m4JzEdUjYjpr/CHnCozdWeqiaB+uQiJsYm2rJQ0
         xCf1mgAwjLLKC/mySK+TTi8VQHVuqRdsh7gchmqPD3sN5Tiv+ZOi8oqArT6cbziZ44XK
         xYRZ9Hlv1aDmgnqDNGlpZ4K4UefcPtSIYu6Mo/HZZkJD538n0EEfT6l4G+dUjlyreN/Q
         aOIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7DgGWOlRCs3G7JD9sGeeDW/VKLb/rwF/h0oAT/pa71s=;
        b=srWeGW6cHszlcw9YR0El40Aq6K7wkMQ+JrCGHpH6FOO+xLh82E+N1aS8XNULpZ3TCj
         2Wp2pWnyB9l7oVFCEUyNAIYE5Zltal0rr9ixLsV9tCEsSWBt8Z7Go1+/s8H6j+7Aal3Q
         Os58vph4AitPDgcMPyu99UCys4gYUFIfXHnQ+j5WURGpVSJOT5WRdMyVlQSI1V5DxZHI
         SnxXCsTfw26muCPd2OjF11fZeYB7LwHfwEm6cyeK4gcM2yZWBUj6jYv50DuxfHAUcgND
         jTu3U7LR9EUSkC1y6M0xJJ0+63AITBTHK3lI/VyRibOppNKebnyTockHH3Lp15r1NWGw
         qngQ==
X-Gm-Message-State: AOAM531bdSg51kvFkj7Fjw2SGXxF+rnraReAZpDLWTt4Cv2fqBrhcx2+
        KBDahpSpYsgEPgCMC0a5qB4=
X-Google-Smtp-Source: ABdhPJwRgRtbom+FZTqfoHbOCcVYuTu+Af1ZcSalDUCZ4tvCLAcwMO2r2Hfslghrhse59lU/4GRtmw==
X-Received: by 2002:a7b:ce06:: with SMTP id m6mr8612193wmc.38.1614949365507;
        Fri, 05 Mar 2021 05:02:45 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id h20sm4345385wmm.19.2021.03.05.05.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 05:02:45 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 3/6] io_uring: do ctx initiated file note removal
Date:   Fri,  5 Mar 2021 12:58:38 +0000
Message-Id: <5a3fc5d9f446b4ec7f3a34ae466b63d14dda8d30.1614942979.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614942979.git.asml.silence@gmail.com>
References: <cover.1614942979.git.asml.silence@gmail.com>
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

