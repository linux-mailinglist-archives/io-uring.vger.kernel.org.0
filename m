Return-Path: <io-uring+bounces-10077-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 25882BF770E
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 17:42:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE84D1884B33
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 15:42:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E81412F3602;
	Tue, 21 Oct 2025 15:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="21sxfgts"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4461D8DE1
	for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 15:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761061340; cv=none; b=ZrvXip8QkOXdqST9UVkrTNkHjGLsWC+IqAjO9XFzZLk2Mwh6bUKiEWHZFm29tGLSu27or04hWuHw0MPB7Ody9SLLwj6muC7gZyXKK1Sj1VOsWd7+CwIyxE5L2+Q35H/ufwp3oRWIzV64sGmGJWjz//DcY3E15/E5Cgpf+nJ0SEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761061340; c=relaxed/simple;
	bh=HHHwHrYNJDMySyUENdRJ0VtHCOQTe2XF0OSsOB+XWxA=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=HSnaHfd2LBaxZNPzDF5m/3UWD8oifovwYFLBGQkdS/i29zO1ZkUVC+iyva4GH+QvpligVQCofcyg6arRWUIo5f5LowZg5FJcRgGHqTEt4sUvlMP38z06mXIz/YNkr+09unXumjWWwSEkgAKK5qiqhx1MvFAxGl98jYiKHvdfD4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=21sxfgts; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-940d27610b8so138856439f.1
        for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 08:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761061335; x=1761666135; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZBel5uSDEdI4b8eCpf2f0FxDbxDbDlCuDy/tUy9bv2s=;
        b=21sxfgtsjjO5WK4QS8myfMAvShyJiHXL4KBrNrLxo41BY83WIxlnq9xJNSTe/1yk1F
         0ROdcBSEn/CXk3YC7d+jH0qB1mCbvkZa8qwsqPaVOOTbLlq9SWfRD6rO5Y7swMNL8aS3
         fwP+tZvLW4BWBaGtt67Dckz+NCp7pbHCYp6VLEFWgXJvTQad8TIqf5vI+mzCCvQUy1Hd
         6B/HFIfcq0H55JIfIXTdIfhsCWPdbcypQwU/9b7jGopWgNqrY7ITFb2nOwb06nC0OmqA
         GCzY2ovdd9yzxV/HoTC7MLvBs/v/v/n30+JzwhIE/1wvqccgXeRwQ6JmjVWYeevmwIoM
         6CVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761061335; x=1761666135;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZBel5uSDEdI4b8eCpf2f0FxDbxDbDlCuDy/tUy9bv2s=;
        b=rD6GeYI+VOof5pJ+gBUWBKvonPUNB7ZcQCH3XLIjZ40tmTuvOr6pw/MKGMZkl1F8KF
         JpR8RgpHqYZFWgNTloCVxUJIhe6yp7dk91DhrVcsVNSiay7LJVX9NwWQlGXdgxkZBAhj
         ITikomD7IMaeSlzFoJNsSAV3UFsfSWGcs2oJvBJvaupP5ZPlk1F7P8pLGh/kNnOtztbF
         neRfd2ZBwkKIudsuRfvR0blkly1+L4Wws3OBYWZZ9TenyNtkPBDiedsEn1yExLuWzCoU
         nT5dBzgTHMQ12PF25B0vmQoEKCQRlCs8d+2yl8i7LIGMTaVYq8I4C34WxMJT7NJXZnBd
         xsog==
X-Forwarded-Encrypted: i=1; AJvYcCVCbb6ocFi+/iePZIjlS0RavJy7dFMAcgFWFSY++Pj3vP9ejopeVHueRMHFKXiisv6bK4ixunKO3w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7YFQshb9PDKQiDNamMG7ICR6H8e3JrsMsnYGsQb+tJgKVyD55
	GfcNEWs7Ah8XJ5hR6FXP8RZ1w1UsQWEZDrUqt3zcvZgIFz1YJrD5vGCksK4u/JE+GVY=
X-Gm-Gg: ASbGncsn7wM410UyiIBXoeVxojNGB9Tl9mz8VKF8F30gYDZuOKBwgVrJouSGsDENvY9
	WBsTxINfOUbyw7q+56AO+LS4EXWkJ/EhZcawUJ3lxuZke/KuqdpfO09xlJph6R/fOXlAVBcHwco
	FuhasJw8LZhQT5/ACvJFvUHbaHUJu73pfolqWGRCdMzAIenCNvdMESV+2EfkUlByy/UipjF9z/M
	75hv21XglA2qGV/7JW6VbU8d9JA8QPIlGddcipvVobVoLFcIioaAE3FcA87jwQaQNGf17T+Pmah
	JZwaxlhtnfG716gV0rTwJruuSKI60hGFtZm5sIEjVgpEFsmw9GV/eA0hmNrtHYxh5+424lmSE2O
	mX/cOLm9OZozt+wvo6n1AAWZPR/HxOHKk9QRk7SviqXh7nDDzrItPYQnA/MZ8hib9AQzXrTYp
X-Google-Smtp-Source: AGHT+IE+SWhwxP4i/T8bP4vsbRUk44CO3rcBorxlIErr5JQbIUDHpW0qN6ShKVC53o9/YCnO+4GTBA==
X-Received: by 2002:a05:6602:1484:b0:940:d886:c76f with SMTP id ca18e2360f4ac-940d886ca05mr1252110039f.8.1761061334992;
        Tue, 21 Oct 2025 08:42:14 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-93e8663c7b6sm411649439f.6.2025.10.21.08.42.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 08:42:14 -0700 (PDT)
Message-ID: <0cc942d8-20a4-43ff-82b6-88a6119662d8@kernel.dk>
Date: Tue, 21 Oct 2025 09:42:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: move zcrx into a separate branch
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <989528e611b51d71fb712691ebfb76d2059ba561.1755461246.git.asml.silence@gmail.com>
 <175571404643.442349.8062239826788948822.b4-ty@kernel.dk>
 <64a4c560-1f81-49da-8421-7bf64bb367a0@gmail.com>
 <7a8c84a4-5e8f-4f46-a8df-fbc8f8144990@kernel.dk>
 <b10cb42e-0fb5-4616-bb44-db3e7172ccdc@gmail.com>
 <12e1e244-4b85-4916-83ab-3358b83d8c3c@kernel.dk>
 <57bf5caa-e25e-44e6-ba55-b26bb3930917@gmail.com>
 <f49721ac-d8bb-45f5-ab4b-f75f7ac4c2cc@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f49721ac-d8bb-45f5-ab4b-f75f7ac4c2cc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/21/25 7:44 AM, Pavel Begunkov wrote:
> On 10/20/25 19:34, Pavel Begunkov wrote:
>> On 10/20/25 19:01, Jens Axboe wrote:
>>> On 10/20/25 11:41 AM, Pavel Begunkov wrote:
>>>> On 10/20/25 18:07, Jens Axboe wrote:
>>>>> On 10/17/25 6:37 AM, Pavel Begunkov wrote:
>>>>>> On 8/20/25 19:20, Jens Axboe wrote:
>>>>>>>
>>>>>>> On Sun, 17 Aug 2025 23:43:14 +0100, Pavel Begunkov wrote:
>>>>>>>> Keep zcrx next changes in a separate branch. It was more productive this
>>>>>>>> way past month and will simplify the workflow for already lined up
>>>>>>>> changes requiring cross tree patches, specifically netdev. The current
>>>>>>>> changes can still target the generic io_uring tree as there are no
>>>>>>>> strong reasons to keep it separate. It'll also be using the io_uring
>>>>>>>> mailing list.
>>>>>>>>
>>>>>>>> [...]
>>>>>>>
>>>>>>> Applied, thanks!
>>>>>>
>>>>>> Did it get dropped in the end? For some reason I can't find it.
>>>>>
>>>>> A bit hazy, but I probably did with the discussions on the netdev side
>>>>> too as they were ongoing.
>>>>
>>>> The ones where my work is maliciously blocked with a good email
>>>> trace to prove that? How is that relevant though?
>>>
>>> I have no horse in that game so don't know which thread(s) that is (nor
>>> does it sound like I need to know), I just recall Mina and/or someone
>>> else having patches for this too. Hence I dropped it to get everyone
>>> come to an agreement on what the appropriate entry would be.
>>>
>>> FWIW, I don't think there's much point to listing a separate branch.
>>
>> I sent this patch because last cycle I was waiting for roughly a
>> month for zcrx to be merged, and hence I started managing a branch
>> anyway, which also turned out to be simpler and more convenient for
>> me than the usual workflow. Not blaming anyone, but that's how it went.
>> And there were a couple of (trivial) patches from folks.
> 
> To get some clarity, are you going to pick it up?

Wasn't planning on it, please work with Jakub/Mina/netdev crew for an
entry that everybody is happy with.

-- 
Jens Axboe

