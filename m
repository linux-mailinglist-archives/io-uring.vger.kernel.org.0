Return-Path: <io-uring+bounces-566-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5267384C30D
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 04:23:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD19CB24C50
	for <lists+io-uring@lfdr.de>; Wed,  7 Feb 2024 03:23:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCD4EFC02;
	Wed,  7 Feb 2024 03:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WBMNtwZk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4435F9F2
	for <io-uring@vger.kernel.org>; Wed,  7 Feb 2024 03:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707276210; cv=none; b=aqIv4BCq0pSAM3cLiN5k9xl1UHE/glN2am0NHPmc+9wYUV0YsSFimhx+USi3yNcvpYr/sm7P7YgZuN18gBNe+YcAGZNYmRU8TR2gBPU9K/PJCUHzZWKeA7UNi4Slpgv4pfWHZFVblQS99Jm3U7EDGl4BzivLxVSWB195QpKxwg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707276210; c=relaxed/simple;
	bh=Oth6HKkQrwLt7UwP4SDEzK0wdMmXWiKfX2zv78Aivxg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=M7i8pZ171Pz9n0KfbVJWaQlB9VuZnTDA2lTiFLTumxq5BJvyaASPlNFgtSBFKhpu/tW3K4Aii3fVT1vqgPVi5ke47lavRCxjl6IBOxs1Amp5jEY99uDKZWne+eGOcMU/InG1qguaTtd/salXC9WpflAUaabOPZ31VnKAQjIT0g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WBMNtwZk; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-40ffd94a707so1351315e9.1
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 19:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707276207; x=1707881007; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fHWdYEeEFQDrk/Nclzgv1hyODeI8VuV9Fe0i99M8iEA=;
        b=WBMNtwZkoQglw4wQlz9GcVFS/xGDalwyip8qJ8JSwvn9t/LBd6O1jJoAxLxsQclJmU
         abJFjcoi3xRToxy4c9PXF0GpTdc6W354n0dQ76Q15PJN98va0unJVR6dWrg3azLsChTu
         eiSvgy6nd1f3TsvJedsDN5N3VsCFZewRjhz9NFjtbeE5b5yW6dKX0n3zL6BqocW3E/Hr
         ardrIayCtrvrOc+2Zrwtne4TlU6MtCLGPAhVlBpNb2P4YNoJA1Nrmhjf8P53nLZFUfsK
         4stQ6MKA0DUmjiVrAV74rMWz7/9FqxXqHEEftf+ezD0vGu2fkJgOVt2PSM47MP58QloO
         UD2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707276207; x=1707881007;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fHWdYEeEFQDrk/Nclzgv1hyODeI8VuV9Fe0i99M8iEA=;
        b=wc21+6Zz9vFfVTF9qDVEBifje/yesFTDNVyqucJlXryQYzo/a2IrxEUNlTwFvO1k9p
         PY2GEq9JoCqTKAQjsGAMspTMkqHlArMpspM3CHwO4Zs3m8MsgVNxZioDTGwQ06wxM8wz
         bGY6yNb2X+5v5sLhBpS8jVBWZMzai9zv0FKDRqMYKYhnIz/VruTb3rFMYHa+rHvokLFZ
         x68RBNoknt3TrP79LM9GTlieuM5uLMsC/5WStIjgpKVPyxf6t83xrND2l/7wLUhfb9Eo
         BO8zu9bwTlJJNa4tNqYvG39v8/khV0TM5oNXOGbS1GmmR0wqKH6cMMTAYM5wcQCPT6fp
         IKxw==
X-Gm-Message-State: AOJu0YxNprOzxjWsvonJemaAUp8/FdjVVXXGmyIaKf2zzZyHhEkiBoQu
	pzlC5j1pJUYMRLrWD7/IF5m+tJENra/P2bdQ+Netb0U+vzZPFs/kLbnVsxs0
X-Google-Smtp-Source: AGHT+IFKndXJzBvHK3hSZZFVT/Gh2i6d83k74ZJrLClfV8aKpEFdQRub3gY+3rBeZg4SwkmWgQX4QA==
X-Received: by 2002:a05:600c:19c9:b0:410:12b3:839c with SMTP id u9-20020a05600c19c900b0041012b3839cmr10038wmq.26.1707276206886;
        Tue, 06 Feb 2024 19:23:26 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUyhtt6T/ufCOURAyWg8JUeBqGfjMVbmgxg6UEh0fYnm4IPsV/TyVnl7qVI4MChf1beWKUm/9HH0FEgi6LZ8DA8emkDB5pg84o=
Received: from [192.168.8.100] ([85.255.236.54])
        by smtp.gmail.com with ESMTPSA id v16-20020a05600c445000b0040ff7e3170asm534408wmn.2.2024.02.06.19.23.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Feb 2024 19:23:26 -0800 (PST)
Message-ID: <3a328489-0fa7-461e-a904-dff9ccef5471@gmail.com>
Date: Wed, 7 Feb 2024 03:22:17 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] io_uring: expand main struct io_kiocb flags to
 64-bits
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240206162402.643507-1-axboe@kernel.dk>
 <20240206162402.643507-2-axboe@kernel.dk>
 <f4e5bd14-2550-4683-bdc3-7521351f81e1@gmail.com>
 <6f55dbd7-62a3-48d0-bc5a-2ddddb69e9ac@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6f55dbd7-62a3-48d0-bc5a-2ddddb69e9ac@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/7/24 02:18, Jens Axboe wrote:
> On 2/6/24 5:43 PM, Pavel Begunkov wrote:
>> On 2/6/24 16:22, Jens Axboe wrote:
>>> We're out of space here, and none of the flags are easily reclaimable.
>>> Bump it to 64-bits and re-arrange the struct a bit to avoid gaps.
>>>
>>> Add a specific bitwise type for the request flags, io_request_flags_t.
>>> This will help catch violations of casting this value to a smaller type
>>> on 32-bit archs, like unsigned int.
>>>
>>> No functional changes intended in this patch.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
...
>>>      typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
>>> @@ -592,15 +595,14 @@ struct io_kiocb {
>>>         * and after selection it points to the buffer ID itself.
>>>         */
>>>        u16                buf_index;
>>> -    unsigned int            flags;
>>>    -    struct io_cqe            cqe;
>>
>> With the current layout the min number of lines we touch per
>> request is 2 (including the op specific 64B), that's includes
>> setting up cqe at init and using it for completing. Moving cqe
>> down makes it 3.
>>
>>> +    atomic_t            refs;
>>
>> We're pulling it refs, which is not touched at all in the hot
>> path. Even if there's a hole I'd argue it's better to leave it
>> at the end.
>>
>>> +
>>> +    io_req_flags_t            flags;
>>>          struct io_ring_ctx        *ctx;
>>>        struct task_struct        *task;
>>>    -    struct io_rsrc_node        *rsrc_node;
>>
>> It's used in hot paths, registered buffers/files, would be
>> unfortunate to move it to the next line.
> 
> Yep I did feel a bit bad about that one... Let me take another stab at
> it.
> 
>>> -
>>>        union {
>>>            /* store used ubuf, so we can prevent reloading */
>>>            struct io_mapped_ubuf    *imu;
>>> @@ -615,18 +617,23 @@ struct io_kiocb {
>>>            struct io_buffer_list    *buf_list;
>>>        };
>>>    +    /* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
>>> +    struct hlist_node        hash_node;
>>> +
>>
>> And we're pulling hash_node into the hottest line, which is
>> used only when we arm a poll and remove poll. So, it's mostly
>> for networking, sends wouldn't use it much, and multishots
>> wouldn't normally touch it.
>>
>> As for ideas how to find space:
>> 1) iopoll_completed completed can be converted to flags2
> 
> That's a good idea, but won't immediately find any space as it'd just
> leave a hole anyway. But would be good to note in there perhaps, you
> never know when it needs re-arranging again.

struct io_kiocb {
	unsigned flags;
	...
	u8 	 flags2;
};

I rather proposed to have this, which is definitely borderline
ugly but certainly an option.


>> 2) REQ_F_{SINGLE,DOUBLE}_POLL is a weird duplication. Can
>> probably be combined into one flag, or removed at all.
>> Again, sends are usually not so poll heavy and the hot
>> path for recv is multishot.
> 
> Normal receive is also a hot path, even if multishot should be preferred

The degree of hotness is arguable. It's poll, which takes a
spinlock (and disables irqs), does an indirect call, goes into
he socket internals there touching pretty contended parts
like sock_wq. The relative overhead of looking at f_ops should
be nothing.

But the thought was more about combining them,
REQ_F_POLL_ACTIVE, and clear only if it's not double poll.

> in general. Ditto on non-sockets but still pollable files, doing eg read
> for example.
> 
>> 3) we can probably move req->task down and replace it with
>>
>> get_task() {
>>      if (req->ctx->flags & DEFER_TASKRUN)
>>          task = ctx->submitter_task;
>>      else
>>          task = req->task;
>> }
> 
> Assuming ctx flags is hot, which is would generally be, that's not a bad
> idea at all.

As mentioned, task_work_add would be the main user, and
there is already a different branch for DEFER_TASKRUN,
to it implicitly knows that ctx->submitter_task is correct.

> I'll do another loop over this one.

-- 
Pavel Begunkov

