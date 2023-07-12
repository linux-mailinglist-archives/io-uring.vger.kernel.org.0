Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44C6750208
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 10:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbjGLIvr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Jul 2023 04:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbjGLIvf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Jul 2023 04:51:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287381703;
        Wed, 12 Jul 2023 01:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DHhCKGZdH/5rZrSaKb5E3CgdrbPl5nVO/J8xZtPwSIg=; b=bppyBLuE3mFHmPDyFqjlD16QRs
        kbWcuGabWQi3MxItLRYSjS3ID0w2ySs657uAfNbwq9a22eHx+BmRuMX8END5Fnlpmu3RLCirWSK10
        gEVXuBz25d7dAL4Wu3yBqTrvAKHDbMgFq5yrIITWfWxjKaILJvb0+My4oOoqwvDwbR5H85282KG9e
        GHCmBZXHqGYfKLK2Ucn+jUBzFERxMgIv4k85RqpKJ3AFME5wAfLn9jzMV9lZT2tdkphSwVpx3E47A
        /9AiWwB43320Wen1xa+FoBTAPxb77GIOMDMv5sKpbFsWWsY2u7G1vphtsxAANoaqOaVtsuN7K9dUq
        eAIAj7Rw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qJVZ7-00GVq5-Ts; Wed, 12 Jul 2023 08:51:17 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1493B3002CE;
        Wed, 12 Jul 2023 10:51:17 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id F3850243AF2B7; Wed, 12 Jul 2023 10:51:16 +0200 (CEST)
Date:   Wed, 12 Jul 2023 10:51:16 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH 3/7] io_uring: add support for futex wake and wait
Message-ID: <20230712085116.GC3100107@hirez.programming.kicks-ass.net>
References: <20230712004705.316157-1-axboe@kernel.dk>
 <20230712004705.316157-4-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712004705.316157-4-axboe@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 11, 2023 at 06:47:01PM -0600, Jens Axboe wrote:
> Add support for FUTEX_WAKE/WAIT primitives.
> 
> IORING_OP_FUTEX_WAKE is mix of FUTEX_WAKE and FUTEX_WAKE_BITSET, as
> it does support passing in a bitset.
> 
> Similary, IORING_OP_FUTEX_WAIT is a mix of FUTEX_WAIT and
> FUTEX_WAIT_BITSET.
> 
> FUTEX_WAKE is straight forward, as we can always just do those inline.
> FUTEX_WAIT will queue the futex with an appropriate callback, and
> that callback will in turn post a CQE when it has triggered.
> 
> Cancelations are supported, both from the application point-of-view,
> but also to be able to cancel pending waits if the ring exits before
> all events have occurred.
> 
> This is just the barebones wait/wake support. PI or REQUEUE support is
> not added at this point, unclear if we might look into that later.
> 
> Likewise, explicit timeouts are not supported either. It is expected
> that users that need timeouts would do so via the usual io_uring
> mechanism to do that using linked timeouts.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

I'm not sure I'm qualified to review this :/ I really don't know
anything about how io-uring works. And the above doesn't really begin to
explain things.


> +static void io_futex_wake_fn(struct wake_q_head *wake_q, struct futex_q *q)
> +{
> +	struct io_futex_data *ifd = container_of(q, struct io_futex_data, q);
> +	struct io_kiocb *req = ifd->req;
> +
> +	__futex_unqueue(q);
> +	smp_store_release(&q->lock_ptr, NULL);
> +
> +	io_req_set_res(req, 0, 0);
> +	req->io_task_work.func = io_futex_complete;
> +	io_req_task_work_add(req);
> +}

I'm noting the WARN from futex_wake_mark() went walk-about.

Perhaps something like so?


diff --git a/kernel/futex/waitwake.c b/kernel/futex/waitwake.c
index ba01b9408203..07758d48d5db 100644
--- a/kernel/futex/waitwake.c
+++ b/kernel/futex/waitwake.c
@@ -106,20 +106,11 @@
  * double_lock_hb() and double_unlock_hb(), respectively.
  */
 
-/*
- * The hash bucket lock must be held when this is called.
- * Afterwards, the futex_q must not be accessed. Callers
- * must ensure to later call wake_up_q() for the actual
- * wakeups to occur.
- */
-void futex_wake_mark(struct wake_q_head *wake_q, struct futex_q *q)
+bool __futex_wake_mark(struct futex_q *q)
 {
-	struct task_struct *p = q->task;
-
 	if (WARN(q->pi_state || q->rt_waiter, "refusing to wake PI futex\n"))
-		return;
+		return false;
 
-	get_task_struct(p);
 	__futex_unqueue(q);
 	/*
 	 * The waiting task can free the futex_q as soon as q->lock_ptr = NULL
@@ -130,6 +121,26 @@ void futex_wake_mark(struct wake_q_head *wake_q, struct futex_q *q)
 	 */
 	smp_store_release(&q->lock_ptr, NULL);
 
+	return true;
+}
+
+/*
+ * The hash bucket lock must be held when this is called.
+ * Afterwards, the futex_q must not be accessed. Callers
+ * must ensure to later call wake_up_q() for the actual
+ * wakeups to occur.
+ */
+void futex_wake_mark(struct wake_q_head *wake_q, struct futex_q *q)
+{
+	struct task_struct *p = q->task;
+
+	get_task_struct(p);
+
+	if (!__futex_wake_mark(q)) {
+		put_task_struct(p);
+		return;
+	}
+
 	/*
 	 * Queue the task for later wakeup for after we've released
 	 * the hb->lock.
