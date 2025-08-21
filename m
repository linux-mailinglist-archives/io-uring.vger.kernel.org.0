Return-Path: <io-uring+bounces-9178-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68680B300C6
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 19:12:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D620680CD8
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 17:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1DED2FB627;
	Thu, 21 Aug 2025 17:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kR3vSTed"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77DDB2FB62C
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 17:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755796352; cv=none; b=UmoD7uZHRggAoxU7Z1vUont6LqlqAWQwhZ48E8dbayZPQNu1Z4lU9WRBZmWDiQ5cgP1Ix1pdkbg7MC//RYc380JzQO0ZOhCy8jQAN1ANzviRvEi65f3olkwDS0H/ZehR4CdqW5Js+3bmnDU57oaHdq8XspiyYu6aS9ewLZ7cUqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755796352; c=relaxed/simple;
	bh=POr/EsYoawwub2e0fCwcx3MvS+Lb/CZeoadbhVCr6zg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G+ppxEaVL3sX5ahlDJwY6+u0iXxxDlnpm812xlspjJakAqZShEv8psoOfUrHPE1MWlkNWbSriMxuh4zt12gDX84g9XWb7zTmQesZBW6ilqkckVbjsIrR4SIcgVAIHHrVp7XHhqxSM8VLdkeAH0GgKLxTIACKkt06L8Ye23VTqM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kR3vSTed; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3e57376f655so10394145ab.0
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 10:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755796349; x=1756401149; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BZxIMj1LWErRv8eLbMMO5TET6h711e61T0npzJkrsTc=;
        b=kR3vSTedyOPT4Bgg4XU+EisTxkV7xMUu0+OW/2rNujhkj66GR8zWAsmbZkkBTL7j7g
         qGjJT4hEmA+I6/2U4HpeOM+rsGKNl4pfWvRoh13Kbh4/CW1ISyaOKKbWJsgFXMwNZnTB
         9q+WFcIYS/MxhVNuJa1pWcJmlkOeElpB5fVs5CmKhTHFgCPd1SKGm2LqMCPeXk2oKw/c
         VZ2HmTQ7i0FBwOc6kIYbnKyo57csfOkHOG0LI1Kz/qBZCEHmkqT82V2MKHsvTUOluXcz
         wFSpSCDxkYP2CT/udejkBNpx40XoN4kSUjBJ1cL3QvModfw2hpqRC63y6GVEpbiEGER7
         bjkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755796349; x=1756401149;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BZxIMj1LWErRv8eLbMMO5TET6h711e61T0npzJkrsTc=;
        b=fjXsupHe5swh7pBFCmRD3UdCQWclq5ItOd1jbB9JliNfXh116L/w2UDhlqEP84pq46
         b6g0ujZeaiQreO40mcYvbi2X+ueBl0CNVdCaSjZ3fgUotA6erpR5JhjkkgLBdWpap6GX
         jtP2PGunDANYmXx+AFw/02rvAy9p44bj9SP3GpbuP3gP45+4sQeioNA5mE1umeVtczv1
         NZkhLgSenfsrIp+02bUQCsdEuEl+LEIr8snfQViBr3GQCyek5E4y7AI0/0JDQM5YJcfx
         RaPeh4Voywlc2KOhzo5x5KstzLHMtVdmhdfr4fLbQViq57/t+8W2OF5BUlSRUIY0Jcqe
         rYYw==
X-Gm-Message-State: AOJu0YzOynELmbRKM8+8SdjCc7hIIG3+9l6kbsztj0gokzP1SBqlQK+s
	PVG8N2BaL0xGA6Lj97xji0sedqZvm4BaZyrRO2Bhcyercu04H3xt4BwBcv5gVoY1cKw=
X-Gm-Gg: ASbGncsRNTQRShesKcXtdUR8g0t+NDZW2jDPAydwjxi619Jt9z2YdxzYFRjJwIivcUU
	zG9FWt3a2kxn5LoTSEtR2qyfWHfL3qKQLGkAvZhsm5/T5pE3Avuj0gT5Bse0CCsjtaUavB6wiCj
	b44Gg/m8ofXxv3vS6PMxbpPYXQCpSp8uwC8alsbxOrmFN+2jaxNaHdkh8XGlE9bzUchvyp83US8
	XnNVdYPbZQSq6sToNEnJDaKcqfTz1O+mQcxMzOWI39+wj+KwWYa7jmgmwnVBxRlhQMJZqDT/myL
	qvRW6IHcgcCw0fuUfJsUbVE2hnNh26J5E7IJNOoMbJraUUUOYpf33EOs3qmqvUjDLNjJJhyUz5v
	7fmZittWlNyNbyrtdLgA7+RnwRXfR8g==
X-Google-Smtp-Source: AGHT+IHAGR22k2b9Y8Y7vSOSSbcA14areLWHDVJRFbT2ArXHijf1l3J/kPXMkMKAjvmNLS9p4aWMBA==
X-Received: by 2002:a05:6e02:1987:b0:3e5:5937:e555 with SMTP id e9e14a558f8ab-3e9201f3da9mr2999665ab.6.1755796349419;
        Thu, 21 Aug 2025 10:12:29 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e6836fb3bbsm16588505ab.50.2025.08.21.10.12.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 10:12:28 -0700 (PDT)
Message-ID: <6145c373-d764-480b-a887-57ad60f872e7@kernel.dk>
Date: Thu, 21 Aug 2025 11:12:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET v2 0/8] Add support for mixed sized CQEs
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, Keith Busch <kbusch@kernel.org>
References: <20250821141957.680570-1-axboe@kernel.dk>
 <CADUfDZragMLiHkkw0Y+HAeEWZX8vBpPpWjgwdai8SjCuiLw0gQ@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZragMLiHkkw0Y+HAeEWZX8vBpPpWjgwdai8SjCuiLw0gQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/21/25 11:02 AM, Caleb Sander Mateos wrote:
> On Thu, Aug 21, 2025 at 7:28?AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Hi,
>>
>> Currently io_uring supports two modes for CQEs:
>>
>> 1) The standard mode, where 16b CQEs are used
>> 2) Setting IORING_SETUP_CQE32, which makes all CQEs posted 32b
>>
>> Certain features need to pass more information back than just a single
>> 32-bit res field, and hence mandate the use of CQE32 to be able to work.
>> Examples of that include passthrough or other uses of ->uring_cmd() like
>> socket option getting and setting, including timestamps.
>>
>> This patchset adds support for IORING_SETUP_CQE_MIXED, which allows
>> posting both 16b and 32b CQEs on the same CQ ring. The idea here is that
>> we need not waste twice the space for CQ rings, or use twice the space
>> per CQE posted, if only some of the CQEs posted require the use of 32b
>> CQEs. On a ring setup in CQE mixed mode, 32b posted CQEs will have
>> IORING_CQE_F_32 set in cqe->flags to tell the application (or liburing)
>> about this fact.
> 
> This makes a lot of sense. Have you considered something analogous for
> SQEs? Requiring all SQEs to be 128 bytes when an io_uring is used for
> a mix of 64-byte and 128-byte SQEs also wastes memory, probably even
> more since SQEs are 4x larger than CQEs.

Adding Keith, as he and I literally just talked about that. My answer
was that the case is a bit different in that 32b CQEs can be useful in
cases that are predominately 16b in the first place. For example,
networking workload doing send/recv/etc and the occassional
get/setsockopt kind of thing. Or maybe a mix of normal recv and zero
copy rx.

For the SQE case, I think it's a bit different. At least the cases I
know of, it's mostly 100% 64b SQEs or 128b SQEs. I'm certainly willing
to be told otherwise! Because that is kind of the key question that
needs answering before even thinking about doing that kind of work.

But yes, it could be supported, and Keith (kind of) signed himself up to
do that. One oddity I see on that side is that while with CQE32 the
kernel can manage the potential wrap-around gap, for SQEs that's
obviously on the application to do. That could just be a NOP or
something like that, but you do need something to fill/skip that space.
I guess that could be as simple as having an opcode that is simply "skip
me", so on the kernel side it'd be easy as it'd just drop it on the
floor. You still need to app side to fill one, however, and then deal
with "oops SQ ring is now full" too.

Probably won't be too bad at all, however.

-- 
Jens Axboe

