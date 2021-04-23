Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EAF03689AF
	for <lists+io-uring@lfdr.de>; Fri, 23 Apr 2021 02:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235797AbhDWAUQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Apr 2021 20:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbhDWAUQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Apr 2021 20:20:16 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1F7C061574
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 17:19:40 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id u187so5573786wmb.0
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 17:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=O9q0SZhl1rh251ef1hA/BcWM9E+0Kc8MYnMZQLk6KtI=;
        b=UoJV8ppZF6baSBwdqNRApBEn0UjiufJOdlzvhvoqnTQVYtzx70hqnJuUo7lK3zNhZ/
         iAfhUohPQc9J7pu3K/t9on7iHhkEfUdIOYXe8EENpmGWxAAiwt+Uil8rDHMF6NAxQ+5x
         ej5T9ZbF1v96w/edI6u0WZnuHjnAUrB+fSh6QIhHcwxLHS/CxjSSPeJ9mIDUE/+BEuRN
         cvxH+aRGW3mslnR6y0jnmSINrAWBlL/aCfCATK1ond9M79F6AjNKy+ECs7v7t9noHeUm
         vxSC950v+TmpsXJIOVhT/NdLF9W4hKqIq5ctaYljuPYCFW+EVboepUhEqElhNX46T1RR
         2hIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O9q0SZhl1rh251ef1hA/BcWM9E+0Kc8MYnMZQLk6KtI=;
        b=YvVJcYrUqYAHNNUcKh7aKp+yzrlk9uIlrcjtdwSo7V7/Ut/pe5soi829KSZ6oq0LcF
         kID6fd8K5KyNGA0mcNR+2He3odb4GTRsObA7BPZmIduUUN10eaCXQpWA1+spKyF4ow7J
         cbs3meem8dFLMmFuXN08Z44yMpyy39R9smS2SgqZVMb1LhrTNkebUK8EistF8zMF0yG3
         Ly8p0lBRH4kWFVScFCDPgQiixa1nll0V+VVDKWOCpntWj5u4yUJXksZCE/e4bJMyqRgU
         D8wiT/YgFwyAOnRf2pkRhBSPeE31w94CJDuoBppy6VHNz3Fg2gJeImJ6iDJ0lCDdsr3w
         0gTQ==
X-Gm-Message-State: AOAM531oE2Pn05qvHi0OXQj+zb8y8VfvP1KgzhVChAxvZ4GdSlIMKcSz
        /U8TmjWgcV8zVmuwddk3bIz66J1CCEg=
X-Google-Smtp-Source: ABdhPJzPtFItmIlAY3I/hj8b6R4Odt09DpbcNyG7VpOvybFFcP17Nq87pQQUQC5Vy0C81/HCEVPbXw==
X-Received: by 2002:a1c:6184:: with SMTP id v126mr1345883wmb.118.1619137179293;
        Thu, 22 Apr 2021 17:19:39 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.225])
        by smtp.gmail.com with ESMTPSA id g12sm6369605wru.47.2021.04.22.17.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 17:19:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 01/11] io_uring: move __io_sqe_files_unregister
Date:   Fri, 23 Apr 2021 01:19:18 +0100
Message-Id: <95caf17fe837e67bd1f878395f07049062a010d4.1619128798.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619128798.git.asml.silence@gmail.com>
References: <cover.1619128798.git.asml.silence@gmail.com>
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

