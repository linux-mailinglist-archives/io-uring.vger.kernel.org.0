Return-Path: <io-uring+bounces-10792-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 70A7CC86D44
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 20:40:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E8B97350499
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 19:40:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CAF032ABFB;
	Tue, 25 Nov 2025 19:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lX59330w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8EF2D130B
	for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 19:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764099622; cv=none; b=TdcXjaOhxYmEFICRWG/lkjITXhqf388IZ0cn3ZVAgz7ew1FEXX5eOtGEL3vgwM4d99iaGfLgTAplE9FV0Ay25yvZ/Z+7aFDdaEgsmbRznEX3sbwW9K4KldqZayWfFcCWOoypYeVZog/crLl6ntCvDB5qPcC1Ro7/vswrmtXtP5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764099622; c=relaxed/simple;
	bh=55KLs212Dn8sTkvNUHAgTA9I9hiZ2MXbrlzA2dcyhk4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UvVa08YiBhr/0/Knd176g0U8/K5+nZnpsjfye/0vQkwABGd7OXr1rLp8zmUKBl2BNmMFqlQHfIgwZ72pii0prliK/J4o+6ACkY8FHNLV7MKffwHzux20NZGhryJH0S38OeSP1d+JZDZ7iKi9xr/lYvj9BE2tYQrCJk4NCQUS464=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lX59330w; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-477aa218f20so36749045e9.0
        for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 11:40:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764099619; x=1764704419; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F+mYioxWgzcz5tqtizOnI1Ne46KDyU7fg8afEAzl4P4=;
        b=lX59330w6ZKGrDncB/Dj6T4JJGTrkq1f9IPZxOCmJWuHlE7ipbmWslGLZsPsstSfWM
         5F2gEEU2zV5v4u1sH1DzcKPfG8gjox6BUe4YLavuSmK4Arrkv0102hJmT4ZaD9It27ug
         q9gLRyjwP3pEsVpns5Y6S+iga/fVBqZ8B6wCg8nQrlaGACdM7I1VJH9MMBNFhQVG7Juq
         f1088WxUmHtpqFHZ1rtZ5g0vgdVBYQamSEnU6ymbvAs2j9v77zP9HzDicGsUBKz2jIA6
         +BVgrj+KruQsFSe9Hdtxr7kWdkfDWk1lpYa+vZhHm2s98p1ZxUsCnnZ6/evEUiOyLTlA
         yCGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764099619; x=1764704419;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F+mYioxWgzcz5tqtizOnI1Ne46KDyU7fg8afEAzl4P4=;
        b=R9JkXXekCeLLaup16hV5hW/jVCVfpnfAwImU4yeq/IcPKrGWGEKj/3JiihxpdSVIQs
         RzGIAD6KZ1la3M0xm6+i/V570KOx/ypiZq3xvRIbbGceV8HDRyAUzURRQH/3bVTndy73
         aK94VPqQ6VaxvCwZdAvy3K399LJVVPVd3a+bHtuyqV+oEHvD1qN9iAk0B/nygWUxwiCd
         mIfpzVZmPG8vTKIJkHED/tAirJnlJMK8I2+XZ3GAOeUyOG4AoQzoI53p9IAVvhZLk2XS
         JJCIYLPkDXbUluier3Zh+/jwpMMFJvNdFNJnwSLHoKupjGWa7t7Vn6eP1pBBas1M/jP8
         POCw==
X-Forwarded-Encrypted: i=1; AJvYcCWFswcyBKRatiswXIyWADYKcTN5nKLy+hZW4nNSiBNRpReYlb6RfIfu7mUZicSbQO3PD2UnGfiAag==@vger.kernel.org
X-Gm-Message-State: AOJu0YygDQcP8mJb4i6lQ2bDkawdLe3wGoPr+xh6Ns5xnKkwGfkaKdRz
	WYhD9kWG6524rDbP+STT9IiUqoIrjsetKuRaSK+12/Zf6crs+PKKxgVl
X-Gm-Gg: ASbGncuHqPiar5DlW5JADHlSFtxXOjkYHzroy70FeqhvaV8kT2VHFsaigKurst/Jvh6
	Q8ggvfal0OUTAQYeJJL+n/0VdVx88R5vJjR6W8An0alwBdfWdFjrG9XKkEhK+LVVO23tmxuNuOI
	fQ8sn1omOLHlhAYlgff4W/wwvrL8qjr7RyBjchxdSfucrbmforDSQ44KZpnr12pr/lC0s69UDLq
	N7rKeWLN2PqM0wQhbP3wJ/qsTN9rGR0Hu9NmVHAssKaLBxuUDjDjNHLFf2Towibefu48GcYb1io
	4PeZFVWf8qx2Q4NqX3X7W7O4/8bKqJa4TmKuHGanlldWO1tmIsKnYtyKWATmb0ERGF3THLhpkqu
	Ho0Mc9DfYYLq2KTTp+V8TjapETBtXIr8LMgkWk7aq8wLWJN7inxLQABtPp/WX53zV/9+ZI9DPkG
	ng3sAhFI8cYQgvHmoV4P4ri6P6HBhU8GusYJw/80fJ9ZWyfx15jaYnooyLO0xNQw==
X-Google-Smtp-Source: AGHT+IFpWZeUDyopyguGNmEbgYIRF/Mo2eq9v5oFLJoUC93zNjBvPZO9k5dPUiOZ58x4X8B/LhlhcQ==
X-Received: by 2002:a05:600c:1c88:b0:477:9cdb:e337 with SMTP id 5b1f17b1804b1-477c0165badmr197645055e9.7.1764099618711;
        Tue, 25 Nov 2025 11:40:18 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4790add608bsm5321225e9.5.2025.11.25.11.40.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 11:40:18 -0800 (PST)
Message-ID: <478ea064-3a2f-4529-81f3-ac2346fe32f0@gmail.com>
Date: Tue, 25 Nov 2025 19:40:15 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 00/11] Add dmabuf read/write via io_uring
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: Vishal Verma <vishal1.verma@intel.com>, tushar.gohad@intel.com,
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org
References: <cover.1763725387.git.asml.silence@gmail.com>
 <fd10fe48-f278-4ed0-b96b-c4f5a91b7f95@amd.com>
 <905ff009-0e02-4a5b-aa8d-236bfc1a404e@gmail.com>
 <53be1078-4d67-470f-b1af-1d9ac985fbe2@amd.com>
 <a80a1e7d-e387-448f-8095-0aa22a07af17@gmail.com>
 <0d0d2a6a-a90c-409c-8d60-b17bad32af94@amd.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0d0d2a6a-a90c-409c-8d60-b17bad32af94@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/25/25 14:21, Christian König wrote:
> On 11/25/25 14:52, Pavel Begunkov wrote:
>> On 11/24/25 14:17, Christian König wrote:
>>> On 11/24/25 12:30, Pavel Begunkov wrote:
>>>> On 11/24/25 10:33, Christian König wrote:
>>>>> On 11/23/25 23:51, Pavel Begunkov wrote:
>>>>>> Picking up the work on supporting dmabuf in the read/write path.
>>>>>
>>>>> IIRC that work was completely stopped because it violated core dma_fence and DMA-buf rules and after some private discussion was considered not doable in general.
>>>>>
>>>>> Or am I mixing something up here?
>>>>
>>>> The time gap is purely due to me being busy. I wasn't CC'ed to those private
>>>> discussions you mentioned, but the v1 feedback was to use dynamic attachments
>>>> and avoid passing dma address arrays directly.
>>>>
>>>> https://lore.kernel.org/all/cover.1751035820.git.asml.silence@gmail.com/
>>>>
>>>> I'm lost on what part is not doable. Can you elaborate on the core
>>>> dma-fence dma-buf rules?
>>>
>>> I most likely mixed that up, in other words that was a different discussion.
>>>
>>> When you use dma_fences to indicate async completion of events you need to be super duper careful that you only do this for in flight events, have the fence creation in the right order etc...
>>
>> I'm curious, what can happen if there is new IO using a
>> move_notify()ed mapping, but let's say it's guaranteed to complete
>> strictly before dma_buf_unmap_attachment() and the fence is signaled?
>> Is there some loss of data or corruption that can happen?
> 
> The problem is that you can't guarantee that because you run into deadlocks.
> 
> As soon as a dma_fence() is created and published by calling add_fence it can be memory management loops back and depends on that fence.

I think I got the idea, thanks

> So you actually can't issue any new IO which might block the unmap operation.
> 
>>
>> sg_table = map_attach()         |
>> move_notify()                   |
>>    -> add_fence(fence)           |
>>                                  | issue_IO(sg_table)
>>                                  | // IO completed
>> unmap_attachment(sg_table)      |
>> signal_fence(fence)             |
>>
>>> For example once the fence is created you can't make any memory allocations any more, that's why we have this dance of reserving fence slots, creating the fence and then adding it.
>>
>> Looks I have some terminology gap here. By "memory allocations" you
>> don't mean kmalloc, right? I assume it's about new users of the
>> mapping.
> 
> kmalloc() as well as get_free_page() is exactly what is meant here.
> 
> You can't make any memory allocation any more after creating/publishing a dma_fence.

I see, thanks

> The usually flow is the following:
> 
> 1. Lock dma_resv object
> 2. Prepare I/O operation, make all memory allocations etc...
> 3. Allocate dma_fence object
> 4. Push I/O operation to the HW, making sure that you don't allocate memory any more.
> 5. Call dma_resv_add_fence(with fence allocate in #3).
> 6. Unlock dma_resv object
> 
> If you stride from that you most likely end up in a deadlock sooner or later.
-- 
Pavel Begunkov


