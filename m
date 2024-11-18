Return-Path: <io-uring+bounces-4785-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 812669D1BD2
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 00:28:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2C5EC1F21F2F
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 23:28:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF00147C71;
	Mon, 18 Nov 2024 23:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Yv05YWYd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089FF194A74
	for <io-uring@vger.kernel.org>; Mon, 18 Nov 2024 23:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731972535; cv=none; b=OGoMOZ0TSKzr/CYuav/rM1R4100ywMP4cCzBhK5NcXVAC1zrE7h7PGeXHfhCvrLu1pihCr4MfmhUDbISvvDS8DC6GrvP2uCHgp5GT436ond8yZrniWmix8xuAp5eCAvAHB4OTj1H4EQqFCjzIr5cHVfa3PtlNTjPvLdXnVjXjgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731972535; c=relaxed/simple;
	bh=lK1o58Vc0UoAfByJJuWaBNU3ak/VhpQ2XIio2FbD2nk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=otimnhdo5EkqbGrqrOI7gpojxGq0pLUk7hAuLUrEAn1RsCRUn+XTWppP81WzeKGSyDLiG8gS+r43raFuacUNMeQwcmV1w5cPkEg2FPW6hJYise3cORSDnErSb3dJcxj8zR7qaRPbpvKSZgE2NSUTGR/m4jPxG9ZBsOts24RG+FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Yv05YWYd; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-7ea7e250c54so2013411a12.0
        for <io-uring@vger.kernel.org>; Mon, 18 Nov 2024 15:28:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731972531; x=1732577331; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZjFZpcUSunyJclBbcMhVKjU9iiqJVspkP/q1iPGUQxs=;
        b=Yv05YWYdJqh/wY4ixLS0N9GwCVFmVIVeV1DSBRSkJAVXFxNSwW0KrCLCHJ47FsEN7z
         +PPc2mR2ikTEw64QusnFRxqzIxpAnuPFwIhaukolJy9fnVyJ/mV06wRr5zJm8M4iue8+
         KfPs7m93FdV83847kYiQHlbt5+tORFlpnmPfqXFxEGPX+jqJYZUFeP1gqhitxqPuVVCY
         UAKjeP9WlsEIeuFLRp7Jt18uXf2lun9xOZi7uOMEwFpjjTu2KVGvkphzFDlwcy3cZNtz
         TZhOtHwilViDKh38+iddKMgz4vPAidlTjiR4QqU9JQn1IVR8mpTtRU/+cbxjXENL7v//
         5jdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731972531; x=1732577331;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZjFZpcUSunyJclBbcMhVKjU9iiqJVspkP/q1iPGUQxs=;
        b=PYP16Ri65fPOes0YYBYpyGs9UoHFNZJ4jmDyL9VjDpFyVO74sujPhSFdnrTXuaAJh2
         i3jKgvXXI9attE5OLayq6fa9JWiBxD5pIwBWRIEzhkzfuFR2YbMaJV1jGdeOfDKlgc/P
         PD5PE7wI4O1vo7EMQ7B84x7AaQNspCjG91O7e/5R9bo5XANeLuwmu79E5IRZjDdbGjXB
         gJzqnqx/si8K+YOpkhH0A1yQy/7/nt/MVEjlxrBu+moXYGHNB/iiJEZ9Z8w2kaehVkJK
         riVr2j0Kh8rbprI1O3YbIAqMtniOWiYRDl+/wHuEf+W9ussghg0rU72sdsTS9kXd6uvB
         QhyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTCTt3C2girZgaaHE4u/46Wfbyrx0rdh4nhfcoh4a+VI7NMPaXifNt1T48M96KaejEr6sKyYOtcA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzVAnhnUzkCsvR4WqmpkLnkD7C4Ieoup7FU7ioLPKGv5iJXNhYk
	7/kqh4IBzC5sN0CNkVCJvTQkmRY/8ct9pa/qKpdbx6YXmRyeLp+qnA4q0dlMx+loIm2LaIOooK8
	EE1Y=
X-Google-Smtp-Source: AGHT+IGT8CaqVUeqRif1JhIi9ZB24rxDdHDh+WQ0uy82NY5Ppj9cDCRgvN3PW+dVUnfcwzK+nkOPLw==
X-Received: by 2002:a05:6a20:2595:b0:1db:e5ac:1fc0 with SMTP id adf61e73a8af0-1dc90b4bd82mr19787493637.24.1731972531259;
        Mon, 18 Nov 2024 15:28:51 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7f8c1dd62dasm6469445a12.74.2024.11.18.15.28.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2024 15:28:50 -0800 (PST)
Message-ID: <3ad15682-b184-4afd-b396-8a2ca7e586c1@kernel.dk>
Date: Mon, 18 Nov 2024 16:28:49 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] io_uring changes for 6.13-rc1
From: Jens Axboe <axboe@kernel.dk>
To: Sasha Levin <sashal@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 io-uring <io-uring@vger.kernel.org>, tglx@linutronix.de
References: <ad411989-3695-4ac9-9f96-b95f71918285@kernel.dk>
 <Zzu6dkYTFX2AA26c@sashalap> <9aabca30-26a8-41d2-8421-4c547fbf94fa@kernel.dk>
Content-Language: en-US
In-Reply-To: <9aabca30-26a8-41d2-8421-4c547fbf94fa@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/18/24 4:27 PM, Jens Axboe wrote:
> On 11/18/24 3:06 PM, Sasha Levin wrote:
>> Hi Jens, Thomas,
>>
>> On Mon, Nov 18, 2024 at 07:22:59AM -0700, Jens Axboe wrote:
>>> hexue (1):
>>>      io_uring: add support for hybrid IOPOLL
>>
>> After merging of this pull request into linus-next, I've started seeing
>> build errors:
>>
>> /builds/linux/io_uring/rw.c: In function 'io_hybrid_iopoll_delay':
>> /builds/linux/io_uring/rw.c:1179:2: error: implicit declaration of function 'hrtimer_init_sleeper_on_stack'; did you mean 'hrtimer_setup_sleeper_on_stack'? [-Werror=implicit-function-declaration]
>>   hrtimer_init_sleeper_on_stack(&timer, CLOCK_MONOTONIC, mode);
>>   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>   hrtimer_setup_sleeper_on_stack
>>
>> This is because 01ee194d1aba ("io_uring: add support for hybrid IOPOLL")
>> adds a call to hrtimer_init_sleeper_on_stack() which was removed earlier
>> today in Thomas's PR[1], specifically in commit f3bef7aaa6c8
>> ("hrtimers: Delete hrtimer_init_sleeper_on_stack()").
> 
> Right, forgot to mention that. linux-next has been carrying a fixup for
> that which I was going to link, but it's not on a public list for some
> reason.

My bad, it is on lkml:

https://lore.kernel.org/lkml/20241108143328.6d819fcb@canb.auug.org.au/

-- 
Jens Axboe


