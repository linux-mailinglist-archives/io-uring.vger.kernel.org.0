Return-Path: <io-uring+bounces-1242-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E517F88E6C8
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 15:43:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 146951C2E33A
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 14:43:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8919013BC1F;
	Wed, 27 Mar 2024 13:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BtJMkhjV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1A513BC10
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 13:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711546164; cv=none; b=OgdBFzO3xKwpP7J3iWn34IFohGWOIXKLkjbJm8m3tm+KaFOWYQX4Z60x0ULdHNFKXIeqvGDKH1wUkTUhTsQ4UfKpZpT6U7K4BecsvCgyFob9qkzOU4VxUdflB4RzAicq7SBCcf/xUzsScTpi3BUFVnUopSwj66am4dBL9tM9svU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711546164; c=relaxed/simple;
	bh=YW0w+LUYPXP5vYksVyfTqxvyQ8g88ygiNHoYZH59HrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ZTIbdCvsC9xvkUAxljLT8ChI+wkTM4zz9ga579bl9ZNv2KI0k17SIxHfSmj9/+LaDo5Xs4zCZwZoSl1P7JXpe5n3nNlUMCGIqOy9d6SkTlNGEEBHRBh81lXyrgapyJp+PnFRIGGs86LcnXN+WVBg18OvBGBgJVlivnzCWNek2+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BtJMkhjV; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-41488e17e1cso19754925e9.0
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 06:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711546161; x=1712150961; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zb+cmrDU8pfUAVo99dtcVuIZq/XWvJI+Io8muNo+KMM=;
        b=BtJMkhjVuRb/WsUF6M1Jdhm+ru+iKGdAoSIbgubyUcCe1TKnmkX3EXYKXxUqCIuvtq
         /5yzGGYROFC9GdDKjosAy6X3O9tcfprtHl2rUOCBywllHsF+krdlOAGbthqY47/h1Iqt
         RWDVWCWX1irrdDyxJubPjVE7Jttbbmbc0EhVMvPh62oUIBHhRRJmfPE7xGlrQqHKbw+5
         PjY1iih7Q8AjcfqJGigvEE6ED4Hax9sDcJawR/M421hAthbhH8/2JI2w9rsCcGsuOu2p
         FMDuyQzYYlvwFx9QSLh3bLJFMQiWvluj2dRAuXk0zbLUeX65UBkLxwvHItwvuIZ5sVww
         bLMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711546161; x=1712150961;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zb+cmrDU8pfUAVo99dtcVuIZq/XWvJI+Io8muNo+KMM=;
        b=jMJmYC6Yc0wu1ZxGzkhV8gRgFIBDvPs33T9hmcCwh4ttlWXxbVEkC3nMXf1Co3zKHS
         3vgMiCKvv0PN980UiqpWLc0Xt9bCEeA+/F8bdV/U9YFk8AvSQuSIfbiXxiPAUQXe4HAa
         md3dzf0iwL9Gcvlh+vQez3sSklIWPIoIOELbM01bJFSih04iRHA7Sr+5PJVbnPMtjesA
         xbkx50SEylySD+OlSUVI7WN39ARZVS1gjkca3Bg5ob/VBHjvFCGEb9UK6GwN2WM32O2Q
         0KxYGen2Fik3mDT28dNqxT/N7S4u9z7dplXk66phiJjeUwmowSKr0eAmqRVgZrRtqdNr
         N07g==
X-Forwarded-Encrypted: i=1; AJvYcCVxdZr6mv3BvSmUDE0rYHYGPuGx7jEzdcL3iQGUm33QkvMu+u7Y0I331Kl3SMXf4MYmsDi6SkYvx4gpEGo4LzrlVj7MVfR2yvw=
X-Gm-Message-State: AOJu0Yy91NcLpzLfpPhz1m6h4D54ohUIPIwz81rb5+3gHnMXpN+73ryO
	5C+n+91996+cg78GEVWK0JyuuiA82phIUU8c5Csjo0sfPzXFAbh6/PL//GmI
X-Google-Smtp-Source: AGHT+IFHJCR0cCc2KuPCbntPFUPJBmeR8T0VAxoluKkX1VvIEi16578+RcOXfs1p84oOoJD9XF0pTA==
X-Received: by 2002:a05:600c:470a:b0:414:132e:b485 with SMTP id v10-20020a05600c470a00b00414132eb485mr3066wmo.27.1711546160828;
        Wed, 27 Mar 2024 06:29:20 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.233.105])
        by smtp.gmail.com with ESMTPSA id l15-20020adfa38f000000b0033e03a6b1ecsm14948869wrb.18.2024.03.27.06.29.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Mar 2024 06:29:20 -0700 (PDT)
Message-ID: <22f87633-9efa-4cd2-ab5d-e6d225b28ad5@gmail.com>
Date: Wed, 27 Mar 2024 13:24:22 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] io_uring: switch deferred task_work to an
 io_wq_work_list
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240326184615.458820-1-axboe@kernel.dk>
 <20240326184615.458820-3-axboe@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240326184615.458820-3-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/26/24 18:42, Jens Axboe wrote:
> Lockless lists may be handy for some things, but they mean that items
> are in the reverse order as we can only add to the head of the list.
> That in turn means that iterating items on the list needs to reverse it
> first, if it's sensitive to ordering between items on the list.
> 
> Switch the DEFER_TASKRUN work list from an llist to a normal
> io_wq_work_list, and protect it with a lock. Then we can get rid of the
> manual reversing of the list when running it, which takes considerable
> cycles particularly for bursty task_work additions.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   include/linux/io_uring_types.h |  11 ++--
>   io_uring/io_uring.c            | 117 ++++++++++++---------------------
>   io_uring/io_uring.h            |   4 +-
>   3 files changed, 51 insertions(+), 81 deletions(-)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index aeb4639785b5..e51bf15196e4 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -329,7 +329,9 @@ struct io_ring_ctx {
>   	 * regularly bounce b/w CPUs.

...

> -static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
> +static inline void io_req_local_work_add(struct io_kiocb *req, unsigned tw_flags)
>   {
>   	struct io_ring_ctx *ctx = req->ctx;
> -	unsigned nr_wait, nr_tw, nr_tw_prev;
> -	struct llist_node *head;
> +	unsigned nr_wait, nr_tw;
> +	unsigned long flags;
>   
>   	/* See comment above IO_CQ_WAKE_INIT */
>   	BUILD_BUG_ON(IO_CQ_WAKE_FORCE <= IORING_MAX_CQ_ENTRIES);
>   
>   	/*
> -	 * We don't know how many reuqests is there in the link and whether
> +	 * We don't know how many requests is there in the link and whether
>   	 * they can even be queued lazily, fall back to non-lazy.
>   	 */
>   	if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK))
> -		flags &= ~IOU_F_TWQ_LAZY_WAKE;
> -
> -	head = READ_ONCE(ctx->work_llist.first);
> -	do {
> -		nr_tw_prev = 0;
> -		if (head) {
> -			struct io_kiocb *first_req = container_of(head,
> -							struct io_kiocb,
> -							io_task_work.node);
> -			/*
> -			 * Might be executed at any moment, rely on
> -			 * SLAB_TYPESAFE_BY_RCU to keep it alive.
> -			 */
> -			nr_tw_prev = READ_ONCE(first_req->nr_tw);
> -		}
> -
> -		/*
> -		 * Theoretically, it can overflow, but that's fine as one of
> -		 * previous adds should've tried to wake the task.
> -		 */
> -		nr_tw = nr_tw_prev + 1;
> -		if (!(flags & IOU_F_TWQ_LAZY_WAKE))
> -			nr_tw = IO_CQ_WAKE_FORCE;

Aren't you just killing the entire IOU_F_TWQ_LAZY_WAKE handling?
It's assigned to IO_CQ_WAKE_FORCE so that it passes the check
before wake_up below.

> +		tw_flags &= ~IOU_F_TWQ_LAZY_WAKE;
>   
> -		req->nr_tw = nr_tw;
> -		req->io_task_work.node.next = head;
> -	} while (!try_cmpxchg(&ctx->work_llist.first, &head,
> -			      &req->io_task_work.node));
> +	spin_lock_irqsave(&ctx->work_lock, flags);
> +	wq_list_add_tail(&req->io_task_work.node, &ctx->work_list);
> +	nr_tw = ++ctx->work_items;
> +	spin_unlock_irqrestore(&ctx->work_lock, flags);

smp_mb(), see the comment below, and fwiw "_after_atomic" would not
work.

>   	/*
>   	 * cmpxchg implies a full barrier, which pairs with the barrier
> @@ -1289,7 +1254,7 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
>   	 * is similar to the wait/wawke task state sync.
>   	 */
>   
> -	if (!head) {
> +	if (nr_tw == 1) {
>   		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
>   			atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
>   		if (ctx->has_evfd)
> @@ -1297,13 +1262,8 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
>   	}
>   
>   	nr_wait = atomic_read(&ctx->cq_wait_nr);
> -	/* not enough or no one is waiting */
> -	if (nr_tw < nr_wait)
> -		return;
> -	/* the previous add has already woken it up */
> -	if (nr_tw_prev >= nr_wait)
> -		return;
> -	wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
> +	if (nr_tw >= nr_wait)
> +		wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);

IIUC, you're removing a very important optimisation, and I
don't understand why'd you do that. It was waking up only when
it's changing from "don't need to wake" to "have to be woken up",
just once per splicing the list on the waiting side.

It seems like this one will keep pounding with wake_up_state for
every single tw queued after @nr_wait, which quite often just 1.

-- 
Pavel Begunkov

