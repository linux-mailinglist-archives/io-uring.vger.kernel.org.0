Return-Path: <io-uring+bounces-1537-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA3108A3DF2
	for <lists+io-uring@lfdr.de>; Sat, 13 Apr 2024 19:18:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83FB2281FBF
	for <lists+io-uring@lfdr.de>; Sat, 13 Apr 2024 17:18:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D136481BA;
	Sat, 13 Apr 2024 17:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FM/ytn6u"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B49347A2;
	Sat, 13 Apr 2024 17:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713028707; cv=none; b=HGTXflIadgfUvzwWd95QMbRl+h7Z0Q7cTCfKyLedS0ncRz+3HAQ1iaT8FB+z/wphrEyjqfS+cqClvKA5OKjjhVgllhPlYQdD7EjjCjSKTcsLrVYMxP4oOI4M4O76XES/w2dUcB1iSKAtcCeRbli++/W88zX0L9rmvgr3uYD1OIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713028707; c=relaxed/simple;
	bh=uuZNUhJVmDSbe9yg/jYMEbAR5uCGKOrbIm2RKIg4Xzo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e1lYiz8vZ1L1z7nNISxChVjuQBCIFEcXRzY1y/hA8Zd3nF9ENBRdJEfkmWzzKLAXROFFDKKvxCP2hOmVYQjXxqdb+CBnCfByHPUyAKqfzyd1SIVMOFvIqfhYihe++pvN16DsOpQdBwGAde2Zf4lQWRdYLsk7Ysc1dNMB847RPeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FM/ytn6u; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D9BC113CE;
	Sat, 13 Apr 2024 17:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713028705;
	bh=uuZNUhJVmDSbe9yg/jYMEbAR5uCGKOrbIm2RKIg4Xzo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FM/ytn6uwcloxSAfhVxjW/Bg+6EKGlcldZGXGMG6ymG+bx8ujCSNxcuB+2xiLQB2r
	 MC3phObkaav03/93Ptj+/4FXP7HP/IRa3KA3E3WJH1/gnIM7AITeMimQNHyrPLQNGt
	 8WZuDc7eeRuz3Wr+IkLGO6Se7lXdPVn0eN8J64EQ4PcTedTSB3sqXzuBLsvzJTQuSa
	 VGeP+6y5bZhPZCGiIY/sdwwO75rfPwBZ12eqsLAF1BfPaBJK6tNjE9rVM6u8km7Pn9
	 p2qMc949h7n4ab+hWwEA+wYH+u8HN68gIXw2gFoM5wKv7Bt3OB5JnkVQD0JXWexXb5
	 5Q1aQ+CFvyUtA==
Message-ID: <b9f51aa8-c6ee-41df-beae-f97fe9d7ed17@kernel.org>
Date: Sat, 13 Apr 2024 11:18:25 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 2/6] net: add callback for setting a ubuf_info to skb
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "David S . Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
References: <cover.1712923998.git.asml.silence@gmail.com>
 <d0d9e3fffcaba4ace1fb8f437bd4783928bb2d24.1712923998.git.asml.silence@gmail.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <d0d9e3fffcaba4ace1fb8f437bd4783928bb2d24.1712923998.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/12/24 6:55 AM, Pavel Begunkov wrote:
> At the moment an skb can only have one ubuf_info associated with it,
> which might be a performance problem for zerocopy sends in cases like
> TCP via io_uring. Add a callback for assigning ubuf_info to skb, this
> way we will implement smarter assignment later like linking ubuf_info
> together.
> 
> Note, it's an optional callback, which should be compatible with
> skb_zcopy_set(), that's because the net stack might potentially decide
> to clone an skb and take another reference to ubuf_info whenever it
> wishes. Also, a correct implementation should always be able to bind to
> an skb without prior ubuf_info, otherwise we could end up in a situation
> when the send would not be able to progress.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/linux/skbuff.h |  2 ++
>  net/core/skbuff.c      | 20 ++++++++++++++------
>  2 files changed, 16 insertions(+), 6 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

