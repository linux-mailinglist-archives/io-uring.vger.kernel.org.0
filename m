Return-Path: <io-uring+bounces-10062-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ABA9BF1F66
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 17:00:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 9FEBE4F81EE
	for <lists+io-uring@lfdr.de>; Mon, 20 Oct 2025 14:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E8921514F7;
	Mon, 20 Oct 2025 14:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="YtOXs7oQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="ZQpFsF8P";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="x+IiLlT8";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="w2bAipIC"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17E722FDE8
	for <io-uring@vger.kernel.org>; Mon, 20 Oct 2025 14:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760972364; cv=none; b=QfCTvjqqiP9CeGw6BYxRWk4ZlXE/DZsL6iKkNHJRZSW7ZIStvokxcAhAncSdT+4dS3Nd9IG18YuRryYC2FPNikJvwAftrLPqU1+o69r3Fa2fjqnZdof42Rm8WVKXqYNmzPc/u5nCyjt5mOEolo9cxWa8VDT9qRl2cdhyKEF5apc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760972364; c=relaxed/simple;
	bh=4P92wCeR41SZEJqOQWM0k0iMdCNiZsHkvIOsyi2d67E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=bs3af4QzgeAUh47fyOtISILFemFk9XOWO4sRKyNXTkdZHcjWLRNtp4BQGH+Y4CrHn2yAMKRSNIbv6Xhx7NYKR8mZgnM8x4Qwg8SGKgKXNDtEJCeenCo7SmNpOCELBUBeEQ/+IBuXAuuZHNRAcVp4ySVK0BGlyN6J+wZh99fRaDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=YtOXs7oQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=ZQpFsF8P; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=x+IiLlT8; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=w2bAipIC; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BCB17211CA;
	Mon, 20 Oct 2025 14:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760972355; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HhY91SCBW6JS0zb9FLXtm1RLUvVQ7/Vrbj1VX7bL0Do=;
	b=YtOXs7oQKfUHZa0cGU9juCUFHzGh+NX3rfQZO9etKv0Ml+4Ti21YM4rNAxfKi65W0mDdEw
	5f8bE9TBXscBXkfr2KNmX+4ASpfCbNbRvNbTJARVcfhz32tDs9Jq0syNdKAH+hh+XUlSQ8
	mHAu/TRxrxsae18FDROBKMbKXdqeC/8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760972355;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HhY91SCBW6JS0zb9FLXtm1RLUvVQ7/Vrbj1VX7bL0Do=;
	b=ZQpFsF8PGsvs13c2pA8sUX7S+Q2HtBJGZ5LjkSwBvTHZSuGqFSraVq95mSLm1mINftUUuS
	rQ+GcC/mHcPNUCBg==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=x+IiLlT8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=w2bAipIC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1760972351; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HhY91SCBW6JS0zb9FLXtm1RLUvVQ7/Vrbj1VX7bL0Do=;
	b=x+IiLlT8/Q62WsOR7sC7dejKM270xrVAme/KF4xDoo15kKxF0XNochVlZ4U5zfM/N9aQTk
	8LrgOJjEG3h7RFGSZyDyMUwI4JkBOx5n3td9duZ4CYCV1OF/UOiQzIeVX6nEIM+AM704mL
	dMcKHpAg2Js94idVn5W1CvLdCqiJFFE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1760972351;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HhY91SCBW6JS0zb9FLXtm1RLUvVQ7/Vrbj1VX7bL0Do=;
	b=w2bAipICDwsuQgvYKw+VMt4alZqpUIGFe7f1oWwZ1O73voxGNQFKULHLptGAioAC8yr6gD
	wv5tWN+BsX4GVRDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6AC5D13AAD;
	Mon, 20 Oct 2025 14:59:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OwchDj9O9mirQAAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 20 Oct 2025 14:59:11 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Fengnan Chang <changfengnan@bytedance.com>
Cc: axboe@kernel.dk,  xiaobing.li@samsung.com,  asml.silence@gmail.com,
  io-uring@vger.kernel.org,  Diangang Li <lidiangang@bytedance.com>
Subject: Re: [PATCH v2] io_uring: add IORING_SETUP_SQTHREAD_STATS flag to
 enable sqthread stats collection
In-Reply-To: <20251020113031.2135-1-changfengnan@bytedance.com> (Fengnan
	Chang's message of "Mon, 20 Oct 2025 19:30:31 +0800")
References: <20251020113031.2135-1-changfengnan@bytedance.com>
Date: Mon, 20 Oct 2025 10:59:05 -0400
Message-ID: <87ldl539hi.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: BCB17211CA
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-3.01 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	FREEMAIL_CC(0.00)[kernel.dk,samsung.com,gmail.com,vger.kernel.org,bytedance.com];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.de:dkim]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -3.01
X-Spam-Level: 

Fengnan Chang <changfengnan@bytedance.com> writes:

> In previous versions, getrusage was always called in sqrthread
> to count work time, but this could incur some overhead.
> This patch turn off stats by default, and introduces a new flag
> IORING_SETUP_SQTHREAD_STATS that allows user to enable the
> collection of statistics in the sqthread.
>
> ./t/io_uring -p1 -d128 -b4096 -s32 -c1 -F1 -B1 -R1 -X1 -n1 ./testfile
> IOPS base: 570K, patch: 590K
>
> ./t/io_uring -p1 -d128 -b4096 -s32 -c1 -F1 -B1 -R1 -X1 -n1 /dev/nvme1n1
> IOPS base: 826K, patch: 889K
>
> Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
> Reviewed-by: Diangang Li <lidiangang@bytedance.com>
> ---
>  include/uapi/linux/io_uring.h |  5 +++++
>  io_uring/fdinfo.c             | 15 ++++++++++-----
>  io_uring/io_uring.h           |  3 ++-
>  io_uring/sqpoll.c             | 10 +++++++---
>  io_uring/sqpoll.h             |  1 +
>  5 files changed, 25 insertions(+), 9 deletions(-)
>
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 263bed13473e..8c5cb9533950 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -231,6 +231,11 @@ enum io_uring_sqe_flags_bit {
>   */
>  #define IORING_SETUP_CQE_MIXED		(1U << 18)
>  
> +/*
> + * Enable SQPOLL thread stats collection
> + */
> +#define IORING_SETUP_SQTHREAD_STATS	(1U << 19)
> +
>  enum io_uring_op {
>  	IORING_OP_NOP,
>  	IORING_OP_READV,
> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
> index ff3364531c77..4c532e414255 100644
> --- a/io_uring/fdinfo.c
> +++ b/io_uring/fdinfo.c
> @@ -154,13 +154,16 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
>  		if (tsk) {
>  			get_task_struct(tsk);
>  			rcu_read_unlock();
> -			getrusage(tsk, RUSAGE_SELF, &sq_usage);
> +			if (sq->enable_work_time_stat)
> +				getrusage(tsk, RUSAGE_SELF, &sq_usage);
>  			put_task_struct(tsk);

If the usage statistics are disabled, you don't need to acquire and drop
the task_struct reference any longer.  you can move the get/put_task_struct
into the if.

>  			sq_pid = sq->task_pid;
>  			sq_cpu = sq->sq_cpu;
> -			sq_total_time = (sq_usage.ru_stime.tv_sec * 1000000
> +			if (sq->enable_work_time_stat) {
> +				sq_total_time = (sq_usage.ru_stime.tv_sec * 1000000
>  					 + sq_usage.ru_stime.tv_usec);
> -			sq_work_time = sq->work_time;
> +				sq_work_time = sq->work_time;
> +			}
>  		} else {
>  			rcu_read_unlock();
>  		}
> @@ -168,8 +171,10 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
>  
>  	seq_printf(m, "SqThread:\t%d\n", sq_pid);
>  	seq_printf(m, "SqThreadCpu:\t%d\n", sq_cpu);
> -	seq_printf(m, "SqTotalTime:\t%llu\n", sq_total_time);
> -	seq_printf(m, "SqWorkTime:\t%llu\n", sq_work_time);
> +	if (ctx->flags & IORING_SETUP_SQTHREAD_STATS) {
> +		seq_printf(m, "SqTotalTime:\t%llu\n", sq_total_time);
> +		seq_printf(m, "SqWorkTime:\t%llu\n", sq_work_time);
> +	}

It works, but it is weird that you gate the writing of sq_total_time on
(sq->enable_work_time_stat) and then, the display of it on (ctx->flags &
IORING_SETUP_SQTHREAD_STATS).  Since a sqpoll can attend to more than
one ctx, I'd just check ctx->flags & IORING_SETUP_SQTHREAD_STATS
in both places in this function.

>  	seq_printf(m, "UserFiles:\t%u\n", ctx->file_table.data.nr);
>  	for (i = 0; i < ctx->file_table.data.nr; i++) {
>  		struct file *f = NULL;
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index 46d9141d772a..949dc7cba111 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -54,7 +54,8 @@
>  			IORING_SETUP_REGISTERED_FD_ONLY |\
>  			IORING_SETUP_NO_SQARRAY |\
>  			IORING_SETUP_HYBRID_IOPOLL |\
> -			IORING_SETUP_CQE_MIXED)
> +			IORING_SETUP_CQE_MIXED |\
> +			IORING_SETUP_SQTHREAD_STATS)
>  
>  #define IORING_ENTER_FLAGS (IORING_ENTER_GETEVENTS |\
>  			IORING_ENTER_SQ_WAKEUP |\
> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index a3f11349ce06..46bcd4854abc 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -161,6 +161,7 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p,
>  	mutex_init(&sqd->lock);
>  	init_waitqueue_head(&sqd->wait);
>  	init_completion(&sqd->exited);
> +	sqd->enable_work_time_stat = false;
>  	return sqd;
>  }
>  
> @@ -317,7 +318,8 @@ static int io_sq_thread(void *data)
>  		}
>  
>  		cap_entries = !list_is_singular(&sqd->ctx_list);
> -		getrusage(current, RUSAGE_SELF, &start);
> +		if (sqd->enable_work_time_stat)
> +			getrusage(current, RUSAGE_SELF, &start);
>  		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
>  			int ret = __io_sq_thread(ctx, cap_entries);
>  
> @@ -333,7 +335,8 @@ static int io_sq_thread(void *data)
>  
>  		if (sqt_spin || !time_after(jiffies, timeout)) {
>  			if (sqt_spin) {
> -				io_sq_update_worktime(sqd, &start);
> +				if (sqd->enable_work_time_stat)
> +					io_sq_update_worktime(sqd, &start);
>  				timeout = jiffies + sqd->sq_thread_idle;
>  			}
>  			if (unlikely(need_resched())) {
> @@ -445,7 +448,8 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
>  			ret = PTR_ERR(sqd);
>  			goto err;
>  		}
> -
> +		if (ctx->flags & IORING_SETUP_SQTHREAD_STATS)
> +			sqd->enable_work_time_stat = true;
>  		ctx->sq_creds = get_current_cred();
>  		ctx->sq_data = sqd;
>  		ctx->sq_thread_idle = msecs_to_jiffies(p->sq_thread_idle);
> diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
> index b83dcdec9765..55f2e4d46d54 100644
> --- a/io_uring/sqpoll.h
> +++ b/io_uring/sqpoll.h
> @@ -19,6 +19,7 @@ struct io_sq_data {
>  	u64			work_time;
>  	unsigned long		state;
>  	struct completion	exited;
> +	bool			enable_work_time_stat;
>  };
>  
>  int io_sq_offload_create(struct io_ring_ctx *ctx, struct io_uring_params *p);

-- 
Gabriel Krisman Bertazi

