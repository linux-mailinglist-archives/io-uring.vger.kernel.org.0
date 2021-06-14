Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DB53A5B5E
	for <lists+io-uring@lfdr.de>; Mon, 14 Jun 2021 03:37:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbhFNBjH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Jun 2021 21:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232286AbhFNBjG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Jun 2021 21:39:06 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2732AC0617AF
        for <io-uring@vger.kernel.org>; Sun, 13 Jun 2021 18:36:50 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id z8so12614269wrp.12
        for <io-uring@vger.kernel.org>; Sun, 13 Jun 2021 18:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=LF9osU2bL9wpML7vfDWO48G7emok74LqYRZOkN+lh7c=;
        b=gABv6zWA1vgOaXh7qUu89ip4j7ozAvoj0F7i6u5ZtNr8OqQIs7jh1pZQqHUfttGqlT
         EGHsPeFdtrTt/jykhdbXJ/3LW4ruxJHt1ehOmSuCkyUBcEOBwWK/vBO3ajtMAgpvOULO
         K5fclW4MuyFjB33Xd1uA4CYw7jFrgV5q0HVKXLv9r3G58FG6L1PQn6YaiQIJxklLfTBl
         qs4HoX6KIazbVSFQQ762UPdCeNijYWZdxEe0xrzzf5y7V+kz3BHWBwoofTygVNqSwk6N
         52a+qPmoNOa8KkrABzBWIVbI4GBHDLKC2LmYtFAdbw2DnFRs8938t7rcgbUle+7ozR4i
         fGsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LF9osU2bL9wpML7vfDWO48G7emok74LqYRZOkN+lh7c=;
        b=pzZrnMhtVRkrtdLABgDdnPqM77QbGg3w/14EZO+FKeCVUrA4uVB8DgV2aUkqPYGM3E
         tnlpHrHoUiK4EY6gTTfqCA1MG3WqntMiRaNIpgcTYZr8/Td8dkWIfti7futLVx8ZqHir
         63Nb4KgLUOwMlzp3l8KuqgIdRiyY+uggoFYym8sLHNqGz7AvYmSGreF8V583yVlfyH9T
         XWVlgsZ5LVV1o7IgkqOt6qupHzIvkoE+QK2QMPBxBq7O1s5O4GAo7KVQ60X94oWYQ4VV
         fhE+qG29GhNoY6myF+ivvGFpZrPehnI20RLt64L0J/4FZ2CUHfPNktTieWL2FNPa3hc5
         HFLg==
X-Gm-Message-State: AOAM53152xjC+AKHegiR0zqWXIyBVNP9XAGk9Ot+jjNr+1oXVPuYV7ZY
        u0WzUVJ2gWL1Dn8tYQdAJcQ=
X-Google-Smtp-Source: ABdhPJxo4GrTecu1fFouA6xIV3d1hRzjOurSErvR+hKYT/wp46/L+YTH3Dd3KDPspl6BP7qCBZ9z5Q==
X-Received: by 2002:adf:cd8d:: with SMTP id q13mr11282161wrj.78.1623634607935;
        Sun, 13 Jun 2021 18:36:47 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.119])
        by smtp.gmail.com with ESMTPSA id a9sm6795291wrv.37.2021.06.13.18.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 18:36:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 04/13] io_uring: rename function *task_file
Date:   Mon, 14 Jun 2021 02:36:15 +0100
Message-Id: <e2fbce42932154c2631ce58ffbffaa232afe18d5.1623634181.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623634181.git.asml.silence@gmail.com>
References: <cover.1623634181.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

What at some moment was references to struct file used to control
lifetimes of task/ctx is now just internal tctx structures/nodes,
so rename outdated *task_file() routines into something more sensible.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8fbb48c1ac7a..cea3d0f5dad5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1024,7 +1024,7 @@ static const struct io_op_def io_op_defs[] = {
 };
 
 static bool io_disarm_next(struct io_kiocb *req);
-static void io_uring_del_task_file(unsigned long index);
+static void io_uring_del_tctx_node(unsigned long index);
 static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
 					 bool cancel_all);
@@ -8709,7 +8709,7 @@ static void io_tctx_exit_cb(struct callback_head *cb)
 	 * node. It'll be removed by the end of cancellation, just ignore it.
 	 */
 	if (!atomic_read(&tctx->in_idle))
-		io_uring_del_task_file((unsigned long)work->ctx);
+		io_uring_del_tctx_node((unsigned long)work->ctx);
 	complete(&work->completion);
 }
 
@@ -8962,7 +8962,7 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 	}
 }
 
-static int __io_uring_add_task_file(struct io_ring_ctx *ctx)
+static int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_tctx_node *node;
@@ -8999,19 +8999,19 @@ static int __io_uring_add_task_file(struct io_ring_ctx *ctx)
 /*
  * Note that this task has used io_uring. We use it for cancelation purposes.
  */
-static inline int io_uring_add_task_file(struct io_ring_ctx *ctx)
+static inline int io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 {
 	struct io_uring_task *tctx = current->io_uring;
 
 	if (likely(tctx && tctx->last == ctx))
 		return 0;
-	return __io_uring_add_task_file(ctx);
+	return __io_uring_add_tctx_node(ctx);
 }
 
 /*
  * Remove this io_uring_file -> task mapping.
  */
-static void io_uring_del_task_file(unsigned long index)
+static void io_uring_del_tctx_node(unsigned long index)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_tctx_node *node;
@@ -9041,7 +9041,7 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
 	unsigned long index;
 
 	xa_for_each(&tctx->xa, index, node)
-		io_uring_del_task_file(index);
+		io_uring_del_tctx_node(index);
 	if (wq) {
 		/*
 		 * Must be after io_uring_del_task_file() (removes nodes under
@@ -9325,7 +9325,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		}
 		submitted = to_submit;
 	} else if (to_submit) {
-		ret = io_uring_add_task_file(ctx);
+		ret = io_uring_add_tctx_node(ctx);
 		if (unlikely(ret))
 			goto out;
 		mutex_lock(&ctx->uring_lock);
@@ -9535,7 +9535,7 @@ static int io_uring_install_fd(struct io_ring_ctx *ctx, struct file *file)
 	if (fd < 0)
 		return fd;
 
-	ret = io_uring_add_task_file(ctx);
+	ret = io_uring_add_tctx_node(ctx);
 	if (ret) {
 		put_unused_fd(fd);
 		return ret;
-- 
2.31.1

