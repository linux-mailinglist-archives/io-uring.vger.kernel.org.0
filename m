Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C618C2C790F
	for <lists+io-uring@lfdr.de>; Sun, 29 Nov 2020 13:27:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgK2M0y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 Nov 2020 07:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgK2M0y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 Nov 2020 07:26:54 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4389C0613CF;
        Sun, 29 Nov 2020 04:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3+rYoc55tiwS75r5UCguG8RQp9uhLP5n17rDjyfEd7Y=; b=tLLVBytJxX+unnNEkq5U+SIOYx
        D4HQ1CXpb70Mxz8rmgaygXLoT0KibBXJymI6seriwwVWnh/2ChpV1RtHW6b1QBcBt5T8/Qxlqghzs
        diinud7/xixia1gJpwtMyIJkL1B9hxeggd+BARYKh+RSqldsepas95dZbi2zBvin+MLTaXrTTiPvM
        MZ9pAfDG9iN8EYHr0Lh3wfm7B2s7uEPZjRxaw0KnT+ENxu5IbsDl4+XhYRGBaWrcnIJVaWldnYFdg
        e46aNbywYl5kNGnRGs34OTfqQbDkn+FP0F7bpOe24kSr8kpXcRsSGQn2xbLMmWu0IHKwFBc2Idg0K
        BtVVVOyg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kjLmC-0000Dl-Da; Sun, 29 Nov 2020 12:26:00 +0000
Date:   Sun, 29 Nov 2020 12:26:00 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Hillf Danton <hdanton@sina.com>
Cc:     syzbot <syzbot+12056a09a0311d758e60@syzkaller.appspotmail.com>,
        axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in idr_for_each (2)
Message-ID: <20201129122600.GA4327@casper.infradead.org>
References: <000000000000ca835605b0e8a723@google.com>
 <20201129113429.13660-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201129113429.13660-1-hdanton@sina.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Nov 29, 2020 at 07:34:29PM +0800, Hillf Danton wrote:
> >  radix_tree_next_slot include/linux/radix-tree.h:422 [inline]
> >  idr_for_each+0x206/0x220 lib/idr.c:202
> >  io_destroy_buffers fs/io_uring.c:8275 [inline]
> 
> Matthew, can you shed any light on the link between the use of idr
> routines and the UAF reported?

I presume it's some misuse of IDR by io_uring.  I'd rather io_uring
didn't use the IDR at all.  This compiles; I promise no more than that.

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ef3cd7fe4416..2fcf196bb3c3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -344,7 +344,7 @@ struct io_ring_ctx {
 	struct socket		*ring_sock;
 #endif
 
-	struct idr		io_buffer_idr;
+	struct xarray		io_buffers;
 
 	struct idr		personality_idr;
 
@@ -1298,7 +1298,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	init_completion(&ctx->ref_comp);
 	init_completion(&ctx->sq_thread_comp);
-	idr_init(&ctx->io_buffer_idr);
+	xa_init(&ctx->io_buffers);
 	idr_init(&ctx->personality_idr);
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->wait);
@@ -3042,7 +3042,7 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
 
 	lockdep_assert_held(&req->ctx->uring_lock);
 
-	head = idr_find(&req->ctx->io_buffer_idr, bgid);
+	head = xa_load(&req->ctx->io_buffers, bgid);
 	if (head) {
 		if (!list_empty(&head->list)) {
 			kbuf = list_last_entry(&head->list, struct io_buffer,
@@ -3050,7 +3050,7 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
 			list_del(&kbuf->list);
 		} else {
 			kbuf = head;
-			idr_remove(&req->ctx->io_buffer_idr, bgid);
+			xa_erase(&req->ctx->io_buffers, bgid);
 		}
 		if (*len > kbuf->len)
 			*len = kbuf->len;
@@ -4130,7 +4130,8 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx, struct io_buffer *buf,
 	}
 	i++;
 	kfree(buf);
-	idr_remove(&ctx->io_buffer_idr, bgid);
+	if (nbufs != -1U)
+		xa_erase(&ctx->io_buffers, bgid);
 
 	return i;
 }
@@ -4148,7 +4149,7 @@ static int io_remove_buffers(struct io_kiocb *req, bool force_nonblock,
 	lockdep_assert_held(&ctx->uring_lock);
 
 	ret = -ENOENT;
-	head = idr_find(&ctx->io_buffer_idr, p->bgid);
+	head = xa_load(&ctx->io_buffers, p->bgid);
 	if (head)
 		ret = __io_remove_buffers(ctx, head, p->bgid, p->nbufs);
 
@@ -4225,15 +4226,15 @@ static int io_provide_buffers(struct io_kiocb *req, bool force_nonblock,
 
 	lockdep_assert_held(&ctx->uring_lock);
 
-	list = head = idr_find(&ctx->io_buffer_idr, p->bgid);
+	list = head = xa_load(&ctx->io_buffers, p->bgid);
 
 	ret = io_add_buffers(p, &head);
 	if (ret < 0)
 		goto out;
 
 	if (!list) {
-		ret = idr_alloc(&ctx->io_buffer_idr, head, p->bgid, p->bgid + 1,
-					GFP_KERNEL);
+		ret = xa_err(xa_store(&ctx->io_buffers, p->bgid, head,
+					GFP_KERNEL));
 		if (ret < 0) {
 			__io_remove_buffers(ctx, head, p->bgid, -1U);
 			goto out;
@@ -8468,19 +8469,15 @@ static int io_eventfd_unregister(struct io_ring_ctx *ctx)
 	return -ENXIO;
 }
 
-static int __io_destroy_buffers(int id, void *p, void *data)
-{
-	struct io_ring_ctx *ctx = data;
-	struct io_buffer *buf = p;
-
-	__io_remove_buffers(ctx, buf, id, -1U);
-	return 0;
-}
-
 static void io_destroy_buffers(struct io_ring_ctx *ctx)
 {
-	idr_for_each(&ctx->io_buffer_idr, __io_destroy_buffers, ctx);
-	idr_destroy(&ctx->io_buffer_idr);
+	unsigned long pgid;
+	struct io_buffer *buf;
+
+	xa_for_each(&ctx->io_buffers, pgid, buf) {
+		xa_erase(&ctx->io_buffers, pgid);
+		__io_remove_buffers(ctx, buf, pgid, -1U);
+	}
 }
 
 static void io_ring_ctx_free(struct io_ring_ctx *ctx)

