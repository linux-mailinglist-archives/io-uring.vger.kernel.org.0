Return-Path: <io-uring+bounces-12966-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OKM1DTc502kwgAcAu9opvQ
	(envelope-from <io-uring+bounces-12966-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Apr 2026 06:40:23 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 86A813A177A
	for <lists+io-uring@lfdr.de>; Mon, 06 Apr 2026 06:40:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 69EBB3018748
	for <lists+io-uring@lfdr.de>; Mon,  6 Apr 2026 04:39:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5C4D34A796;
	Mon,  6 Apr 2026 04:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CvZmSErQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F4B3290AA;
	Mon,  6 Apr 2026 04:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775450372; cv=none; b=WHi/1bQre0cAodHDmmXnzgbKIh27pPwpDWk/vuva+hDliMx6/S9vARQ07ymwok3YJzwGW63HY7sO3yE2M/iFqOLGwhIBQ9Ya1r4PJmoRLnHom988I+qelTTXjkQfrN6t35PXtqkQCnc5+HcQst8oCc01NNZWjm9GwT3nwUS+sLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775450372; c=relaxed/simple;
	bh=5wFMBkbNcWEKQfciEN3tPppkZZ/hT+uEl/M30p0cKnw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d4t6l4QUw4XCVnqotBwD+5mnZ1HBcD89MAOvGS1puDl7p0MojqcjXhMy9z6C9sUErXZSFGE2u5qVKexmdbXI0+tHc41bWOuDu0itPstBJZHiLHr5YnZCnLhYyQeL+kCEU7vioqdbO0zjS5RPwRPoWVEBw59Hwbqbqstnp/x9Hho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CvZmSErQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A57C2BCB0;
	Mon,  6 Apr 2026 04:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775450372;
	bh=5wFMBkbNcWEKQfciEN3tPppkZZ/hT+uEl/M30p0cKnw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CvZmSErQmK36/0I5I7bxseumwyYM8Pfyi/Rgt7KEzw3FBvxJPh+VyxwBqHMEgIZXt
	 zSlE+ckWVC1KOfaPI3XPt99y2Zb7rN/f+rj+v0dNoK+leVbnmOyIUpH0ywYC+7YkJX
	 lwWa4wp4hUyt9lkPl73ZsIQNqWKdAU23UH4kiwMBDO8S5dpChTBhJJCBFjgDv2DRPf
	 287mEFJoalKjwvoCZTTZNjhLXKfYk3YcyS6mghu981FLos91SrpB99wIpwr9AFsghx
	 WhDoXwwADW/P8thTeLNN9y9S5t538mwN5Ie99nr+0WrFQuP7ueXi5igrH9iv8Q7mL4
	 S6IiH5WGaVpTw==
Date: Sun, 5 Apr 2026 21:39:31 -0700
From: Kees Cook <kees@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kusaram Devineni <kusaram@devineni.in>,
	Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH] signalfd: don't dequeue the forced fatal signals
Message-ID: <202604052136.440E9CFA44@keescook>
References: <adKJMRkQJXEwHs-j@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adKJMRkQJXEwHs-j@redhat.com>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12966-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kees@kernel.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,devineni.in:email]
X-Rspamd-Queue-Id: 86A813A177A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sun, Apr 05, 2026 at 06:09:21PM +0200, Oleg Nesterov wrote:
> These signals should act like SIGKILL, in that userspace must never dequeue
> them. But as Kusaram explains, io_uring-driven signalfd_read_iter() called
> from get_signal() -> task_work_run() paths can do this before get_signal()
> has a chance to dequeue such a signal and notice SA_IMMUTABLE.
> 
> Change signalfd_poll() and signalfd_dequeue() to add pending SA_IMMUTABLE
> signals to ctx->sigmask.
> 
> Cc: stable@kernel.org
> Reported-by: syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=0a4c46806941297fecb9
> Tested-by: syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/all/69d122fd.050a0220.2dbe29.001c.GAE@google.com/
> Suggested-by: Kusaram Devineni <kusaram@devineni.in>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Kees Cook <kees@kernel.org>

Who should take this? I'm happy to add it to my seccomp tree if akpm (or
maybe Christian wants it)?

-Kees

> ---
>  fs/signalfd.c | 28 ++++++++++++++++++++++------
>  1 file changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/signalfd.c b/fs/signalfd.c
> index dff53745e352..107a83336657 100644
> --- a/fs/signalfd.c
> +++ b/fs/signalfd.c
> @@ -48,17 +48,30 @@ static int signalfd_release(struct inode *inode, struct file *file)
>  	return 0;
>  }
>  
> +static void mk_sigmask(struct signalfd_ctx *ctx, sigset_t *sigmask)
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
> +	mk_sigmask(ctx, &sigmask);
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
> +	mk_sigmask(ctx, &sigmask);
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
> +		mk_sigmask(ctx, &sigmask);
>  	}
>  	spin_unlock_irq(&current->sighand->siglock);
>  
> -- 
> 2.52.0
> 
> 

-- 
Kees Cook

