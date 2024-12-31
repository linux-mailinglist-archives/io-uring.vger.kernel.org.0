Return-Path: <io-uring+bounces-5642-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D2BB9FEBC2
	for <lists+io-uring@lfdr.de>; Tue, 31 Dec 2024 01:13:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 554631882A92
	for <lists+io-uring@lfdr.de>; Tue, 31 Dec 2024 00:13:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CFC836D;
	Tue, 31 Dec 2024 00:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ro+HEflr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD35E163
	for <io-uring@vger.kernel.org>; Tue, 31 Dec 2024 00:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735604000; cv=none; b=kZSYjdUbttecfqJmJTBvmYtsVn8tztsZ0GrSEqFat5p3e2TiufzkuuG4vSXAZJcW/ccl2j1Ntpl51/s/XRFE53HWo3Kewk+sj5LnTm2mZ47BiIx1iwapfWa1l0MNCfakhifmP22OqFOqpJyoIzj4xMcUiZ9GEn/z/ZjUqzh1ejQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735604000; c=relaxed/simple;
	bh=5oNlkK+CfjG+3LCajdhL1Ar58kBGxyYf1JXr6C2trDM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lsz91Nzv5/UN3mTrJNJwYR6Odw7AwaBPPZ4/HI7gATQAapP1AcOvO1R7AuxMwVv9IDmHBtJYA9u7Uq5VQSHpYl+z1z5e2CQrKQNh5XaKcGVSTRo9kF9tQEApGnWDLXavS9y2pawj29UjcWVUmrzZ4IF2Mgi4+lQ6m+Mhm8eQq2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ro+HEflr; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2eeb4d643a5so13142568a91.3
        for <io-uring@vger.kernel.org>; Mon, 30 Dec 2024 16:13:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1735603996; x=1736208796; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=15ywTqFuRE+m18j9c+tnqw6PnvvvA2E6epIAQ4hw4NI=;
        b=Ro+HEflrlGrE/rElfKnGjVl0eVZNkxDKeh8mK5ErwmS2DznVcMJunZR44MsS6XE8Lu
         V93Eht7I/qtzWVb68paQAKxmNzXBKdXxwQaxWa68nFWG5h2paprJNEeq7OxELZfkPHYQ
         6JiZSzktjac6fpuhle9aAkC9CJ3ZOvCrd/sO8Hgu/WnxCkUM7pOWY3MLEb2ctZrT8U+l
         X0pWknJZWvHald2NDx3rlEklWtHX/oZDLC2jalwUNWWRVzKIKZcq7m5p8RxNybKQ8UY8
         0Mfnwsqg6tnPmDlLthKokiFe/3bSPybWNrxy2eGFMIBuXUFywhKN2ME3WfW31AV3bYOm
         qsSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735603996; x=1736208796;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=15ywTqFuRE+m18j9c+tnqw6PnvvvA2E6epIAQ4hw4NI=;
        b=m/juvD/HUaWhEjut6jmDbjUhUxNsPpqgmM6Mo7pHopM/wiX84dM6AZ94SWwvxLtzuz
         DAHBiiBlCmG7Ol2kqgzGIbbDckKIh9D2VnxSSQhEo0Vo1thiWnpFwiwj/JT3SRQki1HZ
         x1WhUSmjpCwTlWpdAolDOURzCBU67etIVxO3gu9vJQkfukSWmYJZZhZXxD/CHpKskM6V
         zoy4b6eZkqlA1BKRWrHw1wuQX6MBnQ6cmY/+I6CgcUGtNNKrJqLnS/dqTH8bHUpKPR84
         uHQFO6qzjmunaF0780JDdh7+30/IMNqcbmx+waN447tt7483FRnWRMhh65jPIJcAI9i8
         teQQ==
X-Gm-Message-State: AOJu0Yzm4YHqAO6h2MypOc6xEhqhMnA3pMEAvjbA/2esTPPpRiZThhR3
	hs4eeDfw/MCGwAEKiQPaYCwg5wmW4olffVgyQr19f5+A0XRnmnwsHX9WvFEtdr6z5/oGhTYCNKY
	E
X-Gm-Gg: ASbGncvpaQkac1iu+lLk7iLs0aHq/Rb2I87hYVe/Ug/T+oSBubpS05r964eIk2CDVNc
	Km2nVi0TmNKCe/vI3KasyUuBYK2ZWrqXOgbTIddtyDYOIa+0NgNVgmI5CVI2anU4rwVmHB1LWWB
	RucMjIwfBdsEQTOwhTgZKG3AnM06IzjgybWbYXJSqtpRLSDYLwa9sMSlNaSQdUaPNZPJeFBzdIf
	x7oYgxvbca9O4LV4gj9hlQLTOxT6S7/Qgs3cZEisU7ol6MzqD/zNQ==
X-Google-Smtp-Source: AGHT+IHkrX3hoNe0Na//goFXM6nbOmX7xQPFfRjB0k6NlTKA8VaYWEN0pBRciuuwt5Vx0kUDUtp55w==
X-Received: by 2002:a17:90b:524b:b0:2ee:9d49:3ae6 with SMTP id 98e67ed59e1d1-2f452e1d12fmr55616766a91.10.1735603996111;
        Mon, 30 Dec 2024 16:13:16 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f2ed82d273sm23268342a91.30.2024.12.30.16.13.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Dec 2024 16:13:15 -0800 (PST)
Message-ID: <7b9f9a66-4ebb-4f01-9226-b1002e7b0ddf@kernel.dk>
Date: Mon, 30 Dec 2024 17:13:14 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rw: always clear ->bytes_done on io_async_rw
 setup
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring <io-uring@vger.kernel.org>
References: <1e3d150c-8d0c-42b9-b479-0aa55f0ab86f@kernel.dk>
 <87wmfh6tlz.fsf@mailhost.krisman.be>
 <394c611c-4089-4137-b690-939bf544e6a8@kernel.dk>
 <87seq47p0o.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87seq47p0o.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/30/24 4:02 PM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 12/30/24 9:08 AM, Gabriel Krisman Bertazi wrote:
>>> Jens Axboe <axboe@kernel.dk> writes:
>>>
>>>> A previous commit mistakenly moved the clearing of the in-progress byte
>>>> count into the section that's dependent on having a cached iovec or not,
>>>> but it should be cleared for any IO. If not, then extra bytes may be
>>>> added at IO completion time, causing potentially weird behavior like
>>>> over-reporting the amount of IO done.
>>>
>>> Hi Jens,
>>>
>>> Sorry for the delay.  I went completely offline during the christmas
>>> week.
>>
>> No worries, sounds like a good plan!
>>
>>> Did this solve the sysbot report?  I'm failing to understand how it can
>>> happen.  This could only be hit if the allocation returned a cached
>>> object that doesn't have a free_iov, since any newly kmalloc'ed object
>>> will have this field cleaned inside the io_rw_async_data_init callback.
>>> But I don't understand where we can cache the rw object without having a
>>> valid free_iov - it didn't seem possible to me before or now.
>>
>> Not sure I follow - you may never have a valid free_iov, it completely
>> depends on whether or not the existing rw user needed to allocate an iov
>> or not.
> 
>> Hence it's indeed possible that there's a free_iov and the user
>> doesn't need or use it, or the opposite of there not being one and the
>> user then allocating one that persists.
>>
>> In any case, it's of course orthogonal to the issue here, which is that
>> ->bytes_done must _always_ be initialized, it has no dependency on a
>> free_iovec or not. Whenever someone gets an 'rw', it should be pristine
>> in that sense.
> 
> I see. In addition, I was actually confusing rw->free_iov_nr with
> rw->bytes_done when writing my previous message.  The first needs to
> have a valid value if ->free_iov is valid. Thanks for the explanation
> and making me review this code.

Ah right, yes free_iov_nr would obviously need to be valid if free_iov
is set.

> The fix looks good to me now, obviously.

Thanks for checking!

-- 
Jens Axboe

