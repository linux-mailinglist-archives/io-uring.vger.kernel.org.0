Return-Path: <io-uring+bounces-7884-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49A90AAE3AB
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 16:58:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B68F9503AD4
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 14:58:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87D9F2874F1;
	Wed,  7 May 2025 14:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fWLmPiXK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFEA25C6F0
	for <io-uring@vger.kernel.org>; Wed,  7 May 2025 14:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746629919; cv=none; b=Xyu6HTKqcUN4H2z0nQ4sNMCBY1qlIYmf/FKExC/+jV/bH4AzM9YCdInDrqrmxL+Ab1ibjye6SBnJvms/PgSDjdSBuWOpdUmU7/I6y3gnc6QHY3SgHANac0bzsua6Gq0Es0RWR+2wogp+XzInFgVPIQrb2SPqRTnHXSSRgpdALaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746629919; c=relaxed/simple;
	bh=ot/ijAjsVTB2GzEonZ2dg9O+AbldxBu1O01eXYt0PNc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=R6xRPY72R55UO3/z9eS1hSRWBjtZpxClGWDF+2AYLz84oofU4mSatbfKqqItRdgfrYvmHAJb3rHhevTlQVu5Z8ncjiwSeBoavllnYSRkjs+5/ZUzF4SUhRbRNrkcb9qpTwHG6jbPFqu0j6PVyRSVW8xVJKMFn5U7unICIF8aVKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fWLmPiXK; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3d965c64d53so25884945ab.1
        for <io-uring@vger.kernel.org>; Wed, 07 May 2025 07:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746629914; x=1747234714; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xirS0rsKou6eHbo+PTnfaphpih6hb5dBAfNGpygLyvQ=;
        b=fWLmPiXK9b/uvEwwCAlB9Wp6kJFLIpphcISq9HNJNWht7ScsMN7SiX02sG4J5NCtzu
         FKIhfqW058Pj/iOOEX4xhS0k7EKbY96w08D7WC7FA0tlwlXtPb3bRlTT2v5TmiIKtkcJ
         V0SFBJNv+oZGzWuC+UmNrEgkq5HE0RQOotGt9Jt7smEzyl0RAdXV/fRtNccWYUXgv7Q7
         WYZ0pOG6D2p528B+S2z+v6jp/qCVLuoALQjJuVjq1oMp94S/c+FUi57A/p6vHW5w8qvq
         FXgfIZcf+XWyjXLl/W7OObWWMZuIosK9u+58XIlIHxTC4/x7XEOG3V7dHmtR5mWDWD2b
         856w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746629914; x=1747234714;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xirS0rsKou6eHbo+PTnfaphpih6hb5dBAfNGpygLyvQ=;
        b=CWwsZCpU+3ubvLEpsVeVVIddQawOARz6BNmlNv249K2Fct1nEur9ScKzFOtUBz/8UM
         sD+Yus78yUDmeeYG/cC5AIQqqyNbBe3/UklTtNUYQ4biTMUOTKZSLRQL9QIAA+oHB4hl
         lque19mJCRbjHGGJmogxoeJPcDNZHLBF/Rq1kitiUjfGOsa7tM64kECBthS2HTZ3wKpq
         KY0LHyGgPAaPKnMWsaTh4I2XRSvPcxStdi8R/n3b6k1gRX5+O4o/b6Fv1HjgJR1Fwdgg
         qWbAbCmZoI76JNLF2qnopOV/Af2zT1Lpn3EDt2JHLPqTDvdEgY/fJ9oh7e6W0J5CkNUF
         qvjA==
X-Forwarded-Encrypted: i=1; AJvYcCWJ1yI2FueDzBmR3+f8tbOhom8q0Y/OkqUmdef71q9Yip+0leOKSv9lzGe2yZFV1effSkKzQm4ZlA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwNki4xIECNdFebwRKHTpJivpfcaJg7fsFBCuqodsZgOJ/G1yv1
	27d38L8VyZ+wFk8IEhWGuPVPk1W/RhS5+D22VpNb+ugmpPm3IjP/z+cIChFI0sA=
X-Gm-Gg: ASbGnctk7e4Ls+6SVs21+lwxvVUoW3Hoq2mV2i7uLmMGvOQ+DZSoTnOKxdR3o1Oww+b
	iXs9WBr1cyH2F/Afbf+UmgPSBHlhz3vkTf8Zy6f9FTqYduv+jYd3DqsjNvcMbi+eZd8lfPbKrYw
	JVKurC8x304KnH4jhuX24LuwVt9q2hcpN+vl0FrwTAwRXZvqik+AE2vtUI+iTOsRNTD1OyYN8JS
	Zo1kkGzGki3i6NJHpI5iGl29koRk/asQfmAOa0CFb+vLDWGHTD+CJu52dOJZT7RpiHHc3fMO1mm
	oKDi6lNA9rqsVjovZS7pRRtNqlJy6gVsc+Nb
X-Google-Smtp-Source: AGHT+IG884MFAuMZNPfa2druhKtMJoYr2w+XYbXOcegPpyMw4So3CkUtOlG56i7hs4sKQxDkypNnxQ==
X-Received: by 2002:a05:6e02:3f02:b0:3d3:f19c:77c7 with SMTP id e9e14a558f8ab-3da73923251mr36020025ab.16.1746629914616;
        Wed, 07 May 2025 07:58:34 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d975ce5a3dsm31246365ab.0.2025.05.07.07.58.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 07:58:34 -0700 (PDT)
Message-ID: <a4ef2e70-e858-4a3a-9f7a-22bd3af2fefe@kernel.dk>
Date: Wed, 7 May 2025 08:58:33 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: ensure deferred completions are flushed for
 multishot
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <a1dffa40-0c30-40d0-87b4-0a03698fd85f@kernel.dk>
 <c6260e33-ad29-4cd1-85c1-d0658c347a31@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c6260e33-ad29-4cd1-85c1-d0658c347a31@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/7/25 8:36 AM, Pavel Begunkov wrote:
> On 5/7/25 14:56, Jens Axboe wrote:
>> Multishot normally uses io_req_post_cqe() to post completions, but when
>> stopping it, it may finish up with a deferred completion. This is fine,
>> except if another multishot event triggers before the deferred completions
>> get flushed. If this occurs, then CQEs may get reordered in the CQ ring,
>> as new multishot completions get posted before the deferred ones are
>> flushed. This can cause confusion on the application side, if strict
>> ordering is required for the use case.
>>
>> When multishot posting via io_req_post_cqe(), flush any pending deferred
>> completions first, if any.
>>
>> Cc: stable@vger.kernel.org # 6.1+
>> Reported-by: Norman Maurer <norman_maurer@apple.com>
>> Reported-by: Christian Mazakas <christian.mazakas@gmail.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 769814d71153..541e65a1eebf 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -848,6 +848,14 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
>>       struct io_ring_ctx *ctx = req->ctx;
>>       bool posted;
>>   +    /*
>> +     * If multishot has already posted deferred completions, ensure that
>> +     * those are flushed first before posting this one. If not, CQEs
>> +     * could get reordered.
>> +     */
>> +    if (!wq_list_empty(&ctx->submit_state.compl_reqs))
>> +        __io_submit_flush_completions(ctx);
> 
> A request is already dead if it's in compl_reqs, there should be no
> way io_req_post_cqe() is called with it. Is it reordering of CQEs
> belonging to the same request? And what do you mean by "deferred"
> completions?

It's not the same req, it's different requests using the same
provided buffer ring where it can be problematic.

-- 
Jens Axboe


