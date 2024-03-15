Return-Path: <io-uring+bounces-981-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D598687D3B5
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 19:39:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 002411C2114C
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 18:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71ADF1078B;
	Fri, 15 Mar 2024 18:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="h51kVhMA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A161094E
	for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 18:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710527936; cv=none; b=nZ3uVGuvvnKh/e0V6FAParEnMUZyOmVShu2hMb9ezLDCv1EP3VWCsfjXHXQ6wSkprNvJ56uXa3B++O1mHKzaxX5rGtSifd157nSYbHRkbqftNu1N4ktJEH6JjkSG3vKYKj/6zrUv/CbJnFk8LFJTmk77jhI/YEltcR+y/mB/lQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710527936; c=relaxed/simple;
	bh=FE5FZcflrFydjv5wTobXzCovvh8a51nGES68yu61N/E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jKgpjl5oHYVE1GD8ZfA5OT2Ybha3+LNrCYy05+69/9RiC+Jb7Pr6bt7yWThT7HUSyBhrC+RX5E2I8x8mVgEFI1BhNXpqJnZhNaXo1e9KF/YKdc+8JMHgsLznSQfMF4HdrQAFssneOgfu90BUELeoAqodhBCW22yqJKQk/CReOJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=h51kVhMA; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e6c9f6e654so520237b3a.0
        for <io-uring@vger.kernel.org>; Fri, 15 Mar 2024 11:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710527933; x=1711132733; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zx/QYGqeBwxOWirQqOSQxBOr3DvYw7fB8m99OMMWAOI=;
        b=h51kVhMAnrXdVbWCLH9by8ntxGI95/I37Kl70aLjd87ZLTDZHKrb2Y/sO202wI2lJP
         JWQ6vgSi2CK+JMlMu1D/oIpksnAMrLBDFypHoaXI12a6YHU2+Pjd2BqmFqMz7OF8iIqF
         K5lE18X80R/fmWPZNL3cdeFLY+tWn/+R20XNBMpZk70SFi+1TZ4IO6bDqwF1s9refLp6
         v4MBxsvap03t2/yEe5MiXGI1iek5FeqPGTEUf80Q+29N6YJncqHPfG7IwC2p3OIMDxNK
         icDayiZCiZF68X+oX3/xK72vJ8amoOuXzQL60rDQ9r0CS3azBLeogPjJFKTt/JR7mWp9
         rB0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710527933; x=1711132733;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zx/QYGqeBwxOWirQqOSQxBOr3DvYw7fB8m99OMMWAOI=;
        b=ns4eQEAtmvY/w79OPivNh3qSEbigjJe8msOEyKvn/feEepjq44v4bvAR1wdjwR2cby
         VKje+epbIbMmBMmSJc7yxvYEyJ+twq+zp3p3yxjCej7rmh13PWbR5fJGVuYUfbMbZhpg
         ojpe1qlFHRSC6rZgEossOrMiI0elWOC3SM66b9tEdkYJ9W92iJyAjPrS+rleRdXOv7Gl
         OAyPuEORpLfTpD0T2w3/fqclAY3RIzVGt7HIa+twSI5YHDK13LWekoFC0+2p7k/hCAq+
         kbYblY3XUlulQ6GGH4Q9xBs+gxp7i6hnZFl+ExOHVfFJEF86koAOJp+Q83if6CMuBMi4
         g4jQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5Xe3tsYT/CBx1rA46gUjlq+4wD/TPiecn9D7YuWVfVYTPg3iD8ZyafYI4H15j7Jf291GWWZPSnAdM9U311zFoEF395adBH3U=
X-Gm-Message-State: AOJu0YwcHhAKcrW1lJP5ni9cBGUjWDto3aXfir56jzMxOSvxxVe7ecWs
	fSyJVbUVR8JZh2HlRmXMjpolpLzUAAarXx8OXSpaWf7gSwC1WY1zucqeXlvMxlg=
X-Google-Smtp-Source: AGHT+IGf15HhF6EiHl5W/TRSFTz000lHp9JTfa+1Aw89T4HQ3sxH+AGMGHezP87wJs1tLIIxGqo0Iw==
X-Received: by 2002:a17:90a:bf13:b0:29b:9d97:b98c with SMTP id c19-20020a17090abf1300b0029b9d97b98cmr3706785pjs.2.1710527933150;
        Fri, 15 Mar 2024 11:38:53 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id sw11-20020a17090b2c8b00b0029bcaaf2baasm3289994pjb.3.2024.03.15.11.38.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 11:38:52 -0700 (PDT)
Message-ID: <1e49ba1e-a2b0-4b11-8c36-85e7b9f95260@kernel.dk>
Date: Fri, 15 Mar 2024 12:38:50 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v4 13/16] io_uring: add io_recvzc request
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20240312214430.2923019-1-dw@davidwei.uk>
 <20240312214430.2923019-14-dw@davidwei.uk>
 <7752a08c-f55c-48d5-87f2-70f248381e48@kernel.dk>
 <4343cff7-37d9-4b78-af70-a0d7771b04bc@gmail.com>
 <c4871911-5cb6-4237-a0a3-001ecb8bd7e5@kernel.dk>
 <e646d731-dec9-4d2e-9e05-dbb9b1183a0b@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e646d731-dec9-4d2e-9e05-dbb9b1183a0b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/15/24 11:34 AM, Pavel Begunkov wrote:
> On 3/14/24 16:14, Jens Axboe wrote:
> [...]
>>>>> @@ -1053,6 +1058,85 @@ struct io_zc_rx_ifq *io_zc_verify_sock(struct io_kiocb *req,
>>>>>        return ifq;
>>>>>    }
>>>>>    +int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>> +{
>>>>> +    struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
>>>>> +
>>>>> +    /* non-iopoll defer_taskrun only */
>>>>> +    if (!req->ctx->task_complete)
>>>>> +        return -EINVAL;
>>>>
>>>> What's the reasoning behind this?
>>>
>>> CQ locking, see the comment a couple lines below
>>
>> My question here was more towards "is this something we want to do".
>> Maybe this is just a temporary work-around and it's nothing to discuss,
>> but I'm not sure we want to have opcodes only work on certain ring
>> setups.
> 
> I don't think it's that unreasonable restricting it. It's hard to
> care about !DEFER_TASKRUN for net workloads, it makes CQE posting a bit

I think there's a distinction between "not reasonable to support because
it's complicated/impossible to do so", and "we prefer not to support
it". I agree, as a developer it's hard to care about !DEFER_TASKRUN for
networking workloads, but as a user, they will just setup a default
queue until they wise up. And maybe this can be a good thing in that
they'd be nudged toward DEFER_TASKRUN, but I can also see some head
scratching when something just returns (the worst of all error codes)
-EINVAL when they attempt to use it.

> cleaner, and who knows where the single task part would become handy.

But you can still take advantage of single task, since you know if
that's going to be true or not. It just can't be unconditional.

> Thinking about ifq termination, which should better cancel and wait
> for all corresponding zc requests, it's should be easier without
> parallel threads. E.g. what if another thread is in the enter syscall
> using ifq, or running task_work and not cancellable. Then apart
> from (non-atomic) refcounting, we'd need to somehow wait for it,
> doing wake ups on the zc side, and so on.

I don't know, not seeing a lot of strong arguments for making it
DEFER_TASKRUN only. My worry is that once we starting doing that, then
more will follow. And honestly I think that would be a shame.

For ifq termination, surely these things are referenced, and termination
would need to wait for the last reference to drop? And if that isn't an
expected condition (it should not be), then a percpu ref would suffice.
Nobody cares if the teardown side is more expensive, as long as the fast
path is efficient.

Dunno - anyway, for now let's just leave it as-is, it's just something
to consider once we get closer to a more finished patchset.

> The CQ side is easy to support though, put conditional locking
> around the posting like fill/post_cqe does with the todays
> patchset.

Yep, which is one of the reasons why I was hopeful this could go away!

-- 
Jens Axboe


