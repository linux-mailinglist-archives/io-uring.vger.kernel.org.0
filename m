Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD6B2DC9ED
	for <lists+io-uring@lfdr.de>; Thu, 17 Dec 2020 01:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgLQA2r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Dec 2020 19:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbgLQA2q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Dec 2020 19:28:46 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572C9C06179C
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 16:28:06 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 190so3973761wmz.0
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 16:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=dWl4gRkQyrfeKDpMw1WM3UGxr3yA53czooauoQTj6fs=;
        b=GswTgBoVBLqjiacvv0QN9zEFUjdD78J6BMS7OGXNIqwEwjhqSsWQDKRsxGNo+bFaN6
         jOj7TpWcgerbvOgmjh3KAzpzeue2ntd/Ubclm1YdEd+Puczf3hPaDrxUbZV5xm2UCqD1
         NEIsmHC4FaOW4MkBxKQLI6h8JYY1fmj2P167jKoXiJSM1oKKqp1W/WSaZmUDgH+/R+gx
         GI2md/ReB+iJlYxpV/MFw+klerA9hw8HXy/pmYkLA4zBAjs5rYv42lgclrrO7IVRhqLD
         vQM89hrbhPI4QIv+KI6UgkdQgeFmCnMz0kfY8NRQZ3sRDbAmtmFBtAbhtskO0xEbQ6AX
         8sWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dWl4gRkQyrfeKDpMw1WM3UGxr3yA53czooauoQTj6fs=;
        b=dBFF0QSe23fe5SELYCrtfBRduwSkQ2TBhUW/fmBMTuSbN/0TFCyf6bzp3tw08wqYJP
         L+luodMq+KKPdLDWDEZczgj26+LB129cmUBUO4nMJeLfw84GrRfiyTPbgZ0Tvw3lI4Sz
         Eo48/NR5Em0KjBMz5cMJ/edu12h4mkil+gQ7cVnrPrV8kykooExu0HWDDJXfkkVH6onM
         xq3JOfAb0l6FrLHxXkGbFZexSXnpYuKw4lplA3FyZU5Rw3j7Hn9QadOYbSrn1HYVsxiE
         EZcFsM4Bg6Fe5ucIejbOpmSHJiDEdLLVLL8arnCe90fMdPmx3yweIC+BtCLe5q1yQ8QI
         0PVA==
X-Gm-Message-State: AOAM5324XVN3st6y5FQwnoTG7GuNblmBoHJNglJgunIvP/I3iFaorhC1
        J+Dr0mSv6dE8MZfBzAZuc9c=
X-Google-Smtp-Source: ABdhPJy2lxS0iO5ZhYSCPHnBdDgYm+AAvciYcSEKlEqPfhfJAyo3e3VKwQ3AgK/JS4GPRmQSSfHSHg==
X-Received: by 2002:a1c:6144:: with SMTP id v65mr5739601wmb.125.1608164885058;
        Wed, 16 Dec 2020 16:28:05 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.225])
        by smtp.gmail.com with ESMTPSA id h29sm5711161wrc.68.2020.12.16.16.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 16:28:04 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/5] io_uring: cancel reqs shouldn't kill overflow list
Date:   Thu, 17 Dec 2020 00:24:35 +0000
Message-Id: <5074c62067b347160b6053ffcfe01bca94b10620.1608164394.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1608164394.git.asml.silence@gmail.com>
References: <cover.1608164394.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring_cancel_task_requests() doesn't imply that the ring is going
away, it may continue to work well after that. The problem is that it
sets ->cq_overflow_flushed effectively disabling the CQ overflow feature

Split setting cq_overflow_flushed from flush, and do the first one only
on exit. It's ok in terms of cancellations because there is a
io_uring->in_idle check in __io_cqring_fill_event().

It also fixes a race with setting ->cq_overflow_flushed in
io_uring_cancel_task_requests, whuch's is not atomic and a part of a
bitmask with other flags. Though, the only other flag that's not set
during init is drain_next, so it's not as bad for sane architectures.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f53356ced5ab..7115147a25a8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1734,10 +1734,6 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
 
-	/* if force is set, the ring is going away. always drop after that */
-	if (force)
-		ctx->cq_overflow_flushed = 1;
-
 	cqe = NULL;
 	list_for_each_entry_safe(req, tmp, &ctx->cq_overflow_list, compl.list) {
 		if (!io_match_task(req, tsk, files))
@@ -8663,6 +8659,8 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 {
 	mutex_lock(&ctx->uring_lock);
 	percpu_ref_kill(&ctx->refs);
+	/* if force is set, the ring is going away. always drop after that */
+	ctx->cq_overflow_flushed = 1;
 	if (ctx->rings)
 		io_cqring_overflow_flush(ctx, true, NULL, NULL);
 	mutex_unlock(&ctx->uring_lock);
-- 
2.24.0

