Return-Path: <io-uring+bounces-8495-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D99DCAE930C
	for <lists+io-uring@lfdr.de>; Thu, 26 Jun 2025 01:55:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E3DB18929AA
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 23:55:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADADD28726A;
	Wed, 25 Jun 2025 23:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Btd0Jrwu"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8447425C6E5;
	Wed, 25 Jun 2025 23:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750895693; cv=none; b=d4+ReKNEJGIhyAEEZwNaU0KxxeK/sg5cKRLp60OP+JzrMwLnGqVbk/k/buHEtPMIUILM2MlW/5LtmcWcAAEXtFs3K1HgLCpZLcjjDMGKAEzxhEbr4XeWRwdxNVhGzpV4q+mIB2mH1z4HnRZi5lKl7DA8NG430cVv2eRpy8Ss4JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750895693; c=relaxed/simple;
	bh=vSHutcvfY5eO+VRz9LZHF0l2YWbkUIIc+58AK7xTErQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WjOQ5iTF6X4nb5gNjbYGcKI3plo65hoEG23Mw8UbHH96A4Hi+6QmGNmrMnY76K1Ilot9Cnx/A2595/zzJVw463XN0EREJ6inoBWPEPmy78A2fcCHFGoZv4IYy0kRTlol2tx5qrqGmkxp2T/uAh0NQrUuxakYa2cRCmg+tcb1KEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Btd0Jrwu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B40C4CEEA;
	Wed, 25 Jun 2025 23:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750895693;
	bh=vSHutcvfY5eO+VRz9LZHF0l2YWbkUIIc+58AK7xTErQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Btd0JrwuVhBS6GZ6+QNTB6F2AaZT4GjITI7a2K81pmXmkAMyfocHCB6cSBKwXvkYZ
	 zZZNS1x1tkuMXVl4/0oOddKgrSzaJeuvb/A1Pknq02teDAWe77jMYwR0CGUVlSU8ni
	 M2DyUqnQIZ0i+BYOj+aex+aN2oXmOyl7x8BRJLgNqSSlDteZWrZntpamcx9ODLn0OC
	 QdqzSXKLaYZW/IKMi/HlG7MkG9xz0OtNkjkZBDeq0lHPDkdZARUx+Mps8FXGcOFcWX
	 aWDNBywoOkQOFNHzzisEQpSIQGn/iR1eqkUZ9eB21jrhcfzxDnND7GCjU3Ar2GLX6E
	 6KHz9eW8NZfaA==
Date: Wed, 25 Jun 2025 17:54:50 -0600
From: Keith Busch <kbusch@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jiazi Li <jqqlijiazi@gmail.com>,
	linux-kernel@vger.kernel.org,
	"peixuan.qiu" <peixuan.qiu@transsion.com>, io-uring@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] stacktrace: do not trace user stack for user_worker tasks
Message-ID: <aFyMSoxZ-Iz33fL9@kbusch-mbp>
References: <20250623115914.12076-1-jqqlijiazi@gmail.com>
 <20250624130744.602c5b5f@batman.local.home>
 <80e637d3-482d-4f3a-9a86-948d3837b24d@kernel.dk>
 <20250625165054.199093f1@batman.local.home>
 <ddcbdaa0-479a-4821-9230-d3207be20b3c@kernel.dk>
 <20250625184144.48c87888@gandalf.local.home>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250625184144.48c87888@gandalf.local.home>

On Wed, Jun 25, 2025 at 06:41:44PM -0400, Steven Rostedt wrote:
> On Wed, 25 Jun 2025 16:30:55 -0600
> Jens Axboe <axboe@kernel.dk> wrote:
> 
> > On 6/25/25 2:50 PM, Steven Rostedt wrote:
> > > [
> > >   Adding Peter Zijlstra as he has been telling me to test against
> > >   PF_KTHREAD instead of current->mm to tell if it is a kernel thread.
> > >   But that seems to not be enough!
> > > ]  
> > 
> > Not sure I follow - if current->mm is NULL, then it's PF_KTHREAD too.
> > Unless it's used kthread_use_mm().
> > 
> > PF_USER_WORKER will have current->mm of the user task that it was cloned
> > from.
> 
> The suggestion was to use (current->flags & PF_KTHREAD) instead of
> !current->mm to determine if a task is a kernel thread or not as we don't
> want to do user space stack tracing on kernel threads. Peter said that
> because of io threads which have current->mm set, you can't rely on that,
> so check the PF_KHTREAD flag instead. This was assuming that io kthreads
> had that set too, but apparently it does not and we need to check for
> PF_USER_WORKER instead of just PF_KTHREAD.

If you're interested, here's a discussion with Linus on some fallout
with PF_USER_WORKER threads I stumbled upon a few months ago with no
clear longterm resolution:

  https://lore.kernel.org/kvm/CAHk-=wg4Wm4x9GoUk6M8BhLsrhLj4+n8jA2Kg8XUQF=kxgNL9g@mail.gmail.com/

That was about userspace problems with these PF_USER_WORKER tasks
spawned with vhost rather than anything in kernel, so it's from the
other side of what you're dealing with here. I'm just mentioning it in
case the improvements your considering could be useful for the userspace
side too.

