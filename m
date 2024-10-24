Return-Path: <io-uring+bounces-4018-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D5199AF5CB
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 01:25:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E3E61C21807
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 23:25:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8DE12003DE;
	Thu, 24 Oct 2024 23:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SUIokgeX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693F21B392C
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 23:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729812315; cv=none; b=XqXGskaPqIFqRQV2beF2JJWA8cK8SUdoolFSZLhgV/L/hvqcXRww4o9uFd1ma39A05xDdAuJBWiuKsHDzJxFwBmESah8jvd5Zatlxm0ILgm8ONmt9onK3rbJqoEc9SeSd4bL2SJdro8zXG/sW47fz8/VbDFymPDVTR3RULoANFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729812315; c=relaxed/simple;
	bh=9yJ80Cu6LmbQ6HS0RLXgKe93ooM0lF7LK+mwdqi5F9c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iIarrN23yTeXRat0WmXf4YCG/8R3i53awf/mad6ljHcEa3MWTcMXh5aSZZtavZnN7yIOXW9PlcGvroTFhOwUx3yuxi17uOJ/zJ4rG8VkYw2xbuV4mD4Zqpb5NUsW5svTIt7aprgF5tn1Bfe8SkE5sPo7eTO+oOm0Nu6Emug/LIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SUIokgeX; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-7ea8c4ce232so1101682a12.0
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 16:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729812312; x=1730417112; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JTd/XGf1mB5cjq0szQmXcBwBqSmquAvdHM3ImKbNA5k=;
        b=SUIokgeXaQMAUPjeG1g0QinAIqzqr0QKjYX1qyDWMuzvxzLkm9Y87bIcrrf+XWHGzA
         kjK8huQzs6FdWu/YpQ8YSfGedmgpebf8gPOoF+9JEwmft+35HylQXLRkpIj6H4/TJqyO
         NOmuaYUyP00QyYh78cYDk85FRQ/27V7PNEkNrLR8UHpS4WbtcN8A2651s7H+lWhO66NF
         VuYSGYtX33cmLxSb8VMOmcYkS0UmYEwgFGGx2yJqdP7aiQwiKOxsFle0Q9ujirqujiIj
         jUoO9YV6L2WA9EV02o3G58pRMUFBhP4CRQ6K/tzXN83el6nAUDWAKz5MKDlB6YS214db
         4o7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729812312; x=1730417112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JTd/XGf1mB5cjq0szQmXcBwBqSmquAvdHM3ImKbNA5k=;
        b=V1ajF3+dnHf0E2tXeGtpyeQQ+V7Aord97nFk6eyDeBCHXJH2b+Kn8IxoynhjRD7Oph
         Tu8WHd4pGxlXlTq0aknKe8lj6jHSTLKHiTMAgLx/23hJImcMh37KsajTNfLXl+gko+XW
         +/Hn0I2zTwRP90fFZlT5n3zt2zGatCyf83HIkTHfwnstTGdjnnDN7fKzj8byLSwJmc0r
         hyEDlYZBXj0e132ckfKFVmYTCb4oXfT4iuod7cH62SqpZ+q1sflMiy6GT9mSDLyvoblT
         cu1Ha+0u3OKUTomttV1fA7MBcQtPNUz7KH0r5RXYjNG/4EOTI8C23NobwtsLhXn/c3d9
         6G6w==
X-Gm-Message-State: AOJu0YxNkRwOo2m7nkA2yAUeR7ktvJVnkTF7kzk1YTF778Y/m4Uhak19
	ynBlw8gSKnYImIoXQS//ED/1SDMissISMJV/RPqLNb/oXfnSKVxLsXx2nocuu0A=
X-Google-Smtp-Source: AGHT+IEmyAGjb+MBNYiPW1nZ5+l7ErL67ME3TATwVV1rPM+Mu6WjCAlo8BS/J8MLK+3z5D7ZgghOUQ==
X-Received: by 2002:a17:902:d543:b0:207:6fd:57d5 with SMTP id d9443c01a7336-20fa9e76831mr91650065ad.36.1729812311674;
        Thu, 24 Oct 2024 16:25:11 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7f0d9a7esm76982195ad.182.2024.10.24.16.25.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 16:25:11 -0700 (PDT)
Message-ID: <09958a6f-4e24-4a18-b6b3-7ea10ea96beb@kernel.dk>
Date: Thu, 24 Oct 2024 17:25:10 -0600
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cdc6a0c4-5ad8-4ad6-9dca-49fa5e44f8dd@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/24 12:10 PM, Pavel Begunkov wrote:
> On 10/24/24 18:31, Jens Axboe wrote:
>> On Sat, Oct 12, 2024 at 3:30?AM Ruyi Zhang <ruyi.zhang@samsung.com> wrote:
> ...
>>>> I don't think there is any difference, it'd be a matter of
>>>> doubling the number of in flight timeouts to achieve same
>>>> timings. Tell me, do you really have a good case where you
>>>> need that (pretty verbose)? Why not drgn / bpftrace it out
>>>> of the kernel instead?
>>>
>>>   Of course, this information is available through existing tools.
>>>   But I think that most of the io_uring metadata has been exported
>>>   from the fdinfo file, and the purpose of adding the timeout
>>>   information is the same as before, easier to use. This way,
>>>   I don't have to write additional scripts to get all kinds of data.
>>>
>>>   And as far as I know, the io_uring_show_fdinfo function is
>>>   only called once when the user is viewing the
>>>   /proc/xxx/fdinfo/x file once. I don't think we normally need to
>>>   look at this file as often, and only look at it when the program
>>>   is abnormal, and the timeout_list is very long in the extreme case,
>>>   so I think the performance impact of adding this code is limited.
>>
>> I do think it's useful, sometimes the only thing you have to poke at
>> after-the-fact is the fdinfo information. At the same time, would it be
> 
> If you have an fd to print fdinfo, you can just well run drgn
> or any other debugging tool. We keep pushing more debugging code
> that can be extracted with bpf and other tools, and not only
> it bloats the code, but potentially cripples the entire kernel.

While that is certainly true, it's also a much harder barrier to entry.
If you're already setup with eg drgn, then yeah fdinfo is useless as you
can grab much more info out by just using drgn.

I'm fine punting this to "needs more advanced debugging than fdinfo".
It's just important we get closure on these patches, so they don't
linger forever in no man's land.

-- 
Jens Axboe

