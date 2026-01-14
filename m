Return-Path: <io-uring+bounces-11718-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ABC49D20E6C
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 19:51:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0614430591CA
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 18:50:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60F362D5C7A;
	Wed, 14 Jan 2026 18:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EjlK3II5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A1F32571F
	for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 18:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768416614; cv=none; b=BnX5cH0AWfPEkt5cBrREhCwKOmW3ItO/lmaMT04L6KJ0i37jlfDabywMBdhlqI/aPkmHiIbm/w3xT5B7CGjzPR6MZWYyP+WCAtG0TBWMlnuK+lB8WZMDSaxF5e6LTRMa0FvBC6HF/QzXfXvhzhnwK4+QkJ8+TU+HyaYEaH0rJWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768416614; c=relaxed/simple;
	bh=7rcU/oakf3K99yeGXelFE23vsa7yMvXHOYdTrQcyXWc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XMCtV49i9vGHMsq4sOFb1Skf+dBkzpxVgdjt6YDF+ChAW5gkZFckTXH7300mg7S0bDaXUdX5nXMeQ6Z7rAevel4TRSsEnor9UerhiJlzhfY4ptuB8HIkJcMenofSFl4gBE/2ezMNSFXWT+DoNaYdnVmYtbXs5m6KGhf4SI73eFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EjlK3II5; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-477a2ab455fso1716945e9.3
        for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 10:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768416611; x=1769021411; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wFtqsmE5XZuEsb6b2DBhD16JeaZ/Z8weRvZd63oHxcI=;
        b=EjlK3II5wPVC4P7wRwBpyEPxojHu1USvJ3x8lhZQGxVyIH2qsBY77M2AXPZwVviw22
         VT2DjSK5tQHkmtUr0/rYcgfsx9YrIWQTEKt9oVPj8mLAjJ/SWzQHqWSFCXBmpuVyPRN9
         VA2Uy5/4ImmijFQ4ZcVbYqEWIcZH+/6wT10hCCUPXGMn2ddhK9SMTSmNWbM2GVEBbEDz
         P2VTqGDtPs7h54HlWJ/ysyuYb58Ld9tu8zFyEo9RMyPQuiwZ1EWo9NMl1KeHzOipqLUg
         VDd4HAvQpMGj4Qxa9Zn+kKwgZkRpxIr6A9vyj7Dfdgeo9MY5YG+VtmNxX4uuxCd3w1lo
         4mhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768416611; x=1769021411;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wFtqsmE5XZuEsb6b2DBhD16JeaZ/Z8weRvZd63oHxcI=;
        b=fzYaMY9mk1O+7fZDy6JN2eUHjLH3pdWbMdRzkM7l2fm9L6GbhkQbXggys5bPsP/S8i
         laYwLgjWyCeoGknJAFaaz1om6NcwuzlalGo8ZLIGtR3WW+3gP6/hygIbFd29I8Z9+ajI
         PZKeL0nWSClViwh+4kLPmNCk+FP+AaH+4ZTw3EIRAG2GG8YJRREC1rMzjf77wlZvOwPL
         YK2gMcAjCfG3+h2y6mpsM4O47NfRqYjMeqG/4W1jKGvRox1b9xedMVEry0PuS68TkrgI
         p2kvlVfwACgL6GkEH2K8VFrV+clJ2Um/KGpWfbdZCaj4l4i+WMyoY0NyZXzfyXVWXYig
         xVrw==
X-Gm-Message-State: AOJu0YwfRs/MrvGZRqSjnQkzZo0HhLINIzPMx8OnluK8RB2Jgnvg2Fcb
	8l537uZ7yU4/TGxX52K/hHsdFR0tJ42qah10xT1IFHrwQjMsDbIPSf/23R8tww==
X-Gm-Gg: AY/fxX5HYOo9xeRGuWe18pz3BotjN+BXjyLIKW/hH2Z8/CTrP4CqLFLIpo5Oq0+r1He
	DKRb0q4kfMB7xvgo6VwZay1ryk8NYUbGapB62dQSG+oDM25EEF2qkMQgCmsH86UTpLQ5aiKo57L
	7SOfs3Xud39H65NlmRqcGRFjILNenQI8LmN6zSHkK4AIAjDS6u4MQ4/B6LIOtlEeMJvghu8rIma
	9sZTqbzt7kxffRHE0YZn6XsmmtbUCktx3aUnQEBDwm9kywcBpfSrvbeL35zz3z3zqoFz4OtN5E+
	V/RMRI7LeTvUVgZKgBsVOWCY+jfItUqUFV1m06djvz9xamRr6T+/McuH2iQCPzpzX5aNatXOYV8
	iKqR7TZRJEVBDbrv8n2pL+RddLMA8n5G75I9rh5bTGTLwyTHLHxHPc3p2iCoMn8YwSxZWlTxxhF
	PW+r98gSVpVnfH6JegFFP0cf6SQRfv8t9hvLZTZQWkyrL8M+qIdCCzuATtpjMDvFDZR5OBE64UR
	uDOQW71ktAsAbEUqgRJetlB+mrqgy2eUH0+hDDgTS2Ad6Jui5wwnVlgE+/XG/OEJw==
X-Received: by 2002:a05:600c:8707:b0:477:a219:cdb7 with SMTP id 5b1f17b1804b1-47ee30693a6mr50768145e9.0.1768416610796;
        Wed, 14 Jan 2026 10:50:10 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f429071a2sm4727155e9.11.2026.01.14.10.50.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jan 2026 10:50:10 -0800 (PST)
Message-ID: <d8f24928-bcc8-4772-a9b2-d6d5d1bbca72@gmail.com>
Date: Wed, 14 Jan 2026 18:50:05 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 1/1] man: add io_uring_register_region.3
To: Jens Axboe <axboe@kernel.dk>, Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <6ba5f1669bfe047ed790ee47c37ca63fd65b05de.1768334542.git.asml.silence@gmail.com>
 <87ldi12o91.fsf@mailhost.krisman.be>
 <d3a4a02e-0bcc-41fd-994e-1b109f99eeaa@kernel.dk>
 <9f032fbc-f461-4243-9561-2ce7407041f1@gmail.com>
 <5f026b78-870f-4cfd-b78b-a805ca48264b@gmail.com>
 <c805f085-2e13-40ee-a615-e002165996c6@gmail.com>
 <adda36d5-0fe0-466c-a339-7bd9ffec1e23@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <adda36d5-0fe0-466c-a339-7bd9ffec1e23@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/14/26 17:23, Jens Axboe wrote:
> On 1/14/26 9:04 AM, Pavel Begunkov wrote:
>> On 1/14/26 14:54, Pavel Begunkov wrote:
>>> On 1/14/26 14:42, Pavel Begunkov wrote:
>>>> On 1/13/26 22:37, Jens Axboe wrote:
>>>>> On 1/13/26 2:31 PM, Gabriel Krisman Bertazi wrote:
>>>>>> Pavel Begunkov <asml.silence@gmail.com> writes:
>>>>>>
>>>>>>> Describe the region API. As it was created for a bunch of ideas in mind,
>>>>>>> it doesn't go into details about wait argument passing, which I assume
>>>>>>> will be a separate page the region description can refer to.
>>>>>>>
>>>>>>
>>>>>> Hey, Pavel.
>>>>>
>>>>> I did a bunch of spelling and phrasing fixups when applying, can you
>>>>> take a look at the repo and send a patch for the others? Thanks!
>>>>
>>>> "Upon successful completion, the memory region may then be used, for
>>>> example, to pass waiting parameters to the io_uring_enter(2) system
>>>> call in a more efficient manner as it avoids copying wait related data
>>>> for each wait event."
>>>>
>>>> Doesn't matter much, but this change is somewhat misleading. Both copy
>>>> args same number of times (i.e. unsafe_get_user() instead of
>>>> copy_from_user()), which is why I was a bit vague with that
>>>> "in an efficient manner".
>>>
>>> Hmm, actually the normal / non-registered way does make an extra
>>> copy, even though it doesn't have to.
>>
>> And the compiler is smart enough to optimise it out since
>> it's all on stack.
> 
> Not sure I follow these emails. For the normal case,
> io_validate_ext_arg() copies in the args via a normal user copy, which
> depending on options and the arch (or even sub-arch, amd more expensive)
> is more or less expensive.

In the end, after prep that is still just a move instruction, e.g.
for x86. And it loads into a register and stores it into ext_arg,
just like with registration. User copy needs to prepare page fault
handling / etc., which could be costly (e.g. I see stac + lfence
in asm), but that's not exactly about avoiding copies.

> For the registered case, it's a simple memory
> dereference. Doesn't cover the signal parts as I believe those are way
> less commonly used.
-- 
Pavel Begunkov


