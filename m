Return-Path: <io-uring+bounces-742-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B815867B04
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 17:01:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A64B029137A
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 16:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E09A712C522;
	Mon, 26 Feb 2024 16:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XLXU59Aw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC97112CD93
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 16:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708963288; cv=none; b=F+BACg87+eQrH1o8HTLSRBknKtyhM80m1eYzSfzuQ/LDWEOebL1IJwSnwRJJo75Zo/7gf0QKfhiXrck4E/3JyR6ecRwFg2U35+CUVMEHPH/fNU3JN6ZZYWhYJXlMv4ZRX/uZxdRMcsuAy5BuMH01G3F2Af9LgFVny+Sta7XMfeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708963288; c=relaxed/simple;
	bh=CG6GpmkYwFQyWwX8c9FO3D4AAKxNwjrKnC2XvXXnKyU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ltRinBIrn/ZBQgVxV7lnNTqGArDREkTL9hXlLbSl3acTXBqJnFZfHGJK5OwasNy/IosoHDrktxVyHMGtI0Yuv8CsugUNhJpXLAHddbn+Pmt9SKB3kv7eOUlLvg51d9PckKayZF9ZY1TUHS/rfpFsizXZrbN1Omfz/QB8Doj9sJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XLXU59Aw; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5658082d2c4so4093681a12.1
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 08:01:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708963285; x=1709568085; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0d/qsOjbzkytdml2PGuFs9QDolHH7SGqnW0SyaSmUag=;
        b=XLXU59AwxlmjAJHuNrB0HQtNmORmmWrxVpD9myqEhpdVFDyZluWSlUA7v3s2d761xo
         UKuLX+Xw+nLacfN/6uMDZpdEG+2YzQRI/eJlZtTAq37fsokc/yk+oepKIwaO39uR1OwX
         6QmHq2KW6TiLFwRGJqWL4Y0h7dTtTOvrsrsYsa7JOSOw6UM6mbWq6LMb9+giFK/8MxGq
         Gxm0Fe+JQNLpUlk1mRsk6xw+E2jBcMU0Nm+XCWnX2fJe4VPP4A/vvQIxZtTLm414upa9
         qghEfV2CLnCuKVuaAUA38xcpDRVU6UTm2xQkMDh7yaszMFder/gN9BbuV6Bk6kZr1CKw
         KLbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708963285; x=1709568085;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0d/qsOjbzkytdml2PGuFs9QDolHH7SGqnW0SyaSmUag=;
        b=cshaJMbkNSskn8kZ30avhBa1mI8rPUHlpzB4RteQIdM5veYNIPqgom26U+kzUNHFQj
         e498uumP3MxsBR2r6yqHSHfTEM8k16xLGSzd6EMGpdST/+n0f5rffX4GGGZScxEqpdTd
         Dp+GdisagL72G5zDpgcIr5p2ZqxVsAoaEKd8MdjBYNTdj+ke/JlnYVnn3tVm/RB56xp1
         EssOcAQfiTPZ0ALy2ztS68P1wlQOXcbdNglDy4ggMakcaW6p7/kBPZEjpcHnu0wQZCtS
         8RKv5fZcH3mOITKhXHJyZZaJlr4SfL+Z+EGd9VRL9xZHJ9dtRvIXNa2drrcx9f2QCkBn
         9Gww==
X-Gm-Message-State: AOJu0YzV4HEubjJYz/sbYt+OFMJIbDHrksrPGQU80DZ/N8Y3sVSctDIS
	s9SRtGhf1jCD7/Z7mMdyrq1763kPtvubZAYbCt5kIhKHvaBLG3gTMC9D5eib
X-Google-Smtp-Source: AGHT+IG6BUBXqQhQM1nvt7DUytLL2SlJ4TYJFxw5vz6Sf1BtnDhpDIvkGgKleIxburF9yZbrG8H9QQ==
X-Received: by 2002:aa7:d958:0:b0:564:f6d5:f291 with SMTP id l24-20020aa7d958000000b00564f6d5f291mr5292308eds.34.1708963284716;
        Mon, 26 Feb 2024 08:01:24 -0800 (PST)
Received: from [192.168.8.100] ([85.255.235.18])
        by smtp.gmail.com with ESMTPSA id b1-20020aa7dc01000000b00565e33da344sm1338072edu.68.2024.02.26.08.01.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 08:01:24 -0800 (PST)
Message-ID: <a0f62e25-f19c-44b7-bf26-4460ae01de7f@gmail.com>
Date: Mon, 26 Feb 2024 15:41:24 +0000
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
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <454ef0d2-066f-4bdf-af42-52fd0c57bd56@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/24 15:16, Jens Axboe wrote:
> On 2/26/24 7:36 AM, Pavel Begunkov wrote:
>> On 2/26/24 14:27, Jens Axboe wrote:
>>> On 2/26/24 7:02 AM, Dylan Yudaken wrote:
>>>> On Mon, Feb 26, 2024 at 1:38?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> On 2/26/24 3:47 AM, Dylan Yudaken wrote:
>>>>>> On Sun, Feb 25, 2024 at 12:46?AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>
>>>>>>> This works very much like the receive side, except for sends. The idea
>>>>>>> is that an application can fill outgoing buffers in a provided buffer
>>>>>>> group, and then arm a single send that will service them all. For now
>>>>>>> this variant just terminates when we are out of buffers to send, and
>>>>>>> hence the application needs to re-arm it if IORING_CQE_F_MORE isn't
>>>>>>> set, as per usual for multishot requests.
>>>>>>>
>>>>>>
>>>>>> This feels to me a lot like just using OP_SEND with MSG_WAITALL as
>>>>>> described, unless I'm missing something?
>>>>>
>>>>> How so? MSG_WAITALL is "send X amount of data, and if it's a short send,
>>>>> try again" where multishot is "send data from this buffer group, and
>>>>> keep sending data until it's empty". Hence it's the mirror of multishot
>>>>> on the receive side. Unless I'm misunderstanding you somehow, not sure
>>>>> it'd be smart to add special meaning to MSG_WAITALL with provided
>>>>> buffers.
>>>>>
>>>>
>>>> _If_ you have the data upfront these are very similar, and only differ
>>>> in that the multishot approach will give you more granular progress
>>>> updates. My point was that this might not be a valuable API to people
>>>> for only this use case.
>>>
>>> Not sure I agree, it feels like attributing a different meaning to
>>> MSG_WAITALL if you use a provided buffer vs if you don't. And that to me
>>> would seem to be confusing. Particularly when we have multishot on the
>>> receive side, and this is identical, just for sends. Receives will keep
>>> receiving as long as there are buffers in the provided group to receive
>>> into, and sends will keep sending for the same condition. Either one
>>> will terminate if we run out of buffers.
>>>
>>> If you make MSG_WAITALL be that for provided buffers + send, then that
>>> behaves differently than MSG_WAITALL with receive, and MSG_WAITALL with
>>> send _without_ provided buffers. I don't think overloading an existing
>>> flag for this purposes is a good idea, particularly when we already have
>>> the existing semantics for multishot on the receive side.
>>
>> I'm actually with Dylan on that and wonder where the perf win
>> could come from. Let's assume TCP, sends are usually completed
>> in the same syscall, otherwise your pacing is just bad. Thrift,
>> for example, collects sends and packs into one multi iov request
>> during a loop iteration. If the req completes immediately then
>> the userspace just wouldn't have time to push more buffers by
>> definition (assuming single threading).
> 
> The problem only occurs when they don't complete inline, and now you get
> reordering. The application could of course attempt to do proper pacing
> and see if it can avoid that condition. If not, it now needs to

Ok, I admit that there are more than valid cases when artificial pacing
is not an option, which is why I also laid out the polling case.
Let's also say that limits potential perf wins to streaming and very
large transfers (like files), not "lots of relatively small
request-response" kinds of apps.

> serialize sends. Using provided buffers makes this very easy, as you
> don't need to care about it at all, and it eliminates complexity in the
> application dealing with this.

If I'm correct the example also serialises sends(?). I don't
think it's that simpler. You batch, you send. Same with this,
but batch into a provided buffer and the send is conditional.

Another downside is that you need a provided queue per socket,
which sounds pretty expensive for 100s if not 1000s socket
apps.

>> If you actually need to poll tx, you send a request and collect
>> data into iov in userspace in background. When the request
>> completes you send all that in batch. You can probably find
>> a niche example when batch=1 in this case, but I don't think
>> anyone would care.
>>
>> The example doesn't use multi-iov, and also still has to
>> serialise requests, which naturally serialises buffer consumption
>> w/o provided bufs.
> 
> IMHO there's no reason NOT to have both a send with provided buffers and
> a multishot send. The alternative would be to have send-N, where you
> pass in N. But I don't see much point to that over "just drain the whole
> pending list". The obvious use case is definitely send multishot, but

Not sure I follow, but in all cases I was contemplating about
you sends everything you have at the moment.

> what would the reasoning be to prohibit pacing by explicitly disallowing
> only doing a single buffer (or a partial queue)? As mentioned earlier, I
> like keeping the symmetry with the receive side for multishot, and not
> make it any different unless there's a reason to.

There are different, buffer content kernel (rx) vs userspace (tx)
provided, provided queue / group per socket vs shared. Wake ups
for multishots as per below. It's not like it's a one line change,
so IMHO requires to be giving some benefits.

>>>> You do make a good point about MSG_WAITALL though - multishot send
>>>> doesn't really make sense to me without MSG_WAITALL semantics. I
>>>> cannot imagine a useful use case where the first buffer being
>>>> partially sent will still want the second buffer sent.
>>>
>>> Right, and I need to tweak that. Maybe we require MSG_WAITALL, or we
>>> make it implied for multishot send. Currently the code doesn't deal with
>>> that.
>>>
>>> Maybe if MSG_WAITALL isn't set and we get a short send we don't set
>>> CQE_F_MORE and we just stop. If it is set, then we go through the usual
>>> retry logic. That would make it identical to MSG_WAITALL send without
>>> multishot, which again is something I like in that we don't have
>>> different behaviors depending on which mode we are using.
>>>
>>>>>> I actually could imagine it being useful for the previous patches' use
>>>>>> case of queuing up sends and keeping ordering,
>>>>>> and I think the API is more obvious (rather than the second CQE
>>>>>> sending the first CQE's data). So maybe it's worth only
>>>>>> keeping one approach?
>>>>>
>>>>> And here you totally lost me :-)
>>>>
>>>> I am suggesting here that you don't really need to support buffer
>>>> lists on send without multishot.
>>>
>>> That is certainly true, but I also don't see a reason _not_ to support
>>> it. Again mostly because this is how receive and everything else works.
>>> The app is free to issue a single SQE for send without multishot, and
>>> pick the first buffer and send it.
>>
>> Multishot sound interesting, but I don't see it much useful if
>> you terminate when there are no buffers. Otherwise, if it continues
>> to sit in, someone would have to wake it up
> 
> I did think about the termination case, and the problem is that if there
> are no buffers, you need it to wake when there are buffers. And at that
> point you may as well just do another send, as you need the application
> to trigger it. The alternative would be to invent a way to trigger that
> wakeup, which would be send only and weird just because of that.

Yeah, that's the point, wake ups would be userspace driven, and how
to do it without heavy stuff like syscalls is not so clear.

> If you end up poll armed because the socket buffer is full, then it
> certainly makes sense to stay armed as there's a natural trigger there
> when that condition resolves.

-- 
Pavel Begunkov

