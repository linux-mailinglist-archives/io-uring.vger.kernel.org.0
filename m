Return-Path: <io-uring+bounces-3562-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BDC6F998B27
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 17:15:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 488681F22003
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 15:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 396321CB307;
	Thu, 10 Oct 2024 15:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="T3Eofcci"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E6A1BD018
	for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 15:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728573336; cv=none; b=Jy/wEs/l+VhS97JiKKzoJ0XvW9340fXD3ZQgHbBgAnjQEgnGTI8ML1355IF+hZE/XnsPix9MzTAJ9kuq57745gCLnoHuecn6HxbeRLT4qXlNvCAQAzjXuM2bMJIdW58BfM0IeQl7cQQ8G+T042fzw24DbiOswF/wjO2jhyvnLhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728573336; c=relaxed/simple;
	bh=dqv56F5p2mdifL8zO+qci9lkhNNOL4e99MU0MjciAkI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Mm+YLN1Zfw/a7X3zCPToqyrmXy8Vxlvqe+iiRTJ+O7vp2yZOPDwf2XYd8UJ66GCnyajowAo+roShHirYYHdVcNupASIjhaqPimA6jd19z8OTOWtrL2UxVmqEehZnt3dyN1sm7j+uo8kty/AZqmo/KIyKnG3Skeeys7DK2JY6lO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=T3Eofcci; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3a3a03399fbso5928855ab.0
        for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 08:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728573333; x=1729178133; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VurnIyQe6BUgz/A+1slxdmxDT8lrNtE5+PtU4B5g+ZQ=;
        b=T3Eofcci82iRPGCp+cpMwEfTK2wNJXTdwDJITRotwMCdhEz/HbYb79caMVZQctMmOa
         SO4KW1+Iel5kuMMmNE0BXuapJKOg7e1dWgBr2AxbDWd3Vq+8U0lhgzY42o9hz0H3yAua
         swv/cgqv6D7HQ4y6UOyWVlVlAYPboNUCeU9baT1dcC50LSFYLeW+JA9GSo4Yq8Kz1XEq
         VFN2JTbDcnPXsPwvDrqs/mb9AJ9B0DV8xgJ29VeW+MSCe/zndP/eHjZJIthLt6puqTZL
         wF6GVKiKLW4t6CXAZYjWp1ewbvkmDN9ub19sI33DEEL9DSkewNw095iEGRa6/LmKISR4
         sRTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728573333; x=1729178133;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VurnIyQe6BUgz/A+1slxdmxDT8lrNtE5+PtU4B5g+ZQ=;
        b=bAx7KAaAVfEHmaD4NYVvrH91qBameTTd7tVrJvbTIKGR+DB9Oo+gadDvHglmRK+uag
         tu6zZb0kfcf2LHPCgTY4H6PzZ+cxAe5bGfWfIaFsvz8zQn+1khTcJJC5gXJZ3pm0C5IN
         TMqD8TI95Clcyz+j7BvbL37RQNImBD3dtNhDLTO4yvvuDS3cyoaRT6tDmE0NJ5EwsCAN
         90SiZZ8PCVoSFyfiOtpwpa+uBv2LyHD8NLVMyeCYeuvM7fSsCq9ckcuxO/6aVknglXVk
         6LxAh8nbhA+Jle/Ax9hLwGB4MF97ePReSjVQPsovhhPtgzMn53GiX0ALOCx6EbgKba99
         jGXg==
X-Forwarded-Encrypted: i=1; AJvYcCXtvtANX92/j2mdEp2AjpI+TCp5R8zj3ZmWRaVeZAn3m7GWKHYYK80ZBOEWjCsQMW4Lwn05QCZ/cA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyH2qn1gcCSx/BbFsB6ajpZThvmPwd2UFLH1F7Icwi8lR8pUJEA
	GM/eNuplrCnls3b7MQnEh742V1WfZaf7Wip9/uiZH1MFXE+XoOwZGqrx2h4j04A=
X-Google-Smtp-Source: AGHT+IG4IRz9l2JEioTTHbM8YIFvgA0hLl48difILQmjUmIugOIvdPAFjxjO4kf/1OS5dYC9/nT4FQ==
X-Received: by 2002:a05:6e02:58a:b0:3a3:a5c5:3915 with SMTP id e9e14a558f8ab-3a3a5c53af9mr33703855ab.16.1728573333169;
        Thu, 10 Oct 2024 08:15:33 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dbada84a35sm279876173.117.2024.10.10.08.15.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 08:15:32 -0700 (PDT)
Message-ID: <eac28bf4-edf6-4df7-8b74-f9eb9811f141@kernel.dk>
Date: Thu, 10 Oct 2024 09:15:31 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/15] io_uring zero copy rx
To: David Ahern <dsahern@kernel.org>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <2e475d9f-8d39-43f4-adc5-501897c951a8@kernel.dk>
 <93036b67-018a-44fb-8d12-7328c58be3c4@kernel.org>
 <2144827e-ad7e-4cea-8e38-05fb310a85f5@kernel.dk>
 <3b2646d6-6d52-4479-b082-eb6264e8d6f7@kernel.org>
 <57391bd9-e56e-427c-9ff0-04cb49d2c6d8@kernel.dk>
 <d0ba9ba9-8969-4bf6-a8c7-55628771c406@kernel.dk>
 <b8fd4a5b-a7eb-45a7-a2f4-fce3b149bd5b@kernel.dk>
 <7f8c6192-3652-4761-b2e3-8a4bddb71e29@kernel.dk>
 <8ec09781-5d6b-4d9b-b29d-a0698bcff5fe@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8ec09781-5d6b-4d9b-b29d-a0698bcff5fe@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/10/24 9:03 AM, David Ahern wrote:
> On 10/10/24 8:21 AM, Jens Axboe wrote:
>>> which adds zc send. I ran a quick test, and it does reduce cpu
>>> utilization on the sender from 100% to 95%. I'll keep poking...
>>
>> Update on this - did more testing and the 100 -> 95 was a bit of a
>> fluke, it's still maxed. So I added io_uring send and sendzc support to
>> kperf, and I still saw the sendzc being maxed out sending at 100G rates
>> with 100% cpu usage.
>>
>> Poked a bit, and the reason is that it's all memcpy() off
>> skb_orphan_frags_rx() -> skb_copy_ubufs(). At this point I asked Pavel
>> as that made no sense to me, and turns out the kernel thinks there's a
>> tap on the device. Maybe there is, haven't looked at that yet, but I
>> just killed the orphaning and tested again.
>>
>> This looks better, now I can get 100G line rate from a single thread
>> using io_uring sendzc using only 30% of the single cpu/thread (including
>> irq time). That is good news, as it unlocks being able to test > 100G as
>> the sender is no longer the bottleneck.
>>
>> Tap side still a mystery, but it unblocked testing. I'll figure that
>> part out separately.
>>
> 
> Thanks for the update. 30% cpu is more inline with my testing.
> 
> For the "tap" you need to make sure no packet socket applications are
> running -- e.g., lldpd is a typical open I have a seen in tests. Check
> /proc/net/packet

Here's what I see:

sk               RefCnt Type Proto  Iface R Rmem   User   Inode
0000000078c66cbc 3      3    0003   2     1 0      0      112645
00000000558db352 3      3    0003   2     1 0      0      109578
00000000486837f4 3      3    0003   4     1 0      0      109580
00000000f7c6edd6 3      3    0003   4     1 0      0      22563 
000000006ec0363c 3      3    0003   2     1 0      0      22565 
0000000095e63bff 3      3    0003   5     1 0      0      22567 

was just now poking at what could be causing this. This is a server box,
nothing really is running on it... The nic in question is ifindex 2.

-- 
Jens Axboe

