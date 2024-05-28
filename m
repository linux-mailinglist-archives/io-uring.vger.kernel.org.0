Return-Path: <io-uring+bounces-1975-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 244108D1E87
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 16:24:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 89298B21DCA
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 14:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBC3816E895;
	Tue, 28 May 2024 14:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="r8Qmfnm1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDED16F829
	for <io-uring@vger.kernel.org>; Tue, 28 May 2024 14:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716906243; cv=none; b=PFLfxDxJRBPO6jUBWEaxnYLCKwpwl8jpC/BmeVMaBvB4j/xrf+X9DXpT681IkUUhojCyagefs/a86C4SpXeeq70au9oamfnFUHIRqxdmARjdZJbGmROohb7BvL7mBqZDcwe7+j2z26yK6MKqcTdZGsI+/Llxkcu7ghm9oAldRpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716906243; c=relaxed/simple;
	bh=ZJ/iQS8rQR7I+T7lxpnUfkD7S5DOwlALN8kkb0vcSbw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=XlxQPX+t1vStSLM35hmVCY/Rx3XyV/8qdD1utlo2I+AlsH1xG8zRD/fkeVWyEeVv5SFYfmQs8MkJfHay0qBkOqXVrurXSwVR3zKqVJWuPqzh2vfjqM8xQ3eBvLpWbjYur1QC3yaCd87dQH7klePX+gJC1wU1Dw8ShjK7i49TvTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=r8Qmfnm1; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6f8f6802131so22719a34.1
        for <io-uring@vger.kernel.org>; Tue, 28 May 2024 07:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716906240; x=1717511040; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bsVThgzx0/GCxzyEGc5/+vdtrs3QaKv6GCE+Xs8Dvzg=;
        b=r8Qmfnm1nYuPomvyoaPoGDaEkHSRfnQrXswhyNC4Ba8B1OozKxJDTBmtiPNjVfjAt0
         3bvDmZGUdB9J9sG1KHZpl6tl43laTDvaQD90mv88MhLdh4BEWDA/WP7bhFUGGlVPff8R
         7uKo2t5OdMDkpC+yYcdXP4YaDX9qFlWyo+LlmiRNLLPDEnfgxnNogaQHq6nuR3BQ5hFE
         jtXjctsXFBCUjJ6HYjrj9+KR9CTbFI4jozRy1fN20+joWrJPlG67FxVhD4TekAWXMUeX
         PqE4Q+fSsToADYpknyoWx7ETwzCvhUC0NhO+O9O0crOZC4wRo+WSnPxkNDC6nxCc5GNG
         /bJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716906240; x=1717511040;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bsVThgzx0/GCxzyEGc5/+vdtrs3QaKv6GCE+Xs8Dvzg=;
        b=Z6s770a9KWXtI5zNaY7RP7abaqFkq54kMXk0W61ZSR53dUF31IOz01cQwWi0Kqk4+4
         2Pue5yEF3ujWM4rwcNHVYcA9wNNLA7grOJusaLW9EETKM5Q97wA7mK7x/Gksam3w1DjV
         /Yh1Pg4Mt6LZYhlxIsqNT60wPIfmKVMcAVKsNnsW070IS7J7VYLNSHplQh2G9I2u/MFu
         f27bDoSoMp4hWRWe3tEbAGGk08JQqO+4zD/tcR6cMfDOXyKii2RYTurNg35b9sOPC91U
         iLjQ7rnH0dYhFr0bll4O/KR/5pnIJBq/NAN8hNKOtdOw1tue5MzTbJPeUeIgEgiD4S1S
         3aIg==
X-Forwarded-Encrypted: i=1; AJvYcCWhBB8QrQqXCMzbmAKwTZ2L5+o72TqjhOYKFDmk/A10R0wOGzu4mZHqEVrEf8yaVa4HLycWJsmG0zaMpse5fUGFDzfJpq9FmeU=
X-Gm-Message-State: AOJu0YzMmsSBenUOfZChzgDn78gSDBhIVxMW9sujLDDmD29MaXBE8ile
	lt91+hpdsLkkqBRprS1sthOnEnAxPDeYQTIh7F0ZGsbb0amgmKxe2pjsZhw0xLzPSdAYuAJvw7q
	5
X-Google-Smtp-Source: AGHT+IEHJAILKiTLo3HyKdok0HpBwNnM/RPmYWUqAnuLd2ulfEnvqWj2eDOwFHZ47feT3M+pZbcq7w==
X-Received: by 2002:a05:6830:720d:b0:6f0:471e:fd18 with SMTP id 46e09a7af769-6f8d0b57724mr14044676a34.2.1716906240330;
        Tue, 28 May 2024 07:24:00 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6f8d0e61524sm1924976a34.50.2024.05.28.07.23.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 07:23:59 -0700 (PDT)
Message-ID: <39bc9945-149f-4e48-91fa-9bec19eb74f9@kernel.dk>
Date: Tue, 28 May 2024 08:23:58 -0600
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
 <a9988b65-2a66-4af8-9fb4-ed7648d96b58@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a9988b65-2a66-4af8-9fb4-ed7648d96b58@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/28/24 7:18 AM, Pavel Begunkov wrote:
> On 5/24/24 23:58, Jens Axboe wrote:
>> If IORING_SETUP_SINGLE_ISSUER is set, then we can't post CQEs remotely
>> to the target ring. Instead, task_work is queued for the target ring,
>> which is used to post the CQE. To make matters worse, once the target
>> CQE has been posted, task_work is then queued with the originator to
>> fill the completion.
>>
>> This obviously adds a bunch of overhead and latency. Instead of relying
>> on generic kernel task_work for this, fill an overflow entry on the
>> target ring and flag it as such that the target ring will flush it. This
>> avoids both the task_work for posting the CQE, and it means that the
>> originator CQE can be filled inline as well.
>>
>> In local testing, this reduces the latency on the sender side by 5-6x.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   io_uring/msg_ring.c | 77 +++++++++++++++++++++++++++++++++++++++++++--
>>   1 file changed, 74 insertions(+), 3 deletions(-)
>>
>> diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
>> index feff2b0822cf..3f89ff3a40ad 100644
>> --- a/io_uring/msg_ring.c
>> +++ b/io_uring/msg_ring.c
>> @@ -123,6 +123,69 @@ static void io_msg_tw_complete(struct callback_head *head)
>>       io_req_queue_tw_complete(req, ret);
>>   }
>>   +static struct io_overflow_cqe *io_alloc_overflow(struct io_ring_ctx *target_ctx)
>> +{
>> +    bool is_cqe32 = target_ctx->flags & IORING_SETUP_CQE32;
>> +    size_t cqe_size = sizeof(struct io_overflow_cqe);
>> +    struct io_overflow_cqe *ocqe;
>> +
>> +    if (is_cqe32)
>> +        cqe_size += sizeof(struct io_uring_cqe);
>> +
>> +    ocqe = kmalloc(cqe_size, GFP_ATOMIC | __GFP_ACCOUNT);
>> +    if (!ocqe)
>> +        return NULL;
>> +
>> +    if (is_cqe32)
>> +        ocqe->cqe.big_cqe[0] = ocqe->cqe.big_cqe[1] = 0;
>> +
>> +    return ocqe;
>> +}
>> +
>> +/*
>> + * Entered with the target uring_lock held, and will drop it before
>> + * returning. Adds a previously allocated ocqe to the overflow list on
>> + * the target, and marks it appropriately for flushing.
>> + */
>> +static void io_msg_add_overflow(struct io_msg *msg,
>> +                struct io_ring_ctx *target_ctx,
>> +                struct io_overflow_cqe *ocqe, int ret)
>> +    __releases(target_ctx->uring_lock)
>> +{
>> +    spin_lock(&target_ctx->completion_lock);
>> +
>> +    if (list_empty(&target_ctx->cq_overflow_list)) {
>> +        set_bit(IO_CHECK_CQ_OVERFLOW_BIT, &target_ctx->check_cq);
>> +        atomic_or(IORING_SQ_TASKRUN, &target_ctx->rings->sq_flags);
> 
> TASKRUN? The normal overflow path sets IORING_SQ_CQ_OVERFLOW

Was a bit split on it - we want it run as part of waiting, but I also
wasn't super interested in exposing it as an overflow condition since it
is now. It's more of an internal implementation detail.

-- 
Jens Axboe


