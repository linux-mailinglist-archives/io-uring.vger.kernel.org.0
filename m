Return-Path: <io-uring+bounces-10096-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AEDC8BF9418
	for <lists+io-uring@lfdr.de>; Wed, 22 Oct 2025 01:36:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23F4F3BADC3
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 23:35:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29675248F77;
	Tue, 21 Oct 2025 23:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="pQHt5KW6";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2y52c06v";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="oUD1abxb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="n2EUCtv6"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE301350A02
	for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 23:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761089745; cv=none; b=seSlP2s0X0FRd29+gKqPT88T5g2AsGBIB916bX+gT0CXQmWbeEad++s/AVySNhcjshO96q394tsjgoA8ZRQiabcwzFdm65ogE7TTw2auzdivS0jftp4DoMXA/JjlzWw7f9pY/qIAB2tO40iIALMHSz47HHhkkKjNbYi4swB4IMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761089745; c=relaxed/simple;
	bh=2YK7GPQt1SqrKPBY4DsdMBhtOmWB0kO1WJr90imRync=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Ag7pQURbhcR9NzUboZJWqs5UUr69SJ9h8RiA5+y1wMP+LfQS4k6USIHS+teZUQxnDenSZem++C4lR8OdfLCAmXE7AOZw9bOr/MPh3/cm+Ki6DgIh7oTHXD9GXXblt01pg1E4XuIeuS8UHALXtIDEHYNVTiTxizZu1T/6JqmDBpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=pQHt5KW6; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2y52c06v; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=oUD1abxb; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=n2EUCtv6; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DCD7F1F38D;
	Tue, 21 Oct 2025 23:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761089737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sslgU3Aaga8h6ljL3VJZQlD5jXYA0Jpb3iMuKNK7zcU=;
	b=pQHt5KW69nZRn2rC+eV/nQbRVpkKzTlYeANzxy9OTLaRIpnZVYrS7GKUUNUFEiYcDQsYG8
	Loc6Hlqx9ZZSX3zGEaz7Zg9ESFxMOVYG2boKi4DezTKsGfddBRxybMejZC7t6aBjhn+JA5
	Ny+L9eF6gu/uNRQzdkGQywS4pn4HGVU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761089737;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sslgU3Aaga8h6ljL3VJZQlD5jXYA0Jpb3iMuKNK7zcU=;
	b=2y52c06v62lmNvCLX8Qa7X+C95LaCgshtri232bKhu7EGNEZ2nkqVuiwmOEVT9thQ4w2Fz
	tjZKhOpwsqfK1NCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oUD1abxb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=n2EUCtv6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1761089732; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sslgU3Aaga8h6ljL3VJZQlD5jXYA0Jpb3iMuKNK7zcU=;
	b=oUD1abxbWVB4NmaFLyKq/DLc8a60S73gcSvegW4I2/QFzrs/605dAbc7yJ5SSPpZmfzWMz
	G51QDlB5RDmmD/IHiusjRAGeKiyy5v/HeMsjyai1oK3AmU6V/637gtgg8u6yHmqVhhv32P
	Ms78Mf/U7mIYFwzQhLCC6n8n9aU99ZI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1761089732;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sslgU3Aaga8h6ljL3VJZQlD5jXYA0Jpb3iMuKNK7zcU=;
	b=n2EUCtv6OmtbAUk44AXGKzw9tAE29liOBUZL27JLDNNi9FBpGvWVJDSFDKefFzmMC49rpC
	fm96wd7+KwOGzlBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8898D139D2;
	Tue, 21 Oct 2025 23:35:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id y2v4FMQY+GjcaQAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 21 Oct 2025 23:35:32 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,  changfengnan@bytedance.com,
  xiaobing.li@samsung.com,  lidiangang@bytedance.com,
  stable@vger.kernel.org
Subject: Re: [PATCH 1/2] io_uring/sqpoll: switch away from getrusage() for
 CPU accounting
In-Reply-To: <20251021175840.194903-2-axboe@kernel.dk> (Jens Axboe's message
	of "Tue, 21 Oct 2025 11:55:54 -0600")
References: <20251021175840.194903-1-axboe@kernel.dk>
	<20251021175840.194903-2-axboe@kernel.dk>
Date: Tue, 21 Oct 2025 19:35:30 -0400
Message-ID: <87cy6f25h9.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: DCD7F1F38D
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from,2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim]
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spam-Level: 

Jens Axboe <axboe@kernel.dk> writes:

> getrusage() does a lot more than what the SQPOLL accounting needs, the
> latter only cares about (and uses) the stime. Rather than do a full
> RUSAGE_SELF summation, just query the used stime instead.
>
> Cc: stable@vger.kernel.org
> Fixes: 3fcb9d17206e ("io_uring/sqpoll: statistics of the true utilization of sq threads")
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  io_uring/fdinfo.c |  9 +++++----
>  io_uring/sqpoll.c | 34 ++++++++++++++++++++--------------
>  io_uring/sqpoll.h |  1 +
>  3 files changed, 26 insertions(+), 18 deletions(-)
>
> diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
> index ff3364531c77..966e06b078f6 100644
> --- a/io_uring/fdinfo.c
> +++ b/io_uring/fdinfo.c
> @@ -59,7 +59,6 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
>  {
>  	struct io_overflow_cqe *ocqe;
>  	struct io_rings *r = ctx->rings;
> -	struct rusage sq_usage;
>  	unsigned int sq_mask = ctx->sq_entries - 1, cq_mask = ctx->cq_entries - 1;
>  	unsigned int sq_head = READ_ONCE(r->sq.head);
>  	unsigned int sq_tail = READ_ONCE(r->sq.tail);
> @@ -152,14 +151,16 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
>  		 * thread termination.
>  		 */
>  		if (tsk) {
> +			struct timespec64 ts;
> +
>  			get_task_struct(tsk);
>  			rcu_read_unlock();
> -			getrusage(tsk, RUSAGE_SELF, &sq_usage);
> +			ts = io_sq_cpu_time(tsk);
>  			put_task_struct(tsk);
>  			sq_pid = sq->task_pid;
>  			sq_cpu = sq->sq_cpu;
> -			sq_total_time = (sq_usage.ru_stime.tv_sec * 1000000
> -					 + sq_usage.ru_stime.tv_usec);
> +			sq_total_time = (ts.tv_sec * 1000000
> +					 + ts.tv_nsec / 1000);
>  			sq_work_time = sq->work_time;
>  		} else {
>  			rcu_read_unlock();
> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> index a3f11349ce06..8705b0aa82e0 100644
> --- a/io_uring/sqpoll.c
> +++ b/io_uring/sqpoll.c
> @@ -11,6 +11,7 @@
>  #include <linux/audit.h>
>  #include <linux/security.h>
>  #include <linux/cpuset.h>
> +#include <linux/sched/cputime.h>
>  #include <linux/io_uring.h>
>  
>  #include <uapi/linux/io_uring.h>
> @@ -169,6 +170,22 @@ static inline bool io_sqd_events_pending(struct io_sq_data *sqd)
>  	return READ_ONCE(sqd->state);
>  }
>  
> +struct timespec64 io_sq_cpu_time(struct task_struct *tsk)
> +{
> +	u64 utime, stime;
> +
> +	task_cputime_adjusted(tsk, &utime, &stime);
> +	return ns_to_timespec64(stime);
> +}
> +
> +static void io_sq_update_worktime(struct io_sq_data *sqd, struct timespec64 start)
> +{
> +	struct timespec64 ts;
> +
> +	ts = timespec64_sub(io_sq_cpu_time(current), start);
> +	sqd->work_time += ts.tv_sec * 1000000 + ts.tv_nsec / 1000;
> +}

Hi Jens,

Patch looks good. I'd just mention you are converting ns to timespec64,
just to convert it back to ms when writing to sqd->work_time and
sq_total_time.  I think wraparound is not a concern for
task_cputime_adjusted since this is the actual system cputime of a
single thread inside a u64.  So io_sq_cpu_time could just return ms
directly and io_sq_update_worktime would be trivial:

  sqd->work_time = io_sq_pu_time(current) - start.

Regardless:

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

Thanks,


-- 
Gabriel Krisman Bertazi

