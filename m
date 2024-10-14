Return-Path: <io-uring+bounces-3672-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4769F99D6AA
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 20:40:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68A5C1C22D18
	for <lists+io-uring@lfdr.de>; Mon, 14 Oct 2024 18:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D26931C3054;
	Mon, 14 Oct 2024 18:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GPN/DQ1Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C09231C95;
	Mon, 14 Oct 2024 18:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728931217; cv=none; b=LSSAzvuIIjFd25ngyqgrqUB1OpeA0QfK1pkZdB2cI8CLySPlU+RBdQu1RspgtF7NGnP1kXg1bzB1M49PGPn1nYcCGGkIHWm2JvtPPxbNOgp7kjZao1bEbwAtRT56URJZF93PyXiIayTDbbSrTmGSiusjcnnvbKJujxUag9ZlSXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728931217; c=relaxed/simple;
	bh=XkG72tUSpUhp3aHCBem5/2QNbOxFmMokJDz3cMwues8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=beCX8YRLQmtnxi+vVNC3DToPTVm5jc7ojRaNt6KCPVUSrjLaFM+o8O9owcbGFTNA1qE6lxHB9BvR00yX+JBVy4RJuq3MVv/WsQdkcZ+BTZYQnn/UU/EdGDWTY/2oMko5YqmU6kNpAL1cviGzKkvu9Zrdf5R7zOclln8WviatynA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GPN/DQ1Y; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4311420b63fso34709185e9.2;
        Mon, 14 Oct 2024 11:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728931214; x=1729536014; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qn1Xl6AIZqnPGo4TWnIcBKCPpdkKQG+Rsmtodw7xETU=;
        b=GPN/DQ1YTe/5/yN3tgyOJsm7wSTD+I4d4i/DSa7CXt9tpphC84ECyYvHXPL9trNkp1
         vhcnvoal1OtUvgfm2aJKHIvNYfFTWWygOMbEeNznirlCTKhXpYl8klxo/yZKHZayiofc
         rWnLRmDTHHidnNYjchuUCltoSRxjvIqjmB45q5up8Lfb3nPBWZ+rQwH1ll2mv6XlMtwn
         j6lF9YqGpIwfsoOVuByRRo0/GUyRV+alWe46FyrGvnE9xLDG7p9gLvxzQg1ZtMEseu/f
         dcORlo8qS7WvJkPKiSKkq3OthuPWUr+8zRuEPcbEMIHBXBROgjfSQPYnnRpsL4fHC/Nm
         9AZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728931214; x=1729536014;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qn1Xl6AIZqnPGo4TWnIcBKCPpdkKQG+Rsmtodw7xETU=;
        b=roMXGOozvjQl5xaiZk34WA5bFOCO6P7w7lA2YGmuWmPuY23ngmvGJzp1Op7BSiDOGF
         DT5AGywuQascdXbzeKz06RVKyqArPqpUFXMtjuLH9aoYI8KaAfbvh+qWMAxLb2kVDe87
         8nNZYvnQnYsDFPTPPureLhIy4BraLjc/Em01vu1k+KAX1kffFYbJ9fpQVAEgV6sOo984
         GZUv6Xjcr156jEk6hhkOEAHjtwI8sgXxxu/r08VxQMQTPl9GVK4Ozbdk1UCpLV/JvZOm
         YXqe7NpolD1xb/HBqwUYpVe7t3UJrAcTylMXjh31TFTk3h/iV/oHQX1lEOwN4BsUEZ6w
         v3Tw==
X-Forwarded-Encrypted: i=1; AJvYcCX6WIiEWpEolh+MaaHdhjSsDyirufkaplVBInwfwMwhSboNsSDmL0k/LzfLrEY/MN05L+xzXiQVBfj+yw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwbTgGWjcT3dWVAR369NBuvxuwFQsVeTcwViDi7o7SGnr+D1RE2
	G3k5ZREhbqT7kqQ2YKCvKUvoGnrcsQ5MQClZCTF0v7uky5CO/Y8b
X-Google-Smtp-Source: AGHT+IG9ESckIDKPtn9QHbC6qIACZZAO+R+g0utfEpDhtLA3I5r8hFoeGnNCtW2jB8qcQZK4wyydFA==
X-Received: by 2002:a05:600c:4e13:b0:42c:a802:a8b4 with SMTP id 5b1f17b1804b1-4312556ea22mr78198895e9.0.1728931213877;
        Mon, 14 Oct 2024 11:40:13 -0700 (PDT)
Received: from [192.168.42.211] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4311b69f799sm89856905e9.1.2024.10.14.11.40.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Oct 2024 11:40:13 -0700 (PDT)
Message-ID: <221eb1e4-a631-451e-be84-9012d40186c9@gmail.com>
Date: Mon, 14 Oct 2024 19:40:40 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 7/8] io_uring/uring_cmd: support provide group kernel
 buffer
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org
References: <38ad4c05-6ee3-4839-8d61-f8e1b5219556@gmail.com>
 <ZwdJ7sDuHhWT61FR@fedora> <4b40eff1-a848-4742-9cb3-541bf8ed606e@gmail.com>
 <655b3348-27a1-4bc7-ade7-4d958a692d0b@kernel.dk> <ZwiN0Ioy2Y7cfnTI@fedora>
 <44028492-3681-4cd4-8ae2-ef7139ad50ad@kernel.dk> <ZwiWdO6SS_jlkYrM@fedora>
 <051e74c9-c5b4-40d7-9024-b4bd3f5d0a0f@kernel.dk> <Zwk0SQBiTUBLNvj0@fedora>
 <a7eefe36-55fd-48f7-b05b-afed16a32d0c@kernel.dk> <ZwlIEiWpTMMh-NTL@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZwlIEiWpTMMh-NTL@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/11/24 16:45, Ming Lei wrote:
> On Fri, Oct 11, 2024 at 08:41:03AM -0600, Jens Axboe wrote:
>> On 10/11/24 8:20 AM, Ming Lei wrote:
>>> On Fri, Oct 11, 2024 at 07:24:27AM -0600, Jens Axboe wrote:
>>>> On 10/10/24 9:07 PM, Ming Lei wrote:
>>>>> On Thu, Oct 10, 2024 at 08:39:12PM -0600, Jens Axboe wrote:
>>>>>> On 10/10/24 8:30 PM, Ming Lei wrote:
>>>>>>> Hi Jens,
...
>>>>> Suppose we have N consumers OPs which depends on OP_BUF_UPDATE.
>>>>>
>>>>> 1) all N OPs are linked with OP_BUF_UPDATE
>>>>>
>>>>> Or
>>>>>
>>>>> 2) submit OP_BUF_UPDATE first, and wait its completion, then submit N
>>>>> OPs concurrently.
>>>>
>>>> Correct
>>>>
>>>>> But 1) and 2) may slow the IO handing.  In 1) all N OPs are serialized,
>>>>> and 1 extra syscall is introduced in 2).
>>>>
>>>> Yes you don't want do do #1. But the OP_BUF_UPDATE is cheap enough that
>>>> you can just do it upfront. It's not ideal in terms of usage, and I get
>>>> where the grouping comes from. But is it possible to do the grouping in
>>>> a less intrusive fashion with OP_BUF_UPDATE? Because it won't change any
>>>
>>> The most of 'intrusive' change is just on patch 4, and Pavel has commented
>>> that it is good enough:
>>>
>>> https://lore.kernel.org/linux-block/ZwZzsPcXyazyeZnu@fedora/T/#m551e94f080b80ccbd2561e01da5ea8e17f7ee15d

Trying to catch up on the thread. I do think the patch is tolerable and
mergeable, but I do it adds quite a bit of complication to the path if
you try to have a map in what state a request can be and what
dependencies are there, and then patches after has to go to every each
io_uring opcode and add support for leased buffers. And I'm afraid
that we'll also need to feedback from completion of those to let
the buffer know what ranges now has data / initialised. One typical
problem for page flipping rx, for example, is that you need to have
a full page of data to map it, otherwise it should be prezeroed,
which is too expensive, same problem you can have without mmap'ing
and directly exposing pages to the user.

>> At least for me, patch 4 looks fine. The problem occurs when you start
>> needing to support this different buffer type, which is in patch 6. I'm
>> not saying we can necessarily solve this with OP_BUF_UPDATE, I just want
>> to explore that path because if we can, then patch 6 turns into "oh
>> let's just added registered/fixed buffer support to these ops that don't
>> currently support it". And that would be much nicer indeed.
...
>>>> would be totally fine in terms of performance. OP_BUF_UPDATE will
>>>> _always_ completely immediately and inline, which means that it'll
>>>> _always_ be immediately available post submission. The only think you'd
>>>> ever have to worry about in terms of failure is a badly formed request,
>>>> which is a programming issue, or running out of memory on the host.
>>>>
>>>>> Also it makes error handling more complicated, io_uring has to remove
>>>>> the kernel buffer when the current task is exit, dependency or order with
>>>>> buffer provider is introduced.
>>>>
>>>> Why would that be? They belong to the ring, so should be torn down as
>>>> part of the ring anyway? Why would they be task-private, but not
>>>> ring-private?
>>>
>>> It is kernel buffer, which belongs to provider(such as ublk) instead
>>> of uring, application may panic any time, then io_uring has to remove
>>> the buffer for notifying the buffer owner.
>>
>> But it could be an application buffer, no? You'd just need the
>> application to provide it to ublk and have it mapped, rather than have
>> ublk allocate it in-kernel and then use that.
> 
> The buffer is actually kernel 'request/bio' pages of /dev/ublkbN, and now we
> forward and borrow it to io_uring OPs(fs rw, net send/recv), so it can't be
> application buffer, not same with net rx.

I don't see any problem in dropping buffers from the table
on exit, we have a lot of stuff a thread does for io_uring
when it exits.


>>> In concept grouping is simpler because:
>>>
>>> - buffer lifetime is aligned with group leader lifetime, so we needn't
>>> worry buffer leak because of application accidental exit
>>
>> But if it was an application buffer, that would not be a concern.
> 
> Yeah, but storage isn't same with network, here application buffer can't
> support zc.

Maybe I missed how it came to app buffers, but the thing I
initially mentioned is about storing the kernel buffer in
the table, without any user pointers and user buffers.

>>> - the buffer is borrowed to consumer OPs, and returned back after all
>>> consumers are done, this way avoids any dependency
>>>
>>> Meantime OP_BUF_UPDATE(provide buffer OP, remove buffer OP) becomes more
>>> complicated:
>>>
>>> - buffer leak because of app panic

Then io_uring dies and releases buffers. Or we can even add
some code removing it, as mentioned, any task that has ever
submitted a request already runs some io_uring code on exit.

>>> - buffer dependency issue: consumer OPs depend on provide buffer OP,
>>> 	remove buffer OP depends on consumer OPs; two syscalls has to be
>>> 	added for handling single ublk IO.
>>
>> Seems like most of this is because of the kernel buffer too, no?
> 
> Yeah.
> 
>>
>> I do like the concept of the ephemeral buffer, the downside is that we
>> need per-op support for it too. And while I'm not totally against doing
> 
> Can you explain per-op support a bit?
> 
> Now the buffer has been provided by one single uring command.
> 
>> that, it would be lovely if we could utilize and existing mechanism for
>> that rather than add another one.

That would also be more flexible as not everything can be
handled by linked request logic, and wouldn't require hacking
into every each request type to support "consuming" leased
buffers.

Overhead wise, let's say we fix buffer binding order and delay it
as elaborated on below, then you can provide a buffer and link a
consumer (e.g. send request or anything else) just as you do
it now. You can also link a request returning the buffer to the
same chain if you don't need extra flexibility.

As for groups, they're complicated because of the order inversion,
the notion of a leader and so. If we get rid of the need to impose
more semantics onto it by mediating buffer transition through the
table, I think we can do groups if needed but make it simpler.

>> What's preventing it from registering it in ->prep()? It would be a bit
>> odd, but there would be nothing preventing it codewise, outside of the
>> oddity of ->prep() not being idempotent at that point. Don't follow why
>> that would be necessary, though, can you expand?
> 
> ->prep() doesn't export to uring cmd, and we may not want to bother
> drivers.
> 
> Also remove buffer still can't be done in ->prep().
> 
> Not dig into further, one big thing could be that dependency isn't
> respected in ->prep().

And we can just fix that and move the choosing of a buffer
to ->issue(), in which case a buffer provided by one request
will be observable to its linked requests.

-- 
Pavel Begunkov

