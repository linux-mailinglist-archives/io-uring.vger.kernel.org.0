Return-Path: <io-uring+bounces-6090-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EA25DA1A655
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:56:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B29216168D
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:56:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3880620FAB7;
	Thu, 23 Jan 2025 14:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0Behr9Wb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F3738B
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 14:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737644159; cv=none; b=Q6B+x1kZ3jIv3Qwc7IYMY2haMTwkDBZeokor7UIvrIrp5lEFCLBLjidL0KxHOk2pwGIhTRDIk4NSjDwl0UW2YW9t4qHScI1XSL0lYhKyrASv+gPuu48iq4/LDT8KxWCok6OmDt6/lBN0J+txXzB4xXMUrY2xqmB2eLBA5HmKuK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737644159; c=relaxed/simple;
	bh=svFmRy4FN0riog4Cy0Uv5QDccPJNHYNfhWSbMKDVhFU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TCrPkwiX8vuYvHW+bHFb/ahdCupYby2w0zD1I1Yq99zKu67o5Xi3OhxZYqO+Al+s7WMw1lspHG3GyqQK6bruMKvFrEr6y3B86yc+EdzFYab4qSI9RyB81XJOCO+PXbq+FZwW7HKixvBEA0sxHT81sKqKjUO73o52VcfHhnaTl+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0Behr9Wb; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-844e06e5d11so29819039f.0
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 06:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737644156; x=1738248956; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zy+opCPVnAYVjhcBR6KhzrdJT0DT+Y19UcJekdt8nXU=;
        b=0Behr9WbupdhlRntsnrQh6QOBJLgdSZr7rmc/AiYoD/xHhjowzrknsxTHFF9ulD15K
         Dz15RVVb9zfubTsLRDuTCwDeXnMXCsU5r6knSWO1NXT3lIEH8zHgFpAqS7dyKfHVRSy2
         WGLTwbwcJSI3kzuFtzAgm2S9/a+AN+9JdlGoPA48GE+LLJPFk8Ggq+88iqOVgNOaymcv
         ixJZ2jzdCiUD7cm6SCS44fnj6nbUz14kYyftOiHqmVKVwPiXJr9XRnpDfKp6sfIRWHNg
         T2Hx8M9tRmhMnhdFlCW49ygCc2X1rUpY/ZXmINhJh/3DXWbHYTcZS7Ah0bda+yAJkocg
         DqgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737644156; x=1738248956;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zy+opCPVnAYVjhcBR6KhzrdJT0DT+Y19UcJekdt8nXU=;
        b=emcQe2iNR4Xv0XLxfl0VK+lG0IjeQtZ+LHnabdJxTe1o1RYMqV/7O7yYmgejSv9zr+
         Ue6QHSVgkS1zPn24JJnx7F4jU+HXNLTcMU9fparQKKyBn2ZrIJDDmq5IRGX4t2p7hLw8
         KwbIWwEnZ3E2izly7XhMSVhxT8YE7LYinE0X3VRNEeo5LOz3YO2PK3TT/IHf45RYlqfm
         3kwEe4fGDoV888cdglyt0iIuwN25GXvRqjoxvWCOdqStuhANDjZDjMzu24VceO1beEBj
         f/EuMaT+FYG9UHrTTROvmY3c1fPkuoDnkxwv4IjdcGAG06VnXoG44s0V4vbUsLgzXJbl
         DZXQ==
X-Forwarded-Encrypted: i=1; AJvYcCUnodMHFdmyr4g6hm6b9itM/LYXCOjpfeD0qSPB6jVyeIblBlwgLHvv31TvFqeP/7CGZ1BkjRX+Xg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzBmkS2141MjDNPkBsFlYsWugtHwJ3qcm2DYfBTMQyDEzQucPgN
	e/mm38oi/rz4WNhqoal33XB+nTdQSIlKWnD/G6Fo6LaliDzdTKBCU+EVsG4AOLtRVjZFGhnKuAJ
	c
X-Gm-Gg: ASbGnctfehMIdJxkK2+rANtEAp3LCff0SkSs+DXTPGfokGREHj5PUCHJyX8Ze2vEL2A
	p+J2cCLXdBYOKalzxnNkMWAI5ArUWMgr4ryWivqL9bdVyBibJVyL8C/EEUjsCXdlMjcB6Rl2c3X
	d7o9hG7czKYuzB8k3+wwyxkfigxYc4owov1IDZZc2r8J/+VaIV3hgrFDasQ/hBI/dCSoXK7JFvY
	aQUxcFHNzWMl1TdkNBcqUGSm77+59o0Ft8tudOdmVn0mseCRsY1P45FUzfy9jHTvR27Q9CS4w5R
X-Google-Smtp-Source: AGHT+IHXEZ24kXC4Eimw/Eueg96mToiznGvuXyqXLU69r+l9tVmn5ICOqljbjNuK6+JJ6RQ0XkX1VQ==
X-Received: by 2002:a05:6602:3c3:b0:84a:78ff:1247 with SMTP id ca18e2360f4ac-851b6286c35mr2403822939f.9.1737644156194;
        Thu, 23 Jan 2025 06:55:56 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4eab1196a54sm2271248173.37.2025.01.23.06.55.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2025 06:55:55 -0800 (PST)
Message-ID: <c8e4efdb-4f41-41a5-8470-14afb963c9e4@kernel.dk>
Date: Thu, 23 Jan 2025 07:55:55 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring: get rid of alloc cache init_once handling
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: krisman@suse.de
References: <20250123142301.409846-1-axboe@kernel.dk>
 <20250123142301.409846-3-axboe@kernel.dk>
 <cebeb4b6-0604-43cb-b916-e03ee79cf713@gmail.com>
 <f3c9c1bf-4356-4cb7-9fd1-980444db83a6@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f3c9c1bf-4356-4cb7-9fd1-980444db83a6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/23/25 7:47 AM, Pavel Begunkov wrote:
> On 1/23/25 14:27, Pavel Begunkov wrote:
>> On 1/23/25 14:21, Jens Axboe wrote:
>>> init_once is called when an object doesn't come from the cache, and
>>> hence needs initial clearing of certain members. While the whole
>>> struct could get cleared by memset() in that case, a few of the cache
>>> members are large enough that this may cause unnecessary overhead if
>>> the caches used aren't large enough to satisfy the workload. For those
>>> cases, some churn of kmalloc+kfree is to be expected.
>>>
>>> Ensure that the 3 users that need clearing put the members they need
>>> cleared at the start of the struct, and place an empty placeholder
>>> 'init' member so that the cache initialization knows how much to
>>> clear.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>>>   include/linux/io_uring/cmd.h   |  3 ++-
>>>   include/linux/io_uring_types.h |  3 ++-
>>>   io_uring/alloc_cache.h         | 30 +++++++++++++++++++++---------
>>>   io_uring/futex.c               |  4 ++--
>>>   io_uring/io_uring.c            | 13 ++++++++-----
>>>   io_uring/io_uring.h            |  5 ++---
>>>   io_uring/net.c                 | 11 +----------
>>>   io_uring/net.h                 |  7 +++++--
>>>   io_uring/poll.c                |  2 +-
>>>   io_uring/rw.c                  | 10 +---------
>>>   io_uring/rw.h                  |  5 ++++-
>>>   io_uring/uring_cmd.c           | 10 +---------
>>>   12 files changed, 50 insertions(+), 53 deletions(-)
>>>
>>> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
>>> index a3ce553413de..8d7746d9fd23 100644
>>> --- a/include/linux/io_uring/cmd.h
>>> +++ b/include/linux/io_uring/cmd.h
>>> @@ -19,8 +19,9 @@ struct io_uring_cmd {
>>>   };
>>>   struct io_uring_cmd_data {
>>> -    struct io_uring_sqe    sqes[2];
>>>       void            *op_data;
>>> +    int            init[0];
>>
>> What do you think about using struct_group instead?
> 
> And why do we care not clearing it all on initial alloc? If that's
> because of kasan, we can disable it until ("kasan, mempool: don't
> store free stacktrace in io_alloc_cache objects") lands.

Not sure I follow - on initial alloc they do need clearing, that's when
they need clearing. If they are coming from the cache, the state should
be consistent.

-- 
Jens Axboe

