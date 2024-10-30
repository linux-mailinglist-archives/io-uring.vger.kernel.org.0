Return-Path: <io-uring+bounces-4205-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D3B79B6403
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 14:26:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CE5D7B22E1C
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 13:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5765E1E47C3;
	Wed, 30 Oct 2024 13:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JpKRxxMr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842D31E3DC5
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 13:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730294777; cv=none; b=W6DDh/bhKwB8eOLSQwOaKt9Ag7MZ26wn7VdoMy0wjQa5TmVo94qIry6Xt1QmfZlJrsNTppQpkmt1UKUkfWw//GrVRaSi6k8TmY9Z/L6UboixNVwZy3eetTwUhQPF2GRQxttB/V1SmXweFtdhW9lzyEPqRUpW681TZlRgE/5Qxrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730294777; c=relaxed/simple;
	bh=+lEE3ZvScNViSL9a6fOzXq+QZdhBaSX2eQfMf90vbOQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LodsA4OhCdpPh10cMLcIbY06t2a18sLUsv+5HuwQ/3vtE7/hOMUiIkZxyMUFzhoWxkc0Lqoa601tDPF/mEPcHocP4jxP99SoT4xSnawfqzpO2dgzdDxdMovXKxI5QilWkXR4X5BRV0ehfLENj7PrBgjVmdlv/Xi9dt/qQFJ/qhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JpKRxxMr; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-83abc039b25so254233139f.0
        for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 06:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730294773; x=1730899573; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/xX6fm9VCsSgt5EDlA5wRKTyZ1JmOIbQx/7X6jBDtd8=;
        b=JpKRxxMrbniqoBNjxSaJfU7K+YPVWP9NUCxsCAM4fqbY2HeS4Wlf0VsPiRwhHaHHgK
         XyzVaEfwOwLPg/xf4Kcqm0voOsTUNhNxCS112l5vDHoFbQ3fFmvr4XuX3lGH+QYpCoQq
         /zn1NKHUwNDwVMW3g6RR+SYayj7HY8TSgt3tkI8s+sO2fJEF1JvwUAgL38U1PRLa8pyU
         mZuGq/xYqD4PScV4+xXkDc1liB0kfEYe4SuRJKLy8xvfePaB8q0SJwzQjJrgbkhxD7Jx
         NTqzBeFkEl4rgJzlWC6T+qyoAM+OYHuMNn1PMMJUOSey1n+SJCx9mC2ktdpJkdVTE/EL
         cFpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730294773; x=1730899573;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/xX6fm9VCsSgt5EDlA5wRKTyZ1JmOIbQx/7X6jBDtd8=;
        b=EIlpAjuhaovK7YbNGwyMTMo+C6hSkp3bowapNfhR6d6BIaHzPgppm+imw7IgkoFbHG
         DxiExPiW5kc+jjzOeWT39CoXVAnlMKiRonXBzMG97BmHp8UKaDuWjkF+GRs6zBEsLLoX
         Z39JrtZA4C9XgudHtTbwmjjCm1sL3jeceCId3rvb/yj+4JowpKKbM3XHnZ+X9aY5WmBO
         9IxR4BHhemJADr1CSwuSW3aFJkfYcR9/tfc4+0Alsw40kjBsQAkLSYkK33TEUNM4kZ8X
         r7kOYiv9TIz8pRrzziAmuoQkMuMIG/rRJpkOAlDnOBpbsEMz1cIJIEQ8DmFkbPXWD/de
         LjIQ==
X-Gm-Message-State: AOJu0YwzPrwso3galK9N1J3azB+Mek3cBn9xe9M+2rriT2qhzNV7bnmT
	PaWC0np2imjhtcbXT77PsDdvBrcCcGvmoS6u64lvmSd0phYqrl+71lKAHffQl+4=
X-Google-Smtp-Source: AGHT+IEsVlii3mRo5W+vm4gIyoAnXb3fZiNSsyAm6sxq7zo11o0EclueM9ju723DPueM+/HbQGuJ0Q==
X-Received: by 2002:a05:6602:13d5:b0:82a:a76a:1779 with SMTP id ca18e2360f4ac-83b1c46f9a3mr1190724339f.8.1730294773512;
        Wed, 30 Oct 2024 06:26:13 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc727813a0sm2924292173.143.2024.10.30.06.26.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2024 06:26:12 -0700 (PDT)
Message-ID: <34fe7b21-41cf-4524-87e4-20f1944460b6@kernel.dk>
Date: Wed, 30 Oct 2024 07:26:10 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 RESEND] io_uring/fdinfo: add timeout_list to fdinfo
To: Pavel Begunkov <asml.silence@gmail.com>,
 Ruyi Zhang <ruyi.zhang@samsung.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 peiwei.li@samsung.com
References: <CGME20241012091032epcas5p2dec0e3db5a72854f4566b251791b84ad@epcas5p2.samsung.com>
 <e8d1f8e8-abd9-4e4b-aa55-d8444794f55a@gmail.com>
 <20241012091026.1824-1-ruyi.zhang@samsung.com>
 <5d288a05-c3c8-450a-9e25-abac89eb0951@kernel.dk>
 <cdc6a0c4-5ad8-4ad6-9dca-49fa5e44f8dd@gmail.com>
 <09958a6f-4e24-4a18-b6b3-7ea10ea96beb@kernel.dk>
 <8890fa84-7fd3-4198-86d6-9da79e7cad07@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8890fa84-7fd3-4198-86d6-9da79e7cad07@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/29/24 7:29 PM, Pavel Begunkov wrote:
> On 10/25/24 00:25, Jens Axboe wrote:
>> On 10/24/24 12:10 PM, Pavel Begunkov wrote:
>>> On 10/24/24 18:31, Jens Axboe wrote:
>>>> On Sat, Oct 12, 2024 at 3:30?AM Ruyi Zhang <ruyi.zhang@samsung.com> wrote:
>>> ...
>>>>>> I don't think there is any difference, it'd be a matter of
>>>>>> doubling the number of in flight timeouts to achieve same
>>>>>> timings. Tell me, do you really have a good case where you
>>>>>> need that (pretty verbose)? Why not drgn / bpftrace it out
>>>>>> of the kernel instead?
>>>>>
>>>>>    Of course, this information is available through existing tools.
>>>>>    But I think that most of the io_uring metadata has been exported
>>>>>    from the fdinfo file, and the purpose of adding the timeout
>>>>>    information is the same as before, easier to use. This way,
>>>>>    I don't have to write additional scripts to get all kinds of data.
>>>>>
>>>>>    And as far as I know, the io_uring_show_fdinfo function is
>>>>>    only called once when the user is viewing the
>>>>>    /proc/xxx/fdinfo/x file once. I don't think we normally need to
>>>>>    look at this file as often, and only look at it when the program
>>>>>    is abnormal, and the timeout_list is very long in the extreme case,
>>>>>    so I think the performance impact of adding this code is limited.
>>>>
>>>> I do think it's useful, sometimes the only thing you have to poke at
>>>> after-the-fact is the fdinfo information. At the same time, would it be
>>>
>>> If you have an fd to print fdinfo, you can just well run drgn
>>> or any other debugging tool. We keep pushing more debugging code
>>> that can be extracted with bpf and other tools, and not only
>>> it bloats the code, but potentially cripples the entire kernel.
>>
>> While that is certainly true, it's also a much harder barrier to entry.
>> If you're already setup with eg drgn, then yeah fdinfo is useless as you
>> can grab much more info out by just using drgn.
> 
> drgn is simple, not that harder than patching fdinfo, we can add
> liburing/scripts, and push it there so that don't need rewriting
> it each time.

It's not that drgn it's hard to use, it's not, but that people aren't
necessarily aware of it. Once you've used it, yeah it's trivial. But for
the cases where you are stuck in prod and you haven't used anything like
that, it's a bit of a stretch to get there. Once it's part of your usual
arsenal of tools, not an issue at all.

Adding something to liburing/scripts/ would indeed be awesome.

>> I'm fine punting this to "needs more advanced debugging than fdinfo".
>> It's just important we get closure on these patches, so they don't
>> linger forever in no man's land.
> 
> The only option I see is to dump first ~5 and stop there, but
> I still think the tooling option is better.

Let's just not do it at all, I think a partial dump is likely to be
potentially useless. And you can't cat it again and expect something
different if things are stuck.

-- 
Jens Axboe

