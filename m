Return-Path: <io-uring+bounces-8184-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E4596ACAE7D
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 15:04:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7C2F3AAAE1
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 13:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CE941ACEAF;
	Mon,  2 Jun 2025 13:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3G94P5vy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B15191F6D
	for <io-uring@vger.kernel.org>; Mon,  2 Jun 2025 13:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748869486; cv=none; b=JxDX/RBs+4gZPCUqviwxOP+QLsTe4SU/EHpmYXpfw56ef+jdcLhwjqcnrd6fFBrLK6Z1hxyQXd+kj+7XdjHNUTauyj7uUbzlB54Au8hxDJiBgJ4f1VCPYcebemPc5q/mJyhmjaWh8/jhGmL6spNOUwfpY5+IIo7OkXCRwAsqa0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748869486; c=relaxed/simple;
	bh=hF/MctHOpEFGq46zKt5EkFc4W8HHgePD44VUaFj8Tuc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h4G9LfuSHSL3a8jgNY3tpeZXhIzQhkFO6VoI3PfNnmixKskRqH9CN22fbl8NfTcMq5YiEYu84SMKsfRfC2iySFFT0DSQXVaRUkGyD+jwSSM8cFYav2hQhXafsrwJcZV2dYJXc7WLa78NwxFkNEeNxrfuhsvSDgPIJwoG4HK2AqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3G94P5vy; arc=none smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-2d060c62b61so4078920fac.0
        for <io-uring@vger.kernel.org>; Mon, 02 Jun 2025 06:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748869481; x=1749474281; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VR6oz7HoMCPB1uam9Aq9oq7mhNCINIvpTViASl6JyHs=;
        b=3G94P5vyCIcVuC/ZzMdBgRT58GY9nO37GVLfuA6Fx+blevR+rKmxsQPbcahwGKrB0b
         NTM28RYhzWKwDqAvla2B2oMalYacAK+pdQ9loHhwErMm1Fk/KwugwCm7HQXHRH8xt+Kr
         PPSKZn1uuKPJ4U1Vv03BxhzAYBDiKxW6rD5aQN9XGCxeIvlSJfbqLendoSdFcQHyl/L3
         LL595ZpRrJc6dUY6+OH9Vt9GLTzhot4uSub87F14KpzQkzdEEg5Uhp9dmtuaPCuqd/W3
         ZcqRQUkurMKvX29BjpP0S68pxNsuM19nLqkB6O8HHq8R6OPRYRwtMUtNcOLeRkfwKd3h
         B30w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748869481; x=1749474281;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VR6oz7HoMCPB1uam9Aq9oq7mhNCINIvpTViASl6JyHs=;
        b=uH0CUFigBPtl9itGawn+S69SB8C4XVge0oOY7Jse1K2qoqLHDnMSWmO8sXmbMIGlbZ
         cwhHDxYrEnog2UTbuXPMbk76MsqXpn166/1KiawWe+FdOpU6mOYjsEv4PyuyIt1UkDAp
         vKT3trjK6lnpBkrs4sdmrJHVEY2/A0PccUZP+e3WCaw4PHWPpycIVhThGuDbtpzucSro
         /0qWq0DTHvxBHMYoH4+zJXnuJgnO1hgK/b+tQYgLv6YCjCsYdDQnRrl2PQfLZxmRdmVa
         xCJXrLxZQNEGFehhogxWTmoV+xAq45KkQGO5p9zyDak+QIdaelIFkwmfXBbDqyagtsCx
         Q6tw==
X-Forwarded-Encrypted: i=1; AJvYcCXS+Obej/InUCqKk735CNhIYfLYgn7y6KhXVzO5wmCWDdEkh90nR+mxn2Au04dJJjcZX082XSU61g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxCjex9r1mms52b/o6VMMbQJ+JBNl0Nd+XsCTggArVo43ZCu6IF
	uYLiugTE2W+xxbWEnDF5vl/lNrECzI9f0CDvhvM4UX76PCNtnizqJ1KP+D3DE+/dci9+R6H0+kQ
	rfJdb
X-Gm-Gg: ASbGncvdTZKsJQHVCsRgluC0pu5/MUgDSvpN+nHi1h9/BiwmM+8Oi4qBRUS2jnM5wwn
	cP184V+7mycr5SwcTYdZMw9To+2EP/s3G3KNJ5S8Q2aIP1AyLJSk8GPtxnu89av7yeueR9Wc9RM
	ldgE7p70gPbkEnt4F7CJdCvP5coPj6Xd0IWjtv+RM6f6457y6rd4y+TmWEi6S6/QUUy84qxGWwr
	CbM+JQ/dzgFzZzSVdBESPb1MOC587mBS0wD08UsPTKYB6gjhBY+cDyor/SHJHZigdx3lnK33333
	GjnbtMG71rb23xnpLrQMiCkPriR4DzdZXUaL9TQ0R3Uejdg=
X-Google-Smtp-Source: AGHT+IEApGZmYsYQikCm/UNwu0cVXVD2IbCYrtOGd6/sTOk+cyUrxGj+1CmVDaWcauIyUvHBvjtF0Q==
X-Received: by 2002:a05:6e02:1fc8:b0:3dc:88f1:d88b with SMTP id e9e14a558f8ab-3dd9c989d19mr109528275ab.3.1748869470393;
        Mon, 02 Jun 2025 06:04:30 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dd9359dc9dsm21514045ab.44.2025.06.02.06.04.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 06:04:29 -0700 (PDT)
Message-ID: <882bcc13-388c-43bd-b1d6-0409666e08ed@kernel.dk>
Date: Mon, 2 Jun 2025 07:04:29 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/uring_cmd: be smarter about SQE copying
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
Cc: Caleb Sander Mateos <csander@purestorage.com>
References: <5d03de61-1419-443f-b3a4-e1f2ac2fe137@kernel.dk>
 <6659c8b0-dff2-4b5c-b4bd-00a8110e8358@gmail.com>
 <546c11ec-25af-4f98-b805-1cb9e672c80b@kernel.dk>
 <d6d6d109-69af-48e9-aca9-acdf9ce82bd2@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <d6d6d109-69af-48e9-aca9-acdf9ce82bd2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/2/25 6:10 AM, Pavel Begunkov wrote:
> On 6/2/25 12:55, Jens Axboe wrote:
>> On 6/2/25 4:24 AM, Pavel Begunkov wrote:
>>> On 5/31/25 21:52, Jens Axboe wrote:
>>>> uring_cmd currently copies the SQE unconditionally, which was introduced
>>> ...>       /*
>>>> -     * Unconditionally cache the SQE for now - this is only needed for
>>>> -     * requests that go async, but prep handlers must ensure that any
>>>> -     * sqe data is stable beyond prep. Since uring_cmd is special in
>>>> -     * that it doesn't read in per-op data, play it safe and ensure that
>>>> -     * any SQE data is stable beyond prep. This can later get relaxed.
>>>> +     * Copy SQE now, if we know we're going async. Drain will set
>>>> +     * FORCE_ASYNC, and assume links may cause it to go async. If not,
>>>> +     * copy is deferred until issue time, if the request doesn't issue
>>>> +     * or queue inline.
>>>>         */
>>>> -    memcpy(ac->sqes, sqe, uring_sqe_size(req->ctx));
>>>> -    ioucmd->sqe = ac->sqes;
>>>> +    ioucmd->sqe = sqe;
>>>> +    if (req->flags & (REQ_F_FORCE_ASYNC| REQ_F_LINK | REQ_F_HARDLINK) ||
>>>> +        ctx->submit_state.link.head)
>>>> +        io_uring_sqe_copy(req, ioucmd);
>>>> +
>>>
>>> It'd be great if we can't crash the kernel (or do sth more nefarious with
>>> that), and I'm 95% sure it's possible. The culprit is violation of
>>> layering by poking into io_uring core bits that opcodes should not know
>>> about, the flimsiness of attempts to infer the core io_uring behaviour
>>> from opcode handlers, and leaving a potentially stale ->sqe pointer.
>>
>> Sure, it's not a pretty solution. At all. Might be worth just having a
>> handler for this so that the core can call it, rather than have
>> uring_cmd attempt to cover all the cases here. That's the most offensive
>> part to me, the ->sqe pointer I'm not too worried about, in terms of
>> anything nefarious. If that's a problem, the the uring_cmd prep side is
> 
> If a cmd accesses it after going async while it points to the SQ,
> a lot of interesting things can happen, you just need to swap the
> SQ in between, so that the pointer ends up dangling, and there is a
> convenient feature for that.

Not sure why you aren't being explicit and just saying "resizing", but
yes agree that would be a problematic spot. Above comment was just about
swapping between two separately valid SQEs, not dead SQEs.

>> borken anyway and needs fixing. Getting it wrong could obviously
>> reintroduce potential issues with data getting lost, however.
> 
> It's flimsy as it depends on the file impl, especially with
> -EIOCBQUEUED, but yeah, your choice.

It is... Just consider it an RFC - I think we should do something about
it, productive suggestions more than welcome.

-- 
Jens Axboe

