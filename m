Return-Path: <io-uring+bounces-4276-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4EFD49B7EB8
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 16:42:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ABE66B20DBC
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 15:42:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 347011A01C4;
	Thu, 31 Oct 2024 15:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kqmsYqTf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E145813342F
	for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 15:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730389359; cv=none; b=uzobQsgbOJ/Ts4f8BCjAPXtE3ctuHXlCL75Cjvjn5+OJTvwiDuXe7yJ21vGeuF+lkVW4RgFnGQyUELMTKN8EnVO3N4jmkV2Mn4v6IcCX9d2iDLoei4B6TXekc4ahukv1yoA7e7oXjaI/RtPELx55r2sbPunGwfRE9MJGboK75+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730389359; c=relaxed/simple;
	bh=0NtkvTCi3ZOjvlTD7dhsImSkuX2SKlh1rwQxldb1VFs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ar+TmK9r/szIW0QMeAxgJfExhv5m9L5rZDVaaderCbKLSeXvmhM87Qe0zOzrMD34YGxL9FC13UtIJn2CyD0TnhLwTZlYB4R9DKWFMUPpU48li7wx7raGqEh23S2VpypCsTkhkRJAVsXq4caen5c1i0jdlcOlGeONxz8EEdgyXXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kqmsYqTf; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3a4e5e57678so7165615ab.1
        for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 08:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730389355; x=1730994155; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zu4t7ikgDLPihQeRUe19wAEWK8bbjEbdWU4hqER7Wu4=;
        b=kqmsYqTfZ/EMVU+mznZuygMkc4oKn65+EcqxgNds8bsLE12uMtqfA/DI5ISy2A7OEC
         hEa1YkKVnctayPCnBqByZ9iMHKv1KHzYzWw20vsP9CQ2PztsNQow+3muSijpltMjc54A
         Ra9JEgI5Nfk3cL+t3R9SwV2EIT4nrWDuxn7zFz+lhXO/q7J1JMFz0GvlZlaserTW/AWW
         RxTGpT6g4RJEnBLEdZEQe4tccdsKZM9+sFJmwpD5cmT4F1dl/JtgDzvgJYjhH3HWnRps
         dD8Bi/8YUvPVMAi2aserWlTrb6IhYF2fNdCLxvRbc7Wpvzi/ncQsnSm19iDH7y8WJanu
         Oxhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730389355; x=1730994155;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zu4t7ikgDLPihQeRUe19wAEWK8bbjEbdWU4hqER7Wu4=;
        b=HOZz6BIurtjavqF/BxvwVBERWzTCpL8XpFZs5B5miJic+0szRx1Q2rMuxN4dkSqnKE
         r0+7nt2lw0mFzDFsbo3xPE+SmjQpUtawu5To9NTfmBaavnjy9IobxN/tfHydGtaeC0QW
         ecusQZ6T1knJSY2O8RKRylwlq+LX61XFHwXjb39tujaO4NsfwBxJk+oQRrAuyM85UCco
         /anXgxt+jncjeyij9hVGSkkXZrGF6WZzw7IEVqVEbgviEgRpa5gL6JwOW9dZvXOu1U5q
         oN1hf3/VZ6D4mi6YZYofDui9TrnTAnsuotLtQSNnvr0pQc07DhVksz8t3o+AYqO407y4
         2zWA==
X-Gm-Message-State: AOJu0Yz4dbfiFdJzUdWI/Y4wpbwjQjNjcNdeLtAtOnnMSKadnvOnH5SV
	6PaenUh4QB2Se9Xa5CQgOIN6DBzwap4YCDHVhZRrey6N51IzgC6ZfxCsEADZ04Q=
X-Google-Smtp-Source: AGHT+IHa2dzQdMslHA1FvCu6c4JUdPTqwrA6RqZYR3mOyurWoXTJiivF7PieJ8badg2W5wGDUdk+hA==
X-Received: by 2002:a05:6e02:111:b0:3a3:637f:1012 with SMTP id e9e14a558f8ab-3a6aff71b31mr2963635ab.12.1730389354967;
        Thu, 31 Oct 2024 08:42:34 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4de049a4813sm334757173.149.2024.10.31.08.42.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2024 08:42:34 -0700 (PDT)
Message-ID: <eb7f844c-9517-4ff9-979f-d78afd4673c4@kernel.dk>
Date: Thu, 31 Oct 2024 09:42:33 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V8 0/8] io_uring: support sqe group and leased group kbuf
To: Pavel Begunkov <asml.silence@gmail.com>, Ming Lei <ming.lei@redhat.com>
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <bc9c365a-16fc-46b2-bc92-4c6dfbc3ada6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/31/24 9:25 AM, Pavel Begunkov wrote:
> On 10/31/24 14:29, Jens Axboe wrote:
>> On 10/31/24 7:25 AM, Pavel Begunkov wrote:
>>> On 10/30/24 02:43, Jens Axboe wrote:
>>>> On 10/29/24 8:03 PM, Ming Lei wrote:
>>>>> On Tue, Oct 29, 2024 at 03:26:37PM -0600, Jens Axboe wrote:
>>>>>> On 10/29/24 2:06 PM, Jens Axboe wrote:
>>>>>>> On 10/29/24 1:18 PM, Jens Axboe wrote:
>>> ...
>>>>>> +    node->buf = imu;
>>>>>> +    node->kbuf_fn = kbuf_fn;
>>>>>> +    return node;
>>>>>
>>>>> Also this function needs to register the buffer to table with one
>>>>> pre-defined buf index, then the following request can use it by
>>>>> the way of io_prep_rw_fixed().
>>>>
>>>> It should not register it with the table, the whole point is to keep
>>>> this node only per-submission discoverable. If you're grabbing random
>>>> request pages, then it very much is a bit finicky
>>>
>>> Registering it into the table has enough of design and flexibility
>>> merits: error handling, allowing any type of dependencies of requests
>>> by handling it in the user space, etc.
>>
>> Right, but it has to be a special table. See my lengthier reply to Ming.
> 
> Mind pointing the specific part? I read through the thread and didn't
> see why it _has_ to be a special table.
> And by "special" I assume you mean the property of it being cleaned up
> / flushed by the end of submission / syscall, right?

Right, that's all I mean, special in the sense that it isn't persistent.
Nothing special about it otherwise. Maybe "separate table from
buf_table" is a more accurate way to describe it.

>> The initial POC did install it into a table, it's just a one-slot table,
> 
> By "table" I actually mean anything that survives beyond the current
> syscall / submission and potentially can be used by requests submitted
> with another syscall.

Obviously there's nothing special about the above mentioned table in the
sense that it's a normal table, it just doesn't survive beyond the
current submission. The reason why I like that approach is that it
doesn't leave potentially iffy data in a table beyond that submission.
If we don't own this data, it's merely borrowed from someone else, then
special case must be taken around it.

>> io_submit_state. I think the right approach is to have an actual struct
>> io_rsrc_data local_table in the ctx, with refs put at the end of submit.
>> Same kind of concept, just allows for more entries (potentially), with
>> the same requirement that nodes get put when submit ends. IOW, requests
>> need to find it within the same submit.
>>
>> Obviously you would not NEED to do that, but if the use case is grabbing
>> bvecs out of a request, then it very much should not be discoverable
>> past the initial assignments within that submit scope.
>>
>>>> and needs to be of
>>>> limited scope.
>>>
>>> And I don't think we can force it, neither with limiting exposure to
>>> submission only nor with the Ming's group based approach. The user can
>>> always queue a request that will never complete and/or by using
>>> DEFER_TASKRUN and just not letting it run. In this sense it might be
>>> dangerous to block requests of an average system shared block device,
>>> but if it's fine with ublk it sounds like it should be fine for any of
>>> the aforementioned approaches.
>>
>> As long as the resource remains valid until the last put of the node,
>> then it should be OK. Yes the application can mess things up in terms of
> 
> It should be fine in terms of buffers staying alive. The "dangerous"
> part I mentioned is about abuse of a shared resource, e.g. one
> container locking up all requests of a bdev so that another container
> can't do any IO, maybe even with an fs on top. Nevertheless, it's ublk,
> I don't think we need to concern about that much since io_uring is
> on the other side from normal user space.

If you leave it in the table, then you can no longer rely on the final
put being the callback driver. Maybe this is fine, but then it needs
some other mechanism for this.

>> latency if it uses one of these bufs for eg a read on a pipe that never
>> gets any data, but the data will remain valid regardless. And that's
>> very much a "doctor it hurts when I..." case, it should not cause any
> 
> Right, I care about malicious abuse when it can affect other users,
> break isolation / fairness, etc., I'm saying that there is no
> difference between all the approaches in this aspect, and if so
> it should also be perfectly ok from the kernel's perspective to allow
> to leave a buffer in the table long term. If the user wants to screw
> itself and doesn't remove the buffer that's the user's choice to
> shoot itself in the leg.
> 
> From this angle, that I look at the auto removal you add not as some
> security / etc. concern, but just as a QoL / performance feature so
> that the user doesn't need to remove the buffer by hand.
> 
> FWIW, instead of having another table, we can just mark a sub range
> of the main buffer table to be cleared every time after submission,
> just like we separate auto slot allocation with ranges.

I did consider that idea too, mainly from the perspective of then not
needing any kind of special OP or OP support to grab one of these
buffers, it'd just use the normal table but in a separate range. Doesn't
feel super clean, and does require some odd setup. Realistically,
applications probabably use one or the other and not combined, so
perhaps it's fine and the range is just the normal range. If they do mix
the two, then yeah they would want to use separate ranges for them.

Honestly don't care too deeply about that implementation detail, I care
more about having these buffers be io_rsrc_node and using the general
infrastructure for them. If we have to add IORING_RSRC_KBUFFER for them
and a callback + data field to io_rsrc_node, that still a much better
approach than having some other intermediate type which basically does
the same thing, except it needs new fields to store it and new helpers
to alloc/put it.

-- 
Jens Axboe

