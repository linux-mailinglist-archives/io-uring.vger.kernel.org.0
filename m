Return-Path: <io-uring+bounces-1249-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3239988EC0C
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 18:05:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB8A81F2CE47
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 17:05:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4809E14D44C;
	Wed, 27 Mar 2024 17:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bikwYunb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E91214D45B
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 17:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711559152; cv=none; b=KuBzTS4TmwlkGPq1dZrCahJLRatuT0ovABcD1jKYQ7KsZlN9cj6Budk0zKxgwctaYT90ytylQ/cS6uDDPSZV1MXcvZzY0v0Za5/gaSm6sQujHSOp8Lv3y30A6+ilnrIPjfsbC65hhat7ZQmll0BP2qGjCScNbqGiEFyHAlXRVtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711559152; c=relaxed/simple;
	bh=pLKnmys22mi2a4DtMoscHNrg4btOQ6VCiyy1oPwrQ6Q=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=H+Wx69LjkcV9REGfGI9gF72flJhjnswV250Hyf+ZIHx3VtRjXNl7tA0zQUaZWUriL4q9UxAKmryH8OtqB5xDEu26ezcyp6oSAsn6OoPlQfhYfLB+RvUfXSOlzegKMIVNBAskOu/3cO4ZWwMMMPaXMjSlj/XQWr8EZuixXWXRvrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bikwYunb; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6e696233f44so21162b3a.0
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 10:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711559148; x=1712163948; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a/FFnUc8IMS523UM/kaNZcv38+bb9/H/2FMB9fAxJf0=;
        b=bikwYunb+8PP21BiRazqOW62WpnwEKemUFpfkYqgn9YOeSTDGn90LckL+Tgkh228/f
         eo2K0luyM4sBacFPyycGfb+bW1ZdGvKKJ1pkrz87TNG9j4WZ01F6x4f33ZsxTPhCqRbq
         XkwTPl7mHO2xC+HHBO69sOOH5ZepC2Y2jJkS8TMkHTPSQAwH2HJZz8vEz4DmfnKfYfjB
         YwOHtDXJtaIu4u/LyV9J5eurtqvDSGGxHzTzrTWbraqwGOkVVIb0dhVRgNfe66Ksfw4A
         2wjd1I+Oxl+NToRt+t/r7JU0qKiwj956kRPW3Br1YifyXwpdFpzA5KNyH7xTqiEX9kkr
         oHhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711559148; x=1712163948;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a/FFnUc8IMS523UM/kaNZcv38+bb9/H/2FMB9fAxJf0=;
        b=BG+PJ5M2JfwQN8GswJ57Fb/FYNJ9TTs2jwbMcNMc8yUZZUWigMHSgVCVKq4wSPpvb/
         /DDi6FUiIXaiPILLSZk/Ep4gNiqj/yTW/dJWS2t0Ai37j4Ee0nGV0ZemeEMWMsNxYsPK
         IeQ9AO6F4ub1f8PvNLFT0Wn3WDOSA1MF0gTNd5p2DcdWE2GtZCIg/fE7Y+ratqPV45tv
         L+vVH/KG44XcV5Hj9MlgLro558XBH07KvzKpxVpxPnj2lFezOrFpwaGXmetZBqrKokzV
         JkZEi6oDyAZUEG5LkpHiGVRrjPodjnaZJyEhpVxS9FpdXv78rMKfxKCadlm/ldEPcx8C
         XoVw==
X-Forwarded-Encrypted: i=1; AJvYcCXr70A1J5VREHw2xabsc7zMOlnpx+BUYCflLaFedpw0hNRBgK/EczwAQDvprKjQY4KiNsD80ymaNTT8EvuSBv3f7/JCpjbsywc=
X-Gm-Message-State: AOJu0Yz58imS4NDAm5psZ080gD0DC79gFQgU9QvxZOF2+0gSTrMjF/PS
	cF9cTw/wwMrawASwqU3Il/4/7oB+LGUf1UxlV7+euqHtlnCZQQGPbaogQ8MDZA4=
X-Google-Smtp-Source: AGHT+IHRPWVP1Q9wTkcnFyUBjgAgSa9veCY+4YO3I3AwI0hsfB2EjM54auZAaj2Tqm+csnGBdICdaA==
X-Received: by 2002:a05:6a00:93a2:b0:6ea:88a2:af80 with SMTP id ka34-20020a056a0093a200b006ea88a2af80mr452859pfb.1.1711559148286;
        Wed, 27 Mar 2024 10:05:48 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:122::1:2343? ([2620:10d:c090:600::1:bb1e])
        by smtp.gmail.com with ESMTPSA id s24-20020a62e718000000b006eac4b45a88sm2282664pfh.90.2024.03.27.10.05.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Mar 2024 10:05:47 -0700 (PDT)
Message-ID: <747d6dcf-c684-41b2-bd6d-742c0271b105@kernel.dk>
Date: Wed, 27 Mar 2024 11:05:46 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET 0/4] Use io_wq_work_list for task_work
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240326184615.458820-1-axboe@kernel.dk>
 <03e57f18-1565-46a4-a6b1-d95be713bfb2@gmail.com>
 <88493204-8801-4bbc-b8dc-c483e59e999e@kernel.dk>
In-Reply-To: <88493204-8801-4bbc-b8dc-c483e59e999e@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/27/24 10:36 AM, Jens Axboe wrote:
> On 3/27/24 7:33 AM, Pavel Begunkov wrote:
>> On 3/26/24 18:42, Jens Axboe wrote:
>>> Hi,
>>>
>>> This converts the deferred, normal, and fallback task_work to use a
>>> normal io_wq_work_list, rather than an llist.
>>>
>>> The main motivation behind this is to get rid of the need to reverse
>>> the list once it's deleted and run. I tested this basic conversion of
>>> just switching it from an llist to an io_wq_work_list with a spinlock,
>>> and I don't see any benefits from the lockless list. And for cases where
>>> we get a bursty addition of task_work, this approach is faster as it
>>> avoids the need to iterate the list upfront while reversing it.
>>
>> I'm curious how you benchmarked it including accounting of irq/softirq
>> where tw add usually happens?
> 
> Performance based and profiles. I tested send zc with small packets, as
> that is task_work intensive and exhibits the bursty behavior I mentioned
> in the patch / cover letter. And normal storage IO, IRQ driven.
> 
> For send zc, we're spending about 2% of the time doing list reversal,
> and I've seen as high as 5 in other testing. And as that test is CPU
> bound, performance is up about 2% as well.
> 
> With the patches, task work adding accounts for about 0.25% of the
> cycles, before it's about 0.66%.
> 
> We're spending a bit more time in __io_run_local_work(), but I think
> that's deceptive as we have to disable/enable interrupts now. If an
> interrupt triggers on the unlock, that time tends to be attributed there
> in terms of cycles.

Forgot to mention the storage side - profiles look eerily similar in
terms of time spent in task work adding / running, the only real
difference is that 1.9% of llist_reverse_list() is gone.

-- 
Jens Axboe


