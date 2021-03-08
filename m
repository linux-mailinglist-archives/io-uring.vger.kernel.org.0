Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF24330F08
	for <lists+io-uring@lfdr.de>; Mon,  8 Mar 2021 14:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhCHNUU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 08:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhCHNUJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 08:20:09 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CFFEC06174A
        for <io-uring@vger.kernel.org>; Mon,  8 Mar 2021 05:20:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xM/FJAhQs2pm/IScZi7o2bJK/m5pn5l7YWkP69rLTf8=; b=lTEg4aqktiaimQ96hSq6wjJpwe
        ikjSUZb9+7ACbh7FzMvMqRFgXGadCMPk91tTaqwTOyt6lgVdPv+cm+uj09FO+PMJ1oLyYmsBwjhIz
        UFJG+Rs6aCxuTXhiQOY9zMdRQlmICZSZu0qeN8Se8GcIRLStcBe6vC9LIcW3zN/pEbv6WhIzs7jJ1
        zSdqOhk3BcIUAD++Ig45wjeglStg/K+PUG3LpK4DAZCnkt8UVPKBkIyMjmkIoMidXYincPzxOQlfg
        qc0TczFtiJr/qU4HUPwvxlg6Q1/a2PWwDsc6P1m59TpF2BNoNaBDqB2zurXpq53W1HGJQBzcXx2Xq
        EU7cOqiw==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lJFnl-00FVoM-JU; Mon, 08 Mar 2021 13:20:02 +0000
Date:   Mon, 8 Mar 2021 13:20:01 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     yangerkun <yangerkun@huawei.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org, yi.zhang@huawei.com
Subject: Re: [PATCH 1/2] io_uring: fix UAF for personality_idr
Message-ID: <20210308132001.GA3479805@casper.infradead.org>
References: <20210308065903.2228332-1-yangerkun@huawei.com>
 <e4b79f4d-c777-103d-e87e-d72dc49cb440@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4b79f4d-c777-103d-e87e-d72dc49cb440@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Mar 08, 2021 at 10:46:37AM +0000, Pavel Begunkov wrote:
> Matthew, any chance you remember whether idr_for_each tolerates
> idr_remove() from within the callback? Nothing else is happening in
> parallel.

No, that's not allowed.  The design of the IDR is that you would free
the thing being pointed to and then call idr_destroy() afterwards to
free the IDR's data structures.  But this should use an XArray anyway.
Compile-tested only.

PS, I found this commit:

commit 41726c9a50e7464beca7112d0aebf3a0090c62d2
Author: Jens Axboe <axboe@kernel.dk>
Date:   Sun Feb 23 13:11:42 2020 -0700

    io_uring: fix personality idr leak
    
    We somehow never free the idr, even though we init it for every ctx.
    Free it when the rest of the ring data is freed.

The IDR hasn't needed to be freed since I reimplemented it on top of
the radix tree in 2016.  The same is true for the XArray, which is
why idr_destroy() is simply deleted below instead of replaced with
xa_destroy().

From 8b0b4d331bdd9861eaac7322eba7a2669f18be80 Mon Sep 17 00:00:00 2001
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Date: Mon, 8 Mar 2021 08:04:38 -0500
Subject: [PATCH] io_uring: Convert personality_idr to XArray

You can't call idr_remove() from within a idr_for_each() callback,
but you can call xa_erase() from an xa_for_each() loop, so switch the
entire personality_idr from the IDR to the XArray.  This manifests as a
use-after-free as idr_for_each() attempts to walk the rest of the node
after removing the last entry from it.

Fixes: 071698e13ac6 ("io_uring: allow registering credentials")
Reported-by: Pavel Begunkov <asml.silence@gmail.com>
Reported-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/io_uring.c | 47 ++++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 92c25b5f1349..72355903daa1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -408,7 +408,8 @@ struct io_ring_ctx {
 
 	struct idr		io_buffer_idr;
 
-	struct idr		personality_idr;
+	struct xarray		personalities;
+	u32			pers_next;
 
 	struct {
 		unsigned		cached_cq_tail;
@@ -1131,7 +1132,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_completion(&ctx->ref_comp);
 	init_completion(&ctx->sq_thread_comp);
 	idr_init(&ctx->io_buffer_idr);
-	idr_init(&ctx->personality_idr);
+	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->wait);
 	spin_lock_init(&ctx->completion_lock);
@@ -5921,7 +5922,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 
 		if (!(issue_flags & IO_URING_F_NONBLOCK))
 			mutex_lock(&ctx->uring_lock);
-		new_creds = idr_find(&ctx->personality_idr, req->work.personality);
+		new_creds = xa_load(&ctx->personalities, req->work.personality);
 		if (!(issue_flags & IO_URING_F_NONBLOCK))
 			mutex_unlock(&ctx->uring_lock);
 		if (!new_creds)
@@ -8418,7 +8419,6 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 	io_eventfd_unregister(ctx);
 	io_destroy_buffers(ctx);
-	idr_destroy(&ctx->personality_idr);
 
 #if defined(CONFIG_UNIX)
 	if (ctx->ring_sock) {
@@ -8483,7 +8483,7 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
 {
 	const struct cred *creds;
 
-	creds = idr_remove(&ctx->personality_idr, id);
+	creds = xa_erase(&ctx->personalities, id);
 	if (creds) {
 		put_cred(creds);
 		return 0;
@@ -8492,14 +8492,6 @@ static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
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
@@ -8541,13 +8533,17 @@ static void io_ring_exit_work(struct work_struct *work)
 
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
@@ -9127,10 +9123,9 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
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
@@ -9198,9 +9193,13 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
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
@@ -9532,14 +9531,16 @@ static int io_probe(struct io_ring_ctx *ctx, void __user *arg, unsigned nr_args)
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
2.30.0

