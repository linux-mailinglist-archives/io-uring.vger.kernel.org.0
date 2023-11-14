Return-Path: <io-uring+bounces-87-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD2FD7EB983
	for <lists+io-uring@lfdr.de>; Tue, 14 Nov 2023 23:39:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D4331B20AEF
	for <lists+io-uring@lfdr.de>; Tue, 14 Nov 2023 22:39:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E44026ACF;
	Tue, 14 Nov 2023 22:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="wVNzQfxl";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="nN3okgEE"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CAD33063
	for <io-uring@vger.kernel.org>; Tue, 14 Nov 2023 22:39:27 +0000 (UTC)
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF576DD
	for <io-uring@vger.kernel.org>; Tue, 14 Nov 2023 14:39:25 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CA3F221E10;
	Tue, 14 Nov 2023 22:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1700001563; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UzGi1p2Va37MtprX6t78yMZe0bCypD2bw9ZB1l59LVQ=;
	b=wVNzQfxlxq3y9ZvFdaSA/U0IsZm8vTj11YIaAdGPRcyriTogELlOmmw8pqDKVjChDhnzsi
	qJNVkPi2rqZXyIsvNQv7UyJqizCwh98uQWC2GJnhnD9tnpCelinw2zScdzxT9cvCyWQM+T
	Qz9IHfiVfz3GXr7qD5Cd3FYPiKUufZ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1700001563;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UzGi1p2Va37MtprX6t78yMZe0bCypD2bw9ZB1l59LVQ=;
	b=nN3okgEECga6CZSzFshpGqOam7aWHEZD3JNHMjmqmPLIUS/NaBCabkdBo6cZ8cNEwIUtL7
	nFtR3/rSMONMRZCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
	(No client certificate requested)
	by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 93ACD13460;
	Tue, 14 Nov 2023 22:39:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
	by imap2.suse-dmz.suse.de with ESMTPSA
	id ApmGHhv3U2XSGQAAMHmgww
	(envelope-from <krisman@suse.de>); Tue, 14 Nov 2023 22:39:23 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>,  Pavel Begunkov
 <asml.silence@gmail.com>
Subject: Re: [PATCH v2] io_uring/fdinfo: remove need for sqpoll lock for
 thread/pid retrieval
In-Reply-To: <202966f7-3e79-4913-a7db-6b2fc230dda7@kernel.dk> (Jens Axboe's
	message of "Tue, 14 Nov 2023 10:09:15 -0700")
References: <202966f7-3e79-4913-a7db-6b2fc230dda7@kernel.dk>
Date: Tue, 14 Nov 2023 17:39:22 -0500
Message-ID: <871qcs3qp1.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -7.10
X-Spamd-Result: default: False [-7.10 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[3];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 TAGGED_RCPT(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-3.00)[-1.000];
	 BAYES_HAM(-3.00)[100.00%];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 TO_DN_ALL(0.00)[];
	 NEURAL_HAM_SHORT(-1.00)[-1.000];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com];
	 RCVD_COUNT_TWO(0.00)[2];
	 RCVD_TLS_ALL(0.00)[]

Jens Axboe <axboe@kernel.dk> writes:

> A previous commit added a trylock for getting the SQPOLL thread info via
> fdinfo, but this introduced a regression where we often fail to get it if
> the thread is busy. For that case, we end up not printing the current CPU
> and PID info.
>
> Rather than rely on this lock, just print the pid we already stored in
> the io_sq_data struct, and ensure we update the current CPU every time we
> are going to sleep. The latter won't potentially be 100% accurate, but
> that wasn't the case before either as the task can get migrated at any
> time unless it has been pinned at creation time.
>
> We retain keeping the io_sq_data dereference inside the ctx->uring_lock,
> as it has always been, as destruction of the thread and data happen below
> that. We could make this RCU safe, but there's little point in doing that.
>
> With this, we always print the last valid information we had, rather than
> have spurious outputs with missing information.
>
> Fixes: 7644b1a1c9a7 ("io_uring/fdinfo: lock SQ thread while retrieving thread cpu/pid")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> v2: actually remember to use the cached values... also update ->sq_cpu
>     when we initially set it up, if it's not pinned to a given CPU.
>
> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
> index f04a43044d91..976e9500f651 100644
> --- a/io_uring/fdinfo.c
> +++ b/io_uring/fdinfo.c
> @@ -145,13 +145,8 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
>  	if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
>  		struct io_sq_data *sq = ctx->sq_data;
>  
> -		if (mutex_trylock(&sq->lock)) {
> -			if (sq->thread) {
> -				sq_pid = task_pid_nr(sq->thread);
> -				sq_cpu = task_cpu(sq->thread);
> -			}
> -			mutex_unlock(&sq->lock);
> -		}
> +		sq_pid = sq->task_pid;
> +		sq_cpu = sq->sq_cpu;
>  	}
>  
>  	seq_printf(m, "SqThread:\t%d\n", sq_pid);
> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index bd6c2c7959a5..ecb00322a4e5 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -229,10 +229,12 @@ static int io_sq_thread(void *data)
>  	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
>  	set_task_comm(current, buf);
>  
> -	if (sqd->sq_cpu != -1)
> +	if (sqd->sq_cpu != -1) {
>  		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
> -	else
> +	} else {
>  		set_cpus_allowed_ptr(current, cpu_online_mask);
> +		sqd->sq_cpu = task_cpu(current);
> +	}
>  
>  	mutex_lock(&sqd->lock);
>  	while (1) {
> @@ -291,6 +293,7 @@ static int io_sq_thread(void *data)
>  			}
>  
>  			if (needs_sched) {
> +				sqd->sq_cpu = task_cpu(current);

Don't you also need to update sqd->sq_cpu in io_sqd_handle_event before
releasing the lock?  sqpoll might get migrated after the following
schedule and then parked, in which case sqd->sq_cpu will not be up to
date for a while.

Other than that, I think the patch is fine.

>  				mutex_unlock(&sqd->lock);
>  				schedule();
>  				mutex_lock(&sqd->lock);

-- 
Gabriel Krisman Bertazi

