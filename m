Return-Path: <io-uring+bounces-3999-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AC7A89AEF36
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 20:09:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C6891F23B20
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 18:09:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A88A71FBF50;
	Thu, 24 Oct 2024 18:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N6aSfLQH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9E11D3195;
	Thu, 24 Oct 2024 18:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729793370; cv=none; b=qhKk7ZHL2tZmWnwNuTfqZIRLSdXsuQTS2EJfNtOTafwkFgW01fF79imqGXWH6q4nlHdRjmu+mOWkiCnissj6+5BghlPrulRpCmh8BM0acwliTiL4511HOH4xs9rfkhqy/JxMk7YRMi9sDV73ylsosw5nEm5s5x7SLpl9kyHzqn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729793370; c=relaxed/simple;
	bh=mZrqIPbWD2XR4gVDDsIspNXqD8W28PsXAi0Vx3T2DOY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oOkVhJWhtGlDMyQq6gZzkA5McxDhtDj5flUbF3c7dsn/UOTBczgbE0l0N+IGX4X99OuagGkEJ17nsiA9uAgE8POrR/ww5I3dZw8YSIm4zmClUgf/X1vFPHVRd1r7/VUZ2//7PVyQScBm/dn4K00O+pjMp+8CEM9PqEl9A/jvRhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N6aSfLQH; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a9a26a5d6bfso161344466b.1;
        Thu, 24 Oct 2024 11:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729793366; x=1730398166; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X00KeFCO+XW/rhhuyEmi7r+QpexBxGBKXmR+pez2QnY=;
        b=N6aSfLQHVqpptaY8Nci4UQwB4OIccIrHZWF9/IXr3HBKexsYm5up3X3UqSAlLb9es5
         viCRZr42rD1M+elg9vGp1qYCdJjz6PzjXrv0NU+kYrKngy1Zr44k4ik+4INR9+/GdGfg
         wsr/kQpxfXocdWGPboOM2nQWKoIAsO5Xc58ee2+cwdirGhrYT1phkf+1kHeiy8+iNpaY
         fOihzoK291SMch1EAKR27N+y6Jfv4ZJ08DVWER2skI/4YnHlLX2os5ALtEcQNtWu/rJV
         h+mBKGCIsi8qfR5boGjw/tBpMzEcGZdxgYDWE6lJL2LRpeM9JZXuTTEmhkAzI6reNm6h
         wnww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729793366; x=1730398166;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X00KeFCO+XW/rhhuyEmi7r+QpexBxGBKXmR+pez2QnY=;
        b=jCpObxvxQOJ6WvFa0234XRL7URUsfd4xSWIZyOkGsEVFmD7R/BLDr5VpALIXHCxcNx
         Q0EhgdlJ/y77PF0Uj+NhCbxJzajwTeD2l/k0FmtI3QgriP90QRt1IF2E+JytzsLy72Th
         oEWY782KcnE+JYBILP1od8X8MaNAojb1D7tQezA1WZfSCNaUYDpKrxp/tKJKdslAtb6C
         IGlfjfFYKl1RLg0csxmb79Roa49iQYpWE89yowwftEfi86zRQrNBXPOFXEAE30yM1lhp
         dglPlzKzlLJqcBPvRMDyMWWP0VikUNMLvT5IOtRyCXja1sou76EulLnu3Zp1Bbp2nBH1
         YdvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPAbDoSjOjvVgWxXwMS/wyu7K8ofJIUFWg38KQO7SQr6dZ92rYk6qf3vG5vIMATmpX91lELer1nIu0T5c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfzDCVaxVzNb+7NLfK1tL3z2GDcpfuDyfHN1Br+5tW0xDcawjW
	kdO7SF21z33iW3E4qKksoXDoGp9KoGzBFq27BvE/DeKXnb8TBKKllhp5qQ==
X-Google-Smtp-Source: AGHT+IGRmayPSSXVg1tBv7VtvJwkvc/tj+oj23SU679geAITRlSjdm6dHFzTP1K0jM44M2TKf2GxcA==
X-Received: by 2002:a17:907:9693:b0:a9a:5b78:d7d8 with SMTP id a640c23a62f3a-a9abf88829fmr514235466b.17.1729793366232;
        Thu, 24 Oct 2024 11:09:26 -0700 (PDT)
Received: from [192.168.8.113] ([85.255.233.224])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a912f681bsm647545366b.84.2024.10.24.11.09.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 11:09:25 -0700 (PDT)
Message-ID: <cdc6a0c4-5ad8-4ad6-9dca-49fa5e44f8dd@gmail.com>
Date: Thu, 24 Oct 2024 19:10:00 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 RESEND] io_uring/fdinfo: add timeout_list to fdinfo
To: Jens Axboe <axboe@kernel.dk>, Ruyi Zhang <ruyi.zhang@samsung.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 peiwei.li@samsung.com
References: <CGME20241012091032epcas5p2dec0e3db5a72854f4566b251791b84ad@epcas5p2.samsung.com>
 <e8d1f8e8-abd9-4e4b-aa55-d8444794f55a@gmail.com>
 <20241012091026.1824-1-ruyi.zhang@samsung.com>
 <5d288a05-c3c8-450a-9e25-abac89eb0951@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <5d288a05-c3c8-450a-9e25-abac89eb0951@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/24/24 18:31, Jens Axboe wrote:
> On Sat, Oct 12, 2024 at 3:30?AM Ruyi Zhang <ruyi.zhang@samsung.com> wrote:
...
>>> I don't think there is any difference, it'd be a matter of
>>> doubling the number of in flight timeouts to achieve same
>>> timings. Tell me, do you really have a good case where you
>>> need that (pretty verbose)? Why not drgn / bpftrace it out
>>> of the kernel instead?
>>
>>   Of course, this information is available through existing tools.
>>   But I think that most of the io_uring metadata has been exported
>>   from the fdinfo file, and the purpose of adding the timeout
>>   information is the same as before, easier to use. This way,
>>   I don't have to write additional scripts to get all kinds of data.
>>
>>   And as far as I know, the io_uring_show_fdinfo function is
>>   only called once when the user is viewing the
>>   /proc/xxx/fdinfo/x file once. I don't think we normally need to
>>   look at this file as often, and only look at it when the program
>>   is abnormal, and the timeout_list is very long in the extreme case,
>>   so I think the performance impact of adding this code is limited.
> 
> I do think it's useful, sometimes the only thing you have to poke at
> after-the-fact is the fdinfo information. At the same time, would it be

If you have an fd to print fdinfo, you can just well run drgn
or any other debugging tool. We keep pushing more debugging code
that can be extracted with bpf and other tools, and not only
it bloats the code, but potentially cripples the entire kernel.

> more useful to dump _some_ of the info, even if we can't get all of it?
> Would not be too hard to just stop dumping if need_resched() is set, and

need_resched() takes eternity in the eyes of hard irqs, that is
surely one way to make the system unusable. Will we even get the
request for rescheduling considering that irqs are off => timers
can't run?

> even note that - you can always retry, as this info is generally grabbed
> from the console anyway, not programmatically. That avoids the worst
> possible scenario, which is a malicious setup with a shit ton of pending
> timers, while still allowing it to be useful for a normal setup. And
> this patch could just do that, rather than attempt to re-architect how
> the timers are tracked and which locking it uses.

Or it can be done with one of the existing tools that already
exist specifically for that purpose, which don't need any additional
kernel and custom handling in the kernel, and users won't need to
wait until the patch lands into your kernel and can be run right
away.

-- 
Pavel Begunkov

