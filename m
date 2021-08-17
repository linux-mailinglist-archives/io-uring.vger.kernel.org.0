Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BC63EF2A7
	for <lists+io-uring@lfdr.de>; Tue, 17 Aug 2021 21:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbhHQT30 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Aug 2021 15:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbhHQT3Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Aug 2021 15:29:25 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118FFC061764
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 12:28:52 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id k8so11244269wrn.3
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 12:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yHh3U/1FHj7cuQuVSSCqv+8dTelYwLO04Yq72u9vtlQ=;
        b=YToaJ8wNzgwulbSDE/pC3F8Q6wKc8UwC7TD71KGlc8HKIo9G/gPDeymdQ3HUXJFYCK
         YVkDNKU1TKQRdXIao9q15F9xgSbNrpxBxP7ZVCYMK4RFsW7iAgoq+xwNrSQaORpraSs3
         aewitUOPz9ReNVWaMbqdWjmNL57enIFJuhOWYvpEQl+bU/do6sIETTHc6CEsb3iYQZ64
         V9LI6QVT6xnihID3tqDq4pZvU4wviCKHQpd045r0kXvBlWRghN84NpmB5ydY6ytdEwDM
         ihrlAazSwgJXw82aZoVNEGweWpLQIrkvwEzQaRFLnH2+2xiy/tx19kusw4azFsqRwNgf
         EnMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yHh3U/1FHj7cuQuVSSCqv+8dTelYwLO04Yq72u9vtlQ=;
        b=LCl9ZUkdfSIac+OWBiQ2/sK07cKOrhGkuiI5YCpClArqsp+1YggIwCtEOkj37lwxYl
         9YBY7iyA2NEhB+CgYCwC7M3AxhLlFyOPA2VNLxpVIBGCZK7eoWhsuqsjYoyPJxmT5uy0
         F5/aUgJUFKO0BKCjndN8jU95hfMaOwhH9cIqnt4UlwiXyva2SHpEVB6svJVkoTl90W34
         r0W4nlSDWd/89SLfsHNbbjrZempv8wqonWsY0RjuYc1o+iwPOCrH8YEtVI4xs6tICTbz
         lhfNSkVo4pZbhM0OP1946E89UtZz2s5wQyxkZ9/HCSeYQrX/kgmPk70UrwDEjYa/5RX/
         VT0g==
X-Gm-Message-State: AOAM533dNaY3QAMAvPfzW8dPmVGCuO8GloXkQxhdYfEStytPNgsBGdmc
        iq6y14SVLa2Hfeq+K1EoW8w=
X-Google-Smtp-Source: ABdhPJz3SME1E4aWd5DPOKXjR+maMpENdVJpwfjoFtTDFX+KrZpxY2ro1eGAQgjGI2OuyFSfcntyqA==
X-Received: by 2002:adf:a2c4:: with SMTP id t4mr6137411wra.258.1629228530774;
        Tue, 17 Aug 2021 12:28:50 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.12])
        by smtp.gmail.com with ESMTPSA id e6sm3120388wme.6.2021.08.17.12.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 12:28:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/4] io_uring: improve tctx_task_work() ctx referencing
Date:   Tue, 17 Aug 2021 20:28:10 +0100
Message-Id: <8494d5bac9e30dba7928d33b18f4d0ddeb9899ce.1629228203.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629228203.git.asml.silence@gmail.com>
References: <cover.1629228203.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring processed by tctx_task_work() can't get freed until the
function returns. The reason is that io_ring_exit_work() executes a
task_work after all references are put, where the task works
execution is naturally serialised. Remove extra ctx pinning.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 719d62b6e3d5..202517860c83 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2004,9 +2004,14 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx)
 		io_submit_flush_completions(ctx);
 		mutex_unlock(&ctx->uring_lock);
 	}
-	percpu_ref_put(&ctx->refs);
 }
 
+/*
+ * All the ctxs we operate on here will stay alive until the function returns.
+ * That's because initially they're refcounted by the requests, and after
+ * io_ring_exit_work() synchronises with the current task by injecting and
+ * waiting for a task_work, which can't be executed until it returns.
+ */
 static void tctx_task_work(struct callback_head *cb)
 {
 	struct io_ring_ctx *ctx = NULL;
@@ -2033,7 +2038,6 @@ static void tctx_task_work(struct callback_head *cb)
 			if (req->ctx != ctx) {
 				ctx_flush_and_put(ctx);
 				ctx = req->ctx;
-				percpu_ref_get(&ctx->refs);
 			}
 			req->io_task_work.func(req);
 			node = next;
-- 
2.32.0

