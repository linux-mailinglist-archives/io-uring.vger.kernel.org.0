Return-Path: <io-uring+bounces-3569-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 862CC99919E
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 21:04:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0109E1F25F4A
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 19:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D7AA1E5732;
	Thu, 10 Oct 2024 18:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="csO8O0L7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7391CEAA6;
	Thu, 10 Oct 2024 18:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728586248; cv=none; b=H38CPAK5WmbOKGzTrC6WIXiWofHDR3Bpo0rYsOkMlovSTBPxt4/XDcahhcbKZ1/8koIh/yfCLWuo/71ziC+6gdx5lDtlpcXMcclvfsBANmZtGmBgG4yIuAyYSbER7NzHvqCzRl3C5/fghQKp1t0TcSAvSFZZp5mRwTDcyCoRhxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728586248; c=relaxed/simple;
	bh=VvALfe1tjjjMdKtNZuRURZtOV2wf+a2gYaPw1L+uu3I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XkHjnc7RL1WXm8YKrhO3FiU+qCrzv6kH7+JRdmagLE37ExBI94vuHvlKiHYcheGadTuy1BPdSYcZfoBexQt6lwTD6Q7HL61lmouvf9tabdcsvCB5Fza6oZPvNQnVC1MoSCBf2LPOtGGv0K4Hp3qn3tWOUJ03ld9CQeAjUT+QHZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=csO8O0L7; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43117917eb9so8964735e9.0;
        Thu, 10 Oct 2024 11:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728586245; x=1729191045; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rfaProorKPtZlGUv+B092FuMSIfSwLzcCZ2qy4P0GCQ=;
        b=csO8O0L7f7w8/eCYOzGyTavFuXgH5cUxcFNmYd9MRNHj4G/ydzVwUQPPfHf/4OMiNj
         ZKLPCJUC1WW1UqAcLAymQa5G8OucygJRoFwlO4KMaFstOju2WhE+fiwkmISxQvEkL1/j
         +YE1fAAR3xYJmIwT9yzsQzQQ5a/JsHrN5Eu6pf+O3hmjJM0XcZH+r8LJQtMSFPIGND0D
         rv8u7emP9f9AL7642AWwZDx69Dye261IoBRpPvrp1dl5cevGKLPH6Non15dCssTb24I1
         x2SXzLQWF3pSRSxdKUWG/1qQJC/zoziD0cYZQ0uZVvbaGTX+IaG3tS4YvVgKDJx/WZHj
         Nz8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728586245; x=1729191045;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rfaProorKPtZlGUv+B092FuMSIfSwLzcCZ2qy4P0GCQ=;
        b=pbkWYMW5r/L+1eNN64ooO4pOmMQCDfE2XFqMOLFl9P6zYydq0qlpT2AWypnCRDW8lj
         RfEa+XCbejxkJ5tgJHz+9Zx4j4r0zF+PUxwRbAcrJNVspEYNLPIS/KqDITveFkTar4kc
         LUno5xauPS6km3K90uSbXIJwJJuFSDm3RaB+aXgE/4ELwXolDRfwoADxlKpaodurjlCq
         CncuCbfn/9h0iFoySBDUAXqDGlhlpOjBj+Le3YklzbH2x2OMX8suTCEbFaQH80P+KJX8
         Ar3zuiUsULghLXtI8NG724S9jx0nD7fMhtgUlXFpjroo9yl1mKb8P9CH2jBpAA46qTnW
         /L0w==
X-Forwarded-Encrypted: i=1; AJvYcCXqLA3ruir8wyswy+SykFYbwNPO7DU8mMCxwNgiOL/QoLmpo0LYU1VXlSmzYHN1Aa4DeyfQ2NCTXrZbiKY=@vger.kernel.org, AJvYcCXyvWLUByEdZ5PxX5Tq8mr/U22aVxHwoi0BijezmAQqE78egfLbY73Ty8hFT9lAzklSWB/eCMlfsg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzKAQuEoQe3FYzQqqWHUkYlcBy90blmGFOaioDq2qi9DqWm/ejy
	yRArmOV5dUq6gwcds5dD1s9vaXND1pA9szxN4wB9sRq40Tutd1tx
X-Google-Smtp-Source: AGHT+IFpeSn9AXDIe0Rw6ZOwzFbea27/6FPpaJem64uoLtM6XhfRp3ozjDTlAtOD/aXqu5qAYySRRg==
X-Received: by 2002:a05:600c:1c23:b0:430:57f2:baf2 with SMTP id 5b1f17b1804b1-430d59b7873mr62927435e9.22.1728586244334;
        Thu, 10 Oct 2024 11:50:44 -0700 (PDT)
Received: from [192.168.42.219] ([148.252.140.94])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4311835c3acsm23052745e9.41.2024.10.10.11.50.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 11:50:43 -0700 (PDT)
Message-ID: <b41dfbe1-2dee-47fc-a2f4-38bef49f60ab@gmail.com>
Date: Thu, 10 Oct 2024 19:51:19 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 6/8] io_uring: support providing sqe group buffer
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <20240912104933.1875409-7-ming.lei@redhat.com>
 <51c10faa-ac28-4c40-82c4-373dbcad6e79@gmail.com> <ZwJIWqPT_Ae9K2bp@fedora>
 <8d93e1ba-0fdf-44d4-9189-199df57d0676@gmail.com> <ZwdDU1-lfywyb4jO@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZwdDU1-lfywyb4jO@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/10/24 04:00, Ming Lei wrote:
> On Wed, Oct 09, 2024 at 03:25:25PM +0100, Pavel Begunkov wrote:
>> On 10/6/24 09:20, Ming Lei wrote:
>>> On Fri, Oct 04, 2024 at 04:32:04PM +0100, Pavel Begunkov wrote:
>>>> On 9/12/24 11:49, Ming Lei wrote:
>>>> ...
>>>>> It can help to implement generic zero copy between device and related
>>>>> operations, such as ublk, fuse, vdpa,
>>>>> even network receive or whatever.
>>>>
>>>> That's exactly the thing it can't sanely work with because
>>>> of this design.
>>>
>>> The provide buffer design is absolutely generic, and basically
>>>
>>> - group leader provides buffer for member OPs, and member OPs can borrow
>>> the buffer if leader allows by calling io_provide_group_kbuf()
>>>
>>> - after member OPs consumes the buffer, the buffer is returned back by
>>> the callback implemented in group leader subsystem, so group leader can
>>> release related sources;
>>>
>>> - and it is guaranteed that the buffer can be released always
>>>
>>> The ublk implementation is pretty simple, it can be reused in device driver
>>> to share buffer with other kernel subsystems.
>>>
>>> I don't see anything insane with the design.
>>
>> There is nothing insane with the design, but the problem is cross
>> request error handling, same thing that makes links a pain to use.
> 
> Wrt. link, the whole group is linked in the chain, and it respects
> all existed link rule, care to share the trouble in link use case?

Error handling is a pain, it has been, even for pure link without
any groups. Even with a simple req1 -> req2, you need to track if
the first request fails you need to expect another failed CQE for
the second request, probably refcount (let's say non-atomically)
some structure and clean it up when you get both CQEs. It's not
prettier when the 2nd fails, especially if you consider short IO
and that you can't fully retry that partial IO, e.g. you consumed
data from the socket. And so on.

> The only thing I thought of is that group internal link isn't supported
> yet, but it may be added in future if use case is coming.
> 
>> It's good that with storage reads are reasonably idempotent and you
>> can be retried if needed. With sockets and streams, however, you
>> can't sanely borrow a buffer without consuming it, so if a member
>> request processing the buffer fails for any reason, the user data
>> will be dropped on the floor. I mentioned quite a while before,
>> if for example you stash the buffer somewhere you can access
>> across syscalls like the io_uring's registered buffer table, the
>> user at least would be able to find an error and then memcpy the
>> unprocessed data as a fallback.
> 
> I guess it is net rx case, which requires buffer to cross syscalls,
> then the buffer has to be owned by userspace, otherwise the buffer
> can be leaked easily.
> 
> That may not match with sqe group which is supposed to borrow kernel
> buffer consumed by users.

It doesn't necessarily require to keep buffers across syscalls
per se, it just can't drop the data it got on the floor. It's
just storage can read data again.

...
>>>>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>>>>> index 793d5a26d9b8..445e5507565a 100644
>>>>> --- a/include/linux/io_uring_types.h
>>>>> +++ b/include/linux/io_uring_types.h
...
>>>> FWIW, would be nice if during init figure we can verify that the leader
>>>> provides a buffer IFF there is someone consuming it, but I don't think
>>>
>>> It isn't doable, same reason with IORING_OP_PROVIDE_BUFFERS, since buffer can
>>> only be provided in ->issue().
>>
>> In theory we could, in practise it'd be too much of a pain, I agree.
>>
>> IORING_OP_PROVIDE_BUFFERS is different as you just stash the buffer
>> in the io_uring instance, and it's used at an unspecified time later
>> by some request. In this sense the API is explicit, requests that don't
>> support it but marked with IOSQE_BUFFER_SELECT will be failed by the
>> kernel.
> 
> That is also one reason why I add ->accept_group_kbuf.

I probably missed that, but I haven't seen that

>>>> the semantics is flexible enough to do it sanely. i.e. there are many
>>>> members in a group, some might want to use the buffer and some might not.
>>>>
...
>>>>> +	if (!kbuf->bvec)
>>>>> +		return -EINVAL;
>>>>
>>>> How can this happen?
>>>
>>> OK, we can run the check in uring_cmd API.
>>
>> Not sure I follow, if a request providing a buffer can't set
>> a bvec it should just fail, without exposing half made
>> io_uring_kernel_buf to other requests.
>>
>> Is it rather a WARN_ON_ONCE check?
> 
> I meant we can check it in API of io_provide_group_kbuf() since the group
> buffer is filled by driver, since then the buffer is immutable, and we
> needn't any other check.

That's be a buggy provider, so sounds like WARN_ON_ONCE

...
>>>>>     		if (unlikely(ret < 0))
>>>>> @@ -593,6 +600,15 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
>>>>>     	if (issue_flags & IO_URING_F_NONBLOCK)
>>>>>     		flags |= MSG_DONTWAIT;
>>>>> +	if (req->flags & REQ_F_GROUP_KBUF) {
>>>>
>>>> Does anything prevent the request to be marked by both
>>>> GROUP_KBUF and BUFFER_SELECT? In which case we'd set up
>>>> a group kbuf and then go to the io_do_buffer_select()
>>>> overriding all of that
>>>
>>> It could be used in this way, and we can fail the member in
>>> io_queue_group_members().
>>
>> That's where the opdef flag could actually be useful,
>>
>> if (opdef[member]->accept_group_kbuf &&
>>      member->flags & SELECT_BUF)
>> 	fail;
>>
>>
>>>>> +		ret = io_import_group_kbuf(req,
>>>>> +					user_ptr_to_u64(sr->buf),
>>>>> +					sr->len, ITER_SOURCE,
>>>>> +					&kmsg->msg.msg_iter);
>>>>> +		if (unlikely(ret))
>>>>> +			return ret;
>>>>> +	}
>>>>> +
>>>>>     retry_bundle:
>>>>>     	if (io_do_buffer_select(req)) {
>>>>>     		struct buf_sel_arg arg = {
>>>>> @@ -1154,6 +1170,11 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>>>>>     			goto out_free;
>>>>>     		}
>>>>>     		sr->buf = NULL;
>>>>> +	} else if (req->flags & REQ_F_GROUP_KBUF) {
>>>>
>>>> What happens if we get a short read/recv?
>>>
>>> For short read/recv, any progress is stored in iterator, nothing to do
>>> with the provide buffer, which is immutable.
>>>
>>> One problem for read is reissue, but it can be handled by saving iter
>>> state after the group buffer is imported, I will fix it in next version.
>>> For net recv, offset/len of buffer is updated in case of short recv, so
>>> it works as expected.
>>
>> That was one of my worries.
>>
>>> Or any other issue with short read/recv? Can you explain in detail?
>>
>> To sum up design wise, when members that are using the buffer as a
>> source, e.g. write/send, fail, the user is expected to usually reissue
>> both the write and the ublk cmd.
>>
>> Let's say you have a ublk leader command providing a 4K buffer, and
>> you group it with a 4K send using the buffer. Let's assume the send
>> is short and does't only 2K of data. Then the user would normally
>> reissue:
>>
>> ublk(4K, GROUP), send(off=2K)
>>
>> That's fine assuming short IO is rare.
>>
>> I worry more about the backward flow, ublk provides an "empty" buffer
>> to receive/read into. ublk wants to do something with the buffer in
>> the callback. What happens when read/recv is short (and cannot be
>> retried by io_uring)?
>>
>> 1. ublk(provide empty 4K buffer)
>> 2. recv, ret=2K
>> 3. ->grp_kbuf_ack: ublk should commit back only 2K
>>     of data and not assume it's 4K
> 
> ->grp_kbuf_ack is supposed to only return back the buffer to the
> owner, and it doesn't care result of buffer consumption.
> 
> When ->grp_kbuf_ack() is done, it means this time buffer borrow is
> over.
> 
> When userspace figures out it is one short read, it will send one
> ublk uring_cmd to notify that this io command is completed with
> result(2k). ublk driver may decide to requeue this io command for
> retrying the remained bytes, when only remained part of the buffer
> is allowed to borrow in following provide uring command originated
> from userspace.

My apologies, I failed to notice that moment, even though should've
given it some thinking at the very beginning. I think that part would
be a terrible interface. Might be good enough for ublk, but we can't
be creating a ublk specific features that change the entire io_uring.
Without knowing how much data it actually got, in generic case you
1) need to require the buffer to be fully initialised / zeroed
before handing it. 2) Can't ever commit the data from the callback,
but it would need to wait until the userspace reacts. Yes, it
works in the specific context of ublk, but I don't think it works
as a generic interface.

We need to fall back again and think if we can reuse the registered
buffer table or something else, and make it much cleaner and more
accommodating to other users. Jens, can you give a quick thought
about the API? You've done a lot of interfaces before and hopefully
have some ideas here.


> For ublk use case, so far so good.
> 
>>
>> Another option is to fail ->grp_kbuf_ack if any member fails, but
>> the API might be a bit too awkward and inconvenient .
> 
> We needn't ->grp_kbuf_ack() to cover buffer consumption.

-- 
Pavel Begunkov

