Return-Path: <io-uring+bounces-7452-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B863A85FB7
	for <lists+io-uring@lfdr.de>; Fri, 11 Apr 2025 15:54:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B20448C45B5
	for <lists+io-uring@lfdr.de>; Fri, 11 Apr 2025 13:48:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B59C81DE3AD;
	Fri, 11 Apr 2025 13:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NWkeeyvq"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7EF1DDC33;
	Fri, 11 Apr 2025 13:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744379300; cv=none; b=bqTaOoBSB1jJnnbmJk9V4dsYIjGrRbr5NUjcldwGb8UyC7HDxi5QlE3Lyci8ABmmN7ijHjOt2OE5yZSLXDVPPcrTOmIc8e2K4azSECMO2Yxt0Ti9Ww747uCEIClzBYV2L1vWtorxqkvSTOM2jEPaBgtn6TbdJ7KioqQs51N4Rp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744379300; c=relaxed/simple;
	bh=D2SQjbTT5a0oRdKpUHoRJNLR5tpYbUFIgjsEPcXTPyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RgVoTxgnmCaRSXtHExpIdUybILxf1uqGHFivyj7O6ZOuvOwkbmR2dxQxyr4ZRHsZ9vP0QUtwOFGOxpunqihU+N86G6h51TvAEp5fAMP0k1LzjugHvilqjFtniSHmMCsR1w+3mcwaGBSb6fHutw8osUjlO8Sik8XcFnXFybAbU9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NWkeeyvq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19A0C4CEE2;
	Fri, 11 Apr 2025 13:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744379300;
	bh=D2SQjbTT5a0oRdKpUHoRJNLR5tpYbUFIgjsEPcXTPyc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NWkeeyvq4ZszPn1TerH3sLVZ9hsUPK2v0pKvE3WrrZ2b4n/EY6hU+H3HIJr/3pJAC
	 ansFAO9ksKs/z0uvTx3fLmvpWcddIN7c+eYAzxxVIPEg1PS/EX8UavVJwRg8zBmtBj
	 TSgpX9eTLpZ1cSl7wKt28xRdb6faeEK98Sz3yanig3GaVXnqKRsIsoBSdxMPdNJBkD
	 2YabTgju0LYb6xcxIyC4bsHbiTxlhxG4XgHIPH7OIKqm0+JE4IR60gQr0Xac/u4d6k
	 zqAfsFlBlHtEG+mih1frDPb47Llhf+uvVYuyhU1AGzfrbWN2yi2WylXov7r1s1vOYk
	 iZKBABqkQITMA==
Date: Fri, 11 Apr 2025 15:48:16 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/5] fs: gate final fput task_work on PF_NO_TASKWORK
Message-ID: <20250411-teebeutel-begibt-7d9c0323954b@brauner>
References: <20250409134057.198671-1-axboe@kernel.dk>
 <20250409134057.198671-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250409134057.198671-2-axboe@kernel.dk>

On Wed, Apr 09, 2025 at 07:35:19AM -0600, Jens Axboe wrote:
> fput currently gates whether or not a task can run task_work on the
> PF_KTHREAD flag, which excludes kernel threads as they don't usually run
> task_work as they never exit to userspace. This punts the final fput
> done from a kthread to a delayed work item instead of using task_work.
> 
> It's perfectly viable to have the final fput done by the kthread itself,
> as long as it will actually run the task_work. Add a PF_NO_TASKWORK flag
> which is set by default by a kernel thread, and gate the task_work fput
> on that instead. This enables a kernel thread to clear this flag
> temporarily while putting files, as long as it runs its task_work
> manually.
> 
> This enables users like io_uring to ensure that when the final fput of a
> file is done as part of ring teardown to run the local task_work and
> hence know that all files have been properly put, without needing to
> resort to workqueue flushing tricks which can deadlock.
> 
> No functional changes in this patch.
> 
> Cc: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---

Seems fine. Although it has some potential for abuse. So maybe a
VFS_WARN_ON_ONCE() that PF_NO_TASKWORK is only used with PF_KTHREAD
would make sense.

Acked-by: Christian Brauner <brauner@kernel.org>

>  fs/file_table.c       | 2 +-
>  include/linux/sched.h | 2 +-
>  kernel/fork.c         | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/file_table.c b/fs/file_table.c
> index c04ed94cdc4b..e3c3dd1b820d 100644
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -521,7 +521,7 @@ static void __fput_deferred(struct file *file)
>  		return;
>  	}
>  
> -	if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
> +	if (likely(!in_interrupt() && !(task->flags & PF_NO_TASKWORK))) {
>  		init_task_work(&file->f_task_work, ____fput);
>  		if (!task_work_add(task, &file->f_task_work, TWA_RESUME))
>  			return;
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index f96ac1982893..349c993fc32b 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1736,7 +1736,7 @@ extern struct pid *cad_pid;
>  						 * I am cleaning dirty pages from some other bdi. */
>  #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
>  #define PF_RANDOMIZE		0x00400000	/* Randomize virtual address space */
> -#define PF__HOLE__00800000	0x00800000
> +#define PF_NO_TASKWORK		0x00800000	/* task doesn't run task_work */
>  #define PF__HOLE__01000000	0x01000000
>  #define PF__HOLE__02000000	0x02000000
>  #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with cpus_mask */
> diff --git a/kernel/fork.c b/kernel/fork.c
> index c4b26cd8998b..8dd0b8a5348d 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2261,7 +2261,7 @@ __latent_entropy struct task_struct *copy_process(
>  		goto fork_out;
>  	p->flags &= ~PF_KTHREAD;
>  	if (args->kthread)
> -		p->flags |= PF_KTHREAD;
> +		p->flags |= PF_KTHREAD | PF_NO_TASKWORK;
>  	if (args->user_worker) {
>  		/*
>  		 * Mark us a user worker, and block any signal that isn't
> -- 
> 2.49.0
> 

