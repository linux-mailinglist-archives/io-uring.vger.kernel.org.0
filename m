Return-Path: <io-uring+bounces-4281-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 404539B801D
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 17:30:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF08A1F214DC
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 16:30:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 707751BC07B;
	Thu, 31 Oct 2024 16:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lFqztQ+0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B863F2E406;
	Thu, 31 Oct 2024 16:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730392156; cv=none; b=JY37mfQ/YR6V6tiJrtJ4YciOYBKCg+bUqf9D8WxB/bMy+qUEYqWpFXFYmy9P08E9BxIp2USHEz+9bnfq1NHB3/OWKoBhA6szgMj5gr249gidTJU7I/k898mNxCUUvMINDhHcpW7mYje6sYb/bWEM0Dnkgb6ADbZJHYHsXSWEKVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730392156; c=relaxed/simple;
	bh=OYQafoI7BIz0Oi5fXUKpHtSgw5oFZMnFYKOuqIdJoEU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A2ZFiw7ZNNlSjoZLxgnXUp11ZmeEdG1XMrIVIG3u0WmLmoxmrrgz1QHSZYhMMH2lubjPB03To5OG8tXISxIeEACjQHZnXNi70OsaAcD6nQevhSiN9QRLWUyZsKSTgknvLMBUjDrQDIAUATMbXQYvf2hmLVVbIjJQ3nRPg8jEz9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lFqztQ+0; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a9a850270e2so174095966b.0;
        Thu, 31 Oct 2024 09:29:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730392152; x=1730996952; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AI8NJUEO8pc0p6G0u+K0OVeZdhbtV9QBSYnNZJm2p/8=;
        b=lFqztQ+07CMz1R9mEoR/tJ92Ofs0qO2CscvGHQ6/G4gm3GMVA+9yc0z5QleGhOAhas
         8zAs3Qk32+YltB5ha7/v3Ng9HW2pGaEfePWwyvFVd34UFrdvI2i+liJic18iFjTqkyFy
         GNDKOF7KvwsJpFs997unwZtuOTdRdqrC9SefCNN2uuWsMVZgR28ecKMtFtzpTebPs83v
         9WKDGx1Lv+sZTIfv2nRIW1GIUlVvqwZ+BnL3H9j0I8YxYB10FKxqSaj8e9eMd0iSvELa
         ebfbKHkMwsXY6xiZd4gjZmEVFVGU2lwvblAotP/SK0Bw5OC++UpFFAbM2DCpk6lohH8w
         hHFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730392152; x=1730996952;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AI8NJUEO8pc0p6G0u+K0OVeZdhbtV9QBSYnNZJm2p/8=;
        b=WE3BxOtoUOGtcrW+x/zsnjzK0vuYix0QyWBIlBilspwsxLZAfLTl8f76jTD0YEG6WC
         ZIOPBSpSk01MPxHpB+GCRxOJVaJOR4czkfr/aonge8Bc3/WGr4EXfSdEJLPJ3Om4DnN9
         x48Xi8JpG/jLUeB5Tk4LokuHktYh73+U24LtEsDIa3na4h/N4bz6dWu5Gj0daFKUf3d6
         cecGopOiaAclWuFMANggrWgPcIIDiTFW2k4yJrfL0JEcEPDqb6/3u9TJuGIuFTDHSQV4
         4ggZkprfmCBuxzpW7O7bSFlVoULCUH+F5Q3+yH1VAuvQPBgItsNAX0+3PO2J1h8mcMjr
         mCyg==
X-Forwarded-Encrypted: i=1; AJvYcCVId8pt3uHIOt/l/SYBR9UVl172fDDSlzu1LjGrahpXFNnzFipNc+eitjmUcvQmGv8/zR/0T4OAmxiUHA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwlKDm6kKwzXi5GYNl90zsyAe+QATqpssgwi4GpIYbLhkZvxTTA
	+tLSMQoIadqMwwIJOcJow6feseikGcq97qJVFLpAw/rBDC86HZI6
X-Google-Smtp-Source: AGHT+IF+XY3GgGyatoOnYvUX8xe7GwTk0fcbjF+IOkWxWLGphtT9xWk+ChiS7RAwrbN6kniEtoud0g==
X-Received: by 2002:a17:907:3d90:b0:a9a:b823:14ca with SMTP id a640c23a62f3a-a9e6553aeefmr47331566b.6.1730392151726;
        Thu, 31 Oct 2024 09:29:11 -0700 (PDT)
Received: from [192.168.42.101] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e564c5369sm83853766b.48.2024.10.31.09.29.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2024 09:29:11 -0700 (PDT)
Message-ID: <dbdc7ad4-a73b-46e3-999b-c63f7132e598@gmail.com>
Date: Thu, 31 Oct 2024 16:29:27 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V8 0/8] io_uring: support sqe group and leased group kbuf
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Uday Shankar <ushankar@purestorage.com>,
 Akilesh Kailash <akailash@google.com>
References: <20241025122247.3709133-1-ming.lei@redhat.com>
 <15b9b1e0-d961-4174-96ed-5a6287e4b38b@gmail.com>
 <d859c85c-b7bf-4673-8c77-9d7113f19dbb@kernel.dk>
 <bc44d3c0-41e8-425c-957f-bad70aedcc50@kernel.dk>
 <e76d9742-5693-4057-b925-3917943c7441@kernel.dk>
 <f51e50c8-271e-49b6-b3e1-a63bf61d7451@kernel.dk> <ZyGT3h5jNsKB0mrZ@fedora>
 <674e8c3c-1f2c-464a-ad59-da3d00104383@kernel.dk>
 <1f40a907-9c53-408d-997e-da49e5751c66@gmail.com>
 <6e6893cd-890d-46b0-9164-01801a4145bc@kernel.dk>
 <bc9c365a-16fc-46b2-bc92-4c6dfbc3ada6@gmail.com>
 <eb7f844c-9517-4ff9-979f-d78afd4673c4@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <eb7f844c-9517-4ff9-979f-d78afd4673c4@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/31/24 15:42, Jens Axboe wrote:
> On 10/31/24 9:25 AM, Pavel Begunkov wrote:
>> On 10/31/24 14:29, Jens Axboe wrote:
>>> On 10/31/24 7:25 AM, Pavel Begunkov wrote:
>>>> On 10/30/24 02:43, Jens Axboe wrote:
>>>>> On 10/29/24 8:03 PM, Ming Lei wrote:
>>>>>> On Tue, Oct 29, 2024 at 03:26:37PM -0600, Jens Axboe wrote:
>>>>>>> On 10/29/24 2:06 PM, Jens Axboe wrote:
>>>>>>>> On 10/29/24 1:18 PM, Jens Axboe wrote:
>>>> ...
>>>>>>> +    node->buf = imu;
>>>>>>> +    node->kbuf_fn = kbuf_fn;
>>>>>>> +    return node;
>>>>>>
>>>>>> Also this function needs to register the buffer to table with one
>>>>>> pre-defined buf index, then the following request can use it by
>>>>>> the way of io_prep_rw_fixed().
>>>>>
>>>>> It should not register it with the table, the whole point is to keep
>>>>> this node only per-submission discoverable. If you're grabbing random
>>>>> request pages, then it very much is a bit finicky
>>>>
>>>> Registering it into the table has enough of design and flexibility
>>>> merits: error handling, allowing any type of dependencies of requests
>>>> by handling it in the user space, etc.
>>>
>>> Right, but it has to be a special table. See my lengthier reply to Ming.
>>
>> Mind pointing the specific part? I read through the thread and didn't
>> see why it _has_ to be a special table.
>> And by "special" I assume you mean the property of it being cleaned up
>> / flushed by the end of submission / syscall, right?
> 
> Right, that's all I mean, special in the sense that it isn't persistent.
> Nothing special about it otherwise. Maybe "separate table from
> buf_table" is a more accurate way to describe it.
> 
>>> The initial POC did install it into a table, it's just a one-slot table,
>>
>> By "table" I actually mean anything that survives beyond the current
>> syscall / submission and potentially can be used by requests submitted
>> with another syscall.
> 
> Obviously there's nothing special about the above mentioned table in the
> sense that it's a normal table, it just doesn't survive beyond the
> current submission. The reason why I like that approach is that it
> doesn't leave potentially iffy data in a table beyond that submission.
> If we don't own this data, it's merely borrowed from someone else, then
> special case must be taken around it.

So you're not trying to prevent some potential malicious use
but rather making it a bit nicer for buggy users. I don't think I
care much about that aspect and would sacrifice the property if it
gives us anything good anywhere else.

>>> io_submit_state. I think the right approach is to have an actual struct
>>> io_rsrc_data local_table in the ctx, with refs put at the end of submit.
>>> Same kind of concept, just allows for more entries (potentially), with
>>> the same requirement that nodes get put when submit ends. IOW, requests
>>> need to find it within the same submit.
>>>
>>> Obviously you would not NEED to do that, but if the use case is grabbing
>>> bvecs out of a request, then it very much should not be discoverable
>>> past the initial assignments within that submit scope.
>>>
>>>>> and needs to be of
>>>>> limited scope.
>>>>
>>>> And I don't think we can force it, neither with limiting exposure to
>>>> submission only nor with the Ming's group based approach. The user can
>>>> always queue a request that will never complete and/or by using
>>>> DEFER_TASKRUN and just not letting it run. In this sense it might be
>>>> dangerous to block requests of an average system shared block device,
>>>> but if it's fine with ublk it sounds like it should be fine for any of
>>>> the aforementioned approaches.
>>>
>>> As long as the resource remains valid until the last put of the node,
>>> then it should be OK. Yes the application can mess things up in terms of
>>
>> It should be fine in terms of buffers staying alive. The "dangerous"
>> part I mentioned is about abuse of a shared resource, e.g. one
>> container locking up all requests of a bdev so that another container
>> can't do any IO, maybe even with an fs on top. Nevertheless, it's ublk,
>> I don't think we need to concern about that much since io_uring is
>> on the other side from normal user space.
> 
> If you leave it in the table, then you can no longer rely on the final
> put being the callback driver. Maybe this is fine, but then it needs
> some other mechanism for this.

Not sure I follow. The ->kbuf_fn is set by the driver, right?
It'll always be called once the node is destroyed, in this sense
the final destination is always the driver that leased the buffer.

Or do you mean the final rsrc_node put? Not sure how that works
considering requests can complete inside the submission as well
as outlive it with the node reference.

>>> latency if it uses one of these bufs for eg a read on a pipe that never
>>> gets any data, but the data will remain valid regardless. And that's
>>> very much a "doctor it hurts when I..." case, it should not cause any
>>
>> Right, I care about malicious abuse when it can affect other users,
>> break isolation / fairness, etc., I'm saying that there is no
>> difference between all the approaches in this aspect, and if so
>> it should also be perfectly ok from the kernel's perspective to allow
>> to leave a buffer in the table long term. If the user wants to screw
>> itself and doesn't remove the buffer that's the user's choice to
>> shoot itself in the leg.
>>
>>  From this angle, that I look at the auto removal you add not as some
>> security / etc. concern, but just as a QoL / performance feature so
>> that the user doesn't need to remove the buffer by hand.
>>
>> FWIW, instead of having another table, we can just mark a sub range
>> of the main buffer table to be cleared every time after submission,
>> just like we separate auto slot allocation with ranges.
> 
> I did consider that idea too, mainly from the perspective of then not
> needing any kind of special OP or OP support to grab one of these
> buffers, it'd just use the normal table but in a separate range. Doesn't
> feel super clean, and does require some odd setup. Realistically,

I feel like we don't even need to differentiate it from normal
reg buffers in how it's used by other opcodes, cleaning the table
is just a feature, I'd even argues an optional one.

> applications probabably use one or the other and not combined, so
> perhaps it's fine and the range is just the normal range. If they do mix
> the two, then yeah they would want to use separate ranges for them.
> 
> Honestly don't care too deeply about that implementation detail, I care
> more about having these buffers be io_rsrc_node and using the general
> infrastructure for them. If we have to add IORING_RSRC_KBUFFER for them
> and a callback + data field to io_rsrc_node, that still a much better

Right, and I don't think it's a problem at all, for most of the
users destroying a resource is cold path anyway, apart from this
zc proposal nobody registers file/buffer just for one request.

> approach than having some other intermediate type which basically does
> the same thing, except it needs new fields to store it and new helpers
> to alloc/put it.

-- 
Pavel Begunkov

