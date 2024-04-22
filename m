Return-Path: <io-uring+bounces-1607-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED5688AD3AF
	for <lists+io-uring@lfdr.de>; Mon, 22 Apr 2024 20:12:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4F06282101
	for <lists+io-uring@lfdr.de>; Mon, 22 Apr 2024 18:12:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B673154429;
	Mon, 22 Apr 2024 18:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="s5E9Z7KZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F373153BC6
	for <io-uring@vger.kernel.org>; Mon, 22 Apr 2024 18:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713809525; cv=none; b=jmtlgb4Kyq8nu1V7/p5gD2mzCfpZadPePeTyb5HZK4ji/SkOKHAjvmyP4l67n7atGGVw5i7xzW6inIQIosEz1NZezS8whjdHVLYiSwrUY7DReDCFU0r9E+6KVJD50fDpTZZwgP15PZpGWwyia8/S/JffkotNH6G7ivEoGyA3ta4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713809525; c=relaxed/simple;
	bh=+bmT5ZSnz6cgrFnjIOgO/GAMoJUGwoT1BGZQE6EcDOk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eKTk2cUWmxOOo3n7LvTmR+7yH5QPtRKYL/tqIzUXf2S16wbEgDINuppAg2I155eXOO81OdL+1ADTE/ymmGaCBJVh9Fmhn3B1xcKh5MP96yTrDgZNwzxmjG6ZHeCSc8eLbrkfwZMe5stHDBqpp90o3yy7RgF387CKfCZQ+xAJJsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=s5E9Z7KZ; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-36c0274c0faso1503905ab.0
        for <io-uring@vger.kernel.org>; Mon, 22 Apr 2024 11:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1713809521; x=1714414321; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TmGShFWoRVktvJFqOt7PH3+a0ik/WNiKdXQiHlHb8Zs=;
        b=s5E9Z7KZcCpWQUJt0yEtbSktV7+SMh7KWfg5uwM8eDiHs9MXR87hz7NDa9xnW6EwKo
         JNQbxyefKa36K0BQGsBK0LK0ukcO/50P2PRw3wQzOrnTtrGjanCF1ShMcdBkeVgoYkWQ
         KtqIHoFwPOwssBw8l51KkxyNvL0kAmcLpTCk74wEMLenkvGP/dz950EcaWRYbiuY807L
         IhnjgCRDF4fZXCo0P2G0jOlKrMDaNGx7s9Tl2OACupc5hHiW4RPRDVXlkfjbWxvCNEXp
         13Rb3HqFzb4J0JDomys3YNIwNWLX9vEmOEh+D1N65ObNq7WA51v5TAUxM7pI6VAEK3LX
         ELdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713809521; x=1714414321;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TmGShFWoRVktvJFqOt7PH3+a0ik/WNiKdXQiHlHb8Zs=;
        b=AEVi35beAw6CUtShBqWallKHpOS16co5woNU2S8LDnKHhK/74bZBQa7MyWOYmRlUob
         q0Hl4pKtgYYjVurCwqGFu0m3DjtuhZDxVUFbuv0yjpwCYlFoqE+z3h9qz1CcGIiiSyeH
         5A6mkzQ8capvGiZXWJSfXXgBvz+dIscHQKBf/Yt+/44d8jUIHJUofThK+g6ZYwGUSENa
         LqvWteRa7JvSxUXXhwKdlkj+PXtFVUXq9hSEuOLzV6QQ6BWD0x6vFMgBv7OAYK/Q1uMr
         MVZ1/WJXmlB2DN47HcXG11344L8B/Vl5jfENflG4kaZajmoul6UjqWc+fQbd+YGdmkQ+
         E1WQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmFgeepCVOf55JSck9k9W7GJo1rS5J/ny/stvqphjM/WV9EUDj+KIC02EXoVi9EJxigaH1lzYUEDRv09B5SgByQYWmGMVDqjE=
X-Gm-Message-State: AOJu0YzRI4qTCAKR5CJ6J53DIsBSvBMDeWsQV7obR6haOUcZ7zoSf7BE
	/HIVYmxER+GQTmpNWL3BfAt5tc/t2o/f5cGNimAQRp5V8yf4PyhkZC+Tirzj060=
X-Google-Smtp-Source: AGHT+IEM9WSFapHFfE2legEY6Pjtc4qT2dZMs0/BLF/YWrO5XJsdpSDaFVp69Tt8NORqNaoNOQVwhw==
X-Received: by 2002:a5d:9282:0:b0:7da:d6ff:7f53 with SMTP id s2-20020a5d9282000000b007dad6ff7f53mr2625378iom.0.1713809521264;
        Mon, 22 Apr 2024 11:12:01 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id he8-20020a0566386d0800b004852c9c9c24sm1055587jab.95.2024.04.22.11.12.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Apr 2024 11:12:00 -0700 (PDT)
Message-ID: <e8c28f87-ff8a-4f30-b252-46e2260357c9@kernel.dk>
Date: Mon, 22 Apr 2024 12:11:59 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: releasing CPU resources when polling
Content-Language: en-US
To: hexue <xue01.he@samsung.com>
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, anuj20.g@samsung.com, wenwen.chen@samsung.com,
 ruyi.zhang@samsung.com, xiaobing.li@samsung.com, cliang01.li@samsung.com
References: <CGME20240418093150epcas5p31dc20cc737c72009265593f247e48262@epcas5p3.samsung.com>
 <20240418093143.2188131-1-xue01.he@samsung.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240418093143.2188131-1-xue01.he@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/18/24 3:31 AM, hexue wrote:
> This patch is intended to release the CPU resources of io_uring in
> polling mode. When IO is issued, the program immediately polls for
> check completion, which is a waste of CPU resources when IO commands
> are executed on the disk.
> 
> I add the hybrid polling feature in io_uring, enables polling to
> release a portion of CPU resources without affecting block layer.
> 
> - Record the running time and context switching time of each
>   IO, and use these time to determine whether a process continue
>   to schedule.
> 
> - Adaptive adjustment to different devices. Due to the real-time
>   nature of time recording, each device's IO processing speed is
>   different, so the CPU optimization effect will vary.
> 
> - Set a interface (ctx->flag) enables application to choose whether
>   or not to use this feature.
> 
> The CPU optimization in peak workload of patch is tested as follows:
>   all CPU utilization of original polling is 100% for per CPU, after
>   optimization, the CPU utilization drop a lot (per CPU);
> 
>    read(128k, QD64, 1Job)     37%   write(128k, QD64, 1Job)     40%
>    randread(4k, QD64, 16Job)  52%   randwrite(4k, QD64, 16Job)  12%
> 
>   Compared to original polling, the optimised performance reduction
>   with peak workload within 1%.
> 
>    read  0.29%     write  0.51%    randread  0.09%    randwrite  0%

As mentioned, this is like a reworked version of the old hybrid polling
we had. The feature itself may make sense, but there's a slew of things
in this patch that aren't really acceptable. More below.

> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 854ad67a5f70..7607fd8de91c 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -224,6 +224,11 @@ struct io_alloc_cache {
>  	size_t			elem_size;
>  };
>  
> +struct iopoll_info {
> +	long		last_runtime;
> +	long		last_irqtime;
> +};
> +
>  struct io_ring_ctx {
>  	/* const or read-mostly hot data */
>  	struct {
> @@ -421,6 +426,7 @@ struct io_ring_ctx {
>  	unsigned short			n_sqe_pages;
>  	struct page			**ring_pages;
>  	struct page			**sqe_pages;
> +	struct xarray		poll_array;
>  };
>  
>  struct io_tw_state {
> @@ -641,6 +647,10 @@ struct io_kiocb {
>  		u64			extra1;
>  		u64			extra2;
>  	} big_cqe;
> +	/* for hybrid iopoll */
> +	int				poll_flag;
> +	struct timespec64		iopoll_start;
> +	struct timespec64		iopoll_end;
>  };

This is adding 4/8 + 16 + 16 bytes to the io_kiocb - or in other ways to
look at it, growing it by ~17% in size. That does not seem appropriate,
given the limited scope of the feature.

> @@ -1875,10 +1878,28 @@ static bool io_assign_file(struct io_kiocb *req, const struct io_issue_def *def,
>  	return !!req->file;
>  }
>  
> +void init_hybrid_poll_info(struct io_ring_ctx *ctx, struct io_kiocb *req)
> +{
> +	u32 index;
> +
> +	index = req->file->f_inode->i_rdev;
> +	struct iopoll_info *entry = xa_load(&ctx->poll_array, index);

Mixing code and declarations, that's a no go. This should look like:


	u32 index = req->file->f_inode->i_rdev;
	struct iopoll_info *entry = xa_load(&ctx->poll_array, index);

Outside of that, this is now dipping into the inode from the hot path.
You could probably make do with f_inode here, as this is just a lookup
key?

It's also doing an extra lookup per polled IO. I guess the overhead is
fine as it's just for the hybrid setup, though not ideal.

> +
> +	if (!entry) {
> +		entry = kmalloc(sizeof(struct iopoll_info), GFP_KERNEL);

As also brought up, you need error checking on allocations.

> +		entry->last_runtime = 0;
> +		entry->last_irqtime = 0;
> +		xa_store(&ctx->poll_array, index, entry, GFP_KERNEL);
> +	}
> +
> +	ktime_get_ts64(&req->iopoll_start);
> +}

Time retrieval per IO is not cheap.

>  static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>  {
>  	const struct io_issue_def *def = &io_issue_defs[req->opcode];
>  	const struct cred *creds = NULL;
> +	struct io_ring_ctx *ctx = req->ctx;
>  	int ret;
>  
>  	if (unlikely(!io_assign_file(req, def, issue_flags)))
> @@ -1890,6 +1911,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>  	if (!def->audit_skip)
>  		audit_uring_entry(req->opcode);
>  
> +	if (ctx->flags & IORING_SETUP_HY_POLL)
> +		init_hybrid_poll_info(ctx, req);
> +
>  	ret = def->issue(req, issue_flags);

Would probably be better to have this in the path of the opcodes that
actually support iopoll, rather than add a branch for any kind of IO.

> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index d5495710c178..d5b175826adb 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -125,6 +125,8 @@ static inline void io_req_task_work_add(struct io_kiocb *req)
>  	__io_req_task_work_add(req, 0);
>  }
>  
> +#define LEFT_TIME 1000

This badly needs a comment and a better name...

> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index d5e79d9bdc71..ac73121030ee 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -1118,6 +1118,69 @@ void io_rw_fail(struct io_kiocb *req)
>  	io_req_set_res(req, res, req->cqe.flags);
>  }
>  
> +void io_delay(struct io_kiocb *req, struct iopoll_info *entry)
> +{
> +	struct hrtimer_sleeper timer;
> +	ktime_t kt;
> +	struct timespec64 tc, oldtc;
> +	enum hrtimer_mode mode;
> +	long sleep_ti;
> +
> +	if (req->poll_flag == 1)
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
> +	if (sleep_ti < LEFT_TIME)
> +		return;
> +
> +	ktime_get_ts64(&oldtc);
> +	kt = ktime_set(0, sleep_ti);
> +	req->poll_flag = 1;
> +
> +	mode = HRTIMER_MODE_REL;
> +	hrtimer_init_sleeper_on_stack(&timer, CLOCK_MONOTONIC, mode);
> +	hrtimer_set_expires(&timer.timer, kt);
> +
> +	set_current_state(TASK_UNINTERRUPTIBLE);
> +	hrtimer_sleeper_start_expires(&timer, mode);
> +	if (timer.task) {
> +		io_schedule();
> +	}

Redundant braces.

> +	hrtimer_cancel(&timer.timer);
> +	mode = HRTIMER_MODE_ABS;
> +
> +	__set_current_state(TASK_RUNNING);
> +	destroy_hrtimer_on_stack(&timer.timer);
> +
> +	ktime_get_ts64(&tc);
> +	entry->last_irqtime = tc.tv_nsec - oldtc.tv_nsec - sleep_ti;
> +}
> +
> +int iouring_hybrid_poll(struct io_kiocb *req, struct io_comp_batch *iob, unsigned int poll_flags)

Overly long line.

> +	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
> +	struct io_ring_ctx *ctx = req->ctx;
> +	struct iopoll_info *entry;
> +	int ret;
> +	u32 index;
> +
> +	index = req->file->f_inode->i_rdev;

Ditto here on i_rdev vs inode.

> +	entry = xa_load(&ctx->poll_array, index);
> +	io_delay(req, entry);
> +	ret = req->file->f_op->iopoll(&rw->kiocb, iob, poll_flags);
> +
> +	ktime_get_ts64(&req->iopoll_end);
> +	entry->last_runtime = req->iopoll_end.tv_nsec - req->iopoll_start.tv_nsec;
> +	return ret;
> +}
> +
>  int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
>  {
>  	struct io_wq_work_node *pos, *start, *prev;
> @@ -1145,6 +1208,11 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
>  		if (READ_ONCE(req->iopoll_completed))
>  			break;
>  
> +		if (ctx->flags & IORING_SETUP_HY_POLL) {
> +			ret = iouring_hybrid_poll(req, &iob, poll_flags);
> +			goto comb;
> +		}

comb?

> +
>  		if (req->opcode == IORING_OP_URING_CMD) {
>  			struct io_uring_cmd *ioucmd;
>  
> @@ -1156,6 +1224,7 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
>  
>  			ret = file->f_op->iopoll(&rw->kiocb, &iob, poll_flags);
>  		}
> +comb:
>  		if (unlikely(ret < 0))
>  			return ret;
>  		else if (ret)

-- 
Jens Axboe


