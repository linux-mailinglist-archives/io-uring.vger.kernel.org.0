Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469C23310A8
	for <lists+io-uring@lfdr.de>; Mon,  8 Mar 2021 15:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbhCHOUa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 09:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbhCHOUT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 09:20:19 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF4FC06174A
        for <io-uring@vger.kernel.org>; Mon,  8 Mar 2021 06:20:19 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id y124-20020a1c32820000b029010c93864955so3911997wmy.5
        for <io-uring@vger.kernel.org>; Mon, 08 Mar 2021 06:20:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zG29DrKJHBKzaGtzI5jlSowwhLMO0uVzhnsjqP6xWew=;
        b=uzdZZsAug11dIvdKtOqOju1imTzM0AJvrWMFRqGjxBY39y9Sw2pgq7yDoFHT0xnpHE
         65+YbduBTV8vJNwkj/WC/dj6tVJBEMwkhZUVBXEePw0eO91+OXdelhIgtwK1jYdIKf/g
         C9s59EUSnFGcxJr1QzNjZnIS9gqIzO0v33lOu/50QwWpBwP1XAmcTgEc6b7eejNp1xbT
         jGgCF/IiRUmYfn3i1tQESg6sWGKVsi7gPBSfkFMT9xIt4gsU+srIyfVJJ9vK2qUSmmX2
         NQ6Wv/FCfK8tIKnk1LWQ2EmJGpl7J9xrJI9C0Btrho68niQaiGGJdfXixM7Asaciitqj
         8idw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zG29DrKJHBKzaGtzI5jlSowwhLMO0uVzhnsjqP6xWew=;
        b=uNp9a629GKtaeNlRVditCSS8Xjr2XwNWsTYexLcmC2DIVYfHJT6d1QNYSHBeNYo9+4
         BXJKqw53Adqho8I71dtecq/FYPePJi642NlPrjcNQyPFcqtC5Z1KjOfWsjPW/dHUYOXd
         /Gil55gUHVXyPomhPRWGhu8pZZVMRL7ia6/2QjNX9Ti0UUPpp15K9SXU7RP2Otg5dN5u
         ryoxnoTic5sNca82nuZEClznQU6AYogXcjX2yHeRLgBNkDnBNnYO4oRKlJtT3wkN3ex/
         1wkhT41WSM/96l9ObCg5W08opexgiRlQ1yMiU1fd77dK3LS5clyYHSJsZxPW4xxIAhhj
         fdEg==
X-Gm-Message-State: AOAM530A+QEUasTeFdbcyODAINn3yQ2EckTyZkRbWKI025BTsNy6P6Ja
        ihA1fqqOU3H1qaPGuSMjZdw=
X-Google-Smtp-Source: ABdhPJxCJtKMniHuZyC0yuIFv0cAvkOb1BBhMwQOf7VOMSEmGFchj/md8ML+ZH20KMaSDMqmYL2zqw==
X-Received: by 2002:a1c:a958:: with SMTP id s85mr21771825wme.138.1615213218109;
        Mon, 08 Mar 2021 06:20:18 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.144])
        by smtp.gmail.com with ESMTPSA id p18sm22475384wro.18.2021.03.08.06.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 06:20:17 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Matthew Wilcox <willy@infradead.org>,
        yangerkun <yangerkun@huawei.com>, asml.silence@gmail.com,
        Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 5.12] io_uring: Convert personality_idr to XArray
Date:   Mon,  8 Mar 2021 14:16:16 +0000
Message-Id: <7ccff36e1375f2b0ebf73d957f037b43becc0dde.1615212806.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

You can't call idr_remove() from within a idr_for_each() callback,
but you can call xa_erase() from an xa_for_each() loop, so switch the
entire personality_idr from the IDR to the XArray.  This manifests as a
use-after-free as idr_for_each() attempts to walk the rest of the node
after removing the last entry from it.

Fixes: 071698e13ac6 ("io_uring: allow registering credentials")
Cc: stable@vger.kernel.org # 5.6+
Reported-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
[Pavel: rebased (creds load was moved into io_init_req())]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

p.s. passes liburing tests well

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5ef9f836cccc..5505e19f1391 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -407,7 +407,8 @@ struct io_ring_ctx {
 
 	struct idr		io_buffer_idr;
 
-	struct idr		personality_idr;
+	struct xarray		personalities;
+	u32			pers_next;
 
 	struct {
 		unsigned		cached_cq_tail;
@@ -1138,7 +1139,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_completion(&ctx->ref_comp);
 	init_completion(&ctx->sq_thread_comp);
 	idr_init(&ctx->io_buffer_idr);
-	idr_init(&ctx->personality_idr);
+	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->wait);
 	spin_lock_init(&ctx->completion_lock);
@@ -6338,7 +6339,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->work.list.next = NULL;
 	personality = READ_ONCE(sqe->personality);
 	if (personality) {
-		req->work.creds = idr_find(&ctx->personality_idr, personality);
+		req->work.creds = xa_load(&ctx->personalities, personality);
 		if (!req->work.creds)
 			return -EINVAL;
 		get_cred(req->work.creds);
@@ -8359,7 +8360,6 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 	io_eventfd_unregister(ctx);
 	io_destroy_buffers(ctx);
-	idr_destroy(&ctx->personality_idr);
 
 #if defined(CONFIG_UNIX)
 	if (ctx->ring_sock) {
@@ -8424,7 +8424,7 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
 {
 	const struct cred *creds;
 
-	creds = idr_remove(&ctx->personality_idr, id);
+	creds = xa_erase(&ctx->personalities, id);
 	if (creds) {
 		put_cred(creds);
 		return 0;
@@ -8433,14 +8433,6 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
 	return -EINVAL;
 }
 
-static int io_remove_personalities(int id, void *p, void *data)
-{
-	struct io_ring_ctx *ctx = data;
-
-	io_unregister_personality(ctx, id);
-	return 0;
-}
-
 static bool io_run_ctx_fallback(struct io_ring_ctx *ctx)
 {
 	struct callback_head *work, *next;
@@ -8530,13 +8522,17 @@ static void io_ring_exit_work(struct work_struct *work)
 
 static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 {
+	unsigned long index;
+	struct creds *creds;
+
 	mutex_lock(&ctx->uring_lock);
 	percpu_ref_kill(&ctx->refs);
 	/* if force is set, the ring is going away. always drop after that */
 	ctx->cq_overflow_flushed = 1;
 	if (ctx->rings)
 		__io_cqring_overflow_flush(ctx, true, NULL, NULL);
-	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
+	xa_for_each(&ctx->personalities, index, creds)
+		io_unregister_personality(ctx, index);
 	mutex_unlock(&ctx->uring_lock);
 
 	io_kill_timeouts(ctx, NULL, NULL);
@@ -9166,10 +9162,9 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 }
 
 #ifdef CONFIG_PROC_FS
-static int io_uring_show_cred(int id, void *p, void *data)
+static int io_uring_show_cred(struct seq_file *m, unsigned int id,
+		const struct cred *cred)
 {
-	const struct cred *cred = p;
-	struct seq_file *m = data;
 	struct user_namespace *uns = seq_user_ns(m);
 	struct group_info *gi;
 	kernel_cap_t cap;
@@ -9237,9 +9232,13 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 		seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf,
 						(unsigned int) buf->len);
 	}
-	if (has_lock && !idr_is_empty(&ctx->personality_idr)) {
+	if (has_lock && !xa_empty(&ctx->personalities)) {
+		unsigned long index;
+		const struct cred *cred;
+
 		seq_printf(m, "Personalities:\n");
-		idr_for_each(&ctx->personality_idr, io_uring_show_cred, m);
+		xa_for_each(&ctx->personalities, index, cred)
+			io_uring_show_cred(m, index, cred);
 	}
 	seq_printf(m, "PollList:\n");
 	spin_lock_irq(&ctx->completion_lock);
@@ -9568,14 +9567,16 @@ static int io_probe(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
 static int io_register_personality(struct io_ring_ctx *ctx)
 {
 	const struct cred *creds;
+	u32 id;
 	int ret;
 
 	creds = get_current_cred();
 
-	ret = idr_alloc_cyclic(&ctx->personality_idr, (void *) creds, 1,
-				USHRT_MAX, GFP_KERNEL);
-	if (ret < 0)
-		put_cred(creds);
+	ret = xa_alloc_cyclic(&ctx->personalities, &id, (void *)creds,
+			XA_LIMIT(0, USHRT_MAX), &ctx->pers_next, GFP_KERNEL);
+	if (!ret)
+		return id;
+	put_cred(creds);
 	return ret;
 }
 
-- 
2.24.0

