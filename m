Return-Path: <io-uring+bounces-8479-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E58CAE6D4C
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 19:08:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4B85173E47
	for <lists+io-uring@lfdr.de>; Tue, 24 Jun 2025 17:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55B3026CE0D;
	Tue, 24 Jun 2025 17:07:58 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900132E175E;
	Tue, 24 Jun 2025 17:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750784878; cv=none; b=rdD1NVNpcvC1Ohku2IlfhzY3D7Pz46D+VEnZXtr5EN4JgFQpV+ThIpb+9+J0sK4r321U/txh1j/nzjsTwsKgP/2poYxRfe0xXEWo88SDYeMcO+TYKu6nu0lxkDK5RVou3BW+VPbiIZffALByq0ZsdiUy41J5yWI2vAGtOAfpP5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750784878; c=relaxed/simple;
	bh=dAep9qf1zVqdFCAAzk9d6adpwmGTLIt1k47UquLn69E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZXtLQyZVJXxWE1SRVoPUA5tbmMBzhYefG6PB7v5k1l5N6402lHhZQlziMFFX8HNgqcpat9EYhlglkaE9QwiGG+or1a6dPYuiM+NIYkIn+QgWDJ71zKQiXXb6nrkgTks1WD8Spy5SKFh5Emotd4pVREcTjU6HQBXGLMJECeCXHBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81F8A10502F;
	Tue, 24 Jun 2025 17:07:47 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf02.hostedemail.com (Postfix) with ESMTPA id 6767C80018;
	Tue, 24 Jun 2025 17:07:45 +0000 (UTC)
Date: Tue, 24 Jun 2025 13:07:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiazi Li <jqqlijiazi@gmail.com>
Cc: linux-kernel@vger.kernel.org, "peixuan.qiu" <peixuan.qiu@transsion.com>,
 Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [PATCH] stacktrace: do not trace user stack for user_worker
 tasks
Message-ID: <20250624130744.602c5b5f@batman.local.home>
In-Reply-To: <20250623115914.12076-1-jqqlijiazi@gmail.com>
References: <20250623115914.12076-1-jqqlijiazi@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6767C80018
X-Stat-Signature: 7mfwfisopyzzuytgifg8xyupdsge7cni
X-Rspamd-Server: rspamout06
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/D0o+whg74phBC5Y2Cn3IAQ7L3LDV3uL4=
X-HE-Tag: 1750784865-899221
X-HE-Meta: U2FsdGVkX18qhB4AyxZtWHh+WQN1DIxX1MeXKaLnIwDf8p6Zt4Zu1yObu8v7u2IRO2Wh/KRy5zMPxbUQelL5uOXu5JWk2rkGOXAlK62BYhNBjj00BCEGKLqCzaCOMHkhFYGuKprdisekwC/w3/7tSgFnpclH57/fTGyEWur8cAsAOLc/OVkdVqsBJroj+TOtvlRdWNnJ3Hx+yTYSylPqjTTpfKqosv90pVZAo/yPvIUY2Pui9Ghlu3ZBaBEj9gwDBc0t3CG0Pafh4woluVmRaAHPC1oBNTXOrdqg788nZaTxDqF9PVmfHHC2iVgxbA5aLJJYYF/85l5ZTeegfZz7pGjvRquL+6yZ7gCnxzWV2GmvThtZcj4hPbL6CzQc2s7Giv2VXYRlBIQUO30qRZZ3cw==

On Mon, 23 Jun 2025 19:59:11 +0800
Jiazi Li <jqqlijiazi@gmail.com> wrote:

> Tasks with PF_USER_WORKER flag also only run in kernel space,
> so do not trace user stack for these tasks.

What exactly is the difference between PF_KTHREAD and PF_USER_WORKER?

Has all the locations that test for PF_KTHREAD been audited to make
sure that PF_USER_WORKER isn't also needed?

I'm working on other code that needs to differentiate between user
tasks and kernel tasks, and having to have multiple flags to test is
becoming quite a burden.

-- Steve


> 
> Signed-off-by: Jiazi Li <jqqlijiazi@gmail.com>
> Signed-off-by: peixuan.qiu <peixuan.qiu@transsion.com>
> ---
>  kernel/stacktrace.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
> index afb3c116da91..82fbccdd1a24 100644
> --- a/kernel/stacktrace.c
> +++ b/kernel/stacktrace.c
> @@ -228,8 +228,8 @@ unsigned int stack_trace_save_user(unsigned long *store, unsigned int size)
>  		.size	= size,
>  	};
>  
> -	/* Trace user stack if not a kernel thread */
> -	if (current->flags & PF_KTHREAD)
> +	/* Skip tasks that do not return to userspace */
> +	if (current->flags & (PF_KTHREAD | PF_USER_WORKER))
>  		return 0;
>  
>  	arch_stack_walk_user(consume_entry, &c, task_pt_regs(current));


