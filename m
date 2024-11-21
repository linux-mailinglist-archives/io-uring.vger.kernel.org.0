Return-Path: <io-uring+bounces-4928-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 274109D4F72
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 16:10:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7E869B25E64
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 15:07:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 292EC1DAC8E;
	Thu, 21 Nov 2024 15:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JSF9QcAi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698DE1D0405
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 15:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732201619; cv=none; b=TsvMmhYMb66XKQeOwF96QcegmioeLmHEIK8OzwQMr2XVJuJ3NSslHV+Xla5wx/NlhYskqz3TDqmeWrXoDituvIlTx864p4Ras0dSXTbw7iur1bPlq1IHUWpM9imAJJ2CPkQcU8Y5GU3rSMLxAUlOl19Rud6TV4soIYEugy8X3P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732201619; c=relaxed/simple;
	bh=mMoEkxjcPhi9Oi8RuKTW19VHXR1FPYN/r3ixp/C/Qbs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pQiiKXDreEb+coebaIDv4Jo/tArHtZiYk2vYzgPmCiObkYlVfNI5R/eLJL3gFq+bqka14spBt2ddF5pJJtPpa+OMo5ojkrTpv/L1GWJvVVm2q8xzoXX8NrnckB83Bkmbhp68Ck9mnfPXp7gbjJ6PCVVqWZMO7s3SlvpUo++XXUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JSF9QcAi; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-aa1e6ecd353so69951966b.1
        for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 07:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732201616; x=1732806416; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t4WObQVST1uYw9gMSlxbzlwZp7k4+LEpGOdFyb1BPTs=;
        b=JSF9QcAiJGUzsVRVUnuD6pklQWEztQF4sgQuNeRctHuhqtkJZeINPvArw3GU3g2dxe
         WOBH3ScFr1KMM9BljZTGC/tDLXYlKJDdrHIy+uVqsS4AfktL9gXRw1G89hqURM86YFJ0
         gkFxighLQRkRjY50f6uQCtl4dZ1sQAzaj/TEeFkNZ5lWcSPPKUDiDPPWjM9ScXws/RIS
         c3rVD28RsQl3856Cw0L4UEm8gZ7zJPFGmsL+yXa3e0y2mrWQC6Jmn76FJNhnXNNOIZYC
         d4Xzqb/uGpryQrJdRFHY9TrZQ9zTZVdDbLin9SID2repIqxBL9hFFREn6TzMOU45yOtv
         D9Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732201616; x=1732806416;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t4WObQVST1uYw9gMSlxbzlwZp7k4+LEpGOdFyb1BPTs=;
        b=GeIg+nmOoeWdTMKyusPnINJy6q10d1OyLNiUvtuIPaqHXmg+RuxWLpFF3KxKdy6TtV
         6rVTNsjjkGTUIGWzfn2tyXYvuXvB1gru2sOYKGVAuXq7Ed30OR2ko1gMg2eZxXY3gVX+
         iK7SN4eZJYhjEFxgi8hR7zGknTeoQvWB+WOtaqr0NnapHtC5jAqhvUizghx2Y+bY25SW
         gxpRv4Y4REN1Wwbnm1i23MF+tlCfCRtfgQGZ+7za5P1Z+ei/qrAZoIWg81jsQEKsl3Ob
         5ynJHgz6WHijdJ6pNDpKWLqyIcCkcAC+yLxMZ2uzMp0eP3OdwIfB4C9MRg3z9N1R/tpF
         +xXQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgYSbhuDWWCEhnMbdM+gNO2XYJOlj/zfZyuwOIA90K0FTg4biEIpYhu3MAFSj/BA5z9XtlfenvpQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzAR4fIDWPe+5rFlF9MhNOF9I034j62ypn+/h+vsJF+YAaBg9Qn
	G95X46cx9iDMaD5cAP10I0139buaJRP3J50JsVHISdKWafu+/7xPiHqS7w==
X-Gm-Gg: ASbGncuGHn20qg6L09mfvQ06hcAfbfvHZtHalZchDDbbixbS/mLkss7m86Na/ZbqlUN
	aByO05iWjAJZAtxgUUwyJIaytD/Ic8L8q4HqWCn4V0IiL1NYw2vllLKFSp8px4rexduVECAq8kD
	HeU3Xoy+3Z6X0sgo4Y+DHS6q2pftjc1fb6xA8ndm9jhfBN0ZEsQxpYyy+LRJiHQ5rrg+s81mbFR
	PG+ls/OoxflxGIJ0+H9jLhYcHZ4dwiaGvMNE1hGLk9zM/jeutx5tNmCk8BAPQ==
X-Google-Smtp-Source: AGHT+IFFkklVt/n7vG3axrcAT+KdtJbLWjr6sm3UJfwmosc8gqCoadKGL6S4saGu7M6Ktv05oy/BvA==
X-Received: by 2002:a05:6402:13cd:b0:5cf:14fa:d24d with SMTP id 4fb4d7f45d1cf-5cff4ca4e23mr7963244a12.22.1732201615248;
        Thu, 21 Nov 2024 07:06:55 -0800 (PST)
Received: from [192.168.42.120] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cff44ef824sm2031679a12.32.2024.11.21.07.06.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 07:06:54 -0800 (PST)
Message-ID: <66fa0bfd-13aa-4608-a390-17ea5f333940@gmail.com>
Date: Thu, 21 Nov 2024 15:07:46 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next v1 2/2] io_uring: limit local tw done
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20241120221452.3762588-1-dw@davidwei.uk>
 <20241120221452.3762588-3-dw@davidwei.uk>
 <f32b768f-e4a4-4b8c-a4f8-0cdf0a506713@gmail.com>
 <95470d11-c791-4b00-be95-45c2573c6b86@kernel.dk>
 <614ce5a4-d289-4c3a-be5b-236769566557@gmail.com>
 <b7170b8e-9346-465b-be60-402c8f125e54@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b7170b8e-9346-465b-be60-402c8f125e54@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/24 14:31, Jens Axboe wrote:
> On 11/21/24 7:25 AM, Pavel Begunkov wrote:
>> On 11/21/24 01:12, Jens Axboe wrote:
>>> On 11/20/24 4:56 PM, Pavel Begunkov wrote:
>>>> On 11/20/24 22:14, David Wei wrote:
...
>>> I think that can only work if we change work_llist to be a regular list
>>> with regular locking. Otherwise it's a bit of a mess with the list being
>>
>> Dylan once measured the overhead of locks vs atomics in this
>> path for some artificial case, we can pull the numbers up.
> 
> I did it more recently if you'll remember, actually posted a patch I
> think a few months ago changing it to that. But even that approach adds

Right, and it's be a separate topic from this set.

> extra overhead, if you want to add it to the same list as now you need

Extra overhead to the retry path, which is not the hot path,
and coldness of it is uncertain.

> to re-grab (and re-disable interrupts) the lock to add it back. My gut
> says that would be _worse_ than the current approach. And if you keep a
> separate list instead, well then you're back to identical overhead in
> terms of now needing to check both when needing to know if anything is
> pending, and checking both when running it.
> 
>>> reordered, and then you're spending extra cycles on potentially
>>> reordering all the entries again.
>>
>> That sucks, I agree, but then it's same question of how often
>> it happens.
> 
> At least for now, there's a real issue reported and we should fix it. I
> think the current patches are fine in that regard. That doesn't mean we
> can't potentially make it better, we should certainly investigate that.
> But I don't see the current patches as being suboptimal really, they are
> definitely good enough as-is for solving the issue.

That's fair enough, but I still would love to know how frequent
it is. There is no purpose in optimising it as hot/slow path if
it triggers every fifth run or such. David, how easy it is to
get some stats? We can hack up some bpftrace script

-- 
Pavel Begunkov

