Return-Path: <io-uring+bounces-50-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F5FD7E497B
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 20:57:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F3844B20EFD
	for <lists+io-uring@lfdr.de>; Tue,  7 Nov 2023 19:57:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70D7E36AEF;
	Tue,  7 Nov 2023 19:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="C/cxheYa"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BA536AED
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 19:57:03 +0000 (UTC)
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3426AD7A
	for <io-uring@vger.kernel.org>; Tue,  7 Nov 2023 11:57:03 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1cc13149621so13001035ad.1
        for <io-uring@vger.kernel.org>; Tue, 07 Nov 2023 11:57:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1699387022; x=1699991822; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iiqZoe3cG5zJQ5OOe2jEoEouiFdtnH+oQy33hyDN06M=;
        b=C/cxheYa383fqW82p2onHQ3kFplis0NJbJYPQpLB7j5PuMckITMTQUcfDOQCHgU6vT
         M9ZW6pLn94zgwsVp2Q3RRFvCkeJeiNAW+mdnZVTKrsIcjUxc1VlbIyCPEkGQYhh+EBVb
         a3w5Cd9iGyoccJ1LZAeoNwCHyLwNbrsqD7pSfr47XjI+ViRlfw3n13aGdVeVC+60yJE2
         qH+HziNrOHRxEX6gYaT0zkxvEuBAOu73Jhd9qTl7cVDTGBDnfazIblOdRWiThL7kQyfh
         RSnJHXvj/Qy5V94DRGaz8bL5Bd4Mv57pTzm6T6AIxrbjpfNp5WvVJ2bv6psPwcWM9p6S
         JnQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699387022; x=1699991822;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iiqZoe3cG5zJQ5OOe2jEoEouiFdtnH+oQy33hyDN06M=;
        b=YUXA6hSchMkIBJ0pX++CuBPga0sJGOtJg2K4CesySHPwlyT15BEKUk24Cz+KBu6u77
         f06Nd+/qXhw+axEkK9AF1N3ku/jbdisC9dbrUcnvyPxVapvEdzuCB0cjZrq9J2mJnPca
         nUzUV7YNs29kPlvMDhXXyNN9jkaflau/AhikFKEQBZNC18DQYyDNo9oGhEqiLwhqLPL/
         HGsmn6tAYcEglkc8gvuIxhtVyn832+y9KI1Zklf2JS2wo9cuFALbpVmP2uFBSePFCKiw
         420ncwkrmSQsAXvD8GiKwBGW+Vk1eioQs7i+YpSICpepINR+TV4hwrilnBi0E+4sEI/2
         jhyA==
X-Gm-Message-State: AOJu0Yz6bw2Gzht6j+NM4TbLOOghVjxO6egdsjIAAJHFncnnBY4uzqed
	59IWo/odj+WqjvkNzR+aBhfMUr8W5ezAbzJCazX6eQ==
X-Google-Smtp-Source: AGHT+IEmMHzu7vPHrCR/85N4xxetTGp0wpvOKi3yOBlpZTg9WRkU6UkuwS9bpTddnh5ytzD4nkfGTA==
X-Received: by 2002:a17:902:db08:b0:1b8:9fc4:2733 with SMTP id m8-20020a170902db0800b001b89fc42733mr82234plx.3.1699387022555;
        Tue, 07 Nov 2023 11:57:02 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id q12-20020a170902a3cc00b001b8943b37a5sm217447plb.24.2023.11.07.11.57.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Nov 2023 11:57:02 -0800 (PST)
Message-ID: <faa79714-a894-4f19-b798-176e12fbf96f@kernel.dk>
Date: Tue, 7 Nov 2023 12:57:01 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/poll: use IOU_F_TWQ_LAZY_WAKE for wakeups
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <e6bcdcb4-8a3d-48a1-8301-623cd30430e6@kernel.dk>
 <55fe5c04-f3c2-5d39-0ff3-e086bf4a13cc@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <55fe5c04-f3c2-5d39-0ff3-e086bf4a13cc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/7/23 10:47 AM, Pavel Begunkov wrote:
> On 10/19/23 14:01, Jens Axboe wrote:
>> With poll triggered retries, each event trigger will cause a task_work
>> item to be added for processing. If the ring is setup with
>> IORING_SETUP_DEFER_TASKRUN and a task is waiting on multiple events to
>> complete, any task_work addition will wake the task for processing these
>> items. This can cause more context switches than we would like, if the
>> application is deliberately waiting on multiple items to increase
>> efficiency.
> 
> I'm a bit late here. The reason why I didn't enable it for polling is
> because it changes the behaviour. Let's think of a situation where we
> want to accept 2 sockets, so we send a multishot accept and do
> cq_wait(nr=2). It was perfectly fine before, but now it'll hung as
> there's only 1 request and so 1 tw queued. And same would happen with
> multishot recv even though it's more relevant to packet based protocols
> like UDP.
> 
> It might be not specific to multishots:
> listen(backlog=1), queue N oneshot accepts and cq_wait(N).

I don't think it's unreasonable to assume that you need a backlog of N
if you batch wait for N to come in, with defer taskrun. I'm more curious
about non-accept cases that would potentially break.

> Now we get the first connection in the queue to accept.
> 
>     [IORING_OP_ACCEPT] = {
>         .poll_exclusive        = 1,
>     }
> 
> Due to poll_exclusive (I assume) it wakes only one accept. That

Right, if poll_exclusive is set, then we use exclusive waits. IFF the
caller also groks that and asks to wake just 1, then we will indeed just
wake one. I can certainly see this one being a problem, but at least
that could be handled by not doing this for exclusive poll waits.

> will try to queue up a tw for it, but it'll not be executed
> because it's just one item. No other connection can be queued
> up because of the backlog limit => presumably no other request
> will be woken up => that first tw never runs. It's more subtle
> and timing specific than the previous example, but nevertheless
> it's concerning we might step on sth like that.

Backlog aside, as per above, what other cases would we need to worry
about here? It's really anything where something in poll would need
processing to trigger more events.
 
IOW, if we can allow some known cases at least that'd certainly
help, or conversely exclude ones (like poll_exclusive).

-- 
Jens Axboe


