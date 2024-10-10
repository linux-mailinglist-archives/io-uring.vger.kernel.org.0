Return-Path: <io-uring+bounces-3564-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ADF6998C43
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 17:48:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D7D31C22CA6
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 15:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E06E1917C0;
	Thu, 10 Oct 2024 15:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HjpATXrT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C614A7DA62;
	Thu, 10 Oct 2024 15:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728575262; cv=none; b=fptV2baK02QU+BIact81vrc5gI6JHsa5LdTX/GJ8s8TFKbtl8pSf/FU6oGVI9P5TvmVy1WSecA7W3v1xV2Zs1xpAvsRDYkJrYGkHeSELS0cu/taMw9oYBe5blCe61TkhAq7E11LrdzHsHKZBoz03C+tr/9XD+lByD/Yc53wwVPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728575262; c=relaxed/simple;
	bh=m1n2YWFVEdaH5nVH4itHpiSzRpBwnNSQcR46978WYs4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QvwGnoGynYTh0X0s98/+lEuTHBbZnu4h95VrTS9tNYFaCR8on3M3XBNtY9/33//EZyF6QbOAxpByuyp/6Mm8RsqvSoaVCkyza5MGNAHKKLWhbhP1Sg8FafV6r8dpt0+6PWRsCHSDMeXrFW0hhFAZmvBSoZd4sXCr20iLUn6WHvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HjpATXrT; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5c9388a00cfso912606a12.3;
        Thu, 10 Oct 2024 08:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728575259; x=1729180059; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XJOdKSCyRxWoJZsXqjQ2pGVqLKgYzGVaLiitUDbtxIM=;
        b=HjpATXrTsJ1dsvyKAaL7MnlsedT0sqAzKe1Qgl69gRjPlVuI34kJaYARPiTKLhcp6j
         ktjFUdA2Px1+E9V1Z8N828vCwpX5qtfGvUyZ7BCpfT0HoCiGDHXNiLWVsp/cT80mwD57
         1zisZYpYWQCRp2bWnBQ++Ludncx087acmMgCzDnJjQRSgt7DsS+CcIBrbYfGrWlLNPvU
         LhrPu6kiNRHF0zTPGZHStBdKM+/Bwx/Z4U9hljInHqsi4ii0SfrtkWaZAO83nLxm1HjZ
         76ocryEQWiv848l29G9LfLfOioW7Co7/T7cvigbAJ/blWz8JKpaJIG4Rh10As8hrWE6J
         mrQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728575259; x=1729180059;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XJOdKSCyRxWoJZsXqjQ2pGVqLKgYzGVaLiitUDbtxIM=;
        b=n+ZlV8qV49qOobEoKcXO6/mWNLWE8xAClXetdpczkibJux+WlFXxZBBaitEKGLuQsH
         TpcgsFBJ3pq7Xs7U00OlKvuCh1VlD0i/32k2wvHHpCzZYFmppjw675yrHTbaedmt19ls
         BBJlJVwsQ6Jy+UR0amfYg2YkXItWHMPgLA9jUkCPGJP7JouPiTPAmIbvf2MqfbCSBBgk
         xox6mILZjxu7dcMdzdjzqbCFqP+Fg+cYmXQuH6NrF+xESXCOWldcLdf8BmswpsoxPcvM
         xwO/vvBLluuhqgAEQoJhyBLEySUHTWgVRAusPFNOVdgPDCHd/9cq+4DLsWkBbwYxBJNj
         pXQw==
X-Forwarded-Encrypted: i=1; AJvYcCVrz9GE1/xL7jys70V1Xdr8hdoJRUlpyxIfJ4x/gyd+amdsPnNoJSVTreDvm3qwkpsi66qSZDo1NLejbVU=@vger.kernel.org, AJvYcCXE1cvLExrFWUcF6pPeTmyqy0y9pupN4k2fFp0l5KsJ8T4kGAqXY2+gKc5aRKWn4+8d7sBEI5KjkA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwC5IZuDQxvtBdPw4gr1tAHzroJ8q08yuKVKLUSZRtOvhMnRTkz
	EX92Jk/FXpn0Xlui9RiaKk72/WmNqV5ya8Va0ILfzfqnbokubblf
X-Google-Smtp-Source: AGHT+IEmtBgLQok+KmjxmSzpC3Ma+9HgYtARqPFruWkhsp331a529yBtG+P+AeYz/vjVJttl6CIMag==
X-Received: by 2002:a17:907:e648:b0:a99:5985:bf39 with SMTP id a640c23a62f3a-a998d117e0amr591415466b.13.1728575258849;
        Thu, 10 Oct 2024 08:47:38 -0700 (PDT)
Received: from [192.168.42.29] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99a7f25406sm105668466b.69.2024.10.10.08.47.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 08:47:38 -0700 (PDT)
Message-ID: <4b40eff1-a848-4742-9cb3-541bf8ed606e@gmail.com>
Date: Thu, 10 Oct 2024 16:48:14 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 7/8] io_uring/uring_cmd: support provide group kernel
 buffer
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <20240912104933.1875409-8-ming.lei@redhat.com>
 <b232fa58-1255-44b2-92c9-f8eb4f70e2c9@gmail.com> <ZwJObC6mzetw4goe@fedora>
 <38ad4c05-6ee3-4839-8d61-f8e1b5219556@gmail.com> <ZwdJ7sDuHhWT61FR@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZwdJ7sDuHhWT61FR@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/10/24 04:28, Ming Lei wrote:
> On Wed, Oct 09, 2024 at 04:14:33PM +0100, Pavel Begunkov wrote:
>> On 10/6/24 09:46, Ming Lei wrote:
>>> On Fri, Oct 04, 2024 at 04:44:54PM +0100, Pavel Begunkov wrote:
>>>> On 9/12/24 11:49, Ming Lei wrote:
...
>>> so driver can check if device buffer can be provided with this uring_cmd,
>>> but I prefer to the new uring_cmd flag:
>>>
>>> - IORING_PROVIDE_GROUP_KBUF can provide device buffer in generic way.
>>
>> Ok, could be.
>>
>>> - ->prep() can fail fast in case that it isn't one group request
>>
>> I don't believe that matters, a behaving user should never
>> see that kind of failure.
>>
>>
>>>> 1. Extra overhead for files / cmds that don't even care about the
>>>> feature.
>>>
>>> It is just checking ioucmd->flags in ->prep(), and basically zero cost.
>>
>> It's not if we add extra code for each every feature, at
>> which point it becomes a maze of such "ifs".
> 
> Yeah, I guess it can't be avoided in current uring_cmd design, which

If can't only if we keep putting all custom / some specific
command features into the common path. And, for example, I
just named how this one could be avoided.

The real question is whether we deem that buffer providing
feature applicable widely enough so that it could be useful
to many potential command implementations and therefore is
worth of partially handling it generically in the common path.

> serves for different subsystems now, and more in future.
> 
> And the situation is similar with ioctl.

Well, commands look too much as ioctl for my taste, but even
then I naively hope it can avoid regressing to it.

>>>> 2. As it stands with this patch, the flag is ignored by all other
>>>> cmd implementations, which might be quite confusing as an api,
>>>> especially so since if we don't set that REQ_F_GROUP_KBUF memeber
>>>> requests will silently try to import a buffer the "normal way",
>>>
>>> The usage is same with buffer select or fixed buffer, and consumer
>>> has to check the flag.
>>
>> We fails requests when it's asked to use the feature but
>> those are not supported, at least non-cmd requests.
>>
>>> And same with IORING_URING_CMD_FIXED which is ignored by other
>>> implementations except for nvme, :-)
>>
>> Oh, that's bad. If you'd try to implement the flag in the
>> future it might break the uapi. It might be worth to patch it
>> up on the ublk side, i.e. reject the flag, + backport, and hope
>> nobody tried to use them together, hmm?
>>
>>> I can understand the concern, but it exits since uring cmd is born.
>>>
>>>> i.e. interpret sqe->addr or such as the target buffer.
>>>
>>>> 3. We can't even put some nice semantics on top since it's
>>>> still cmd specific and not generic to all other io_uring
>>>> requests.
>>>>
>>>> I'd even think that it'd make sense to implement it as a
>>>> new cmd opcode, but that's the business of the file implementing
>>>> it, i.e. ublk.
>>>>
>>>>>      */
>>>>>     #define IORING_URING_CMD_FIXED	(1U << 0)
>>>>> -#define IORING_URING_CMD_MASK	IORING_URING_CMD_FIXED
>>>>> +#define IORING_PROVIDE_GROUP_KBUF	(1U << 1)
>>>>> +#define IORING_URING_CMD_MASK	(IORING_URING_CMD_FIXED | IORING_PROVIDE_GROUP_KBUF)
>>>
>>> It needs one new file operation, and we shouldn't work toward
>>> this way.
>>
>> Not a new io_uring request, I rather meant sqe->cmd_op,
>> like UBLK_U_IO_FETCH_REQ_PROVIDER_BUFFER.
> 
> `cmd_op` is supposed to be defined by subsystems, but maybe we can
> reserve some for generic uring_cmd. Anyway this shouldn't be one big
> deal, we can do that in future if there are more such uses.

That's if the generic handling is desired, which isn't much
different from a flag, otherwise it can be just a new random
file specific cmd opcode as any other.

-- 
Pavel Begunkov

