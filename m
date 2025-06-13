Return-Path: <io-uring+bounces-8331-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8222DAD92A1
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 18:11:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E88DC3A1AFB
	for <lists+io-uring@lfdr.de>; Fri, 13 Jun 2025 16:11:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED3AD200132;
	Fri, 13 Jun 2025 16:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IQHkrkH/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4A73594F;
	Fri, 13 Jun 2025 16:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749831092; cv=none; b=JudidRIwmIgbs70kC6gY1dQwc6albi4e6NL+RCxyP7HYzBWUHmDQUtpoePqn8iY1QKOdmQ7866Dmxp2I3us9Csk7VrdisSaD0BH++1WVQbdcZWmm6Fzrn0MczOKk26atzeZX3f5UlkbQFa9HRqpN00WH4IUjHmjgtm16NIPBcx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749831092; c=relaxed/simple;
	bh=D1ITj4GdjLoyNT3sAnB4lgJg8AqZrOjpHHe8QAw1VM8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=isUDt5I2Iti5AmjsoxMbmbNYtAw3ePLiVOjT4d5tRffrL+rdByoz1snqOpQQZPfFNN9L1e89Ll9DEjBFY+p4T5bHZaDVolE0AaEtW4C1QTqNdE3dsSRbrZUVf1E1yYEiu7Drhvq5cK2E3zKQk0S94HBMB9iQIor9eW2DnisqWQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IQHkrkH/; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-3a507e88b0aso2291476f8f.1;
        Fri, 13 Jun 2025 09:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749831089; x=1750435889; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=djTz91ov2i0srIIkJAlK+NfElm2rN6LPscfEqTdW4nw=;
        b=IQHkrkH/oWSOU79lNvTeIhU35J0m4ncwPb/iFtNOohCY/JSfc1YkD5/6u3CNubG4vp
         UtCshp8YjozVBfny7+CGYd3U0e86+RYg/1Lx475MEq5/Dcgn7CUM1WzfRfPUHJA9swcl
         Nnvb2xeSEesqYLfcXc9811b/CUSd6zqKCFgAuMTR01uvrU0pGu7AMvivMexeZg/N0NYJ
         WNdLNug/47ql+8v4Mi03bukkv3EpSXiA1KnbAdf+IJ8WRAwnfjPivLES1kParl+1c7V0
         obTm0PTkyKkRZB03Kkvf4/az8DRrHIj9ec8FD/o8xs/MY9r0PzxHWSAdQBs7tWBXw2of
         WRLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749831089; x=1750435889;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=djTz91ov2i0srIIkJAlK+NfElm2rN6LPscfEqTdW4nw=;
        b=mWlI3+i3eAXtc1DzYnqyffyF6956Y8C5onchr0WTqUDcAPssap6Pdykv6AXGKJHlMG
         hOao3tg1g5uHGytNAAxFfCEDxa22CEQFgVWM/tUfG2+5AnqG3PNNeTwhTPYRUjOxTRVw
         t4QScQQK4EPOIHU88AAhctgTyphUBQPAZwqVoLTw6oJ6pQ9lexOHwiM9krGOHQIViDSA
         LBRGlRk6OyVgLODzz9tbDKIGdxeI1rdKiN20oEpu/ejLW5vJN3x6IBvQdzJq28MVVTCX
         xlN2Mr2R08Al3tdEwX+KLaL4FhAd/Jn5H5/fJPvxUGv38vBqLN0KAVQ+Ji1CVLajfaL+
         GErQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrqTPvFAL4mkWuNleaLk6/lsTa6RUqT8RwlPLCs5Gbu+tUNoSm8RCrThMqwS+9jBxMJJs=@vger.kernel.org, AJvYcCVhcdWVlfO2qqpetB8fIkYSuM6Fw7XYQFQF0FVBT7v39gDZbDdBo7bk2XQoJ2v2UV7KlyMOLW+ynYDNFg9z@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8k1XU0VoCbhvTGTm19jVKerFEUVTRUJy99x1RRQ/rXl/uoUoP
	uDHu64IRUlAaojugzPzYRNI1Txrfu0V2bViWY/gAb1MRad2B3ernDngY
X-Gm-Gg: ASbGncuH8fOE7X8GMabf3zoPo71t+CfnQUjyIfeYFclYaVkNXjzyrzH3wTqCAvmnjma
	aOLIULLnyOi1ET6sDjPkQIxxkDoZZwIkamL7kgHLhXVOxXXGZUt20Uoz3YwHHmcNzk+86LtVqSO
	a+Cx4BeH7nEPBDZyuumE+Rjw/6leuUP20clvgJ+ZkQr6zQaX26DNptDmjO/tuX1PocqoD0vAmH/
	rXKOV639mVYiZ5e2TlHnrUjbh4S07jiHlu5ocDK70sjzO6kEdyxqOTqpNXJi+glzdM/ksmIwlcB
	FPud53uPZNemXRtvzcOJHFDLXdBxPzaP1np9jicS8hLDCIkpDGm0UaETfl/JC12KmafZ+gXj
X-Google-Smtp-Source: AGHT+IFokHB4xgytSk5N1+IyzZiwrf7Ig6qUaw4U17koCWUQXbNFfRlLKvmZzXK5VjhGo2Mzn0SwBg==
X-Received: by 2002:a5d:5c84:0:b0:3a5:3e64:1ac4 with SMTP id ffacd0b85a97d-3a5723a2742mr359497f8f.33.1749831089151;
        Fri, 13 Jun 2025 09:11:29 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.140.198])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568a54d1fsm2743050f8f.2.2025.06.13.09.11.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jun 2025 09:11:28 -0700 (PDT)
Message-ID: <415993ef-0238-4fc0-a2e5-acb938ec2b10@gmail.com>
Date: Fri, 13 Jun 2025 17:12:50 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 5/5] io_uring/bpf: add basic kfunc helpers
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Andrii Nakryiko <andrii@kernel.org>
Cc: io-uring@vger.kernel.org, Martin KaFai Lau <martin.lau@linux.dev>,
 bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <cover.1749214572.git.asml.silence@gmail.com>
 <c4de7ed6e165f54e2166e84bc88632887d87cfdf.1749214572.git.asml.silence@gmail.com>
 <CAADnVQJgxnQEL+rtVkp7TB_qQ1JKHiXe=p48tB_-N6F+oaDLyQ@mail.gmail.com>
 <8aa7b962-40a6-4bbc-8646-86dd7ce3380e@gmail.com>
 <CAADnVQ+--s_zGdRg4VHv3H317dCrx_+nEGH7FNYzdywkdh3n-A@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAADnVQ+--s_zGdRg4VHv3H317dCrx_+nEGH7FNYzdywkdh3n-A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/13/25 01:25, Alexei Starovoitov wrote:
> On Thu, Jun 12, 2025 at 6:25 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
...>>>> +BTF_ID_FLAGS(func, bpf_io_uring_extract_next_cqe, KF_RET_NULL);
>>>> +BTF_KFUNCS_END(io_uring_kfunc_set)
>>>
>>> This is not safe in general.
>>> The verifier doesn't enforce argument safety here.
>>> As a minimum you need to add KF_TRUSTED_ARGS flag to all kfunc.
>>> And once you do that you'll see that the verifier
>>> doesn't recognize the cqe returned from bpf_io_uring_get_cqe*()
>>> as trusted.
>>
>> Thanks, will add it. If I read it right, without the flag the
>> program can, for example, create a struct io_ring_ctx on stack,
>> fill it with nonsense and pass to kfuncs. Is that right?
> 
> No. The verifier will only allow a pointer to struct io_ring_ctx
> to be passed, but it may not be fully trusted.
> 
> The verifier has 3 types of pointers to kernel structures:
> 1. ptr_to_btf_id
> 2. ptr_to_btf_id | trusted
> 3. ptr_to_btf_id | untrusted
> 
> 1st was added long ago for tracing and gradually got adopted
> for non-tracing needs, but it has a foot gun, since
> all pointer walks keep ptr_to_btf_id type.
> It's fine in some cases to follow pointers, but not in all.
> Hence 2nd variant was added and there
> foo->bar dereference needs to be explicitly allowed
> instead of allowed by default like for 1st kind.
> 
> All loads through 1 and 3 are implemented as probe_read_kernel.
> while loads from 2 are direct loads.
> 
> So kfuncs without KF_TRUSTED_ARGS with struct io_ring_ctx *ctx
> argument are likely fine and safe, since it's impossible
> to get this io_ring_ctx pointer by dereferencing some other pointer.
> But better to tighten safety from the start.
> We recommend KF_TRUSTED_ARGS for all kfuncs and
> eventually it will be the default.

Sure, I'll add it, thanks for the explanation

...>> diff --git a/io_uring/bpf.c b/io_uring/bpf.c
>> index 9494e4289605..400a06a74b5d 100644
>> --- a/io_uring/bpf.c
>> +++ b/io_uring/bpf.c
>> @@ -2,6 +2,7 @@
>>    #include <linux/bpf_verifier.h>
>>
>>    #include "io_uring.h"
>> +#include "memmap.h"
>>    #include "bpf.h"
>>    #include "register.h"
>>
>> @@ -72,6 +73,14 @@ struct io_uring_cqe *bpf_io_uring_extract_next_cqe(struct io_ring_ctx *ctx)
>>          return cqe;
>>    }
>>
>> +__bpf_kfunc
>> +void *bpf_io_uring_get_region(struct io_ring_ctx *ctx, u64 size__retsz)
>> +{
>> +       if (size__retsz > ((u64)ctx->ring_region.nr_pages << PAGE_SHIFT))
>> +               return NULL;
>> +       return io_region_get_ptr(&ctx->ring_region);
>> +}
> 
> and bpf prog should be able to read/write anything in
> [ctx->ring_region->ptr, ..ptr + size] region ?

Right, and it's already rw mmap'ed into the user space.

> Populating (creating) dynptr is probably better.
> See bpf_dynptr_from*()
> 
> but what is the lifetime of that memory ?

It's valid within a single run of the callback but shouldn't cross
into another invocation. Specifically, it's protected by the lock,
but that can be tuned. Does that match with what PTR_TO_MEM expects?

I can add refcounting for longer term pinning, maybe to store it
as a bpf map or whatever is the right way, but I'd rather avoid
anything expensive in the kfunc as that'll likely be called on
every program run.

-- 
Pavel Begunkov


