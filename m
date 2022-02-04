Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB11D4A9180
	for <lists+io-uring@lfdr.de>; Fri,  4 Feb 2022 01:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356009AbiBDAM3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 19:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348910AbiBDAM3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 19:12:29 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F39C06173B
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 16:12:29 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id i186so3667998pfe.0
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 16:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Jf+oIISZq+aVP6srI/KyAAoWiVJ1pdZ+KSr0jmsAlz4=;
        b=b4V+oOdBmY45jcD9ByQ9CTdu4qkoU4MWnLANubIcxJL24cYOO6LmKjVDd0EMnVgzFQ
         EgBQ+Rqc8Wtso9cIJJz87eLSlBhwdQ+KytGADjwwR8fHHZrVI07Z0wjlOHUMxrE3nqC8
         W1Yp3Pcxu63miptE5XaXjWjCWKeV4TuVeAgrqy0aWYY2CVOJGkov7VBbDUoy7x5CNih/
         g7o/PtNjzZrnMosZrNicrrsfBMzBAxwj4U4XzNQWTDqHlsEdlh/BpyFWjGP4s0bhp4Yi
         WfCBQ1RRUV3roYLpHSr1kPVcX8xwtlzo7Di3A+IE9maDwFKoL8hrYBOjdzewWG1H0e1z
         44GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jf+oIISZq+aVP6srI/KyAAoWiVJ1pdZ+KSr0jmsAlz4=;
        b=0KXbPXrGV9wuHesFjFMh3oVhDIiH1+dwkI5xahN1x/e7D221tyLGBkZdzeOyTK5/Gu
         LrzUAj9ac0199g3BfoZRHFC1QKqfSRVEteE+EkK7Z9gbAohPdh7H5u6Uxegoi7NTFqxq
         WRQVZfbaRuAl+SshryI4cSDHLGb4gZxuwWpgc003ol6RyT/qTSDfVsgLEXT94Y9GbSde
         Y2ycgxIjwdib5gJBzrBkg+Nf53cNJE52EmQ9RMRjuoXC0txn8+WlCUrzJ7mZEuVRi6Wh
         4oVglhsJOyK5N1M96UJSfqYFJRwsXl96WVlFv9n/6qUFLAsGeL2N4SmhKmgK87RySHIJ
         3Mog==
X-Gm-Message-State: AOAM530V8X11Fqfj1rl3nGbCJjFrAGJwaHRdHcoR8gY0l3jVuUdk5/lS
        v9VEFUXmmgd3iI6wvroUHqfygQ==
X-Google-Smtp-Source: ABdhPJzfzGBK8opUJ7tv2QNthYTkg5XkDJEQ6w4P2CBQNO9sPg7d/ZFu8DpZJjagQNeNOEP6Ee0p3g==
X-Received: by 2002:aa7:9f1b:: with SMTP id g27mr624680pfr.30.1643933548756;
        Thu, 03 Feb 2022 16:12:28 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id p1sm165439pfh.98.2022.02.03.16.12.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 16:12:28 -0800 (PST)
Subject: Re: [PATCH v5 2/4] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Usama Arif <usama.arif@bytedance.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220203233439.845408-1-usama.arif@bytedance.com>
 <20220203233439.845408-3-usama.arif@bytedance.com>
 <03ee875d-03fd-d538-7a03-7cbde98d5b78@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <525081cc-e436-b871-77d2-75ae141148cc@kernel.dk>
Date:   Thu, 3 Feb 2022 17:12:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <03ee875d-03fd-d538-7a03-7cbde98d5b78@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/3/22 4:46 PM, Pavel Begunkov wrote:
> On 2/3/22 23:34, Usama Arif wrote:
>> This is done by creating a new RCU data structure (io_ev_fd) as part of
>> io_ring_ctx that holds the eventfd_ctx.
>>
>> The function io_eventfd_signal is executed under rcu_read_lock with a
>> single rcu_dereference to io_ev_fd so that if another thread unregisters
>> the eventfd while io_eventfd_signal is still being executed, the
>> eventfd_signal for which io_eventfd_signal was called completes
>> successfully.
>>
>> The process of registering/unregistering eventfd is done under a lock
>> so multiple threads don't enter a race condition while
>> registering/unregistering eventfd.
>>
>> With the above approach ring quiesce can be avoided which is much more
>> expensive then using RCU lock. On the system tested, io_uring_reigster with
>> IORING_REGISTER_EVENTFD takes less than 1ms with RCU lock, compared to 15ms
>> before with ring quiesce.
>>
>> Signed-off-by: Usama Arif <usama.arif@bytedance.com>
>> ---
>>   fs/io_uring.c | 116 ++++++++++++++++++++++++++++++++++++++++----------
>>   1 file changed, 93 insertions(+), 23 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 21531609a9c6..51602bddb9a8 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -326,6 +326,13 @@ struct io_submit_state {
>>   	struct blk_plug		plug;
>>   };
>>   
>> +struct io_ev_fd {
>> +	struct eventfd_ctx	*cq_ev_fd;
>> +	struct io_ring_ctx	*ctx;
>> +	struct rcu_head		rcu;
>> +	bool 			unregistering;
>> +};
>> +
>>   struct io_ring_ctx {
>>   	/* const or read-mostly hot data */
>>   	struct {
>> @@ -399,7 +406,8 @@ struct io_ring_ctx {
>>   	struct {
>>   		unsigned		cached_cq_tail;
>>   		unsigned		cq_entries;
>> -		struct eventfd_ctx	*cq_ev_fd;
>> +		struct io_ev_fd	__rcu	*io_ev_fd;
>> +		struct mutex		ev_fd_lock;
>>   		struct wait_queue_head	cq_wait;
>>   		unsigned		cq_extra;
>>   		atomic_t		cq_timeouts;
>> @@ -1448,6 +1456,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>>   	xa_init_flags(&ctx->io_buffers, XA_FLAGS_ALLOC1);
>>   	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
>>   	mutex_init(&ctx->uring_lock);
>> +	mutex_init(&ctx->ev_fd_lock);
>>   	init_waitqueue_head(&ctx->cq_wait);
>>   	spin_lock_init(&ctx->completion_lock);
>>   	spin_lock_init(&ctx->timeout_lock);
>> @@ -1726,13 +1735,32 @@ static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
>>   	return &rings->cqes[tail & mask];
>>   }
>>   
>> -static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
>> +static void io_eventfd_signal(struct io_ring_ctx *ctx)
>>   {
>> -	if (likely(!ctx->cq_ev_fd))
>> -		return false;
>> +	struct io_ev_fd *ev_fd;
>> +
>> +	/* Return quickly if ctx->io_ev_fd doesn't exist */
>> +	if (likely(!rcu_dereference_raw(ctx->io_ev_fd)))
>> +		return;
>> +
>> +	rcu_read_lock();
>> +	/* rcu_dereference ctx->io_ev_fd once and use it for both for checking and eventfd_signal */
>> +	ev_fd = rcu_dereference(ctx->io_ev_fd);
>> +
>> +	/*
>> +	 * Check again if ev_fd exists incase an io_eventfd_unregister call completed between
>> +	 * the NULL check of ctx->io_ev_fd at the start of the function and rcu_read_lock.
>> +	 */
>> +	if (unlikely(!ev_fd))
>> +		goto out;
>>   	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
>> -		return false;
>> -	return !ctx->eventfd_async || io_wq_current_is_worker();
>> +		goto out;
>> +
>> +	if (!ctx->eventfd_async || io_wq_current_is_worker())
>> +		eventfd_signal(ev_fd->cq_ev_fd, 1);
>> +
>> +out:
>> +	rcu_read_unlock();
>>   }
>>   
>>   /*
>> @@ -1751,8 +1779,7 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
>>   	 */
>>   	if (wq_has_sleeper(&ctx->cq_wait))
>>   		wake_up_all(&ctx->cq_wait);
>> -	if (io_should_trigger_evfd(ctx))
>> -		eventfd_signal(ctx->cq_ev_fd, 1);
>> +	io_eventfd_signal(ctx);
>>   }
>>   
>>   static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
>> @@ -1764,8 +1791,7 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
>>   		if (waitqueue_active(&ctx->cq_wait))
>>   			wake_up_all(&ctx->cq_wait);
>>   	}
>> -	if (io_should_trigger_evfd(ctx))
>> -		eventfd_signal(ctx->cq_ev_fd, 1);
>> +	io_eventfd_signal(ctx);
>>   }
>>   
>>   /* Returns true if there are no backlogged entries after the flush */
>> @@ -9353,34 +9379,76 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
>>   
>>   static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
>>   {
>> +	struct io_ev_fd *ev_fd;
>>   	__s32 __user *fds = arg;
>> -	int fd;
>> +	int fd, ret;
>>   
>> -	if (ctx->cq_ev_fd)
>> -		return -EBUSY;
>> +	mutex_lock(&ctx->ev_fd_lock);
>> +	ret = -EBUSY;
>> +	ev_fd = rcu_dereference_protected(ctx->io_ev_fd, lockdep_is_held(&ctx->ev_fd_lock));
>> +	if (ev_fd) {
>> +		/*
>> +		 * If ev_fd exists, there are 2 possibilities:
>> +		 * - The rcu_callback to io_eventfd_put hasn't finished while unregistering
>> +		 * (hence ev_fd->unregistering is true) and io_eventfd_register
>> +		 * can continue and overwrite ctx->io_ev_fd with the new eventfd.
>> +		 * - Or io_eventfd_register has been called on an io_uring that has
>> +		 * already registered a valid eventfd in which case return -EBUSY.
>> +		 */
>> +		if(!ev_fd->unregistering)
>> +			goto out;
>> +	}
>>   
>> +	ret = -EFAULT;
>>   	if (copy_from_user(&fd, fds, sizeof(*fds)))
>> -		return -EFAULT;
>> +		goto out;
>>   
>> -	ctx->cq_ev_fd = eventfd_ctx_fdget(fd);
>> -	if (IS_ERR(ctx->cq_ev_fd)) {
>> -		int ret = PTR_ERR(ctx->cq_ev_fd);
>> +	ret = -ENOMEM;
>> +	ev_fd = kmalloc(sizeof(*ev_fd), GFP_KERNEL);
>> +	if (!ev_fd)
>> +		goto out;
>>   
>> -		ctx->cq_ev_fd = NULL;
>> -		return ret;
>> +	ev_fd->cq_ev_fd = eventfd_ctx_fdget(fd);
>> +	if (IS_ERR(ev_fd->cq_ev_fd)) {
>> +		ret = PTR_ERR(ev_fd->cq_ev_fd);
>> +		kfree(ev_fd);
>> +		goto out;
>>   	}
>> +	ev_fd->ctx = ctx;
>> +	ev_fd->unregistering = false;
>>   
>> -	return 0;
>> +	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
>> +	ret = 0;
>> +
>> +out:
>> +	mutex_unlock(&ctx->ev_fd_lock);
>> +	return ret;
>> +}
>> +
>> +static void io_eventfd_put(struct rcu_head *rcu)
>> +{
>> +	struct io_ev_fd *ev_fd = container_of(rcu, struct io_ev_fd, rcu);
>> +	struct io_ring_ctx *ctx = ev_fd->ctx;
>> +
>> +	eventfd_ctx_put(ev_fd->cq_ev_fd);
>> +	kfree(ev_fd);
>> +	rcu_assign_pointer(ctx->io_ev_fd, NULL);
>>   }
> 
> Emm, it happens after the grace period, so you have a gap where a
> request may read a freed eventfd... What I think you wanted to do
> is more like below:
> 
> 
> io_eventfd_put() {
> 	evfd = ...;
> 	eventfd_ctx_put(evfd->evfd);
> 	kfree(io_ev_fd);
> }
> 
> register() {
> 	mutex_lock();
> 	ev_fd = rcu_deref();
> 	if (ev_fd) {
> 		rcu_assign_pointer(ctx->evfd, NULL);
> 		call_rcu(&ev_fd->evfd, io_eventfd_put);
> 	}
> 	mutex_unlock();
> }
> 
> 
> Note, there's no need in ->unregistering. I also doubt you need
> ->ev_fd_lock, how about just using already taken ->uring_lock?

Agree on both, for this scheme to work it's also critical that we assign
evfd = NULL before call_rcu() is done, not in the callback. Ditto on the
lock, the register side is under uring_lock anyway, so this one doesn't
add anything.


-- 
Jens Axboe

