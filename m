Return-Path: <io-uring+bounces-10788-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A1B8C8541B
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 14:52:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6404B4E576B
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 13:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C1A923B632;
	Tue, 25 Nov 2025 13:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tn23i8i/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A337238150
	for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 13:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764078745; cv=none; b=FBaSDtuUbHEO9kVRR70FEHjCCs6NUCT9XdEGqzK64cPzyBY138D2Gl9GzK+njpYkTX1a0oHp7gRwrO21y8kz9ymsT6+SZx0MW9xT+GdPY5BzLV5XxmM8bQQDGQ8NiOX2SusRpw3RNz4CvmdAIlJdRyFYhFziHM2qulHnH1Pa1rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764078745; c=relaxed/simple;
	bh=f14XKdRLbAIaCqZKzl7GBicWGlFYtiJZvAmLderW2+o=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=JmZCXT0FZAaF8/u4htti8coiP0OCyuj60DpzlFFPdkE/NRjEdINv+LrVAyun19moc33ZPBlztBB0XvcE8bXE7FSpCIzeWYAW2PFtZGd9VrYMzIIGNTyhitlII+gBZpwveX+6yHMwg6JWCBHq0YwR7efyzADoFgVF+OeX+Q8tldQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tn23i8i/; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-477a2ab455fso59522855e9.3
        for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 05:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764078741; x=1764683541; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kHOesweq24KF358s0vEumPsOYuhj+3ibk2FmOjZUv+4=;
        b=Tn23i8i/gAj7vqH1s1cK5d5zQm7b7yhVGSi/AE/Ivf2m+vkkXTZSCrGKTRHLTuQTa7
         +KvNFkU/QqK+sEYwmwE2Yb0UignIKpNtSGsqpMHs/CPGxcYMG/N8qiBawIMySNh8OD9L
         5CFkyX3nscW9U/c0Ixc1EDHO06SCrhsAKXgyg9EeZTPGrTiWs68K46R3tkvVE17xIQlY
         0Zwxtkt7V4Jn7BDMVmlugZm3dJgJc/uiAABbZzW2rEcSjTHEnOrqyDjv+jCOU9L7FiMM
         HA/ARVms1OdAi49sm7BTSYV6aRV0jfm40tamlOr9bgiYxozsxBCGcTL6bgfe+VIuWtOO
         M3Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764078741; x=1764683541;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kHOesweq24KF358s0vEumPsOYuhj+3ibk2FmOjZUv+4=;
        b=BN2zFvi0BWQqD+IDRVC6v3ONRd7q50IcjbrAUOBPa2vti8p3CkJbvX5vFOnoW8FnA6
         J3FB15YyWalb2MbmXW/wWDc7FEpVQ5tpQSx6vM+3v1wyjLaZ+ESEnnh2fiyR4z64g0Ef
         nW4247A5iJB1Mrxs/7hKJm816mNHt5LEf/6FHPc645Vp48UKySEEk0kRAE/KLNLPhDMO
         Y7dROeald1WFmFlDIzR02EjMU4aH/pbuXIgpyGYcaWrmik+gCPHYf4X9ORlI+Py++e+D
         JoNjX/PhL/JPDtHAQWtmp8hPKAY/YWp+0B8s/3g5G4a2CfULyBizDzw+ty8rl1sSMGq9
         Cd8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUIAfRCOtZ9zzm9RbxSXOAn4YUsfEmgvoi0Tptjtnn8ENTOkDNoM6kAVSY4g2SFkgRqth+EcTNXWQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxPCWCAbGmunBO2VH7Ck5p1a4kpeQ7QcSEek0jPkl3aBABQ4cmk
	PGK0/Ht1BJy7dkzFwM17n+Uig37rBmsOQOTdb5AVGX9Z9VHkEX2qaAY6
X-Gm-Gg: ASbGnctXP+gR30bwp2iWxCNchzO+YkQEocFCWJh/0abya2ispTtF8cuZTk+H7+Q9RCd
	QnXDy87FOv3JgP9O6gASCMJDGGUM0ekzcCGd9f11EWEsCVPyiI/cSrbSKbAV8nYWfEhz8GhGQee
	cpl+lgEWIGlYkHmiMq5hKubMZAtqjLrG+hybTNI8RNFMFmSgR4j/Uf3mDAyfKb/v5/8cxwSyjJK
	N1yjXEkpgAOKIBnOlypPgfScUJcCZmGfOMKlzL7kcg+1EOzjmOlmAQrRwVCOHQxmmYSVTMDKN3q
	nUNc0SaxKOZvVAgafBNWrTgqMasu51w9/o13VgD6LA+DA/wYJwIETwwPJjlvzj/oVzzTS45zlDd
	cQgSbZO3+SzG4tP4AZqGGyKLaFFEUXKT2BhVDE+Llg8fPKj3dnOhups6FzRilCyLMt5+gBdFibJ
	xVzNLclGpgP6C609TWGFqEnUrnYCOYy5gqz82VM/c4CVkcfsqwXGEcaZ7kR7kVyfiRr8q6paPV
X-Google-Smtp-Source: AGHT+IFKl0FSWbmMlOH9ZWfAZWRSmX8BD6ohJLnDHz1PIktPZZElxLDCt4b4SkoYMkjbJJn+KqrIYg==
X-Received: by 2002:a5d:5d81:0:b0:42b:3ded:298d with SMTP id ffacd0b85a97d-42cc1d2d5ebmr16251211f8f.32.1764078741365;
        Tue, 25 Nov 2025 05:52:21 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fa3a81sm35280457f8f.26.2025.11.25.05.52.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Nov 2025 05:52:20 -0800 (PST)
Message-ID: <a80a1e7d-e387-448f-8095-0aa22a07af17@gmail.com>
Date: Tue, 25 Nov 2025 13:52:18 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Pavel Begunkov <asml.silence@gmail.com>
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
Content-Language: en-US
In-Reply-To: <53be1078-4d67-470f-b1af-1d9ac985fbe2@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/24/25 14:17, Christian König wrote:
> On 11/24/25 12:30, Pavel Begunkov wrote:
>> On 11/24/25 10:33, Christian König wrote:
>>> On 11/23/25 23:51, Pavel Begunkov wrote:
>>>> Picking up the work on supporting dmabuf in the read/write path.
>>>
>>> IIRC that work was completely stopped because it violated core dma_fence and DMA-buf rules and after some private discussion was considered not doable in general.
>>>
>>> Or am I mixing something up here?
>>
>> The time gap is purely due to me being busy. I wasn't CC'ed to those private
>> discussions you mentioned, but the v1 feedback was to use dynamic attachments
>> and avoid passing dma address arrays directly.
>>
>> https://lore.kernel.org/all/cover.1751035820.git.asml.silence@gmail.com/
>>
>> I'm lost on what part is not doable. Can you elaborate on the core
>> dma-fence dma-buf rules?
> 
> I most likely mixed that up, in other words that was a different discussion.
> 
> When you use dma_fences to indicate async completion of events you need to be super duper careful that you only do this for in flight events, have the fence creation in the right order etc...

I'm curious, what can happen if there is new IO using a
move_notify()ed mapping, but let's say it's guaranteed to complete
strictly before dma_buf_unmap_attachment() and the fence is signaled?
Is there some loss of data or corruption that can happen?

sg_table = map_attach()         |
move_notify()                   |
   -> add_fence(fence)           |
                                 | issue_IO(sg_table)
                                 | // IO completed
unmap_attachment(sg_table)      |
signal_fence(fence)             |

> For example once the fence is created you can't make any memory allocations any more, that's why we have this dance of reserving fence slots, creating the fence and then adding it.

Looks I have some terminology gap here. By "memory allocations" you
don't mean kmalloc, right? I assume it's about new users of the
mapping.

>>> Since I don't see any dma_fence implementation at all that might actually be the case.
>>
>> See Patch 5, struct blk_mq_dma_fence. It's used in the move_notify
>> callback and is signaled when all inflight IO using the current
>> mapping are complete. All new IO requests will try to recreate the
>> mapping, and hence potentially wait with dma_resv_wait_timeout().
> 
> Without looking at the code that approach sounds more or less correct to me.
> 
>>> On the other hand we have direct I/O from DMA-buf working for quite a while, just not upstream and without io_uring support.
>>
>> Have any reference?
> 
> There is a WIP feature in AMDs GPU driver package for ROCm.
> 
> But that can't be used as general purpose DMA-buf approach, because it makes use of internal knowledge about how the GPU driver is using the backing store.

Got it

> BTW when you use DMA addresses from DMA-buf always keep in mind that this memory can be written by others at the same time, e.g. you can't do things like compute a CRC first, then write to backing store and finally compare CRC.

Right. The direct IO path also works with user pages, so the
constraints are similar in this regard.

-- 
Pavel Begunkov


