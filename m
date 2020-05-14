Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D16FF1D3302
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2020 16:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgENOdm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 May 2020 10:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbgENOdm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 May 2020 10:33:42 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A03C061A0C
        for <io-uring@vger.kernel.org>; Thu, 14 May 2020 07:33:41 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 23so1380984pfy.8
        for <io-uring@vger.kernel.org>; Thu, 14 May 2020 07:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MkuKw+sxjvGuqxJdpesOpuEhAAy+cBgVlzhwJt6exMw=;
        b=Pey6467nTZjbvEntOBfNxuK+MR5QXU7/6wKb+7uV5N+9OT5sSo5LNKPWxgw0C/+xA5
         ixAXBadzLgremE7F7r1A20NT/qiSpZ7EYzYa1hjt8eI11B21QrUBHsU4HnPKda63gW/q
         L0+Ru0xFSyNhQZUlobCPSPrc2+oLySM5GJp0PnAe3D9FKUi7Tb1asj/qmFuluLNup04e
         W27lkuKM8gGBfMclfDcfb4pLZxFsoPfaKlZ0Ix54SKFXCo4pisc/8TppaUYnpNLN+Vlu
         AmF8IhEG9MT1iQO2UrIviszOQR5Kcct07IEsSOLS49lSh3jP50itY1+2bz6vaqDLlxdT
         Xs0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MkuKw+sxjvGuqxJdpesOpuEhAAy+cBgVlzhwJt6exMw=;
        b=GWsX1BDwROBhTowN3ymrGwoaOYgmJAMhCW05NoiKkCLI99gjtC7x0S/N62WxG/Sczj
         d9G2SVbwPKPKLE8HHPts1r2sxzxE1cpXBVMpHK3LC2MpE9sfnoomhoHUyoY9y+k2rE/1
         Z4fiwfG75fMRQDygqjacdC0IyoQdlC1seQNpnxTOYM5kySEIsJb+05JBmDbQyWP05vLD
         +RZ6UALwlC6MpairwPBKUAZZXQRU+jO8NfR2xAItgja0kHXFauDtYDPuaMognEJjpqTm
         Kd710U/1Oo32HZgO+ECbbkZAj/JL69G6f0J8WOBS380aocNmrVcJGeDVfj39tKaFy2B0
         /8sA==
X-Gm-Message-State: AOAM533IvRPqqTEsauBOkHfmgEYKoNKrfDPibcWvzHREoXsGLdvo9PZr
        ElyCJhMroS7JDUP301Y0dBnPiP1uJAw=
X-Google-Smtp-Source: ABdhPJxJ0uEAhRzNODiuXSDQgp5av5rhb69u842oH8pbvBGSbgXIYTw1+vYbZNya4Z0NbyYPtsZAMQ==
X-Received: by 2002:a62:2ac3:: with SMTP id q186mr2702919pfq.101.1589466820476;
        Thu, 14 May 2020 07:33:40 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:85e7:ddeb:bb07:3741? ([2605:e000:100e:8c61:85e7:ddeb:bb07:3741])
        by smtp.gmail.com with ESMTPSA id nu10sm19707849pjb.9.2020.05.14.07.33.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 07:33:39 -0700 (PDT)
Subject: Re: [PATCH RFC} io_uring: io_kiocb alloc cache
From:   Jens Axboe <axboe@kernel.dk>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     joseph qi <joseph.qi@linux.alibaba.com>,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <492bb956-a670-8730-a35f-1d878c27175f@kernel.dk>
 <dc5a0caf-0ba4-bfd7-4b6e-cbcb3e6fde10@linux.alibaba.com>
 <70602a13-f6c9-e8a8-1035-6f148ba2d6d7@kernel.dk>
Message-ID: <a68bbc0a-5bd7-06b6-1616-2704512228b8@kernel.dk>
Date:   Thu, 14 May 2020 08:33:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <70602a13-f6c9-e8a8-1035-6f148ba2d6d7@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/14/20 8:22 AM, Jens Axboe wrote:
>> I still use my previous io_uring_nop_stress tool to evaluate the improvement
>> in a physical machine. Memory 250GB and cpu is "Intel(R) Xeon(R) CPU E5-2682 v4 @ 2.50GHz".
>> Before this patch:
>> $sudo taskset -c 60 ./io_uring_nop_stress -r 300
>> total ios: 1608773840
>> IOPS:      5362579
>>
>> With this patch:
>> sudo taskset -c 60 ./io_uring_nop_stress -r 300
>> total ios: 1676910736
>> IOPS:      5589702
>> About 4.2% improvement.
> 
> That's not bad. Can you try the patch from Pekka as well, just to see if
> that helps for you?
> 
> I also had another idea... We basically have two types of request life
> times:
> 
> 1) io_kiocb can get queued up internally
> 2) io_kiocb completes inline
> 
> For the latter, it's totally feasible to just have the io_kiocb on
> stack. The downside is if we need to go the slower path, then we need to
> alloc an io_kiocb then and copy it. But maybe that's OK... I'll play
> with it.

Can you try this with your microbenchmark? Just curious what it looks
like for that test case if we completely take slab alloc+free out of it.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index d2e37215d05a..4ecd6bd38f02 100644
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
@@ -5784,12 +5794,10 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
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
@@ -5839,6 +5847,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 {
 	struct io_submit_state state, *statep = NULL;
 	struct io_kiocb *link = NULL;
+	struct io_kiocb stack_req;
 	int i, submitted = 0;
 
 	/* if we have a backlog and couldn't flush it all, return BUSY */
@@ -5865,20 +5874,31 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
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

-- 
Jens Axboe

