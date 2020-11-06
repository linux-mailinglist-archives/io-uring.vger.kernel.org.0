Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1692A96A0
	for <lists+io-uring@lfdr.de>; Fri,  6 Nov 2020 14:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbgKFNDr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Nov 2020 08:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727345AbgKFNDq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Nov 2020 08:03:46 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0D1C0613CF
        for <io-uring@vger.kernel.org>; Fri,  6 Nov 2020 05:03:46 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id p1so1228888wrf.12
        for <io-uring@vger.kernel.org>; Fri, 06 Nov 2020 05:03:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=cMsbN1cXUOhDnKA9vLFqVPAMTnB7NDJm50LxYgeXtBI=;
        b=N0eWwiSJmtqfO+uv3Hcn6VD0v/DunhZQ4WpLlUPEK3yOQuKZosp9+bS073xCeysJLy
         oVgr82lEHmCf/7WRY5osP1GGovjsaBq1qKm2RTMCAhhSGDUoQpOfYq0oFSYOxExNvdu/
         SY536dj9VhR8nTqYdneL1cj/9zYzlWsstv6B2n5SisuIVj1Kgv51Ub+ZwXkZcoEkoWWZ
         0KC0jrn36OptPv/bYZuNU86AJPk2ihPMh8oumZPz1KJ7088vH1Rgp/Kp3uVTmzri0m1a
         T8Ll70JH3OS/+4ft/Jlf90uZbBBAHQFDQsw2fAbd77ivit6VZNq1VrdFlIKVzTFthshL
         EGeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cMsbN1cXUOhDnKA9vLFqVPAMTnB7NDJm50LxYgeXtBI=;
        b=gnymYOZ8Dugx8wekLgvnHB4MfAds/3IGNFYGgEIRYaqwn4pDcAmw2K7hEDvFe5PqEa
         VyTsXyFx9+GqS/AosK5sp2Ksehys7Bb/ykgQXu4WJdedVqpcfps+h3Metwn67AOADQH/
         9BUL2daorpJObo+xayQVQq5xAXhnE8ueKqtbiFe/0SZVFpA0P6AkWRJg5mcENSimQO6m
         nCi5F7Jveuruf2tSlAxB1R/aJ3EcmukIA4dlM1LsfrY85RJ5P02UQIQR0BcIrqgRha3A
         P/axcmJe/uWPrNy2ZZAIAWRsP/tkDN4jqa5fchmzPxRBazsJAe/lFvH4RBbQArHuf/At
         8F8w==
X-Gm-Message-State: AOAM532ESM2jCknKkf/IELLLNoTwYV0Mqemx+xGsuWkWw5hRWVmnBDql
        reMTGLGRa8feR64QU6TKgEA=
X-Google-Smtp-Source: ABdhPJyWOyu9v6W9bnj8uYqfYrfuz5WLhjD/PPGdVL0ZYMBBziMtpPgv6lUB2L2NQpia4g1GqmkYgA==
X-Received: by 2002:adf:93e1:: with SMTP id 88mr2481227wrp.37.1604667825112;
        Fri, 06 Nov 2020 05:03:45 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id e5sm1931839wrw.93.2020.11.06.05.03.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 05:03:44 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/6] io_uring: pass files into kill timeouts/poll
Date:   Fri,  6 Nov 2020 13:00:25 +0000
Message-Id: <223ca90aa569d0f9f166634cef520f14202b8124.1604667122.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1604667122.git.asml.silence@gmail.com>
References: <cover.1604667122.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Make io_poll_remove_all() and io_kill_timeouts() to match against files
as well. A preparation patch, effectively not used by now.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 22ac3ce57819..c93060149087 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1588,14 +1588,15 @@ static bool io_task_match(struct io_kiocb *req, struct task_struct *tsk)
 /*
  * Returns true if we found and killed one or more timeouts
  */
-static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk)
+static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
+			     struct files_struct *files)
 {
 	struct io_kiocb *req, *tmp;
 	int canceled = 0;
 
 	spin_lock_irq(&ctx->completion_lock);
 	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
-		if (io_task_match(req, tsk)) {
+		if (io_match_task(req, tsk, files)) {
 			io_kill_timeout(req);
 			canceled++;
 		}
@@ -5469,7 +5470,8 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 /*
  * Returns true if we found and killed one or more poll requests
  */
-static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk)
+static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
+			       struct files_struct *files)
 {
 	struct hlist_node *tmp;
 	struct io_kiocb *req;
@@ -5481,7 +5483,7 @@ static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk)
 
 		list = &ctx->cancel_hash[i];
 		hlist_for_each_entry_safe(req, tmp, list, hash_node) {
-			if (io_task_match(req, tsk))
+			if (io_match_task(req, tsk, files))
 				posted += io_poll_remove_one(req);
 		}
 	}
@@ -8615,8 +8617,8 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	percpu_ref_kill(&ctx->refs);
 	mutex_unlock(&ctx->uring_lock);
 
-	io_kill_timeouts(ctx, NULL);
-	io_poll_remove_all(ctx, NULL);
+	io_kill_timeouts(ctx, NULL, NULL);
+	io_poll_remove_all(ctx, NULL, NULL);
 
 	if (ctx->io_wq)
 		io_wq_cancel_all(ctx->io_wq);
@@ -8847,8 +8849,8 @@ static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 			}
 		}
 
-		ret |= io_poll_remove_all(ctx, task);
-		ret |= io_kill_timeouts(ctx, task);
+		ret |= io_poll_remove_all(ctx, task, NULL);
+		ret |= io_kill_timeouts(ctx, task, NULL);
 		if (!ret)
 			break;
 		io_run_task_work();
-- 
2.24.0

