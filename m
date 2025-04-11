Return-Path: <io-uring+bounces-7453-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F7E0A85FCB
	for <lists+io-uring@lfdr.de>; Fri, 11 Apr 2025 15:58:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E26F03BFBE4
	for <lists+io-uring@lfdr.de>; Fri, 11 Apr 2025 13:55:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5922812CDBE;
	Fri, 11 Apr 2025 13:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ecovjPMD"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F17F2367B7;
	Fri, 11 Apr 2025 13:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744379729; cv=none; b=OkvtVFtSH+z/MBmnjKNJxKmb51cniPISwtWACU8IK0CmdywM2OVlL24jgeuyGq8i+i+cQBSbbPSB/Kpz2ZBVFm+eFhp7mUqh2AmDbdpDifL0oKspNaSmabUBMuZsV0NBOibFmi36J3k35SrSTqb0JXSH0Fwj/BVSgVyqcQl5gtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744379729; c=relaxed/simple;
	bh=HQ2pZiqaXqjVl9Q7OM4VPu3+OAkJ/KMahrjpBIqunho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rACps1tHdOxOdIU40Kywky98NlD+KQBfD5XmAorJQGdQIgoG+MQx8KDFVg4hMO8kf4v+bvnKUQKXBTyzNnvR/VsF/r45zYOOao0Wg/wWvnDPp0IMm8xxuk3V4LccK7h+8dgHYvzSfuJ6p9evvjDGKkl1OsUQJgimcTn+2+jKgSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ecovjPMD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A0FC4CEE2;
	Fri, 11 Apr 2025 13:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744379728;
	bh=HQ2pZiqaXqjVl9Q7OM4VPu3+OAkJ/KMahrjpBIqunho=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ecovjPMDFI+Oh8jApChmBjmZ6JgQPVn0axmwSKhrFlCkJDwAJNNO17YVaMmUZ8SAN
	 iAuMm8HmFZbM90+7Vr2yxp7Nsu3AdNc6Ggx2bRWUtRmN0n72VEF7Ac/XVg+N1XMbSR
	 WJ8r5QLL6gjlegItBl+L4n8R+1GNyNF3HTQzHQX+/PqLfS69Cb5XPvqAWfVwa9w9+q
	 XI0HUcrE/sJMuvvIZGh8B4W1g2tYTE/Kp2/AnSc5zeKF9ZMyUsUbZ42PzdezRejxZq
	 7VQ0KGwuLdsihsMs26+Eay6btzO7UG3aZ48bL8g0viJK+SLboU/aLOowDiVcyTQVN0
	 cTGouWrw3y8Ag==
Date: Fri, 11 Apr 2025 15:55:24 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/5] io_uring: mark exit side kworkers as task_work
 capable
Message-ID: <20250411-reinreden-nester-8cd21e845563@brauner>
References: <20250409134057.198671-1-axboe@kernel.dk>
 <20250409134057.198671-3-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250409134057.198671-3-axboe@kernel.dk>

On Wed, Apr 09, 2025 at 07:35:20AM -0600, Jens Axboe wrote:
> There are two types of work here:
> 
> 1) Fallback work, if the task is exiting
> 2) The exit side cancelations
> 
> and both of them may do the final fput() of a file. When this happens,
> fput() will schedule delayed work. This slows down exits when io_uring

I was a bit surprised by this because it means that all those __fput()s
are done with kthread credentials which is a bit surprising (but
harmless afaict).

> needs to wait for that work to finish. It is possible to flush this via
> flush_delayed_fput(), but that's a big hammer as other unrelated files
> could be involved, and from other tasks as well.
> 
> Add two io_uring helpers to temporarily clear PF_NO_TASKWORK for the
> worker threads, and run any queued task_work before setting the flag
> again. Then we can ensure we only flush related items that received
> their final fput as part of work cancelation and flushing.

Ok, so the only change is that this isn't offloaded to the global
delayed fput workqueue but to the task work that you're running off of
your kthread helpers.

> 
> For now these are io_uring private, but could obviously be made
> generically available, should there be a need to do so.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  io_uring/io_uring.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index c6209fe44cb1..bff99e185217 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -238,6 +238,20 @@ static inline void io_req_add_to_cache(struct io_kiocb *req, struct io_ring_ctx
>  	wq_stack_add_head(&req->comp_list, &ctx->submit_state.free_list);
>  }
>  
> +static __cold void io_kworker_tw_start(void)
> +{
> +	if (WARN_ON_ONCE(!(current->flags & PF_NO_TASKWORK)))
> +		return;
> +	current->flags &= ~PF_NO_TASKWORK;
> +}
> +
> +static __cold void io_kworker_tw_end(void)
> +{
> +	while (task_work_pending(current))
> +		task_work_run();
> +	current->flags |= PF_NO_TASKWORK;
> +}
> +
>  static __cold void io_ring_ctx_ref_free(struct percpu_ref *ref)
>  {
>  	struct io_ring_ctx *ctx = container_of(ref, struct io_ring_ctx, refs);
> @@ -253,6 +267,8 @@ static __cold void io_fallback_req_func(struct work_struct *work)
>  	struct io_kiocb *req, *tmp;
>  	struct io_tw_state ts = {};
>  
> +	io_kworker_tw_start();
> +
>  	percpu_ref_get(&ctx->refs);
>  	mutex_lock(&ctx->uring_lock);
>  	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
> @@ -260,6 +276,7 @@ static __cold void io_fallback_req_func(struct work_struct *work)
>  	io_submit_flush_completions(ctx);
>  	mutex_unlock(&ctx->uring_lock);
>  	percpu_ref_put(&ctx->refs);
> +	io_kworker_tw_end();
>  }
>  
>  static int io_alloc_hash_table(struct io_hash_table *table, unsigned bits)
> @@ -2876,6 +2893,8 @@ static __cold void io_ring_exit_work(struct work_struct *work)
>  	struct io_tctx_node *node;
>  	int ret;
>  
> +	io_kworker_tw_start();
> +
>  	/*
>  	 * If we're doing polled IO and end up having requests being
>  	 * submitted async (out-of-line), then completions can come in while
> @@ -2932,6 +2951,8 @@ static __cold void io_ring_exit_work(struct work_struct *work)
>  		 */
>  	} while (!wait_for_completion_interruptible_timeout(&ctx->ref_comp, interval));
>  
> +	io_kworker_tw_end();
> +
>  	init_completion(&exit.completion);
>  	init_task_work(&exit.task_work, io_tctx_exit_cb);
>  	exit.ctx = ctx;
> -- 
> 2.49.0
> 

