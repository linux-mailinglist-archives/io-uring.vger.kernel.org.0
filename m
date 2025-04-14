Return-Path: <io-uring+bounces-7458-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06403A88967
	for <lists+io-uring@lfdr.de>; Mon, 14 Apr 2025 19:11:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B43DD3B3D07
	for <lists+io-uring@lfdr.de>; Mon, 14 Apr 2025 17:11:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 933DF1F236B;
	Mon, 14 Apr 2025 17:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dMrIBYrI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA97D27B4F9;
	Mon, 14 Apr 2025 17:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744650702; cv=none; b=thciUaY+VcgWyQwcnnrVJxqvn8+cMZn1viguvYFbd0BsY4pFAq7dw8llxOCIagzcBBrpK5pL3K3XZJL8uGS76SxVXCheGwkpyntgQ71QZ/OaKbH76MGe7OjOvVtzXNq17DU1iOo/mA/R8pBmAQZ8FbmuY6iYpLoIUMUeQDJgdiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744650702; c=relaxed/simple;
	bh=ck+m1PSg9GahaYEhevrrlgN/zQ9PTfapMVgglxCXq3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CLtJKMafGdw/i6KllaDyYL6fZbtWgpdrvYDIHUwpCVwrIeFlmeLRKeYxqCRZaspXqfwfomGSeBuAWZcgWOCrxFbRgs8wlUJ0hEyBWmT10raigGgz6pbcNzI5uCGaXBG46mSvbO4EzmtzTzAprnh0AjAerWtSS6WO4DDttMyFk78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dMrIBYrI; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43ed8d32a95so39462065e9.3;
        Mon, 14 Apr 2025 10:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744650699; x=1745255499; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UC3vPHRe+zUrpoVanQyCstzz7M5adlvJuH9P7U1QAZ4=;
        b=dMrIBYrIYjG21JSMfnJF+uszormbNz1xL1kYWPor5ld4yhCYzuNxR6Q0j8R0vZHZQT
         AoJD1k2g1y2ToUMDO9+D333b/gdLHurr4HXI+1vY+xWCzXt08+4hKPwAMWvkt3mNTNbZ
         PZQ+wuVq4shT+qlf22fgpHzVYfJb4xfeJrkWw/QkvncjMPWXJn+AOjrhC3ND99nZjRE6
         uRY4lEzIpHWlDvHt7PveCWxU6HGU+NQsAAc0VZulC7s9VuW48faYW3GgzlMKbuA2WMEh
         nI5GW8W7E30Cl1tSG+ipHT1Zxt8rmpLOEexGWbc1aR9ygUzWSiUrf+JphmpsUBTlPjOu
         Ab+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744650699; x=1745255499;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UC3vPHRe+zUrpoVanQyCstzz7M5adlvJuH9P7U1QAZ4=;
        b=VIvHBIoHHydzA/nCna5tGkWWTfp6TC1nxj/9FyBg9kSGXhz/E4dSp/PBiRXRCiUb88
         Xyq82t2E9IUZ/z3btKzR0jCvLqBGRfovl9OUR8H5OzlggYla0FPCuAAdcV4HABI+A5IP
         RvlMf1WoJjn0R9PYYFEXkqq78sNvHpfW4b0HpU0MX46mlVZnA9fcMyeG3eUpzLNF313f
         Lmes9gVfr5d5E4JD5tOqLiovKImbJZZkYwKf/YuPS/zbHTfQYEsF4BvqjGU0Rf5N9y6Q
         pLGrqU74a4YmQqXJdP/ifOu/NW8FOhZ2uxNixfJl0v++ho27wLFKsV9BOdhqaBOw5g93
         f07A==
X-Forwarded-Encrypted: i=1; AJvYcCXpa5LHyXzCbMrce7m8Tx/BjIxvAT3c9LXV5SYUfWPmo7qUVoIJ2BMEyECgt5OhYgppun7qdhW38PAJ0NLK@vger.kernel.org
X-Gm-Message-State: AOJu0YzBaG7VG989aedhKOaI6SwY2xPwV+Tw00bHs/R8py4hXvraKDqF
	7DEvLx8QJX0ziKCXJJJzHCswBqULb8PNTVf/Vr99ebJo7hf/mVZu
X-Gm-Gg: ASbGncts0NBNwyql0MfAfa65P1AEllHpZm4MKGynIDY1ht1cF3rqemFc69ru7PhKNcA
	7PknF4avrXTkOvsm5R/mLw1Jp+ttiIzs2OMUlzliElQvS6tOSWZQ4MDOSVGNs2O8Vt3s9JOwBT+
	jT69+eRLgBN2pwcx4MKewMFXSDvWxNtg+CiuVVrIY9v8LQT1f5ean2voXIVlwq1vBolsTMbLtp6
	TGAt+Sw37ezuRT4se16TLTBhygpH+K7Y1N5gkSyy4ymFrDSwyoQTcD1+mfxbmBLy4qsrVv01BMM
	rWu8Jda6WDtnOv3M6AkXp4KMZQ3K4i7pSNtLio0g14BZhdBPwn6xQQ==
X-Google-Smtp-Source: AGHT+IFtNo+5Lyy948LZ2irnXhEhkkwUe2Ihm61wmkbWkSNp7Ep2XqopfYnp5O2HXXK3GuAuTUNtiA==
X-Received: by 2002:a05:600c:b8d:b0:43c:fa24:8721 with SMTP id 5b1f17b1804b1-43f4aac8753mr73938965e9.17.1744650698579;
        Mon, 14 Apr 2025 10:11:38 -0700 (PDT)
Received: from f (cst-prg-79-34.cust.vodafone.cz. [46.135.79.34])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f233a2a13sm180544885e9.10.2025.04.14.10.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Apr 2025 10:11:37 -0700 (PDT)
Date: Mon, 14 Apr 2025 19:11:30 +0200
From: Mateusz Guzik <mjguzik@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com, brauner@kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/5] fs: gate final fput task_work on PF_NO_TASKWORK
Message-ID: <gj6liprp6wtwgabimozkpaw6rv5xfotyi62zuegy5ffjxjdrrs@325g7wcnir6t>
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

I don't have comments on the semantics here, I do have comments on some
future-proofing.

To my reading kthreads on the stock kernel never execute task_work.

This suggests it would be nice for task_work_add() to at least WARN_ON
when executing with a kthread. After all you don't want a task_work_add
consumer adding work which will never execute.

But then for your patch to not produce any splats there would have to be
a flag blessing select kthreads as legitimate task_work consumers.

So my suggestion would be to add the WARN_ON() in task_work_add() prior
to anything in this patchset, then this patch would be extended with a
flag (PF_KTHREAD_DOES_TASK_WORK?) and relevant io_uring threads would
get the flag.

Then the machinery which sets/unsets PF_NO_TASKWORK can assert that:
1. it operates on a kthread...
2. ...with the PF_KTHREAD_DOES_TASK_WORK flag

This is just a suggestion though.

