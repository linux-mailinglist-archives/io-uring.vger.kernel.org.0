Return-Path: <io-uring+bounces-1253-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE95988EDF1
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 19:14:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A27D29FA42
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 18:14:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4341214E2F0;
	Wed, 27 Mar 2024 18:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kRUJd+UU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDEA14EC74
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 18:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562991; cv=none; b=SsL8rVYKd6HOKf/EJrWIEdSDqS3YAdfDK2CtapagJ8Bmps08TdLXeTYTCZ4pkER0YI+VwIXPd88ycXy2m5SmC346E1sdLgym/9hJq3LwUnZcAqRJ12oGVrmL9KQGLupqlUvBqIbUtjqLO0u05bA7Aet7cQyKcqQBbSNRhPI21AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562991; c=relaxed/simple;
	bh=bfOGkVr/lxalajopbdP+g1OxE/l4GQzfWebLD1pVIsc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sIkbiZGh2br74DMs6O/zvWl+ZiZLr47uYt+YvZX3bVPcv7wgDENn/JmgS6D/RpVGnvwJKpO0ljtqYCw4Xl++vVA2+94d6Wau3HZ+COqXGgOd+gBnmvGBgko8nxJCbtoA5IPIdJ18MT8qgfF6WtHBvelKNE7wSn8oJf8KVzO5Vmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kRUJd+UU; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-41490d05bafso1019995e9.1
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 11:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711562988; x=1712167788; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nGV5CjzuZD3fAHObsoLVlKsc5bWhOlYyrWXGCyaP3BQ=;
        b=kRUJd+UUGllars5OE1kczVMhB/GKcpvvzGdS/zAcPmJraa9F084/4SOdb/HkLglyL0
         nhbGBUYmhiSbDNIMrXk3Mt/wQkXO71qtNpB0A3X3wVqCRuYoNcS50ggcGVfsguMmUXFt
         Nk5NnaibHce5D/fYnrlbQ2Dbh4PdciiPraYwztMOqpdZUUUDrjLlO9FceIft3opLdiXg
         qMkqzh9nwBpixta8TWxZVl2cah27d2MENYb6/wR8NkO7Ots4V4K2A6KokvyRG33VYKfE
         eXxENjBhKiaOYSWcbVktm1esejoDsPHDcM2ZeMYp2cTDD5L6+/4OJYr7vwpgVQNSB0/c
         cj0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711562988; x=1712167788;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nGV5CjzuZD3fAHObsoLVlKsc5bWhOlYyrWXGCyaP3BQ=;
        b=btnSNy37r2IM6dbbdMO/NgMSq5mqDISa0kwZFeZs+DP/v0Bo/k3hD5O4yWFI/VjaHT
         cG2PwzgKaXQIA0f6z+ttQ3NvgYKvXDHRuqBN3/6PCFZGAJTetUmsz0bB0J/lrEEFE0MN
         3l4mKsQHCkNqfvLk0BbYToTIIeBNAA7ylFMe0PvzjrxqBm/U0E5JV+c6IhEQ8kcjMRpb
         KDo34rpqA39SuIif1DDUO7bF5rGlQJUZ6OeOtAKuM22EgQVViFFuZCWlFzTqdmG3kQWA
         f7RahHtBkOqXd/2by060SV3Kz/IDUdCSaYov3nQ5yRCdDgFJoEY2CkXQHsU/NEQaC0x4
         8lvw==
X-Forwarded-Encrypted: i=1; AJvYcCUDOP+XceR2+RdHpY1CM/Bf9eGi1aOYdiUvECDLLsJ8N8wVwAAe4jU7F1InQ0KZeDu82jFthcEzlXr1HbBp0sFHcbmSwi3lkw8=
X-Gm-Message-State: AOJu0YxH3BTWgRgFT3X4fztx9sG2YsvOih53FYttl6CxCFphPczcklWO
	Vl4G3hdm5HxgqsPy38NX3NKuaYTDdK33dWy1VS5b/mmCMTnjnQlG5yrPztwJ
X-Google-Smtp-Source: AGHT+IGo9thdM1lAE4p7wf5oZk10zXTBUSALYe1HC2FUQUDT60wzm4/+yb/KQZu92rGOACa2WXSO5Q==
X-Received: by 2002:adf:f0c5:0:b0:341:be17:2554 with SMTP id x5-20020adff0c5000000b00341be172554mr723482wro.36.1711562987786;
        Wed, 27 Mar 2024 11:09:47 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.233.105])
        by smtp.gmail.com with ESMTPSA id cl1-20020a5d5f01000000b0033e72e104c5sm14624081wrb.34.2024.03.27.11.09.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Mar 2024 11:09:47 -0700 (PDT)
Message-ID: <38203eac-f4b9-42e3-b9cd-1d42902c1850@gmail.com>
Date: Wed, 27 Mar 2024 18:04:22 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET 0/4] Use io_wq_work_list for task_work
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240326184615.458820-1-axboe@kernel.dk>
 <03e57f18-1565-46a4-a6b1-d95be713bfb2@gmail.com>
 <88493204-8801-4bbc-b8dc-c483e59e999e@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <88493204-8801-4bbc-b8dc-c483e59e999e@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 16:36, Jens Axboe wrote:
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

I assume IRQs are firing on random CPUs then unless you configured
it. In which case it should be bouncing of the cacheline + that
peeking at the prev also needs to fetch it from RAM / further caches.
Unless there is enough of time for TCP to batch them.

> For send zc, we're spending about 2% of the time doing list reversal,
> and I've seen as high as 5 in other testing. And as that test is CPU

I've seen similar before, but for me it was overhead shifted from
__io_run_local_work() fetching requests into reverse touching all
of them. There should be a change in __io_run_local_work()
total cycles (incl children) then I assume

> bound, performance is up about 2% as well.

Did you count by any chance how many items there was in the
list? Average or so

> With the patches, task work adding accounts for about 0.25% of the
> cycles, before it's about 0.66%.

i.e. spinlock is faster. How come? Same cmpxchg in spinlock
with often cache misses, but with irq on/off on top. The only
diff I can remember is that peek into prev req.

> We're spending a bit more time in __io_run_local_work(), but I think
> that's deceptive as we have to disable/enable interrupts now. If an
> interrupt triggers on the unlock, that time tends to be attributed there
> in terms of cycles.

Hmm, I think if run_local_work runtime doesn't change you'd
statistically get same number of interrupts "items" hitting
it, but the would be condensed more to irq-off. Or are you
accounting for some irq delivery / hw differences?

>> One known problem with the current list approach I mentioned several
>> times before is that it peeks at the previous queued tw to count them.
>> It's not nice, but that can be easily done with cmpxchg double. I
>> wonder how much of an issue is that.
> 
> That's more of a wart than a real issue though, but we this approach

Assuming tw add executing on random CPUs, that would be additional
fetch every tw add, I wouldn't disregard it right away.

> obviously doesn't do that. And then we can drop the rcu section around
> adding local task_work. Not a huge deal, but still nice.

I don't see how. After you queue the req it might be immediately
executed dropping the ctx ref, which was previously protecting ctx.
The rcu section protects ctx.

>>> And this is less code and simpler, so I'd prefer to go that route.
>>
>> I'm not sure it's less code, if you return optimisations that I
>> believe were killed, see comments to patch 2, it might turn out to
>> be even bulkier and not that simpler.
> 
> It's still considerably less:
> 
>   3 files changed, 59 insertions(+), 84 deletions(-)
> 
> thought that isn't conclusive by itself, as eg io_llist_xchg() goes away
> which has some comments. But I do think the resulting code is simpler
> and more straight forward.

-- 
Pavel Begunkov

