Return-Path: <io-uring+bounces-562-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EE3084C17A
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 01:47:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92FDE1F23C0D
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 00:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE1F18F62;
	Wed,  7 Feb 2024 00:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kO5JmOa6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E698F48
	for <io-uring@vger.kernel.org>; Wed,  7 Feb 2024 00:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707266821; cv=none; b=sEXQKHU/7JztsWZkXl2qNaoauciFvz2rUqALvxM1VqS0aBfjLIbNKquswTsUAVvC92pIo55Vz6YfRTaQ96p6Ve2QGQ4DUnH+INgRf7rboYYSEyKFM4+zXDJ/dGnHfvGe8q0EVnuK2s/B8yJIW4sf5clcIMJmiWKcZT4MnPZZbuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707266821; c=relaxed/simple;
	bh=t0+riXJG2SEGzIS6bc4Xe8NlaBrnY3/DxehPgR7dkNA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=l5SyEAviCy+BqaKxgAbEFdT9h3kltCzQBeTdWkkG3FK/0qNQCqvb/xg0nDdlchV0R1ECSwk+wQ2RdyT9mr6ZwKzuM5+CP4RrpBTYwt8qc2fg7Y7czkn3nO3lUpN6isvmPhBLCgl0aMjA2TXPHGBy402cIdgi6zjzkREkAofh/MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kO5JmOa6; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40fd280421aso283325e9.3
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 16:46:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707266818; x=1707871618; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Glh1XvYB/+tPNxMlAe/BxF3v1l48mJwHwy0va0sYUo4=;
        b=kO5JmOa6RwBj/WmkpTZwZzId9kuD3/p6nXshqoICpDqe3pik37J5/oJjBJ3hLEaxZp
         D3LzNmyTiRxH/lruFWs1gweAm9BZYyKPMY0T/GY6zjem3RD00lg/RlTnztMBPZ+NMA5Y
         GoggYRpCVqBQEs7O3YM8MnZhSlwgvMwdnIGDgUfNrDwFCyAiuOqDg+ckLcoAp/+0+rG8
         n72SsL7OItZP2B+00LNIbT9pN+80mb4g6jXYwH4413VV9mORnnCpiWUzgUechHGpNU4I
         AJYIRJszZUGtfiJACev8vZ+KEORVO3aq6qrZfTOcW8QEHmJqFgjKRswAdNHBpJujQBRS
         AZ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707266818; x=1707871618;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Glh1XvYB/+tPNxMlAe/BxF3v1l48mJwHwy0va0sYUo4=;
        b=MuYn7ujzAXvUt87oHBIbQTx30Y55mOS36I9OocXA+qE4h8MyQEVF8PZSz5AFZA7Bn3
         d/yuRs1rlo3nTpKZ3gPRyRKz9GSU+6OOltrIrayfMwFSZIsJg6KyBwPUvH0FySTaIgg7
         YR99A2/+NuLAgIJXJj3zhx+aNJLaVgufySSJpXCsTu783/s/m/oGP7mDx/TVrTKwgCm5
         zNtwHXSAW/1ILG7nbTN6ekkfd5z2m4f/8NQ+2scZ+pAxqOMf9T8IpZghypDPkYTu/1fL
         Pqn+w9UML5UDRlMsxJoOi+rNC2QIML4kOsyB9Epa5wWEvWqm7tb4u0kpMCEdj3HBOCeq
         EYew==
X-Gm-Message-State: AOJu0YxFjCv0VLNgQjsHzmv3lawgkv/kHlVH4JTKjhwMdAQkI9TBciYG
	aKu3l1VcpIqHCOVP/0C32Y0MqwJSXVjS4falmz6wIzalC3+7Z0TNUx2PcVng
X-Google-Smtp-Source: AGHT+IFYz14o2hgaaKdkTi4d7Bh0FKZiflWpxn0CzT87QBZsqZx/TMhpcTFWnbaTZNqogVGNUWrH3g==
X-Received: by 2002:adf:edcd:0:b0:33a:f3a5:37d1 with SMTP id v13-20020adfedcd000000b0033af3a537d1mr2073099wro.29.1707266817422;
        Tue, 06 Feb 2024 16:46:57 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVcMJHiTF2H0US45VH4ZvPvR2ZKzSYS5XVzJYlYZlwqgw2ese8r8bPEAQHaQ7REPY7gQad6IuNkGEGpE1ToVXzSiQCZxLUoNI0=
Received: from [192.168.8.100] ([85.255.236.54])
        by smtp.gmail.com with ESMTPSA id m3-20020a056000024300b0033b2799815csm181050wrz.86.2024.02.06.16.46.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Feb 2024 16:46:57 -0800 (PST)
Message-ID: <f4e5bd14-2550-4683-bdc3-7521351f81e1@gmail.com>
Date: Wed, 7 Feb 2024 00:43:25 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] io_uring: expand main struct io_kiocb flags to
 64-bits
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240206162402.643507-1-axboe@kernel.dk>
 <20240206162402.643507-2-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240206162402.643507-2-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/6/24 16:22, Jens Axboe wrote:
> We're out of space here, and none of the flags are easily reclaimable.
> Bump it to 64-bits and re-arrange the struct a bit to avoid gaps.
> 
> Add a specific bitwise type for the request flags, io_request_flags_t.
> This will help catch violations of casting this value to a smaller type
> on 32-bit archs, like unsigned int.
> 
> No functional changes intended in this patch.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   include/linux/io_uring_types.h  | 87 ++++++++++++++++++---------------
>   include/trace/events/io_uring.h | 14 +++---
>   io_uring/filetable.h            |  2 +-
>   io_uring/io_uring.c             |  9 ++--
>   4 files changed, 60 insertions(+), 52 deletions(-)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 854ad67a5f70..5ac18b05d4ee 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -428,7 +428,7 @@ struct io_tw_state {
>   	bool locked;
>   };
>   
> -enum {
> +enum io_req_flags {
>   	REQ_F_FIXED_FILE_BIT	= IOSQE_FIXED_FILE_BIT,
>   	REQ_F_IO_DRAIN_BIT	= IOSQE_IO_DRAIN_BIT,
>   	REQ_F_LINK_BIT		= IOSQE_IO_LINK_BIT,
> @@ -468,70 +468,73 @@ enum {
>   	__REQ_F_LAST_BIT,
>   };
>   
> +typedef enum io_req_flags __bitwise io_req_flags_t;
> +#define IO_REQ_FLAG(bitno)	((__force io_req_flags_t) BIT_ULL((bitno)))
> +
>   enum {
>   	/* ctx owns file */
> -	REQ_F_FIXED_FILE	= BIT(REQ_F_FIXED_FILE_BIT),
> +	REQ_F_FIXED_FILE	= IO_REQ_FLAG(REQ_F_FIXED_FILE_BIT),
>   	/* drain existing IO first */
> -	REQ_F_IO_DRAIN		= BIT(REQ_F_IO_DRAIN_BIT),
> +	REQ_F_IO_DRAIN		= IO_REQ_FLAG(REQ_F_IO_DRAIN_BIT),
>   	/* linked sqes */
> -	REQ_F_LINK		= BIT(REQ_F_LINK_BIT),
> +	REQ_F_LINK		= IO_REQ_FLAG(REQ_F_LINK_BIT),
>   	/* doesn't sever on completion < 0 */
> -	REQ_F_HARDLINK		= BIT(REQ_F_HARDLINK_BIT),
> +	REQ_F_HARDLINK		= IO_REQ_FLAG(REQ_F_HARDLINK_BIT),
>   	/* IOSQE_ASYNC */
> -	REQ_F_FORCE_ASYNC	= BIT(REQ_F_FORCE_ASYNC_BIT),
> +	REQ_F_FORCE_ASYNC	= IO_REQ_FLAG(REQ_F_FORCE_ASYNC_BIT),
>   	/* IOSQE_BUFFER_SELECT */
> -	REQ_F_BUFFER_SELECT	= BIT(REQ_F_BUFFER_SELECT_BIT),
> +	REQ_F_BUFFER_SELECT	= IO_REQ_FLAG(REQ_F_BUFFER_SELECT_BIT),
>   	/* IOSQE_CQE_SKIP_SUCCESS */
> -	REQ_F_CQE_SKIP		= BIT(REQ_F_CQE_SKIP_BIT),
> +	REQ_F_CQE_SKIP		= IO_REQ_FLAG(REQ_F_CQE_SKIP_BIT),
>   
>   	/* fail rest of links */
> -	REQ_F_FAIL		= BIT(REQ_F_FAIL_BIT),
> +	REQ_F_FAIL		= IO_REQ_FLAG(REQ_F_FAIL_BIT),
>   	/* on inflight list, should be cancelled and waited on exit reliably */
> -	REQ_F_INFLIGHT		= BIT(REQ_F_INFLIGHT_BIT),
> +	REQ_F_INFLIGHT		= IO_REQ_FLAG(REQ_F_INFLIGHT_BIT),
>   	/* read/write uses file position */
> -	REQ_F_CUR_POS		= BIT(REQ_F_CUR_POS_BIT),
> +	REQ_F_CUR_POS		= IO_REQ_FLAG(REQ_F_CUR_POS_BIT),
>   	/* must not punt to workers */
> -	REQ_F_NOWAIT		= BIT(REQ_F_NOWAIT_BIT),
> +	REQ_F_NOWAIT		= IO_REQ_FLAG(REQ_F_NOWAIT_BIT),
>   	/* has or had linked timeout */
> -	REQ_F_LINK_TIMEOUT	= BIT(REQ_F_LINK_TIMEOUT_BIT),
> +	REQ_F_LINK_TIMEOUT	= IO_REQ_FLAG(REQ_F_LINK_TIMEOUT_BIT),
>   	/* needs cleanup */
> -	REQ_F_NEED_CLEANUP	= BIT(REQ_F_NEED_CLEANUP_BIT),
> +	REQ_F_NEED_CLEANUP	= IO_REQ_FLAG(REQ_F_NEED_CLEANUP_BIT),
>   	/* already went through poll handler */
> -	REQ_F_POLLED		= BIT(REQ_F_POLLED_BIT),
> +	REQ_F_POLLED		= IO_REQ_FLAG(REQ_F_POLLED_BIT),
>   	/* buffer already selected */
> -	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
> +	REQ_F_BUFFER_SELECTED	= IO_REQ_FLAG(REQ_F_BUFFER_SELECTED_BIT),
>   	/* buffer selected from ring, needs commit */
> -	REQ_F_BUFFER_RING	= BIT(REQ_F_BUFFER_RING_BIT),
> +	REQ_F_BUFFER_RING	= IO_REQ_FLAG(REQ_F_BUFFER_RING_BIT),
>   	/* caller should reissue async */
> -	REQ_F_REISSUE		= BIT(REQ_F_REISSUE_BIT),
> +	REQ_F_REISSUE		= IO_REQ_FLAG(REQ_F_REISSUE_BIT),
>   	/* supports async reads/writes */
> -	REQ_F_SUPPORT_NOWAIT	= BIT(REQ_F_SUPPORT_NOWAIT_BIT),
> +	REQ_F_SUPPORT_NOWAIT	= IO_REQ_FLAG(REQ_F_SUPPORT_NOWAIT_BIT),
>   	/* regular file */
> -	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
> +	REQ_F_ISREG		= IO_REQ_FLAG(REQ_F_ISREG_BIT),
>   	/* has creds assigned */
> -	REQ_F_CREDS		= BIT(REQ_F_CREDS_BIT),
> +	REQ_F_CREDS		= IO_REQ_FLAG(REQ_F_CREDS_BIT),
>   	/* skip refcounting if not set */
> -	REQ_F_REFCOUNT		= BIT(REQ_F_REFCOUNT_BIT),
> +	REQ_F_REFCOUNT		= IO_REQ_FLAG(REQ_F_REFCOUNT_BIT),
>   	/* there is a linked timeout that has to be armed */
> -	REQ_F_ARM_LTIMEOUT	= BIT(REQ_F_ARM_LTIMEOUT_BIT),
> +	REQ_F_ARM_LTIMEOUT	= IO_REQ_FLAG(REQ_F_ARM_LTIMEOUT_BIT),
>   	/* ->async_data allocated */
> -	REQ_F_ASYNC_DATA	= BIT(REQ_F_ASYNC_DATA_BIT),
> +	REQ_F_ASYNC_DATA	= IO_REQ_FLAG(REQ_F_ASYNC_DATA_BIT),
>   	/* don't post CQEs while failing linked requests */
> -	REQ_F_SKIP_LINK_CQES	= BIT(REQ_F_SKIP_LINK_CQES_BIT),
> +	REQ_F_SKIP_LINK_CQES	= IO_REQ_FLAG(REQ_F_SKIP_LINK_CQES_BIT),
>   	/* single poll may be active */
> -	REQ_F_SINGLE_POLL	= BIT(REQ_F_SINGLE_POLL_BIT),
> +	REQ_F_SINGLE_POLL	= IO_REQ_FLAG(REQ_F_SINGLE_POLL_BIT),
>   	/* double poll may active */
> -	REQ_F_DOUBLE_POLL	= BIT(REQ_F_DOUBLE_POLL_BIT),
> +	REQ_F_DOUBLE_POLL	= IO_REQ_FLAG(REQ_F_DOUBLE_POLL_BIT),
>   	/* request has already done partial IO */
> -	REQ_F_PARTIAL_IO	= BIT(REQ_F_PARTIAL_IO_BIT),
> +	REQ_F_PARTIAL_IO	= IO_REQ_FLAG(REQ_F_PARTIAL_IO_BIT),
>   	/* fast poll multishot mode */
> -	REQ_F_APOLL_MULTISHOT	= BIT(REQ_F_APOLL_MULTISHOT_BIT),
> +	REQ_F_APOLL_MULTISHOT	= IO_REQ_FLAG(REQ_F_APOLL_MULTISHOT_BIT),
>   	/* recvmsg special flag, clear EPOLLIN */
> -	REQ_F_CLEAR_POLLIN	= BIT(REQ_F_CLEAR_POLLIN_BIT),
> +	REQ_F_CLEAR_POLLIN	= IO_REQ_FLAG(REQ_F_CLEAR_POLLIN_BIT),
>   	/* hashed into ->cancel_hash_locked, protected by ->uring_lock */
> -	REQ_F_HASH_LOCKED	= BIT(REQ_F_HASH_LOCKED_BIT),
> +	REQ_F_HASH_LOCKED	= IO_REQ_FLAG(REQ_F_HASH_LOCKED_BIT),
>   	/* don't use lazy poll wake for this request */
> -	REQ_F_POLL_NO_LAZY	= BIT(REQ_F_POLL_NO_LAZY_BIT),
> +	REQ_F_POLL_NO_LAZY	= IO_REQ_FLAG(REQ_F_POLL_NO_LAZY_BIT),
>   };
>   
>   typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
> @@ -592,15 +595,14 @@ struct io_kiocb {
>   	 * and after selection it points to the buffer ID itself.
>   	 */
>   	u16				buf_index;
> -	unsigned int			flags;
>   
> -	struct io_cqe			cqe;

With the current layout the min number of lines we touch per
request is 2 (including the op specific 64B), that's includes
setting up cqe at init and using it for completing. Moving cqe
down makes it 3.

> +	atomic_t			refs;

We're pulling it refs, which is not touched at all in the hot
path. Even if there's a hole I'd argue it's better to leave it
at the end.

> +
> +	io_req_flags_t			flags;
>   
>   	struct io_ring_ctx		*ctx;
>   	struct task_struct		*task;
>   
> -	struct io_rsrc_node		*rsrc_node;

It's used in hot paths, registered buffers/files, would be
unfortunate to move it to the next line.

> -
>   	union {
>   		/* store used ubuf, so we can prevent reloading */
>   		struct io_mapped_ubuf	*imu;
> @@ -615,18 +617,23 @@ struct io_kiocb {
>   		struct io_buffer_list	*buf_list;
>   	};
>   
> +	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
> +	struct hlist_node		hash_node;
> +

And we're pulling hash_node into the hottest line, which is
used only when we arm a poll and remove poll. So, it's mostly
for networking, sends wouldn't use it much, and multishots
wouldn't normally touch it.

As for ideas how to find space:
1) iopoll_completed completed can be converted to flags2

2) REQ_F_{SINGLE,DOUBLE}_POLL is a weird duplication. Can
probably be combined into one flag, or removed at all.
Again, sends are usually not so poll heavy and the hot
path for recv is multishot.

3) we can probably move req->task down and replace it with

get_task() {
     if (req->ctx->flags & DEFER_TASKRUN)
         task = ctx->submitter_task;
     else
         task = req->task;
}

The most common user of it -- task_work_add -- already
checks the flag and has separate paths, and
init/completion paths can be optimised.


>   	union {
>   		/* used by request caches, completion batching and iopoll */
>   		struct io_wq_work_node	comp_list;
>   		/* cache ->apoll->events */
>   		__poll_t apoll_events;
>   	};
> -	atomic_t			refs;
> -	atomic_t			poll_refs;
> +
> +	struct io_rsrc_node		*rsrc_node;
> +
> +	struct io_cqe			cqe;
> +
>   	struct io_task_work		io_task_work;
> +	atomic_t			poll_refs;
>   	unsigned			nr_tw;
> -	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
> -	struct hlist_node		hash_node;
>   	/* internal polling, see IORING_FEAT_FAST_POLL */
>   	struct async_poll		*apoll;
>   	/* opcode allocated if it needs to store data for async defer */
> diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
> index 69454f1f98b0..3d7704a52b73 100644
> --- a/include/trace/events/io_uring.h
> +++ b/include/trace/events/io_uring.h
> @@ -148,7 +148,7 @@ TRACE_EVENT(io_uring_queue_async_work,
>   		__field(  void *,			req		)
>   		__field(  u64,				user_data	)
>   		__field(  u8,				opcode		)
> -		__field(  unsigned int,			flags		)
> +		__field(  io_req_flags_t,		flags		)
>   		__field(  struct io_wq_work *,		work		)
>   		__field(  int,				rw		)
>   
> @@ -167,10 +167,10 @@ TRACE_EVENT(io_uring_queue_async_work,
>   		__assign_str(op_str, io_uring_get_opcode(req->opcode));
>   	),
>   
> -	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %s, flags 0x%x, %s queue, work %p",
> +	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %s, flags 0x%lx, %s queue, work %p",
>   		__entry->ctx, __entry->req, __entry->user_data,
> -		__get_str(op_str),
> -		__entry->flags, __entry->rw ? "hashed" : "normal", __entry->work)
> +		__get_str(op_str), (long) __entry->flags,
> +		__entry->rw ? "hashed" : "normal", __entry->work)
>   );
>   
>   /**
> @@ -378,7 +378,7 @@ TRACE_EVENT(io_uring_submit_req,
>   		__field(  void *,		req		)
>   		__field(  unsigned long long,	user_data	)
>   		__field(  u8,			opcode		)
> -		__field(  u32,			flags		)
> +		__field(  io_req_flags_t,	flags		)
>   		__field(  bool,			sq_thread	)
>   
>   		__string( op_str, io_uring_get_opcode(req->opcode) )
> @@ -395,10 +395,10 @@ TRACE_EVENT(io_uring_submit_req,
>   		__assign_str(op_str, io_uring_get_opcode(req->opcode));
>   	),
>   
> -	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %s, flags 0x%x, "
> +	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %s, flags 0x%lx, "
>   		  "sq_thread %d", __entry->ctx, __entry->req,
>   		  __entry->user_data, __get_str(op_str),
> -		  __entry->flags, __entry->sq_thread)
> +		  (long) __entry->flags, __entry->sq_thread)
>   );
>   
>   /*
> diff --git a/io_uring/filetable.h b/io_uring/filetable.h
> index b47adf170c31..b2435c4dca1f 100644
> --- a/io_uring/filetable.h
> +++ b/io_uring/filetable.h
> @@ -17,7 +17,7 @@ int io_fixed_fd_remove(struct io_ring_ctx *ctx, unsigned int offset);
>   int io_register_file_alloc_range(struct io_ring_ctx *ctx,
>   				 struct io_uring_file_index_range __user *arg);
>   
> -unsigned int io_file_get_flags(struct file *file);
> +io_req_flags_t io_file_get_flags(struct file *file);
>   
>   static inline void io_file_bitmap_clear(struct io_file_table *table, int bit)
>   {
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index cd9a137ad6ce..360a7ee41d3a 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1768,9 +1768,9 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
>   	}
>   }
>   
> -unsigned int io_file_get_flags(struct file *file)
> +io_req_flags_t io_file_get_flags(struct file *file)
>   {
> -	unsigned int res = 0;
> +	io_req_flags_t res = 0;
>   
>   	if (S_ISREG(file_inode(file)->i_mode))
>   		res |= REQ_F_ISREG;
> @@ -2171,7 +2171,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
>   	/* req is partially pre-initialised, see io_preinit_req() */
>   	req->opcode = opcode = READ_ONCE(sqe->opcode);
>   	/* same numerical values with corresponding REQ_F_*, safe to copy */
> -	req->flags = sqe_flags = READ_ONCE(sqe->flags);
> +	sqe_flags = READ_ONCE(sqe->flags);
> +	req->flags = (io_req_flags_t) sqe_flags;
>   	req->cqe.user_data = READ_ONCE(sqe->user_data);
>   	req->file = NULL;
>   	req->rsrc_node = NULL;
> @@ -4153,7 +4154,7 @@ static int __init io_uring_init(void)
>   	BUILD_BUG_ON(SQE_COMMON_FLAGS >= (1 << 8));
>   	BUILD_BUG_ON((SQE_VALID_FLAGS | SQE_COMMON_FLAGS) != SQE_VALID_FLAGS);
>   
> -	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(int));
> +	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(u64));
>   
>   	BUILD_BUG_ON(sizeof(atomic_t) != sizeof(u32));
>   

-- 
Pavel Begunkov

