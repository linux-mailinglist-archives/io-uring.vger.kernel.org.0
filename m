Return-Path: <io-uring+bounces-2282-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1577190F1FE
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 17:22:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7BE59B20A88
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 15:22:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15F181EEF7;
	Wed, 19 Jun 2024 15:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VT/oUT09"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24A01802E;
	Wed, 19 Jun 2024 15:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718810537; cv=none; b=LvbV3wFNDDe0nsMfEOEgsowr/kimm8AQnvjlRjvqJ9Lb7ISuJOQRDDY2RwSyg3jq2zC3zD8ton1CiGrea/bq2OL7VrkaQcYsYn28y4imAyS38gG2Ut7LCzOv9eEwBiA0L0JiNHe0uDsUMuasJW4Q8LlyHQxxltDnDUH/M8yKO0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718810537; c=relaxed/simple;
	bh=MGKmSIw7EsYVNabyzicNT4POfLFnZAdLFhQGQsw5tVU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FY3vQuuZu2WFETMqCKj7r5+mHdzVAQeJgHkUo9gQtfj5axeXN60ERqW8Wio6NQOAMxZUxDL93hoBSE+6a6pajI3otrUeGc5ai9+hNLb+GueG52jNnL6Mvd9O9terqkrcMmLtKwoltbIkWN58Lm47Nc+q26b40coyWoxsW7wFQcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VT/oUT09; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a6ef793f4b8so686217866b.1;
        Wed, 19 Jun 2024 08:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718810533; x=1719415333; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ywdo7DX3PIPmahM/CSRsqNOz0oRxENLDMIF01HBcJoY=;
        b=VT/oUT09IHf5jEw61SIo7CwtTvA6WBPb/u9wppWsuFALvUOvd8Xi93+ZZE6G0EYAY3
         Pbj4qCxY+rmFleaCXYC6xj0oivp2Ewm+/jfd99JczzK2UzZk+ng3VfmM7JHiwVfIW1Vc
         6TwU4mF3ms9d8dF9ExEdaQ+AiwiUVctLtYPZ/L5gI0U3jrHueI9NV3CPIwVSrywDFA1d
         MrDBIp6EhIk1FszH1h4aQwIjLyuIVhUaHm/k2PUghnxVK2Cyd8t/wvFUoPHycc0XjBoo
         IppvPF48VJYwa6yx/2gouJeWajHxD4k7+0uD5+9U1DudyEKtS2t59Z5CBnQZ9S0eLGpq
         27MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718810533; x=1719415333;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ywdo7DX3PIPmahM/CSRsqNOz0oRxENLDMIF01HBcJoY=;
        b=giK0dc96QwrIAo7imK3WsZlknvuNgVv3OEDlpLPksLE8dCpG2o6xmn+PgjGSqE8LDm
         7WZ/P/biiGwFLqc9VKJjEebrvlIrX0zRPrnaRyyWT2UzQm59gDzB1KeTrEIewrPdeHx5
         MZb7lRwDixaZQumS1rKUoh7t2wYzuOThTJDGQJyx8SFm44BwqQ86jB5VSXJG+dWfgYTc
         xrFKEQLBXLzUknBM+u9lHlbYnIkM63QE6by1ASgJ8fxUD3/DEto9mYx31b+m9YzWC+UV
         aHnp1463z2k2u+0p6quGRQQyw/0iZHtTbQ8Jbo68s6OiiktRyhl8Ays3qTskwb2LV1jL
         XPEg==
X-Forwarded-Encrypted: i=1; AJvYcCWxr+/vFoXXbFukL5Vp8KVWTYtkexaLOueqtlZPhP/CcxYZnI+H+4kPn6G5zNyL68irJSYZd+SpGlyHaocAMQDIDw3Cwqc7tFZvTwZD
X-Gm-Message-State: AOJu0Ywy1uXWOPk10KzcPAKbyCQ/vGAl7MCEOWFL3rGMjcEFNqY1xCb5
	M8Yq8gmCcuDbZXxw9tZR2yr9jlaEcqzQWP5q7GvJjyAuDHhHyQm4
X-Google-Smtp-Source: AGHT+IEDQI/Eq6fVlcVAiMR9XjPDWCL2BcEu3Q3AqoDE+3RPn0H41VIyRyiPW5Wth0AmBDI9dd3mQg==
X-Received: by 2002:a17:907:c5c7:b0:a6f:b5ff:a6eb with SMTP id a640c23a62f3a-a6fb5ffaafemr110153766b.24.1718810532889;
        Wed, 19 Jun 2024 08:22:12 -0700 (PDT)
Received: from [192.168.42.75] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f56ed0f2asm677483266b.131.2024.06.19.08.22.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Jun 2024 08:22:12 -0700 (PDT)
Message-ID: <c6b297ae-b1a9-4500-966e-9a0ea192d46b@gmail.com>
Date: Wed, 19 Jun 2024 16:22:17 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] Subject: io_uring: releasing CPU resources when
 polling
To: hexue <xue01.he@samsung.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CGME20240619071833epcas5p274ddb249a75e4b3006b48d1378071923@epcas5p2.samsung.com>
 <20240619071826.1553543-1-xue01.he@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240619071826.1553543-1-xue01.he@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/19/24 08:18, hexue wrote:
> io_uring use polling mode could improve the IO performence, but it will
> spend 100% of CPU resources to do polling.
> 
> This set a signal "IORING_SETUP_HY_POLL" to application, aim to provide
> a interface for user to enable a new hybrid polling at io_uring level.
> 
> A new hybrid poll is implemented on the io_uring layer. Once IO issued,
> it will not polling immediately, but block first and re-run before IO
> complete, then poll to reap IO. This poll function could keep polling
> high performance and free up some CPU resources.
> 
> we considered about complex situations, such as multi-concurrency,
> different processing speed of multi-disk, etc.
> 
> Test results:
> set 8 poll queues, fio-3.35, Gen5 SSD, 8 CPU VM
> 
> per CPU utilization:
>      read(128k, QD64, 1Job)     53%   write(128k, QD64, 1Job)     45%
>      randread(4k, QD64, 16Job)  70%   randwrite(4k, QD64, 16Job)  16%
> performance reduction:
>      read  0.92%     write  0.92%    randread  1.61%    randwrite  0%

What are numbers for normal / non-IOPOLL runs?



> --
> 
> changes since v4:
> - Rewrote the commit
> - Update the test results
> - Reorganized the code basd on 6.11
> 
> changes since v3:
> - Simplified the commit
> - Add some comments on code
> 
> changes since v2:
> - Modified some formatting errors
> - Move judgement to poll path
> 
> changes since v1:
> - Extend hybrid poll to async polled io
> 
> Signed-off-by: hexue <xue01.he@samsung.com>
> ---
>   include/linux/io_uring_types.h |  14 ++++
>   include/uapi/linux/io_uring.h  |   1 +
>   io_uring/io_uring.c            |   4 +-
>   io_uring/io_uring.h            |   3 +
>   io_uring/rw.c                  | 115 ++++++++++++++++++++++++++++++++-
>   5 files changed, 135 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 91224bbcfa73..8eab99c4122e 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -226,6 +226,11 @@ struct io_alloc_cache {
>   	size_t			elem_size;
>   };
>   
> +struct iopoll_info {
> +	long		last_runtime;
> +	long		last_irqtime;
> +};

Please follow the naming convention for all types you
add: "io_...".

> +
>   struct io_ring_ctx {
>   	/* const or read-mostly hot data */
>   	struct {
> @@ -428,6 +433,7 @@ struct io_ring_ctx {
>   	unsigned short			n_sqe_pages;
>   	struct page			**ring_pages;
>   	struct page			**sqe_pages;
> +	struct xarray		poll_array;
>   };
>   
>   struct io_tw_state {
> @@ -591,6 +597,12 @@ static inline void io_kiocb_cmd_sz_check(size_t cmd_sz)
>   )
>   #define cmd_to_io_kiocb(ptr)	((struct io_kiocb *) ptr)
>   
> +struct hy_poll_time {
> +	int		poll_state;
> +	struct timespec64		iopoll_start;
> +	struct timespec64		iopoll_end;

why not u64 and ktime_get_ns()?

> +};
> +
>   struct io_kiocb {
>   	union {
>   		/*
> @@ -665,6 +677,8 @@ struct io_kiocb {
>   		u64			extra1;
>   		u64			extra2;
>   	} big_cqe;
> +    /* for hybrid iopoll */
> +	struct hy_poll_time		*hy_poll;
>   };
>   
>   struct io_overflow_cqe {
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 994bf7af0efe..ef32ec319d1f 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -199,6 +199,7 @@ enum io_uring_sqe_flags_bit {
>    * Removes indirection through the SQ index array.
>    */
>   #define IORING_SETUP_NO_SQARRAY		(1U << 16)
> +#define IORING_SETUP_HY_POLL	(1U << 17)
>   
>   enum io_uring_op {
>   	IORING_OP_NOP,
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 816e93e7f949..a1015ce6dde7 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -299,6 +299,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>   		goto err;
>   
>   	ctx->flags = p->flags;
> +	xa_init(&ctx->poll_array);
>   	atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
>   	init_waitqueue_head(&ctx->sqo_sq_wait);
>   	INIT_LIST_HEAD(&ctx->sqd_list);
> @@ -2679,6 +2680,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
>   	kfree(ctx->cancel_table.hbs);
>   	kfree(ctx->cancel_table_locked.hbs);
>   	xa_destroy(&ctx->io_bl_xa);
> +	xa_destroy(&ctx->poll_array);
>   	kfree(ctx);
>   }
>   
> @@ -3637,7 +3639,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
>   			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
>   			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
>   			IORING_SETUP_NO_MMAP | IORING_SETUP_REGISTERED_FD_ONLY |
> -			IORING_SETUP_NO_SQARRAY))
> +			IORING_SETUP_NO_SQARRAY | IORING_SETUP_HY_POLL))
>   		return -EINVAL;
>   
>   	return io_uring_create(entries, &p, params);
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index 624ca9076a50..665093c048ba 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -148,6 +148,9 @@ static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
>   		__io_submit_flush_completions(ctx);
>   }
>   
> +/* if sleep time less than 1us, then do not do the schedule op */
> +#define MIN_SCHETIME 1000

Add prefix IO_, and name should be less ambiguous.

e.g. IO_HYBRID_POLL_MIN_SLEEP

> +
>   #define io_for_each_link(pos, head) \
>   	for (pos = (head); pos; pos = pos->link)
>   
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 1a2128459cb4..48b162becfa2 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -772,6 +772,46 @@ static bool need_complete_io(struct io_kiocb *req)
>   		S_ISBLK(file_inode(req->file)->i_mode);
>   }
>   
> +static void init_hybrid_poll(struct io_ring_ctx *ctx, struct io_kiocb *req)
> +{
> +	/*
> +	 * In multiple concurrency, a thread may operate several files
> +	 * under different file systems, the inode numbers may be
> +	 * duplicated. Each device has a different IO command processing
> +	 * capability, so using device number to record the running time
> +	 * of device
> +	 */
> +	u32 index = req->file->f_inode->i_rdev;
> +	struct iopoll_info *entry = xa_load(&ctx->poll_array, index);
> +	struct hy_poll_time *hpt = kmalloc(sizeof(struct hy_poll_time), GFP_KERNEL);

Just a note, it's a performance hazard for anything running
fast enough. Per IO allocation + xarray + ktime...

> +
> +	/* if alloc fail, go to regular poll */
> +	if (!hpt) {
> +		ctx->flags &= ~IORING_SETUP_HY_POLL;

Please don't modify ctx->flags, if you want to fall back
to normal polling do it per IO.

> +		return;
> +	}
> +	hpt->poll_state = 0;

What's 0/1? Just turn it into a bool with the right name
or add named constants for states.

> +	req->hy_poll = hpt;
> +
> +	if (!entry) {
> +		entry = kmalloc(sizeof(struct iopoll_info), GFP_KERNEL);
> +		if (!entry) {
> +			ctx->flags &= ~IORING_SETUP_HY_POLL;
> +			return;
> +		}
> +		entry->last_runtime = 0;
> +		entry->last_irqtime = 0;
> +		xa_store(&ctx->poll_array, index, entry, GFP_KERNEL);
> +	}
> +
> +	/*
> +	 * Here we need nanosecond timestamps, some ways of reading
> +	 * timestamps directly are only accurate to microseconds, so
> +	 * there's no better alternative here for now
> +	 */
> +	ktime_get_ts64(&hpt->iopoll_start);
> +}
> +
>   static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
>   {
>   	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
> @@ -809,6 +849,8 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
>   		kiocb->ki_flags |= IOCB_HIPRI;
>   		kiocb->ki_complete = io_complete_rw_iopoll;
>   		req->iopoll_completed = 0;
> +		if (ctx->flags & IORING_SETUP_HY_POLL)
> +			init_hybrid_poll(ctx, req);
>   	} else {
>   		if (kiocb->ki_flags & IOCB_HIPRI)
>   			return -EINVAL;
> @@ -1106,6 +1148,75 @@ void io_rw_fail(struct io_kiocb *req)
>   	io_req_set_res(req, res, req->cqe.flags);
>   }
>   
> +static void io_delay(struct hy_poll_time *hpt, struct iopoll_info *entry)
> +{
> +	struct hrtimer_sleeper timer;
> +	struct timespec64 tc, oldtc;
> +	enum hrtimer_mode mode;
> +	ktime_t kt;
> +	long sleep_ti;
> +
> +	if (hpt->poll_state == 1)
> +		return;
> +
> +	if (entry->last_runtime <= entry->last_irqtime)
> +		return;
> +
> +	/*
> +	 * Avoid excessive scheduling time affecting performance
> +	 * by using only 25 per cent of the remaining time
> +	 */
> +	sleep_ti = (entry->last_runtime - entry->last_irqtime) / 4;

Let's say you've got a new entry, which sets both to 0. Then
user does sleep(8 min) and iopolls it once, which will update
last_runtime=8 min. Next time it tries to iopoll,
(8 min - 0) / 4 = 2 min. It'll try to sleep for 2 minutes,
with UNINTERRUBTIBLE (below) at that.

Extreme, but shows there can be all kinds of fun with this scheme.

> +
> +	/*
> +	 * If the time available for sleep is too short, i.e. the
> +	 * totle running time and the context switching loss time
> +	 * are very close to each other, the scheduling operation
> +	 * is not performed to avoid increasing latency
> +	 */
> +	if (sleep_ti < MIN_SCHETIME)
> +		return;
> +
> +	ktime_get_ts64(&oldtc);
> +	kt = ktime_set(0, sleep_ti);
> +	hpt->poll_state = 1;
> +
> +	mode = HRTIMER_MODE_REL;
> +	hrtimer_init_sleeper_on_stack(&timer, CLOCK_MONOTONIC, mode);
> +	hrtimer_set_expires(&timer.timer, kt);
> +	set_current_state(TASK_UNINTERRUPTIBLE);

TASK_INTERRUPTIBLE, we don't want it to make userspace
unresponsive.

> +	hrtimer_sleeper_start_expires(&timer, mode);
> +
> +	if (timer.task)
> +		io_schedule();
> +
> +	hrtimer_cancel(&timer.timer);
> +	mode = HRTIMER_MODE_ABS;

What's this for? It's a local variable.

> +	__set_current_state(TASK_RUNNING);
> +	destroy_hrtimer_on_stack(&timer.timer);
> +
> +	ktime_get_ts64(&tc);
> +	entry->last_irqtime = tc.tv_nsec - oldtc.tv_nsec - sleep_ti
Where did seconds go? And can also get negative values and all
kinds of inconsistent timings.

Why is it even called irq time? Anyone would think it's an interrupt
from the IO, but it's rather from the timer.

> +}
> +
> +static int io_uring_hybrid_poll(struct io_kiocb *req,
> +				struct io_comp_batch *iob, unsigned int poll_flags)
> +{
> +	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
> +	struct io_ring_ctx *ctx = req->ctx;
> +	struct hy_poll_time *hpt = req->hy_poll;
> +	u32 index = req->file->f_inode->i_rdev;
> +	struct iopoll_info *entry = xa_load(&ctx->poll_array, index);

Why is it per file/device/etc instead of globally per ring?
It'd make some sense if you caluculate an aggregate, e.g.
minimum sleep time for all of them, but otherwise not much.
Take one slow device, one fast device, while sleeping for the
slow one, you can get lots of completions from the fast one.

> +	int ret;

Why it's even per inode but not per ring? Take one very
slow device,

> +
> +	io_delay(hpt, entry);
> +	ret = req->file->f_op->iopoll(&rw->kiocb, iob, poll_flags);

IORING_OP_URING_CMD uses uring_cmd_iopoll

> +
> +	ktime_get_ts64(&hpt->iopoll_end);
> +	entry->last_runtime = hpt->iopoll_end.tv_nsec - hpt->iopoll_start.tv_nsec;
> +	return ret;
> +}
> +
>   int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
>   {
>   	struct io_wq_work_node *pos, *start, *prev;
> @@ -1133,7 +1244,9 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
>   		if (READ_ONCE(req->iopoll_completed))
>   			break;
>   
> -		if (req->opcode == IORING_OP_URING_CMD) {
> +		if (ctx->flags & IORING_SETUP_HY_POLL) {
> +			ret = io_uring_hybrid_poll(req, &iob, poll_flags);
> +		} else if (req->opcode == IORING_OP_URING_CMD) {
>   			struct io_uring_cmd *ioucmd;
>   
>   			ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);

-- 
Pavel Begunkov

