Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6724A914A
	for <lists+io-uring@lfdr.de>; Fri,  4 Feb 2022 00:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242401AbiBCXvK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 18:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbiBCXvJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 18:51:09 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CC9C061714;
        Thu,  3 Feb 2022 15:51:09 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id g18so7747710wrb.6;
        Thu, 03 Feb 2022 15:51:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cFvNszLfG0+0qKre9tbScLSSKrwdfrj78+DdDXq9mDI=;
        b=JqVTCCJq7KWz5f6HxIWSXG7e62uDfhZcj1Yz59rRzX0qkbRAzFKuRIlH75WpcNR4pj
         AJiXILlQWzpnn9PmkIG8ve8VrJlyuR7QcSCVWcn9aq4zTdxw7hpVQBhvrjDYHrgcAg7/
         D/5LvogMIzluPX0Q5vw2y3JpeNnSlp6LZKjeFZZVvtdH1L7ngMOidM9AYNAsYiaLaa7J
         +4l/+j3n9dJj0bUEsVgD7HUVjD8COgL6tnuqkiPfvmdTgbEKr9IXoJtKIV983U2QLDWG
         UTzPJTHlPXcnPv96yRJu3QXgd2yK9T3ZUa61MHJGXQP5YbRyIv9B2gONypxr4ESBQmk5
         oXUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cFvNszLfG0+0qKre9tbScLSSKrwdfrj78+DdDXq9mDI=;
        b=cKXls4yebt8cbd8kwBOUXsNrKftX5spPZgCvzzroMH0biOa3jaVYqZ9JeYPTErZi5d
         B4Yl64I7fi29h9Vt/XpPHcnd7AGYbNsANVYdfgh3SDrnsfx2MTLZI7V0xaQoUdbWYecA
         jfVwTuI6Npeuee7N5p5+2ukcWbVkwOe4CNAWtiHOHYZEqnwwU1rqKKcdkcP2T+dR4DIL
         Dya6pKVFDTdbj75MaT3AMl+JZdx54X3wvEN0sdruP5NAaVFxXqIGtArKVFFRiIutyS5X
         wOORF3yhly+Yx9zhUZ+KDpC6D/OLDD+/c4DxATymQncD7efZj4/w7EpCf98r+CYmCrei
         S7Dg==
X-Gm-Message-State: AOAM533ZNGf1qftdMDIqTx41NlzUWVd/XUgoOgDtDecMDqeL1jre2WxM
        EjhDyT+YXj3RKPTs6rKD5FA=
X-Google-Smtp-Source: ABdhPJw61InZ1aA5ZPF/4dX7pXw72KV1uZt17uGDN0qEMoG4lHGV/t9GugGdC9c+nyFYazP+N2lHQA==
X-Received: by 2002:a5d:4f08:: with SMTP id c8mr243365wru.710.1643932267674;
        Thu, 03 Feb 2022 15:51:07 -0800 (PST)
Received: from [192.168.8.198] ([85.255.232.204])
        by smtp.gmail.com with ESMTPSA id f6sm245084wrj.26.2022.02.03.15.51.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 15:51:07 -0800 (PST)
Message-ID: <03ee875d-03fd-d538-7a03-7cbde98d5b78@gmail.com>
Date:   Thu, 3 Feb 2022 23:46:03 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v5 2/4] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
Content-Language: en-US
To:     Usama Arif <usama.arif@bytedance.com>, io-uring@vger.kernel.org,
        axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220203233439.845408-1-usama.arif@bytedance.com>
 <20220203233439.845408-3-usama.arif@bytedance.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20220203233439.845408-3-usama.arif@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/22 23:34, Usama Arif wrote:
> This is done by creating a new RCU data structure (io_ev_fd) as part of
> io_ring_ctx that holds the eventfd_ctx.
> 
> The function io_eventfd_signal is executed under rcu_read_lock with a
> single rcu_dereference to io_ev_fd so that if another thread unregisters
> the eventfd while io_eventfd_signal is still being executed, the
> eventfd_signal for which io_eventfd_signal was called completes
> successfully.
> 
> The process of registering/unregistering eventfd is done under a lock
> so multiple threads don't enter a race condition while
> registering/unregistering eventfd.
> 
> With the above approach ring quiesce can be avoided which is much more
> expensive then using RCU lock. On the system tested, io_uring_reigster with
> IORING_REGISTER_EVENTFD takes less than 1ms with RCU lock, compared to 15ms
> before with ring quiesce.
> 
> Signed-off-by: Usama Arif <usama.arif@bytedance.com>
> ---
>   fs/io_uring.c | 116 ++++++++++++++++++++++++++++++++++++++++----------
>   1 file changed, 93 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 21531609a9c6..51602bddb9a8 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -326,6 +326,13 @@ struct io_submit_state {
>   	struct blk_plug		plug;
>   };
>   
> +struct io_ev_fd {
> +	struct eventfd_ctx	*cq_ev_fd;
> +	struct io_ring_ctx	*ctx;
> +	struct rcu_head		rcu;
> +	bool 			unregistering;
> +};
> +
>   struct io_ring_ctx {
>   	/* const or read-mostly hot data */
>   	struct {
> @@ -399,7 +406,8 @@ struct io_ring_ctx {
>   	struct {
>   		unsigned		cached_cq_tail;
>   		unsigned		cq_entries;
> -		struct eventfd_ctx	*cq_ev_fd;
> +		struct io_ev_fd	__rcu	*io_ev_fd;
> +		struct mutex		ev_fd_lock;
>   		struct wait_queue_head	cq_wait;
>   		unsigned		cq_extra;
>   		atomic_t		cq_timeouts;
> @@ -1448,6 +1456,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>   	xa_init_flags(&ctx->io_buffers, XA_FLAGS_ALLOC1);
>   	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
>   	mutex_init(&ctx->uring_lock);
> +	mutex_init(&ctx->ev_fd_lock);
>   	init_waitqueue_head(&ctx->cq_wait);
>   	spin_lock_init(&ctx->completion_lock);
>   	spin_lock_init(&ctx->timeout_lock);
> @@ -1726,13 +1735,32 @@ static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
>   	return &rings->cqes[tail & mask];
>   }
>   
> -static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
> +static void io_eventfd_signal(struct io_ring_ctx *ctx)
>   {
> -	if (likely(!ctx->cq_ev_fd))
> -		return false;
> +	struct io_ev_fd *ev_fd;
> +
> +	/* Return quickly if ctx->io_ev_fd doesn't exist */
> +	if (likely(!rcu_dereference_raw(ctx->io_ev_fd)))
> +		return;
> +
> +	rcu_read_lock();
> +	/* rcu_dereference ctx->io_ev_fd once and use it for both for checking and eventfd_signal */
> +	ev_fd = rcu_dereference(ctx->io_ev_fd);
> +
> +	/*
> +	 * Check again if ev_fd exists incase an io_eventfd_unregister call completed between
> +	 * the NULL check of ctx->io_ev_fd at the start of the function and rcu_read_lock.
> +	 */
> +	if (unlikely(!ev_fd))
> +		goto out;
>   	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
> -		return false;
> -	return !ctx->eventfd_async || io_wq_current_is_worker();
> +		goto out;
> +
> +	if (!ctx->eventfd_async || io_wq_current_is_worker())
> +		eventfd_signal(ev_fd->cq_ev_fd, 1);
> +
> +out:
> +	rcu_read_unlock();
>   }
>   
>   /*
> @@ -1751,8 +1779,7 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
>   	 */
>   	if (wq_has_sleeper(&ctx->cq_wait))
>   		wake_up_all(&ctx->cq_wait);
> -	if (io_should_trigger_evfd(ctx))
> -		eventfd_signal(ctx->cq_ev_fd, 1);
> +	io_eventfd_signal(ctx);
>   }
>   
>   static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
> @@ -1764,8 +1791,7 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
>   		if (waitqueue_active(&ctx->cq_wait))
>   			wake_up_all(&ctx->cq_wait);
>   	}
> -	if (io_should_trigger_evfd(ctx))
> -		eventfd_signal(ctx->cq_ev_fd, 1);
> +	io_eventfd_signal(ctx);
>   }
>   
>   /* Returns true if there are no backlogged entries after the flush */
> @@ -9353,34 +9379,76 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
>   
>   static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
>   {
> +	struct io_ev_fd *ev_fd;
>   	__s32 __user *fds = arg;
> -	int fd;
> +	int fd, ret;
>   
> -	if (ctx->cq_ev_fd)
> -		return -EBUSY;
> +	mutex_lock(&ctx->ev_fd_lock);
> +	ret = -EBUSY;
> +	ev_fd = rcu_dereference_protected(ctx->io_ev_fd, lockdep_is_held(&ctx->ev_fd_lock));
> +	if (ev_fd) {
> +		/*
> +		 * If ev_fd exists, there are 2 possibilities:
> +		 * - The rcu_callback to io_eventfd_put hasn't finished while unregistering
> +		 * (hence ev_fd->unregistering is true) and io_eventfd_register
> +		 * can continue and overwrite ctx->io_ev_fd with the new eventfd.
> +		 * - Or io_eventfd_register has been called on an io_uring that has
> +		 * already registered a valid eventfd in which case return -EBUSY.
> +		 */
> +		if(!ev_fd->unregistering)
> +			goto out;
> +	}
>   
> +	ret = -EFAULT;
>   	if (copy_from_user(&fd, fds, sizeof(*fds)))
> -		return -EFAULT;
> +		goto out;
>   
> -	ctx->cq_ev_fd = eventfd_ctx_fdget(fd);
> -	if (IS_ERR(ctx->cq_ev_fd)) {
> -		int ret = PTR_ERR(ctx->cq_ev_fd);
> +	ret = -ENOMEM;
> +	ev_fd = kmalloc(sizeof(*ev_fd), GFP_KERNEL);
> +	if (!ev_fd)
> +		goto out;
>   
> -		ctx->cq_ev_fd = NULL;
> -		return ret;
> +	ev_fd->cq_ev_fd = eventfd_ctx_fdget(fd);
> +	if (IS_ERR(ev_fd->cq_ev_fd)) {
> +		ret = PTR_ERR(ev_fd->cq_ev_fd);
> +		kfree(ev_fd);
> +		goto out;
>   	}
> +	ev_fd->ctx = ctx;
> +	ev_fd->unregistering = false;
>   
> -	return 0;
> +	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
> +	ret = 0;
> +
> +out:
> +	mutex_unlock(&ctx->ev_fd_lock);
> +	return ret;
> +}
> +
> +static void io_eventfd_put(struct rcu_head *rcu)
> +{
> +	struct io_ev_fd *ev_fd = container_of(rcu, struct io_ev_fd, rcu);
> +	struct io_ring_ctx *ctx = ev_fd->ctx;
> +
> +	eventfd_ctx_put(ev_fd->cq_ev_fd);
> +	kfree(ev_fd);
> +	rcu_assign_pointer(ctx->io_ev_fd, NULL);
>   }

Emm, it happens after the grace period, so you have a gap where a
request may read a freed eventfd... What I think you wanted to do
is more like below:


io_eventfd_put() {
	evfd = ...;
	eventfd_ctx_put(evfd->evfd);
	kfree(io_ev_fd);
}

register() {
	mutex_lock();
	ev_fd = rcu_deref();
	if (ev_fd) {
		rcu_assign_pointer(ctx->evfd, NULL);
		call_rcu(&ev_fd->evfd, io_eventfd_put);
	}
	mutex_unlock();
}


Note, there's no need in ->unregistering. I also doubt you need
->ev_fd_lock, how about just using already taken ->uring_lock?

-- 
Pavel Begunkov
