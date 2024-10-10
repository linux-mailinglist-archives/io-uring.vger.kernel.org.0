Return-Path: <io-uring+bounces-3560-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DE16499896B
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 16:26:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 835431F262F2
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 14:26:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E50C71CB322;
	Thu, 10 Oct 2024 14:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IoRnQMui"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BAF1CBE8E
	for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 14:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728570080; cv=none; b=kCN1xyesAhddMXxrdlgQE3wu+cDAsl5qaizsuilCam5OndQPsVEhdWDRm9zp32ryTd7ZBVHQD1jDu+eZh6Vw1h5+s+g9iOafd3qTq/8otVpmp4GJ5uyemrluX6e4uiJMuxBvubqR0PW/87YdtAiTsobrOK/yWj2IYJDQRsDarQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728570080; c=relaxed/simple;
	bh=n7HoGcX2L0YKI7cUXJJVfQvll6z9g8JXY/vqdTgflDk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=oCBJq9NU2pwQUIueLmcetDgCPwrlMQKNt1Xecn0QATYJEoUxRxSvg7MilwYoRiKmj2AOerSF5Y37xmprP6ot9Oo9tOpcwL4vgQmslbGz5pP1OM0kaXcSn7K7/TvvfphsnXMQiaPP/JvB38gSUraKggFh1cW0l5KrQ3ORVMO37c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IoRnQMui; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-82cd93a6617so30016039f.3
        for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 07:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728570077; x=1729174877; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5tvncHTC2aiQ4SkVBWT+IRmD6oV6FizLLxXnrLKWpLs=;
        b=IoRnQMuiWPDA2C+qY9uBGYO4Oa0dWMp1FwrA1WGOivoy4Zy2JUYnPGxvjK112N8L1W
         /UP5GBaTQpV8tWwFSTv6zqaPlANlzaZhkt6fmjyHj+rfXTSfRlrPFaJDGAZUZFpBqN99
         Y3kCkOjlQoalSgcd7QzSzqDJSmRzE4b/RAmCgbloufdCEj0Jgil4VkxBFY5OqZn5PqPc
         r5H7si2eoyX/59x949FcKySf9Nx3R/SNdA+XSW/mHNQ28JG8X8z0EMavtbuXHR4CDLl3
         mgTtT8zbPoEWXACA/Md99UpNOS9sPuzr5jUADyAmyFuUIO7v4UHR+3sGZWhJ4Wh8WnGp
         1ymw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728570077; x=1729174877;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5tvncHTC2aiQ4SkVBWT+IRmD6oV6FizLLxXnrLKWpLs=;
        b=eo6cCWrXdbXqGS1xjcO+aOtv6ThhskOthYm7V0PIPzR2rRluhcSyXV5V7nIhkE3699
         Lp6vk88aehEhebRy3MljjzzFYZv6wpvGIP/Kg0nJvNkLe1GqWvUTJYnYvnCzkg0MM7qK
         8MEA1zbIEZhh9j3SqAzVI7u0A6v6TZFK/D1NMoaS7STB+B0lVfk0nsKv7sCKWsbF9yDX
         ZnQJk3gmjPG2himSocfgrXL14phnUNJJkywK6Oqlymuo+NkiMK+yB3UUdYuUff5x7yUY
         DulKgNxN1a7ylS1dlmGRt7Hn0fOt4Te+5Gd6tzkId/00XPgxd/VuImmlxcLXk+c4o1mz
         upuw==
X-Forwarded-Encrypted: i=1; AJvYcCXdf1rH6B6fDKY1xVa5/LZFqNiZlhspxJ1Qfi1Cud48OfWz0PMJ0PoCPZ1JTrMsw9ms5BVwx1qxbg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxISwVLdQNU6Cm1x99geQrYaw7eyr7PfIh4CEBTyrPyAWxC+sUP
	UaP0SIPEvudUW5xXDI4XrzSUVmntL/ociSXAxB0fD2929TmLuWu58Yqy2FAVYPo=
X-Google-Smtp-Source: AGHT+IFnnWnYuwy7+xBj0/ioILZjAV/Z00xLWLKbmDtYiQXiQ8nSC7NQo9WKB8KvKrFR2xiM0PA8cw==
X-Received: by 2002:a05:6602:1555:b0:82d:129f:acb6 with SMTP id ca18e2360f4ac-8353d5125a7mr595608639f.14.1728570076721;
        Thu, 10 Oct 2024 07:21:16 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dbad9f1b61sm254375173.78.2024.10.10.07.21.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 07:21:16 -0700 (PDT)
Message-ID: <7f8c6192-3652-4761-b2e3-8a4bddb71e29@kernel.dk>
Date: Thu, 10 Oct 2024 08:21:15 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/15] io_uring zero copy rx
From: Jens Axboe <axboe@kernel.dk>
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
Content-Language: en-US
In-Reply-To: <b8fd4a5b-a7eb-45a7-a2f4-fce3b149bd5b@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/9/24 11:12 AM, Jens Axboe wrote:
> On 10/9/24 10:53 AM, Jens Axboe wrote:
>> On 10/9/24 10:50 AM, Jens Axboe wrote:
>>> On 10/9/24 10:35 AM, David Ahern wrote:
>>>> On 10/9/24 9:43 AM, Jens Axboe wrote:
>>>>> Yep basically line rate, I get 97-98Gbps. I originally used a slower box
>>>>> as the sender, but then you're capped on the non-zc sender being too
>>>>> slow. The intel box does better, but it's still basically maxing out the
>>>>> sender at this point. So yeah, with a faster (or more efficient sender),
>>>>
>>>> I am surprised by this comment. You should not see a Tx limited test
>>>> (including CPU bound sender). Tx with ZC has been the easy option for a
>>>> while now.
>>>
>>> I just set this up to test yesterday and just used default! I'm sure
>>> there is a zc option, just not the default and hence it wasn't used.
>>> I'll give it a spin, will be useful for 200G testing.
>>
>> I think we're talking past each other. Yes send with zerocopy is
>> available for a while now, both with io_uring and just sendmsg(), but
>> I'm using kperf for testing and it does not look like it supports it.
>> Might have to add it... We'll see how far I can get without it.
> 
> Stanislav pointed me at:
> 
> https://github.com/facebookexperimental/kperf/pull/2
> 
> which adds zc send. I ran a quick test, and it does reduce cpu
> utilization on the sender from 100% to 95%. I'll keep poking...

Update on this - did more testing and the 100 -> 95 was a bit of a
fluke, it's still maxed. So I added io_uring send and sendzc support to
kperf, and I still saw the sendzc being maxed out sending at 100G rates
with 100% cpu usage.

Poked a bit, and the reason is that it's all memcpy() off
skb_orphan_frags_rx() -> skb_copy_ubufs(). At this point I asked Pavel
as that made no sense to me, and turns out the kernel thinks there's a
tap on the device. Maybe there is, haven't looked at that yet, but I
just killed the orphaning and tested again.

This looks better, now I can get 100G line rate from a single thread
using io_uring sendzc using only 30% of the single cpu/thread (including
irq time). That is good news, as it unlocks being able to test > 100G as
the sender is no longer the bottleneck.

Tap side still a mystery, but it unblocked testing. I'll figure that
part out separately.

-- 
Jens Axboe

