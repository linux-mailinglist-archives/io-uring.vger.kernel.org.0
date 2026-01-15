Return-Path: <io-uring+bounces-11730-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5542FD24E4A
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 15:16:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DB8593004223
	for <lists+io-uring@lfdr.de>; Thu, 15 Jan 2026 14:14:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D490396D3C;
	Thu, 15 Jan 2026 14:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Dmw+xCnz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E6230FC39
	for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 14:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768486477; cv=none; b=adGo/egyhxKEWFr+XU82z9l2yj7wJZ4Ul2IjkwXPhdMdepGHm1dS6fzH2E4BRaXzwISvQdStaoAFPDCxggtq8tot9EQzYv2Vld3jKMw4uF8qbx10gTJfcSOoKrxp95KOo5c2BCvvPFmGMbF7uBFG4iMRfaiM1OOtug1PJG+E/tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768486477; c=relaxed/simple;
	bh=ByzgaxSAirkBj0i6U7A3Vm156SluqK5OLQeG32b7DxE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BY0+1zHm+mhnJNhOsMbx8g0bhhfvtOuRWWbzACswgL0AfVfXn18gi4w/AerC1V7Vs7h9buyzRl9FDY2mOOjCjQVeydiGPQBd19tvv4SegbFeAyudxXIjj6PjE9rZf33m766GYKD8jE5eKcr2MhMtgRd0D1cIsvDNsna4mh4cDsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Dmw+xCnz; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-4040996405eso565967fac.2
        for <io-uring@vger.kernel.org>; Thu, 15 Jan 2026 06:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768486474; x=1769091274; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aBU8rBWowG9Rc6V+1jXT0t2HqV4ZzI+gBAv1ZFMKIuU=;
        b=Dmw+xCnzLef9KgFNN0z8xSaMj54PMD7lXzgawOWOkVrAkPPxHt3gO5MBPfxGuot0+Z
         O5N7uNuS/RUZil0ARYHxfYc9OybBFUk9c+UHGweAWjJXb1lQhbdE6vjveD9dNgSO0gL8
         H6s/Aj5+n0ISqX1yRcPBTStldx3YGCcvgpo/DEG7Tms2slT16AHSPgtQW+EnCSt+yN8T
         Im7WWdD201fl9UnL6Ingi1GzYfC6dBZAHis2wdztDHys5eVQqQloh2Plf0cnOlCkzQo8
         0StWGM59GLXsytTlZznXhlcXawL4YccC8DyXue5d4PGvHYrOLG+QczdVWbfmoG3tXqjv
         bpOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768486474; x=1769091274;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aBU8rBWowG9Rc6V+1jXT0t2HqV4ZzI+gBAv1ZFMKIuU=;
        b=H8KxKCJxk0w2K9Y4K5Ikky/q2HqrxstgryhfvvOwbd6gNY/ci6gOq+c6fVM2ojNIeX
         WIHYrPlfjLdwqXEN1coStirks1NprKGQKDWTLvz125UWwv5LSFTE2oTSMUWnL2JgdWQt
         ndXokeVj5b881JrNGKz+DOiJXgNmjybK9vNhBU2J9N2Sa++DY9lIHaeu4wxb0IGfhXDc
         4VWdfNSU545xHKYG7ix2V+JnqhOb3bTOuMnmWEEpkKZfEjigbMMSkL3Owl6OQnF34per
         LwGSgIBlz729ttxdqioARZT5nMfFwpfVW82v00Iy/XHD+45UszWBU4p40fmlN3BRCas6
         PGXA==
X-Gm-Message-State: AOJu0Yz9qZTzrqHghShxsGA/lR6Rc60FlgkJj4xXyIMT/mzn8LfSgpoG
	P/jv+C7SVvxtsmFL2bUWqrp4sqHFNeUwvqVNQWrz+dSW5korEA39A6Os0fnJfa2+lTT5rYGt7W0
	88ZhT
X-Gm-Gg: AY/fxX5JSzfVdIV70FxCk3juWYSIl0JvWxYP1/3hSCjEEgcOwiOIygmawXu1I7O/3Ul
	2Y0EUFN6dg2ybJg9k0ekcqA/Vq8h5Lzya2D/pEMDiVATPbnXZEqiytQdE2O9hSIgYIQhR6doVs3
	k5mXHKx2DYX5UVSpCovmg+VOZW3OPJGP8GsnoRqViIZX8ceZ/UMJ1dZuuWuGWm9AwKh1bo31E69
	cRYLW3SzeT5AkZQgmwda38p6jLexMq/7ll+HKCx/vxFnzB4KsS9snfHc557HPYlW/4edf+xIY6f
	xxHFFzP6mWbbpmDGjwUC1d3xEb3fySiWGnwsyzc0AT2MMdubgEUYWLjI43BR1EvI6LfhDBwnR/N
	QZIAat3/i/Y3gHdcNQDOEc7CPC6JUikJboKKCmjbuviBPSNKtID0wEtE/en3O5CDjZ+yIHg4DvL
	Tl0fn7fzZyO720YLfeVg==
X-Received: by 2002:a05:6870:b3e7:b0:33f:b3dc:23cf with SMTP id 586e51a60fabf-40407184c94mr4359293fac.50.1768486473860;
        Thu, 15 Jan 2026 06:14:33 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3ffa4e3a7bfsm18501792fac.8.2026.01.15.06.14.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jan 2026 06:14:33 -0800 (PST)
Message-ID: <1c9a7c71-fc6d-4630-bfd5-f0e567d96e85@kernel.dk>
Date: Thu, 15 Jan 2026 07:14:32 -0700
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
 <988a3d72-a58b-45a4-8d98-8928de4f3ecf@kernel.dk>
 <53767b80-846d-47ee-a69b-f037a9a2d4da@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <53767b80-846d-47ee-a69b-f037a9a2d4da@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/15/26 6:06 AM, Pavel Begunkov wrote:
> On 1/14/26 23:53, Jens Axboe wrote:
> ...
>>>>> And the compiler is smart enough to optimise it out since
>>>>> it's all on stack.
>>>>
>>>> Not sure I follow these emails. For the normal case,
>>>> io_validate_ext_arg() copies in the args via a normal user copy, which
>>>> depending on options and the arch (or even sub-arch, amd more expensive)
>>>> is more or less expensive.
>>>
>>> In the end, after prep that is still just a move instruction, e.g.
>>> for x86. And it loads into a register and stores it into ext_arg,
>>> just like with registration. User copy needs to prepare page fault
>>> handling / etc., which could be costly (e.g. I see stac + lfence
>>> in asm), but that's not exactly about avoiding copies.
>>
>> Those are implementation details. The user copy is stac/clac, and then
>> the loads. This is what makes it more expensive. I don't want to be
>> writing about stac/clac in the man page, that's irrelevant to the user.
> 
> Confused why would you be thinking about putting that into the
> man page. I'm saying that it claims copy avoidance, but there is
> no difference in the number of copies. It's also uncomfortable
> that it's in a commit with my name attached, while the change
> wouldn't fall under the "language edits" note.

Sheesh let's turn down the sensitivity. If you want it changed, send a
patch. I'm trying to phrase it in such a way that it makes sense to
people without getting into too much detail. It avoids copying from
USERSPACE, which is the expensive part.

I think we've spent enough time on this detail at this point, no?

-- 
Jens Axboe

