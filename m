Return-Path: <io-uring+bounces-11033-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 25A83CBA160
	for <lists+io-uring@lfdr.de>; Sat, 13 Dec 2025 01:04:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AC69E30A6601
	for <lists+io-uring@lfdr.de>; Sat, 13 Dec 2025 00:04:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BF10156CA;
	Sat, 13 Dec 2025 00:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bOBfyOCi"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1745FDF6C;
	Sat, 13 Dec 2025 00:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765584255; cv=none; b=I9jKBrdUSKMWA/xDpsk7NuB+VAr1Dauevq8U70L3NIzAbI01GbgI7xS48KOoC40mWlgRyM7scTUFAT6wmtcC2pGZz5MtHUfBPmuyBbg4lSCBEfxLRbijm6mN0O1r0HZiR6vzed10L3lLlPpMXKNBt7Qi1sPZZvTCCxidrxMqrk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765584255; c=relaxed/simple;
	bh=9ON0BsqUdHPuKooEwOAYhec1H4nQqHimI1tGEkaJO24=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fT0Fn6ZBjhIX7ZwVXSF5TYQCdScGr2aO1wmr0J2AdQyaoYRoGxgKIhcSf7pp7Y202CdAc/JiMxEvHuvrvVwbU0ZMu33QDImwUs5cQMoTUWrKnEecXHjPx3rzYZCTdGglrb/qPvhKLAIZdRwjqOEVk3EYW6HAqdBZtg5jlLiy/lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bOBfyOCi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E33BC4CEF1;
	Sat, 13 Dec 2025 00:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765584254;
	bh=9ON0BsqUdHPuKooEwOAYhec1H4nQqHimI1tGEkaJO24=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bOBfyOCiVijuc8pYCEFzqgUszZYPT+BswDG6MX3gqzGPo2n1Lt28KE6rf4X7ORfZt
	 6s9Kr8lsTdBadLvGSFAGPRGWUJGOZqnVrENL81iURcZvwucaE8C5w34HHZe6IAbLD+
	 M7RNKJ9AL0E1v15XxZrKaQehEtHvbRDdkOEBUXr8qbntz/pu5mAo4AuId2LocjKBYT
	 2+NTFSrdb0hSOexDJM08KB1GySrqXNOHdf+F1H8DpHzempFBSekxVn7LZoKZ12JbAn
	 KqADfNiu5RqdcLkqAyR9DZ/OwyIPpjzb/+PG90FfbMrxxdnu+MTKD17DC/7ZED9X2u
	 gaODwKaWfXPAg==
Date: Sat, 13 Dec 2025 09:04:07 +0900
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Jonathan
 Corbet <corbet@lwn.net>, Michael Chan <michael.chan@broadcom.com>, Pavan
 Chebbi <pavan.chebbi@broadcom.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
 <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>, Ilias Apalodimas
 <ilias.apalodimas@linaro.org>, Shuah Khan <shuah@kernel.org>, Mina Almasry
 <almasrymina@google.com>, Stanislav Fomichev <sdf@fomichev.me>, Yue Haibing
 <yuehaibing@huawei.com>, David Wei <dw@davidwei.uk>, Haiyue Wang
 <haiyuewa@163.com>, Jens Axboe <axboe@kernel.dk>, Joe Damato
 <jdamato@fastly.com>, Simon Horman <horms@kernel.org>, Vishwanath Seshagiri
 <vishs@fb.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
 io-uring@vger.kernel.org, dtatulea@nvidia.com
Subject: Re: [PATCH net-next v7 7/9] eth: bnxt: allow providers to set rx
 buf size
Message-ID: <20251213090407.3de8dd86@kernel.org>
In-Reply-To: <c97d2c95-31c5-4bf6-b58f-552e85314056@gmail.com>
References: <cover.1764542851.git.asml.silence@gmail.com>
	<95566e5d1b75abcaefe3dca9a52015c2b5f04933.1764542851.git.asml.silence@gmail.com>
	<20251202105820.14d6de99@kernel.org>
	<c97d2c95-31c5-4bf6-b58f-552e85314056@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 11 Dec 2025 01:39:25 +0000 Pavel Begunkov wrote:
> On 12/2/25 18:58, Jakub Kicinski wrote:
> > On Sun, 30 Nov 2025 23:35:22 +0000 Pavel Begunkov wrote:  
> >> +static ssize_t bnxt_get_rx_buf_size(struct bnxt *bp, int rxq_idx)
> >> +{
> >> +	struct netdev_rx_queue *rxq = __netif_get_rx_queue(bp->dev, rxq_idx);
> >> +	size_t rx_buf_size;
> >> +
> >> +	rx_buf_size = rxq->mp_params.rx_buf_len;
> >> +	if (!rx_buf_size)
> >> +		return BNXT_RX_PAGE_SIZE;  
> > 
> > I'd like to retain my cfg objects in the queue API, if you don't mind.
> > I guess we just need the way for drivers to fill in the defaults and
> > then plumb them into the ops.  
> 
> It was problematic, I wanted to split it into more digestible chunks.
> My main problem is that it was not really optional and could break
> drivers that don't even care about this qcfg len option but allow
> setting it device-wise via ethtool, and I won't even have a way to
> test them.
> 
> Maybe there is a way to strip down qcfg and only apply it to marked
> queue api enabled drivers for now, and then extend the idea it in
> the future. E.g.

Yes, I mean a stripped down version, since we're not shadowing the
ethtool knob any more the full set of changes I had will be too much.
Off the top of my head I think we'd need to retain:
 - the qcfg struct passed as an argument to the queue callbacks
   (drivers other than bnxt won't use it which is okay since they don't
   set .supported_params)
 - the ability to conjure the qcfg struct for any given queue by the
   driver at any time (netdev_queue_config())
 - probably the callback to fill in the defaults so that the driver
   doesn't have to check "is the value set by the user" explicitly

