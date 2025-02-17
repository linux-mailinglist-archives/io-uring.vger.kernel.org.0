Return-Path: <io-uring+bounces-6493-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AA7FA388C0
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 17:07:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 30F2C189B3B1
	for <lists+io-uring@lfdr.de>; Mon, 17 Feb 2025 16:02:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6B3E22579D;
	Mon, 17 Feb 2025 15:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cUwHPrw/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A3E22578B
	for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 15:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739807846; cv=none; b=HnUQbh35y5PkAwry2tXT0p2XKqi7/h1YKRyie7tcP2kQadJOjSx9g+jayW/+iYmiTH1+aCHHU2FMBi6LpoWeCVSYzptFh/gzLnoNtGshU5PVm2CGsPaVb5CHESvkGbEwqlTkssqe1ub8AiBnEsU1HrHBlPDdkLgpzMqwlCcILK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739807846; c=relaxed/simple;
	bh=8c08EzOvn6HuFuigFyESjK/Rg7sZXEF6G7gTfP2NSp4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=oimUsc8CeAs7hjzP/OSBp4v0rj41Tz0SmntSQZvUOu+fcnPNz2CeAm0rybKpoIzVgTUy4zY45teJxWfxR3Q8VWu9MfMI2/gqrIb8e5uEual5og8G+4POvOjM1MVLFdjz2y00/CDrwVGMHsnazfclVEuFnaAx8yy2Ld0LW3g5dL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cUwHPrw/; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3d284b9734fso20168355ab.2
        for <io-uring@vger.kernel.org>; Mon, 17 Feb 2025 07:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739807843; x=1740412643; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fnHr7H+pYTdBsVUj5LfY9XzKNTplyyxEawv55GYD4hs=;
        b=cUwHPrw/Whoi7fnn/Ocpvg4JH+fO0cV3vF+pKHHmt2FeHIm5W/8BAdA+SionMBZ934
         ddAToihlnZgSjmdYH40/FEGJMAkWR2OW57b8PvN8oNyA/OOkejxnY7ebRuHGcOUZp3br
         9fYxYfdVYV+a0fAn5+Ps5OEX543WBxJC92CHVXsNAycXy3efk2bA+93J5mUkKFRG89eh
         SgTjxEHAzAcGz6Ky7qEcS1tASZRB3C66u3MqA+XDM+XU1vUo6UTzxv7nPed9Q3cFppP8
         rqmDwgYSkut6HWsKAXN1fzP8LwYXljo8hSLoFNnVQT63/z+RjHU4YxA5zvpA33y8TL4L
         s4/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739807843; x=1740412643;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fnHr7H+pYTdBsVUj5LfY9XzKNTplyyxEawv55GYD4hs=;
        b=WRceXf2jZxkBy0SPC1ChBa1jinvUMok5Xr8CJ6FBH0Kyr85xnfCkd5j6ESCnpExnE1
         IVZWfKM4op8l3DXDEb5LfykLAOOD+eUg2Ej8cxJS9Ggf2n38MeUW99uw28nj98/SZMpX
         +zrmsNROQWy3V8ksjaZaL3Z1/zawSBMdrLGtektDB294bN57Qyq3x3kLg5PKUa9uRTyq
         +DOkIk9yoTSbzjXW0alPf4PC9Mbo6MTPFNwUKcUcFJHUECBXC5jabcCPXh3OfDP9J4bu
         E2ZpCM+cGbHVIm016Zq8+O9Fv2pCs7VzP71TpNiIitMCGV/tjJmgQBYYYXs9SjNTs9x2
         Ez/A==
X-Forwarded-Encrypted: i=1; AJvYcCUIXXCiNxBETrWnWyLhAIeU5unAfPSScaCp3LtUAPt6MORrzHQUBdJGKQSiF6HU+hOYsuKlkKGm5w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxDQLbm7kf8wx1QvATlnoZ+c7nENU9BJEPuw4zXt6RMpEWrV4Ch
	5Kme+xeyU5ffkiS7dv1kJoqfUSDQA8cjYz00iZtEv5bqXvhZiESIIY2kuBI4XnE=
X-Gm-Gg: ASbGncufIt1WhQTV8dvtt1KQWkTzaAEHUDe3tjVokD8MU3XK8v6J5LzxOZwgqBysdBL
	XLNXvAxs2dpTTYZuUFIyoMznahE4sjyJHqoOc3vnHt+xHKyZU9MS5af58lMFaA2nArrEs0SFXgH
	/Xu46qW/iWVIYkBzuFJjmpLiZcNBcXcTSQf6M66uig28pjD7xAXVWjf7VrmlsCeYvnKQ8U1xgqN
	QzsrcijZ5xakv62IUUiqfUZRb/R1/idKQpC/vSmecO6xmUBKPfInnMq6vQzdSr8UcD+Owaz4g2t
	57aEJvOE59WT
X-Google-Smtp-Source: AGHT+IEcxWHJe6qySI0zZtCdSH6q+LV9rb4boy1ML/wi+G7Azsx0FhvqXKucsQHQ2juPfWK9pYThpw==
X-Received: by 2002:a05:6e02:2181:b0:3a7:88f2:cfa9 with SMTP id e9e14a558f8ab-3d2808feeb1mr64355395ab.11.1739807843036;
        Mon, 17 Feb 2025 07:57:23 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d2a65ce0d7sm745875ab.12.2025.02.17.07.57.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Feb 2025 07:57:22 -0800 (PST)
Message-ID: <4fcb1ef3-689e-4c1f-9734-d4affd518d58@kernel.dk>
Date: Mon, 17 Feb 2025 08:57:21 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/rw: forbid multishot async reads
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <49f065f7b88b7a67190ce65919e7c93c04b3a74b.1739799395.git.asml.silence@gmail.com>
 <cd42f912-df8a-4c9d-a891-1c127f6b6fa0@kernel.dk>
 <b89b5ef0-9db9-44e6-9ae3-aabf39a70759@gmail.com>
 <b4c65139-b1e4-4a00-a70b-f1e1c3661d83@kernel.dk>
 <5d50f5bf-1f2a-4b01-9749-d65b52d77e76@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <5d50f5bf-1f2a-4b01-9749-d65b52d77e76@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2/17/25 8:33 AM, Pavel Begunkov wrote:
> On 2/17/25 15:06, Jens Axboe wrote:
>> On 2/17/25 7:12 AM, Pavel Begunkov wrote:
>>> On 2/17/25 13:58, Jens Axboe wrote:
>>>> On 2/17/25 6:37 AM, Pavel Begunkov wrote:
>>>>> At the moment we can't sanely handle queuing an async request from a
>>>>> multishot context, so disable them. It shouldn't matter as pollable
>>>>> files / socekts don't normally do async.
>>>>
>>>> Having something pollable that can return -EIOCBQUEUED is odd, but
>>>> that's just a side comment.
>>>>
>>>>
>>>>> diff --git a/io_uring/rw.c b/io_uring/rw.c
>>>>> index 96b42c331267..4bda46c5eb20 100644
>>>>> --- a/io_uring/rw.c
>>>>> +++ b/io_uring/rw.c
>>>>> @@ -878,7 +878,15 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
>>>>>        if (unlikely(ret))
>>>>>            return ret;
>>>>>    -    ret = io_iter_do_read(rw, &io->iter);
>>>>> +    if (unlikely(req->opcode == IORING_OP_READ_MULTISHOT)) {
>>>>> +        void *cb_copy = rw->kiocb.ki_complete;
>>>>> +
>>>>> +        rw->kiocb.ki_complete = NULL;
>>>>> +        ret = io_iter_do_read(rw, &io->iter);
>>>>> +        rw->kiocb.ki_complete = cb_copy;
>>>>> +    } else {
>>>>> +        ret = io_iter_do_read(rw, &io->iter);
>>>>> +    }
>>>>
>>>> This looks a bit odd. Why can't io_read_mshot() just clear
>>>> ->ki_complete?
>>>
>>> Forgot about that one, as for restoring it back, io_uring compares
>>> or calls ->ki_complete in a couple of places, this way the patch
>>> is more contained. It can definitely be refactored on top.
>>
>> I'd be tempted to do that for the fix too, the patch as-is is a
>> bit of an eye sore... Hmm.
> 
> It is an eyesore, sure, but I think a simple/concise eyesore is
> better as a fix than having to change a couple more blocks across
> rw.c. It probably wouldn't be too many changes, but I can't say
> I'm concerned about this version too much as long as it can be
> reshuffled later.

Sure, as discussed let's do a cleanup series on top. You'll send out
a v2 with some improved commit message wording?

-- 
Jens Axboe


