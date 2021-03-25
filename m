Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 644E0349997
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 19:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhCYShA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 14:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbhCYSgz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 14:36:55 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA2BC06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 11:36:55 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id p19so1741515wmq.1
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 11:36:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=OaG3wfWFpu3SJmc8hHO1UU4JPuVh7AESr6D6jQCnOII=;
        b=O076OvT/H6xQ2t4vmGwne2QpDkFjCWcj1Q5fSqYkWjEiZV7FPtk2wkLYemmlmzr8De
         2IxoDeiFG5aZCtHk3no4QayZh1v7qBHMABDOMw/a/7xDQaSC5aLOal4rR9vnbM2JjHjL
         gxiE8PNT/WdrM3+SnQru01V05N33MjIITD57lK7oYeDmXm/ZoOUsgmRT/QkUcLQDFNPz
         F6KnqtoMoolrvgVAvRV1E1+HValsCiZHCbaTni5L93RX8tbzoT8x3bqO2zR6a71P9lYI
         HRd/u6eT3L7/zBbZ4BggtwUNlPGwRJOQdrGFSEEVj96dYbytJn0s/1N+D8PmSeuc7hAd
         GSzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OaG3wfWFpu3SJmc8hHO1UU4JPuVh7AESr6D6jQCnOII=;
        b=Ku5HjyY/QFPDLmA7p6awQajInFHrVdMg0kC8csbNoKMpaTO8oina/xDzeydQUtWv27
         HyS/3WgFAQ6aRqX81oMHVMmztVDWoVmiAIAkUQPW8/0CLLQkkftadZGt5H2rNj4enkZH
         rvPrAL8wWyxW7uXtnDyRpCz/pR8GAcMvFIRnMOTGOQM0f84708lLu10NA8a+Bx2vbC2K
         YQs4v0swDfb6liSFbN7doI26qR3PGgvbFE+FGmh5FCoyj3VP7uClD+p8JNCooAJ7Tiu9
         q9Ei01XJ1lFtXawgl9VgJkZ3kGo/8i1CbmUHItsUBt1r+iLMO1k9NAlk7hxMuVzSznsL
         8xbQ==
X-Gm-Message-State: AOAM530GN8pye9Y1eXMeCDMvnVZt/qmMWgP0NDZ7eAOtxhbWe9meB52K
        7eAEylEw7cyMKSdt5EtOgOM=
X-Google-Smtp-Source: ABdhPJzuQFOMBRdMVNA3T3DuT7Tah5IY2qKuJkVarPKSccqziZUxqgkznYc9inupm29Os60mt1nl+w==
X-Received: by 2002:a1c:4b11:: with SMTP id y17mr9101314wma.171.1616697414352;
        Thu, 25 Mar 2021 11:36:54 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id p27sm7876828wmi.12.2021.03.25.11.36.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 11:36:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/4] io_uring: do post-completion chore on t-out cancel
Date:   Thu, 25 Mar 2021 18:32:43 +0000
Message-Id: <72ace588772c0f14834a6a4185d56c445a366fb4.1616696997.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616696997.git.asml.silence@gmail.com>
References: <cover.1616696997.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't forget about io_commit_cqring() + io_cqring_ev_posted() after
exit/exec cancelling timeouts. Both functions declared only after
io_kill_timeouts(), so to avoid tons of forward declarations move
it down.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 42 ++++++++++++++++++++++--------------------
 1 file changed, 22 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e4861095c4a7..3fcce81b24cd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1263,26 +1263,6 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 	}
 }
 
-/*
- * Returns true if we found and killed one or more timeouts
- */
-static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
-			     struct files_struct *files)
-{
-	struct io_kiocb *req, *tmp;
-	int canceled = 0;
-
-	spin_lock_irq(&ctx->completion_lock);
-	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
-		if (io_match_task(req, tsk, files)) {
-			io_kill_timeout(req, -ECANCELED);
-			canceled++;
-		}
-	}
-	spin_unlock_irq(&ctx->completion_lock);
-	return canceled != 0;
-}
-
 static void __io_queue_deferred(struct io_ring_ctx *ctx)
 {
 	do {
@@ -8608,6 +8588,28 @@ static void io_ring_exit_work(struct work_struct *work)
 	io_ring_ctx_free(ctx);
 }
 
+/* Returns true if we found and killed one or more timeouts */
+static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
+			     struct files_struct *files)
+{
+	struct io_kiocb *req, *tmp;
+	int canceled = 0;
+
+	spin_lock_irq(&ctx->completion_lock);
+	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
+		if (io_match_task(req, tsk, files)) {
+			io_kill_timeout(req, -ECANCELED);
+			canceled++;
+		}
+	}
+	io_commit_cqring(ctx);
+	spin_unlock_irq(&ctx->completion_lock);
+
+	if (canceled != 0)
+		io_cqring_ev_posted(ctx);
+	return canceled != 0;
+}
+
 static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 {
 	unsigned long index;
-- 
2.24.0

