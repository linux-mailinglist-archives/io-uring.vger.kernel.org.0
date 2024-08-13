Return-Path: <io-uring+bounces-2738-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8153E94FBE1
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 04:38:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A1E90B21A52
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 02:38:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A15F9134A0;
	Tue, 13 Aug 2024 02:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WQ62d9Mk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD6481B285
	for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 02:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723516684; cv=none; b=PdKKAOxOchao45vzJk/+C7CwRokC2ogo6erWtATKotcN7u/pq3clXU0YUnaDkww9EZdJRhDMt0aV61kWQAzVKkmaejiETqmgnVI7os839CKQp3XzGI37XeEhfl2lTctbBAXvHKM6Fp7zeoWvZKmQsjE9jtRgy/6GVD7Ly2ojGtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723516684; c=relaxed/simple;
	bh=KAxtGA9uEaJlh8XJZf9PSwCrU/B8b4edjqdodS+vqt0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PdxsxpExOIWy4mu+gBzwnIuQCyvXy9c18o9YRP3mxPgQNDTxpJNTox7vdIuTV540qTAL2cjH1nDwampgA1I6aRjGt3CS2rPipQy0bng7h1WPyOCOn/kz+KLU578xzUzf0LMojMlZlStk7+IXNgrBCvzbu4X5amf9BRLB1GS/3T8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WQ62d9Mk; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4280ca0791bso36957175e9.1
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 19:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723516681; x=1724121481; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OTSndj20k8xuaMnEUawafsGLWSCeTFrqUiqFmA91nzk=;
        b=WQ62d9MkIXNngPatHQm1n/u/i7KIJQs+rVvxpvpxgEKWV/ujDJiwVCBFQAnktMqBa5
         KtfjJu8Acnoc4HNWpZOfXUYekEkQBwTs5FWDCOAkfI40VBE4YSCX2JTCw+m3NVk8LJLG
         Ysc6NexaCe5RfH0PpeRUS0sWQJp5qV/jzm/0HvYwyZpy6Y6D+kOyb4E0VktVaOR7gspM
         YS6p3Zyx27IX/wyouNX/hIyp6t/DtGKSautovo0bs2RaOZSna2hjOnfzMF+4wm1/urYQ
         tp6+I9E2eU5VyPOqHoR0LgstqsESwl/YaFWkzS2E8+oLvxTfvJDJW2Hi2ZjY6348Jw5c
         psrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723516681; x=1724121481;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OTSndj20k8xuaMnEUawafsGLWSCeTFrqUiqFmA91nzk=;
        b=qfqtruCG08aLPxXSHr+690dUQcVTLx4ZqqffUcENC9uVF5k+EhYoj9vi7plFtnneBT
         tSAFF93Jq0UMuj91d0ZFkb8e5h2NnzFq1uxzqQcJRVJMiQF5DlNY2iQCiaQp1zClN0eQ
         zBZNaKs4YPZERR4C6Gls/3oqotCgQGjFvMm/KenL7sKWQKfd/tUcrgQgHU9gVrSOUfiN
         TOXaPQXVzYkZV6VfvX2tsUqAoA5dSDAKi58FKwxsSHILl9pvjjkLavVl7PZ0TJ+jk1xe
         5+s6n1u54Nhf80B8Oq/a4AU3KfYdiDpwnbLqwfN7XPXKvob0BTw0cQo7RlnidsBj6zWg
         pRTA==
X-Forwarded-Encrypted: i=1; AJvYcCVAi+Yy5Fxkn09v3s4hqIH0FkKs2m5+NW0OphuoKS0Og0w3mN1uzvWULFsrlxtfpyRjf4OzG/cbvh5ONH9zWfGNwQKfMbEhMB8=
X-Gm-Message-State: AOJu0Yx9ub5RNONRYGVyoTT0VJ4TdElVaDWHkgJNIF3CP2U4HfxzCt5/
	vjdVERuB8u2fBsDN8uaXp1Ti1kitSBZoblu2X913N0prWLhKg/kYai3KoeZV
X-Google-Smtp-Source: AGHT+IEquPOT6ib9+sTYtrwOSGKU4eWDTKZw5+fRC30cF8eInNfyFoinW2oSnl0sKKcMTJAQcs4dkQ==
X-Received: by 2002:a05:600c:a46:b0:427:d8f2:5dee with SMTP id 5b1f17b1804b1-429d480e2bemr17329755e9.15.1723516681041;
        Mon, 12 Aug 2024 19:38:01 -0700 (PDT)
Received: from [192.168.42.116] ([85.255.232.227])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429c77370b0sm123174425e9.32.2024.08.12.19.38.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Aug 2024 19:38:00 -0700 (PDT)
Message-ID: <bb0ea79a-008f-46d5-8141-dcc8448404e4@gmail.com>
Date: Tue, 13 Aug 2024 03:38:30 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] clodkid and abs mode CQ wait timeouts
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: Lewis Baker <lewissbaker@gmail.com>
References: <cover.1723039801.git.asml.silence@gmail.com>
 <98f30ada-e6a9-4a44-ac93-49665041c1ff@kernel.dk>
 <6ad98d50-75f4-4f7d-9062-75bfbf0ec75d@kernel.dk>
 <61b2c7c1-7607-4bd9-b430-b190b6166117@gmail.com>
 <78d5648d-7698-44b9-ab66-6ef1edee40ad@kernel.dk>
 <0b661e9c-1625-4153-93b8-d0e03fea81dd@gmail.com>
 <666bd7b9-a927-40eb-858b-20dc194639ab@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <666bd7b9-a927-40eb-858b-20dc194639ab@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/24 03:09, Jens Axboe wrote:
> On 8/12/24 7:32 PM, Pavel Begunkov wrote:
>> On 8/13/24 01:59, Jens Axboe wrote:
>>> On 8/12/24 6:50 PM, Pavel Begunkov wrote:
>>>> On 8/12/24 19:30, Jens Axboe wrote:
>>>>> On 8/12/24 12:13 PM, Jens Axboe wrote:
>>>>>> On 8/7/24 8:18 AM, Pavel Begunkov wrote:
>>>>>>> Patch 3 allows the user to pass IORING_ENTER_ABS_TIMER while waiting
>>>>>>> for completions, which makes the kernel to interpret the passed timespec
>>>>>>> not as a relative time to wait but rather an absolute timeout.
>>>>>>>
>>>>>>> Patch 4 adds a way to set a clock id to use for CQ waiting.
>>>>>>>
>>>>>>> Tests: https://github.com/isilence/liburing.git abs-timeout
>>>>>>
>>>>>> Looks good to me - was going to ask about tests, but I see you have those
>>>>>> already! Thanks.
>>>>>
>>>>> Took a look at the test, also looks good to me. But we need the man
>>>>> pages updated, or nobody will ever know this thing exists.
>>>>
>>>> If we go into that topic, people not so often read manuals
>>>> to learn new features, a semi formal tutorial would be much
>>>> more useful, I believe.
>>>>
>>>> Regardless, I can update mans before sending the tests, I was
>>>> waiting if anyone have feedback / opinions on the api.
>>>
>>> I regularly get people sending corrections or questions after having
>>> read man pages, so I'd have to disagree. In any case, if there's one
>>
>> That doesn't necessarily mean they've learned about the feature from
>> the man page. In my experience, people google a problem, find some
>> clue like a name of the feature they need and then go to a manual
>> (or other source) to learn more.
>>
>> Which is why I'm not saying that man pages don't have a purpose, on
>> the contrary, but there are often more convenient ways of discovering
>> in the long run.
> 
> In my experience, you google if you have very little clue what you're
> doing, to hopefully learn. And you use a man page, if whatever API you're
> using has good man pages, if you're just curius about a specific
> function. There's definitely a place for both.
> 
> None of that changes the fact that the liburing man pages should
> _always_ document all of the API.

Nobody said the opposite, but I don't buy that man pages or lack
of thereof somehow mean "nobody will ever know this thing exists".

-- 
Pavel Begunkov

