Return-Path: <io-uring+bounces-7459-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E451A88C52
	for <lists+io-uring@lfdr.de>; Mon, 14 Apr 2025 21:35:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A7D457A7960
	for <lists+io-uring@lfdr.de>; Mon, 14 Apr 2025 19:34:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDC691ADFE4;
	Mon, 14 Apr 2025 19:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="I6sy5nJI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451D01AD403
	for <io-uring@vger.kernel.org>; Mon, 14 Apr 2025 19:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744659331; cv=none; b=AvkUt3/R6tpwMUly08BPTSiCBbL6OssryHRfe5qjd1ba5az0hZmYXVJTJm2vixmil7AHF2FvOGJfSCoQ6hHXBOGoFgHh6U834nJew3xbzKC5ToQhxFESOcjN4w0k6N6oR3RJvTchw+SwcKJe5O8GMLXtgV6DICQGS9wyErANawQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744659331; c=relaxed/simple;
	bh=4DYoBFJNUP3UkiuUtc/FGAzvL3hBom3dR3htenqLAy8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y+KHX6nF5u3ZG8KFjBGlsDSVhXVtE4E7FeOB50kd0PQdfbWmRcMNs+NTy5e5WcGBDcaS/xzTSDruudIJXr6o46yvvy4LAFfK9Ig0O3g0yWIfe8Qus/MEgW1nGKpcuAUhmHVnEwNj3si6k6mRKk9tdtD9KlXR+uuvO55YZMm0VDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=I6sy5nJI; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3d445a722b9so23190895ab.3
        for <io-uring@vger.kernel.org>; Mon, 14 Apr 2025 12:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744659328; x=1745264128; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kQcWlSOKyFtlnxBLYEiwaL3kPiNi8IsyhCrMWx8B53M=;
        b=I6sy5nJId6XtzmTrG0gu55ku0Vy8MpqDCMXiCgOI/MpRvpB6vMlvEZFRZRd14xMdJk
         TeA2EKzWQxNyRlG+shG4qaTj83HCUHsEcq0s7IwrFGvlHCkTb6hqeJDehHiQUYes8vm3
         1Bnak40dFmTOuBeNxHOQ4dJ8eEK+lcT/g1p4/9VvcbzFojfgIxOGguTFkyUf9+pt7Yrl
         JFRxwrc/xAVocKM55V6z60zqg/vvSVr6nnyEzNJmDg33kfFwMF22FNwCaWXIgF+hrXs3
         TyQo6DzD95Z95M4jQmubvmbobF2QH+TwJZNa0SynxwqK/P/BYOotz6tF7GlEJRfgaQdF
         4B3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744659328; x=1745264128;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kQcWlSOKyFtlnxBLYEiwaL3kPiNi8IsyhCrMWx8B53M=;
        b=jgBQWREXvgKHRtYO6J/+5J07oTjgl/bQVwIKsrhmm5y2+UJM2i59F3AODSU2LN7LKE
         o70zBgnNc5AL9NpQBENosi7BFH16ZOC11FOe4XIwJumJoyfJcpOv1Pi1u/ACV8AjTBnr
         XfuqwJTGvYbAx8co5R/YhpcBNAgPh4uwEPW7CzzEse0I2uAVmh3D8cFrmvWCaPsyzpFR
         XnYguYdax5Od0Ans4E0so4TippsPaCOe6ZN+nN3jqVxhumcOOV+9QPH8dhye95NNgf+/
         aGi91/jpDgjhUj1xcfieVNX8JipkMAqWna4vgugXCR3PEmTxV7wYzWjj1fJL+goB8bPg
         TPkA==
X-Gm-Message-State: AOJu0YwZ5Ne28kDWNfzc9gXEVreO3uegjYAjNTtcPWle+d+85Rm44G0P
	sggqu/TdOUQXhlYZiTN0wsNHOhUfUQiau+bZvc5RPA+XJnUHXH572pLRyhpZoh0=
X-Gm-Gg: ASbGnctsJmwSN+/Ub/RA5+1AlcVnr3s1WTDwxXPKjmwFmQmMkLysrB6ZBIy9BIa8Nfe
	oANklJecFC4AFyQZdTxuLTnlaIWtsU4FOuvzk/m+wYqqyGROiqF/ZEHluysXaJ8nMnWQV+bABs6
	pA87/tCtyw4p1ngsPV3nt6TIEQMNq5ZIfa8dyS2bBZ2E6GmQ7Uu45BcEvg0/8VtxkZpD7f8ooiC
	mm4wfzZPzN3N8TdorhBan+l93KBZcWie/uM+juSecaaRs5wON+0VGq5UdhGeT/YzLVm6LWQepsW
	0e5oJk+BpAbVKUMPT4QdHgy1P0LjN//PfgBv
X-Google-Smtp-Source: AGHT+IFZFvf9s9O3yFwQDM03lsEZMLEJdiLpa/o6o5Qz1t59pba0q9aXsHOkfOYTUGsRk4DsYjI+3A==
X-Received: by 2002:a05:6e02:3b89:b0:3d3:fdcc:8fb8 with SMTP id e9e14a558f8ab-3d7ec2035camr123753565ab.10.1744659328187;
        Mon, 14 Apr 2025 12:35:28 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505e7da54sm2703561173.140.2025.04.14.12.35.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Apr 2025 12:35:27 -0700 (PDT)
Message-ID: <c83ab29b-48e5-44b1-8902-2711a806739f@kernel.dk>
Date: Mon, 14 Apr 2025 13:35:26 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] fs: gate final fput task_work on PF_NO_TASKWORK
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: io-uring@vger.kernel.org, asml.silence@gmail.com, brauner@kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20250409134057.198671-1-axboe@kernel.dk>
 <20250409134057.198671-2-axboe@kernel.dk>
 <gj6liprp6wtwgabimozkpaw6rv5xfotyi62zuegy5ffjxjdrrs@325g7wcnir6t>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <gj6liprp6wtwgabimozkpaw6rv5xfotyi62zuegy5ffjxjdrrs@325g7wcnir6t>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/14/25 11:11 AM, Mateusz Guzik wrote:
> On Wed, Apr 09, 2025 at 07:35:19AM -0600, Jens Axboe wrote:
>> fput currently gates whether or not a task can run task_work on the
>> PF_KTHREAD flag, which excludes kernel threads as they don't usually run
>> task_work as they never exit to userspace. This punts the final fput
>> done from a kthread to a delayed work item instead of using task_work.
>>
>> It's perfectly viable to have the final fput done by the kthread itself,
>> as long as it will actually run the task_work. Add a PF_NO_TASKWORK flag
>> which is set by default by a kernel thread, and gate the task_work fput
>> on that instead. This enables a kernel thread to clear this flag
>> temporarily while putting files, as long as it runs its task_work
>> manually.
>>
>> This enables users like io_uring to ensure that when the final fput of a
>> file is done as part of ring teardown to run the local task_work and
>> hence know that all files have been properly put, without needing to
>> resort to workqueue flushing tricks which can deadlock.
>>
>> No functional changes in this patch.
>>
>> Cc: Christian Brauner <brauner@kernel.org>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  fs/file_table.c       | 2 +-
>>  include/linux/sched.h | 2 +-
>>  kernel/fork.c         | 2 +-
>>  3 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/file_table.c b/fs/file_table.c
>> index c04ed94cdc4b..e3c3dd1b820d 100644
>> --- a/fs/file_table.c
>> +++ b/fs/file_table.c
>> @@ -521,7 +521,7 @@ static void __fput_deferred(struct file *file)
>>  		return;
>>  	}
>>  
>> -	if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
>> +	if (likely(!in_interrupt() && !(task->flags & PF_NO_TASKWORK))) {
>>  		init_task_work(&file->f_task_work, ____fput);
>>  		if (!task_work_add(task, &file->f_task_work, TWA_RESUME))
>>  			return;
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index f96ac1982893..349c993fc32b 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1736,7 +1736,7 @@ extern struct pid *cad_pid;
>>  						 * I am cleaning dirty pages from some other bdi. */
>>  #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
>>  #define PF_RANDOMIZE		0x00400000	/* Randomize virtual address space */
>> -#define PF__HOLE__00800000	0x00800000
>> +#define PF_NO_TASKWORK		0x00800000	/* task doesn't run task_work */
>>  #define PF__HOLE__01000000	0x01000000
>>  #define PF__HOLE__02000000	0x02000000
>>  #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with cpus_mask */
>> diff --git a/kernel/fork.c b/kernel/fork.c
>> index c4b26cd8998b..8dd0b8a5348d 100644
>> --- a/kernel/fork.c
>> +++ b/kernel/fork.c
>> @@ -2261,7 +2261,7 @@ __latent_entropy struct task_struct *copy_process(
>>  		goto fork_out;
>>  	p->flags &= ~PF_KTHREAD;
>>  	if (args->kthread)
>> -		p->flags |= PF_KTHREAD;
>> +		p->flags |= PF_KTHREAD | PF_NO_TASKWORK;
>>  	if (args->user_worker) {
>>  		/*
>>  		 * Mark us a user worker, and block any signal that isn't
> 
> I don't have comments on the semantics here, I do have comments on some
> future-proofing.
> 
> To my reading kthreads on the stock kernel never execute task_work.

Correct

> This suggests it would be nice for task_work_add() to at least WARN_ON
> when executing with a kthread. After all you don't want a task_work_add
> consumer adding work which will never execute.

I don't think there's much need for that, as I'm not aware of any kernel
usage that had a bug due to that. And if you did, you'd find it pretty
quick during testing as that work would just never execute.

> But then for your patch to not produce any splats there would have to be
> a flag blessing select kthreads as legitimate task_work consumers.

This patchset very much adds a specific flag for that, PF_NO_TASKWORK,
and kernel threads have it set by default. It just separates the "do I
run task_work" flag from PF_KTHREAD. So yes you could add:

WARN_ON_ONCE(task->flags & PF_NO_TASKWORK);

to task_work_add(), but I'm not really convinced it'd be super useful.

-- 
Jens Axboe

