Return-Path: <io-uring+bounces-2460-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F2CA592A071
	for <lists+io-uring@lfdr.de>; Mon,  8 Jul 2024 12:44:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD29D289523
	for <lists+io-uring@lfdr.de>; Mon,  8 Jul 2024 10:44:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29D1A77F0B;
	Mon,  8 Jul 2024 10:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TGYK3voN"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E03770ED
	for <io-uring@vger.kernel.org>; Mon,  8 Jul 2024 10:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720435453; cv=none; b=D7+PZAm3rlN494VpwidX+pZ2/08/Mk2DysIpkwKNHBiISffsdgyf2NOgNFcY2Qxg064E1nl6PQk6sLAhJMRPmVVLHyoOgCO5fUqXqcoX/8QCiV6Z5HAgWgknRbT628wHg8PqAOh56lil7qrvjl1UfHzVqcczUaOM3C4xkc38zC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720435453; c=relaxed/simple;
	bh=8kZKtHaSntB0zH7WGHS7bR+NbYj6bYLwa6+eVpBRPEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LuFlvM7R5nFdD8HoZZxNLer/SuBWF8lW82pGD2pJsl+/KTF2PjLPKTOf2SoRqEac8VLHMhhaL1rq7h0f+6Q180XKdV0Ve2lmhTM0Cqhv9GQUFTwSpN+ORcX8Mtl43EpoRzRO8WYvjoHtIXU4K/mf7hh8eg4lUP31MKE3wuchl/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TGYK3voN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720435450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kpyW9FT2E9hiqVYKVyxDHrtGhd9Kv+SY2bEweXiLk6s=;
	b=TGYK3voNvBzh2yyU8vig3QlKD+KZtuAaTStiF/6TY/Y2nFgjVuJMEptZH9aL/xWoi0mXAO
	TQT59GHcNTG5zvF3kapbKpNIYtuzdboxdHt9WkD5KLrjJcepXDcdi6xpHjlFaFab8XYRb7
	VDCDo3SCywfZ0Z+nBuEn5wtKLyreSlc=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-329-TbLzjhYxOFKH0jQaBM9bfg-1; Mon,
 08 Jul 2024 06:44:04 -0400
X-MC-Unique: TbLzjhYxOFKH0jQaBM9bfg-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6CD9F1935788;
	Mon,  8 Jul 2024 10:44:02 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.226.75])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 4012F3000181;
	Mon,  8 Jul 2024 10:43:58 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon,  8 Jul 2024 12:42:26 +0200 (CEST)
Date: Mon, 8 Jul 2024 12:42:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Tycho Andersen <tandersen@netflix.com>,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	Julian Orth <ju.orth@gmail.com>
Subject: Re: [PATCH 2/2] kernel: rerun task_work while freezing in
 get_signal()
Message-ID: <20240708104221.GA18761@redhat.com>
References: <cover.1720368770.git.asml.silence@gmail.com>
 <1d935e9d87fd8672ef3e8a9a0db340d355ea08b4.1720368770.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d935e9d87fd8672ef3e8a9a0db340d355ea08b4.1720368770.git.asml.silence@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On 07/07, Pavel Begunkov wrote:
>
> io_uring can asynchronously add a task_work while the task is getting
> freezed. TIF_NOTIFY_SIGNAL will prevent the task from sleeping in
> do_freezer_trap(), and since the get_signal()'s relock loop doesn't
> retry task_work, the task will spin there not being able to sleep
> until the freezing is cancelled / the task is killed / etc.
> 
> Cc: stable@vger.kernel.org
> Link: https://github.com/systemd/systemd/issues/33626
> Fixes: 3146cba99aa28 ("io-wq: make worker creation resilient against signals")

I don't think we should blame io_uring even if so far it is the only user
of TWA_SIGNAL.

Perhaps we should change do_freezer_trap() somehow, not sure... It assumes
that TIF_SIGPENDING is the only reason to not sleep in TASK_INTERRUPTIBLE,
today this is not true.

> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2694,6 +2694,10 @@ bool get_signal(struct ksignal *ksig)
>  	try_to_freeze();
>  
>  relock:
> +	clear_notify_signal();
> +	if (unlikely(task_work_pending(current)))
> +		task_work_run();
> +
>  	spin_lock_irq(&sighand->siglock);

Well, but can't we kill the same code at the start of get_signal() then?
Of course, in this case get_signal() should check signal_pending(), not
task_sigpending().

Or perhaps something like the patch below makes more sense? I dunno...

Oleg.

diff --git a/kernel/signal.c b/kernel/signal.c
index 1f9dd41c04be..e2ae85293fbb 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2676,6 +2676,7 @@ bool get_signal(struct ksignal *ksig)
 	struct signal_struct *signal = current->signal;
 	int signr;
 
+start:
 	clear_notify_signal();
 	if (unlikely(task_work_pending(current)))
 		task_work_run();
@@ -2760,10 +2761,11 @@ bool get_signal(struct ksignal *ksig)
 			if (current->jobctl & JOBCTL_TRAP_MASK) {
 				do_jobctl_trap();
 				spin_unlock_irq(&sighand->siglock);
+				goto relock;
 			} else if (current->jobctl & JOBCTL_TRAP_FREEZE)
 				do_freezer_trap();
-
-			goto relock;
+				goto start;
+			}
 		}
 
 		/*


