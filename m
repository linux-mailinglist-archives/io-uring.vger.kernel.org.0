Return-Path: <io-uring+bounces-5907-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 535AEA13086
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 02:13:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9DB131888A6B
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 01:13:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB5CC125B9;
	Thu, 16 Jan 2025 01:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sPCLEkOB"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F851C695;
	Thu, 16 Jan 2025 01:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736989979; cv=none; b=mM1qRZsapb08aO06eK+BrZVgfU9DJmRa3AbwtipCYuLWV+sHZE1sbIBwQeUqEVzg1g/Y8oZJbMf7iEWzxdUw4+NbfBFXrF/sSR/bekiAHTQLkjUVlF6n9S7mJjRqJDRoJY/zvagLn+QHtC5wqBEkvh6xBL0Epu8a8q/pO+FxKTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736989979; c=relaxed/simple;
	bh=66RvYYm+yQPiJ81hmrvb4gjGExU4ffsA/G2xU7ulz58=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RQJowwGbpcACKlVZBw/gEL/qFq8MjJ44oFmSgHGYEXhW5VRrpQgy9U9me6YDCZ9h7ZyWeDq1Ys4AeNJJO2p0Rk/ZmRBlQfdyrb6DBdjx93L0UtMBkAko0RtbQybu17WWq1jF1syTWBeNko98c//YPeDqISaaKN8kMPwRL0hroFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sPCLEkOB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A821C4CED1;
	Thu, 16 Jan 2025 01:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736989979;
	bh=66RvYYm+yQPiJ81hmrvb4gjGExU4ffsA/G2xU7ulz58=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=sPCLEkOBtIHjftAsWeJFS0uJ/0JgWwjEF+Vr0NcWSucDMCBeWfeFfnymmayDxh7/s
	 5IBRaBA30XBMQaszzM8CnPZlqlcMN0LbcqOZmE2mNjg17yaXsgeoCfLlhY2dvn8FYP
	 RfbCrDiwOpJS5sZLTc7kSvQ/SMYR4ETvnwaBNSKf7YTYk+P9oSHdBYtMkmi5ZakrFp
	 /b6HC0XejRavmX3zyV9ib5T10rxOegcpTUjUmjChjrAJ2tyDmMNhzBhHH/QbK0+i0/
	 YHg43HvRxVSzl8FkcMe7QxKrLyTYiA28ROsTMzfw6odlZYLKVxwQW4+WXGaAw0AQQn
	 m34H3m2ZP2Skw==
Date: Wed, 15 Jan 2025 17:12:57 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v10 18/22] io_uring/zcrx: set pp memory
 provider for an rx queue
Message-ID: <20250115171257.04289cc9@kernel.org>
In-Reply-To: <20250108220644.3528845-19-dw@davidwei.uk>
References: <20250108220644.3528845-1-dw@davidwei.uk>
	<20250108220644.3528845-19-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  8 Jan 2025 14:06:39 -0800 David Wei wrote:
> +	ASSERT_RTNL();
> +
> +	if (ifq_idx >= dev->num_rx_queues)

_real_ rx queues.

We don't allow configuring disabled queues today.

> +		return -EINVAL;
> +	ifq_idx = array_index_nospec(ifq_idx, dev->num_rx_queues);
> +
> +	rxq = __netif_get_rx_queue(ifq->dev, ifq_idx);
> +	if (rxq->mp_params.mp_priv)
> +		return -EEXIST;
> +
> +	ifq->if_rxq = ifq_idx;
> +	rxq->mp_params.mp_ops = &io_uring_pp_zc_ops;
> +	rxq->mp_params.mp_priv = ifq;
> +	ret = netdev_rx_queue_restart(ifq->dev, ifq->if_rxq);
> +	if (ret)
> +		goto fail;

Hm. Could you move all this (and the rtnl_lock() in the caller) 
to a helper under net/ ? Or does something io_uring-y here need 
to be protected by rtnl_lock()?

