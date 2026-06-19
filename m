Return-Path: <io-uring+bounces-13796-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id jcKEDf2qNWpe2wYAu9opvQ
	(envelope-from <io-uring+bounces-13796-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 22:47:57 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 873976A7B3D
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 22:47:56 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kMk3cXHu;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13796-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13796-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3C41F303FFBE
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 20:47:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 660DB35AC13;
	Fri, 19 Jun 2026 20:47:54 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A98305679;
	Fri, 19 Jun 2026 20:47:53 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781902074; cv=none; b=Gf/fAh+aLbIIaFXb7xhytRsWhaB/Vo3gU+wlFu/473IwRoJeyPAdkQIoW3bGpsIbu3sLFJoDXdovl39v6KsEvlCwZXozwHah+B3Ca1Zqz5fKrj5DvcO8qFHjOBeHqpdYcP2+ru+i43EV7UeCtuZv27nimwOdE9tFgu5oWNtymEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781902074; c=relaxed/simple;
	bh=ShzyKQcD/fORAt0e4n4OEY7UfiOZFwsOuiKAmPm5DdU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HIDqMU3whIWtSOucxQPysJn5sKOOZQchtBLVjS7/9Mjhvjs/mSuYhLpgz5eNJfQj7XK5rlN7BwBLOV6FHTc8/uFAFXHLXVE5Ii0fV4rDcY0FGM9fs7LCpROEs30KXlM8K0TaoXzsjIPPIIk7p98ciZyYLJ/hvlL98ZlRxRWf/QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kMk3cXHu; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0EC1F000E9;
	Fri, 19 Jun 2026 20:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781902073;
	bh=oMepAgFoiMAcYRoSAIlQ6epWJLgq46cFe3AvDVMIw4U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kMk3cXHuC2lghPQeYaKjrO+oNMGuOOMBJQX+4oeTxGkw377PY59NPaA23oqbfGuMT
	 s8VjPFh1iJVUgu0cptTommezQ5bAED7q3S5JzZVv8dezEdIKFpp//eJdwkAU55dCuR
	 4AF2BD5hWQhS1CThPPaCEFFO52iHTiPR84/R4YKmeWCKFVDdZzFTJnuu800VM6CUmg
	 3sWWyXkX94ExQ0d5XFQ/s1h+rCrBhbfJPd62CAci/NErzS1cPDsEZ5mm57jrvlCNP7
	 MLLiUD2zR4ZZOCpYjLpICPtQHYvVUxktXPQ476+NgD1N/7n7lfweaYtOXqpWH6j2ME
	 FmjOIvYjqbiYw==
Date: Fri, 19 Jun 2026 13:47:52 -0700
From: Kees Cook <kees@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Kusaram Devineni <kusaram@devineni.in>,
	Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH v2] signalfd: don't dequeue the forced fatal signals
Message-ID: <202606191347.85254DD62@keescook>
References: <adKJMRkQJXEwHs-j@redhat.com>
 <202604052136.440E9CFA44@keescook>
 <adO3HG8bvwRPcmte@redhat.com>
 <ajVMIG0imWthpYEU@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajVMIG0imWthpYEU@redhat.com>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:oleg@redhat.com,m:akpm@linux-foundation.org,m:brauner@kernel.org,m:kusaram@devineni.in,m:axboe@kernel.dk,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[kees@kernel.org,io-uring@vger.kernel.org];
	TAGGED_FROM(0.00)[bounces-13796-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kees@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,keescook:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 873976A7B3D

On Fri, Jun 19, 2026 at 04:03:12PM +0200, Oleg Nesterov wrote:
> It seems that this fix is going to be lost ;)

Eek; thanks for the reminder. If Christian doesn't beat me to it, I'll
grab this for -next after -rc2 so we can get some soak time.

-Kees

> 
> Can anyone pick it up?
> 
> Oleg.
> 
> On 04/06, Oleg Nesterov wrote:
> >
> > These signals should act like SIGKILL, in that userspace must never dequeue
> > them. But as Kusaram explains, io_uring-driven signalfd_read_iter() called
> > from get_signal() -> task_work_run() paths can do this before get_signal()
> > has a chance to dequeue such a signal and notice SA_IMMUTABLE.
> > 
> > Change signalfd_poll() and signalfd_dequeue() to add pending SA_IMMUTABLE
> > signals to ctx->sigmask.
> > 
> > TODO: we should probably change force_sig_info_to_task(HANDLER_EXIT) to
> > make fatal_signal_pending() true, or add a fatal_or_forced_signal_pending()
> > helper. Then signalfd_dequeue() could just return -EINTR in this case.
> > This also makes sense for get_signal(), which could prioritize a fatal
> > signal sent by (say) force_sig_seccomp(force_coredump => true), just like
> > it already prioritizes SIGKILL.
> > 
> > Cc: stable@kernel.org
> > Reported-by: syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=0a4c46806941297fecb9
> > Tested-by: syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com
> > Link: https://lore.kernel.org/all/69d122fd.050a0220.2dbe29.001c.GAE@google.com/
> > Suggested-by: Kusaram Devineni <kusaram@devineni.in>
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> > Reviewed-by: Kees Cook <kees@kernel.org>
> > ---
> >  fs/signalfd.c | 28 ++++++++++++++++++++++------
> >  1 file changed, 22 insertions(+), 6 deletions(-)
> > 
> > diff --git a/fs/signalfd.c b/fs/signalfd.c
> > index dff53745e352..22bc0870a824 100644
> > --- a/fs/signalfd.c
> > +++ b/fs/signalfd.c
> > @@ -48,17 +48,30 @@ static int signalfd_release(struct inode *inode, struct file *file)
> >  	return 0;
> >  }
> >  
> > +static void refine_sigmask(struct signalfd_ctx *ctx, sigset_t *sigmask)
> > +{
> > +	struct k_sigaction *k = current->sighand->action;
> > +	int n;
> > +
> > +	*sigmask = ctx->sigmask;
> > +	for (n = 1; n <= _NSIG; ++n, ++k) {
> > +		if (k->sa.sa_flags & SA_IMMUTABLE)
> > +			sigaddset(sigmask, n);
> > +	}
> > +}
> > +
> >  static __poll_t signalfd_poll(struct file *file, poll_table *wait)
> >  {
> >  	struct signalfd_ctx *ctx = file->private_data;
> >  	__poll_t events = 0;
> > +	sigset_t sigmask;
> >  
> >  	poll_wait(file, &current->sighand->signalfd_wqh, wait);
> >  
> >  	spin_lock_irq(&current->sighand->siglock);
> > -	if (next_signal(&current->pending, &ctx->sigmask) ||
> > -	    next_signal(&current->signal->shared_pending,
> > -			&ctx->sigmask))
> > +	refine_sigmask(ctx, &sigmask);
> > +	if (next_signal(&current->pending, &sigmask) ||
> > +	    next_signal(&current->signal->shared_pending, &sigmask))
> >  		events |= EPOLLIN;
> >  	spin_unlock_irq(&current->sighand->siglock);
> >  
> > @@ -155,11 +168,13 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, kernel_siginfo_t *info
> >  				int nonblock)
> >  {
> >  	enum pid_type type;
> > -	ssize_t ret;
> >  	DECLARE_WAITQUEUE(wait, current);
> > +	sigset_t sigmask;
> > +	ssize_t ret;
> >  
> >  	spin_lock_irq(&current->sighand->siglock);
> > -	ret = dequeue_signal(&ctx->sigmask, info, &type);
> > +	refine_sigmask(ctx, &sigmask);
> > +	ret = dequeue_signal(&sigmask, info, &type);
> >  	switch (ret) {
> >  	case 0:
> >  		if (!nonblock)
> > @@ -174,7 +189,7 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, kernel_siginfo_t *info
> >  	add_wait_queue(&current->sighand->signalfd_wqh, &wait);
> >  	for (;;) {
> >  		set_current_state(TASK_INTERRUPTIBLE);
> > -		ret = dequeue_signal(&ctx->sigmask, info, &type);
> > +		ret = dequeue_signal(&sigmask, info, &type);
> >  		if (ret != 0)
> >  			break;
> >  		if (signal_pending(current)) {
> > @@ -184,6 +199,7 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, kernel_siginfo_t *info
> >  		spin_unlock_irq(&current->sighand->siglock);
> >  		schedule();
> >  		spin_lock_irq(&current->sighand->siglock);
> > +		refine_sigmask(ctx, &sigmask);
> >  	}
> >  	spin_unlock_irq(&current->sighand->siglock);
> >  
> > -- 
> > 2.52.0
> > 
> 

-- 
Kees Cook

