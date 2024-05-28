Return-Path: <io-uring+bounces-1981-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F2678D22E1
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 20:00:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B2B881C22D73
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 18:00:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABF3F45957;
	Tue, 28 May 2024 17:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gYqa68B9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8580482FE
	for <io-uring@vger.kernel.org>; Tue, 28 May 2024 17:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716919193; cv=none; b=fv1lmSkLuM0pOJWYI/5Rorz4ml5Y/Tn55CNfXPEiWqPpYEAOGS3V2QubluOEMdwT5cRHNl/uuUnsQWhQGflU4hPsdaJQYNegqzwlOUtKmzYAjhWv+f+4Pd0+aJglEmfZOoH9bWJea5x5CqWd06lzbAOWyNoR/xOgmS/lhq3BzQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716919193; c=relaxed/simple;
	bh=iFsG9Vxx1t4Xf2S/qBbmwmEXs9uCX9zpUyOCrMCudeU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hZa8HqxE23/DBMuCXh6Mc908dBr2Jgs3DxKPiUwNqqo8rBazRGKEXPWGoMr8p4Mp2K3YlKeeR4ug9PB9V3udRwS8asayp4AUArTUSkPosq0UXZKpD/xWjwEzYBlgsY0Qg8oIJeCPn0+0xwUqXXdsW/8GnG+E8IbRXQMvJqyKlNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gYqa68B9; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-698ef41ed78so75397a12.1
        for <io-uring@vger.kernel.org>; Tue, 28 May 2024 10:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716919190; x=1717523990; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oJmSuOKbu0fCb60M9pRep7C024tzJRVtaPbaZOS/Pkg=;
        b=gYqa68B9qaCsLD70b+chFRuiPIIdLnzuFi5FiHfcm0IBrr03dgDt82zlVij45GU2Dq
         vFe7/qdSKC6YDxtZsBGCUbQJwTi9RzYcLpv1Tf48epzgcfWAtymw8Wyp5yzZxSEQYhLw
         BcLbJhwtU5027iiTi9wwvYwFIk0b04PapTbZ8MHAQLrxrSJHmjaFg3L3woYRDDGKlMB/
         8ozyMbtkJUd6vUM9JGq9Bczk8bQHKBozpmdZqsgY1D1wZK4EKARXhHfGU7BbnBe4/w9J
         zlWTQoknOL6DKTeB0JHQ4tc2Ul8lkuaunUyCaj5GzKFFrag4KAazvPYAXH3B87mV+VyO
         J9qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716919190; x=1717523990;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oJmSuOKbu0fCb60M9pRep7C024tzJRVtaPbaZOS/Pkg=;
        b=H9ZPTRRI1ZkMwO85vzH/ubp4UQOYGe6TYYEli+Cnm+YHnPvy2l51xQI6Ltth5S1r+g
         nMN4VlQ7cfwtyR0+U5e3Zv/JYEWvZB5QaE+TVuJGJHKxCYP4WxypYSDf25+o3E+VUgtk
         T+zFbwHNzBnXPRWTdRdv6nuiueECA2/6CaM7OVJ64j3aAtiIKOi2UhaW/Xew0q7NASZw
         uz6wmIdMUKt2G8I6RrrlNkuJLolhFyhPsaSmFbb8FWcuME6k4LxeuvVrOoIuPp2UVh0I
         SzxEpgGaZ1A5d/llkwZEVaeK/JVu6Wpn3nvZqbCP4VnS2iEDw3odfyEBDhWLm45YQBIj
         pZeA==
X-Forwarded-Encrypted: i=1; AJvYcCWwGSJlgRe5E0DkvZ9Pnl1VdUDCif0KmB2+KcuRccK/wTlLYHm2MDBuCv3ItPg6oFr2PikmyIv7tlJDA8kJ+tBZstt7diphfCI=
X-Gm-Message-State: AOJu0YyrDl6gmm9JHsK0GoNlG59n8yfF7PSLdBK1u8uZYLEz5tJBiBcD
	Htawsgx79DiKaypsz/W8y4KCNV/G9J5iCETRgZXIx5xPh0ytyINMlu+C/XDox9A=
X-Google-Smtp-Source: AGHT+IGt+QtjbA/TIy5HZHz9+1qRxtIPxAuadnjeUn+sB6hs52L1G30XYr+b/RQAQu64m755sleYxw==
X-Received: by 2002:a05:6a20:9759:b0:1af:ce9c:6421 with SMTP id adf61e73a8af0-1b212b6f694mr11955665637.0.1716919189844;
        Tue, 28 May 2024 10:59:49 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21e1::14ae? ([2620:10d:c090:400::5:29f9])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f987a73sm8014105a91.37.2024.05.28.10.59.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 10:59:49 -0700 (PDT)
Message-ID: <1fde3564-eb2e-4c7e-8d7d-4cd4f0a8533d@kernel.dk>
Date: Tue, 28 May 2024 11:59:47 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring/msg_ring: avoid double indirection task_work
 for data messages
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240524230501.20178-1-axboe@kernel.dk>
 <20240524230501.20178-3-axboe@kernel.dk>
 <d0ea0826-2929-4a52-86b1-788a521a6356@gmail.com>
 <c0dedf57-26b4-4b29-acbf-6624d89bd0ac@kernel.dk>
 <8566094d-0bcb-4280-b179-a5c273e8e182@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8566094d-0bcb-4280-b179-a5c273e8e182@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/28/24 10:23 AM, Pavel Begunkov wrote:
> On 5/28/24 15:23, Jens Axboe wrote:
>> On 5/28/24 7:32 AM, Pavel Begunkov wrote:
>>> On 5/24/24 23:58, Jens Axboe wrote:
>>>> If IORING_SETUP_SINGLE_ISSUER is set, then we can't post CQEs remotely
>>>> to the target ring. Instead, task_work is queued for the target ring,
>>>> which is used to post the CQE. To make matters worse, once the target
>>>> CQE has been posted, task_work is then queued with the originator to
>>>> fill the completion.
>>>>
>>>> This obviously adds a bunch of overhead and latency. Instead of relying
>>>> on generic kernel task_work for this, fill an overflow entry on the
>>>> target ring and flag it as such that the target ring will flush it. This
>>>> avoids both the task_work for posting the CQE, and it means that the
>>>> originator CQE can be filled inline as well.
>>>>
>>>> In local testing, this reduces the latency on the sender side by 5-6x.
>>>>
>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>> ---
>>>>    io_uring/msg_ring.c | 77 +++++++++++++++++++++++++++++++++++++++++++--
>>>>    1 file changed, 74 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
>>>> index feff2b0822cf..3f89ff3a40ad 100644
>>>> --- a/io_uring/msg_ring.c
>>>> +++ b/io_uring/msg_ring.c
>>>> @@ -123,6 +123,69 @@ static void io_msg_tw_complete(struct callback_head *head)
>>>>        io_req_queue_tw_complete(req, ret);
>>>>    }
>>>>    +static struct io_overflow_cqe *io_alloc_overflow(struct io_ring_ctx *target_ctx)
>>>> +{
>>>> +    bool is_cqe32 = target_ctx->flags & IORING_SETUP_CQE32;
>>>> +    size_t cqe_size = sizeof(struct io_overflow_cqe);
>>>> +    struct io_overflow_cqe *ocqe;
>>>> +
>>>> +    if (is_cqe32)
>>>> +        cqe_size += sizeof(struct io_uring_cqe);
>>>> +
>>>> +    ocqe = kmalloc(cqe_size, GFP_ATOMIC | __GFP_ACCOUNT);
>>>
>>> __GFP_ACCOUNT looks painful
>>
>> It always is - I did add the usual alloc cache for this after posting
>> this series, which makes it a no-op basically:
> 
> Simple ring private cache wouldn't work so well with non
> uniform transfer distributions. One way messaging, userspace
> level batching, etc., but the main question is in the other
> email, i.e. maybe it's better to go with the 2 tw hop model,
> which returns memory back where it came from.

The cache is local to the ring, so anyone that sends messages to that
ring gets to use it. So I believe it should in fact work really well. If
messaging is bidirectional, then caching on the target will apply in
both directions.

-- 
Jens Axboe


