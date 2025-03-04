Return-Path: <io-uring+bounces-6954-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B915BA4F0AE
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 23:46:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C92A9188D4CD
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 22:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B04221FBCA2;
	Tue,  4 Mar 2025 22:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UmiWaaof"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF37E1DDC14;
	Tue,  4 Mar 2025 22:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741128403; cv=none; b=by7NrVgIaIc4q4eBVs2SdTNC4m4e6VQoXq2F6deYAqsEieDsI7ugbEdiBVA9W3xEt/wW6AG/q8dHLPQcj3BCvTb10PrAyiWcmLb/S7XohcfCoy292x7oj40O1jigsRETp5YABDyAfIpZO9tDimEZ6cJFY1xmUGf1uObIQ9oOdJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741128403; c=relaxed/simple;
	bh=VygENYCWiBbarTNsVf9RrCUGhuzEZXrMuNwYSB8fkM4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V8E6HxKG4ocFgIVabDLQqK2pr3SPxi+9csq9SwlYRhp09luSgSEbU1qmGGR4hjhSF2SazKRSum4UWKEYrnu2LDX+GAM/9GyaZ/A3hERAy9gK3ng4rXsTIkvQtb9OsbFnORfF1ypZ/BrERjWz856DIPkq0sOctwOWMyFfhNX010Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UmiWaaof; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-38f2f391864so3410929f8f.3;
        Tue, 04 Mar 2025 14:46:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741128400; x=1741733200; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kRyVz6x1YbuhNRQ7pPSN75qrUu/RYDbWdOLZVI+9yxY=;
        b=UmiWaaofIoORtxQoU2/YfJXOIZBuydcm9YfcaiZbcANGT53BQG7PE8DGliwCoQLfuk
         UJqeGlwjq1aOIwIEqdX2FwJdERWX4l9XY6Kaa2pkuP8Yc93Q/XfpmRaaiIad1mKYdz3+
         MN5OYuotHhxaysFbeZgL0gJN/LdJhJq4yGYvkhx1S7X0URENfTyEMi44Z6mhe6Dz87hR
         pG+VJb3ilZy0wZJM7CoqvjwcbdqE+J4jBEq09yNGKuFbPOohUf60y71VAP4wtZnahM3P
         DSMiwqzG2xd89JzDuKFTx3OYbYViOdkmIfan9dGOx4bLKlfGR5TGQUej82TVRIQOUzQ+
         N0nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741128400; x=1741733200;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kRyVz6x1YbuhNRQ7pPSN75qrUu/RYDbWdOLZVI+9yxY=;
        b=At91ExJ0Fg6QeE88gTW6YrsjZ8r9feOww7UBqwE200OVrhD8zMp4a0gthal6SxrSh4
         fjuypK1zglI5KFViaRZWdBbL7d/6RqYwn4klQ98NYALIUhOfG3Rx0klYPmrkGYC/hY8P
         SXo+RqBjQeSp/anggUF8KXm7QMgK0CG+z9CdkgqQXzHxprwQqA32+CJzB+vF3DLX1NnL
         B/qk/RESQ3PIpggfOMMWcV+1RuLtnmfUpVutIFds8Gtv/HdtfdTs35XzW87iSEnSkQEi
         DRZ4HUa/cUDXsW8pqc8pE/gfxFJmk5EjFbRBSdnbfYV4v+JgskzQR2SvaSn7Zu2qqlzk
         LzOg==
X-Forwarded-Encrypted: i=1; AJvYcCU04BZIy9n4JnZz8VpRc5P/uzLZK2LH3uYAnj/lSWwQ+Cat4zzpRzRA9vcwkMpr3F09wXMj6BdpFGQM@vger.kernel.org, AJvYcCU10Qd15MIi1SLvRvGXr3B6R0InDdsP4hSOZHOV+v3e9RgctsMZsMELpPrUNR7ecDXa80o5/OcxYw==@vger.kernel.org, AJvYcCWpofj1puFwEVPZ6KnJrXlmXOZgZFmsJ5zpl9HoJIDOSN6ATcZ+Pkshn0448coZk+sVvA897FO5/5PludfWqQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwD/xIJsod56Z/wUJGfFI7d8s4Dc8nSimpEi3mxa2U2YAlBviTc
	M8pR4VbAmpMURGneJyWFEypCNaP8La4U1tzoTmG1NGi0SF2rfMh5o+zIQA==
X-Gm-Gg: ASbGncuFQpiy5wZxOSNHMBe8s6Xk8CXKYRrzYsi5AribysWb9eNcvghkus8pg8V1vew
	fclPzCa6sebQ6acqV0nVEeAFMSGA4e/WWP/qX2zvkHa3yJS0+/Nq7rVajoPAn/eapV6Tba63jnd
	flOoPis5zAFTQdk6VzM38LIl5LfAxOrHn3+LA430qLuB4pRL7hhhxxvP+gRkK1j7/OUPtQtLBwS
	Um48DEW4q9jtKqmQbGlBtEpggGcibHvTo1lLQqK3RSwWZ7PGHOxdYXreW9eTGswm1tgi2oXjSCF
	F2F2FYNbinbr8WzeT1lzuOUk51Wycaw3iHJQJv0y3cYObeODSdaHbg==
X-Google-Smtp-Source: AGHT+IFkVGW5ZhOoHDiSj66/ast7DJZ4iFg4olBQTOGakMQgpSc4MxRp6vh0LNKqEDclR9jjv6jMZg==
X-Received: by 2002:a5d:47c9:0:b0:390:fbba:e64e with SMTP id ffacd0b85a97d-3911f7a8e4cmr497280f8f.38.1741128399728;
        Tue, 04 Mar 2025 14:46:39 -0800 (PST)
Received: from [192.168.8.100] ([185.69.144.147])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e486eea3sm18647614f8f.101.2025.03.04.14.46.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Mar 2025 14:46:38 -0800 (PST)
Message-ID: <970ec89d-4161-41f4-b66f-c65ebd4bd583@gmail.com>
Date: Tue, 4 Mar 2025 22:47:48 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] iomap: propagate nowait to block layer
To: Dave Chinner <david@fromorbit.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 linux-xfs@vger.kernel.org, wu lei <uwydoc@gmail.com>
References: <f287a7882a4c4576e90e55ecc5ab8bf634579afd.1741090631.git.asml.silence@gmail.com>
 <Z8dsfxVqpv-kqeZy@dread.disaster.area>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z8dsfxVqpv-kqeZy@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/25 21:11, Dave Chinner wrote:
...
>> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
>> index b521eb15759e..07c336fdf4f0 100644
>> --- a/fs/iomap/direct-io.c
>> +++ b/fs/iomap/direct-io.c
>> @@ -363,9 +363,14 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>>   	 */
>>   	if (need_zeroout ||
>>   	    ((dio->flags & IOMAP_DIO_NEED_SYNC) && !use_fua) ||
>> -	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode)))
>> +	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode))) {
>>   		dio->flags &= ~IOMAP_DIO_CALLER_COMP;
>>   
>> +		if (!is_sync_kiocb(dio->iocb) &&
>> +		    (dio->iocb->ki_flags & IOCB_NOWAIT))
>> +			return -EAGAIN;
>> +	}
> 
> How are we getting here with IOCB_NOWAIT IO? This is either
> sub-block unaligned write IO, it is a write IO that requires
> allocation (i.e. write beyond EOF), or we are doing a O_DSYNC write
> on hardware that doesn't support REQ_FUA.
> 
> The first 2 cases should have already been filtered out by the
> filesystem before we ever get here. The latter doesn't require
> multiple IOs in IO submission - the O_DSYNC IO submission (if any is
> required) occurs from data IO completion context, and so it will not
> block IO submission at all.
> 
> So what type of IO in what mapping condition is triggering the need
> to return EAGAIN here?

I didn't hit it but neither could prove that it's impossible.
I'll drop the hunk since you're saying it shouldn't be needed.

>>   	/*
>>   	 * The rules for polled IO completions follow the guidelines as the
>>   	 * ones we set for inline and deferred completions. If none of those
>> @@ -374,6 +379,23 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
>>   	if (!(dio->flags & (IOMAP_DIO_INLINE_COMP|IOMAP_DIO_CALLER_COMP)))
>>   		dio->iocb->ki_flags &= ~IOCB_HIPRI;
>>   
>> +	bio_opf = iomap_dio_bio_opflags(dio, iomap, use_fua, atomic);
>> +
>> +	if (!is_sync_kiocb(dio->iocb) && (dio->iocb->ki_flags & IOCB_NOWAIT)) {
>> +		/*
>> +		 * This is nonblocking IO, and we might need to allocate
>> +		 * multiple bios. In this case, as we cannot guarantee that
>> +		 * one of the sub bios will not fail getting issued FOR NOWAIT
>> +		 * and as error results are coalesced across all of them, ask
>> +		 * for a retry of this from blocking context.
>> +		 */
>> +		if (bio_iov_vecs_to_alloc(dio->submit.iter, BIO_MAX_VECS + 1) >
>> +					  BIO_MAX_VECS)
>> +			return -EAGAIN;
>> +
>> +		bio_opf |= REQ_NOWAIT;
>> +	}
> 
> Ok, so this allows a max sized bio to be used. So, what, 1MB on 4kB
> page size is the maximum IO size for IOCB_NOWAIT now? I bet that's
> not documented anywhere....
> 
> Ah. This doesn't fix the problem at all.
> 
> Say, for exmaple, I have a hardware storage device with a max
> hardware IO size of 128kB. This is from the workstation I'm typing
> this email on:
> 
> $ cat /sys/block/nvme0n1/queue/max_hw_sectors_kb
> 128
> $  cat /sys/block/nvme0n1/queue/max_segments
> 33
> $
> 
> We build a 1MB bio above, set REQ_NOWAIT, then:
> 
> submit_bio
>    ....
>    blk_mq_submit_bio
>      __bio_split_to_limits(bio, &q->limits, &nr_segs);
>        bio_split_rw()
>          .....
>          split:
> 	.....
>          /*
>           * We can't sanely support splitting for a REQ_NOWAIT bio. End it
>           * with EAGAIN if splitting is required and return an error pointer.
>           */
>          if (bio->bi_opf & REQ_NOWAIT)
>                  return -EAGAIN;
> 
> 
> So, REQ_NOWAIT effectively limits bio submission to the maximum
> single IO size of the underlying storage. So, we can't use
> REQ_NOWAIT without actually looking at request queue limits before
> we start building the IO - yuk.
> 
> REQ_NOWAIT still feels completely unusable to me....

Not great but better than not using the async path at all (i.e. executing
by a kernel worker) as far as io_uring concerned. It should cover a good
share of users, and io_uring has a fallback path, so userspace won't even
know about the error. The overhead per byte is less biting for 128K as well.

The patch already limits the change to async users only, but if you're
concerned about non-io_uring users, I can try to narrow it to io_uring
requests only, even though I don't think it's a good way.

Are you only concerned about the size being too restrictive or do you
see any other problems?

-- 
Pavel Begunkov


