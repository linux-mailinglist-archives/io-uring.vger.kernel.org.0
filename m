Return-Path: <io-uring+bounces-8685-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 38684B065CF
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 20:13:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 713DB566102
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 18:13:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73A5D298992;
	Tue, 15 Jul 2025 18:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rEGI7osx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F22725A331
	for <io-uring@vger.kernel.org>; Tue, 15 Jul 2025 18:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752603233; cv=none; b=mEMTKzBXQA3+YDfyI6dTbUDyAU3H35ihol9wqifeqIqx01LL0f3bnhfgQCQ4pGE3Lx5O5wls3D6tjpsJjMp5M/79syXagIDBM2Tr20fbLaETYahC+sZs2f+D6pHv+GQ8c0SWX8lVk78fB0znX7QoWUXA6CshN85BpVTczhCNKpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752603233; c=relaxed/simple;
	bh=jRtjZEoPwg7SZd6v0VSjmvhTtWCFsdgvnxdRTAdHco0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iDX9AMtUra5yAlV9LAh1kUEiUUq2+z8JX4BUALzOVs/wm8MemiXwimvjxWOkDcgZ4EbpmxAb1UmKSjuc90KlYsAYWjJ/raxU8yFgC1iM4lUP1xIYr0ne/8/pUQ6a74Z+OqvDg5POIfgI5HrY1UDv1HhUAPJ0Cq5j4Zu72HMiHM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rEGI7osx; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3e25355160dso14942525ab.0
        for <io-uring@vger.kernel.org>; Tue, 15 Jul 2025 11:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752603230; x=1753208030; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QXSyLwnl9NAhYrvrWml4XqFokUkcr0XU+eMEr5t27lY=;
        b=rEGI7osxBW1mfrNOKS4ORe9jivP40B8ONOXEV9KOA6GKX9Jjvd/XZqA6kTTEXZ52Gl
         EEqJYWvimpmKfTkMpiZBMhEhIJymafRMWHi0vELwSQBIQPbmgZdSPbaqyvlecETpgaYP
         /6kDrc4vpuFIWYgnKXKr8hx6ap+q1WRA7Kq9/ypJE2f1JwZgIVd+C1nmz4+b6gVLs/9p
         1B0uEhEW5s6Ik3ECYDpt1U8gEMDbK5j2x9NXAkwm3GiFaxUx5Og3gjOB5n2f1tJTxTMc
         +L1CQ/1PjmoruH+7oVJO438G8njLYDDvPf+S1CpPKdulzdcH4v1oiDQKR55iadpvPB/Q
         H96Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752603230; x=1753208030;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QXSyLwnl9NAhYrvrWml4XqFokUkcr0XU+eMEr5t27lY=;
        b=c8ryoK3j25sCeYJSWeshMEKLtERttzFMNp3sTDNGj0k2Vk3MiNBd9v68OMa8b8hKFk
         1bCXPYiroJ0Wmjqp+TRGwAudqQGo6ccrqeNj+RRLzk6ouTOV/ZHpWNiquFSDlj/D0Aut
         Hsstr+gw5xXGuxRB/jTcZREeGsDKO2mKSLrNvnvyGFmN+g4R0FJ+Smi1E4H4wC/ZWalq
         Dxr3FcfMA8yq6reyR39lSdaQZrjgYkVinnIuVI2BaEWztmYszhm244mXQ73XXk4yWYjg
         f7gFQQZqLjeYuIgNVXOAQjPB29d/dk/S8Vez58gBPMLK7hvoylb1iDyhaS+3Xv8BJ5rs
         YjyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrLEfBH8itI6/54zkRGnzQ7VEP+f0FevUkrR2PwkIV5R4SvSC0W0qCgUoPhCmivqDZRYXlCfSxUQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwldG5NR45Hdr5dim3KlbrgkDrEl9eSt4SFgjBcwaYqKPDwH/8Y
	Yg1EWjOr7yzp401XPcXXbVcxONyJSSL7SWKyUcwBQ6xLj4xEAcGU1sL04LE5NGMRbPYGqCzAOMB
	bCe5H
X-Gm-Gg: ASbGnctS68PHA+dt/MxV57ExYHV/W9XLvTqY89UEZhGM+JGeZO5Vk+0w9e1vmJKO5O8
	LEZ1uYQpHdTW1ME6xO27EXOwtyMKRUuaphIzPSWW6oZ7PWhPK5BysatDw/9yjBvptv0fzxD2Wzf
	wsEeqBvWJOCLE+YA6kxe+Ifl6dbTQpmGi5EDpPybaUKN05dylJCZInjozxMT+1lS1MhGV6mUnr0
	sI0XxInHPXHdXTbQDqpK+gLT+SF0y6B7/jDKt6KhqDf64WEpbjrShMnU4YLEHv++qZ3y7AwfQ/5
	j/4l4dHabbKsTyFSOB+ZFLmJImTf5MRImFv155PkQzIDIIHFZP9pv8ZfqvIa7oQ/DxxeF1AvIvA
	rjXW+O7nXo3zHUEEyqg==
X-Google-Smtp-Source: AGHT+IGnjIc1UsmBSeutKcpN4bz12qYPJZhR7QeBMK3X5ibiaJJyohArq2Sb8KPPV65VJ/iAmbxsUg==
X-Received: by 2002:a92:cd82:0:b0:3df:39e2:f1a8 with SMTP id e9e14a558f8ab-3e282491138mr661905ab.16.1752603229572;
        Tue, 15 Jul 2025 11:13:49 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e24611ce92sm37744195ab.6.2025.07.15.11.13.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 11:13:49 -0700 (PDT)
Message-ID: <8d9a1230-0db4-4f7a-bca8-565465d3c186@kernel.dk>
Date: Tue, 15 Jul 2025 12:13:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/poll: fix POLLERR handling
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: dw@davidwei.uk
References: <550b470aafd8d018e3e426d96ce10663da90ac45.1752443564.git.asml.silence@gmail.com>
 <62c40bff-f12e-456d-8d68-5cf5c696c743@kernel.dk>
 <dd1306f6-faae-4c90-bc1a-9f9639b102d6@gmail.com>
 <7432e60c-c34d-4929-b665-432b6d410b5b@kernel.dk>
 <3b7eb60d-9555-4fa4-a9b8-5605abd3988b@kernel.dk>
 <bf0de1c6-64e6-4a4a-b741-3fab0576339f@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <bf0de1c6-64e6-4a4a-b741-3fab0576339f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/15/25 3:06 AM, Pavel Begunkov wrote:
> On 7/14/25 21:45, Jens Axboe wrote:
>> On 7/14/25 11:51 AM, Jens Axboe wrote:
>>> On 7/14/25 9:30 AM, Pavel Begunkov wrote:
>>>> On 7/14/25 15:56, Jens Axboe wrote:
>>>>> On 7/14/25 4:59 AM, Pavel Begunkov wrote:
>>>>>> 8c8492ca64e7 ("io_uring/net: don't retry connect operation on EPOLLERR")
>>>>>> is a little dirty hack that
>>>>>> 1) wrongfully assumes that POLLERR equals to a failed request, which
>>>>>> breaks all POLLERR users, e.g. all error queue recv interfaces.
>>>>>> 2) deviates the connection request behaviour from connect(2), and
>>>>>> 3) racy and solved at a wrong level.
>>>>>>
>>>>>> Nothing can be done with 2) now, and 3) is beyond the scope of the
>>>>>> patch. At least solve 1) by moving the hack out of generic poll handling
>>>>>> into io_connect().
>>>>>>
>>>>>> Cc: stable@vger.kernel.org
>>>>>> Fixes: 8c8492ca64e79 ("io_uring/net: don't retry connect operation on EPOLLERR")
>>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>>> ---
>>>>>>    io_uring/net.c  | 4 +++-
>>>>>>    io_uring/poll.c | 2 --
>>>>>>    2 files changed, 3 insertions(+), 3 deletions(-)
>>>>>>
>>>>>> diff --git a/io_uring/net.c b/io_uring/net.c
>>>>>> index 43a43522f406..e2213e4d9420 100644
>>>>>> --- a/io_uring/net.c
>>>>>> +++ b/io_uring/net.c
>>>>>> @@ -1732,13 +1732,15 @@ int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>>      int io_connect(struct io_kiocb *req, unsigned int issue_flags)
>>>>>>    {
>>>>>> +    struct poll_table_struct pt = { ._key = EPOLLERR };
>>>>>>        struct io_connect *connect = io_kiocb_to_cmd(req, struct io_connect);
>>>>>>        struct io_async_msghdr *io = req->async_data;
>>>>>>        unsigned file_flags;
>>>>>>        int ret;
>>>>>>        bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
>>>>>>    -    if (unlikely(req->flags & REQ_F_FAIL)) {
>>>>>> +    ret = vfs_poll(req->file, &pt) & req->apoll_events;
>>>>>> +    if (ret & EPOLLERR) {
>>>>>>            ret = -ECONNRESET;
>>>>>>            goto out;
>>>>>
>>>>> Is this req->apoll_events masking necessary or useful?
>>>>
>>>> good point, shouldn't be here
>>>
>>> Do you want to send a v2?
>>
>> Actually I think it can be improved/fixed further. If POLLIN is set, we
> 
> How is it related to POLLIN?

Gah POLLOUT of course.

>> should let it go through. And there should not be a need to call
>> vfs_poll() unless ->in_progress is already set. Something ala:
> 
> In any case, v1 doesn't seem to work, so needs to be done differently.

RIght, that's what I aluded to in the "improved/fixed" further. FWIW, I
did dig out the old test case I wrote for this and added it to liburing
as well. So should have somewhat better coverage now.

-- 
Jens Axboe

