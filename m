Return-Path: <io-uring+bounces-3496-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 733369971D1
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 18:38:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 04E6EB26049
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 16:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D35419D098;
	Wed,  9 Oct 2024 16:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TIcvZ5r5"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C4D198A01;
	Wed,  9 Oct 2024 16:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728491744; cv=none; b=GOjcVz9M8pOa1xv8YLPzeRlhyvOjcSfgps4K0sGqysUI6GGL1+aE9qYqGwptFQGioG1Wr8Y8W9xflqlEcqxSkZlDY6BKTKqjIepRXBxjATNIEBMehbEBgY2mwC5ro/69g0HmOw4aLHDW23RUG683mRqE0uh1xpdxSXrao1ApI/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728491744; c=relaxed/simple;
	bh=Pj1JHpsjjEWao6KpxdYZtY6m5WhQQEKvk4q5IKNDY+Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OFqztttOS8qu56O7O69V7hUQ9AboVCtil38Cout2AUsYX4sV/hGYyvL7KOg1yxkUFGPXtq8YXcVXFxDHqsop6ma+CT2OKEv1p4U+BMSBGw34/0A1NSoYpb3Xxh4X9rOvZ3uFUxijbJqOlWestiLGul0yFVwiGtdMT0QwcTMeHt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TIcvZ5r5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4CCC4CEC3;
	Wed,  9 Oct 2024 16:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728491744;
	bh=Pj1JHpsjjEWao6KpxdYZtY6m5WhQQEKvk4q5IKNDY+Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TIcvZ5r5MwVKCocNByGXsAqxBhSs03gafdC3k3TjWDyaoxFooPDVFTdXpoKvaJSvd
	 CzqRXGfkbE4s8tjwL8S/yOoMSb3/HHdjYL3iwjn2wxEDb+DKFA4T7eGrE+LpdSS4Xu
	 i6PiWXt4LJ8D4x2KQ7/dkvHjCcWgE+Oqv8pPd2Cng4uRfL9L6VGNVyRu2icf91LpdF
	 fSWXLDrBHtHsH6NeVomvn6wxVG38OpBW/hXy/hvF5uM7pkjSb3rmdSZ1AdnhwUQhDI
	 DOqOk+PuKVyEgZ265DbCitmqKrbyfK/y2PdRTxtDJVmBPBWtC/hJi0c9dv2e8AvPe9
	 a2Zstg/krgUbg==
Message-ID: <3b2646d6-6d52-4479-b082-eb6264e8d6f7@kernel.org>
Date: Wed, 9 Oct 2024 10:35:43 -0600
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
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <2144827e-ad7e-4cea-8e38-05fb310a85f5@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/9/24 9:43 AM, Jens Axboe wrote:
> Yep basically line rate, I get 97-98Gbps. I originally used a slower box
> as the sender, but then you're capped on the non-zc sender being too
> slow. The intel box does better, but it's still basically maxing out the
> sender at this point. So yeah, with a faster (or more efficient sender),

I am surprised by this comment. You should not see a Tx limited test
(including CPU bound sender). Tx with ZC has been the easy option for a
while now.

> I have no doubts this will go much higher per thread, if the link bw was
> there. When I looked at CPU usage for the receiver, the thread itself is
> using ~30% CPU. And then there's some softirq/irq time outside of that,
> but that should ammortize with higher bps rates too I'd expect.
> 
> My nic does have 2 100G ports, so might warrant a bit more testing...
> 

It would be good to see what the next bottleneck is for io_uring with ZC
Rx path. My expectation is that a 200G link is a means to show you (ie.,
you will not hit 200G so cpu monitoring, perf-top, etc will show the
limiter).

