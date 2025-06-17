Return-Path: <io-uring+bounces-8381-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5600CADC9F0
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 13:51:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E0A118975C4
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 11:52:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC2E22DF3F0;
	Tue, 17 Jun 2025 11:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ddt8aQWu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1292E2C032C
	for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 11:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750161102; cv=none; b=P5Soyw8Pp6JeANxUeNaS3VI4uftCjKQseYBh15X594sa1AkIA13zxRijK0GClifCmrOkmhQkWi13am5jxZwrHt+p8bs0neOTaNV3gQ+s8sDFhfo1R8GxOFTBYQWel0UXCple/KLBnbWuEmjLWy4n8RPP4+HTX9Yin50UYxF5u60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750161102; c=relaxed/simple;
	bh=PjTYhPXaN4zsCNomWPT+Ntla9OZRzhzM3JvTAkf0c4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r4ma+9e7/2fwPDHH3d6ITiwZiXx1JCoc0AZ30SUJcIOvpPTivEE7M7EhlxgfbSt3MCfD/24eln4NTlR2JnmfTfk3Y9JXRIOliVdD5dHMVe7c5XzjCqkNHaUTT7eliFB7qTS1d5Dr/hAs3TyK8i30bTTatjMC7sxe7QFFKlbXric=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ddt8aQWu; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3ddc4ad070bso18253975ab.3
        for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 04:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750161097; x=1750765897; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qoHly15vxLS5/ykdngWXt2g+fixKU9w+RD7hve+I1Dw=;
        b=Ddt8aQWupMPGvFEmEYhd6So+7Be/vRE/ed7H+feTFc9jMo9JyjuYko9cx2cbHHqi/+
         f89hjMDDO6FxzDBdzAjHTQql3cjp4pr3z8AURHW0a/WzBu/uvKHyqIRBzWX2XIDXu3DO
         dgQ+54a+GMtosM9EFijxrhcw9l61Zc1zcMddEO5u73BZWjUOaT7JmJUDB0xMkgOtb8v8
         85WmipGB+VRLjXHm6fuZ3XHjGtQjd3w2H5/iu2dHP2UFDs+9iJS/yPARO26DFUaT3ZBN
         T5V8ZEPGZyPlU1cl5L4wSKSGZf81uirQnZwP64GDW3NiPdggSsvVfaeCNHEQH/yqRoHs
         Lktw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750161097; x=1750765897;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qoHly15vxLS5/ykdngWXt2g+fixKU9w+RD7hve+I1Dw=;
        b=UdNTjhWRZuGlkX8P+EI52ysug8TgGDnzHN7l1tbWDpmcP6X15aiPPGMg153Ug5NfsS
         8jUetQQx/O1Kfx3WJzhY/ctb/GJTeyuzPbW50NO95DPK2Yf4TzcVKG0n0eykfbjWmA9C
         FTozhbDZBItyZ/mlk88xhoDbvBwZmxgI2UL/rSihBXJ4DlsjHdQ3YKW6JWcFUhexYdxj
         m1u34OmTJHXRxvc20rvbfS0GKnvSiKUE32pIssj2oONLWuqb8/BFiwvDA1/g6XGR0dfq
         XfXB54U8YjIEVcorblL5UsXBh7tTGlC7h+vYYYbRKxSYhJLXm531UThdATqPbdHIPRii
         th6A==
X-Gm-Message-State: AOJu0YzKn7SA+7y/1+HjVOsPjn7hgXH3Ng0UBB78r4QiNKgpowC3uRpI
	i9Q+DTBPugPLo9bTruqlYMMTvX80EFm9H/BUmr/m34Yox0c6i7fva3OqwaAdl8Cid23GQh9b9fj
	+k9bK
X-Gm-Gg: ASbGncs0jvcwI5xfiRjQ8ttbXfv43Njyscpek7PtnfiLwPl0lPxnYCzlepqTvywvx/l
	NVX0qXLQ5NtLhLS21kanqQiEJTqrQISh6J41NzLzaqjGHOLqBehnwQ4GmHO6U6zkyAk4xkuQ9ng
	xSmRT7guAYjj83EnX1UUcRqhv7WL+z3dXyNa62AekxpLyqf4XE0Q2kxRsDhFpBJo8EQC8+i2wkJ
	bfmz3eFSH1vXruagKG1TEaaERqffS0xPwtbGdidPF3JUav2l4PyxueeNu/Rt74g/eyx7M3b3ZDU
	gVHz5+x/iA9Sanp6tuo2YBEuqwvUZimciS+XIQugyDeoOZQsCU7RudlQ6FQiqSj0QNHZtQ==
X-Google-Smtp-Source: AGHT+IEAf8eknWjq0uP7ynv8Iy+oZagX8j7RqQvjai4+H2PcIodvdVJ5aC+DGg0anp8wzHgFlaEc5w==
X-Received: by 2002:a05:6e02:1885:b0:3dd:b569:6448 with SMTP id e9e14a558f8ab-3de07cff2d7mr133901865ab.6.1750161097572;
        Tue, 17 Jun 2025 04:51:37 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50149b7ad72sm2198293173.3.2025.06.17.04.51.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 04:51:36 -0700 (PDT)
Message-ID: <13d5c94e-9f3c-4a0e-a468-562e78155ba5@kernel.dk>
Date: Tue, 17 Jun 2025 05:51:36 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Building liburing on musl libc gives error that errno.h not found
To: =?UTF-8?Q?Milan_P=2E_Stani=C4=87?= <mps@arvanta.net>
Cc: io-uring@vger.kernel.org
References: <b94bfb39-0083-446a-bc76-79b99ea84a4e@kernel.dk>
 <20250615195617.GA15397@m1pro.arvanta.net>
 <1198c63d-4fe8-4dda-ae9f-23a9f5dafd5c@kernel.dk>
 <20250616130612.GA21485@m1pro.arvanta.net>
 <39ae421b-a633-4b47-bf2b-6a55d818aa7c@kernel.dk>
 <20250616141823.GA27374@m1pro.arvanta.net>
 <290bfa14-b595-4fea-b1fe-a3f0881f4220@kernel.dk>
 <a3aaaba3-17d6-4d23-8723-2a25526a4587@kernel.dk>
 <20250616163244.GA16126@m1pro.arvanta.net>
 <f5b6a7f1-ecb2-4247-b339-b7a3f51f5216@kernel.dk>
 <20250617081947.GA21947@m1pro.arvanta.net>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250617081947.GA21947@m1pro.arvanta.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/17/25 2:19 AM, Milan P. Stani? wrote:
> On Mon, 2025-06-16 at 10:35, Jens Axboe wrote:
>> On 6/16/25 10:32 AM, Milan P. Stani? wrote:
>>> On Mon, 2025-06-16 at 09:35, Jens Axboe wrote:
>>>> On 6/16/25 9:13 AM, Jens Axboe wrote:
>>>>> On 6/16/25 8:18 AM, Milan P. Stani? wrote:
>>>>>> On Mon, 2025-06-16 at 07:59, Jens Axboe wrote:
>>>>>>> On 6/16/25 7:06 AM, Milan P. Stani? wrote:
>>>>>>>> On Mon, 2025-06-16 at 06:34, Jens Axboe wrote:
>>>>>>>>> On 6/15/25 1:56 PM, Milan P. Stani? wrote:
>>>>>>>>>> On Sun, 2025-06-15 at 12:57, Jens Axboe wrote:
>>>>>>>>>>> On 6/15/25 11:16 AM, Milan P. Stani? wrote:
>>>>>>>>>>>> Hi,
>>>>>>>>>>>>
>>>>>>>>>>>> Trying to build liburing 2.10 on Alpine Linux with musl libc got error
>>>>>>>>>>>> that errno.h is not found when building examples/zcrx.c
>>>>>>>>>>>>
>>>>>>>>>>>> Temporary I disabled build zcrx.c, merge request with patch for Alpine
>>>>>>>>>>>> is here:
>>>>>>>>>>>> https://gitlab.alpinelinux.org/alpine/aports/-/merge_requests/84981
>>>>>>>>>>>> I commented in merge request that error.h is glibc specific.
>>>>>>>>>>>
>>>>>>>>>>> I killed it, it's not needed and should've been caught during review.
>>>>>>>>>>> We should probably have alpine/musl as part of the CI...
>>>>>>>>>>
>>>>>>>>>> Fine.
>>>>>>>>>>
>>>>>>>>>>>> Side note: running `make runtests` gives 'Tests failed (32)'. Not sure
>>>>>>>>>>>> should I post full log here.
>>>>>>>>>>>
>>>>>>>>>>> Either that or file an issue on GH. Sounds like something is very wrong
>>>>>>>>>>> on the setup if you get failing tests, test suite should generally
>>>>>>>>>>> pass on the current kernel, or any -stable kernel.
>>>>>>>>>>>
>>>>>>>>>> I'm attaching log here to this mail. Actually it is one bug but repeated
>>>>>>>>>> in different tests, segfaults
>>>>>>>>>
>>>>>>>>> Your kernel is ancient, and that will surely account from some of the
>>>>>>>>> failures you see. A 6.6 stable series from January 2024 is not current
>>>>>>>>> by any stretch, should definitely upgrade that. But I don't think this
>>>>>>>>> accounts for all the failures seen, it's more likely there's some musl
>>>>>>>>> related issue as well which is affecting some of the tests.
>>>>>>>>
>>>>>>>> This happens also on 6.14.8-1 asahi kernel on apple m1pro machine.
>>>>>>>> I forgot to mention this in previous mail, sorry.
>>>>>>>
>>>>>>> Also on musl, correct?
>>>>>>
>>>>>> Yes, correct.
>>>>>>
>>>>>>> Guessing it must be some musl oddity. I'll try and setup a vm with
>>>>>>> alpine and see how that goes.
>>>>>>
>>>>>> It could be. I can ask on #musl IRC channel on libera.chat
>>>>>
>>>>> Probably easier if I just take a look at it, as long as I can get
>>>>> an alpine vm image going.
>>>>
>>>> Pure guesswork, but you are most likely running into default ulimit
>>>> limits being tiny. Probably something ala:
>>>>
>>>> rc_ulimit="-n 524288 -l 262144"
>>>>
>>>> in /etc/rc.conf would help.
>>>
>>> Tried, but didn't help.
>>>
>>> I will left it for now and return to test it when new liburing is
>>> released. It must pass our builders and CI, so I disabled test earlier.
>>>
>>> Thank you for help.
>>
>> That's fine, I don't recommend distros attempt to verify it by using
>> the test suite anyway, that's not really its intended purpose. Though it
>> can be useful in terms of verifying all relevant fixes are backported,
>> particular if the distro is one of those oddballs that don't base on or
>> pull in -stable.
>>
>> I'll be releasing 2.11 shortly, but it likely won't change anything on
>> your end, outside of having the examples/zcrx compilation fixed.
>>
>> FWIW, I'm on Alpine Linux 3.22 and it passes here.
> 
> liburing 2.11 builds fine on Alpine edge and previous bugs (segfaults)
> don't appears now with new version.
> 
> runtests shows that 4 test failed:
> ----------------
> Test run complete, kernel: 6.6.14-0-lts #1-Alpine SMP PREEMPT_DYNAMIC Fri, 26 Jan 2024 11:08:07 +0000
> Tests failed (4): <accept.t> <nop.t> <sqwait.t> <timeout.t>
> make[1]: *** [Makefile:331: runtests] Error 1
> make[1]: Leaving directory '/home/mps/aports/main/liburing/src/liburing-liburing-2.11/test'
> make: *** [Makefile:21: runtests] Error 2
> ----------------
> 
> but I think this is not blocker to update liburing to 2.11 on alpine.

It's fine - as mentioned, by far most of the test suite is for kernel
testing, not liburing itself. And if run on an old kernel. various test
case failures are expected, as the kernel is lacking fixes.

-- 
Jens Axboe

