Return-Path: <io-uring+bounces-2461-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DCC892A5E5
	for <lists+io-uring@lfdr.de>; Mon,  8 Jul 2024 17:40:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05BE828454C
	for <lists+io-uring@lfdr.de>; Mon,  8 Jul 2024 15:40:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1516140363;
	Mon,  8 Jul 2024 15:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Abd06NVO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233C313B7A3;
	Mon,  8 Jul 2024 15:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720453204; cv=none; b=InkVtugEMsF9w7YOyzIcTiWCLbFf90voi9qy72TX3p61CQLdhu//G4qmMwC74HnkmFhwMCTjNkeVrKnQ4cacgqEubqqGBt9MMc9yRl8GHCQGRURNu9PkSQxPQBLORkKOx1BQ0reLaJ4yCd4Jpd/H1RQX1hH4M/jvsYgYR2hV90w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720453204; c=relaxed/simple;
	bh=pvPOUFYWBe65xe/4kqz1kS7V0Nu6FfHZexhreB2xFqc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LRIY0e79/f8yMzgVMefFl6n2lCQ6jDuKUe0iQSiNr8aZbjkyJ1s31AgoPKnQXe5ed/HfArw20DICOYTdXjNL5YTm/ivkNNjutOgbexfQoweGBJDLOlJ/4BZE38AJ1aN1KtB2QX4VhSJ4fJrxddEB/8pD3ogqKVmgd1jtOvVl3RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Abd06NVO; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-58c947a6692so5129512a12.0;
        Mon, 08 Jul 2024 08:40:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720453201; x=1721058001; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8cIbrzp/9+rBGOi+JydWc8Pqt8a2TXPEYOYm+hPpzu4=;
        b=Abd06NVOHqA4pbtDragAmKXrVQQMrsOSeN4CM8MKdCO6sX+UH/DUthgw/9vs1MbMok
         0ITMhZS7Vap5dy0T/uRK4jqPHiHINUmnncnD2DN2/xLFLRhBvdfKa5sA7Ag7E1tmm4pO
         2Ymr7khRRI5+RJWlEb4mGdqe76LonP1qnkWDaeuT9T0lMhDF0i0Gu3d64mE52pmIuP+l
         KWvYult7po7ejxBTapSQywtG333YF9pXf0O/gaaDcza6BUdyfhY+oL8UZqwDmE5yCE7/
         1W55tzkvJ6hLQaRkb1fAdXspb+ab+KeBx8uTfsDXNuS4Uv148re4V2P26XVaRhdJdcY1
         1z3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720453201; x=1721058001;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8cIbrzp/9+rBGOi+JydWc8Pqt8a2TXPEYOYm+hPpzu4=;
        b=iQ20wYMRndvj1ZviPb/fIbphL+boIbr7oxpAWSFD+Q14igYZgf7llwF2BzP+qPxBZ1
         2C9BHCZ0IbtsSna7GQmmkxdsMCjBqLBZa3bzZYxGEjwCPLBGhCU16rdiBYrsHjXrbI/U
         cpLko2AWcho+bhSBtNBdMH4NxJ6I/0Ud3y9kB9DaauS5wXFenuM31VQ7at81boss329/
         aJYbFGXlaSh3jdf71ZZhaCcKFsn5iP18IDipFzxgwTQh90OV7dzN1qXgBEEP55QBTy/w
         KsuqizZ+PzI9d6O+EsuKOviQH9kaiRp4dbxPVyQ+gYNKHvLTFoBldfhmFdvQ1igkDp8g
         pIjA==
X-Forwarded-Encrypted: i=1; AJvYcCVyNGx5xDcsGaNxJJsV9wyGrONA4+iV9E8lWnA1KGOD87822XbcN+42ufVLLGMlnd/hWst2MJ9c9/KiOaVP2jXRfhzQAapRfUR0/UGV
X-Gm-Message-State: AOJu0YzZP6DaTZRJUlvh4Ra4All92siGITg4HkIpGWZDZLFrvm9RCIHn
	2BwwFa+RSPJ8B//7aXpfir/KF0AKv/PNijMnrEEt0VE/hcE+k6Xn
X-Google-Smtp-Source: AGHT+IFGpZR2YtZobflHmofogwGIAmCHG0go1fqlzmSQEcoFqmffLFqMWjBXdMl1Taf3eaT4uezs8A==
X-Received: by 2002:a17:906:228d:b0:a77:c314:d621 with SMTP id a640c23a62f3a-a77c314d83amr592775266b.13.1720453201110;
        Mon, 08 Jul 2024 08:40:01 -0700 (PDT)
Received: from [192.168.42.229] ([85.255.235.223])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a780a7ff021sm4139166b.103.2024.07.08.08.40.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jul 2024 08:40:00 -0700 (PDT)
Message-ID: <62c11b59-c909-4c60-8370-77729544ec0a@gmail.com>
Date: Mon, 8 Jul 2024 16:40:07 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] kernel: rerun task_work while freezing in
 get_signal()
To: Oleg Nesterov <oleg@redhat.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christian Brauner <brauner@kernel.org>,
 Tycho Andersen <tandersen@netflix.com>, Thomas Gleixner
 <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
 Julian Orth <ju.orth@gmail.com>, Tejun Heo <tj@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>
References: <cover.1720368770.git.asml.silence@gmail.com>
 <1d935e9d87fd8672ef3e8a9a0db340d355ea08b4.1720368770.git.asml.silence@gmail.com>
 <20240708104221.GA18761@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240708104221.GA18761@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/8/24 11:42, Oleg Nesterov wrote:
> On 07/07, Pavel Begunkov wrote:
>>
>> io_uring can asynchronously add a task_work while the task is getting
>> freezed. TIF_NOTIFY_SIGNAL will prevent the task from sleeping in
>> do_freezer_trap(), and since the get_signal()'s relock loop doesn't
>> retry task_work, the task will spin there not being able to sleep
>> until the freezing is cancelled / the task is killed / etc.
>>
>> Cc: stable@vger.kernel.org
>> Link: https://github.com/systemd/systemd/issues/33626
>> Fixes: 3146cba99aa28 ("io-wq: make worker creation resilient against signals")
> 
> I don't think we should blame io_uring even if so far it is the only user
> of TWA_SIGNAL.

And it's not entirely correct even for backporting purposes,
I'll pin it to when freezing was introduced then.

> Perhaps we should change do_freezer_trap() somehow, not sure... It assumes
> that TIF_SIGPENDING is the only reason to not sleep in TASK_INTERRUPTIBLE,
> today this is not true.

Let's CC Peter Zijlstra and Tejun in case they might have
some input on that.

Link to this patch for convenience:
https://lore.kernel.org/all/1d935e9d87fd8672ef3e8a9a0db340d355ea08b4.1720368770.git.asml.silence@gmail.com/

>> --- a/kernel/signal.c
>> +++ b/kernel/signal.c
>> @@ -2694,6 +2694,10 @@ bool get_signal(struct ksignal *ksig)
>>   	try_to_freeze();
>>   
>>   relock:
>> +	clear_notify_signal();
>> +	if (unlikely(task_work_pending(current)))
>> +		task_work_run();
>> +
>>   	spin_lock_irq(&sighand->siglock);
> 
> Well, but can't we kill the same code at the start of get_signal() then?
> Of course, in this case get_signal() should check signal_pending(), not
> task_sigpending().

Should be fine, but I didn't want to change the
try_to_freeze() -> __refrigerator() path, which also reschedules.

> Or perhaps something like the patch below makes more sense? I dunno...

It needs a far backporting, I'd really prefer to keep it
lean and without more side effects if possible, unless
there is a strong opinion on that.

> Oleg.
> 
> diff --git a/kernel/signal.c b/kernel/signal.c
> index 1f9dd41c04be..e2ae85293fbb 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -2676,6 +2676,7 @@ bool get_signal(struct ksignal *ksig)
>   	struct signal_struct *signal = current->signal;
>   	int signr;
>   
> +start:
>   	clear_notify_signal();
>   	if (unlikely(task_work_pending(current)))
>   		task_work_run();
> @@ -2760,10 +2761,11 @@ bool get_signal(struct ksignal *ksig)
>   			if (current->jobctl & JOBCTL_TRAP_MASK) {
>   				do_jobctl_trap();
>   				spin_unlock_irq(&sighand->siglock);
> +				goto relock;
>   			} else if (current->jobctl & JOBCTL_TRAP_FREEZE)
>   				do_freezer_trap();
> -
> -			goto relock;
> +				goto start;
> +			}
>   		}
>   
>   		/*
> 

-- 
Pavel Begunkov

