Return-Path: <io-uring+bounces-9181-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 32005B30156
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 19:46:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1E56AC1966
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 17:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 249A2221540;
	Thu, 21 Aug 2025 17:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LPhr5x0W"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C7A1EB5B
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 17:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755798370; cv=none; b=RrWOlhZEnGpUmp8Lui5Ei2wWlOALVZFagEsddbylVh11ETZmqXXK7B20Z0e50WfOowO4IQEqcfE43qShDl9HSu/KK1XjXLXqKL0sZugqlkOvIh1qZerL9+vyjqphdTRWoZh9CrdcsXHIHjG2FuXC+3ntUBbqSkKDAO7aU/fQ5Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755798370; c=relaxed/simple;
	bh=9DvRey2lP14QkFcVj/q0N8fsTMqzOK7vwIc+H6vQoM0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=E89PT2mMQMbGvUnVAfH/EjP4u8/Uk/f94RZ2S5OoeglsLLeKxXjWw4Jb6laS9m1lv+wW16AWsl05C2t3BJeMNhSaY5M8m1FOWPXn1diIsYIcgIPSrmgCpNTUu73TqxZwhj1G8IPTWn4ME0YAh7BE0WBhNNMbOE10A1Uqp1Z9zTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LPhr5x0W; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3e584a51a3fso6731115ab.2
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 10:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755798365; x=1756403165; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+0S5OHl0lw7IAFn+2R8CIFib5OkNFL11pU3MRipekeE=;
        b=LPhr5x0WKrk5GyQJwHeGnCAmYwAHdgrNUdGSO3IXJ/qCf4l5hIYwaTNWDMr72Wr7iG
         QnZbh81mgKa8GzzwtRYYlfrI/Y6pd3Fz/Gc7V8npRPfXcwUa9mDpORX5QaacXj7qZrGT
         vUzcYG8Lr2HXF6tXYMfkt14/15/RtSnn87JexEnMQDVl4m9szH6vERV1W3+sXiiJ3J0X
         JQSjXFDti2EMpUiwBFzNsv7GCS35OI28Z8XhB+fEkAZ7egidNWJaMyg8bhkA1rMCsy3B
         0RLpeRiie6GW6nzgeUnpFh1Rt2dWkx+41UTK0BhTGikNnsOo4+TWFjNDW7QiXWZmqAvR
         2wTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755798365; x=1756403165;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+0S5OHl0lw7IAFn+2R8CIFib5OkNFL11pU3MRipekeE=;
        b=e9e+fd32Xz90ZfL9FxOYXqVXz08l/QdctX3wOk5SOEBNVIOZ+z76wQLSqo4EAharF/
         rJJxbisl89b40FtrZm0egD9EX5iYiPLeG0cJGp/zV6sp7DKEBWzbMwiNxuX/pgzeWcDI
         efhy1TunPeFz1agdT3Y5LHzFjoHj/CquM/qW73yNMnlGml5/ll3evoO3ymLEjWicf/qx
         rvO3qeBK6DSd9hnW8B7PmV2UHzPBATtdO5sHErR89J4MPq0HXaCsBg/J9XqVV1TadB3/
         WsABR73vcVfzZ/ebbh6OgFYtLBAE8dKIZXA3jaJUs9aU7UTonx5b0a6Ns3in2FhJy5Up
         DizA==
X-Gm-Message-State: AOJu0YzTdQ7jQNgYSC0NXt9bqVxHmb6owAKM1bpXW9Q7nQ0lNZiEeNmK
	esx06SxEu3YP/Xcx5vDzAEbu4WQR3+CHGaQEMDGe8wVM1F1GnbLH8tFF076awfzCc8T7rp5VmiN
	dJFrg
X-Gm-Gg: ASbGncswr9yL//ZJdy+2Ygt3rHyg7A1ne9xdgOkKtjBu35k5OKyyokYnqWJpUXSCys0
	5/jDpklcCbth6rBS8CB+tJPcG0qbW0qD9b/BnGfDVlJefVUlgu/et4fSWYzne7GVQ6enwWybBRw
	pA5VR8lDcW82i651LRQjTDWtmOPSNDa5U/5/DZCbwJBR4NR3jctHUT3+0/t6nTwfcYFqWpgjpLi
	LrFwkK/7aWVuGTgjXm2hz8/swDz7I610C5FEXua5GkbmVI7T9T3DyL7CnzfCe0qAoA8B3ajIHZU
	lNyfoQ4xuXB3WCp9skU0qW0Yx9jkkQrih6FaXTZt2Bi8nMNXofN5hHSk3gOBaqIoPeVvc8hvA3p
	ik5A2yALNQZ8UDt8FuBbUiQdwnT0qZg==
X-Google-Smtp-Source: AGHT+IHrd1qOZpH1zBihTDy+KLh07BejaS+REDktfsInw2aw+OGpAm6luNSAY7cBTpjKwDde5L5/ew==
X-Received: by 2002:a05:6e02:184e:b0:3e5:6bc6:4dcf with SMTP id e9e14a558f8ab-3e9209c64a8mr4028715ab.7.1755798365201;
        Thu, 21 Aug 2025 10:46:05 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e699e569a4sm17305345ab.0.2025.08.21.10.46.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 10:46:04 -0700 (PDT)
Message-ID: <670929ea-b614-40cf-b5cc-929a39d9e59d@kernel.dk>
Date: Thu, 21 Aug 2025 11:46:03 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET v2 0/8] Add support for mixed sized CQEs
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org, Keith Busch <kbusch@kernel.org>
References: <20250821141957.680570-1-axboe@kernel.dk>
 <CADUfDZragMLiHkkw0Y+HAeEWZX8vBpPpWjgwdai8SjCuiLw0gQ@mail.gmail.com>
 <6145c373-d764-480b-a887-57ad60f872e7@kernel.dk>
 <CADUfDZpPP2FR1X9hVSkhbtQs=2wtXkeXRBjPDXA9ShSCU0PM2w@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZpPP2FR1X9hVSkhbtQs=2wtXkeXRBjPDXA9ShSCU0PM2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/21/25 11:41 AM, Caleb Sander Mateos wrote:
> On Thu, Aug 21, 2025 at 10:12?AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 8/21/25 11:02 AM, Caleb Sander Mateos wrote:
>>> On Thu, Aug 21, 2025 at 7:28?AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> Hi,
>>>>
>>>> Currently io_uring supports two modes for CQEs:
>>>>
>>>> 1) The standard mode, where 16b CQEs are used
>>>> 2) Setting IORING_SETUP_CQE32, which makes all CQEs posted 32b
>>>>
>>>> Certain features need to pass more information back than just a single
>>>> 32-bit res field, and hence mandate the use of CQE32 to be able to work.
>>>> Examples of that include passthrough or other uses of ->uring_cmd() like
>>>> socket option getting and setting, including timestamps.
>>>>
>>>> This patchset adds support for IORING_SETUP_CQE_MIXED, which allows
>>>> posting both 16b and 32b CQEs on the same CQ ring. The idea here is that
>>>> we need not waste twice the space for CQ rings, or use twice the space
>>>> per CQE posted, if only some of the CQEs posted require the use of 32b
>>>> CQEs. On a ring setup in CQE mixed mode, 32b posted CQEs will have
>>>> IORING_CQE_F_32 set in cqe->flags to tell the application (or liburing)
>>>> about this fact.
>>>
>>> This makes a lot of sense. Have you considered something analogous for
>>> SQEs? Requiring all SQEs to be 128 bytes when an io_uring is used for
>>> a mix of 64-byte and 128-byte SQEs also wastes memory, probably even
>>> more since SQEs are 4x larger than CQEs.
>>
>> Adding Keith, as he and I literally just talked about that. My answer
>> was that the case is a bit different in that 32b CQEs can be useful in
>> cases that are predominately 16b in the first place. For example,
>> networking workload doing send/recv/etc and the occassional
>> get/setsockopt kind of thing. Or maybe a mix of normal recv and zero
>> copy rx.
>>
>> For the SQE case, I think it's a bit different. At least the cases I
>> know of, it's mostly 100% 64b SQEs or 128b SQEs. I'm certainly willing
>> to be told otherwise! Because that is kind of the key question that
>> needs answering before even thinking about doing that kind of work.
> 
> We certainly have a use case that mixes the two on the same io_uring:
> ublk commit/buffer register/unregister commands (64 byte SQEs) and
> NVMe passthru commands (128 byte SQEs). I could also imagine an
> application issuing both normal read/write commands and NVMe passthru
> commands. But you're probably right that this isn't a super common use
> case.

Yes that's a good point, and that would roughly be 50/50 in terms of 64b
vs 128b SQEs?

And yes, I can imagine other uses cases too, but I'm also finding a hard
time justifying those as likely. On the other hand, people do the
weirdest things...

>> But yes, it could be supported, and Keith (kind of) signed himself up to
>> do that. One oddity I see on that side is that while with CQE32 the
>> kernel can manage the potential wrap-around gap, for SQEs that's
>> obviously on the application to do. That could just be a NOP or
>> something like that, but you do need something to fill/skip that space.
>> I guess that could be as simple as having an opcode that is simply "skip
>> me", so on the kernel side it'd be easy as it'd just drop it on the
>> floor. You still need to app side to fill one, however, and then deal
>> with "oops SQ ring is now full" too.
> 
> Sure, of course userspace would need to handle a misaligned big SQE at
> the end of the SQ analogously to mixed CQE sizes. I assume liburing
> should be able to do that mostly transparently, that logic could all
> be encapsulated by io_uring_get_sqe().

Yep I think so, we'd need a new helper to return the kind of SQE you
want, and it'd just need to get a 64b one and mark it with the SKIP
opcode first if being asked for a 128b one and we're one off from
wrapping around.

-- 
Jens Axboe

