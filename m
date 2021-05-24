Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E8538F67E
	for <lists+io-uring@lfdr.de>; Tue, 25 May 2021 01:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbhEXXxE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 May 2021 19:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbhEXXxC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 May 2021 19:53:02 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CA0C061574
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:33 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id p7so26471705wru.10
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PitBa2jCNmj904tw0FxJoTkGxYP0G/MkJkaZ9Dl1k7k=;
        b=tKneJrTmJYzx0VGFLr8Z0lLEXlfxFGQYZoBcXo9dipyeTeJ00hOEmdFEDhYU8rjLHx
         Yw7W2knG/qadtw4wS0Kxote47Cdxxui7VWU0QQWhrpsttXMG8v5XPDUnjU1H70LM0Vfg
         KcUKIhQYg5mR624lXyywKd3rjNj124Zou62MoO1sbSXqY5/p7i4LxWZFSNC4fRb4wop0
         n0XmYUWs93a9CInEg+d1XoAywWWjaf1O+WvIhcIF0AVIaI8Ed2cA1lxNesEw0dVpSCPo
         Ipv0bhuapWuh2xRibskfCE3f7ebUFZFYY1w0OPtAZ/bbI4sjvVF9g/93TKJVr5LcE1dz
         AWjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PitBa2jCNmj904tw0FxJoTkGxYP0G/MkJkaZ9Dl1k7k=;
        b=Ve3skrUif6a8pi+M0dR++9c0NoCPRpCTvY3h6qVQPWY1sFjV1FIggneVXgZkv/XJiN
         q83rh8cUNWs+cKYwQmKAnxTHaZJkcu0MCeuKj/ovigKobT4TWxK45K4Qd+WduOWQhkzV
         332+b3VxG7ZsAnWafAjTGlxlpyCM6VC6rC6a6kh4W9DkLPFa0SBhxdLl5y2u3opnHFAO
         TrxGOOqjumnoxTLUEo3+N75MPz8t1b3tVFhin8Luu7oFJPYxYi6SDDbgEkWs9sOYk73U
         ReGoTktnvh4x5KCHfCM2VG9fofPSPasP3lSGRPsgtGbSOHT9eJsN3ueoYFf4ZcTc2On6
         k9Kg==
X-Gm-Message-State: AOAM5312hJFMiWoJuOpoXoJuU5+ob+AHmdZvrBY4c0ALW5JtduUzXv8q
        RCiFg3TX4/s3ZbzlpuphdXU=
X-Google-Smtp-Source: ABdhPJwV+naetv6KATH17cjfNcPvx0xH9mrlgBeYAFoybeYUpnj2QATu4domL14wrOrbvr3nAvhn2Q==
X-Received: by 2002:a05:6000:1286:: with SMTP id f6mr23384970wrx.226.1621900292202;
        Mon, 24 May 2021 16:51:32 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.116])
        by smtp.gmail.com with ESMTPSA id f7sm8961069wmq.30.2021.05.24.16.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:51:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 04/13] io_uring: rename function *task_file
Date:   Tue, 25 May 2021 00:51:03 +0100
Message-Id: <34ae8baa7c3d7174e9ed7093da4f62b091931442.1621899872.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621899872.git.asml.silence@gmail.com>
References: <cover.1621899872.git.asml.silence@gmail.com>
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
index df1510adaaf7..c34df3e01151 100644
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
@@ -8706,7 +8706,7 @@ static void io_tctx_exit_cb(struct callback_head *cb)
 	 * node. It'll be removed by the end of cancellation, just ignore it.
 	 */
 	if (!atomic_read(&tctx->in_idle))
-		io_uring_del_task_file((unsigned long)work->ctx);
+		io_uring_del_tctx_node((unsigned long)work->ctx);
 	complete(&work->completion);
 }
 
@@ -8959,7 +8959,7 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 	}
 }
 
-static int __io_uring_add_task_file(struct io_ring_ctx *ctx)
+static int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_tctx_node *node;
@@ -8996,19 +8996,19 @@ static int __io_uring_add_task_file(struct io_ring_ctx *ctx)
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
@@ -9039,7 +9039,7 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
 
 	tctx->io_wq = NULL;
 	xa_for_each(&tctx->xa, index, node)
-		io_uring_del_task_file(index);
+		io_uring_del_tctx_node(index);
 	if (wq)
 		io_wq_put_and_exit(wq);
 }
@@ -9317,7 +9317,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		}
 		submitted = to_submit;
 	} else if (to_submit) {
-		ret = io_uring_add_task_file(ctx);
+		ret = io_uring_add_tctx_node(ctx);
 		if (unlikely(ret))
 			goto out;
 		mutex_lock(&ctx->uring_lock);
@@ -9527,7 +9527,7 @@ static int io_uring_install_fd(struct io_ring_ctx *ctx, struct file *file)
 	if (fd < 0)
 		return fd;
 
-	ret = io_uring_add_task_file(ctx);
+	ret = io_uring_add_tctx_node(ctx);
 	if (ret) {
 		put_unused_fd(fd);
 		return ret;
-- 
2.31.1

