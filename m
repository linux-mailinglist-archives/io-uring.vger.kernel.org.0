Return-Path: <io-uring+bounces-11024-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 67647CB8854
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 10:49:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3DBA23007696
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 09:49:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75A8531577D;
	Fri, 12 Dec 2025 09:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mZWKSwfX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F1117C211
	for <io-uring@vger.kernel.org>; Fri, 12 Dec 2025 09:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765532975; cv=none; b=lZZy6xUE/gxYMlVv5xsl21iq/JanjyNKStQsHzj70iNq2XUoD/zGC4GiS0Pi8EN3fI7JHNrc5zhlQp8sv1efIijMZRP0hLRvHztFWJ/MNisBq2KgXGogIvsVbRwQn2ytrDlnrr3LZrCyXUddXSE3JbWwRyxWFMhkQUecidki8pY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765532975; c=relaxed/simple;
	bh=Zi0HAm5ISAfFOyplrD8JYPk8dlYOV00R3NoaSgKwP6Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mcvrpyX01EAaVlneiqSvDPFTVBvvkH8Wytzyqx7rfHnt+g9rFXUS3TnnocrriMFCgSLF+UCzhUAV2kHnpxw+BYsWi5SvKpSq6yDyBkBqZbrhc/1ZVrJvBrhZn2SdWjL/u8EZrKV6YhYKhAChmQohzAa3Cp6SzBrb2wVbD8MXsIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mZWKSwfX; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3437c093ef5so1082476a91.0
        for <io-uring@vger.kernel.org>; Fri, 12 Dec 2025 01:49:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765532973; x=1766137773; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7OPYqE/T1Jn3dyNFsV7itVNm44RgJkhKZs7I9v6pzwY=;
        b=mZWKSwfXdo8QcGKIVXvKhjSbJjLP6LVoiTazGD4ypqzCqQGNWVfe1XEs2FOLQLeKHb
         FpRhuujYbGKEZSTJsMFQ3x9zDz899R9+C8JoOuF+LUVrq8WN0ZNLQzEFYeJsg7DNEF1c
         AWFe0pdnWx5bHftnlFYfab9WvGhma6Zlhh1VXXLY2GjTXo43AtOJhrrS0mr//8OSwrHX
         bPiA4NnF03qdIPXfEcZdo/J56lXvNLJ/YzTuTkw/A18BtPi/kqPNLLbTZCKdAr7tYyTq
         5eM6Ym5S8mdkETsGSoz7OfnNc2+4eNtMpKiY82JZsTBcFgRI6aNzovh9pRKjSAgkoUcJ
         2ZhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765532973; x=1766137773;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7OPYqE/T1Jn3dyNFsV7itVNm44RgJkhKZs7I9v6pzwY=;
        b=FGhZlIpb6R32CJ7KWk4xVAf/vd4MiLUuzTEPy/OXTWctr/Uqx7Vy4BHjXvsq8tMC1J
         oyQNulfGmvnaZ2doOobfob86XfqWu3rD3eHIynnlx86/xoQ+pWpJ9x5B9pDytVarqAn3
         GGeW6W182L70Fd3d1OJV9oRjH0osvcqmH4kQ0rSIOf5558IN0EGGcrA0zYYzDlr+bHJK
         2H0TZHiALDVokq677msNoiXiwrjWj2UBkF05DDFlHQoC9XB5tQtJYXTBy0NqGPHyigv4
         ghoaj6IxXtG2o8of0Jf9nwUKCfGfa3Ec6m7PGXr9PY1/mSf0MhzBXN89B/DmpCfIAo8S
         HFOg==
X-Forwarded-Encrypted: i=1; AJvYcCWMffCFLOvTmVfFp0rwJiUn3fH+0QYdR3dOx2aKoF/KqkO8H8rNHrn2gCfauZO9d2oTJAwrvskD1g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxbX4Rur07mqcBt7nSztWom1o1I1/CX1SzHh9Ela3zoB/eLFvnz
	l2BbQkfkdsm3hUN6Cz5kjWvlpQTM4I03s9IJU7ssqk9PHlbh1teuIeRJ1XadXA==
X-Gm-Gg: AY/fxX7R1s2M30nYjW5ua+8d2uPxtOdOVU4fBNGrIiSJZAkGrjipbbc4aLvqxifLJFC
	2f3wII4SC1evyVf1QjRR278NvLYWib5UnLCp6B6XZqTFaJ8WLtOrNb7Zy3fj/1vCtfjdHj2JvlK
	IZEbOasMnZZ927FQqqGSrqbERi3GmtuAElpaV59tC8/JVdk7bsNVz29xlyQFykxo52ZXvKhz8Vv
	7lhdKKaKdD+/9NqOR+EUE6Xcint9k1UGWgWHq9WfPKXS4MUcHHigDBXyVetd1sHZY+t6utLqUuh
	LLBX4J/8IX7eR0QQi5wHNgvpL4rdMlCqdbUQ2D40a/U0Vwu38r1No8Jjkj52UrX1RHc59mXq4on
	oncoYljCDA+A72XG2WIzecZDwilYk8CVqSBGX6t1aqhW5LCPp+zDQocop0l+bXdGk7pRe3tVvKp
	xHMvtzQt2cmwOECJ9yGaM7mzKNFbZMcAob4hzUJQzqMw==
X-Google-Smtp-Source: AGHT+IHk3b+r+U62D5TAWv7XilaCfjCDCYarnMfrgzo07fuxZBLJC0uIY9P17yuaaDS9B5eszCZang==
X-Received: by 2002:a17:90b:3146:b0:341:6164:c27d with SMTP id 98e67ed59e1d1-34abd6cc322mr1678686a91.3.1765532973063;
        Fri, 12 Dec 2025 01:49:33 -0800 (PST)
Received: from [100.82.101.13] ([203.208.167.148])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34abe3dea94sm1455980a91.11.2025.12.12.01.49.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Dec 2025 01:49:32 -0800 (PST)
Message-ID: <21672cc5-abc2-4595-94b2-3ab0c2d40cf3@gmail.com>
Date: Fri, 12 Dec 2025 17:49:29 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] io_uring: fix io may accumulation in poll mode
To: Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
 io-uring@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>,
 Diangang Li <lidiangang@bytedance.com>
References: <20251210085501.84261-1-changfengnan@bytedance.com>
 <20251210085501.84261-3-changfengnan@bytedance.com>
 <ca81eb74-2ded-44dd-8d6b-42a131c89550@kernel.dk>
 <69f81ed8-2b4a-461f-90b8-0b9752140f8d@kernel.dk>
 <0661763c-4f56-4895-afd2-7346bb2452e4@gmail.com>
 <0654d130-665a-4b1a-b99b-bb80ca06353a@kernel.dk>
 <1acb251a-4c4a-479c-a51e-a8db9a6e0fa3@kernel.dk>
 <5ce7c227-3a03-4586-baa8-5bd6579500c7@gmail.com>
 <1d8a4c67-0c30-449e-a4e3-24363de0fcfa@kernel.dk>
 <f987df2c-f9a7-4656-b725-7a30651b4d86@gmail.com>
 <f763dcd7-dcb3-4cc5-a567-f922cda91ca2@kernel.dk>
 <38972bbc-fb6f-42c5-bd17-b19db134dfad@kernel.dk>
From: Fengnan Chang <fengnanchang@gmail.com>
In-Reply-To: <38972bbc-fb6f-42c5-bd17-b19db134dfad@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2025/12/12 16:58, Jens Axboe 写道:
> On 12/11/25 10:11 PM, Jens Axboe wrote:
>> On 12/11/25 7:12 PM, Fengnan Chang wrote:
>>>
>>> ? 2025/12/12 09:53, Jens Axboe ??:
>>>> On 12/11/25 6:41 PM, Fengnan Chang wrote:
>>>>> Oh, we can't add nr_events == iob.nr_reqs check, if
>>>>> blk_mq_add_to_batch add failed, completed IO will not add into iob,
>>>>> iob.nr_reqs will be 0, this may cause io hang.
>>>> Indeed, won't work as-is.
>>>>
>>>> I do think we're probably making a bigger deal out of the full loop than
>>>> necessary. At least I'd be perfectly happy with just the current patch,
>>>> performance should be better there than we currently have it. Ideally
>>>> we'd have just one loop for polling and catching the completed items,
>>>> but that's a bit tricky with the batch completions.
>>> Yes, ideally one loop would be enough, but given that there are also
>>> multi_queue ctx, that doesn't seem to be possible.
>> It's not removing the double loop, but the below could help _only_
>> iterate completed requests at the end. Rather than move items between
>> the current list at the completion callback, have a separate list just
>> for completed requests. Then we can simply iterate that, knowing all of
>> them have completed. Gets rid of the ->iopoll_completed as well, and
>> then we can move the poll_refs. Not really related at all, obviously
>> this patch should be split into multiple pieces.
>>
>> This uses a lockless list. But since the producer and consumer are
>> generally the same task, that should not add any real overhead. On top
>> of the previous one I sent. What do you think?
> Ran some quick testing, as one interesting case is mixing slower and
> faster devices. Let's take this basic example:
>
> t/io_uring -p1 -d128 -b512 -s32 -c32 -F1 -B1 -R1 -X1 -n1 -P1 -t1 -n2 /dev/nvme32n1 /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1
>
> where nvme32n1 is about 1.27M IOPS, and the other 3 do about 3.3M IOPS,
> and we poll 2 devices with each IO thread. With the current kernel, we
> get:
>
> IOPS=5.18M, BW=2.53GiB/s, IOS/call=31/32
> IOPS=5.19M, BW=2.53GiB/s, IOS/call=31/31
> IOPS=5.17M, BW=2.53GiB/s, IOS/call=31/31
>
> and with the two patches we get:
>
> IOPS=6.54M, BW=3.19GiB/s, IOS/call=31/31
> IOPS=6.52M, BW=3.18GiB/s, IOS/call=31/31
> IOPS=6.52M, BW=3.18GiB/s, IOS/call=31/31
>
> or about a 25% improvement. This is mostly due to the issue you
> highlighted, where you end up with later completions (that are done)
> being stuck behind waiting on a slower completion.
>
> Note: obviously 1 thread driving multiple devices for polling could
> still be improved, and in fact it does improve if we simply change -c32
> to something lower. The more important case is the one you identified,
> where different completion times on the same device will hold
> completions up. Multi device polling is just an interesting way to kind
> of emulate that, to an extent.
>
> This effect is (naturally) also apparent in the completion latencies as
> well, particularly in the higher percentiles.
>
> Ran peak testing too, and it's better all around than before.
I love the patch, I had a similar thought, this addresses my concern,  I 
simple tested it
and the performance is a bit better than the previous performance.

base IOPS is 725K,  previous IOPS is 782K, now 790k.
It looks like all the problems are solved,I 'll do more testing next week.
>


