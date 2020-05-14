Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 784E11D34C7
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2020 17:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgENPPb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 May 2020 11:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgENPPb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 May 2020 11:15:31 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5712FC061A0C
        for <io-uring@vger.kernel.org>; Thu, 14 May 2020 08:15:31 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id f4so1358442pgi.10
        for <io-uring@vger.kernel.org>; Thu, 14 May 2020 08:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hMOpDJkAEEdMSrPiP8lTGNKCX96yEq6IA/XFIqxlWSI=;
        b=RD48UHxYXTjTyYqkeFdVfBN8G1/hTU0AYuwY1KUkcHrk5kmXFFHdtgFLaHwFAgWSEE
         JPAwHH6uyqZcqsM8zWGJq7BuM1JyZQT9Yo6Udg9OLdDDQNi2q1epwLprKudJ9MrZg8pX
         hlRXpUqxPP3+CsoZmaqx0SNsLVauVVppiKyR5Mi81w+1Js/FY5ZxYRhE2pSyve8q1T8z
         O415x+wn09fZaYkmx4fxSJyN96vqZoGsRBbIg38IMNSaebcafkRiFViE6kR5dwBwtCTC
         bp31+HOf8Rm3B8SRT6zwslHLIHh8YI+GP/2dljwqhFyFGOVTWhQdVFac4o+Y/9riPR30
         eBXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hMOpDJkAEEdMSrPiP8lTGNKCX96yEq6IA/XFIqxlWSI=;
        b=IY4LZU05IOMdpAck0RAsP3dI4UC4C3dWPrDiUSHsfnCEDny67JSxUabvbkUcGUnqEt
         vSItrZOwgkwwIYVUwUPONZIOcVS5AgxiNn8FfPax0jtpM2d/fSsg3qk3MmvY2AQoU9d9
         xZvcx9lphNvfjWggLkcEwmAQciHipAP2uIoqstOsAE7IFLl9ALDkue3pRS+DMpzbXguF
         ZsqqxouFf8JTiwr1QumT6vzYs9bg6202fvMmevtWOXAWpAdz+8viSsf6zMo10J1miEBb
         WVUJdl5Xwzh6Se3xniOlrvGlcuSrcorPjuuZyvSnTxebCEc+8KeBfiMauXqolLR4s+OY
         sB6g==
X-Gm-Message-State: AOAM533TfXh8Ts270exht1EDo2vSQ/o01cLOWo3AI5cKbRxk3qyo+85i
        J7lGmRCvVfk5NrnEy7Wpn33cpg==
X-Google-Smtp-Source: ABdhPJy+3bb1fp7SsvCjdaf9YHBshM690MVgrRK1fGADj1MJLm7dcoisufZm/ERmd9lJFBoCdnKEzw==
X-Received: by 2002:a63:e602:: with SMTP id g2mr4421235pgh.380.1589469330620;
        Thu, 14 May 2020 08:15:30 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:85e7:ddeb:bb07:3741? ([2605:e000:100e:8c61:85e7:ddeb:bb07:3741])
        by smtp.gmail.com with ESMTPSA id i3sm2572323pfe.44.2020.05.14.08.15.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 08:15:29 -0700 (PDT)
Subject: Re: [PATCH RFC} io_uring: io_kiocb alloc cache
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     joseph qi <joseph.qi@linux.alibaba.com>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>
References: <492bb956-a670-8730-a35f-1d878c27175f@kernel.dk>
 <dc5a0caf-0ba4-bfd7-4b6e-cbcb3e6fde10@linux.alibaba.com>
 <70602a13-f6c9-e8a8-1035-6f148ba2d6d7@kernel.dk>
 <a68bbc0a-5bd7-06b6-1616-2704512228b8@kernel.dk>
 <0ec1b33d-893f-1b10-128e-f8a8950b0384@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a2b5e500-316d-dc06-1a25-72aaf67ac227@kernel.dk>
Date:   Thu, 14 May 2020 09:15:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <0ec1b33d-893f-1b10-128e-f8a8950b0384@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/14/20 8:53 AM, Pavel Begunkov wrote:
> On 14/05/2020 17:33, Jens Axboe wrote:
>> On 5/14/20 8:22 AM, Jens Axboe wrote:
>>>> I still use my previous io_uring_nop_stress tool to evaluate the improvement
>>>> in a physical machine. Memory 250GB and cpu is "Intel(R) Xeon(R) CPU E5-2682 v4 @ 2.50GHz".
>>>> Before this patch:
>>>> $sudo taskset -c 60 ./io_uring_nop_stress -r 300
>>>> total ios: 1608773840
>>>> IOPS:      5362579
>>>>
>>>> With this patch:
>>>> sudo taskset -c 60 ./io_uring_nop_stress -r 300
>>>> total ios: 1676910736
>>>> IOPS:      5589702
>>>> About 4.2% improvement.
>>>
>>> That's not bad. Can you try the patch from Pekka as well, just to see if
>>> that helps for you?
>>>
>>> I also had another idea... We basically have two types of request life
>>> times:
>>>
>>> 1) io_kiocb can get queued up internally
>>> 2) io_kiocb completes inline
>>>
>>> For the latter, it's totally feasible to just have the io_kiocb on
>>> stack. The downside is if we need to go the slower path, then we need to
>>> alloc an io_kiocb then and copy it. But maybe that's OK... I'll play
>>> with it.
> 
> Does it differ from having one pre-allocated req? Like fallback_req,
> but without atomics and returned only under uring_mutex (i.e. in
> __io_queue_sqe()). Putting aside its usefulness, at least it will have
> a chance to work with reads/writes.

But then you need atomics. I actually think the bigger win here is not
having to use atomic refcounts for this particular part, since we know
the request can't get shared.

Modified below with poor-man-dec-and-test, pretty sure that part is a
bigger win than avoiding the allocator. So maybe that's a better
directiont to take, for things we can't get irq completions on.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index d2e37215d05a..27c1c8f4d2f4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -525,6 +525,7 @@ enum {
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
 	REQ_F_NO_FILE_TABLE_BIT,
+	REQ_F_STACK_REQ_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -580,6 +581,8 @@ enum {
 	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
 	/* doesn't need file table for this request */
 	REQ_F_NO_FILE_TABLE	= BIT(REQ_F_NO_FILE_TABLE_BIT),
+	/* on-stack req */
+	REQ_F_STACK_REQ		= BIT(REQ_F_STACK_REQ_BIT),
 };
 
 struct async_poll {
@@ -695,10 +698,14 @@ struct io_op_def {
 	unsigned		pollout : 1;
 	/* op supports buffer selection */
 	unsigned		buffer_select : 1;
+	/* op can use stack req */
+	unsigned		stack_req : 1;
 };
 
 static const struct io_op_def io_op_defs[] = {
-	[IORING_OP_NOP] = {},
+	[IORING_OP_NOP] = {
+		.stack_req		= 1,
+	},
 	[IORING_OP_READV] = {
 		.async_ctx		= 1,
 		.needs_mm		= 1,
@@ -1345,7 +1352,8 @@ static void __io_req_aux_free(struct io_kiocb *req)
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		io_cleanup_req(req);
 
-	kfree(req->io);
+	if (req->io)
+		kfree(req->io);
 	if (req->file)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
 	if (req->task)
@@ -1370,6 +1378,8 @@ static void __io_free_req(struct io_kiocb *req)
 	}
 
 	percpu_ref_put(&req->ctx->refs);
+	if (req->flags & REQ_F_STACK_REQ)
+		return;
 	if (likely(!io_is_fallback_req(req)))
 		kmem_cache_free(req_cachep, req);
 	else
@@ -1585,7 +1595,14 @@ static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
 __attribute__((nonnull))
 static void io_put_req_find_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
 {
-	if (refcount_dec_and_test(&req->refs)) {
+	bool free_it;
+
+	if (req->flags & REQ_F_STACK_REQ)
+		free_it = __refcount_dec_and_test(&req->refs);
+	else
+		free_it = refcount_dec_and_test(&req->refs);
+
+	if (free_it) {
 		io_req_find_next(req, nxtptr);
 		__io_free_req(req);
 	}
@@ -1593,7 +1610,13 @@ static void io_put_req_find_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
 
 static void io_put_req(struct io_kiocb *req)
 {
-	if (refcount_dec_and_test(&req->refs))
+	bool free_it;
+
+	if (req->flags & REQ_F_STACK_REQ)
+		free_it = __refcount_dec_and_test(&req->refs);
+	else
+		free_it = refcount_dec_and_test(&req->refs);
+	if (free_it)
 		io_free_req(req);
 }
 
@@ -5784,12 +5807,10 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	 * link list.
 	 */
 	req->sequence = ctx->cached_sq_head - ctx->cached_sq_dropped;
-	req->opcode = READ_ONCE(sqe->opcode);
 	req->user_data = READ_ONCE(sqe->user_data);
 	req->io = NULL;
 	req->file = NULL;
 	req->ctx = ctx;
-	req->flags = 0;
 	/* one is dropped after submission, the other at completion */
 	refcount_set(&req->refs, 2);
 	req->task = NULL;
@@ -5839,6 +5860,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 {
 	struct io_submit_state state, *statep = NULL;
 	struct io_kiocb *link = NULL;
+	struct io_kiocb stack_req;
 	int i, submitted = 0;
 
 	/* if we have a backlog and couldn't flush it all, return BUSY */
@@ -5865,20 +5887,31 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	for (i = 0; i < nr; i++) {
 		const struct io_uring_sqe *sqe;
 		struct io_kiocb *req;
-		int err;
+		int err, op;
 
 		sqe = io_get_sqe(ctx);
 		if (unlikely(!sqe)) {
 			io_consume_sqe(ctx);
 			break;
 		}
-		req = io_alloc_req(ctx, statep);
-		if (unlikely(!req)) {
-			if (!submitted)
-				submitted = -EAGAIN;
-			break;
+
+		op = READ_ONCE(sqe->opcode);
+
+		if (io_op_defs[op].stack_req) {
+			req = &stack_req;
+			req->flags = REQ_F_STACK_REQ;
+		} else {
+			req = io_alloc_req(ctx, statep);
+			if (unlikely(!req)) {
+				if (!submitted)
+					submitted = -EAGAIN;
+				break;
+			}
+			req->flags = 0;
 		}
 
+		req->opcode = op;
+
 		err = io_init_req(ctx, req, sqe, statep, async);
 		io_consume_sqe(ctx);
 		/* will complete beyond this point, count as submitted */
diff --git a/include/linux/refcount.h b/include/linux/refcount.h
index 0e3ee25eb156..1afaf73c0984 100644
--- a/include/linux/refcount.h
+++ b/include/linux/refcount.h
@@ -294,6 +294,13 @@ static inline __must_check bool refcount_dec_and_test(refcount_t *r)
 	return refcount_sub_and_test(1, r);
 }
 
+static inline __must_check bool __refcount_dec_and_test(refcount_t *r)
+{
+	int old = --r->refs.counter;
+
+	return old == 0;
+}
+
 /**
  * refcount_dec - decrement a refcount
  * @r: the refcount

-- 
Jens Axboe

