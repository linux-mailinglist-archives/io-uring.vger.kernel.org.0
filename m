Return-Path: <io-uring+bounces-10516-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A64C6C4E504
	for <lists+io-uring@lfdr.de>; Tue, 11 Nov 2025 15:11:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC77F3AB511
	for <lists+io-uring@lfdr.de>; Tue, 11 Nov 2025 14:07:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 240C130E0F6;
	Tue, 11 Nov 2025 14:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fklWz510"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FC529ACF7
	for <io-uring@vger.kernel.org>; Tue, 11 Nov 2025 14:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762870073; cv=none; b=INVyS056sxv+ySJa7Xs/O8G2zskmsmq4KhRevjBBlpHHrAx+5hh3l1ZulYY1app38VQoILXJ4HdOJXJrPLdmdGYaBI78KDiFzQQbX/5YzqC69WOwbigmuy+BG0aJwi1QHrfywNygFrg8RwD07cnBGZ5RFJVJyaZXF1OeaHGYVvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762870073; c=relaxed/simple;
	bh=jIiTkAVeHX/ccT9oaBI+AOc9r46NfhF1GRWGKnU1Uzs=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=FAxhgjOFQ2z082eZSBA+wjHqIRmhQ/wH5NchP5iU3GqO1mQJQ7ENt1IdkknnU3AAZFhN+6gau92Ejvo4p/svdAe8pfrthmPoH6yNuF1QWH/RGobuO344lmNK69pqY1UETW+unCPaVE74HxjU70HSUNUaWeHtt7cLQPiuHjDMrwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fklWz510; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-42b3c965cc4so395243f8f.0
        for <io-uring@vger.kernel.org>; Tue, 11 Nov 2025 06:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762870069; x=1763474869; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KCKVvoLX88nFGrXffFTYvcqX7jyh0wTra/9WwSQ9Y50=;
        b=fklWz510h//+ifH7lIL/+6p5DKcn/I9OQJoWnTvq2WUdg+lYIg2PIhPELW+Q5s4zSa
         EGi1LsAIoivQSrERfbFonN4jhPyFNSF6Tcebxu86vU2apu2Z7tQ9jG2CVwZsv/tpWaf3
         DMJe0mBoGd3dbxx8v+pmYJoA7cEVMe64uiMgcPOeT4QmyLB/CJ7b0DKIJnBRG4FmTvuk
         w5jL3ibGib6KzwvvTbKjjUEd8Z0ttO0Ix5LS3b6pqZlRakW11HllJA4aJgFc6m0Gs/mX
         vo1/EvBAHVQKSvuSlQAu+KEpU5Cj0jsf+0Hvx4p1JRBNByfXHYHutCLqUcDqqmqQ1oUQ
         gBng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762870069; x=1763474869;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KCKVvoLX88nFGrXffFTYvcqX7jyh0wTra/9WwSQ9Y50=;
        b=i5sFW+VsKnxzcW9qU/Xgl/EpPIYm/493VrF6mLx3SybIzEz04PDvQzCzXjlaoDU/tJ
         hKeIb/Oj3cb3lTpQNoONtasppNg58EFNNn1lFUJeLpUxbTU4UruJeAXaSsUjtIR/PuhK
         2qIDFKnYrIO9VNY50T/iWuD0m3j/aSv3GDpP8bhiAxJI4LO/feSMuYrKEEP3u5s3wP8G
         eFVhIevoIlPbu+vbJxZt/xXk3cXKzBYcBsOscH30R8Oo94aF5fmUF3wBmrBmq7ht2WdL
         +6D3JdEKeeJ6mfZQaik6btpCLwKcgXKKLBN+exsYgDgJY4C5xu4klF9cmOJYZKTXa88z
         hfvQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/ocIZ/cIt5WhWonWzoYb1jrJKE/mbYLbOGikXrqEFM4WheUu9ccvXeWVp/NhpIFX84+JjWv+udg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt7PFyNVzO/mrems7ytmk+yfTCSdJ3n3w13nfLy6UQhlUKIxAE
	8oOMsSVEuRfTUtfjnSVoIpAIRtzU3Az2blK1n4gEU9yohkWi/6SN5I7N
X-Gm-Gg: ASbGncscDKefa6bpHI8q4ARAqbHfLGVUHZ+w5ZOYlvtzCkORa5CZvDac1hOYlFLOBQt
	a07fExSGXSt7HP5C0bxrevPSIX9enV0+RX4van+qzHLlnYcMbp3en50u3vQzWwURRNDgzAL56E9
	eqwR2gBJbxzkhcgi29kDok5adoHp2VXnC9dwJuI6qRhhFdtjfp7/SLvsPGvY8ZYAK7ZcE7rAeG4
	Ix5Iy8jFhf/UFrebHmmv6qaXLka2q+xNyDaK63tbn4QhJpgQRr0/hHgH2rwVh6OWHjKbw4bXkX+
	wdUAy83p5dub8tn5/cTlfkSECt6/5gk8mlcGaawwsO5gZaTxmPF3Ch7f32aRY8ocw3vsxPMBYA/
	TmyXEBlHNCxApSY9A4JJMowWzQWVb8HKQuaUjrS5tyvrEcwQiUpAvixMOqrVDEGT7A1pHceec7f
	vfB9VMqkc+zjrXA0zm26MiLTB04jY4o9dAIjhMJZBY8Y4DI2Jin3HbsdXWuxgOXw==
X-Google-Smtp-Source: AGHT+IFESR+bxV13Tl0TP2UREsN6JSVyn887WiEw3ebIMhs3JM+ApYi99gHGhrw09/IIBmoi0SqheA==
X-Received: by 2002:a05:6000:2406:b0:3e7:428f:d33 with SMTP id ffacd0b85a97d-42b432bd192mr3302590f8f.16.1762870069205;
        Tue, 11 Nov 2025 06:07:49 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b29e4b9bdsm24778468f8f.32.2025.11.11.06.07.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 06:07:48 -0800 (PST)
Message-ID: <9b59b165-1f57-4cb6-ae62-403d922ad4da@gmail.com>
Date: Tue, 11 Nov 2025 14:07:47 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 0/5] io_uring: add IORING_OP_BPF for extending io_uring
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 Caleb Sander Mateos <csander@purestorage.com>,
 Akilesh Kailash <akailash@google.com>, bpf@vger.kernel.org,
 Alexei Starovoitov <ast@kernel.org>
References: <20251104162123.1086035-1-ming.lei@redhat.com>
 <891f4413-9556-4f0d-87e2-6b452b08a83f@gmail.com> <aQtz-dw7t7jtqALc@fedora>
 <58c0e697-2f6a-4b06-bf04-c011057cd6c7@gmail.com> <aQ4WTLX9ieL5J7ot@fedora>
Content-Language: en-US
In-Reply-To: <aQ4WTLX9ieL5J7ot@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/7/25 15:54, Ming Lei wrote:
> On Thu, Nov 06, 2025 at 04:03:29PM +0000, Pavel Begunkov wrote:
>> On 11/5/25 15:57, Ming Lei wrote:
>>> On Wed, Nov 05, 2025 at 12:47:58PM +0000, Pavel Begunkov wrote:
>>>> On 11/4/25 16:21, Ming Lei wrote:
>>>>> Hello,
>>>>>
>>>>> Add IORING_OP_BPF for extending io_uring operations, follows typical cases:
>>>>
>>>> BPF requests were tried long time ago and it wasn't great. Performance
>>>
>>> Care to share the link so I can learn from the lesson? Maybe things have
>>> changed now...
>>
>> https://lore.kernel.org/io-uring/a83f147b-ea9d-e693-a2e9-c6ce16659749@gmail.com/T/#m31d0a2ac6e2213f912a200f5e8d88bd74f81406b
>>
>> There were some extra features and testing from folks, but I don't
>> think it was ever posted to the list.
> 
> Thanks for sharing the link:
> 
> ```
> The main problem solved is feeding completion information of other
> requests in a form of CQEs back into BPF. I decided to wire up support
> for multiple completion queues (aka CQs) and give BPF programs access to
> them, so leaving userspace in control over synchronisation that should
> be much more flexible that the link-based approach.
> ```

FWIW, and those extensions were the sign telling that the approach
wasn't flexible enough.

> Looks it is totally different with my patch in motivation and policy.
> 
> I do _not_ want to move application logic into kernel by building SQE from
> kernel prog. With IORING_OP_BPF, the whole io_uring application is
> built & maintained completely in userspace, so I needn't to do cumbersome
> kernel/user communication just for setting up one SQE in prog, not mention
> maintaining SQE's relation with userspace side's.

It's built and maintained in userspace in either case, and in
both cases you have bpf implementing some logic that was previously
done in userspace. To emphasize, you can do the desired parts of
handling in BPF, and I'm not suggesting moving the entirety of
request processing in there.

>>>> for short BPF programs is not great because of io_uring request handling
>>>> overhead. And flexibility was severely lacking, so even simple use cases
>>>
>>> What is the overhead? In this patch, OP's prep() and issue() are defined in
>>
>> The overhead of creating, freeing and executing a request. If you use
>> it with links, it's also overhead of that. That prototype could also
>> optionally wait for completions, and it wasn't free either.
> 
> IORING_OP_BPF is same with existing normal io_uring request and link, wrt
> all above you mentioned.

It is, but it's an extra request, and in previous testing overhead
for that extra request was affecting total performance, that's why
linking or not is also important.

> IORING_OP_BPF's motivation is for being io_uring's supplementary or extention
> in function, not for improving performance.
> 
>>
>>> bpf prog, but in typical use case, the code size is pretty small, and bpf
>>> prog code is supposed to run in fast path.>
>>>> were looking pretty ugly, internally, and for BPF writers as well.
>>>
>>> I am not sure what `simple use cases` you are talking about.
>>
>> As an example, creating a loop reading a file:
>> read N bytes; wait for completion; repeat
> 
> IORING_OP_BPF isn't supposed to implement FS operation in bpf prog.
> 
> It doesn't mean IORING_OP_BPF can't support async issuing:
> 
> - issue_wait() can be added for offload in io-wq context
> 
> OR
> 
> - for typical FS AIO, in theory it can be supported too, just the struct_ops need
> to define one completion callback, and the callback can be called from
> ->ki_complete().

There is more to IO than read/write, and I'm afraid each new type of
operation would need some extra kfunc glue. And even then there is
enough of handling for rw requests in io_uring than just calling the
callback. It's nicer to be able to reuse all io_uring request
handling, which wouldn't even need extra kfuncs.

...
>>> and it can't be used in my case.
>> Hmm, how so? Let's say ublk registers a buffer and posts a
>> completion. Then BPF runs, it sees the completion and does the
>> necessary processing, probably using some kfuncs like the ones
> 
> It is easy to say, how can the BPF prog know the next completion is
> exactly waiting for? You have to rely on bpf map to communicate with userspace

By taking a peek at and maybe dereferencing cqe->user_data.

> to understanding what completion is what you are interested in, also
> need all information from userpace for preparing the SQE for submission
> from bpf prog. Tons of userspace and kernel communication.

You can setup a BPF arena, and all that comm will be working with
a block of shared memory. Or same but via io_uring parameter region.
That sounds pretty simple.

>> you introduced. After it can optionally queue up requests
>> writing it to the storage or anything else.
> 
> Again, I do not want to move userspace logic into bpf prog(kernel), what
> IORING_BPF_OP provides is to define one operation, then userspace
> can use it just like in-kernel operations.

Right, but that's rather limited. I want to cover all those
use cases with one implementation instead of fragmenting users,
if that can be achieved.

> Then existing application can apply IORING_BPF_OP just with little small
> change. If submitting SQE from bpf prog, ublk application need re-write
> for supporting register buffer based zero copy.
> 
>> The reason I'm asking is because it's supposed to be able to
>> do anything the userspace can already achieve (and more). So,
>> if it can't be used for this use cases, there should be some
>> problem in my design.
> 
> BPF prog programming is definitely much more limited compared with
> userspace application because it is safe kernel programming.

-- 
Pavel Begunkov


