Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C7241F2AC
	for <lists+io-uring@lfdr.de>; Fri,  1 Oct 2021 19:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbhJARJf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Oct 2021 13:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhJARJf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Oct 2021 13:09:35 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF3FC061775
        for <io-uring@vger.kernel.org>; Fri,  1 Oct 2021 10:07:50 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id g7so36271742edv.1
        for <io-uring@vger.kernel.org>; Fri, 01 Oct 2021 10:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/iiYW+0orSVFdsu7lmC156zdDQFiOGp7qKTdhi/5V9g=;
        b=ZkjbEOvR93r+pAFhgynAbfqsQIuMAOs4P36H76fP+lqVNlIZ9+HlByvXnBHwJZPV+b
         hLgBFqtiB70iBA1BP6vL+Kls1cYqTiBA1lLB4aWUw/q+5+X5cnieIeNg0Xc0jvZ1R30B
         5SDRe5Ae0ekgZGXKvEJuJnEcu5qss8EAhyBm7CtBredjAqPPdqcdlzNh93wWxPgKI8Tw
         7IJBmc3B2eZzhKXqHx00FBXnJiD6A/+hKDH9VxrKRFhxwiScasd7KTLA5msg6nIQ5BV6
         Dc2ELeMFO5x+jFnhsRBuAbxwmmdA/6s9NiuAY/+9/SpBwxkjw+SdebDmnNfFq5UFmPTB
         uWiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/iiYW+0orSVFdsu7lmC156zdDQFiOGp7qKTdhi/5V9g=;
        b=VkOwOIC0/xk1ErWqCp6+GZzM/oD7HCvx97OvfHt/Rn6pDpxhpBlstuyEmN2/8JwmSG
         5Biz5zytAF/vDnXfEC2EeOD+LI/kTYOum4a+LO0k6UGNTaufI3/F1RjZZBIpS8Tz0Gx6
         R2bwiB79Y5NNzI2I+ZtFVSAuwQNC0imcJd60g0lRqJheL+NhhRRUAHE3IiFl/1bsW1BI
         Ftqxu2x1h4XpO1pIDMDNyHD80vwEhkDN3jhYsW5XyK9WWTAjXHhvdWwruUidlTguVTIw
         rdbpgMpqHQUxMPR0D5qCbZWoW19Ynsm4iT8KGGfaYWykMZ7DED4Nw2l+al829ad40zwG
         4n3Q==
X-Gm-Message-State: AOAM530gJamf2egTx2ouVAoFFOFqYnjnjjCASjaxOIRJoYGAv6AvhRiO
        pwGVsekIxus3Lxe1/ObHdvA=
X-Google-Smtp-Source: ABdhPJy+5h43pjG+LkCn6dbbln1xnEjR4uxu0KZJZFyaXByUEiziGnzKgV7x2iwklarGTbofs8w5Mw==
X-Received: by 2002:a17:907:3fa6:: with SMTP id hr38mr7412050ejc.513.1633108069156;
        Fri, 01 Oct 2021 10:07:49 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.39])
        by smtp.gmail.com with ESMTPSA id y93sm3604480ede.42.2021.10.01.10.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 10:07:48 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 2/4] io_uring: don't return from io_drain_req()
Date:   Fri,  1 Oct 2021 18:07:01 +0100
Message-Id: <93583cee51b8783706b76c73196c155b28d9e762.1633107393.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1633107393.git.asml.silence@gmail.com>
References: <cover.1633107393.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Never return from io_drain_req() but punt to tw if we've got there but
it's a false positive and we shouldn't actually drain.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e75d9cac7d45..8d6d8415e89d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6430,46 +6430,39 @@ static u32 io_get_sequence(struct io_kiocb *req)
 	return seq;
 }
 
-static bool io_drain_req(struct io_kiocb *req)
+static void io_drain_req(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_defer_entry *de;
 	int ret;
-	u32 seq;
+	u32 seq = io_get_sequence(req);
 
 	/* Still need defer if there is pending req in defer list. */
-	if (likely(list_empty_careful(&ctx->defer_list) &&
-		!(req->flags & REQ_F_IO_DRAIN))) {
-		ctx->drain_active = false;
-		return false;
-	}
-
-	seq = io_get_sequence(req);
-	/* Still a chance to pass the sequence check */
 	if (!req_need_defer(req, seq) && list_empty_careful(&ctx->defer_list)) {
+queue:
 		ctx->drain_active = false;
-		return false;
+		io_req_task_queue(req);
+		return;
 	}
 
 	ret = io_req_prep_async(req);
-	if (ret)
-		goto fail;
+	if (ret) {
+fail:
+		io_req_complete_failed(req, ret);
+		return;
+	}
 	io_prep_async_link(req);
 	de = kmalloc(sizeof(*de), GFP_KERNEL);
 	if (!de) {
 		ret = -ENOMEM;
-fail:
-		io_req_complete_failed(req, ret);
-		return true;
+		goto fail;
 	}
 
 	spin_lock(&ctx->completion_lock);
 	if (!req_need_defer(req, seq) && list_empty(&ctx->defer_list)) {
 		spin_unlock(&ctx->completion_lock);
 		kfree(de);
-		io_queue_async_work(req, NULL);
-		ctx->drain_active = false;
-		return true;
+		goto queue;
 	}
 
 	trace_io_uring_defer(ctx, req, req->user_data);
@@ -6477,7 +6470,6 @@ static bool io_drain_req(struct io_kiocb *req)
 	de->seq = seq;
 	list_add_tail(&de->list, &ctx->defer_list);
 	spin_unlock(&ctx->completion_lock);
-	return true;
 }
 
 static void io_clean_op(struct io_kiocb *req)
@@ -6933,8 +6925,8 @@ static void io_queue_sqe_fallback(struct io_kiocb *req)
 {
 	if (req->flags & REQ_F_FAIL) {
 		io_req_complete_fail_submit(req);
-	} else if (unlikely(req->ctx->drain_active) && io_drain_req(req)) {
-		return;
+	} else if (unlikely(req->ctx->drain_active)) {
+		io_drain_req(req);
 	} else {
 		int ret = io_req_prep_async(req);
 
-- 
2.33.0

