Return-Path: <io-uring+bounces-739-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 15BFF867B1A
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 17:05:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 809A4B2F624
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 15:21:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF7E812B140;
	Mon, 26 Feb 2024 15:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zwioy171"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289F160DCB
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 15:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708960586; cv=none; b=itiFd58AQpQWALO1dHBicv6tbBIh+hQ0ZfSydRJfbpu4Z4O9+0vPe3L07U8jK/DwxW5U27674H+HV+ylrIxNlvRdpSzp+EJ02RuoiBAYWtQ1ACI6HS1amD/e2rtk2eVZuX279Zj3qiAXNBDnL7WiX61KqlZmQK0AEo0ohv9HsCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708960586; c=relaxed/simple;
	bh=yUasj2KVc+H6rP87iQDni6Pob5FqF4F+/c72v1NZF5k=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=bqQYVeq60Kb14Qpbe+gKRdwBEtRTC8ct5CIP8IrMXMO1znmMd9/H8J2T7V1F4XDqjZ7KCq2ayLVL12+16G81iG5zzmDF3zXnrzEqdj7I9RFALF2ctt3LbRiGHU0zMmSWCMc6/Mb+kwNpkebT1qBaMukESDJFdeWK8v3Ja6MsEwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zwioy171; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-564fd9eea75so3955593a12.3
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 07:16:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708960583; x=1709565383; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5VBzb5lxHU8Xb66gKzSs4OfWwx7uEc3KxuGoYCGwW5o=;
        b=Zwioy171TdcMlO2lVxSZys7u3vUUcGsbblEM0y+XwjQPR7hV8X+bloWwwQw3a3+ZLF
         Qshoakycc5x6/a2otsjnUsYeRKoxFTo7JL3dH2ZZM/W4ZhULEeFWOuXAumTvbxtg++2L
         /IJFQfWPGjhaOm680J0AW2GGeP50E/Na9HeauGs7e14g3pAnta+JbDcddUB6iwP73XR3
         zwKpFfsBB/P5Nzm9wvs8pI+AujGclrBiyG19zAkBOckInSHWam6DyS9w1yizYTZhwaUl
         ir8oGLrTzNbyiG6CBZ0p1p5lkNBFzhWqN2i22J4wUJ6qm7tBLxW9wCOuyEZteK4R0wU2
         R73w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708960583; x=1709565383;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5VBzb5lxHU8Xb66gKzSs4OfWwx7uEc3KxuGoYCGwW5o=;
        b=uG4+QoH3AIfyhliHM3X+olx+RVBXszGkjG0ViraJqr0a4OlqwMxlcug9LLbvKys0/x
         awOok5sfUuavayzNzEW0omyFKThAL6Y/toVR0xSYonmA8xJsa0u/RUE7qsWEsPrSMf/a
         pS8IYNvy/EymxvepKrKls7H5Z6dH0VDK88qTeL6aVageCgBAKqB9dNJ3oj1Wny1uHeSf
         +VKqcemDag6RPJNp+zbC8LBswLuG89avzH2mLI5Aj4VnQrxgo1XqLRQ0wvfZMZxhtmYe
         2LACmXP3LclLCJTYzwWOnO/3JW9/VKaUS3cL96BFGTLwdjVDtybvxtObalvNG6OMrIsQ
         ek0Q==
X-Forwarded-Encrypted: i=1; AJvYcCVypLBls0vW5CSp2FYwTF2O/ELaCxJz/ANCfouNXq58AMYBoaaMS0JnPQk9bJXB10D7Up6ZN7qSUopuwEJ3xTYYtkYonTBVKBo=
X-Gm-Message-State: AOJu0YwzDLyjOoan+Yzg7cIEXQB3/Og9oV2SNsXTz71PjydH+ZJdun/V
	ACWQhIJSlF/Gn8hmWpHNvbpmQTE3RO8UUE5cyWeD3UDYCLFpNe+NxwGO1qk8
X-Google-Smtp-Source: AGHT+IH5aMxMi2dugxVVgGLpS2eHAiyxShrpKdrhVwm9mmKGnY9L1owmZWbrwGNTqpcLk/6G860jYg==
X-Received: by 2002:a05:6402:556:b0:565:cbba:b7a1 with SMTP id i22-20020a056402055600b00565cbbab7a1mr2887359edx.1.1708960582777;
        Mon, 26 Feb 2024 07:16:22 -0800 (PST)
Received: from [192.168.8.100] ([85.255.235.18])
        by smtp.gmail.com with ESMTPSA id cq15-20020a056402220f00b005661a97a3basm283511edb.33.2024.02.26.07.16.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 07:16:22 -0800 (PST)
Message-ID: <c9d444ba-0200-4f9c-a6d9-c6bb0fcd127d@gmail.com>
Date: Mon, 26 Feb 2024 14:56:27 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/4] io_uring: only account cqring wait time as iowait
 if enabled for a ring
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20240224050735.1759733-1-dw@davidwei.uk>
 <678382b5-0448-4f4d-b7b7-8df7592d77a4@gmail.com>
 <2106a112-35ca-4e02-a501-546f8d734103@davidwei.uk>
 <cf1f03ce-352b-4a61-a595-d595413bc831@kernel.dk>
 <8dc18842-bb1b-4565-ab98-427cbd07542b@gmail.com>
 <a5fc01ba-d023-4f02-acb1-fa1d3cfbff2d@kernel.dk>
 <a19fc5fb-cbb3-4a61-bce2-d6cb52227c19@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a19fc5fb-cbb3-4a61-bce2-d6cb52227c19@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/25/24 21:11, Jens Axboe wrote:
> On 2/25/24 9:43 AM, Jens Axboe wrote:
>> If you are motivated, please dig into it. If not, I guess I will take a
>> look this week.

I tried to split the atomic as mentioned, but I don't think anybody
cares, it was 0.1% in perf, so wouldn't even be benchmarkeable,
and it's iowait only patch anyway. If anything you'd need to read
two vars every tick now, so nevermind

> The straight forward approach - add a nr_short_wait and ->in_short_wait
> and ensure that the idle governor factors that in. Not sure how
> palatable it is, would be nice fold iowait under this, but doesn't
> really work with how we pass back the previous state.

It might look nicer if instead adding nr_short_waiters you'd
do nr_iowait_account for the iowait% and leave nr_iowait
for cpufreq.

The block iowaiting / io_schedule / etc. would need to set
both flags...

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 9116bcc90346..dc7a08db8921 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3790,6 +3790,8 @@ ttwu_do_activate(struct rq *rq, struct task_struct *p, int wake_flags,
>   	if (p->in_iowait) {
>   		delayacct_blkio_end(p);
>   		atomic_dec(&task_rq(p)->nr_iowait);
> +	} else if (p->in_short_wait) {
> +		atomic_dec(&task_rq(p)->nr_short_wait);
>   	}
>   
>   	activate_task(rq, p, en_flags);
> @@ -4356,6 +4358,8 @@ int try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
>   			if (p->in_iowait) {
>   				delayacct_blkio_end(p);
>   				atomic_dec(&task_rq(p)->nr_iowait);
> +			} else if (p->in_short_wait) {
> +				atomic_dec(&task_rq(p)->nr_short_wait);

... which would get this branch folded into the previous one,
which should be more welcome by the sched guys.

-- 
Pavel Begunkov

