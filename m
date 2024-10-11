Return-Path: <io-uring+bounces-3592-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CB0E99A4F7
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 15:24:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AEF35B24DEC
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 13:24:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 522B22185B1;
	Fri, 11 Oct 2024 13:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="EpKsoNPU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE4E20CCE6
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 13:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728653072; cv=none; b=PPDhzMZxd0GW6yx7gTMP4GCEAZbZ+h5Lwn2q4Ciwb93GGz/VxlXmwb8lA/HiVkCK6EeNYsnzuZ/Uff4Zcg3mPR/rJyf2U8VksjYRkW+vAn9dyECBbfYxKxucyo+th3pnSX5bRaHArMI3Zwzj2AFeE4nMRPU6wvj0Lc+GQSGHJFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728653072; c=relaxed/simple;
	bh=BYttc2gCWtd8Qf7Biq7ewziJRDDPDD2lQmlIsPXM5Zg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lW+Pig1/fT0aGaHtqtcOZvd2Sq1d54XaW1knWQaSf6eTgU8hYt4djEvk3kpDCqkgZrOnEmy2E1It/h5/jpv5DASo/QCKNoex6fn5oyQH9ngux2L8oYpc70lw9LViwtuWhzIR8Opzn3AB3f4NTtMNSleJJH0mywLkOzzaG0qPUVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=EpKsoNPU; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-8354d853f91so69227339f.0
        for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 06:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728653069; x=1729257869; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8WBjL+tGnFDdmcuZ2Oif8Lreb74kWxL7K5w/Gs5miiU=;
        b=EpKsoNPURQDuqj6QuBDhaJNxIvHo38yLFsVKtTJdw94UIheQnmgdwN3czMSHoM1C3x
         r7Sw2tkkRP9oks//85pHTQm69Tuaz1GAZ9zbOD2d0c9UlRRMn2+7VVStouvdSHzIFZwC
         4weOjsezR6Z/lsjQ8CQkRnaLW+z2dZ51vw9CF/KBEoxHoQFTbZ5eCweRxtPk1Pv5td9k
         3yTN7VVNt4veW/KGCIUrMv44PigcyMGrWsblFTIOQrNmePxk+UpVdLN6pwFIG2jdOf1Z
         4EeDefvRsDnBdF8Do5aqTYbXc8qHkBvJPjTVz+5BAA1g20316/qP5itWCVjcAR4oy6fz
         ct/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728653069; x=1729257869;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8WBjL+tGnFDdmcuZ2Oif8Lreb74kWxL7K5w/Gs5miiU=;
        b=CJ935XZz+BaRTo68RsSqXw+xEfnC2qhS/CcmRtELMa7zyQaozwxeg7kCjB6CQHVWxU
         yh/PjMcUlV/y5TA+vaqbINHfV3mZlbCIdrhXlaHJMPACHO2FaMdAaelhyR8lqGcaIv6P
         XhOHOPwKARixP4jNRwEWE3fCD0b0hDlQ3MrNRvY9TPLr4WlixfNBawuwptg8QV3VDzey
         x9HLksFATJ1T17sKi+kA6MvTKb748B3Y/2yukvzjP255m7UNoi415F2GQqJexI1hZLZy
         g5okoFAe6mlDovPvEMDVcMT30ldnNVheCC2wYzq+mQaWggAbdAuBg/TupYdc/GrrCS8u
         Cing==
X-Forwarded-Encrypted: i=1; AJvYcCWF1A8Wt4fiQk89pU3zEF6+yGcVkuoMO/kUJgBukRicSALZDF+tgixB/+ylAIS805I7gTG1fNawvg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzvFDlAWBpdRwlcsudZZ7ZQSgaftbKEa8AAAL63w67jbJcHMLrV
	/gum90p3WyzjpysvG7NMCiZoydHVerRIUvXunBQN2Oe6K1J70AJoJi0692G3heI=
X-Google-Smtp-Source: AGHT+IHF19ikV7jmL12C340pK1iAO0S9tFu83pfPJMC8P921FfuQ5KnmILmxsomFZucElk94dIkOxg==
X-Received: by 2002:a05:6602:26d2:b0:82a:4480:badc with SMTP id ca18e2360f4ac-8379477a6b5mr352210739f.10.1728653069486;
        Fri, 11 Oct 2024 06:24:29 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dbadaa8cb2sm636559173.123.2024.10.11.06.24.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2024 06:24:28 -0700 (PDT)
Message-ID: <051e74c9-c5b4-40d7-9024-b4bd3f5d0a0f@kernel.dk>
Date: Fri, 11 Oct 2024 07:24:27 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 7/8] io_uring/uring_cmd: support provide group kernel
 buffer
To: Ming Lei <ming.lei@redhat.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <20240912104933.1875409-8-ming.lei@redhat.com>
 <b232fa58-1255-44b2-92c9-f8eb4f70e2c9@gmail.com> <ZwJObC6mzetw4goe@fedora>
 <38ad4c05-6ee3-4839-8d61-f8e1b5219556@gmail.com> <ZwdJ7sDuHhWT61FR@fedora>
 <4b40eff1-a848-4742-9cb3-541bf8ed606e@gmail.com>
 <655b3348-27a1-4bc7-ade7-4d958a692d0b@kernel.dk> <ZwiN0Ioy2Y7cfnTI@fedora>
 <44028492-3681-4cd4-8ae2-ef7139ad50ad@kernel.dk> <ZwiWdO6SS_jlkYrM@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZwiWdO6SS_jlkYrM@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/10/24 9:07 PM, Ming Lei wrote:
> On Thu, Oct 10, 2024 at 08:39:12PM -0600, Jens Axboe wrote:
>> On 10/10/24 8:30 PM, Ming Lei wrote:
>>> Hi Jens,
>>>
>>> On Thu, Oct 10, 2024 at 01:31:21PM -0600, Jens Axboe wrote:
>>>> Hi,
>>>>
>>>> Discussed this with Pavel, and on his suggestion, I tried prototyping a
>>>> "buffer update" opcode. Basically it works like
>>>> IORING_REGISTER_BUFFERS_UPDATE in that it can update an existing buffer
>>>> registration. But it works as an sqe rather than being a sync opcode.
>>>>
>>>> The idea here is that you could do that upfront, or as part of a chain,
>>>> and have it be generically available, just like any other buffer that
>>>> was registered upfront. You do need an empty table registered first,
>>>> which can just be sparse. And since you can pick the slot it goes into,
>>>> you can rely on that slot afterwards (either as a link, or just the
>>>> following sqe).
>>>>
>>>> Quick'n dirty obviously, but I did write a quick test case too to verify
>>>> that:
>>>>
>>>> 1) It actually works (it seems to)
>>>
>>> It doesn't work for ublk zc since ublk needs to provide one kernel buffer
>>> for fs rw & net send/recv to consume, and the kernel buffer is invisible
>>> to userspace. But  __io_register_rsrc_update() only can register userspace
>>> buffer.
>>
>> I'd be surprised if this simple one was enough! In terms of user vs
>> kernel buffer, you could certainly use the same mechanism, and just
>> ensure that buffers are tagged appropriately. I need to think about that
>> a little bit.
> 
> It is actually same with IORING_OP_PROVIDE_BUFFERS, so the following
> consumer OPs have to wait until this OP_BUF_UPDATE is completed.

See below for the registered vs provided buffer confusion that seems to
be a confusion issue here.

> Suppose we have N consumers OPs which depends on OP_BUF_UPDATE.
> 
> 1) all N OPs are linked with OP_BUF_UPDATE
> 
> Or
> 
> 2) submit OP_BUF_UPDATE first, and wait its completion, then submit N
> OPs concurrently.

Correct

> But 1) and 2) may slow the IO handing.  In 1) all N OPs are serialized,
> and 1 extra syscall is introduced in 2).

Yes you don't want do do #1. But the OP_BUF_UPDATE is cheap enough that
you can just do it upfront. It's not ideal in terms of usage, and I get
where the grouping comes from. But is it possible to do the grouping in
a less intrusive fashion with OP_BUF_UPDATE? Because it won't change any
of the other ops in terms of buffer consumption, they'd just need fixed
buffer support and you'd flag the buffer index in sqe->buf_index. And
the nice thing about that is that while fixed/registered buffers aren't
really used on the networking side yet (as they don't bring any benefit
yet), adding support for them could potentially be useful down the line
anyway.

> The same thing exists in the next OP_BUF_UPDATE which has to wait until
> all the previous buffer consumers are done. So the same slow thing are
> doubled. Not mention the application will become more complicated.

It does not, you can do an update on a buffer that's already inflight.

> Here the provided buffer is only visible among the N OPs wide, and making
> it global isn't necessary, and slow things down. And has kbuf lifetime
> issue.

I was worried about it being too slow too, but the basic testing seems
like it's fine. Yes with updates inflight it'll make it a tad bit
slower, but really should not be a concern. I'd argue that even doing
the very basic of things, which would be:

1) Submit OP_BUF_UPDATE, get completion
2) Do the rest of the ops

would be totally fine in terms of performance. OP_BUF_UPDATE will
_always_ completely immediately and inline, which means that it'll
_always_ be immediately available post submission. The only think you'd
ever have to worry about in terms of failure is a badly formed request,
which is a programming issue, or running out of memory on the host.

> Also it makes error handling more complicated, io_uring has to remove
> the kernel buffer when the current task is exit, dependency or order with
> buffer provider is introduced.

Why would that be? They belong to the ring, so should be torn down as
part of the ring anyway? Why would they be task-private, but not
ring-private?

>> There are certainly many different ways that can get propagated which
>> would not entail a complicated mechanism. I really like the aspect of
>> having the identifier being the same thing that we already use, and
>> hence not needing to be something new on the side.
>>
>>> Also multiple OPs may consume the buffer concurrently, which can't be
>>> supported by buffer select.
>>
>> Why not? You can certainly have multiple ops using the same registered
>> buffer concurrently right now.
> 
> Please see the above problem.
> 
> Also I remember that the selected buffer is removed from buffer list,
> see io_provided_buffer_select(), but maybe I am wrong.

You're mixing up provided and registered buffers. Provided buffers are
ones that the applications gives to the kernel, and the kernel grabs and
consumes them. Then the application replenishes, repeat.

Registered buffers are entirely different, those are registered with the
kernel and we can do things like pre-gup the pages so we don't have to
do them for every IO. They are entirely persistent, any multiple ops can
keep using them, concurrently. They don't get consumed by an IO like
provided buffers, they remain in place until they get unregistered (or
updated, like my patch) at some point.

-- 
Jens Axboe

