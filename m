Return-Path: <io-uring+bounces-8183-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8A12ACADCD
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 14:09:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A35BF3A73A0
	for <lists+io-uring@lfdr.de>; Mon,  2 Jun 2025 12:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 949991FF7D7;
	Mon,  2 Jun 2025 12:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZsZT4sM9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C634C19E98B
	for <io-uring@vger.kernel.org>; Mon,  2 Jun 2025 12:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748866170; cv=none; b=qRuVU28aj0ltMxEJbVXNB1lcXS6jAIf3ku3kHb3qMrRnfd3zmv5f1paq6wCpsh+/LKd4aasOARQuE/A6LLjOFDp4cRXWZozEIV0oRK/anuiRKD2WITT0pLkC181GvSLRsr96px0cqoDLzqRqmtew+JkhC4HDm9ET6TD3wNOoOZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748866170; c=relaxed/simple;
	bh=PIP9l8LCrwZd8czOwdoLzgiAGRsBGabGdU/7piSDYoE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GLZ87e+cgKTKvOi0+yxJ2Okm/w0he8iCu7WofgnJPEkRqjV7WEpo8EMN092Wpch9lmsu2aiKmSyViRFyCgi3jJNquFyZLBbCfr0miq3SuZ0VFZ6nZfw4EjNLwqaba0nRDBtu7FnyZJTLnXGQtt0fM9W/A3zybz726PWkeqGwyjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZsZT4sM9; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ad88105874aso668563266b.1
        for <io-uring@vger.kernel.org>; Mon, 02 Jun 2025 05:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748866167; x=1749470967; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=foxVn50sru/WKm0ymnKvss0rYR1MnWxGNAlEFj6UY8I=;
        b=ZsZT4sM9aX/qrGKzbHN0zcpk8/sMJZlhduhj5UaZclz5R1Zutq4rVfE3H5wy4CxjQI
         k98ie0QxrlGzASy5+nuS4bCxHglfIZyk0HQgMoNKF6YZypGBzJsuk+fnaQl14vpjlYRT
         HMM5U0o4qIXBiqS3RK1jAcNKrBYoduvvSHzX3fy5X7rejtaRzgTUrn7D0Kw7hD5JN0qX
         I8cFFlEz5DRnTFiO/Y9n8bgGeFKw6J86eaF7W4zGW9L6JpLGP7uOyieBfgMC5QXSqt5a
         ZhZJ4TrBuhKjQUHCs8Yfv1Kz5X2LLmls3OqRJBkbccClmDeMdQYcekErJb1PsG5Ev9uT
         1Ytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748866167; x=1749470967;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=foxVn50sru/WKm0ymnKvss0rYR1MnWxGNAlEFj6UY8I=;
        b=xEeFykwLdmbC4P97PMrGfJmTZMusi7SSzj0e/WuGd3iLAx7x+10hT7U0ZM7AmFiMwz
         JC1HI0Qv3vqXG9IqzvhXwdooCQhQzH1+FDC5MxGTbZLtr/MkP121QJnuB3pdklrWX0/E
         j26kWl/J70A6DPSPgGDdDuHBzt5iFWCWeTHyFBweTTWnwUsYOcHxDGfh7IyhPBZZq//8
         3/aKjBW5ig6ZU79PyrCua/1Vw9AVU+uSph2XZlW6PUcGHhA+u/KlYqyXufrm+1ybFtqa
         ARB1wDRP2kL5hul88PJpnriP/5Sb+WIF+pQ5wkY+KS7H7hcvJmue4GmOnIiP3xaRoTgJ
         1v5g==
X-Forwarded-Encrypted: i=1; AJvYcCXUJhzrvGyd+qTBUmQns91o3+v/CwRKEa6rgIGBBWCuDlK5HfT/Gh2OOkXAjNwlDWDjgmjvjbXVYw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxUsrgNHTteu6fxS4S2oN/XaPNg1K+6h02uOLXLIF6Tg+TnMx5e
	lXQ1q3yOCDg+jW9Hf/LvAvqIw89TMhp7bLyw79RQWDKaEsplD8D0zZzG
X-Gm-Gg: ASbGncvXxtsBVodgeJX6QtP98sa0erHX24CRBgcgjnWqwSpnA2h6cPbPP2WStIPa4PJ
	Mz/kUwpWN05bmiHHluuCuII54hV3/mxLKCR550j57TVp9MPehvoJ6VKTuesOCBAzVFHwgH/SPrT
	cqBupRoLRw9cYsLB47NrRvrQ3Cb1pwt3rl4pIMl2NDWnfwBpT2vo6RJ1cpiST9987FVODjJ0csS
	O4nMxAWauLNyA7KeZpTuc28f77NF7cTOfSUD2vsTSoWphA7IDjHyeDQ29E+c0urM4lF2A1Fz+eP
	pEeGt0PEfBVzQVi8hs6TCNnvBvKwjoZH58ixaX+1Y9b3xDFaL78XLkLEwNGb+ZIP
X-Google-Smtp-Source: AGHT+IFQ7XaBRzslUdMqbIBseOd/9OTaNu9iKEYW8BEcD2rhHtMmoIXDZp+ciRb6AEstS8ogCLuVAg==
X-Received: by 2002:a17:906:1699:b0:adb:33d9:67e5 with SMTP id a640c23a62f3a-adb33d96801mr982991266b.38.1748866166730;
        Mon, 02 Jun 2025 05:09:26 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::26f? ([2620:10d:c092:600::1:8317])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada5d7fef72sm787099366b.34.2025.06.02.05.09.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 05:09:25 -0700 (PDT)
Message-ID: <d6d6d109-69af-48e9-aca9-acdf9ce82bd2@gmail.com>
Date: Mon, 2 Jun 2025 13:10:51 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/uring_cmd: be smarter about SQE copying
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc: Caleb Sander Mateos <csander@purestorage.com>
References: <5d03de61-1419-443f-b3a4-e1f2ac2fe137@kernel.dk>
 <6659c8b0-dff2-4b5c-b4bd-00a8110e8358@gmail.com>
 <546c11ec-25af-4f98-b805-1cb9e672c80b@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <546c11ec-25af-4f98-b805-1cb9e672c80b@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/2/25 12:55, Jens Axboe wrote:
> On 6/2/25 4:24 AM, Pavel Begunkov wrote:
>> On 5/31/25 21:52, Jens Axboe wrote:
>>> uring_cmd currently copies the SQE unconditionally, which was introduced
>> ...>       /*
>>> -     * Unconditionally cache the SQE for now - this is only needed for
>>> -     * requests that go async, but prep handlers must ensure that any
>>> -     * sqe data is stable beyond prep. Since uring_cmd is special in
>>> -     * that it doesn't read in per-op data, play it safe and ensure that
>>> -     * any SQE data is stable beyond prep. This can later get relaxed.
>>> +     * Copy SQE now, if we know we're going async. Drain will set
>>> +     * FORCE_ASYNC, and assume links may cause it to go async. If not,
>>> +     * copy is deferred until issue time, if the request doesn't issue
>>> +     * or queue inline.
>>>         */
>>> -    memcpy(ac->sqes, sqe, uring_sqe_size(req->ctx));
>>> -    ioucmd->sqe = ac->sqes;
>>> +    ioucmd->sqe = sqe;
>>> +    if (req->flags & (REQ_F_FORCE_ASYNC| REQ_F_LINK | REQ_F_HARDLINK) ||
>>> +        ctx->submit_state.link.head)
>>> +        io_uring_sqe_copy(req, ioucmd);
>>> +
>>
>> It'd be great if we can't crash the kernel (or do sth more nefarious with
>> that), and I'm 95% sure it's possible. The culprit is violation of
>> layering by poking into io_uring core bits that opcodes should not know
>> about, the flimsiness of attempts to infer the core io_uring behaviour
>> from opcode handlers, and leaving a potentially stale ->sqe pointer.
> 
> Sure, it's not a pretty solution. At all. Might be worth just having a
> handler for this so that the core can call it, rather than have
> uring_cmd attempt to cover all the cases here. That's the most offensive
> part to me, the ->sqe pointer I'm not too worried about, in terms of
> anything nefarious. If that's a problem, the the uring_cmd prep side is

If a cmd accesses it after going async while it points to the SQ,
a lot of interesting things can happen, you just need to swap the
SQ in between, so that the pointer ends up dangling, and there is a
convenient feature for that.

> borken anyway and needs fixing. Getting it wrong could obviously
> reintroduce potential issues with data getting lost, however.

It's flimsy as it depends on the file impl, especially with
-EIOCBQUEUED, but yeah, your choice.

> It's somewhat annoying to need to copy this upfront for the fairly rare
> case of needing it.
> 

-- 
Pavel Begunkov


