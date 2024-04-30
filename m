Return-Path: <io-uring+bounces-1688-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB88E8B78F7
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 16:20:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07BFA1C22A80
	for <lists+io-uring@lfdr.de>; Tue, 30 Apr 2024 14:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40202176FAC;
	Tue, 30 Apr 2024 14:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RPKh3GZa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F091175546;
	Tue, 30 Apr 2024 14:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714486189; cv=none; b=pr9DFD3nLAC1b7kOx7LaBq2GpMwfnqNqBH4gX4yXCa+CgHvdwNzawkD83BmJMNZ5uV1HuBN/Dml0UF7k7oF64bF7p0JD2NUWeLmaYpA0QIXPyWVn1nEMRz6U7mKIbwh1jp7k/Cz21hhVY6sBuPHAfiUZ3flKkR7mmhMmDFCS20A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714486189; c=relaxed/simple;
	bh=ywRNwRPhovkbaiHNeMCGe2hhEGjds8H8k0o3to3GLD0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jtFLJROWscRtPEFQuiLBjp6NMTBVEhFrathjuvm75LPJtVydlnY7YP5jrNLCGfpR3Y972tpsgXcVdnC1aTjPGFUVOlJZ+OwvlsTH0lab5rMsWZxuV21wt/EUAVB+lJaGc2efSP7qBvdhKZ+nr1be9f6treY5PG0i+eDsuuC3ifg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RPKh3GZa; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a58e7628aeaso411867266b.2;
        Tue, 30 Apr 2024 07:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714486185; x=1715090985; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UIKU5NJILWu96wDQLrVFm+trxEpA0Lo8dt1L+Qv5jKs=;
        b=RPKh3GZakQBV44ajxS4bsXL3wgTayaVtKgRfPV7QhtXbwV4jDbc3msSGdqLkvpKZ/A
         mnPIgQ6s3DZAKFEoeIciVnl3/ZXwezMSdQFt+mHShmvrGholZDWLqJadAXkYAv0Xy/QW
         IDJW+r9nxhmwaULWxNJnML0EkSqKK/Z3oeWrfjglTw3Sml6rUr6PJJBQkozg6XRUfLJ6
         INSa1OPOM1qcqaN874xulSp4ELor1BF+cTFCWW98rkhUPQ3Exo30Bmg3NmOW/Mtw8TnI
         b95cnFYNBbtbXSgt/FFzVVq85CpAckQgpbf4uleo9Xqz1oCotplBmjFHXT36wJLRKxAe
         0ZBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714486185; x=1715090985;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UIKU5NJILWu96wDQLrVFm+trxEpA0Lo8dt1L+Qv5jKs=;
        b=QEcb54W2rswQIXfIZ4v2d4ydK+RkEggtbP2QhywRxUrI8nA7nhXHw39LxN8TFKit8v
         8gvUljLFQrViaWM+Om70AXFUSXPm7N14mx82VjVsmkaEXdXIyE/T7CPTjNjIVAJ8QT0B
         5A2CGFEDlY/vGBtpsON23n5zJkcq+oRs0znbiNIg6ZQ9dm2yEHI8tDFsDzqD85PwyxDh
         Ea21wRSkSK14AxBQvot7KJW9a3tETUs2fp0mAvCz4AIq0VAEFARudY4G2alx2mw6wTg2
         b4CKZacn1OgXqEeMdINzGJJsZf7h3swFstc08W2Z/v8vN3YV71KV+YvpRomR7ix9NfAe
         SuAw==
X-Forwarded-Encrypted: i=1; AJvYcCWvcSX0Re3C5/Vt6ZSY9wIGv6udyT0syG8zlUAvnVnK/nf8Ks6OqfGCL2zhuARAjRqjQNL6mWk8PYZDiSskOeUhzsmc2peXyjkOaDzagrp2uFACUrYsgJ1fRBSlrBZVyqnfGIrSwg==
X-Gm-Message-State: AOJu0YwNRkURkGCvrlVRBnT9pvF4/A0LQ+HnkJvMkLw2EO0OIO/+4U/u
	id80uEBKu2YG7LuFdTbL8m72SJXxIOrteXNQ9GYp2ponFEBSQRh1
X-Google-Smtp-Source: AGHT+IEw4ErQlPCYlAgTLlhRqgVLwnMMvXsVwYIWtEndpAGtCGvt+PQs3IuIoC4RZ8l7vZfMeUI1lg==
X-Received: by 2002:a17:906:718f:b0:a58:7b47:ad0d with SMTP id h15-20020a170906718f00b00a587b47ad0dmr1927360ejk.41.1714486185019;
        Tue, 30 Apr 2024 07:09:45 -0700 (PDT)
Received: from [192.168.42.188] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id gf16-20020a170906e21000b00a526fe5ac61sm15046205ejb.209.2024.04.30.07.09.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Apr 2024 07:09:44 -0700 (PDT)
Message-ID: <1b5007d4-2cac-4bbb-beb5-a1bad8be918e@gmail.com>
Date: Tue, 30 Apr 2024 15:10:01 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/9] io_uring: support user sqe ext flags
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>
References: <20240408010322.4104395-1-ming.lei@redhat.com>
 <20240408010322.4104395-3-ming.lei@redhat.com>
 <89dac454-6521-4bd8-b8aa-ad329b887396@kernel.dk> <Zie+RlbtckZJVE2J@fedora>
 <e0d52e3f-f599-42c8-b9f0-8242961291d0@gmail.com> <ZjBozhXCCs46OeWK@fedora>
 <81bc860f-0801-478b-adba-ea2a90cfe69e@gmail.com> <ZjDqb80OTfb6WzBp@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZjDqb80OTfb6WzBp@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/24 13:56, Ming Lei wrote:
> On Tue, Apr 30, 2024 at 01:00:30PM +0100, Pavel Begunkov wrote:
>> On 4/30/24 04:43, Ming Lei wrote:
>>> On Mon, Apr 29, 2024 at 04:24:54PM +0100, Pavel Begunkov wrote:
>>>> On 4/23/24 14:57, Ming Lei wrote:
>>>>> On Mon, Apr 22, 2024 at 12:16:12PM -0600, Jens Axboe wrote:
>>>>>> On 4/7/24 7:03 PM, Ming Lei wrote:
>>>>>>> sqe->flags is u8, and now we have used 7 bits, so take the last one for
>>>>>>> extending purpose.
>>>>>>>
>>>>>>> If bit7(IOSQE_HAS_EXT_FLAGS_BIT) is 1, it means this sqe carries ext flags
>>>>>>> from the last byte(.ext_flags), or bit23~bit16 of sqe->uring_cmd_flags for
>>>>>>> IORING_OP_URING_CMD.
>>>>>>>
>>>>>>> io_slot_flags() return value is converted to `ULL` because the affected bits
>>>>>>> are beyond 32bit now.
>>>>>>
>>>>>> If we're extending flags, which is something we arguably need to do at
>>>>>> some point, I think we should have them be generic and not spread out.
>>>>>
>>>>> Sorry, maybe I don't get your idea, and the ext_flag itself is always
>>>>> initialized in io_init_req(), like normal sqe->flags, same with its
>>>>> usage.
>>>>>
>>>>>> If uring_cmd needs specific flags and don't have them, then we should
>>>>>> add it just for that.
>>>>>
>>>>> The only difference is that bit23~bit16 of sqe->uring_cmd_flags is
>>>>> borrowed for uring_cmd's ext flags, because sqe byte0~47 have been taken,
>>>>> and can't be reused for generic flag. If we want to use byte48~63, it has
>>>>> to be overlapped with uring_cmd's payload, and it is one generic sqe
>>>>> flag, which is applied on uring_cmd too.
>>>>
>>>> Which is exactly the mess nobody would want to see. And I'd also
>>>
>>> The trouble is introduced by supporting uring_cmd, and solving it by setting
>>> ext flags for uring_cmd specially by liburing helper is still reasonable or
>>> understandable, IMO.
>>>
>>>> argue 8 extra bits is not enough anyway, otherwise the history will
>>>> repeat itself pretty soon
>>>
>>> It is started with 8 bits, now doubled when io_uring is basically
>>> mature, even though history might repeat, it will take much longer time
>>
>> You're mistaken, only 7 bits are taken not because there haven't been
>> ideas and need to use them, but because we're out of space and we've
>> been saving it for something that might be absolutely necessary.
>>
>> POLL_FIRST IMHO should've been a generic feature, but it worked around
>> being a send/recv specific flag, same goes for the use of registered
>> buffers, not to mention ideas for which we haven't had enough flag space.
> 
> OK, but I am wondering why not extend flags a bit so that io_uring can
> become extendable, just like this patch.

That would be great if can be done cleanly. Even having it
non contig with the first 8bits is fine, but not conditional
depending on opcode is too much.


>>>>> That is the only way I thought of, or any other suggestion for extending sqe
>>>>> flags generically?
>>>>
>>>> idea 1: just use the last bit. When we need another one it'd be time
>>>> to think about a long overdue SQE layout v2, this way we can try
>>>> to make flags u32 and clean up other problems.
>>>
>>> It looks over-kill to invent SQE v2 just for solving the trouble in
>>> uring_cmd, and supporting two layouts can be new trouble for io_uring.
>>
>> Sounds too uring_cmd centric, it's not specifically for uring_cmd, it's
>> just one of reasons. As for overkill, that's why I'm not telling you
>> to change the layour, but suggesting to take the last bit for the
>> group flag and leave future problems for the future.
> 
> You mentioned 8bit flag is designed from beginning just for saving
> space, so SQE V2 may not help us at all.

Not sure what you mean. Retrospectively speaking, u8 for flags was
an oversight


> If the last bit can be reserved for extend flag, it is still possible
> to extend sqe flags a bit, such as this patch. Otherwise, we just lose
> chance to extend sqe flags in future.

That's why I mentioned SQE layout v2, i.e. a ctx flag which reshuffles
sqe fields in a better way. Surely there will be a lot of headache with
such a migration, but you can make flags a u32 then if you find space
and wouldn't even need and extending flag.


> Jens, can you share your idea/option wrt. extending sqe flags?
> 
>>
>>
>>> Also I doubt the problem can be solved in layout v2:
>>>
>>> - 64 byte is small enough to support everything, same for v2
>>>
>>> - uring_cmd has only 16 bytes payload, taking any byte from
>>> the payload may cause trouble for drivers
>>>
>>> - the only possible change could still be to suppress bytes for OP
>>> specific flags, but it might cause trouble for some OPs, such as
>>> network.
>>
>> Look up sqe's __pad1, for example
> 
> Suppose it is just for uring_cmd, '__pad1' is shared with cmd_op, which is aligned
> with ioctl cmd and is supposed to be 32bit.

It's not shared with cmd_op, it's in a struct with it, unless you
use a u32 part of ->addr2/off, it's just that, a completely
unnecessary created padding. There was also another field left,
at least in case for nvme.

> Same with 'off' which is used in rw at least, if sqe group is to be
> generic flag.
> 
>>
>>
>>>> idea 2: the group assembling flag can move into cmds. Very roughly:
>>>>
>>>> io_cmd_init() {
>>>> 	ublk_cmd_init();
>>>> }
>>>>
>>>> ublk_cmd_init() {
>>>> 	io_uring_start_grouping(ctx, cmd);
>>>> }
>>>>
>>>> io_uring_start_grouping(ctx, cmd) {
>>>> 	ctx->grouping = true;
>>>> 	ctx->group_head = cmd->req;
>>>> }
>>>
>>> How can you know one group is starting without any flag? Or you still
>>> suggest the approach taken in fused command?
>>
>> That would be ublk's business, e.g. ublk or cmds specific flag
> 
> Then it becomes dedicated fused command actually, and last year's main
> concern is that the approach isn't generic.

My concern is anything leaking into hot paths, even if it's a
generic feature (and I wouldn't call it that). The question is
rather at what degree. I wouldn't call groups in isolation
without zc exciting, and making it to look like a generic feature
just for the sake of it might even be worse than having it opcode
specific.

Regardless, this approach doesn't forbid some other opcode from
doing ctx->grouping = true based on some other opcode specific
flag, doesn't necessarily binds it to cmds/ublk.

>>>> submit_sqe() {
>>>> 	if (ctx->grouping) {
>>>> 		link_to_group(req, ctx->group_head);
>>>> 		if (!(req->flags & REQ_F_LINK))
>>>> 			ctx->grouping = false;
>>>> 	}
>>>> }
>>>
>>> The group needs to be linked to existed link chain, so reusing REQ_F_LINK may
>>> not doable.
>>
>> Would it break zero copy feature if you cant?
> 
> The whole sqe group needs to be linked to existed link chain, so we
> can't reuse REQ_F_LINK here.

Why though? You're passing a buffer from the head to all group-linked
requests, how do normal links come into the picture?

-- 
Pavel Begunkov

