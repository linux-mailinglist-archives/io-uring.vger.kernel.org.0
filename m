Return-Path: <io-uring+bounces-2649-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96E35946A20
	for <lists+io-uring@lfdr.de>; Sat,  3 Aug 2024 16:36:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DC3CCB2107B
	for <lists+io-uring@lfdr.de>; Sat,  3 Aug 2024 14:36:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F9BC14E2FC;
	Sat,  3 Aug 2024 14:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KV398DC2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2F314EC48
	for <io-uring@vger.kernel.org>; Sat,  3 Aug 2024 14:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722695779; cv=none; b=Iq6cBOfwJ/N/swpTZoBrc40wCjkvl1R3fTLz3TZ45n/LyH1BTczKkhV1v+Zb8czfg3uWPSxSwX/A9IdpEI/a88Ofn9ocDAIKUCv95Zvx1VpIG8JCrzZYlruNtmPM2e8QpXQQ6EQb901CqR8jiaJ5COSAURY9g/EXNIv4jSAoSwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722695779; c=relaxed/simple;
	bh=yftr8daBEqTwAQqGhxql0VwP2UBCSQDD5dbRkuiWPkk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=iJMpGHl8rQzJPnx8coJGuI/AmLv3Aia6S0L2L9nM1vPF6CfHQMGcDhbPnuQGB3KzkOT/p/P1kDOvV8jdoF55eWfYRIb49aeeWFoaLqz9mYCxALgtZvyaVvtwz7akjbzRC/x9cs4aKQvVfcgHQpYDvKEQnq4F5sLfIYVTFAsdGAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KV398DC2; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-70d2879bfb0so925107b3a.0
        for <io-uring@vger.kernel.org>; Sat, 03 Aug 2024 07:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1722695774; x=1723300574; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xHGICDoTrkz09FMxHlMY4eLRRcpJcG4L4mJZZgN6BZk=;
        b=KV398DC2GOJL6NMU2ARP4Ll3FPJ9yok84KX+qid1tmSQ55DS+3CD8Jdrby9w8QJxKB
         iL2MmctDd5THBPwYXMkOQyi8U2FgQqALDcL4ZBtcNuyvRJXosA9kDxmX9RRwYyHYd8EP
         by0zCM9calVp91ZTnPzRXtvlL6qB6+RHx814lpSb9+ooKPna1MuwakJCD3c0Ajc9Hdq5
         XEG4t7YY7cOlyatz/SsoTBJWNSxoiYcCTZhYtFrh98UwWybBsB1ti6DzGFBPhK+Ly26+
         StGKOsE6mdGtt9S1lKgUsoTKDnKJcziMPhtPuoV7+w+PsH2a8gMKnQVzXKQggl3iOCsF
         XWuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722695774; x=1723300574;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xHGICDoTrkz09FMxHlMY4eLRRcpJcG4L4mJZZgN6BZk=;
        b=i6FU7QgentSa7VzkdtydCmPb3WNxq3qX4PmuKPOa6gU8faSZeIueIvCjFGdB4TD4m9
         EF3KqlIM/9rb9t3KDoolTs0oxVb6QPOC9owtxududIxGB0gEnmatp7NW/5JXFYvCuxwa
         KMkGSXdquwUPxUpJGA6nWCFQ3N8iylqThiyPmTaqGEjacPv3fayUCMUZ5rUctg4NAYpw
         6ZHL/sLvhCQz2SLei9ZcrjvauGSjQ46JezcWjy11YSJq9I6IFttaE7rYKR+bkq8YyEKG
         ddzCej2gQptBaFRLoncaIxwfDmcBdbH9aS/fJ4g5mox7Eo/O3jq4zsnmcQMol9yfFEdy
         UPqw==
X-Forwarded-Encrypted: i=1; AJvYcCWw7rLauqUGkW2IF1lQ6H1fpv9QwBwBNX5Xn+Pwr1+Pk8C74WtRte6OLZTmKtEh7kgLxr+1Shy1mY5YVV7B8hoRA0bNQAp+OYE=
X-Gm-Message-State: AOJu0YzKGnJI1HScD7CzEeo06ZRV90ZVBwCGLgYyKin7XBPH+ms6hFFM
	sFEHsYbZu7LWOYcYzwPgITyQCiftwZ4Ed0cDN9U0q4yMQPov16fCLeJC6rZ8Jqo=
X-Google-Smtp-Source: AGHT+IF9P2wt+ygc/ynh4YBA81/9fudqClnPxDeRWKExkZcHITHbmV9wd5pdPvIy8DmMiI6VZKCHhA==
X-Received: by 2002:a17:903:2312:b0:1fc:4377:afa4 with SMTP id d9443c01a7336-1ff5755a488mr53982255ad.8.1722695774140;
        Sat, 03 Aug 2024 07:36:14 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ff59054759sm35480225ad.150.2024.08.03.07.36.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Aug 2024 07:36:13 -0700 (PDT)
Message-ID: <a428d20d-8c14-465c-89ef-52aa8fc67970@kernel.dk>
Date: Sat, 3 Aug 2024 08:36:12 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring NAPI busy poll RCU is causing 50 context switches/second
 to my sqpoll thread
To: Olivier Langlois <olivier@trillion01.com>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <b1ad0ab3a7e70b72aa73b0b7cab83273358b2e1d.camel@trillion01.com>
 <00918946-253e-43c9-a635-c91d870407b7@gmail.com>
 <bcd3b198697e16059ec69566251ad23c4c78e7a7.camel@trillion01.com>
 <43c27aa1-d955-4375-8d96-cd4201aecf50@gmail.com>
 <4dbbd36aa7ecd1ce7a6289600b5655563e4a5a74.camel@trillion01.com>
 <93b294fc-c4e8-4f1f-8abb-ebcea5b8c3a1@gmail.com>
 <7edc139bd159764075923e75ffb646e7313c7864.camel@trillion01.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <7edc139bd159764075923e75ffb646e7313c7864.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/3/24 8:15 AM, Olivier Langlois wrote:
> On Fri, 2024-08-02 at 16:22 +0100, Pavel Begunkov wrote:
>>>
>>> I am definitely interested in running the profiler tools that you
>>> are
>>> proposing... Most of my problems are resolved...
>>>
>>> - I got rid of 99.9% if the NET_RX_SOFTIRQ
>>> - I have reduced significantly the number of NET_TX_SOFTIRQ
>>>    https://github.com/amzn/amzn-drivers/issues/316
>>> - No more rcu context switches
>>> - CPU2 is now nohz_full all the time
>>> - CPU1 local timer interrupt is raised once every 2-3 seconds for
>>> an
>>> unknown origin. Paul E. McKenney did offer me his assistance on
>>> this
>>> issue
>>> https://lore.kernel.org/rcu/367dc07b740637f2ce0298c8f19f8aec0bdec123.camel@trillion01.com/t/#u
>>
>> And I was just going to propose to ask Paul, but great to
>> see you beat me on that
>>
> My investigation has progressed... my cpu1 interrupts are nvme block
> device interrupts.
> 
> I feel that for questions about block device drivers, this time, I am
> ringing at the experts door!
> 
> What is the meaning of a nvme interrupt?
> 
> I am assuming that this is to signal the completing of writing blocks
> in the device...
> I am currently looking in the code to find the answer for this.
> 
> Next, it seems to me that there is an odd number of interrupts for the
> device:
>  63:         12          0          0          0  PCI-MSIX-0000:00:04.0
> 0-edge      nvme0q0
>  64:          0      23336          0          0  PCI-MSIX-0000:00:04.0
> 1-edge      nvme0q1
>  65:          0          0          0      33878  PCI-MSIX-0000:00:04.0
> 2-edge      nvme0q2
> 
> why 3? Why not 4? one for each CPU...
> 
> If there was 4, I would have concluded that the driver has created a
> queue for each CPU...
> 
> How are the queues associated to certain request/task?
> 
> The file I/O is made by threads running on CPU3, so I find it
> surprising that nvmeq1 is choosen...
> 
> One noteworthy detail is that the process main thread is on CPU1. In my
> flawed mental model of 1 queue per CPU, there could be some sort of
> magical association with a process file descriptors table and the
> choosen block device queue but this idea does not hold... What would
> happen to processes running on CPU2...

The cpu <-> hw queue mappings for nvme devices depend on the topology of
the machine (number of CPUs, relation between thread siblings, number of
nodes, etc) and the number of queue available on the device in question.
If you have as many (or more) device side queues available as number of
CPUs, then you'll have a queue per CPU. If you have less, then multiple
CPUs will share a queue.

You can check the mappings in /sys/kernel/debug/block/<device>/

in there you'll find a number of hctxN folders, each of these is a
hardware queue. hcxt0/type tells you what kind of queue it is, and
inside the directory, you'll find which CPUs this queue is mapped to.
Example:

root@r7625 /s/k/d/b/nvme0n1# cat hctx1/type 
default

"default" means it's a read/write queue, so it'll handle both reads and
writes.

root@r7625 /s/k/d/b/nvme0n1# ls hctx1/
active  cpu11/   dispatch       sched_tags         tags
busy    cpu266/  dispatch_busy  sched_tags_bitmap  tags_bitmap
cpu10/  ctx_map  flags          state              type

and we can see this hardware queue is mapped to cpu 10/11/266.

That ties into how these are mapped. It's pretty simple - if a task is
running on cpu 10/11/266 when it's queueing IO, then it'll use hw queue
1. This maps to the interrupts you found, but note that the admin queue
(which is not listed these directories, as it's not an IO queue) is the
first one there. hctx0 is nvme0q1 in your /proc/interrupts list.

If IO is queued on hctx1, then it should complete on the interrupt
vector associated with nvme0q2.

-- 
Jens Axboe


