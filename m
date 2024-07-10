Return-Path: <io-uring+bounces-2495-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F58392DB15
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 23:36:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AB092831D7
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 21:36:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 653F713C9A4;
	Wed, 10 Jul 2024 21:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YVeuBr8a"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABC912F38B
	for <io-uring@vger.kernel.org>; Wed, 10 Jul 2024 21:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720647370; cv=none; b=PB1Z0dPV7dmepLE2CcaQTlAk6pedtsWYDo6XN5M7Y+VoOyMDrLvXJQLGXS+2pkpdLXIT0XBTD9Yr9gWkkCgWQPNtnb4r5sqIF8iND/nbwIfjQ1qRbbx1IZMMdHPblk629p7UX6soCqdOHs/Uvba/WSSB/3dj1IyQ4qafcwPRHRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720647370; c=relaxed/simple;
	bh=UwINd/1rcWL4hkNdPe+avjy4QtRQ3WHNZFHXTjmTdGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kYdzlBBd9r5Uj+ldpM2oAmlo3ihCNS07aW6YDqBXST1eFSDgfG9pj29FMNUoFeIXc+/34EvIK2IL1G9Ni7CyY+ne9hYkSkvYyE13zqWUux6ePd+Esw4dWVWrr0XMSj7D71oZugXpMdlkjeHDthrlLLKqeqtXDmClOYYVzd48x/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YVeuBr8a; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720647367;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UwINd/1rcWL4hkNdPe+avjy4QtRQ3WHNZFHXTjmTdGY=;
	b=YVeuBr8atoNUPbkZrWsZbs4PRf8bKW99GFYRRzuferPD6kLKNM8NSNr8qv2gbpgDN1UFNS
	lAfeQXUeZVoW3Xjahjl54Y8Sf0PkJt7X64S82hFjk3rKrueG4Qp+1H8f3+CWxfB96bplvl
	xm8pock5Pr7U491qs5sE+nMfpB2bOnk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-675-WyQ7EOp7OJq6o4au8hBwYA-1; Wed,
 10 Jul 2024 17:36:04 -0400
X-MC-Unique: WyQ7EOp7OJq6o4au8hBwYA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B2DFB1955F40;
	Wed, 10 Jul 2024 21:36:01 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.45.224.169])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id C1FEC3000181;
	Wed, 10 Jul 2024 21:35:56 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Wed, 10 Jul 2024 23:34:25 +0200 (CEST)
Date: Wed, 10 Jul 2024 23:34:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Tycho Andersen <tandersen@netflix.com>,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	Julian Orth <ju.orth@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] kernel: rerun task_work while freezing in
 get_signal()
Message-ID: <20240710213418.GH9228@redhat.com>
References: <658da3fe-fa02-423b-aff0-52f54e1332ee@gmail.com>
 <Zo1ntduTPiF8Gmfl@slm.duckdns.org>
 <20240709190743.GB3892@redhat.com>
 <d2667002-1631-4f42-8aad-a9ea56c0762b@gmail.com>
 <20240709193828.GC3892@redhat.com>
 <d9c00f01-576c-46cd-a88c-76e244460dac@gmail.com>
 <Zo3bt3AJHSG5rVnZ@slm.duckdns.org>
 <933e7957-7a73-4c9a-87a7-c85b702a3a32@gmail.com>
 <20240710191015.GC9228@redhat.com>
 <Zo7e8RQQfG7U5fuT@slm.duckdns.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zo7e8RQQfG7U5fuT@slm.duckdns.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On 07/10, Tejun Heo wrote:
>
> Hello,
>
> On Wed, Jul 10, 2024 at 09:10:16PM +0200, Oleg Nesterov wrote:
> ...
> > If nothing else. CRIU needs to attach and make this task TASK_TRACED, right?
>
> Yeah, AFAIK, that's the only way to implement check-pointing for now.

OK,

> > And once the target task is traced, it won't react to task_work_add(TWA_SIGNAL).
>
> I don't know how task_work is being used but the requirement would be that
> if a cgroup is frozen, task_works shouldn't be making state changes which
> can't safely be replayed (e.g. by restarting the frozen syscalls).

Well, in theory task_work can do "anything".

Of course, it can't, say, restart a frozen syscall, task_work_run() just
executes the callbacks in kernel mode and returns.

> it'd be better to freeze them together.

And I tend to agree. simply beacase do_freezer_trap() (and more users of
clear_thread_flag(TIF_SIGPENDING) + schedule(TASK_INTERRUPTIBLE) pattern)
do not take TIF_NOTIFY_SIGNAL into account.

But how do you think this patch can make the things worse wrt CRIU ?

And let's even forget this patch which fixes the real problem.
How do you think the fact that the task sleeping in do_freezer_trap()
can react to TIF_NOTIFY_SIGNAL, call task_work_run(), and then sleep
in do_freezer_trap() again can make any difference in this sense?

> As this thing is kinda difficult to reason about,

Agreed,

> it'd probably be easier to just freeze them together if we can.

Agreed, but this needs some "generic" changes while Pavel needs a
simple and backportable workaround to suppress a real problem.

In short, I don't like this patch either, I just don't see a better
solution for now ;)

Thanks,

Oleg.


