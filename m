Return-Path: <io-uring+bounces-3561-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 82438998AF9
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 17:08:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2D0A51F261D9
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 15:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12A131CB316;
	Thu, 10 Oct 2024 15:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WKw/g2LO"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD00838DE1;
	Thu, 10 Oct 2024 15:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728572583; cv=none; b=HHyi8bymNmVw3EqNQtJQ4eo5gFPwo+lAgF6DiaceH6NmOzrZwXetQe9EE1fjhuV0PklI+p1SRku6nkVg+ET5wmUbmSOivIMoXdPwSJwdPqgSOhJICzSOGf8IDac0yq6Bk/WZkAXjKQsAzdH0sdJ7QR7878gNx/k9UkLU6XpLDbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728572583; c=relaxed/simple;
	bh=Q+9jZOfEu+P6GJzAuvEVSPEa5zIZ8zMH0BMvCaLDHwA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RhWTMJWBLjsR5c37hdh4ccwcENnfdCNNKRlcoBCG4050ujlSYxkzT99bR1PWQPmp4XBIgLx7Bep9Bla/pbDiM1BQMLv/G9AR3rry18Pjn8hWQUxbqyEO2YBUb3EKrG1ZsEsSVPBnXIbQvUYZVQG0s2PE2Z8T+T4Bfr4Da5YIHGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WKw/g2LO; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09454C4CEC5;
	Thu, 10 Oct 2024 15:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728572582;
	bh=Q+9jZOfEu+P6GJzAuvEVSPEa5zIZ8zMH0BMvCaLDHwA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WKw/g2LOKBdWzy2XTY/Txpba1Pbk6DcO5YUN/KPBSm+pWIzeNFRWnxmzzMVOKT0n1
	 Gw3qqPXU5CztciRelTGBLD2xA1JPjiUhkcomBCeRQ/ygMGbpYUQcxWesUJ4XUI399Q
	 VO2ib0vfU8L6SwViI7uYS2DfyOyinx+1qiv6aGDNTqBPafOx2w+J8FgBKnbFcTLBzI
	 PHJjDYxjEqAyH0WZ3+UIMPKBCFzSXH6WwidJczV+N3I48sjVF9k+0iHoAwhwB1Ahwb
	 N0z07YI3piSe0HAmUBsNlZt8clQBzIAYUB/6W3NXMyoW6swQUc+Dq4hF78Sy11igGI
	 9ZWOSTt4/mPmQ==
Message-ID: <8ec09781-5d6b-4d9b-b29d-a0698bcff5fe@kernel.org>
Date: Thu, 10 Oct 2024 09:03:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/15] io_uring zero copy rx
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
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
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <7f8c6192-3652-4761-b2e3-8a4bddb71e29@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/10/24 8:21 AM, Jens Axboe wrote:
>> which adds zc send. I ran a quick test, and it does reduce cpu
>> utilization on the sender from 100% to 95%. I'll keep poking...
> 
> Update on this - did more testing and the 100 -> 95 was a bit of a
> fluke, it's still maxed. So I added io_uring send and sendzc support to
> kperf, and I still saw the sendzc being maxed out sending at 100G rates
> with 100% cpu usage.
> 
> Poked a bit, and the reason is that it's all memcpy() off
> skb_orphan_frags_rx() -> skb_copy_ubufs(). At this point I asked Pavel
> as that made no sense to me, and turns out the kernel thinks there's a
> tap on the device. Maybe there is, haven't looked at that yet, but I
> just killed the orphaning and tested again.
> 
> This looks better, now I can get 100G line rate from a single thread
> using io_uring sendzc using only 30% of the single cpu/thread (including
> irq time). That is good news, as it unlocks being able to test > 100G as
> the sender is no longer the bottleneck.
> 
> Tap side still a mystery, but it unblocked testing. I'll figure that
> part out separately.
> 

Thanks for the update. 30% cpu is more inline with my testing.

For the "tap" you need to make sure no packet socket applications are
running -- e.g., lldpd is a typical open I have a seen in tests. Check
/proc/net/packet

