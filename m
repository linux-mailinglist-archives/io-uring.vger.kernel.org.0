Return-Path: <io-uring+bounces-1574-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AECEC8A6B75
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 14:51:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 30673B224A0
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 12:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E564012BE9E;
	Tue, 16 Apr 2024 12:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sv6gjRAy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595C712BE8C
	for <io-uring@vger.kernel.org>; Tue, 16 Apr 2024 12:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713271913; cv=none; b=u7dt8ohmWxl96xaD5wscLlPkNdsDzQzY8l7qgupFfwKHbtByJtY6uzt+byX1j91Q7Ti8U/FIB7Lk/HNr1h1ew+I/dexYy2X3JEl9Yg03e64dgTLBWwe+5TRhpwXrM4EMyilj/7jJtv+aNNQyZCs03ANb//ZJGAU7wMsjn/Lec3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713271913; c=relaxed/simple;
	bh=Sq6uWkBUvGwdoFuj2Lqf+lPoGbxO34uXViHMpP4DMRc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SNWqrnvsKE5u4ySU6CQumL+oo3cCR/7ObjIUeWGMgdyG9R15BTUgH8jvFhn79ItgZMWbFmYd08xaI0JNZF/fIXtXZWCdG7+pyavwPaVfNDJdzwUCuA50lEli+ppoRtCMHE9CQBN3/pfwmqz67gB2R+2iYDVuDL4bFa7GSwI71Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sv6gjRAy; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1e4edcde7a1so9573375ad.0
        for <io-uring@vger.kernel.org>; Tue, 16 Apr 2024 05:51:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1713271911; x=1713876711; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=71H13pr4eVl70rCDLLAv/pQTxbLf7p3YZFssycXICto=;
        b=sv6gjRAyA9QmKaTvZh8u2zmn7UcHuwnExb9clvmXV/ExiJlDdIPPr6Swupw4NWOckc
         mRcp8WPQ7daor3clf4om2I/oWq+obolpVMxrBctOO4gcoBjQSIFZojoinm5L+57oWdRe
         37BpWMFYh82iCHVp272ejztDc+cAusuVfgfeizZxzxWmTDQ9yOY6vCxbUFd1eABoOol3
         zNVzx8kXRz9jfT041keKAE3y/XBYke/yNu/883yLrqJgBXXwv471p2sfMrbzTgZP7GZw
         FH/dckSPArPnBIuHgCnclC+YiD7Z/g2ihHXLGHzjOsPXnYAMVBkApwS9oc36yVD5zX9c
         6vZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713271911; x=1713876711;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=71H13pr4eVl70rCDLLAv/pQTxbLf7p3YZFssycXICto=;
        b=UyHShAGPsYM1q4oW1Sey6sJ/JK3Em6Ed0VomLfGqSGxojnX/es9ht1BKIjwHAeaSFu
         kbE7L7C+i/vQb0Ye1qALM2pxf2YxzUtNt8ZyKSE2INBApuqbnvnl9N/L1GSK9ue7Vb0f
         0FhgESUkIMBL2IAVeQFygbovUnXhn2vLXp4/QIJN651Uqhq4W2fyyeSdSDx/P1H6Mahp
         wdRQY/g7ymM5S+pd7tn8OhfsjZ1LqAr+n6N+epwZE436asomMrITq7fImhAaWyI3U90e
         h+tlUf+9IONRzkmRzXplOl16GEztV73qWCcZq2s5gBAeodAuuMDxGJUUMEAOlss81Dpi
         VNtA==
X-Forwarded-Encrypted: i=1; AJvYcCV6gQb4V31HgyOvZnYKfMAvT9lCtNKLgEGpmDMiJ/MyGv/D7on7okwVdWTEir0HnHShjxu+DZBn5pmevjTCYGP245Y2ZZUEZ+w=
X-Gm-Message-State: AOJu0YymDAIyTKdlu4xfPeYZvpAtiiO+JsF5NEfmMjMcD8zHlcOmsSNg
	B2P2fb/kjm/CsR3Tuc9x/sM7sagl6RSMRWsBOJlQwJmj/ICJIW4xHfxc1JtQ5RE=
X-Google-Smtp-Source: AGHT+IExRmUvWZnYtg2JQPBT/Sbcdr/8E8O8WxDwMOkjaqf1TGgL5/a7+4q4i9wZgERnBcNgk+Q0Jg==
X-Received: by 2002:a17:902:f682:b0:1dd:e128:16b1 with SMTP id l2-20020a170902f68200b001dde12816b1mr15706499plg.6.1713271910434;
        Tue, 16 Apr 2024 05:51:50 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id o4-20020a170902d4c400b001e41f98c48fsm9676070plg.209.2024.04.16.05.51.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Apr 2024 05:51:49 -0700 (PDT)
Message-ID: <9218e15d-d30f-470f-a09d-b88237bb02c3@kernel.dk>
Date: Tue, 16 Apr 2024 06:51:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] WARNING: CPU: 5 PID: 679 at io_uring/io_uring.c:2835
 io_ring_exit_work+0x2b6/0x2e0
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, Ming Lei <ming.lei@redhat.com>,
 Changhui Zhong <czhong@redhat.com>
Cc: Linux Block Devices <linux-block@vger.kernel.org>,
 io-uring <io-uring@vger.kernel.org>
References: <CAGVVp+WzC1yKiLHf8z0PnNWutse7BgY9HuwgQwwsvT4UYbUZXQ@mail.gmail.com>
 <06b1c052-cbd4-4b8c-bc58-175fe6d41d72@kernel.dk> <Zh3TjqD1763LzXUj@fedora>
 <CAGVVp+X81FhOHH0E3BwcsVBYsAAOoAPXpTX5D_BbRH4jqjeTJg@mail.gmail.com>
 <Zh5MSQVk54tN7Xx4@fedora> <28cc0bbb-fa85-48f1-9c8a-38d7ecf6c67e@kernel.dk>
 <d56d21d5-f8c2-435e-84ca-946927a32197@gmail.com>
 <34d7e331-e258-4dda-a21b-5327664d0d04@kernel.dk>
 <2836d7dc-4afd-49d8-8405-d888f2b3fc95@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2836d7dc-4afd-49d8-8405-d888f2b3fc95@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/16/24 6:40 AM, Pavel Begunkov wrote:
> On 4/16/24 13:24, Jens Axboe wrote:
>> On 4/16/24 6:14 AM, Pavel Begunkov wrote:
>>> On 4/16/24 12:38, Jens Axboe wrote:
>>>> On 4/16/24 4:00 AM, Ming Lei wrote:
>>>>> On Tue, Apr 16, 2024 at 10:26:16AM +0800, Changhui Zhong wrote:
>>>>>>>>
>>>>>>>> I can't reproduce this here, fwiw. Ming, something you've seen?
>>>>>>>
>>>>>>> I just test against the latest for-next/block(-rc4 based), and still can't
>>>>>>> reproduce it. There was such RH internal report before, and maybe not
>>>>>>> ublk related.
>>>>>>>
>>>>>>> Changhui, if the issue can be reproduced in your machine, care to share
>>>>>>> your machine for me to investigate a bit?
>>>>>>>
>>>>>>> Thanks,
>>>>>>> Ming
>>>>>>>
>>>>>>
>>>>>> I still can reproduce this issue on my machine?
>>>>>> and I shared machine to Ming?he can do more investigation for this issue?
>>>>>>
>>>>>> [ 1244.207092] running generic/006
>>>>>> [ 1246.456896] blk_print_req_error: 77 callbacks suppressed
>>>>>> [ 1246.456907] I/O error, dev ublkb1, sector 2395864 op 0x1:(WRITE)
>>>>>> flags 0x8800 phys_seg 1 prio class 0
>>>>>
>>>>> The failure is actually triggered in recovering qcow2 target in generic/005,
>>>>> since ublkb0 isn't removed successfully in generic/005.
>>>>>
>>>>> git-bisect shows that the 1st bad commit is cca6571381a0 ("io_uring/rw:
>>>>> cleanup retry path").
>>>>>
>>>>> And not see any issue in uring command side, so the trouble seems
>>>>> in normal io_uring rw side over XFS file, and not related with block
>>>>> device.
>>>>
>>>> Indeed, I can reproduce it on XFS as well. I'll take a look.
>>>
>>> Looking at this patch, that io_rw_should_reissue() path is for when
>>> we failed via the kiocb callback but came there off of the submission
>>> path, so when we unwind back it finds the flag, preps and resubmits
>>> the req. If it's not the case but we still return "true", it'd leaks
>>> the request, which would explains why exit_work gets stuck.
>>
>> Yep, this is what happens. I have a test patch that just punts any
>> reissue to task_work, it'll insert to iowq from there. Before we would
>> fail it, even though we didn't have to, but that check was killed and
>> then it just lingers for this case and it's lost.
> 
> Sounds good, but let me note that while unwinding, block/fs/etc
> could try to revert the iter, so it might not be safe to initiate
> async IO from the callback as is

Good point, we may just want to do the iov iter revert before sending it
to io-wq for retry. Seems prudent, and can't hurt.

-- 
Jens Axboe


