Return-Path: <io-uring+bounces-9821-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D4BCB59B9F
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 17:12:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75DAA16BD6C
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 15:07:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C669A259C98;
	Tue, 16 Sep 2025 15:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hyZNF4U2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81D823D7C7
	for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 15:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758035068; cv=none; b=UM6QOLw8eReHkum/pcLxpmKTWHEOePb8CQEprhfTxXfpW9z3SxM7HkQhV0C/HYdYOTG9cBXe1CqXCja2c4lK7jcFZq22og9n4kAmtnzTc79Ff2tGYhsiMOXe98gv4yeDRPS9neOme7lJ2s4X56R5q7tXuYsdOfGzj1o9uc4eVww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758035068; c=relaxed/simple;
	bh=VRZQh5ZuG5GKFWMRdhZ6oE2jMrblGif1/SN/dyAG6bc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=EGX9JFcenS+dBSVv4TxFXAdzJYysWRzaS9dPMilOxW8/6uj3KRkn8TVd3tzHraNRzgyOHzzhniOOxy8zNlFtfEr8I14XHnhQPFhthRczIRiQLtWqieT166AfGG0iowiWbC7e9nsJ5XA1tSgt3uLOsI4IDIVIoP+lBfdjE1M1cw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hyZNF4U2; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3ea7af25f8aso938842f8f.0
        for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 08:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758035065; x=1758639865; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b1Cff2z2XyXvt7/L7ov3d8DqtXcwSFEgXrdW1Gsky3s=;
        b=hyZNF4U2CxPkyz191A2Vvab7WPzvAcwGQl+HwV+LD1Lf0yglzMryTPUKeUCe68Mwz4
         a1KL9PW2yVSq02chGipMjzUscnBaiaWBmYasZ7G5H1i/0R5ckGEpIDpjQ52woX5M3RLN
         RuugRuTGxN3qyfjZ2iOvEQ/q1web3fhpyS6W/sqjOI7wVhlKr8e6hrWa1NJEwFq02Ere
         JTOpkUPq0oAb99wffPE77ONJxzRtJQJobLfKodsZ+kxpK+EnX6o49CrvCCbw0DSIdQo/
         pzOpiE0aCLEo1W2yMXB1RUVRKgv5zJ6sIEt4mu4dctvBk2GBTkLu6f7T1f4tFmYd15W9
         dQEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758035065; x=1758639865;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b1Cff2z2XyXvt7/L7ov3d8DqtXcwSFEgXrdW1Gsky3s=;
        b=I0zYIYS3tIC9iqTftA1jFpQfRdy22w5/mXLjXgBFryTFa1UBI0YW1e1lgYV9tduAzH
         jPumOTVtpUlSZApXoW10mhoMcv/CrVIyuE3A7lo0iGyb7LiT/csVmbd2kC7hNWgvC2Hn
         jTY8f23yd3Nf9ddmhUVLsszyvfCqPQjT+AftFpGi0Sw0i8PbliTMz95EgHSnfg3ysKlL
         Bm5/FfPug5107dhxbvE9hgGaUAOnFnVcxB00mZeCb4ycivYpjd5FaUY0nkP8Ra/5xK17
         P2vPD/C/RvDoJCGp9p+xXBgJIoxZZzOxs8rvpIKrPXmGUcnViWzPV/dX5onxoknxES+B
         W4rw==
X-Forwarded-Encrypted: i=1; AJvYcCW92OwG7NTkZ4XgXfU0+SthYwLBME/+IOVXdQCA11rA1g11arAp+z1JE9ror3yzOD2/3cumVOf8Aw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyl039U4EN2fdzwQeYBA7vYsgZuYiDMwYf0nowWRbXTPNDMlD1c
	3idkHVmv5rgWjV2wRUJbS5Lic959V1snqEjZEcwqcJT0u1RqtjOM0bY0
X-Gm-Gg: ASbGnctNqko4f+OszOISIYkcCdCzbwnAWhohzj3k45SH8/JBryLm4yCmXQN8YhT2twG
	ttnhQwybWcjNaIioyPAmASbAa6H/Mwq1gidYfY+jnlTBNjFeUUs6NRbeKKUxby83b+YwIi+QCVW
	fcnyiTU+uMHJdO6UgqbKbKMRFWT4RGtmaGZWmxejNy9PhqGv0QFzac/PeRvs7IIhtHX69HNkgZ6
	I080Uaju/rBJG2xJu0k9o67Am4PTy8A4qUalS0+ah6ue/G2VtKtiMajhFZif7NEMk+2TSV8vh0F
	HC56ql2Wo2QGtCXu6hzYm6UrpkrhaQzCmORy0AcV2h7Z0gKeLRdf7Ci6KLvg6lEf0tUy2d2Vd0m
	FZX6aQQ/ZQ9MlYFPMgZJEgMccPcyELfKNsfjcQiRubpP6jKfmRZWbSQnz+aR1nx5EVA==
X-Google-Smtp-Source: AGHT+IEVIZct0UNk+G61igemd6DWjoJR7ZfppNNlwdmng5YX0rZfTe81l+sag+LSJn2DwtLfkN9CQA==
X-Received: by 2002:a05:6000:2207:b0:3ec:dbc7:3c71 with SMTP id ffacd0b85a97d-3ecdbc73cb2mr1279952f8f.62.1758035064671;
        Tue, 16 Sep 2025 08:04:24 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:8149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3eb35e4fbafsm7435049f8f.41.2025.09.16.08.04.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Sep 2025 08:04:24 -0700 (PDT)
Message-ID: <437ebe86-3183-470a-b5d3-1d5ff8557e01@gmail.com>
Date: Tue, 16 Sep 2025 16:05:56 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next] io_uring/query: check for loops in in_query()
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <2a4811de-1e35-428d-8784-a162c0e4ea8f@kernel.dk>
 <a686490e-03f0-4f21-a8d6-47451562682a@gmail.com>
 <6e347e14-9549-4025-bc99-d184f8244446@gmail.com>
 <3acf3cdc-8ace-42e6-a8a8-974442d98092@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3acf3cdc-8ace-42e6-a8a8-974442d98092@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/15/25 19:41, Jens Axboe wrote:
> On 9/11/25 5:40 AM, Pavel Begunkov wrote:
>> On 9/11/25 10:02, Pavel Begunkov wrote:
>>> On 9/11/25 01:13, Jens Axboe wrote:
>>>> io_query() loops over query items that the application or liburing
>>>> passes in. But it has no checking for a max number of items, or if a
>>>> loop could be present. If someone were to do:
>>>>
>>>>           struct io_uring_query_hdr hdr1, hdr2, hdr3;
>>>>
>>>>           hdr3.next_entry = &hdr1;
>>>>           hdr2.next_entry = &hdr3;
>>>>           hdr1.next_entry = &hdr2;
>>>>
>>>>           io_uring_register(fd, IORING_REGISTER_QUERY, &hdr1, 0);
>>>>
>>>> then it'll happily loop forever and process hdr1 -> hdr2 -> hdr3 and
>>>> then loop back to hdr1.
>>>>
>>>> Add a max cap for these kinds of cases, which is arbitrarily set to
>>>> 1024 as well. Since there's now a cap, it seems that it would be saner
>>>> to have this interface return the number of items processed. Eg 0..N
>>>> for success, and < 0 for an error. Then if someone does need to query
>>>> more than the supported number of items, they can do so iteratively.
>>>
>>> That worsens usability. The user would have to know / count how
>>> many entries there was in the first place, retry, and do all
>>> handling. It'll be better to:
>>>
>>> if (nr > (1U << 20))
>>>       return -ERANGE;
>>> if (fatal_signal_pending())
>>>       return -EINTR;
>>> ...
>>> return 0;
>>>
>>>
>>> 1M should be high enough for future proofing and to protect from
>>> mildly insane users (and would still be fast enough). I also had
>>> cond_resched() in some version, but apparently it got lost as
>>> well.
>>
>> Tested the diff below, works well enough. 1M breaks out after a
>> second even in a very underpowered VM.
> 
> Honestly I'm not sure which of the two I dislike more, I think both are
> not great in terms of API. In practice, nobody is going to ask for 1000
> entries. In practice, people will do one at the time. At the same time,
> I do like having the ability to process multiple in one syscall, even if
> it doesn't _really_ matter. Normally for interfaces like that, returning
> number of processed is the right approach. Eg when you get a signal or
> run into an error, you know where that happened. At the same time, it's

In which case you lose the error code, which can be more important.
In either case, the idea is that it should only fail if the app is
buggy, in which case the user can do it one by one while debugging.

> also a pain in the butt to use for an application if it did to hundreds
> of then. But let's be real, it will not. It'll do a a handful at most,
> and then it's pretty clear where to continue. The only real error here
> would be -EINTR, as anything would be the applications fault because

I'd rather delay non fatal signals and even more so task work
processing, it can't ever be reliable in general case otherwise
and would always need to be executed in a loop. And the execution
should be brief, likely shorter than non-interruptible sections
of many syscalls. In this sense capping at 1000 can be a better
choice.

> it's dumb or malicious, hence the only thing it'd do is submit the whole
> thing again. It's not like it's going to say "oh I got 2, which is less
> than the 5, let me restart at 3". But it now might have to, because it
> doesn't know what the error is.
> 
> Anyway, that's a long winded way of saying I kind of hate needing any
> kind of limit, but at least with returning the number of entries
> processed, we can make the limit low and meaningful rather than some
> random high number "which is surely enough for everyone" with the sole
> idea behind that being that we need to be able to detect loops. And even
> if the interface is idempotent, it's still kind of silly to need to redo
> everything in case of a potentially valid error like an -EINVAL.

It's not a valid syscall return for a correct application (when
querying is available). Query errors are returned individually.

> Are we perhaps better off just killing this linking and just doing
> single items at the time? That nicely avoids any issues related to this,
> makes the 0/-ERROR interface sane, and makes the app interface simpler
> too. The only downside is needing a few more syscalls at probe time,
> which is not something worth optimizing for imho.

You was pretty convincing insisting that extra waiting on teardown is
not tolerable. In the same spirit there were discussions on how fast
you can create rings. I wouldn't care if it's one or two extra
syscalls, but I reasonably expect that it might grow to low double
digit queries at some point, and 10-15 syscalls doesn't sound that
comfortable while that can be easily avoided.

-- 
Pavel Begunkov


