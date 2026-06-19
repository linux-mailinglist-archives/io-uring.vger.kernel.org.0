Return-Path: <io-uring+bounces-13793-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 9OmWNExMNWo8rwYAu9opvQ
	(envelope-from <io-uring+bounces-13793-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 16:03:56 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D1B8B6A63F2
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 16:03:55 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PjD6qjkf;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13793-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13793-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 380263015D59
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 14:03:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AAF2361DCB;
	Fri, 19 Jun 2026 14:03:24 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D3428CF6F
	for <io-uring@vger.kernel.org>; Fri, 19 Jun 2026 14:03:22 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781877804; cv=none; b=FsehK84+0C7lm3LRsuTMjFpS7FEfoxnBGpwFAf0BBwnw9HYC94uOk9WFldYTV4g8I9ppPN9/nMaH2UkHBNUaErP6wYm3URD0/g3XfFZKJvaPm5VETkRf41PyC1BdW5k2cQTLVxm0MLTnHlbYJTxJWrvIFIgdV4hE/X7xDKt6PoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781877804; c=relaxed/simple;
	bh=hi720SOjNMqZAfbk6PAQ+05T5pKF39tbt9W4zea7Cxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rc1xELXBlXsoRUU9RtCoNfV0VbbeCq+jJCsACYGdeL5uns+4/yPnSKMG7efoJWp5o20H2gYXAxuYEn4yKV58u0urxsdAMYxw21wUWKVwMZHX8ownIykPZQDluIxjy57UvgJGPdDZv4w+eJ8hU/Edr0CoQwO3dcy8/K/yW3fuhhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PjD6qjkf; arc=none smtp.client-ip=170.10.129.124
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781877802;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gTWlObZIKVVnnVTmmWbmsMewcq7XfNONPw+/ZJWcgRM=;
	b=PjD6qjkfjFt/BZpN/I7yyaHBga7O8hKNLYEfvEgjPkaoMCvlcHXixwUWPqsEp+z34/Grpy
	k5ptNd2PTutKW/CzLg4S6ewxYC/y879YN1cm4XC8cpbvaKx37VWG2g2f0hpQmCWn03smkP
	tA5YacbiZcXrqGpXUaLm1oN9fRfioyo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-459-YXvW-4zRO52wkKADgvpE3w-1; Fri,
 19 Jun 2026 10:03:18 -0400
X-MC-Unique: YXvW-4zRO52wkKADgvpE3w-1
X-Mimecast-MFC-AGG-ID: YXvW-4zRO52wkKADgvpE3w_1781877797
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 37832195DBAC;
	Fri, 19 Jun 2026 14:03:17 +0000 (UTC)
Received: from fedora (unknown [10.44.34.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 7799A195608C;
	Fri, 19 Jun 2026 14:03:14 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Fri, 19 Jun 2026 16:03:16 +0200 (CEST)
Date: Fri, 19 Jun 2026 16:03:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <kees@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Cc: Kusaram Devineni <kusaram@devineni.in>, Jens Axboe <axboe@kernel.dk>,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v2] signalfd: don't dequeue the forced fatal signals
Message-ID: <ajVMIG0imWthpYEU@redhat.com>
References: <adKJMRkQJXEwHs-j@redhat.com>
 <202604052136.440E9CFA44@keescook>
 <adO3HG8bvwRPcmte@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adO3HG8bvwRPcmte@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13793-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:akpm@linux-foundation.org,m:kees@kernel.org,m:brauner@kernel.org,m:kusaram@devineni.in,m:axboe@kernel.dk,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[oleg@redhat.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[oleg@redhat.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: D1B8B6A63F2

It seems that this fix is going to be lost ;)

Can anyone pick it up?

Oleg.

On 04/06, Oleg Nesterov wrote:
>
> These signals should act like SIGKILL, in that userspace must never dequeue
> them. But as Kusaram explains, io_uring-driven signalfd_read_iter() called
> from get_signal() -> task_work_run() paths can do this before get_signal()
> has a chance to dequeue such a signal and notice SA_IMMUTABLE.
> 
> Change signalfd_poll() and signalfd_dequeue() to add pending SA_IMMUTABLE
> signals to ctx->sigmask.
> 
> TODO: we should probably change force_sig_info_to_task(HANDLER_EXIT) to
> make fatal_signal_pending() true, or add a fatal_or_forced_signal_pending()
> helper. Then signalfd_dequeue() could just return -EINTR in this case.
> This also makes sense for get_signal(), which could prioritize a fatal
> signal sent by (say) force_sig_seccomp(force_coredump => true), just like
> it already prioritizes SIGKILL.
> 
> Cc: stable@kernel.org
> Reported-by: syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=0a4c46806941297fecb9
> Tested-by: syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/all/69d122fd.050a0220.2dbe29.001c.GAE@google.com/
> Suggested-by: Kusaram Devineni <kusaram@devineni.in>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Reviewed-by: Kees Cook <kees@kernel.org>
> ---
>  fs/signalfd.c | 28 ++++++++++++++++++++++------
>  1 file changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/signalfd.c b/fs/signalfd.c
> index dff53745e352..22bc0870a824 100644
> --- a/fs/signalfd.c
> +++ b/fs/signalfd.c
> @@ -48,17 +48,30 @@ static int signalfd_release(struct inode *inode, struct file *file)
>  	return 0;
>  }
>  
> +static void refine_sigmask(struct signalfd_ctx *ctx, sigset_t *sigmask)
> +{
> +	struct k_sigaction *k = current->sighand->action;
> +	int n;
> +
> +	*sigmask = ctx->sigmask;
> +	for (n = 1; n <= _NSIG; ++n, ++k) {
> +		if (k->sa.sa_flags & SA_IMMUTABLE)
> +			sigaddset(sigmask, n);
> +	}
> +}
> +
>  static __poll_t signalfd_poll(struct file *file, poll_table *wait)
>  {
>  	struct signalfd_ctx *ctx = file->private_data;
>  	__poll_t events = 0;
> +	sigset_t sigmask;
>  
>  	poll_wait(file, &current->sighand->signalfd_wqh, wait);
>  
>  	spin_lock_irq(&current->sighand->siglock);
> -	if (next_signal(&current->pending, &ctx->sigmask) ||
> -	    next_signal(&current->signal->shared_pending,
> -			&ctx->sigmask))
> +	refine_sigmask(ctx, &sigmask);
> +	if (next_signal(&current->pending, &sigmask) ||
> +	    next_signal(&current->signal->shared_pending, &sigmask))
>  		events |= EPOLLIN;
>  	spin_unlock_irq(&current->sighand->siglock);
>  
> @@ -155,11 +168,13 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, kernel_siginfo_t *info
>  				int nonblock)
>  {
>  	enum pid_type type;
> -	ssize_t ret;
>  	DECLARE_WAITQUEUE(wait, current);
> +	sigset_t sigmask;
> +	ssize_t ret;
>  
>  	spin_lock_irq(&current->sighand->siglock);
> -	ret = dequeue_signal(&ctx->sigmask, info, &type);
> +	refine_sigmask(ctx, &sigmask);
> +	ret = dequeue_signal(&sigmask, info, &type);
>  	switch (ret) {
>  	case 0:
>  		if (!nonblock)
> @@ -174,7 +189,7 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, kernel_siginfo_t *info
>  	add_wait_queue(&current->sighand->signalfd_wqh, &wait);
>  	for (;;) {
>  		set_current_state(TASK_INTERRUPTIBLE);
> -		ret = dequeue_signal(&ctx->sigmask, info, &type);
> +		ret = dequeue_signal(&sigmask, info, &type);
>  		if (ret != 0)
>  			break;
>  		if (signal_pending(current)) {
> @@ -184,6 +199,7 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, kernel_siginfo_t *info
>  		spin_unlock_irq(&current->sighand->siglock);
>  		schedule();
>  		spin_lock_irq(&current->sighand->siglock);
> +		refine_sigmask(ctx, &sigmask);
>  	}
>  	spin_unlock_irq(&current->sighand->siglock);
>  
> -- 
> 2.52.0
> 


