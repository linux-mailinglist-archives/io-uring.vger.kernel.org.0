Return-Path: <io-uring+bounces-1009-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C54D87D8BD
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 05:21:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4005CB213D5
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 04:21:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ECE34C6D;
	Sat, 16 Mar 2024 04:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dShtKK81"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B125C83;
	Sat, 16 Mar 2024 04:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710562909; cv=none; b=lMOm3SLaz3f6+fJevWv2dl3nJShScLv4M7wXlPTT9fhobn8weVlPKpJosswjq5xOUDKw4if1well5W+xu5BHsHv3G/l3tYrMuyI2eC12iXEDRtrmfosfs17PrWCgzQnm1lq4Vpibos2HMNn5m4XQJJ5zXDN1Ws/zi6pcdo6wE/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710562909; c=relaxed/simple;
	bh=4E7ubM3eIqrwV0NttUkqSMQMq4JuoD3D+JL3/+ESdY0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=WFqbYtd0NKTxrvmvToYz0NuYxK3/TrNwqHCLfOytTk6ZyGzt/Krc0wrYfqUZXCvmPp0JMIhmUsURyJb6N+4oQ20Y4NIywTqSEbbayAPGb9RNkSNUgoWzJ3R+RFTfdx/AHPkErx9W06zYc+Yy+Rp0Z4cFBhlOCLfR54ET5A9krCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dShtKK81; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-513b022a238so3374301e87.0;
        Fri, 15 Mar 2024 21:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710562905; x=1711167705; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mZcWIj4Hm8sNsQyJWl/bJT3zM9TFAfUYYhGX/TE7z7A=;
        b=dShtKK81rofB2mbYHYKKrQLBcYX4xVwsW44iuuM2UGNI+9aczrhEyaDN0jdLmkmfiT
         RWy2dyXeHVnrOlA9A2434GMjoppaRr1dbE+oXz4NrLpxV3gjRK7aXfd3ZoiuduvF+N/f
         faCrkSpSnkDYKm8nNHQf2MhBaD7cNr1l/C4W42J7FOp6GwZZ5wwG7MnMTbvgUoO818ii
         tCFeHNbBp8pvL4pJbFLWy3qq3g3fus36g+nFPdw0wzjIu+4tsnAIry01SlU8YdtBJexc
         bpKSaYNyJzGVK+AUznaBc8VmpNtY/jlPVojNzD2oBRfCHSzKFh6EFK2/WSNJoXBjhiRv
         G57A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710562905; x=1711167705;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mZcWIj4Hm8sNsQyJWl/bJT3zM9TFAfUYYhGX/TE7z7A=;
        b=Va7bDMaTD2LYDLhjTrmPjqyUSXodmcVa3xGcuavbiLOIlCmpVjF2E+W4ilMBbTqTqI
         EEjDHXuDinuBCaE1Z8ce0dKZnEkmJLYQ4Co94xGEHr39P08wArw+taVu2dMWB+HWGb//
         Sf+h1waaapyICyWxhMu4D5eVYolHKsLdeRo6EqtEi07pyh08ONdJqrZ0Y/wOzxt+aNMp
         CDLn7+pC8a3p3YlxTwRhddYdijyVuTahU5ZF5wU29SlvjNW2YQD5JcEymlXgKBSmfAuj
         b16isNW+JgH6blFciCkyLSoPSZbYtG1toT8VotGrk2pEEfGAVCYoeIOxC0aMAreI7tjp
         dZdg==
X-Forwarded-Encrypted: i=1; AJvYcCUYD2orI64UaLO4tNJ9HHwz7cD0h7jSbd40ZvFbrtbeLuUDjQz1RPxVE4crDlUGzdEdiLiUG9h6KDxm4AvjRTHgGHn2IPalhIgJwm0uDOX2qZ0lxEHEk0HhE6v9PvL6L6U1fmCjQw==
X-Gm-Message-State: AOJu0Yzi90q1S9QlmtTCxOmsYqT7X84LgWOdjocDfOdYqdTH13mwLmlN
	VRQmYk7n8Tc6GTHW4TqBIckxdiSocd9evGuMlSzF7G6I4f1bisqrabh2xD4k
X-Google-Smtp-Source: AGHT+IEJAvRiuaaUCvv37BDaE+4o/CBaKFiX5GWs1vz5rsUpBa1+ECC7lGY70G/KoMF2syIOGWI10A==
X-Received: by 2002:a19:2d4b:0:b0:512:ab58:3807 with SMTP id t11-20020a192d4b000000b00512ab583807mr1379887lft.9.1710562904954;
        Fri, 15 Mar 2024 21:21:44 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.99])
        by smtp.gmail.com with ESMTPSA id f11-20020a05600c4e8b00b004132f3ace5csm10803432wmq.37.2024.03.15.21.21.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 21:21:44 -0700 (PDT)
Message-ID: <a2ae9037-d115-404e-9304-7b0959565836@gmail.com>
Date: Sat, 16 Mar 2024 04:20:25 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH 00/11] remove aux CQE caches
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
 <171054320158.386037.13510354610893597382.b4-ty@kernel.dk>
 <ZfT+CDCl+07rlRIp@fedora>
 <CAFj5m9LXFxaeVyWgPGMiJLaueXkpcLz=506Bp_mhpjKU59eEnw@mail.gmail.com>
 <6dcd9e5d-f5c7-4c05-aa48-1fab7b0072ea@gmail.com> <ZfUX/kSYOW6we1SB@fedora>
 <f538b6a2-3898-4028-a63c-7641f02f5bdf@gmail.com>
In-Reply-To: <f538b6a2-3898-4028-a63c-7641f02f5bdf@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/16/24 04:13, Pavel Begunkov wrote:
> On 3/16/24 03:54, Ming Lei wrote:
>> On Sat, Mar 16, 2024 at 02:54:19AM +0000, Pavel Begunkov wrote:
>>> On 3/16/24 02:24, Ming Lei wrote:
>>>> On Sat, Mar 16, 2024 at 10:04 AM Ming Lei <ming.lei@redhat.com> wrote:
>>>>>
>>>>> On Fri, Mar 15, 2024 at 04:53:21PM -0600, Jens Axboe wrote:
>>>>>>
>>>>>> On Fri, 15 Mar 2024 15:29:50 +0000, Pavel Begunkov wrote:
>>>>>>> Patch 1 is a fix.
>>>>>>>
>>>>>>> Patches 2-7 are cleanups mainly dealing with issue_flags conversions,
>>>>>>> misundertsandings of the flags and of the tw state. It'd be great to have
>>>>>>> even without even w/o the rest.
>>>>>>>
>>>>>>> 8-11 mandate ctx locking for task_work and finally removes the CQE
>>>>>>> caches, instead we post directly into the CQ. Note that the cache is
>>>>>>> used by multishot auxiliary completions.
>>>>>>>
>>>>>>> [...]
>>>>>>
>>>>>> Applied, thanks!
>>>>>
>>>>> Hi Jens and Pavel,
>>>>>
>>>>> Looks this patch causes hang when running './check ublk/002' in blktests.
>>>>
>>>> Not take close look, and  I guess it hangs in
>>>>
>>>> io_uring_cmd_del_cancelable() -> io_ring_submit_lock
>>>
>>> Thanks, the trace doesn't completely explains it, but my blind spot
>>> was io_uring_cmd_done() potentially grabbing the mutex. They're
>>> supposed to be irq safe mimicking io_req_task_work_add(), that's how
>>> nvme passthrough uses it as well (but at least it doesn't need the
>>> cancellation bits).
>>>
>>> One option is to replace it with a spinlock, the other is to delay
>>> the io_uring_cmd_del_cancelable() call to the task_work callback.
>>> The latter would be cleaner and more preferable, but I'm lacking
>>> context to tell if that would be correct. Ming, what do you think?
>>
>> I prefer to the latter approach because the two cancelable helpers are
>> run in fast path.
>>
>> Looks all new io_uring_cmd_complete() in ublk have this issue, and the
>> following patch should avoid them all.
> 
> The one I have in mind on top of the current tree would be like below.
> Untested, and doesn't allow this cancellation thing for iopoll. I'll
> prepare something tomorrow.
> 
> 
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index e45d4cd5ef82..000ba435451c 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -14,19 +14,15 @@
>   #include "rsrc.h"
>   #include "uring_cmd.h"
> 
> -static void io_uring_cmd_del_cancelable(struct io_uring_cmd *cmd,
> -        unsigned int issue_flags)
> +static void io_uring_cmd_del_cancelable(struct io_uring_cmd *cmd)
>   {
>       struct io_kiocb *req = cmd_to_io_kiocb(cmd);
> -    struct io_ring_ctx *ctx = req->ctx;
> 
>       if (!(cmd->flags & IORING_URING_CMD_CANCELABLE))
>           return;
> 
>       cmd->flags &= ~IORING_URING_CMD_CANCELABLE;
> -    io_ring_submit_lock(ctx, issue_flags);
>       hlist_del(&req->hash_node);
> -    io_ring_submit_unlock(ctx, issue_flags);
>   }
> 
>   /*
> @@ -80,6 +76,15 @@ static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
>       req->big_cqe.extra2 = extra2;
>   }
> 
> +static void io_req_task_cmd_complete(struct io_kiocb *req,
> +                     struct io_tw_state *ts)
> +{
> +    struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
> +
> +    io_uring_cmd_del_cancelable(ioucmd);
> +    io_req_task_complete(req, ts);
> +}
> +
>   /*
>    * Called by consumers of io_uring_cmd, if they originally returned
>    * -EIOCBQUEUED upon receiving the command.
> @@ -89,8 +94,6 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
>   {
>       struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
> 
> -    io_uring_cmd_del_cancelable(ioucmd, issue_flags);
> -
>       if (ret < 0)
>           req_set_fail(req);
> 
> @@ -105,7 +108,7 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
>               return;

Not very well thought through... Here should be a *del_cancelable call
as well

>           io_req_complete_defer(req);
>       } else {
> -        req->io_task_work.func = io_req_task_complete;
> +        req->io_task_work.func = io_req_task_cmd_complete;
>           io_req_task_work_add(req);
>       }
>   }
> 

-- 
Pavel Begunkov

