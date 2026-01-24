Return-Path: <io-uring+bounces-11916-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KBOoHF/1dGnI/QAAu9opvQ
	(envelope-from <io-uring+bounces-11916-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 17:37:51 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C070E7E234
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 17:37:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4D48F30053EB
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 16:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C291F1DA60F;
	Sat, 24 Jan 2026 16:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K49PeY9u"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BA41A304A
	for <io-uring@vger.kernel.org>; Sat, 24 Jan 2026 16:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769272668; cv=none; b=jvV6PzQ1AxJZmQqGzcJD/qNMmYxCkPPsuk6axltPxoPJF/0B7kWb5pDLE39IcBcnFL6meUQVBXsD2RSCy+dXZ5kNaOsKmBKU88pN6No95TzABkrhrr8wGNrvBTmVsE5Y2k1JRMXJvNyUoP8LQwW2ZvojUvEnC07ya46V/Ws1hGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769272668; c=relaxed/simple;
	bh=fn4GjR7sEiJioorwSbXUnRoVxPznoqVleQ6W3ibZE14=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=X5QXjM7YQAJ0MUfE452wILJrJXnEQoMKFIHwsYalIK8UIMFxo53GyctVor9P1zcyRA60jhAZa+ehXp7bFaScJpNXLVoxFW5NvggvkhtHEGYFk/lkjeoYpB1reqWQHrYHIV42k9604laKRCsMyYf30GrhQQ52QSzs7MBRQI6INao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K49PeY9u; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-435903c4040so1968846f8f.3
        for <io-uring@vger.kernel.org>; Sat, 24 Jan 2026 08:37:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769272666; x=1769877466; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gKt+Qz6/gI7xyFYEiyB3c0ACyr9ruMyvPxLmlO9/7JA=;
        b=K49PeY9u1XjvzW6GFqVVRJ1RSX530QrXLc+fuYKbWAOFwYue+57bGjOc3A8IzMZBCs
         kN+W+9GMHpBkl+weBWFmNV3OSxwlc7wWCyL3J1wDI3mNjR64VrXBHYJUAhzKoh/M6O0G
         9+fuqFvOGbxgVsRVSKuMO8x6zELlGRNaWOGgVMB09Xu2hek1CiAYndHKjYFqkmTZbwhi
         ndc642es8r5GZT6vFR+rlUf51QmYzXuAI4QyEsV+LcDjczvysfRUo4qu/0/wba0lYJXY
         41KHG7IVh2ICQsRHL/o1j7nPgkmbuUIwGHFmyOw6uVHgk1jiLckbRGahCTuG9e8M/PNJ
         ZOFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769272666; x=1769877466;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gKt+Qz6/gI7xyFYEiyB3c0ACyr9ruMyvPxLmlO9/7JA=;
        b=cBu5LqSIlyTP9MC5wjP7limvX1aEKAYgoAwunEpj6AyUEhPajobSbqLPBkI4JnrkSI
         drnDqNi462tzAHVySNlrl3Sy9xuGUpeusnJ909LnsssOWQbV6VfYCFoBEyO57wj04keP
         mwknZAtPt3QllXLRwEXtLi1GxImKMHdBDjzy+CY9wrSxHZkN+qGAyEUfL8ym+/R1aW2x
         WcUZxWVLrrlPaQkxsdQVVFCXg6xgYaj8Teojl/2Fz4HhLZ6b6Z0WG3my2zeXEHsLSehc
         g+QjOgIC1lhIHKPP38K70vfVVp3s72WC1f26c1FD2mBqpoauhMVAh3O08Icc8MXJUl8o
         wMXg==
X-Forwarded-Encrypted: i=1; AJvYcCXFTcQSByyyAgIKT8oEBF7qjthcZv77ZCsLMIExp8UmxCCQ35uZKS5m96dcbgNRsi8zrsvxC2ujQw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwQu2POgObgj5LU1I6j+uqE/LPEKWHzOSq6Qnm3TKdYCr+HfSTl
	2j5cb69thfpcB0IH57tWqROE0k4Ny0NwBGKyOM9DcX8UJtN6DbXLjF1Jz5U8cA==
X-Gm-Gg: AZuq6aLi+jWAXl9SNG/OoNEbBQyFmERYiD6KDDN+QQYTqtmgGutQH/FQmpMDOl7z2ZK
	kB4jlcgYzT20E28hd3KK6XASpVepzyhFrxuIEVSobIZscBrNO1VyRYN6R2/H28ImQueN9cWwg53
	pRIJEIMlESjNpGhejgdSfMPLHRGbKfwxgWvzHtLJg6kERa4ogo8UvU1FzQvgiEl9NIU+7ggy8yG
	4z0KgisMz2ehSrdMavUilg60GpWlrjErrz+KdJwTvtLA4U/bleRUHsDQBWK3hXznYsNOh1t6BNQ
	GoaPiVmeBKQVA+aFzf5AR9u0LyTmQi1CN+Ogmf/7Gj6Fozq2W8tYLQFp7NV62KAlV8C/Cjn+o7T
	3IVRsu8XeNrgjiuJZ8A5OkDuiYik5pmg4yUQ187YjqA5S5NwyVNabVyvtt6cNTAKOdAmxr1Md/e
	q7TGWR6wucptoaXhNzVLxi6zIWjWIJGLIB99AlAtW6MLuHq4AlGGC4HedMhPiD3Ub3RAbc8SDNk
	q7pnZdErWzsxgjnlqjFxjY4y8PcGbXM8fuYHwFqz86AJHo546WK/59Oy/wPIKeIGg==
X-Received: by 2002:a05:600c:8b09:b0:471:1765:839c with SMTP id 5b1f17b1804b1-4804c9afc3amr106144025e9.20.1769272665572;
        Sat, 24 Jan 2026 08:37:45 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804d61f1f8sm54540925e9.5.2026.01.24.08.37.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jan 2026 08:37:44 -0800 (PST)
Message-ID: <e3352f58-071c-447a-922d-85262d0c86e4@gmail.com>
Date: Sat, 24 Jan 2026 16:37:43 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 0/2] Add support for IORING_SETUP_SQ_REWIND
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1769034107.git.asml.silence@gmail.com>
 <176912275112.522897.5400530813917730862.b4-ty@kernel.dk>
 <517fc5f0-5e6d-46ef-800d-9ef4428278a1@kernel.dk>
 <d106a68d-e981-4239-b0db-21a311ec03a3@gmail.com>
 <2d2da3b2-74c6-4605-8d13-3f0cdc67191e@kernel.dk>
 <9c10b8e7-d64c-491a-96b3-fc26863e0dbf@gmail.com>
 <30ee2371-f82f-4b29-9276-71b8cc12b87d@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <30ee2371-f82f-4b29-9276-71b8cc12b87d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-11916-lists,io-uring=lfdr.de];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com]
X-Rspamd-Queue-Id: C070E7E234
X-Rspamd-Action: no action

On 1/24/26 15:12, Jens Axboe wrote:
> On 1/24/26 3:44 AM, Pavel Begunkov wrote:
...
>>>> The head should already be zero. Actually, sounds like the get_sqe
>>>> hunk from the patch is not needed either.
>>>
>>> Yeah agree, I think they are both false alarms. Might warrant a comment
>>> though. Or maybe we just fold it into io_uring_load_sq_head()?
>>
>> What I'm implying is that the
>>
>> +    if (!(ring->flags & IORING_SETUP_SQ_REWIND))
>> +        head = io_uring_load_sq_head(ring);
>> +
>>
>> change from the original patch for normal 64B _io_uring_get_sqe()
>> doesn't seem to be necessary. I need to take a look, but that's
>> a good thing since the function is somewhat frequently called and
>> inlined.
>>
>> That would leave __io_uring_flush_sq() to be the only place
>> checking the flag, so maybe comments would better to be put
>> there.
> 
> If you have time, would you mind checking the current repo and sending a
> patch? Looks like I messed up a bit and committed some of these bits
> with:

I'll take a look a bit later, but removing should be fine
unless liburing overwrites the sq head.

-- 
Pavel Begunkov


