Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF754A876D
	for <lists+io-uring@lfdr.de>; Thu,  3 Feb 2022 16:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239660AbiBCPOy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Feb 2022 10:14:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238577AbiBCPOx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Feb 2022 10:14:53 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B74CC061714
        for <io-uring@vger.kernel.org>; Thu,  3 Feb 2022 07:14:53 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id k18so5635734wrg.11
        for <io-uring@vger.kernel.org>; Thu, 03 Feb 2022 07:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UE8k4ksMkfpQmw8N4M0MAdkk9AYUqnrJAa0N8q0DE/c=;
        b=KuYeENw34SACMMoELDKvViBvZZ4ByrqGto2LAwRxS0w958nM8Y7oEPSIrxHdtO2F8a
         F3sLroAWFmczH06yu20lTxyvuv55ycnmm71PrrBPYLlB9VaDExavJSUuhHnKaI857WZe
         P28kgxz2WkzpsTkQXvqqeSLvEGlhlynuSPax+En6FbNkEhM9w4NfObY/6jqw17U6/Ff5
         eWaJyHtDZmapP+eGRP/gsL1bM1cLeyAt+9zF+0j0+wJdeAknlui/19uyppJGGD8qkhi1
         k/g8+GJZmOdOeiStATTrZIH4utlq6Xa4MKsjwUgTeVkWD2pkve+En7fkwxmdZM71dBgU
         +R2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UE8k4ksMkfpQmw8N4M0MAdkk9AYUqnrJAa0N8q0DE/c=;
        b=S0hCvHm0g+2S1nZH76+uvecWBbbYUpOXuCU/9+b/8aeIuJ5x/BB2i4IyXFqwzNtax7
         Ag75d2Li49pMvUt3N2m5OQhoLurrbItCh325lr44TZDMtVrgpZ9w4PJyE4YsN6PM7zp2
         u0I7z6pJ1W0HMAeE1Me1ONYkWLkAQjsodjzDHIQ62M9ocfxZWAewKccTj1P1OkdIauOg
         KSLQDpbYEGGAdgqjxTWASEypk/1WxgVYlAOlM0UrLmaCOtAS164gBpMWpcp2HnmnYbCu
         CxPtacbnT91LBoFtLIM+Mh+sK0KyDZrnIwOBVt5lfkark4ISIBXcv6MystWBf3Ul4epk
         gkbQ==
X-Gm-Message-State: AOAM532/Og+0VOnBVACZYqfuXP36yxQ7ehlMWG5JQyLkwFYUmc7IpJsN
        aHux2nxLSfa3LIdRSDfQcamxEcPva9DvaQ==
X-Google-Smtp-Source: ABdhPJxVYazkO3J7bgOJF08fM8MZlQEIj1qIvDK6JItULfyTX43vIi2gh2G4QO6ZK61TLBkdKN6gzQ==
X-Received: by 2002:a5d:5258:: with SMTP id k24mr28787479wrc.231.1643901291773;
        Thu, 03 Feb 2022 07:14:51 -0800 (PST)
Received: from ?IPv6:2a02:6b6d:f804:0:28c2:5854:c832:e580? ([2a02:6b6d:f804:0:28c2:5854:c832:e580])
        by smtp.gmail.com with ESMTPSA id be11sm35261wmb.19.2022.02.03.07.14.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Feb 2022 07:14:51 -0800 (PST)
Subject: Re: [External] Re: [RFC] io_uring: avoid ring quiesce while
 registering/unregistering eventfd
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        asml.silence@gmail.com, linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com
References: <20220202155923.4117285-1-usama.arif@bytedance.com>
 <86ae792e-d138-112e-02bb-ab70e3c2a147@kernel.dk>
 <7df1059c-6151-29c8-9ed5-0bc0726c362d@kernel.dk>
From:   Usama Arif <usama.arif@bytedance.com>
Message-ID: <1494b8f0-2f48-0aa1-214c-a02bbc4b05eb@bytedance.com>
Date:   Thu, 3 Feb 2022 15:14:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <7df1059c-6151-29c8-9ed5-0bc0726c362d@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 02/02/2022 19:18, Jens Axboe wrote:
> On 2/2/22 9:57 AM, Jens Axboe wrote:
>> On 2/2/22 8:59 AM, Usama Arif wrote:
>>> Acquire completion_lock at the start of __io_uring_register before
>>> registering/unregistering eventfd and release it at the end. Hence
>>> all calls to io_cqring_ev_posted which adds to the eventfd counter
>>> will finish before acquiring the spin_lock in io_uring_register, and
>>> all new calls will wait till the eventfd is registered. This avoids
>>> ring quiesce which is much more expensive than acquiring the
>>> spin_lock.
>>>
>>> On the system tested with this patch, io_uring_reigster with
>>> IORING_REGISTER_EVENTFD takes less than 1ms, compared to 15ms before.
>>
>> This seems like optimizing for the wrong thing, so I've got a few
>> questions. Are you doing a lot of eventfd registrations (and
>> unregister) in your workload? Or is it just the initial pain of
>> registering one? In talking to Pavel, he suggested that RCU might be a
>> good use case here, and I think so too. That would still remove the
>> need to quiesce, and the posted side just needs a fairly cheap rcu
>> read lock/unlock around it.
> 
> Totally untested, but perhaps can serve as a starting point or
> inspiration.
>

Hi,

Thank you for the replies and comments. My usecase registers only one 
eventfd at the start.

Thanks a lot for the diff below, it was a really good starting point!
I have sent a couple of patches for review implementing the RCU way.
I think that the below diff might have some issues, so i have done some 
parts in a different way. Please have a look in the diff below where i 
think there might be issues like race conditions, and how the patches I 
sent resolve it.

I see that if we remove ring quiesce from the the above 3 opcodes, then 
only IORING_REGISTER_ENABLE_RINGS and IORING_REGISTER_RESTRICTIONS is 
left for ring quiesce. I just had a quick look at those, and from what i 
see we might not need to enter ring quiesce in 
IORING_REGISTER_ENABLE_RINGS as the ring is already disabled at that point?
And for IORING_REGISTER_RESTRICTIONS if we do a similar approach to 
IORING_REGISTER_EVENTFD, i.e. wrap ctx->restrictions inside an RCU 
protected data structure, use spin_lock to prevent multiple 
io_register_restrictions calls at the same time, and use read_rcu_lock 
in io_check_restriction, then we can remove ring quiesce from 
io_uring_register altogether?

My usecase only uses IORING_REGISTER_EVENTFD, but i think entering ring 
quiesce costs similar in other opcodes. If the above sounds reasonable, 
please let me know and i can send patches for removing ring quiesce for 
io_uring_register.

Thanks again!
Usama

> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 64c055421809..195752f4823f 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -329,6 +329,12 @@ struct io_submit_state {
>   	struct blk_plug		plug;
>   };
>   
> +struct io_ev_fd {
> +	struct eventfd_ctx	*cq_ev_fd;
> +	struct io_ring_ctx	*ctx;
> +	struct rcu_head		rcu;
> +};
> +
>   struct io_ring_ctx {
>   	/* const or read-mostly hot data */
>   	struct {
> @@ -412,7 +418,7 @@ struct io_ring_ctx {
>   	struct {
>   		unsigned		cached_cq_tail;
>   		unsigned		cq_entries;
> -		struct eventfd_ctx	*cq_ev_fd;
> +		struct io_ev_fd		*io_ev_fd;
>   		struct wait_queue_head	cq_wait;
>   		unsigned		cq_extra;
>   		atomic_t		cq_timeouts;
> @@ -1741,13 +1747,27 @@ static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
>   
>   static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
>   {
> -	if (likely(!ctx->cq_ev_fd))
> +	if (likely(!ctx->io_ev_fd))
>   		return false;
>   	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
>   		return false;
>   	return !ctx->eventfd_async || io_wq_current_is_worker();
>   }
>   
> +static void io_eventfd_signal(struct io_ring_ctx *ctx)
> +{
> +	struct io_ev_fd *ev_fd;
> +
> +	if (!io_should_trigger_evfd(ctx))
> +		return;
> +

As the above io_should_trigger_evfd is not part of rcu_read_lock in this 
diff, another thread at this point could unregister the eventfd1 that 
was checked in io_should_trigger_evfd call above and register another 
one (eventfd2). If execution switches back to the thread executing 
io_eventfd_signal after this the eventfd_signal below will be sent to 
eventfd2, which is not right. I think there might be other wrong 
scenarios that can happen over here as well.

What i have done to avoid this from happening is treat ctx->io_ev_fd as 
an RCU protected data structure in the entire file. Hence, the entire 
io_eventfd_signal is a read-side critical section and a single ev_fd is
rcu_dereferenced and used in io_should_trigger_evfd and eventfd_signal.


> +	rcu_read_lock();
> +	ev_fd = READ_ONCE(ctx->io_ev_fd);
> +	if (ev_fd)
> +		eventfd_signal(ev_fd->cq_ev_fd, 1);
> +	rcu_read_unlock();
> +}
> +
>   /*
>    * This should only get called when at least one event has been posted.
>    * Some applications rely on the eventfd notification count only changing
> @@ -1764,8 +1784,7 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
>   	 */
>   	if (wq_has_sleeper(&ctx->cq_wait))
>   		wake_up_all(&ctx->cq_wait);
> -	if (io_should_trigger_evfd(ctx))
> -		eventfd_signal(ctx->cq_ev_fd, 1);
> +	io_eventfd_signal(ctx);
>   }
>   
>   static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
> @@ -1777,8 +1796,7 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
>   		if (waitqueue_active(&ctx->cq_wait))
>   			wake_up_all(&ctx->cq_wait);
>   	}
> -	if (io_should_trigger_evfd(ctx))
> -		eventfd_signal(ctx->cq_ev_fd, 1);
> +	io_eventfd_signal(ctx);
>   }
>   
>   /* Returns true if there are no backlogged entries after the flush */
> @@ -9569,31 +9587,49 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
>   
>   static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg)
>   {
> +	struct io_ev_fd *ev_fd;
>   	__s32 __user *fds = arg;
>   	int fd;
>   
> -	if (ctx->cq_ev_fd)
> +	if (ctx->io_ev_fd)
>   		return -EBUSY;
>

You could have 2 threads call io_uring_register on the same ring at the 
same time, they could both pass the above check of ctx->io_ev_fd != NULL 
not existing and enter a race condition to assign ctx->io_ev_fd, i guess 
thats why locks are used for writes when using RCU, i have used 
ctx->ev_fd_lock in the patch i pushed for review. Also as ctx->io_ev_fd 
is RCU protected so accesses are only using 
rcu_dereference_protected/rcu_dereference/rcu_assign_poitner.


>   	if (copy_from_user(&fd, fds, sizeof(*fds)))
>   		return -EFAULT;
>   
> -	ctx->cq_ev_fd = eventfd_ctx_fdget(fd);
> -	if (IS_ERR(ctx->cq_ev_fd)) {
> -		int ret = PTR_ERR(ctx->cq_ev_fd);
> +	ev_fd = kmalloc(sizeof(*ev_fd), GFP_KERNEL);
> +	if (!ev_fd)
> +		return -ENOMEM;
> +
> +	ev_fd->cq_ev_fd = eventfd_ctx_fdget(fd);
> +	if (IS_ERR(ev_fd->cq_ev_fd)) {
> +		int ret = PTR_ERR(ev_fd->cq_ev_fd);
>   
> -		ctx->cq_ev_fd = NULL;
> +		kfree(ev_fd);
>   		return ret;
>   	}
>   
> +	ev_fd->ctx = ctx;
> +	WRITE_ONCE(ctx->io_ev_fd, ev_fd);
>   	return 0;
>   }
>   
> +static void io_eventfd_put(struct rcu_head *rcu)
> +{
> +	struct io_ev_fd *ev_fd = container_of(rcu, struct io_ev_fd, rcu);
> +	struct io_ring_ctx *ctx = ev_fd->ctx;
> +
> +	eventfd_ctx_put(ev_fd->cq_ev_fd);
> +	kfree(ev_fd);
> +	WRITE_ONCE(ctx->io_ev_fd, NULL);
> +}
> +
>   static int io_eventfd_unregister(struct io_ring_ctx *ctx)
>   {
> -	if (ctx->cq_ev_fd) {
> -		eventfd_ctx_put(ctx->cq_ev_fd);
> -		ctx->cq_ev_fd = NULL;
> +	struct io_ev_fd *ev_fd = ctx->io_ev_fd;
> +
> +	if (ev_fd) {
> +		call_rcu(&ev_fd->rcu, io_eventfd_put);
>   		return 0;
>   	}
>   
> @@ -9659,7 +9695,10 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
>   	if (ctx->rings)
>   		__io_cqring_overflow_flush(ctx, true);
>   	mutex_unlock(&ctx->uring_lock);
> -	io_eventfd_unregister(ctx);
> +	if (ctx->io_ev_fd) {
> +		eventfd_ctx_put(ctx->io_ev_fd->cq_ev_fd);
> +		kfree(ctx->io_ev_fd);
> +	}
>   	io_destroy_buffers(ctx);
>   	if (ctx->sq_creds)
>   		put_cred(ctx->sq_creds);
> @@ -11209,6 +11248,8 @@ static bool io_register_op_must_quiesce(int op)
>   	case IORING_UNREGISTER_IOWQ_AFF:
>   	case IORING_REGISTER_IOWQ_MAX_WORKERS:
>   	case IORING_REGISTER_MAP_BUFFERS:
> +	case IORING_REGISTER_EVENTFD:
> +	case IORING_UNREGISTER_EVENTFD:
>   		return false;
>   	default:
>   		return true;
> @@ -11423,7 +11464,7 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
>   	ret = __io_uring_register(ctx, opcode, arg, nr_args);
>   	mutex_unlock(&ctx->uring_lock);
>   	trace_io_uring_register(ctx, opcode, ctx->nr_user_files, ctx->nr_user_bufs,
> -							ctx->cq_ev_fd != NULL, ret);
> +							ctx->io_ev_fd != NULL, ret);
>   out_fput:
>   	fdput(f);
>   	return ret;
> 
