Return-Path: <io-uring+bounces-8657-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C2BDB02D04
	for <lists+io-uring@lfdr.de>; Sat, 12 Jul 2025 23:02:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D97D4E4DD8
	for <lists+io-uring@lfdr.de>; Sat, 12 Jul 2025 21:02:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 873091BC41;
	Sat, 12 Jul 2025 21:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KEGe+WS+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E36C2E0
	for <io-uring@vger.kernel.org>; Sat, 12 Jul 2025 21:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752354158; cv=none; b=PPUjjMwkqrEZcjHOYn3dfiEG2Q+5OS0X2cdp9/msw8FtPPDisZLAnj4vJUk/NWTtlxfjNzPKtabt76Hzr0wCfLhPIvrrA2vDtXxdLHJ4H4HlJqmTdkEQuSWPd5poYyShgXxQ3P1KeQa0YeiTcZwBcD7mfIfVUG/PdeBySrLDjRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752354158; c=relaxed/simple;
	bh=xH2xSWWoc3cTidlGa95ZEnkjnbQ5fuhGuQQTxuChI58=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=IP7ViMAfC3zHev+/deCYhr6JTEiJl0NCXZUSH3Yaw8At7sil0Q3AW53mJlMgaSP4ubGBZOdDTjUUmF6TRPf53zYxzaOQGRtODVSmSm0LYm0Oa3uEd7YZYjyHjF7xxYTaoNy0IvILmuvBvbM3trLX9qRuNc9+WxTgjl82blQNrzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KEGe+WS+; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3de2b02c69eso18006135ab.1
        for <io-uring@vger.kernel.org>; Sat, 12 Jul 2025 14:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752354155; x=1752958955; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=syNOeMUD6vPKcRajXAQ88oTtXlW4qgyz+Vd68IiNVcI=;
        b=KEGe+WS+GHdLxYUEvsjjwTmtwOpuCheLunTOohTWRT2w9rOQmxPEnOqS2Wf+JpN69X
         KgZ23pcRs2IrGAX61RRYUwPPW+MonPPuCYR0T9jReXRfIVjbFtdCoShNJzYDgFf0ny1F
         p79XgQzITNEphstrMeBVtS9N1hC7D1259sjla+oCxpa3t54PINL3Lf6Ynw9hbdKF9qkS
         nwVPdD1wOr7WFUovEpRHycKesb4JrrKOTFAV/HDdkoi5IizmT1kJK5Coi5SCMYSzVlxO
         dgjp7hEHRVbZ8Z5YECvHLhPF8UEdtwWj8/aUT64brL7VQH8P0/gxIj3lYGS345WwCHH8
         oXtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752354155; x=1752958955;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=syNOeMUD6vPKcRajXAQ88oTtXlW4qgyz+Vd68IiNVcI=;
        b=IqHURR/56vXXSc9sxWuMPjIKBBYPO0RrZBvIxqJ0Ltl0x0XTCi2NeFCwqsn1xxDm4Z
         T6tNUVvm7qQorzmlk8pOjEqIkIyNgCBJGIip1sPM7FkvQo0PLIoctsaJA3rNt23UDtbn
         8dn+R2WbZnFJsiaYVoN1bbo31FF+bis3+nqGCLtd8oNYzmiPSg7SJ0bDFPizPukLeGvj
         8Mx6nhhJCzarE2F52NkyCpvNDNQhxpdfOHqELPv8UGWr5WB1Pf61DLuMr+im8f3v+R7i
         /0Ws2rbs52A3vCMhZCIwUtMt4VpieWAD7xpOr/GtTGDm63SJ3vwDdi5KozhIQrIMEeUN
         sOqw==
X-Forwarded-Encrypted: i=1; AJvYcCUJJvfgxnO3V2y2qmZSqWl2rUHt203YDlFt4SscmiyTiTHHc1Tf0s4NOfrcSfwE/gIDV74S5sxJbg==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywmef+Z1lDKlhGJ6aa1wYdhwySW0FUuhoLaw5gOymbvQH3VrTbA
	ddRAY0tgN27RpY38X10tkDgek7v9+CXlNdueUlXiW+b3EnJXnrBQhnbWtfZkp7khEjzKwS/CPoa
	/I/59
X-Gm-Gg: ASbGncu1x1k4xtjp5dnaOdgMcrg1Jn0srGYpJ6pkwaBGQId3OL/CJrqViuYg4QjY3UY
	8L74CbIxRAShV5zHyQAHJ8cloiTbspFeY5HfpVpq9KeRZpuGChN3q7XNWN3Pb4HI6TjLkmTgAgt
	ZJuL5Bdntnd8Vb2lE+rlr/+z/rrx+Yxbe10UPfrIuu7as8Ynyux48vmCqmQxHmO8GI+rYRu2WJ7
	N6c7KzM5olKOr4Qyxo4JGPeBpaK5DLrsHDeGzoNjbCzJ6kIVdP3RehZW67lz5rSXgqO67rWx7G7
	R2ImeXRm93522YQwGevVSd6IAZX51z5z2u7CH9JJdXGDv1soax/f7iFdyVK9PJLrje1jd2wzwVF
	UmTgaCzTeM1yDmMABTLI=
X-Google-Smtp-Source: AGHT+IGMm56CDj0DoKPbPbheqTlFB9GjJ3hR7HWCipEGy+gHVi8YQXX30P7owcffh3mB2F28d1z3+A==
X-Received: by 2002:a05:6602:4010:b0:86d:71:d9a with SMTP id ca18e2360f4ac-879787b862emr841655839f.2.1752354154617;
        Sat, 12 Jul 2025 14:02:34 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8796bc60337sm162372839f.46.2025.07.12.14.02.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Jul 2025 14:02:33 -0700 (PDT)
Message-ID: <ada8bfa0-e6fc-4900-b54b-40d2e18a54f4@kernel.dk>
Date: Sat, 12 Jul 2025 15:02:33 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] io_uring: add IORING_CQE_F_POLLED flag
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <[PATCHSET 0/3] Add support for IORING_CQE_F_POLLED>
 <20250712000344.1579663-1-axboe@kernel.dk>
 <20250712000344.1579663-4-axboe@kernel.dk>
 <7541b1b5-9d0d-474a-a7d9-bbfe107fdcf1@gmail.com>
 <1aaef260-08a2-4fd1-9ded-b1b189a2bbe4@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <1aaef260-08a2-4fd1-9ded-b1b189a2bbe4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/12/25 8:49 AM, Pavel Begunkov wrote:
> On 7/12/25 12:34, Pavel Begunkov wrote:
>> On 7/12/25 00:59, Jens Axboe wrote:
>> ...>       /*
>>>        * If multishot has already posted deferred completions, ensure that
>>>        * those are flushed first before posting this one. If not, CQEs
>>> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
>>> index dc17162e7af1..d837e02d26b2 100644
>>> --- a/io_uring/io_uring.h
>>> +++ b/io_uring/io_uring.h
>>> @@ -235,6 +235,8 @@ static inline void req_set_fail(struct io_kiocb *req)
>>>   static inline void io_req_set_res(struct io_kiocb *req, s32 res, u32 cflags)
>>>   {
>>> +    if (req->flags & REQ_F_POLL_WAKE)
>>> +        cflags |= IORING_CQE_F_POLLED;
>>
>> Can you avoid introducing this new uapi (and overhead) for requests that
>> don't care about it please? It's useless for multishots, and the only
>> real potential use case is send requests.
> 
> Another thought, I think the userspace can already easily infer
> information similar to what this flag gives. E.g. peek at CQEs
> right after submission and mark the inverse of the flag. The
> actual impl can be made nicer than that.

As per the previous reply, not sure it makes a ton of sense. The initial
hack I did was just for sends, and it actually just reused the bit for
SOCK_NONEMPTY, as it was only for writes. But then the concept seemed
generic enough that it'd be useful for writes. And then it becomes
mostly a "did I poll thing", which obviously then makes sense for single
shot read/recv as well.

Now it's taking a new bit, which isn't great.

But I think it's one of those things that need to ruminate a bit. Maybe
just go back to doing it purely for sends. But then perhaps you'd
actually want to know if the NEXT send would block, not that your
current one did.

-- 
Jens Axboe

