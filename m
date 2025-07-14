Return-Path: <io-uring+bounces-8664-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 18600B0423F
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 16:55:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EB1316A5BE
	for <lists+io-uring@lfdr.de>; Mon, 14 Jul 2025 14:54:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72BCB2528F3;
	Mon, 14 Jul 2025 14:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mfJOF40/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46E11D6DA9
	for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 14:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752504874; cv=none; b=HZe6cK5xHPTEc30SdFoNx3FNGCxqs8nCYMIn1g5ySq8o8g1J6STjGkpAdy2Ld6rx5XWmIk+eOkUt7AawKILOU4NIWtmBCkU6PT2UoFdSFrCLGuGWyoEc26vIDqpcf3ruNqrcTuwUEfSRekQ2thaNPgAKPf/Yl47pHozHakfbRA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752504874; c=relaxed/simple;
	bh=0MHBYcHzrwJNQHLPwRv3dzy6BV9CatCLrbCNmxSQmEc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sX7Srh95FgSi1XVsrQHKK/4DAmz7BTQ2pXbQeWMDPyZjXIBwMmNbf+qjjU3JkzYdMwZ35kiTLyqm93Nu1din+CXdZMqvrTWWEK6QGTbQD32m+24nQ0VP5hY2xZC3tejinTt0JxKoMaT/5YXZmA7ClxmrWWdh/rbQ15hcnUZ0zpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mfJOF40/; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-874a68f6516so409050839f.2
        for <io-uring@vger.kernel.org>; Mon, 14 Jul 2025 07:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752504870; x=1753109670; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fPYlYeadyycUWsZFw0ZgybUK5oabQWNtc2703ybpEXA=;
        b=mfJOF40/MHRSKomUO58b4RZPs6a+9LKieOiATDq7YGqgmg8x86yEN0KXHPZD8hV6IN
         PYDwxWLAKGkEBzaaypXGjgx5wetyF7WNvXOdIaEjyS4OCGvhde2xp9K8H7qvhxtFPeo5
         QrgfzgOkJ4+tQy0cDKJbrN1KIcWYp8xbDTCcGf3SG9yShk5aknfiy5aNWJ2MFzKR0Aa1
         Hc+iV5Sqwof7F3lmVw9FPyqUrXNY98NcHnswAr2+Y3biYXX7XiDD7rS8LtOCV4B3kw5o
         50neKSQvL/XC7oCU//sIF0Zops7/ZBbcw3gLdzgQvTSV3i9vyysUmUvgdDg6Sqs3FPRq
         teBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752504870; x=1753109670;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fPYlYeadyycUWsZFw0ZgybUK5oabQWNtc2703ybpEXA=;
        b=vsc/S9PuCrb8Gzj2sKYhEf3tEySS+sm8iqFLaQIVhibvM0EGG7UdnpGLKuCJXAGvwR
         u0OPrDzDimbFBSw7n9xF/pFfmgIiKYroC0jUeJ6fx8fJD1vdoQZlrpQe+WPT4SjENtdj
         H683+ddOqimSU6DXDgOo4ufnRpUDeP532pXK5lIBsRWrWU/BCP5eko/arFWREb0GpHJ5
         9J1OT46SUH0bgyKup6fLzFPM49qWAI5+6SiYSxzH2fF6AQZVRtbAmKAYk39XF4nwzFWE
         DsJqQWXwRZokhZdCgLIOut0D471dTNfKHp1KWldSpAeF76s0E+rPBozlk8isXkFpBwPE
         NCVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXnXSG/0lvcfYowVqUa7YQXMMFZUMNuDJV/nQUBsBwj5kt69uelvjBcD9Rb5wZiKZeKNojxm/aj9A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxGSBZaEnqpVk28xzwruCkqVKHOsVl9QmUCH7WEpvGhjwuf7ye2
	lsksfWntI5KJqq43zcs2H857Ljlqh23tJvG7R5VdPXD5zQx/VDk4O6i7/5KARh7Ndx4=
X-Gm-Gg: ASbGncuxZltrM6C0mtffGRC/2x4XlLWCrge9Ji/1MVbdsSwmcgBWtQrjiwtlY+61S7R
	g19RUvcNmsPHz/RZVhFEOKDC9OTf0TEkXJXZStwRhtoH+OQHi7cuawln+mBgS3sZE/DrVfCCE0k
	nwo4T4h9CM+OATV91mHi86FWd32ajoY7k7FbIjzZacPOldPujX9sDmbOhm0k3SSZ81cH0J92lMm
	ffbnEV03yEYqJzKHflHkIo4SwqnMVJ4ZibfQMBW+NlLkxj5lNtBl1H91eAKCJhf6ctcD3kWzhFj
	caKEyOfB99fn5SE5W3poFcZiYBfNsnPTtEnCK/K1/u9yG7dtOEsaC6P8M8vlo/1fgUORxvkzqOf
	KIIcc/U63pIydxGVG/gs=
X-Google-Smtp-Source: AGHT+IGBYQ8NVFDYDhTocuBdxqV7k691Gg55bZuJXgBLO3uV1b1SrVTXWf9XXNOcVsg84S7ivW+LGA==
X-Received: by 2002:a05:6e02:3804:b0:3df:3464:ab86 with SMTP id e9e14a558f8ab-3e2532a69f2mr124043875ab.9.1752504869558;
        Mon, 14 Jul 2025 07:54:29 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-505565324d7sm2029691173.3.2025.07.14.07.54.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 07:54:29 -0700 (PDT)
Message-ID: <e24aaa01-e703-4a6b-9d1c-bf5deacbda86@kernel.dk>
Date: Mon, 14 Jul 2025 08:54:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring/poll: flag request as having gone through
 poll wake machinery
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <[PATCHSET 0/3] Add support for IORING_CQE_F_POLLED>
 <20250712000344.1579663-1-axboe@kernel.dk>
 <20250712000344.1579663-3-axboe@kernel.dk>
 <801afb46-4070-4df4-a3f6-cb55ceb22a00@gmail.com>
 <9d9b87d4-78df-4c31-8504-8dbc633ccb22@kernel.dk>
 <e89d9a26-0d54-4c22-85d2-6f6c7bad9a73@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e89d9a26-0d54-4c22-85d2-6f6c7bad9a73@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/14/25 3:26 AM, Pavel Begunkov wrote:
> On 7/12/25 21:59, Jens Axboe wrote:
>> On 7/12/25 5:39 AM, Pavel Begunkov wrote:
>>> On 7/12/25 00:59, Jens Axboe wrote:
>>>> No functional changes in this patch, just in preparation for being able
>>>> to flag completions as having completed via being triggered from poll.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>    include/linux/io_uring_types.h | 3 +++
>>>>    io_uring/poll.c                | 1 +
>>>>    2 files changed, 4 insertions(+)
>>>>
>>>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>>>> index 80a178f3d896..b56fe2247077 100644
>>>> --- a/include/linux/io_uring_types.h
>>>> +++ b/include/linux/io_uring_types.h
>>>> @@ -505,6 +505,7 @@ enum {
>>>>        REQ_F_HAS_METADATA_BIT,
>>>>        REQ_F_IMPORT_BUFFER_BIT,
>>>>        REQ_F_SQE_COPIED_BIT,
>>>> +    REQ_F_POLL_WAKE_BIT,
>>>>          /* not a real bit, just to check we're not overflowing the space */
>>>>        __REQ_F_LAST_BIT,
>>>> @@ -596,6 +597,8 @@ enum {
>>>>        REQ_F_IMPORT_BUFFER    = IO_REQ_FLAG(REQ_F_IMPORT_BUFFER_BIT),
>>>>        /* ->sqe_copy() has been called, if necessary */
>>>>        REQ_F_SQE_COPIED    = IO_REQ_FLAG(REQ_F_SQE_COPIED_BIT),
>>>> +    /* request went through poll wakeup machinery */
>>>> +    REQ_F_POLL_WAKE        = IO_REQ_FLAG(REQ_F_POLL_WAKE_BIT),
>>>>    };
>>>>      typedef void (*io_req_tw_func_t)(struct io_kiocb *req, io_tw_token_t tw);
>>>> diff --git a/io_uring/poll.c b/io_uring/poll.c
>>>> index c7e9fb34563d..e1950b744f3b 100644
>>>> --- a/io_uring/poll.c
>>>> +++ b/io_uring/poll.c
>>>> @@ -423,6 +423,7 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>>>>                else
>>>>                    req->flags &= ~REQ_F_SINGLE_POLL;
>>>>            }
>>>> +        req->flags |= REQ_F_POLL_WAKE;
>>>
>>> Same, it's overhead for all polled requests for a not clear gain.
>>> Just move it to the arming function. It's also not correct to
>>> keep it here, if that's what you care about.
>>
>> Not too worried about overhead, for an unlocked or. The whole poll
> 
> You know, I wrote this machinery and optimised it, I'm not saying it
> to just piss you off, I still need it to work well for zcrx :)

This was not a critique of the code, it's just a generic statement on
the serialization around poll triggering is obviously a lot more
expensive than basic flag checking or setting. Every comment is not a
backhanded attack on someones code.

> Not going into details, but it's not such a simple unlocked or. And
> death by a thousand is never old either.

That's obviously true, I was just trying to set expectations that a
single flag mask is not really a big deal. If the idea and feature was
fully solidified and useful, then arguing that adding a bit or is a
problem is nonsense. By that standard, we could never add anything to
the code, only remove. At the same time, adding frivolous code is of
course always a bad idea.

>> machinery is pretty intense in that regard. But yeah, do agree that just
>> moving it to arming would be better and more appropriate too.
>>
>> I'm still a bit split on whether this makes any sense at all, 2-3 really
> 
> Right, that what I meant by unclear benefit. You're returning
> information from past when it's be already irrelevant, especially
> so for socket tx with how they handle their wait queue wakeups.

Indeed, and that's really the core of it and why I'm not totally sold on
it either. As mentioned in a previous email, I think it's better to let
this concept brew a bit in the background. Maybe something more specific
and useful will come out of this later.

-- 
Jens Axboe

