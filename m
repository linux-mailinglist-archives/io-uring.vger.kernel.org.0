Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B612A678F
	for <lists+io-uring@lfdr.de>; Wed,  4 Nov 2020 16:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730246AbgKDPZS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Nov 2020 10:25:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729980AbgKDPZP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Nov 2020 10:25:15 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1197C0613D3
        for <io-uring@vger.kernel.org>; Wed,  4 Nov 2020 07:25:13 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id p10so19659131ile.3
        for <io-uring@vger.kernel.org>; Wed, 04 Nov 2020 07:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/I55w5ZEjSQvNDMlWUra7Vh4lxKcfCqaip9MAI8qAPo=;
        b=y1mInUa5/sn2t/rrInTcF9KJb3nUXyoslzfMBWpnIcq2RquLacgwCDk9IaYeryg7We
         op5PVjlYlLSieE5Xe24NtTX7PnIOhPNFYDmMDLL9y7ypbakLlaIHD/4PYXvQA+POHJ6j
         /1I0NZ0JbixfCsnbLR24DK60uOX6XAlTWWR9LA1O3S1CZUfgKZVz8fliNYG20dKC5DYv
         shx8Tb6yNDy6KJnvFSmvdNv8cxWdl58Z8f/tynCIJZYiXl8oU6/LfWyahl24rz3V4pBq
         JuYe2qgw7RpFP+TIn2gE409ktJjaw85Im5VQ5vO0dh5UoBUSQVy0antDou7aUmnjlPps
         SdGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/I55w5ZEjSQvNDMlWUra7Vh4lxKcfCqaip9MAI8qAPo=;
        b=HtORnzVL/7r5GbL/XhTsgVB/wOb4iHIH/pvia9+uXxvVpO4BHYKQEHihYAu+lq55gZ
         nyBqXdFY1Bz3cP4k6+0+BIDgfOKrQf73M1GqPQfB6bW5zYlEfiei9KDiZABmFj68KnCD
         sOI9DSqnrTmq6BbvnYtbydJniG4wKSt1J0g/pkZbzy1ZLPy+Snyf24lkpvzJoxezqGjk
         vStNJa5+d46eTNk62IBjjvMMlDzaXURUFTjqfRNcthcoswkC4t3yIg0sBL9a0cAflfYv
         S+D1PziCplLHkodYzefsH0fP5Mv3CtRRCmQnllkOP6/1DTRycpIk9AKYhIshpjd86wgM
         uD+A==
X-Gm-Message-State: AOAM533uXg21vD8vKchrqAB8uByc9MMR7LoGUj7qzIpm9QagtMGI70mh
        CohoPQwv7fEP7Wa40aMr3UwGVRauuptkCA==
X-Google-Smtp-Source: ABdhPJyVp82+faRLgSKd0X/JtSdxg9Ce0NmSyh/gOSPYgSpm4ITHRcRAPMFKmHxca5lhbcrAJzs1BA==
X-Received: by 2002:a92:358a:: with SMTP id c10mr6192565ilf.258.1604503512730;
        Wed, 04 Nov 2020 07:25:12 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v88sm1618350ila.71.2020.11.04.07.25.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 07:25:12 -0800 (PST)
Subject: Re: [PATCH 5.10] io_uring: fix overflowed cancel w/ linked ->files
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <9d97c12a0833617f7adff44f16dc543242d9a1f7.1604496692.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <dcbb9f34-9943-8a80-14c0-a968e02254b6@kernel.dk>
Date:   Wed, 4 Nov 2020 08:25:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9d97c12a0833617f7adff44f16dc543242d9a1f7.1604496692.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/4/20 6:39 AM, Pavel Begunkov wrote:
> Current io_match_files() check in io_cqring_overflow_flush() is useless
> because requests drop ->files before going to the overflow list, however
> linked to it request do not, and we don't check them.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> Jens, there will be conflicts with 5.11 patches, I'd appreciate if you
> could ping me when/if you merge it into 5.11

Just for this one:

io_uring: link requests with singly linked list

How does the below look, now based on top of this patch added to
io_uring-5.10:


commit f5a63f6bb1ecfb8852ac2628d53dc3e9644f7f3f
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Tue Oct 27 23:25:37 2020 +0000

    io_uring: link requests with singly linked list
    
    Singly linked list for keeping linked requests is enough, because we
    almost always operate on the head and traverse forward with the
    exception of linked timeouts going 1 hop backwards.
    
    Replace ->link_list with a handmade singly linked list. Also kill
    REQ_F_LINK_HEAD in favour of checking a newly added ->list for NULL
    directly.
    
    That saves 8B in io_kiocb, is not as heavy as list fixup, makes better
    use of cache by not touching a previous request (i.e. last request of
    the link) each time on list modification and optimises cache use further
    in the following patch, and actually makes travesal easier removing in
    the end some lines. Also, keeping invariant in ->list instead of having
    REQ_F_LINK_HEAD is less error-prone.
    
    Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3f6bc98a91da..a701e8fe6716 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -598,7 +598,6 @@ enum {
 	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
 	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
 
-	REQ_F_LINK_HEAD_BIT,
 	REQ_F_FAIL_LINK_BIT,
 	REQ_F_INFLIGHT_BIT,
 	REQ_F_CUR_POS_BIT,
@@ -630,8 +629,6 @@ enum {
 	/* IOSQE_BUFFER_SELECT */
 	REQ_F_BUFFER_SELECT	= BIT(REQ_F_BUFFER_SELECT_BIT),
 
-	/* head of a link */
-	REQ_F_LINK_HEAD		= BIT(REQ_F_LINK_HEAD_BIT),
 	/* fail rest of links */
 	REQ_F_FAIL_LINK		= BIT(REQ_F_FAIL_LINK_BIT),
 	/* on inflight list */
@@ -713,7 +710,7 @@ struct io_kiocb {
 	struct task_struct		*task;
 	u64				user_data;
 
-	struct list_head		link_list;
+	struct io_kiocb			*link;
 
 	/*
 	 * 1. used with ctx->iopoll_list with reads/writes
@@ -1021,6 +1018,9 @@ struct sock *io_uring_get_socket(struct file *file)
 }
 EXPORT_SYMBOL(io_uring_get_socket);
 
+#define io_for_each_link(pos, head) \
+	for (pos = (head); pos; pos = pos->link)
+
 static inline void io_clean_op(struct io_kiocb *req)
 {
 	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED |
@@ -1505,10 +1505,8 @@ static void io_prep_async_link(struct io_kiocb *req)
 {
 	struct io_kiocb *cur;
 
-	io_prep_async_work(req);
-	if (req->flags & REQ_F_LINK_HEAD)
-		list_for_each_entry(cur, &req->link_list, link_list)
-			io_prep_async_work(cur);
+	io_for_each_link(cur, req)
+		io_prep_async_work(cur);
 }
 
 static struct io_kiocb *__io_queue_async_work(struct io_kiocb *req)
@@ -1691,20 +1689,15 @@ static inline bool __io_match_files(struct io_kiocb *req,
 		req->work.identity->files == files;
 }
 
-static bool io_match_files(struct io_kiocb *req,
-			   struct files_struct *files)
+static bool io_match_files(struct io_kiocb *head, struct files_struct *files)
 {
-	struct io_kiocb *link;
+	struct io_kiocb *req;
 
 	if (!files)
 		return true;
-	if (__io_match_files(req, files))
-		return true;
-	if (req->flags & REQ_F_LINK_HEAD) {
-		list_for_each_entry(link, &req->link_list, link_list) {
-			if (__io_match_files(link, files))
-				return true;
-		}
+	io_for_each_link(req, head) {
+		if (__io_match_files(req, files))
+			return true;
 	}
 	return false;
 }
@@ -1971,6 +1964,14 @@ static void __io_free_req(struct io_kiocb *req)
 	percpu_ref_put(&ctx->refs);
 }
 
+static inline void io_remove_next_linked(struct io_kiocb *req)
+{
+	struct io_kiocb *nxt = req->link;
+
+	req->link = nxt->link;
+	nxt->link = NULL;
+}
+
 static void io_kill_linked_timeout(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1979,8 +1980,8 @@ static void io_kill_linked_timeout(struct io_kiocb *req)
 	unsigned long flags;
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
-	link = list_first_entry_or_null(&req->link_list, struct io_kiocb,
-					link_list);
+	link = req->link;
+
 	/*
 	 * Can happen if a linked timeout fired and link had been like
 	 * req -> link t-out -> link t-out [-> ...]
@@ -1989,7 +1990,7 @@ static void io_kill_linked_timeout(struct io_kiocb *req)
 		struct io_timeout_data *io = link->async_data;
 		int ret;
 
-		list_del_init(&link->link_list);
+		io_remove_next_linked(req);
 		link->timeout.head = NULL;
 		ret = hrtimer_try_to_cancel(&io->timer);
 		if (ret != -1) {
@@ -2007,41 +2008,22 @@ static void io_kill_linked_timeout(struct io_kiocb *req)
 	}
 }
 
-static struct io_kiocb *io_req_link_next(struct io_kiocb *req)
-{
-	struct io_kiocb *nxt;
-
-	/*
-	 * The list should never be empty when we are called here. But could
-	 * potentially happen if the chain is messed up, check to be on the
-	 * safe side.
-	 */
-	if (unlikely(list_empty(&req->link_list)))
-		return NULL;
-
-	nxt = list_first_entry(&req->link_list, struct io_kiocb, link_list);
-	list_del_init(&req->link_list);
-	if (!list_empty(&nxt->link_list))
-		nxt->flags |= REQ_F_LINK_HEAD;
-	return nxt;
-}
 
-/*
- * Called if REQ_F_LINK_HEAD is set, and we fail the head request
- */
 static void io_fail_links(struct io_kiocb *req)
 {
+	struct io_kiocb *link, *nxt;
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
-	while (!list_empty(&req->link_list)) {
-		struct io_kiocb *link = list_first_entry(&req->link_list,
-						struct io_kiocb, link_list);
+	link = req->link;
+	req->link = NULL;
 
-		list_del_init(&link->link_list);
-		trace_io_uring_fail_link(req, link);
+	while (link) {
+		nxt = link->link;
+		link->link = NULL;
 
+		trace_io_uring_fail_link(req, link);
 		io_cqring_fill_event(link, -ECANCELED);
 
 		/*
@@ -2053,8 +2035,8 @@ static void io_fail_links(struct io_kiocb *req)
 			io_put_req_deferred(link, 2);
 		else
 			io_double_put_req(link);
+		link = nxt;
 	}
-
 	io_commit_cqring(ctx);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
@@ -2063,7 +2045,6 @@ static void io_fail_links(struct io_kiocb *req)
 
 static struct io_kiocb *__io_req_find_next(struct io_kiocb *req)
 {
-	req->flags &= ~REQ_F_LINK_HEAD;
 	if (req->flags & REQ_F_LINK_TIMEOUT)
 		io_kill_linked_timeout(req);
 
@@ -2073,15 +2054,19 @@ static struct io_kiocb *__io_req_find_next(struct io_kiocb *req)
 	 * dependencies to the next request. In case of failure, fail the rest
 	 * of the chain.
 	 */
-	if (likely(!(req->flags & REQ_F_FAIL_LINK)))
-		return io_req_link_next(req);
+	if (likely(!(req->flags & REQ_F_FAIL_LINK))) {
+		struct io_kiocb *nxt = req->link;
+
+		req->link = NULL;
+		return nxt;
+	}
 	io_fail_links(req);
 	return NULL;
 }
 
-static struct io_kiocb *io_req_find_next(struct io_kiocb *req)
+static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 {
-	if (likely(!(req->flags & REQ_F_LINK_HEAD)))
+	if (likely(!(req->link) && !(req->flags & REQ_F_LINK_TIMEOUT)))
 		return NULL;
 	return __io_req_find_next(req);
 }
@@ -2176,7 +2161,7 @@ static void io_req_task_queue(struct io_kiocb *req)
 	}
 }
 
-static void io_queue_next(struct io_kiocb *req)
+static inline void io_queue_next(struct io_kiocb *req)
 {
 	struct io_kiocb *nxt = io_req_find_next(req);
 
@@ -2233,8 +2218,7 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
 		io_free_req(req);
 		return;
 	}
-	if (req->flags & REQ_F_LINK_HEAD)
-		io_queue_next(req);
+	io_queue_next(req);
 
 	if (req->task != rb->task) {
 		if (rb->task) {
@@ -6003,11 +5987,10 @@ static u32 io_get_sequence(struct io_kiocb *req)
 {
 	struct io_kiocb *pos;
 	struct io_ring_ctx *ctx = req->ctx;
-	u32 total_submitted, nr_reqs = 1;
+	u32 total_submitted, nr_reqs = 0;
 
-	if (req->flags & REQ_F_LINK_HEAD)
-		list_for_each_entry(pos, &req->link_list, link_list)
-			nr_reqs++;
+	io_for_each_link(pos, req)
+		nr_reqs++;
 
 	total_submitted = ctx->cached_sq_head - ctx->cached_sq_dropped;
 	return total_submitted - nr_reqs;
@@ -6362,7 +6345,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	 * race with the completion of the linked work.
 	 */
 	if (prev && refcount_inc_not_zero(&prev->refs))
-		list_del_init(&req->link_list);
+		io_remove_next_linked(prev);
 	else
 		prev = NULL;
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
@@ -6380,8 +6363,8 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 static void __io_queue_linked_timeout(struct io_kiocb *req)
 {
 	/*
-	 * If the list is now empty, then our linked request finished before
-	 * we got a chance to setup the timer
+	 * If the back reference is NULL, then our linked request finished
+	 * before we got a chance to setup the timer
 	 */
 	if (req->timeout.head) {
 		struct io_timeout_data *data = req->async_data;
@@ -6406,16 +6389,10 @@ static void io_queue_linked_timeout(struct io_kiocb *req)
 
 static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 {
-	struct io_kiocb *nxt;
-
-	if (!(req->flags & REQ_F_LINK_HEAD))
-		return NULL;
-	if (req->flags & REQ_F_LINK_TIMEOUT)
-		return NULL;
+	struct io_kiocb *nxt = req->link;
 
-	nxt = list_first_entry_or_null(&req->link_list, struct io_kiocb,
-					link_list);
-	if (!nxt || nxt->opcode != IORING_OP_LINK_TIMEOUT)
+	if (!nxt || (req->flags & REQ_F_LINK_TIMEOUT) ||
+	    nxt->opcode != IORING_OP_LINK_TIMEOUT)
 		return NULL;
 
 	nxt->timeout.head = req;
@@ -6563,7 +6540,7 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			return ret;
 		}
 		trace_io_uring_link(ctx, req, head);
-		list_add_tail(&req->link_list, &head->link_list);
+		link->last->link = req;
 		link->last = req;
 
 		/* last request of a link, enqueue the link */
@@ -6577,9 +6554,6 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			ctx->drain_next = 0;
 		}
 		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
-			req->flags |= REQ_F_LINK_HEAD;
-			INIT_LIST_HEAD(&req->link_list);
-
 			ret = io_req_defer_prep(req, sqe);
 			if (unlikely(ret))
 				req->flags |= REQ_F_FAIL_LINK;
@@ -6712,6 +6686,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->file = NULL;
 	req->ctx = ctx;
 	req->flags = 0;
+	req->link = NULL;
 	/* one is dropped after submission, the other at completion */
 	refcount_set(&req->refs, 2);
 	req->task = current;
@@ -8663,14 +8638,10 @@ static bool io_match_link(struct io_kiocb *preq, struct io_kiocb *req)
 {
 	struct io_kiocb *link;
 
-	if (!(preq->flags & REQ_F_LINK_HEAD))
-		return false;
-
-	list_for_each_entry(link, &preq->link_list, link_list) {
+	io_for_each_link(link, preq->link) {
 		if (link == req)
 			return true;
 	}
-
 	return false;
 }
 

-- 
Jens Axboe

