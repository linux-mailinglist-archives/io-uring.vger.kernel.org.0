Return-Path: <io-uring+bounces-11721-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B1CFAD21CD7
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 00:53:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B4059300C166
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 23:53:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF02C1C3BEB;
	Wed, 14 Jan 2026 23:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qkYxR8fB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D51E337111
	for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 23:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768434806; cv=none; b=S/dJAbtHSTzy1rPOxoStSeOa+weC0P8h8hvS0zMqJ7wN5ljqWC1vghAfnhk+iau4gfJjOyBnuZDncHUkJJZwQzbNeq50n9TqYQn5VWaF4PRz5GWr3GnZg1rFOoYpVqJzInXkJ+fyxRi9AW7a4W2rS4tAx4WUdj2Z/OLckKpd0MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768434806; c=relaxed/simple;
	bh=lHolmV74iwMgnXh8qZYe77RCqRv5qtu70hNankkSIzQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uHxd3cBWeyT1kV3CvpOUWW/IVSZMwek9z6xwKjqwjQuSeECJD9ImaJTsgZwNUgH3T0bQBSfQjJ0vQ12+00BOsiaHdP5FOqvu3J6sxISa1ujndBdhmzYcHw4Z0TK1bDFeW+e1S2bdXozq9dJA3FgmGlbnSWJ4QJw5/q62tBKg7XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qkYxR8fB; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7c6da42fbd4so221566a34.1
        for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 15:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768434803; x=1769039603; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TkJauVFI4dOdwenUB8ne2D9sa1QasiltjqDywWYIWg0=;
        b=qkYxR8fBu6lzsawVQg1N+wF1gaRhJ7/qVOkCC/NJCq2/eBVlTMilmTVt8St6GAFEdy
         oxQLz43IA/aUpGpCzgzbTiizyFUzPjdutNzoqj5oqgliKKcFikJlfxJmaGfLmy4Hbalz
         fyhJCoyL0IMP+fFSqSQwJ3IKVZwlgwo8tFVnOd3bLo93xI6/9tyPCLLuq6FMzrVLD7R9
         xRiB2JEgsUQWzltIdDy8iAWjYpCWyTfDA5eLgvk/1p6noP7mMjjX5gUUP1/IQOKLFax6
         7/UBjviRKkQ4LKUK7dPi8HvNyrXqzBIQvdx0kmG3HtiGh+KDmNdCIBWUeIfp6JR56ch2
         LMsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768434803; x=1769039603;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TkJauVFI4dOdwenUB8ne2D9sa1QasiltjqDywWYIWg0=;
        b=SCJxtuH/Ss+DIXPdyeinQTIUw7cy9gf7kzGjUiPFqb4ulQYcwjM1hwuq9iUG48vXxh
         N1tDDDiUo/OCxDUlcT6Ga1LaVHXoIklCx6r3br0ta2aOfPVbT9dncyw4+9bKoCiAoAbL
         zXsWgZmwICii8+Uq1nlcOA5D7BTUXXkTHgW3cjQlvX2Q+AvL7lD6unlMHYCZb733a3pU
         AkEOTAxA01K9DYegf/ETXp1ljNW2/RXRb2YSgyRc50b72+kHon2dg0AIBNe4ndeTVoCR
         qNCJwidb8VVE2ad+dJOPV3EsQPEFyluxqmRPsDb6PqJQ7udApkVn/3lpMKGHDB5698lg
         cnFg==
X-Gm-Message-State: AOJu0YxORfYNqazXiIC5Irc4rmGMhB62pq3Zgohp/1O4XtPZVe4v4Pdf
	ZnWxwCTrzA71stNp7T1SQLeng3hUWiC3y9taaaCRa/z1O7MnbdeW9BtMv3DlIFhoaKQ=
X-Gm-Gg: AY/fxX5+Q1nRMEa7boCTV9i5FUhWu3Q1af4EtCocd9KHr6C51H3ZyY3vjaRHXoqtycs
	29DUA3LnDF+LRnsNFbjOmQxjPUKHCsa6JZnYD8Ly0EOhPASWuWd6XRr+nHEcQ0P1t1LLkuikf5Q
	7go7+MZcLkmerg2oCJtF7theDrZnSSq6EbLWoKyWl13my3QweLUqOWj8RdH+xJurksjxgqR27lE
	e0RFeeSNWb0cwt7iAMTFaeIrlN3EdqGlR3xHqd7Bd3Zvwl8Gc6ADC3qfyHr2kNdqneYvMkQjUkF
	hdYzBQE42kMWY/i8gKvp0YKV29+fXS/tTlIHsnlryj7id9PHmFTWBxI30NgsCw+Sb+lhstBRMTk
	5m65L5UVK106Fp+UIRFo4bNPRRItCt21e26C4sJh55G12nSyTRLNv3Yf9P2n2TPBcEKUxvDRnq1
	6jn6a8w2P0
X-Received: by 2002:a05:6820:1ca2:b0:660:fdeb:12ca with SMTP id 006d021491bc7-661005f53camr3047388eaf.10.1768434803617;
        Wed, 14 Jan 2026 15:53:23 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6610df9254asm679000eaf.14.2026.01.14.15.53.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jan 2026 15:53:22 -0800 (PST)
Message-ID: <988a3d72-a58b-45a4-8d98-8928de4f3ecf@kernel.dk>
Date: Wed, 14 Jan 2026 16:53:21 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 1/1] man: add io_uring_register_region.3
To: Pavel Begunkov <asml.silence@gmail.com>,
 Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <6ba5f1669bfe047ed790ee47c37ca63fd65b05de.1768334542.git.asml.silence@gmail.com>
 <87ldi12o91.fsf@mailhost.krisman.be>
 <d3a4a02e-0bcc-41fd-994e-1b109f99eeaa@kernel.dk>
 <9f032fbc-f461-4243-9561-2ce7407041f1@gmail.com>
 <5f026b78-870f-4cfd-b78b-a805ca48264b@gmail.com>
 <c805f085-2e13-40ee-a615-e002165996c6@gmail.com>
 <adda36d5-0fe0-466c-a339-7bd9ffec1e23@kernel.dk>
 <d8f24928-bcc8-4772-a9b2-d6d5d1bbca72@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d8f24928-bcc8-4772-a9b2-d6d5d1bbca72@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/14/26 11:50 AM, Pavel Begunkov wrote:
> On 1/14/26 17:23, Jens Axboe wrote:
>> On 1/14/26 9:04 AM, Pavel Begunkov wrote:
>>> On 1/14/26 14:54, Pavel Begunkov wrote:
>>>> On 1/14/26 14:42, Pavel Begunkov wrote:
>>>>> On 1/13/26 22:37, Jens Axboe wrote:
>>>>>> On 1/13/26 2:31 PM, Gabriel Krisman Bertazi wrote:
>>>>>>> Pavel Begunkov <asml.silence@gmail.com> writes:
>>>>>>>
>>>>>>>> Describe the region API. As it was created for a bunch of ideas in mind,
>>>>>>>> it doesn't go into details about wait argument passing, which I assume
>>>>>>>> will be a separate page the region description can refer to.
>>>>>>>>
>>>>>>>
>>>>>>> Hey, Pavel.
>>>>>>
>>>>>> I did a bunch of spelling and phrasing fixups when applying, can you
>>>>>> take a look at the repo and send a patch for the others? Thanks!
>>>>>
>>>>> "Upon successful completion, the memory region may then be used, for
>>>>> example, to pass waiting parameters to the io_uring_enter(2) system
>>>>> call in a more efficient manner as it avoids copying wait related data
>>>>> for each wait event."
>>>>>
>>>>> Doesn't matter much, but this change is somewhat misleading. Both copy
>>>>> args same number of times (i.e. unsafe_get_user() instead of
>>>>> copy_from_user()), which is why I was a bit vague with that
>>>>> "in an efficient manner".
>>>>
>>>> Hmm, actually the normal / non-registered way does make an extra
>>>> copy, even though it doesn't have to.
>>>
>>> And the compiler is smart enough to optimise it out since
>>> it's all on stack.
>>
>> Not sure I follow these emails. For the normal case,
>> io_validate_ext_arg() copies in the args via a normal user copy, which
>> depending on options and the arch (or even sub-arch, amd more expensive)
>> is more or less expensive.
> 
> In the end, after prep that is still just a move instruction, e.g.
> for x86. And it loads into a register and stores it into ext_arg,
> just like with registration. User copy needs to prepare page fault
> handling / etc., which could be costly (e.g. I see stac + lfence
> in asm), but that's not exactly about avoiding copies.

Those are implementation details. The user copy is stac/clac, and then
the loads. This is what makes it more expensive. I don't want to be
writing about stac/clac in the man page, that's irrelevant to the user.

-- 
Jens Axboe

