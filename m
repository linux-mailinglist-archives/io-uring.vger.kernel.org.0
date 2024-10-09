Return-Path: <io-uring+bounces-3485-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CA44996F95
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 17:26:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 709191C21C92
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 15:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35D511DFE2B;
	Wed,  9 Oct 2024 15:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SttTR2M3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5031DFE1D;
	Wed,  9 Oct 2024 15:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728486842; cv=none; b=YGw1I2UA932jxDH67EcVWKTa07Daif7I0HPfOLkwLENDj0Pt1QoSwDbdz1DSgQ+U33tMWx8jnn6KY1Ru/c+UiiTYXzp6VP/5gAYehki7YCnL+AuNGnfwfZlXUDfDSY3Tp54if5QSY5QIDDA3TmMm1zjWgVDq1U9agA5dFWoWp3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728486842; c=relaxed/simple;
	bh=oIpEquwkhRkWzicmsW4WSv3aMjIpPoxplat2oFHVQIk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QsyCh0Mobonop8trwxuapjdFrwOc7Z1ncqp0UaU4Xp/3hWlQfGultbF8zGf6VR0HpuuC5zlu7YMtTgx4ODRDf3/mGC0KeNlP5O76TYzGZKYotla+gtCB4rcCRDRa0alq5oCHELz1xLZ0PV+2RJsiQHn0KIZu8f+zS6XmEB1X+7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SttTR2M3; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a99415adecaso182747066b.0;
        Wed, 09 Oct 2024 08:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728486839; x=1729091639; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R/5SJOAdeOMCf7jQsw/2LoVsitarYvprp05Pq3BIZbY=;
        b=SttTR2M3EiJMpJCQCOzEUjlSKMHIGpNyYmi4hbzttzjhvBFEnDm0UQpkXNkbAd7ziD
         ecrTA5tXNn1XzZJ3Fegytt5Mxwi1MhmzGYT7r+Uuda7K0DpdlwpkOn1XLZVQ58EUSfXo
         /ITSiic6c3E603o0fOqD0ZsAQBV76z97tcsk81zxIDsULVBKZtUXPNnubt2atiA2v6Cs
         nzNE4oxRJ1yL6JuUbQsSZ+fxi43SlRM6OY1ETaCi1dwdF3ff7FoQc0S3WViqYyEHYa7X
         CSLp1Lw4HNtjhQMkv+34e0OW5E6+9J9SNJ2C1tl2jJbgkUtCQu9tIH+ZdHfRiSQWmbwv
         +uUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728486839; x=1729091639;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R/5SJOAdeOMCf7jQsw/2LoVsitarYvprp05Pq3BIZbY=;
        b=kJmAf8r7vNMSCvjCXy9o4pvpEjYSBcokgn4C5wrzs9wzDSSVlQUEItkibsQIRvqpxC
         L2XVT/NKwBw69ZPfwae+Hsb6oYNXtPH8VnI50wYQZYP9HwtqvafrJGDm4GJwYzRnIkPL
         0lg8L7ojrLC3knTGZx/KafIlO18uwXX6+IBA0lOwHtMOvaQjk9zqXVxUqZ5ywqsiJlnQ
         0W0ObpMhAIlx09zvASNzNXp7ktE3vfP4iopxBIymldpAjzDY7YN7YU74nWOSS4yh4ENz
         obOrEXZyDkEsEvpodUL4UO+4tZocBdoLda4/spSaV/skRPK1y1GLZBurv5qknNQ6f8BK
         YZmA==
X-Forwarded-Encrypted: i=1; AJvYcCV5vI+6iKWqvhkN0X7pJUBjiQt7tjRyoYZ5EfiS1FjIcLV5t4tYqJUhY+HTEEAPFzxHPfdlDH2VAw==@vger.kernel.org, AJvYcCWSxQtkW93IQUKf9zXVdFlJL2ck1U5AIku9reqQYHRlq61C+d76wMNgEdbkTzGclpu6PUsu1P+uphoyr5o=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGMi1oK0v+iSPrUh3KtqWDl7VxAdbW5G21tBTxoAM5ByIjAPda
	rxPEAZpQhGBSzOlycHKOCWFT3jngHKpUuarPG67MnnNo2G9KD0C5xZyeyA==
X-Google-Smtp-Source: AGHT+IG3ryKV2/f5K5YScIZrwvFYSltp/YhrSMo0bATbVkEFenQaJ2Z8Pd2yf0gWy3JPkMIP9cCIWQ==
X-Received: by 2002:a17:907:7f12:b0:a99:5f65:fd9a with SMTP id a640c23a62f3a-a9967a7bd65mr862378066b.21.1728486838447;
        Wed, 09 Oct 2024 08:13:58 -0700 (PDT)
Received: from [192.168.42.207] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9938908908sm621471566b.126.2024.10.09.08.13.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 08:13:57 -0700 (PDT)
Message-ID: <38ad4c05-6ee3-4839-8d61-f8e1b5219556@gmail.com>
Date: Wed, 9 Oct 2024 16:14:33 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 7/8] io_uring/uring_cmd: support provide group kernel
 buffer
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org
References: <20240912104933.1875409-1-ming.lei@redhat.com>
 <20240912104933.1875409-8-ming.lei@redhat.com>
 <b232fa58-1255-44b2-92c9-f8eb4f70e2c9@gmail.com> <ZwJObC6mzetw4goe@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZwJObC6mzetw4goe@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/6/24 09:46, Ming Lei wrote:
> On Fri, Oct 04, 2024 at 04:44:54PM +0100, Pavel Begunkov wrote:
>> On 9/12/24 11:49, Ming Lei wrote:
>>> Allow uring command to be group leader for providing kernel buffer,
>>> and this way can support generic device zero copy over device buffer.
>>>
>>> The following patch will use the way to support zero copy for ublk.
>>>
>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>>> ---
>>>    include/linux/io_uring/cmd.h  |  7 +++++++
>>>    include/uapi/linux/io_uring.h |  7 ++++++-
>>>    io_uring/uring_cmd.c          | 28 ++++++++++++++++++++++++++++
>>>    3 files changed, 41 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
>>> index 447fbfd32215..fde3a2ec7d9a 100644
>>> --- a/include/linux/io_uring/cmd.h
>>> +++ b/include/linux/io_uring/cmd.h
>>> @@ -48,6 +48,8 @@ void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
>>>    void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
>>>    		unsigned int issue_flags);
>>> +int io_uring_cmd_provide_kbuf(struct io_uring_cmd *ioucmd,
>>> +		const struct io_uring_kernel_buf *grp_kbuf);
>>>    #else
>>>    static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>>>    			      struct iov_iter *iter, void *ioucmd)
>>> @@ -67,6 +69,11 @@ static inline void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
>>>    		unsigned int issue_flags)
>>>    {
>>>    }
>>> +static inline int io_uring_cmd_provide_kbuf(struct io_uring_cmd *ioucmd,
>>> +		const struct io_uring_kernel_buf *grp_kbuf)
>>> +{
>>> +	return -EOPNOTSUPP;
>>> +}
>>>    #endif
>>>    /*
>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>>> index 2af32745ebd3..11985eeac10e 100644
>>> --- a/include/uapi/linux/io_uring.h
>>> +++ b/include/uapi/linux/io_uring.h
>>> @@ -271,9 +271,14 @@ enum io_uring_op {
>>>     * sqe->uring_cmd_flags		top 8bits aren't available for userspace
>>>     * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
>>>     *				along with setting sqe->buf_index.
>>> + * IORING_PROVIDE_GROUP_KBUF	this command provides group kernel buffer
>>> + *				for member requests which can retrieve
>>> + *				any sub-buffer with offset(sqe->addr) and
>>> + *				len(sqe->len)
>>
>> Is there a good reason it needs to be a cmd generic flag instead of
>> ublk specific?
> 
> io_uring request isn't visible for drivers, so driver can't know if the
> uring command is one group leader.

btw, does it have to be in a group at all? Sure, nobody would be
able to consume the buffer, but otherwise should be fine.

> Another way is to add new API of io_uring_cmd_may_provide_buffer(ioucmd)

The checks can be done inside of io_uring_cmd_provide_kbuf()

> so driver can check if device buffer can be provided with this uring_cmd,
> but I prefer to the new uring_cmd flag:
> 
> - IORING_PROVIDE_GROUP_KBUF can provide device buffer in generic way.

Ok, could be.

> - ->prep() can fail fast in case that it isn't one group request

I don't believe that matters, a behaving user should never
see that kind of failure.


>> 1. Extra overhead for files / cmds that don't even care about the
>> feature.
> 
> It is just checking ioucmd->flags in ->prep(), and basically zero cost.

It's not if we add extra code for each every feature, at
which point it becomes a maze of such "ifs".

>> 2. As it stands with this patch, the flag is ignored by all other
>> cmd implementations, which might be quite confusing as an api,
>> especially so since if we don't set that REQ_F_GROUP_KBUF memeber
>> requests will silently try to import a buffer the "normal way",
> 
> The usage is same with buffer select or fixed buffer, and consumer
> has to check the flag.

We fails requests when it's asked to use the feature but
those are not supported, at least non-cmd requests.

> And same with IORING_URING_CMD_FIXED which is ignored by other
> implementations except for nvme, :-)

Oh, that's bad. If you'd try to implement the flag in the
future it might break the uapi. It might be worth to patch it
up on the ublk side, i.e. reject the flag, + backport, and hope
nobody tried to use them together, hmm?

> I can understand the concern, but it exits since uring cmd is born.
> 
>> i.e. interpret sqe->addr or such as the target buffer.
> 
>> 3. We can't even put some nice semantics on top since it's
>> still cmd specific and not generic to all other io_uring
>> requests.
>>
>> I'd even think that it'd make sense to implement it as a
>> new cmd opcode, but that's the business of the file implementing
>> it, i.e. ublk.
>>
>>>     */
>>>    #define IORING_URING_CMD_FIXED	(1U << 0)
>>> -#define IORING_URING_CMD_MASK	IORING_URING_CMD_FIXED
>>> +#define IORING_PROVIDE_GROUP_KBUF	(1U << 1)
>>> +#define IORING_URING_CMD_MASK	(IORING_URING_CMD_FIXED | IORING_PROVIDE_GROUP_KBUF)
> 
> It needs one new file operation, and we shouldn't work toward
> this way.

Not a new io_uring request, I rather meant sqe->cmd_op,
like UBLK_U_IO_FETCH_REQ_PROVIDER_BUFFER.

-- 
Pavel Begunkov

