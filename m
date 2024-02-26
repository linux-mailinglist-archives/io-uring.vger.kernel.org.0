Return-Path: <io-uring+bounces-736-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E28E88679AC
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 16:12:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E4DD29D8D5
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 15:12:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8F1312DDB6;
	Mon, 26 Feb 2024 14:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mzyul7dW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FCC12E1C9
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 14:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708959400; cv=none; b=iU0cJpsJm8Vt8BkYLSpiGnBiDCV7kTN5NuO0QurBnJ8Hn+P3aNhHWpADpcbid1InKe/DC72Xc647erw3DfTLa5HmAWF7MRCBabXbYXgb9JBEStBGn2FZyhwJ4qtkBrbnSc5TNLnmOuL0/kSVGQhVr3raTA402HrsKkNzYptnSkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708959400; c=relaxed/simple;
	bh=jewomiu6X8yCMlrBXVCRIHfF+VgawT+owtV+CgI8/LY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qpoEjHtjn2CbIM7/9mdDkXrzQg4WXjQhjqNQAeyN0t8GZd1fx5XeLzID6QNf31Q+8bgQnKmp/wBl4Npv1Qkh5ufB8ZxZBrqLphE4daxTOFj3TLnuxN6LzufCYKi3lQWFGvMoAP5dcGJ+wJP+2aoZVO+u5n9t1+FSLKPHazDcybM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mzyul7dW; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a3d484a58f6so442245366b.3
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 06:56:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708959397; x=1709564197; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mmmw7Gw2bfYt6rF9JXJh64hRtWK3F5WXw05ZmfSED8U=;
        b=Mzyul7dWhivrZfLxhrpQ1lGItLf460wMI5iLvBxiziAZ6vA3KOSY0aZ2nEzaUHbUhG
         b1/phm1a39Ej0DTl1avG+p6YP94RbbGLKhpEqKUuPMQksgWsBASbRv2wmL4TKikF7Gvl
         lb5vtMSpcZLGfyzU1I/1N+F4Rc2/3QWjD2UGIRcMFayPe8K3V4HldIMNESJXmanwELHK
         sN3J+CqiNxFPGNC0/gUiqhYZbDP+gLG3aGcSjjlVCoWCAlKP7rhpZHcO3xWh9HysWdSu
         Bmvxs73zkYVY5b9KA5Mzu5cft2zt1GGOqYLmwas2oXK+gLaWIF6zUzGXomyjpUX8XLhb
         VtbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708959397; x=1709564197;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mmmw7Gw2bfYt6rF9JXJh64hRtWK3F5WXw05ZmfSED8U=;
        b=CQ5Q1QYzgEt/BAfn8ATx/0fDFpwZCo2k4CCnbopOA6x+bmIbj1/HW2XkUvxDZODtmt
         CgZgbbJp0wZaVo78byot9WTBQOsh0CWdZsUryAlX/glu/16rL71+HnUt5hi85tBSmTa4
         TjGdT+rqHHheNs9dzY6cbELz0SXH05K1F9MNoUF+jm9je5rv90vzzhCM942pQncqjiII
         ZaxfJGYlN+AuGG8//rhVQ+5iYTgsS0IoJNK7dj9bUlaCad/gDfF6NXNjUhqf1A9csN7v
         oHMlsBYFD+BaZomIO0rhrjQtPf7SiZsPsxpYs6WwyAgfBi38WkWG353BYt4dKInjRXQr
         CPtQ==
X-Gm-Message-State: AOJu0YzmQa7MCrf7Gd8wixTIZ74UQpvOxwL0Hj+Wld35Zd4p2wPiFdPC
	ISU+reowv9UQL32lKEjzb8f5YJ5dN3hjYOphebjdq13jQ2QinCvV
X-Google-Smtp-Source: AGHT+IEvTnoWAFDEsM1hS06m1JGPdn9paOEC2HKNwFvfoWLlDgqwyzpnAHBmGR8XC+ENtJlVYVaDxA==
X-Received: by 2002:a17:906:d20e:b0:a3f:9f38:ded with SMTP id w14-20020a170906d20e00b00a3f9f380dedmr4116540ejz.69.1708959396435;
        Mon, 26 Feb 2024 06:56:36 -0800 (PST)
Received: from [192.168.8.100] ([85.255.235.18])
        by smtp.gmail.com with ESMTPSA id l19-20020a1709060e1300b00a3e86a9c55asm2510895eji.146.2024.02.26.06.56.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:56:36 -0800 (PST)
Message-ID: <f0046836-ef9d-4b58-bfae-f2bf087233e1@gmail.com>
Date: Mon, 26 Feb 2024 14:36:42 +0000
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
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ecd796a4-e413-47d3-91c1-015b5c211ee2@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/24 14:27, Jens Axboe wrote:
> On 2/26/24 7:02 AM, Dylan Yudaken wrote:
>> On Mon, Feb 26, 2024 at 1:38?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> On 2/26/24 3:47 AM, Dylan Yudaken wrote:
>>>> On Sun, Feb 25, 2024 at 12:46?AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> This works very much like the receive side, except for sends. The idea
>>>>> is that an application can fill outgoing buffers in a provided buffer
>>>>> group, and then arm a single send that will service them all. For now
>>>>> this variant just terminates when we are out of buffers to send, and
>>>>> hence the application needs to re-arm it if IORING_CQE_F_MORE isn't
>>>>> set, as per usual for multishot requests.
>>>>>
>>>>
>>>> This feels to me a lot like just using OP_SEND with MSG_WAITALL as
>>>> described, unless I'm missing something?
>>>
>>> How so? MSG_WAITALL is "send X amount of data, and if it's a short send,
>>> try again" where multishot is "send data from this buffer group, and
>>> keep sending data until it's empty". Hence it's the mirror of multishot
>>> on the receive side. Unless I'm misunderstanding you somehow, not sure
>>> it'd be smart to add special meaning to MSG_WAITALL with provided
>>> buffers.
>>>
>>
>> _If_ you have the data upfront these are very similar, and only differ
>> in that the multishot approach will give you more granular progress
>> updates. My point was that this might not be a valuable API to people
>> for only this use case.
> 
> Not sure I agree, it feels like attributing a different meaning to
> MSG_WAITALL if you use a provided buffer vs if you don't. And that to me
> would seem to be confusing. Particularly when we have multishot on the
> receive side, and this is identical, just for sends. Receives will keep
> receiving as long as there are buffers in the provided group to receive
> into, and sends will keep sending for the same condition. Either one
> will terminate if we run out of buffers.
> 
> If you make MSG_WAITALL be that for provided buffers + send, then that
> behaves differently than MSG_WAITALL with receive, and MSG_WAITALL with
> send _without_ provided buffers. I don't think overloading an existing
> flag for this purposes is a good idea, particularly when we already have
> the existing semantics for multishot on the receive side.

I'm actually with Dylan on that and wonder where the perf win
could come from. Let's assume TCP, sends are usually completed
in the same syscall, otherwise your pacing is just bad. Thrift,
for example, collects sends and packs into one multi iov request
during a loop iteration. If the req completes immediately then
the userspace just wouldn't have time to push more buffers by
definition (assuming single threading).

If you actually need to poll tx, you send a request and collect
data into iov in userspace in background. When the request
completes you send all that in batch. You can probably find
a niche example when batch=1 in this case, but I don't think
anyone would care.

The example doesn't use multi-iov, and also still has to
serialise requests, which naturally serialises buffer consumption
w/o provided bufs.

>> You do make a good point about MSG_WAITALL though - multishot send
>> doesn't really make sense to me without MSG_WAITALL semantics. I
>> cannot imagine a useful use case where the first buffer being
>> partially sent will still want the second buffer sent.
> 
> Right, and I need to tweak that. Maybe we require MSG_WAITALL, or we
> make it implied for multishot send. Currently the code doesn't deal with
> that.
> 
> Maybe if MSG_WAITALL isn't set and we get a short send we don't set
> CQE_F_MORE and we just stop. If it is set, then we go through the usual
> retry logic. That would make it identical to MSG_WAITALL send without
> multishot, which again is something I like in that we don't have
> different behaviors depending on which mode we are using.
> 
>>>> I actually could imagine it being useful for the previous patches' use
>>>> case of queuing up sends and keeping ordering,
>>>> and I think the API is more obvious (rather than the second CQE
>>>> sending the first CQE's data). So maybe it's worth only
>>>> keeping one approach?
>>>
>>> And here you totally lost me :-)
>>
>> I am suggesting here that you don't really need to support buffer
>> lists on send without multishot.
> 
> That is certainly true, but I also don't see a reason _not_ to support
> it. Again mostly because this is how receive and everything else works.
> The app is free to issue a single SQE for send without multishot, and
> pick the first buffer and send it.

Multishot sound interesting, but I don't see it much useful if
you terminate when there are no buffers. Otherwise, if it continues
to sit in, someone would have to wake it up

>> It's a slightly confusing API (to me) that you queue PushBuffer(A),
>> Send(A), PushBuffer(B), Send(B)
>> and get back Res(B), Res(A) which are in fact in order A->B.
> 
> Now I'm confused again. If you do do the above sequence, the first CQE
> posted would be Res(A), and then Res(B)?
> 
>> Instead you could queue up PushBuffer(A), Send(Multishot),
>> PushBuffer(B), and get back Res(Multishot), Res(Multishot)
>> which are in order A -> B.
> 
> There should be no difference in ordering of the posted completion
> between the two.
> 

-- 
Pavel Begunkov

