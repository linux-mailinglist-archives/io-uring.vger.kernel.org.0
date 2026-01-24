Return-Path: <io-uring+bounces-11907-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id F7Q+EqiidGnz8AAAu9opvQ
	(envelope-from <io-uring+bounces-11907-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 11:44:56 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 95C727D458
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 11:44:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DB61030097E1
	for <lists+io-uring@lfdr.de>; Sat, 24 Jan 2026 10:44:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A36F23BCE3;
	Sat, 24 Jan 2026 10:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DZys+2oD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B981522579E
	for <io-uring@vger.kernel.org>; Sat, 24 Jan 2026 10:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769251493; cv=none; b=SSiOSzSM+HUViF8pMKFtagBxyu7aEyBW0vIrOCCHhRKwv9vCMHeco7EdUjA+fJ67h0wtGK1gHYVjSqOlWWflYWHILYa7+V8UIcpuDfkftw8wy5F6KHfAsk651o+gIdbyDx9g0l3EsuHIioV+ypXdxTLPVMkPHYzl/9o6pN6/Nbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769251493; c=relaxed/simple;
	bh=E9yBKx0fefNGwsalNaIbzgdp9yQTVkHKNxhOX2f3T1k=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=CBcJGQUJTBqs23fj6YSVXhCCo9KMzKmKpmYX4BvNAZicXRMIFX3HJYFNvHj9T1q0t/Nv7QsjUQvBuUnqGCB2TDOCkXrDnzNKLkXnAZDHtrmJCLGw5sqD1pkIH8fiU1CbN3mUmZQ/prD8GAzj9tsSj9SpnNvK02dQOFFIdhlg1fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DZys+2oD; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-480142406b3so20499795e9.1
        for <io-uring@vger.kernel.org>; Sat, 24 Jan 2026 02:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769251490; x=1769856290; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uEtW9qKL0sdhJsFbY6GgM6jCB1uD4PusmuRJWIXUWhY=;
        b=DZys+2oDyyMLXmQYZ3R5yDmbJyz5VZbFLWdbYLoskT2MWn3OGwoQnIcDwIWpjsW4G8
         641mY4S1FKMzqlGXNtbv0uW19O76RqLc1cfinuYeDxvoLslABxqmM6vmnbhu2055UIb5
         H4d6aqJHSXU88tKetMUdqbT9NbNhFJAXpsaPGm8Mrqk4p9gQviLJAdcFtZBQgdiplXqB
         y67b9/IeSWDVNp60zh7ku1bcVq6zvsSP5w4/F7ZbGm7/VS6uT/tFV7t9nOGhTHxTAU4n
         CcdepPGECaqtVbIROJLtPYNHPoTvgeBAFACsaS6j8XnvO05bw+xx0TvJMFSjTzFxJggn
         AAAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769251490; x=1769856290;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uEtW9qKL0sdhJsFbY6GgM6jCB1uD4PusmuRJWIXUWhY=;
        b=qcvQBhOxrlufwli9m0wNFI8J8XVMN1uEYEAMzdFXLxhGismBusRecf30vv96BI8zDu
         1lIXV/5HEsrcVhrD1WuhCzv5HJc3CANi3zK2ENhBXYDa0JlI91I6psXZiZZjJSKy/4mj
         T+/pqBw0jJlDUeGHAqA5F3dpY7b0HEljSdSNW5c+HaBUiQkVFjt4SbIgdo+ChTrPy6cO
         +lQd90g8q2vJGnMMr9V/CcTJXEyIEXUxU3N2vBMSyKHiYOnmpd6ENck9uAYCGGkyhjU7
         xiFpmjhYwkhQ5Q4ZDtrWhq6b0m2DxI43L77SVa3kNGJlIMrqycyUMlP8KP14qQYBdsh7
         ev3g==
X-Forwarded-Encrypted: i=1; AJvYcCWFHgyv1EURgmCzxdRMmQWWoEky8sAdrj6wN5CNNs4qKwDjjF8jm3nonUqoGDm3LJkgZZNV8/s2jw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6rYSC7/wN7KdjdsPgzo+kon2WAGA0JpUJygwjySFVwVTwg424
	695TJM70jFTxYuS/j84IuDXpc2NM+FBABxcn2UuUvoFdl+9NHFlwA4taphCuGg==
X-Gm-Gg: AZuq6aK0i3J8AM0+Yd7anA3ZwICwbfdpH3sd7sP/deRY0k/YR7/keUoVExcY1vD3EF8
	REQmWKz28GCgMbiJmXTP7zxneKi5hclRmW3BlmaOg1JSi4UzCHnmvg2MPAanjOrVOvZKy9onBXT
	pUEoUerdnpJU3VnleUXRjJ7HHxWNqmUzZFB6dpqsHdn7F+RX3PvQQ1vEL3dJi8Z+LTttWrewMSf
	p5Q30eVq5a6ugkacV/GnPFoTDafRce03QuxLgG24qFf57CDBhSP36ezVwTDM3K3mUe3feNnDawt
	Ss0GLOGC1gbKuuecv9fSDagplflei8i8EAKOr0inQIyHMkCdXgliPGuz7mny8HbVimmjwGLZ0Ja
	w+2LGaAcTwWOoxPuaZ1XUZCOGNv2QVbF7n96RWAmfuJ3iCgssGaIrTAKPW8w+5NF4W3fpUS0xQp
	qkL6JiQC+iUrohTFkLkkYnxC5QxKTivslokEJOuhnkHb6l6mNpKglJppzWLrTe02rcb2fKWBNGj
	8J+JvP9x0up8Kh8tSEzcCXRjpu6pN1UeRXrNAolUbPDMfyA0g92czLBEDB8ULAo8irClyAqkqZ3
X-Received: by 2002:a05:600c:4fcb:b0:47e:e2b0:15b8 with SMTP id 5b1f17b1804b1-4804c944f2dmr92391185e9.4.1769251489919;
        Sat, 24 Jan 2026 02:44:49 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4804dbe1fb8sm44160765e9.20.2026.01.24.02.44.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 24 Jan 2026 02:44:49 -0800 (PST)
Message-ID: <9c10b8e7-d64c-491a-96b3-fc26863e0dbf@gmail.com>
Date: Sat, 24 Jan 2026 10:44:47 +0000
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <2d2da3b2-74c6-4605-8d13-3f0cdc67191e@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-11907-lists,io-uring=lfdr.de];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com]
X-Rspamd-Queue-Id: 95C727D458
X-Rspamd-Action: no action

On 1/23/26 19:04, Jens Axboe wrote:
> On 1/23/26 7:14 AM, Pavel Begunkov wrote:
>> On 1/22/26 23:05, Jens Axboe wrote:
>>> On 1/22/26 3:59 PM, Jens Axboe wrote:
>>>>
>>>> On Wed, 21 Jan 2026 22:23:20 +0000, Pavel Begunkov wrote:
>>>>> Add liburing support and tests for IORING_SETUP_SQ_REWIND.
>>>>>
>>>>> Pavel Begunkov (2):
>>>>>     src/queue: Add support for non circular SQ
>>>>>     tests: add SETUP_SQ_REWIND tests
>>>>>
>>>>> src/include/liburing.h          |  5 ++++-
>>>>>    src/include/liburing/io_uring.h | 12 ++++++++++++
>>>>>    src/queue.c                     |  5 +++++
>>>>>    test/test.h                     |  2 ++
>>>>>    4 files changed, 23 insertions(+), 1 deletion(-)
>>>>>
>>>>> [...]
>>>>
>>>> Applied, thanks!
>>>>
>>>> [1/2] src/queue: Add support for non circular SQ
>>>>         commit: c22129cf0b8c936eb478d920ef84e53d89c6a5cc
>>>> [2/2] tests: add SETUP_SQ_REWIND tests
>>>>         commit: 346c063d16bda52f02d00feb744aafe35b4002a9
>>>
>>> Hmm I do think you're missing some spots though, no?
>>>
>>> diff --git a/src/include/liburing.h b/src/include/liburing.h
>>> index 987b28aaf99e..016be1e80ef2 100644
>>> --- a/src/include/liburing.h
>>> +++ b/src/include/liburing.h
>>> @@ -1702,8 +1702,13 @@ IOURINGINLINE unsigned io_uring_load_sq_head(const struct io_uring *ring)
>>>    IOURINGINLINE unsigned io_uring_sq_ready(const struct io_uring *ring)
>>>        LIBURING_NOEXCEPT
>>>    {
>>> +    unsigned head = 0;
>>> +
>>> +    if (!(ring->flags & IORING_SETUP_SQ_REWIND))
>>> +        head = io_uring_load_sq_head(ring);
>>
>> The head should already be zero. Actually, sounds like the get_sqe
>> hunk from the patch is not needed either.
> 
> Yeah agree, I think they are both false alarms. Might warrant a comment
> though. Or maybe we just fold it into io_uring_load_sq_head()?

What I'm implying is that the

+	if (!(ring->flags & IORING_SETUP_SQ_REWIND))
+		head = io_uring_load_sq_head(ring);
+

change from the original patch for normal 64B _io_uring_get_sqe()
doesn't seem to be necessary. I need to take a look, but that's
a good thing since the function is somewhat frequently called and
inlined.

That would leave __io_uring_flush_sq() to be the only place
checking the flag, so maybe comments would better to be put
there.

-- 
Pavel Begunkov


