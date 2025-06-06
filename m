Return-Path: <io-uring+bounces-8267-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D3607AD094F
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 23:05:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93C82164F10
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 21:05:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47A9F21883C;
	Fri,  6 Jun 2025 21:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1uQXelbj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054AA201013
	for <io-uring@vger.kernel.org>; Fri,  6 Jun 2025 21:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749243944; cv=none; b=t89qSnFXK6tWD2jXUUr+CKSIxLCIcEszA9lYvnXND7KdrF7g/zGEgg0a+mYEmiUlSjX8I/BcVHu3BSgS8zjPUQY7s1a0J/8zpjaSoh5ScahTONq5gbrWM5BnpGfwBCTxxlrKWgDuo+UHaBifd2BSctc6hGEo+sMtqrwalmP8BXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749243944; c=relaxed/simple;
	bh=2Y7/apGkSQ7SZl6F2whlqv3NgJjxVn6YQIXkSSX37nI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gSIdZLT7CG32zXNGHLTDLHdBIUsxcraETKUZyfWhz4tQElVQc3eNIWYX3sxJAawT2pqGSEeGUV4fLakaQNFs1GC9fWxILYmA665RNdklFf/QPnGdgSgXSG90JHqgihWc5vGOIFkWwsISq42jinmJe4UbHKmUMj4WsLpILkhIQig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1uQXelbj; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-86d013c5e79so204139139f.0
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 14:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749243941; x=1749848741; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=g7vPECksX4qRxRQMDVPblj/7Xx7XWK87uG1PlbPPS4U=;
        b=1uQXelbjlSiPDNcN9fTd6BS4Y7MQw8cytEQnaOhxZsNHU2e0a1+uA/vPV7gIR8ZQOn
         kB6mHvemAh/N1FVDWYlbnbOkcVhwB9UMn1B0pTVVuzPplatWxOqEsaW7e3I9Vw+Wekh4
         raMLei8M1H7LnwFQH8GYSM2OXAQyY9SKH3Lk8zOe4uoAhvwVYwWzdYf4UlSVydl5IEaq
         F0r3hTV278HzC7INWOVGPBXjzs+c3t68CRMvid8OYM71DDIlXi01Bddj944OWdnJo1Po
         e0EkNoYiREA0NrcwCHD0es9spAQ2GgwqyP+ud1Mj0LZh7olpdY7rG3YfG6hEJXxUdPcL
         Qz6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749243941; x=1749848741;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g7vPECksX4qRxRQMDVPblj/7Xx7XWK87uG1PlbPPS4U=;
        b=TkcV09K2q/8CVPmxWgQBTeXTGQQ41Vqdlzkdim+jRo3nGbdYUMht+zPUkz79fKIf3j
         RSewTPrynfdhUEKE0ja/jQ2WZ1pBc4H+h8CfeVpzXkhHsxBvWzjR0KWDaRU/PECluw1l
         aL3mQ5DZcU/H6HDU/4ZfVGylEWlvHswsaI05SexlhyXkMj3v3icjzYRlE4ikiG2pHd6J
         VZ5VAfUhJHnBQYAhXYykCOSQwif6MTgDhxOVM/aBQRRNFJN/0n7BHDgfPlsKotOodA/O
         4WyMsS+RlQK0Eru3Jb4x7A3ZmFHqEAMPYu8rEyl7ZzDYIwUjbM51z6X2o5VMzgsF+Wc8
         JrzQ==
X-Gm-Message-State: AOJu0YwHJG/OpoY3lE46IDEYdLo9OFdTavqL2+Hcsxkbayjya8tTh5p/
	ki+PhveE2X3RKcP5bM8I+TKrfGodBNwu/sf5ECd0mrLynoRZdYGozlB6XHIkqStCm+YP9o6n/b3
	nnHRl
X-Gm-Gg: ASbGncvyqSL3W9WLH7qR19uKkVzCK7b/8RDuU9NqyvaXTjHzGps8GyuhgnntXVuV4x7
	ma9XbRSYNMYOauZ3S29g5BN9Ncnl6Rr+iZFhegwufGP+ORbMYWpl2Y29X0IY+dJlQ8Cmev6Wpym
	wB7coJhzFLDbE2fG2CzwnBZVcc30BSfmx8GmocEbyYOUbCDnlHCGyG4qKbCLoLWOZE1ZmXSUREv
	XMM9DCQucGNKxQzx4GQ/SM6drTiHGvazjVY1odst/JnZCbD5Lh4scW3CDW1/J+D/aT8PgAyO+kQ
	xITa4ZKb2CGxFEP/Vpdad53KVZzc90HcpI4/lFB7leRxYnx/
X-Google-Smtp-Source: AGHT+IHJqYWZ7EH3fcUECQJ9dEm2XBPTen1jROzMmwF7bxhaRjZGnShvmDCTNd9gW+A4wG6HN3zrAw==
X-Received: by 2002:a05:6602:368e:b0:86c:ff6a:985d with SMTP id ca18e2360f4ac-8733666e887mr703380939f.6.1749243940908;
        Fri, 06 Jun 2025 14:05:40 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-87338783379sm47536039f.7.2025.06.06.14.05.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 14:05:40 -0700 (PDT)
Message-ID: <98a6907f-b9e7-4331-83cc-855a64bb1eaf@kernel.dk>
Date: Fri, 6 Jun 2025 15:05:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] io_uring/uring_cmd: implement ->sqe_copy() to avoid
 unnecessary copies
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org
References: <20250605194728.145287-1-axboe@kernel.dk>
 <20250605194728.145287-5-axboe@kernel.dk>
 <CADUfDZrXup5LN250NS9BbSCC5Mq5ek82zJ89W2KyqUKaWNwpTw@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <CADUfDZrXup5LN250NS9BbSCC5Mq5ek82zJ89W2KyqUKaWNwpTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/25 11:39 AM, Caleb Sander Mateos wrote:
> On Thu, Jun 5, 2025 at 12:47?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> uring_cmd currently copies the full SQE at prep time, just in case it
>> needs it to be stable. Opt in to using ->sqe_copy() to let the core of
>> io_uring decide when to copy SQEs.
>>
>> This provides two checks to see if ioucmd->sqe is still valid:
>>
>> 1) If ioucmd->sqe is not the uring copied version AND IO_URING_F_INLINE
>>    isn't set, then the core of io_uring has a bug. Warn and return
>>    -EFAULT.
>>
>> 2) If sqe is NULL AND IO_URING_F_INLINE isn't set, then the core of
>>    io_uring has a bug. Warn and return -EFAULT.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  io_uring/opdef.c     |  1 +
>>  io_uring/uring_cmd.c | 35 ++++++++++++++++++++++++-----------
>>  io_uring/uring_cmd.h |  2 ++
>>  3 files changed, 27 insertions(+), 11 deletions(-)
>>
>> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
>> index 6e0882b051f9..287f9a23b816 100644
>> --- a/io_uring/opdef.c
>> +++ b/io_uring/opdef.c
>> @@ -759,6 +759,7 @@ const struct io_cold_def io_cold_defs[] = {
>>         },
>>         [IORING_OP_URING_CMD] = {
>>                 .name                   = "URING_CMD",
>> +               .sqe_copy               = io_uring_cmd_sqe_copy,
>>                 .cleanup                = io_uring_cmd_cleanup,
>>         },
>>         [IORING_OP_SEND_ZC] = {
>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>> index e204f4941d72..f682b9d442e1 100644
>> --- a/io_uring/uring_cmd.c
>> +++ b/io_uring/uring_cmd.c
>> @@ -205,16 +205,25 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>         if (!ac)
>>                 return -ENOMEM;
>>         ac->data.op_data = NULL;
>> +       ioucmd->sqe = sqe;
>> +       return 0;
>> +}
>> +
>> +int io_uring_cmd_sqe_copy(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>> +                         unsigned int issue_flags)
> 
> Is it necessary to pass the sqe? Wouldn't it always be ioucmd->sqe?
> Presumably any other opcode that implements ->sqe_copy() would also
> have the sqe pointer stashed somewhere. Seems like it would simplify
> the core io_uring code a bit not to have to thread the sqe through
> several function calls.

It's not necessary, but I would rather get rid of needing to store an
SQE since that is a bit iffy than get rid of passing the SQE. When it
comes from the core, you _know_ it's going to be valid. I feel like you
need a fairly intimate understanding of io_uring issue flow to make any
judgement on this, if you were adding an opcode and defining this type
of handler.


>> +{
>> +       struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
>> +       struct io_async_cmd *ac = req->async_data;
>> +
>> +       if (sqe != ac->sqes) {
> 
> Maybe return early if sqe == ac->sqes to reduce indentation?

Heh, the current -git version has it like that, since yesterday. So
yeah, I agree.

>> @@ -251,8 +260,12 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>>         }
>>
>>         ret = file->f_op->uring_cmd(ioucmd, issue_flags);
>> -       if (ret == -EAGAIN || ret == -EIOCBQUEUED)
>> -               return ret;
>> +       if (ret == -EAGAIN) {
>> +               io_uring_cmd_sqe_copy(req, ioucmd->sqe, issue_flags);
> 
> Is it necessary to call io_uring_cmd_sqe_copy() here? Won't the call
> in io_queue_async() already handle this case?
> 

Good point, yes it should not be necessary at all. I'll kill it.

>> +               return -EAGAIN;
>> +       } else if (ret == -EIOCBQUEUED) {
> 
> nit: else could be omitted since the if case diverges

With the above removal of cmd_sqe_copu(), then this entire hunk goes
away.

-- 
Jens Axboe

