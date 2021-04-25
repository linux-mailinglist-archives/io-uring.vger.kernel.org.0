Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFF736A784
	for <lists+io-uring@lfdr.de>; Sun, 25 Apr 2021 15:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhDYNdS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 25 Apr 2021 09:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbhDYNdS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 25 Apr 2021 09:33:18 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E954C061756
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:38 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id y124-20020a1c32820000b029010c93864955so3668501wmy.5
        for <io-uring@vger.kernel.org>; Sun, 25 Apr 2021 06:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=O9q0SZhl1rh251ef1hA/BcWM9E+0Kc8MYnMZQLk6KtI=;
        b=IimcWRx/bzYUjfju6mK/4gFVjxVoRKBUH4NekP/iuOVrUxH+AdIP+SYWWs4kZdV8FP
         +oBTdSQMFatliD3UCV1/8NqhLBREVvlIC67Y0l0BsXwCQXcY0Wx7Uiz2yenalbIY0lbs
         M1Mt7tZ7v+rYdPVhjEEP7FT2Z0+FPV/ax7vbabecn3dszEuV2qP0TrrgsxZhDt1P5TfZ
         TTWP6XetCCRLSLQMvdM7+m0gluFz/YN2O2GF6oMbBN+bRAXnjBDnMT4eE26xy8tK76he
         /qRc1dOx+9yRQ7qRr/5oH9gw+57DZcYTQhVkXYrJeEfnddSGj8Pajb/io2+Mx+ko4o0M
         HZ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O9q0SZhl1rh251ef1hA/BcWM9E+0Kc8MYnMZQLk6KtI=;
        b=UB5eMinbr5zH2E3tqWSVd+8/nAT+pRFzGosDxT46JF3yxMDrjfXjGRTWcf5R4iKFiu
         c/Dphf+8ff3zJG29Lr7bjoBQHbrJQJeh+It0A7ed56YiCCV0ZzXty4Kw9Uby2Cn67jPg
         8Z1a4Wt1n9vdRR0xrCsoR/PKilHToe2lk7EQoqaqdyU9+TODjSQJIA2ItYzMHFNWQlK9
         pWy7a07pqJoKVVs/0JULEG0vrBTT7vmZkdJJSKn7K1OJLkVas+7apcvCtv28vZAv3g7b
         d8Uk58gbLqXnTTchfn1SVhM5gk/UAZsGrRv/NHUVszayNhELdPVIMhEu7zLFM82DgkmT
         Q5QA==
X-Gm-Message-State: AOAM532tlyWdwFK/NkR26az6TvP1lJz6dvg063NC0cGD9LWCeZH5Cib6
        b1rH3Dv4dIIPTteiRBKTPVE=
X-Google-Smtp-Source: ABdhPJyvuzsHoqoQ9cuQFag29aOD+QNi+yRY8578XcyRagG3+7HPyEfVBBOf86fnH6f5S5LoZ4SQDA==
X-Received: by 2002:a1c:ed0d:: with SMTP id l13mr15781083wmh.78.1619357557145;
        Sun, 25 Apr 2021 06:32:37 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.108])
        by smtp.gmail.com with ESMTPSA id a2sm16551552wrt.82.2021.04.25.06.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 06:32:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 01/12] io_uring: move __io_sqe_files_unregister
Date:   Sun, 25 Apr 2021 14:32:15 +0100
Message-Id: <95caf17fe837e67bd1f878395f07049062a010d4.1619356238.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619356238.git.asml.silence@gmail.com>
References: <cover.1619356238.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A preparation patch moving __io_sqe_files_unregister() definition closer
to other "files" functions without any modification.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 54 +++++++++++++++++++++++++--------------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b2aa9b99b820..70e331349213 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7023,33 +7023,6 @@ static void io_free_file_tables(struct io_file_table *table, unsigned nr_files)
 	table->files = NULL;
 }
 
-static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
-{
-#if defined(CONFIG_UNIX)
-	if (ctx->ring_sock) {
-		struct sock *sock = ctx->ring_sock->sk;
-		struct sk_buff *skb;
-
-		while ((skb = skb_dequeue(&sock->sk_receive_queue)) != NULL)
-			kfree_skb(skb);
-	}
-#else
-	int i;
-
-	for (i = 0; i < ctx->nr_user_files; i++) {
-		struct file *file;
-
-		file = io_file_from_index(ctx, i);
-		if (file)
-			fput(file);
-	}
-#endif
-	io_free_file_tables(&ctx->file_table, ctx->nr_user_files);
-	kfree(ctx->file_data);
-	ctx->file_data = NULL;
-	ctx->nr_user_files = 0;
-}
-
 static inline void io_rsrc_ref_lock(struct io_ring_ctx *ctx)
 {
 	spin_lock_bh(&ctx->rsrc_ref_lock);
@@ -7152,6 +7125,33 @@ static struct io_rsrc_data *io_rsrc_data_alloc(struct io_ring_ctx *ctx,
 	return data;
 }
 
+static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
+{
+#if defined(CONFIG_UNIX)
+	if (ctx->ring_sock) {
+		struct sock *sock = ctx->ring_sock->sk;
+		struct sk_buff *skb;
+
+		while ((skb = skb_dequeue(&sock->sk_receive_queue)) != NULL)
+			kfree_skb(skb);
+	}
+#else
+	int i;
+
+	for (i = 0; i < ctx->nr_user_files; i++) {
+		struct file *file;
+
+		file = io_file_from_index(ctx, i);
+		if (file)
+			fput(file);
+	}
+#endif
+	io_free_file_tables(&ctx->file_table, ctx->nr_user_files);
+	kfree(ctx->file_data);
+	ctx->file_data = NULL;
+	ctx->nr_user_files = 0;
+}
+
 static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
 	int ret;
-- 
2.31.1

