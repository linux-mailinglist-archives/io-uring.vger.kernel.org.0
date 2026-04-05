Return-Path: <io-uring+bounces-12962-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QHZTD2570mlKYQcAu9opvQ
	(envelope-from <io-uring+bounces-12962-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 05 Apr 2026 17:10:38 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 946AF39ECB4
	for <lists+io-uring@lfdr.de>; Sun, 05 Apr 2026 17:10:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5680B300E252
	for <lists+io-uring@lfdr.de>; Sun,  5 Apr 2026 15:10:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 417B62FFF8B;
	Sun,  5 Apr 2026 15:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VMF91cKB"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7012280309
	for <io-uring@vger.kernel.org>; Sun,  5 Apr 2026 15:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775401817; cv=none; b=d2rMPxeWQFcQi8tQhrHzNey20ouv7LTouzvM6x9W+bp8cW5kI2l20tjryY2L4Bz7pFy45YNFFfu4nPOOV3VC2AJ8LpL7w30jyv/PmaKyt5iziJaAuGTuxUue00XSJXCwbL9+mkCvVGnl8oj0RKg5O+kjsEBC9iq9526RZSCqjQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775401817; c=relaxed/simple;
	bh=AO7t3eq2h9HLO9AEL+MfVjFXZwX4q1lQFe/Hr9mNEus=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dQY/iozS24BCUgb6A2RNWIhMV0ORU7Zolum8GR4WKODw5GsbAYrrSe9PIdGEY4z0zaweqALXWi9DhES7JTtfn3hZyYw6+bQ4KuGDi8zqhc+UfzUlgoDdTogVbbiTI6gzPqxQZ17I4kyrLvwiTDvxrgwujqcUa3/j4uyR8Rq5vck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VMF91cKB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775401815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vsaS9IGbPBOadtTuoNXtEYqCamSNxDlw5DNXAa/aswY=;
	b=VMF91cKBtVlbXgAS+pg1PfFA8AX/e7o5Z0Qxw7JpGxXGBkdNohR5uWEpu+vnqQ/Kvdb8i8
	ldZOHCbx+Vs4vo0TN9xUehPNwvapl7hw7rWgEvXKG49Va7W+0e9797IqZ28VXsy8GmLOQt
	bmW/shhQVsYQKw8hzjyjYzCGpnFOaEs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-199-2Knc8mGKOvqEraU82IWx0w-1; Sun,
 05 Apr 2026 11:10:11 -0400
X-MC-Unique: 2Knc8mGKOvqEraU82IWx0w-1
X-Mimecast-MFC-AGG-ID: 2Knc8mGKOvqEraU82IWx0w_1775401810
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3029D180035C;
	Sun,  5 Apr 2026 15:10:10 +0000 (UTC)
Received: from fedora (unknown [10.44.32.11])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id AB8D919560A6;
	Sun,  5 Apr 2026 15:10:07 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sun,  5 Apr 2026 17:10:09 +0200 (CEST)
Date: Sun, 5 Apr 2026 17:10:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: syzbot <syzbot+0a4c46806941297fecb9@syzkaller.appspotmail.com>
Cc: io-uring@vger.kernel.org, kees@kernel.org, linux-kernel@vger.kernel.org,
	luto@amacapital.net, syzkaller-bugs@googlegroups.com,
	wad@chromium.org
Subject: Re: [syzbot] [kernel] WARNING in __secure_computing
Message-ID: <adJ7TbpTohmN-Ufa@redhat.com>
References: <adJvw9gEC9D1Gxtq@redhat.com>
 <69d27441.050a0220.2dbe29.0028.GAE@google.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69d27441.050a0220.2dbe29.0028.GAE@google.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_FROM(0.00)[bounces-12962-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[oleg@redhat.com,io-uring@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCPT_COUNT_SEVEN(0.00)[7];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,0a4c46806941297fecb9];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 946AF39ECB4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 04/05, syzbot wrote:
>
> Hello,
>
> syzbot has tested the proposed patch but the reproducer is still triggering an issue:
> lost connection to test machine

I can't believe it ;)

> console output: https://syzkaller.appspot.com/x/log.txt?x=17a6cdda580000

	qemu-system-x86_64: hw/ide/core.c:934: ide_dma_cb: Assertion `prep_size >= 0 && prep_size <= n * 512' failed.
	Connection to localhost closed by remote host.

certainly unrelated.

Please retest.

#syz test


diff --git a/fs/signalfd.c b/fs/signalfd.c
index dff53745e352..107a83336657 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -48,17 +48,30 @@ static int signalfd_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static void mk_sigmask(struct signalfd_ctx *ctx, sigset_t *sigmask)
+{
+	struct k_sigaction *k = current->sighand->action;
+	int n;
+
+	*sigmask = ctx->sigmask;
+	for (n = 1; n <= _NSIG; ++n, ++k) {
+		if (k->sa.sa_flags & SA_IMMUTABLE)
+			sigaddset(sigmask, n);
+	}
+}
+
 static __poll_t signalfd_poll(struct file *file, poll_table *wait)
 {
 	struct signalfd_ctx *ctx = file->private_data;
 	__poll_t events = 0;
+	sigset_t sigmask;
 
 	poll_wait(file, &current->sighand->signalfd_wqh, wait);
 
 	spin_lock_irq(&current->sighand->siglock);
-	if (next_signal(&current->pending, &ctx->sigmask) ||
-	    next_signal(&current->signal->shared_pending,
-			&ctx->sigmask))
+	mk_sigmask(ctx, &sigmask);
+	if (next_signal(&current->pending, &sigmask) ||
+	    next_signal(&current->signal->shared_pending, &sigmask))
 		events |= EPOLLIN;
 	spin_unlock_irq(&current->sighand->siglock);
 
@@ -155,11 +168,13 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, kernel_siginfo_t *info
 				int nonblock)
 {
 	enum pid_type type;
-	ssize_t ret;
 	DECLARE_WAITQUEUE(wait, current);
+	sigset_t sigmask;
+	ssize_t ret;
 
 	spin_lock_irq(&current->sighand->siglock);
-	ret = dequeue_signal(&ctx->sigmask, info, &type);
+	mk_sigmask(ctx, &sigmask);
+	ret = dequeue_signal(&sigmask, info, &type);
 	switch (ret) {
 	case 0:
 		if (!nonblock)
@@ -174,7 +189,7 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, kernel_siginfo_t *info
 	add_wait_queue(&current->sighand->signalfd_wqh, &wait);
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
-		ret = dequeue_signal(&ctx->sigmask, info, &type);
+		ret = dequeue_signal(&sigmask, info, &type);
 		if (ret != 0)
 			break;
 		if (signal_pending(current)) {
@@ -184,6 +199,7 @@ static ssize_t signalfd_dequeue(struct signalfd_ctx *ctx, kernel_siginfo_t *info
 		spin_unlock_irq(&current->sighand->siglock);
 		schedule();
 		spin_lock_irq(&current->sighand->siglock);
+		mk_sigmask(ctx, &sigmask);
 	}
 	spin_unlock_irq(&current->sighand->siglock);
 


