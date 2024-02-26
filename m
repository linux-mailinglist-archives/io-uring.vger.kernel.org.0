Return-Path: <io-uring+bounces-770-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EA22868274
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 22:11:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F2CAB22B73
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 21:11:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AA1F12F5A5;
	Mon, 26 Feb 2024 21:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XiOtIpgx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7925D7F7EC
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 21:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708981911; cv=none; b=JMJ4R8WJEUWYJfJ6zcS5IEpWukc900CsmehRvyG8C41oDLMF0t9cge3p/mbtWE/yISBIe0KNUTS4XYC9oefXcswseHWdehVSvQzRssqR3ZmvZqgFgzOshxQvsMG4ySu56Eh6mUPVs2KQZ8o92pdsB7TOCw68ATqfV16hyuVwaU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708981911; c=relaxed/simple;
	bh=O0Dp7m5PLRmLT0Croq5DyIwMLZpBCIt7iuXCefYev1o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sUzn/uq8j5OCAYz/dCpTUXjxm+b/158RoueC9W9JurtjxwKAg0GycXjGsev+k8r25gYz1coFRb3ml/P3WsfSsrLRW7+RYBqF9yy+MU7LpJDGBZ4WNCnH7SZhdPSOqrUeoSLzf4E2X3zUmv0SBuvwXk6yNTl1Wuim32Hr4oc8csQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XiOtIpgx; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-412a3901eaaso12268625e9.0
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 13:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708981908; x=1709586708; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iuxDL2+N3/Tm24DMqXBZ+62xDnwhoF0yKfgzza763sQ=;
        b=XiOtIpgx0qfEj598nAmbUL5asjl0a7KpyYxGBMCm5Q6qvjqbnfZLdPDQTvVLS7y3S7
         omLg027R6tnsdCo1rVDefTvR60Afe5D3LPwN/hU2d7KvwjWtjhqlEm6TCo7cuDWPF9Tx
         sAdsi6/DJaHvmxAWLg8BD5Vj2z8ZqjZZ44MmMn5lgGmY3lSwsapvfwc981Mp9DMPnTmE
         42szf9N8Qlg+FxN5ZlgzsWKzoHeksxf/gi3qOUqLjdFgnJAek8j1xDrzQgYpk0muvxUV
         eY3NfKlY00EpkiQXyAuTRZrGcuNfxGoHCnfK8nxYPNoJqhSA9QiQfDtWZscig7FRk+Yb
         uCVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708981908; x=1709586708;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iuxDL2+N3/Tm24DMqXBZ+62xDnwhoF0yKfgzza763sQ=;
        b=l+92Befa6Jr0bEw8o9mhvpS2KoBhmKNlUQXlqOkAybBL86e4pBpk2gWtDpyAIxHfHR
         IMJJZcZI9F7N9ROuG2QME+VAzQV6bohLeje83O90QrWr0KhUvLoaoB3B4W7lHhFijbjC
         k2zvWMBACy3+EKUnzWAlddiFtsnlzGHIO5s5zmcTYEJ5XfPBoYDS8wZBJkNZrHgor05R
         Q1KCnwoDAjkFQvO59GLnD9lhOFVG/zKhIBlXtzpM5oesFBYI9PNugsNbY9V++mz/Xzce
         uTYhHFw7rEYa8qfqDkJVFLpVnXIp1oKkBHFdHJfiM1kRKnl66FV+5YYujhPjQUPgdBJJ
         ei7A==
X-Gm-Message-State: AOJu0YxnfqCLvDo7E7GjPceQIHaXewFFsQqDoVrYDOMgU3PIrD6Gf1T0
	398nIU4f1qJZrFuNMHwzftkiFB7STz5PtysCVekRJ6Kv7YkrtZ9j
X-Google-Smtp-Source: AGHT+IF8CJ1YuHOpJ7E/Cn872LEUmLXGldCAzIN41eaH0L4eoDFicE9itcLY+nt7hIKnwA0a5QqIzg==
X-Received: by 2002:a05:600c:35cb:b0:412:a1c1:207c with SMTP id r11-20020a05600c35cb00b00412a1c1207cmr3312138wmq.3.1708981907556;
        Mon, 26 Feb 2024 13:11:47 -0800 (PST)
Received: from [192.168.8.100] ([185.69.144.12])
        by smtp.gmail.com with ESMTPSA id n12-20020a05600c294c00b004101f27737asm12896084wmd.29.2024.02.26.13.11.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 13:11:47 -0800 (PST)
Message-ID: <0d440ebb-206e-4315-a7c4-84edc73e8082@gmail.com>
Date: Mon, 26 Feb 2024 20:51:15 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/8] io_uring/net: support multishot for send
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dyudaken@gmail.com>
Cc: io-uring@vger.kernel.org
References: <20240225003941.129030-1-axboe@kernel.dk>
 <20240225003941.129030-7-axboe@kernel.dk>
 <CAO_YeojZHSnx471+HKKFgRo-yy5cv=OmEg_Ri48vMUOwegvOqg@mail.gmail.com>
 <63859888-5602-41fb-9a42-4edc6132766f@kernel.dk>
 <CAO_YeoiTpPALaeiQiCjoW1VSr6PMPDUrH5xT3dTD19=OK1ytPg@mail.gmail.com>
 <ecd796a4-e413-47d3-91c1-015b5c211ee2@kernel.dk>
 <f0046836-ef9d-4b58-bfae-f2bf087233e1@gmail.com>
 <454ef0d2-066f-4bdf-af42-52fd0c57bd56@kernel.dk>
 <a0f62e25-f19c-44b7-bf26-4460ae01de7f@gmail.com>
 <4823c201-8c5d-4a4f-a77e-bd3e6c239cbe@kernel.dk>
 <68adc174-802a-455d-b6ca-a6908e592689@gmail.com>
 <302bf59a-40e1-413a-862d-9b99c8793061@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <302bf59a-40e1-413a-862d-9b99c8793061@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/24 20:12, Jens Axboe wrote:
> On 2/26/24 12:21 PM, Pavel Begunkov wrote:
>> On 2/26/24 19:11, Jens Axboe wrote:
>>> On 2/26/24 8:41 AM, Pavel Begunkov wrote:
>>>> On 2/26/24 15:16, Jens Axboe wrote:
>>>>> On 2/26/24 7:36 AM, Pavel Begunkov wrote:
>>>>>> On 2/26/24 14:27, Jens Axboe wrote:
>>>>>>> On 2/26/24 7:02 AM, Dylan Yudaken wrote:
>>>>>>>> On Mon, Feb 26, 2024 at 1:38?PM Jens Axboe
...
>>> I don't think that's true - if you're doing large streaming, you're
>>> more likely to keep the socket buffer full, whereas for smallish
>>> sends, it's less likely to be full. Testing with the silly proxy
>>> confirms that. And
>>
>> I don't see any contradiction to what I said. With streaming/large
>> sends it's more likely to be polled. For small sends and
>> send-receive-send-... patterns the sock queue is unlikely to be full,
>> in which case the send is processed inline, and so the feature
>> doesn't add performance, as you agreed a couple email before.
> 
> Gotcha, I guess I misread you, we agree that the poll side is more
> likely on bigger buffers.
> 
>>> outside of cases where pacing just isn't feasible, it's extra
>>> overhead for cases where you potentially could or what.
>>
>> I lost it, what overhead?
> 
> Overhead of needing to serialize the sends in the application, which may
> include both extra memory needed and overhead in dealing with it.

I think I misread the code. Does it push 1 request for each
send buffer / queue_send() in case of provided bufs?

Anyway, the overhead of serialisation would be negligent.
And that's same extra memory you keep for the provided buffer
pool, and you can allocate it once. Also consider that provided
buffers are fixed size and it'd be hard to resize without waiting,
thus the userspace would still need to have another, userspace
backlog, it can't just drop requests. Or you make provided queues
extra large, but it's per socket and you'd wasting lots of memory.

IOW, I don't think this overhead could anyhow close us to
the understanding of the 30%+ perf gap.
  
>>> To me, the main appeal of this is the simplicity.
>>
>> I'd argue it doesn't seem any simpler than the alternative.
> 
> It's certainly simpler for an application to do "add buffer to queue"
> and not need to worry about managing sends, than it is to manage a
> backlog of only having a single send active.

They still need to manage / re-queue sends. And maybe I
misunderstand the point, but it's only one request inflight
per socket in either case.
  

>>>>> serialize sends. Using provided buffers makes this very easy,
>>>>> as you don't need to care about it at all, and it eliminates
>>>>> complexity in the application dealing with this.
>>>>
>>>> If I'm correct the example also serialises sends(?). I don't
>>>> think it's that simpler. You batch, you send. Same with this, but
>>>> batch into a provided buffer and the send is conditional.
>>>
>>> Do you mean the proxy example? Just want to be sure we're talking
>>> about
>>
>> Yes, proxy, the one you referenced in the CV. And FWIW, I don't think
>> it's a fair comparison without batching followed by multi-iov.
> 
> It's not about vectored vs non-vectored IO, though you could of course
> need to allocate an arbitrarily sized iovec that you can append to. And
> now you need to use sendmsg rather than just send, which has further
> overhead on top of send.

That's not nearly enough of overhead to explain the difference,
I don't believe so, going through the net stack is quite expensive.

> What kind of batching? The batching done by the tests are the same,
> regardless of whether or not send multishot is used in the sense that we

You can say that, but I say that it moves into the kernel
batching that can be implemented in userspace.

> wait on the same number of completions. As it's a basic proxy kind of
> thing, it'll receive a packet and send a packet. Submission batching is
> the same too, we'll submit when we have to.

"If you actually need to poll tx, you send a request and collect
data into iov in userspace in background. When the request
completes you send all that in batch..."

That's how it's in Thrift for example.

In terms of "proxy", the first approximation would be to
do sth like defer_send() for normal requests as well, then

static void __queue_send(struct io_uring *ring, struct conn *c, int fd,
			 void *data, int bid, int len)
{
	...

	defer_send(data);

	while (buf = defer_backlog.get()) {
		iov[idx++] = buf;
	}
	msghdr->iovlen = idx;
	...
}

>>> the same thing. Yes it has to serialize sends, because otherwise we
>>> can run into the condition described in the patch that adds
>>> provided buffer support for send. But I did bench multishot
>>> separately from there, here's some of it:
>>>
>>> 10G network, 3 hosts, 1 acting as a mirror proxy shuffling N-byte
>>> packets. Send ring and send multishot not used:
>>>
>>> Pkt sz | Send ring | mshot |  usec  |  QPS  |  Bw
>>> ===================================================== 1000   |
>>> No       |  No   |   437  | 1.22M | 9598M 32     |    No       |
>>> No   |  5856  | 2.87M |  734M
>>>
>>> Same test, now turn on send ring:
>>>
>>> Pkt sz | Send ring | mshot |  usec  |  QPS  |  Bw   | Diff
>>> =========================================================== 1000
>>> |    Yes       |  No   |   436  | 1.23M | 9620M | + 0.2% 32     |
>>> Yes       |  No   |  3462  | 4.85M | 1237M | +68.5%
>>>
>>> Same test, now turn on send mshot as well:
>>>
>>> Pkt sz | Send ring | mshot |  usec  |  QPS  |  Bw   | Diff
>>> =========================================================== 1000
>>> |    Yes       |  Yes  |   436  | 1.23M | 9620M | + 0.2% 32     |
>>> Yes       |  Yes  |  3125  | 5.37M | 1374M | +87.2%
>>>
>>> which does show that there's another win on top for just queueing
>>> these sends and doing a single send to handle them, rather than
>>> needing to prepare a send for each buffer. Part of that may be that
>>> you simply run out of SQEs and then have to submit regardless of
>>> where you are at.
>>
>> How many sockets did you test with? It's 1 SQE per sock max
> 
> The above is just one, but I've run it with a lot more sockets. Nothing
> ilke thousands, but 64-128.
> 
>> +87% sounds like a huge difference, and I don't understand where it
>> comes from, hence the question
> 
> There are several things:
> 
> 1) Fact is that the app has to serialize sends for the unlikely case
>     of sends being reordered because of the condition outlined in the
>     patch that enables provided buffer support for send. This is the
>     largest win, particularly with smaller packets, as it ruins the
>     send pipeline.

Do those small packets force it to poll?

> 2) We're posting fewer SQEs. That's the multishot win. Obivously not
>     as large, but it does help.
> 
> People have asked in the past on how to serialize sends, and I've had to
> tell them that it isn't really possible. The only option we had was
> using drain or links, which aren't ideal nor very flexible. Using
> provided buffers finally gives the application a way to do that without
> needing to do anything really. Does every application need it? Certainly
> not, but for the ones that do, I do think it provides a great
> alternative that's better performing than doing single sends at the
> time.

As per note on additional userspace backlog, any real generic app
and especially libs would need to do more to support it.

-- 
Pavel Begunkov

