Return-Path: <io-uring+bounces-2132-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 027198FD6A0
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 21:39:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6C4051F26D40
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 19:39:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D415152DFA;
	Wed,  5 Jun 2024 19:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="B3qzt5h/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8D91527B9
	for <io-uring@vger.kernel.org>; Wed,  5 Jun 2024 19:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717616344; cv=none; b=mq5Iwb5GnkbKIGUeKctqKRr0BuYFb6EuM+Npp3y7bq4CAM3ZHIAYEP0p9Ma6iMVvVa6ND8vEqde1gyO1SpZ5AoV9BX77N3OM3XLfOrko+JYfv2chg/ZGMxYHaXWZXIokNN+kH/SjDW3L9SU6Xux/k5ePDDJ0j8Jvq4SYyzlss4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717616344; c=relaxed/simple;
	bh=sXsIY3eWhb5qaiL0vff0J6Eito7BK9qvOgaDJOxdtQU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=bQg395O4lEH7/mMYwYibWmhap2Bkh14OXdYkOOKW0txW4DvBRhl4V0XiI+9wY8ICvbeZr+a/TouSXuqGFr/r4hcuDoZEeurBUDuOPn7DnCo7MLuGlC/Bsx5RlMVNB+mHl9ojxbhJrbUVbArQhvw0372DtgkFeUynkR+qlpc9mUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=B3qzt5h/; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6f94a070d09so12049a34.3
        for <io-uring@vger.kernel.org>; Wed, 05 Jun 2024 12:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717616342; x=1718221142; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XlflBXXO0avF9haRe+wgGW+1eN5YskuRnrUMKYzCfeQ=;
        b=B3qzt5h/C1OTiY5VtDNospaB0s6S8VLa7uA8thSiCc4lKN7AsoEc4Pnn1u0o1WNvAL
         UCe0tfms+JyLQAysdpQuKDRu3aIvi9bk0PO6P7hh6hFdttR4MLT/pllF5sr4L6ISduPx
         9CyCvTWPY4mHVleHGUlFk/T76IRRg+RK6v5ntLkCbFuQ4LIhZ+/KCbFIJq/ffHpGcsmE
         TrdlDY6HYuP+bhvfVjJ2ieKTXSzczl4Wx1QvgYAQWoNekKDOAvvNmkQooFDJhjIa02Nl
         /O+i4JXbiV8uiRS4lZwHoSRCCkbaFtvXiSqRnkDFZfSHBpCMZK1ENdPcCWMx3CDvXccN
         iFGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717616342; x=1718221142;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XlflBXXO0avF9haRe+wgGW+1eN5YskuRnrUMKYzCfeQ=;
        b=YQSW+U4gFb/akxq+ebPRN2Wr0hEfnMmFv8/y1YkJt3wvhAR3IdzW9D/ZOG6Nb5EiQl
         YNhNHNjHo6+4KZ3hv0DCT+1GmMIlFs1wew3L1azdEBG9hXji1daWAzjzBxMw3RmuDRWc
         MXBIfxo/4omg8RaK+CdEU8Ew0JgcHj8/vzuX5rvRvfjmAl9zObR9zZ4vzJ8P9OID4T0z
         LLzn0I3mfi81JvcO0ZkxZzGvBQI5br0U1kXX8JG/tqNAl5yA7QxEqA8kkL7e4Wi6dNao
         +CG1LHqLCW0WeUgAfn8jeoXOOgLAvO0kZoWpt8qjWMlj7196TiqoxMaLmIn6C3u0/3tb
         FpvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbvBQnqsONUZL2wbX9CTKHWRFHwoeJjRzk4YQ2tQORBMwmqzKYqNZBL2Nr0eePO5lwxnBrspT9Rj3Y/FXCAwpjH2rcfbPXyco=
X-Gm-Message-State: AOJu0Yyfkq54X+2EnMSJsxoG0Z7qQPEEkneZE8/xfKEFA6bOFHdcyVog
	Q1QcZeDYqiWJeeX8b/ptaGHErHQLVTL5nOrglyNUaZqD6mYNdWcdeLN37XkU03gqG8w4U0xWYtz
	s
X-Google-Smtp-Source: AGHT+IECnA4VSfSDBgUD0f2vsR8vWsOdlcKagFzzD0mKiG/t+tSPOUHFaB5a/RAn8Za5nlrj7IMQDw==
X-Received: by 2002:a9d:6f92:0:b0:6f0:3cf3:fb35 with SMTP id 46e09a7af769-6f94b72e9b2mr941661a34.1.1717616342462;
        Wed, 05 Jun 2024 12:39:02 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6f91053a82esm2497658a34.30.2024.06.05.12.39.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jun 2024 12:39:01 -0700 (PDT)
Message-ID: <31d4919f-09af-412f-b43c-c926b9d73b97@kernel.dk>
Date: Wed, 5 Jun 2024 13:39:00 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: move to using private ring references
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240604191314.454554-1-axboe@kernel.dk>
 <20240604191314.454554-4-axboe@kernel.dk>
 <138bf208-dbfa-4d56-b3fe-ff23c59af294@gmail.com>
 <7ac50791-031d-453f-9722-8c7235573a21@gmail.com>
 <04539e03-da04-47d9-9363-59c2f4ba0b03@gmail.com>
 <9514cccc-791e-4cd3-be55-3381092d8167@kernel.dk>
Content-Language: en-US
In-Reply-To: <9514cccc-791e-4cd3-be55-3381092d8167@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/5/24 1:29 PM, Jens Axboe wrote:
> On 6/5/24 1:13 PM, Pavel Begunkov wrote:
>> On 6/5/24 17:31, Pavel Begunkov wrote:
>>> On 6/5/24 16:11, Pavel Begunkov wrote:
>>>> On 6/4/24 20:01, Jens Axboe wrote:
>>>>> io_uring currently uses percpu refcounts for the ring reference. This
>>>>> works fine, but exiting a ring requires an RCU grace period to lapse
>>>>> and this slows down ring exit quite a lot.
>>>>>
>>>>> Add a basic per-cpu counter for our references instead, and use that.
>>>>
>>>> All the synchronisation heavy lifting is done by RCU, what
>>>> makes it safe to read other CPUs counters in
>>>> io_ring_ref_maybe_done()?
>>>
>>> Other options are expedited RCU (Paul saying it's an order of
>>> magnitude faster), or to switch to plain atomics since it's cached,
>>> but it's only good if submitter and waiter are the same task. Paul
>>
>> I mixed it with task refs, ctx refs should be cached well
>> for any configuration as they're bound to requests (and req
>> caches).
> 
> That's a good point, maybe even our current RCU approach is overkill
> since we do the caching pretty well. Let me run a quick test, just
> switching this to a basic atomic_t. The dead mask can just be the 31st
> bit.

Well, the exception is non-local task_work, we still grab and put a
reference on the ctx for each context while iterating.

Outside of that, the request pre-alloc takes care of the rest.

-- 
Jens Axboe



