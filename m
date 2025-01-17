Return-Path: <io-uring+bounces-5960-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81153A14839
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 03:26:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F0D7D3AA165
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 02:25:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0D4B1F5606;
	Fri, 17 Jan 2025 02:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Az1AAbjF"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883B81096F;
	Fri, 17 Jan 2025 02:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737080760; cv=none; b=Y3MBRdtcie/+hl/uZw0bQxoJfjHNabxDLDRs+rNXQwc4zKx3YMrJ14uyNuQ+cflNqGbR56HCGTMTpYfTPzZRz2LhWUWPgELP5h2bWRuGaEXQy9bjv69j6ZYyUN1nsE4cYReTyzd2eInLkoNFmtZbYWGgB3iZy57SG254DySzD48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737080760; c=relaxed/simple;
	bh=qVbxRSsTHZamwBW++n7OJxtgHbjxQOskNuqIoYmuvmk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TbEitcIxlO68T/zr/wkZxy14xGSLQlIps1dsh0VLY4ae7Q47VnrfitMijfNQdGS4kW9Zxy5CMXFHnlSmn7SqaVMm8oOhhy5QNwEUvW8GkUjaix3ZCXwmylJKMOgVXtqNp2iy+pM/WCnM6N/D3HH2FFPHrGlHxeiqnJBko7xgykk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Az1AAbjF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7463BC4CED6;
	Fri, 17 Jan 2025 02:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737080760;
	bh=qVbxRSsTHZamwBW++n7OJxtgHbjxQOskNuqIoYmuvmk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Az1AAbjF9AoALnQk57zkS+knVyEAAUa57aamq1C/S96bJRFM4VB0zcHC/+WuSX1wT
	 ko3ywryspfP7Mi4hz0zavYQOxWHXs0L5Kx9q8eGIjEBA86Jxqxh0nUAsXaCsXC5DJj
	 FnOu6aAVcyGKJGDyCN8m2L8BP1eRByupEB21zDc+kqvdAI5jxFzrs/N5QLD1pdJ2Ga
	 DSlg7qt8xtElq9k54/14pbSvIEARzqr3E59hkFQ6PZLs0UbeeGG52FYIiAed0HrI5k
	 3Knv4Zxh6UHs+mKrXea6I0P40DhCUgYiLW8o7f9wxZLoLY8QixpgnVFDF9JbsEd5DP
	 8CugNy75F9nEg==
Date: Thu, 16 Jan 2025 18:25:58 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v11 10/21] net: add helpers for setting a
 memory provider on an rx queue
Message-ID: <20250116182558.4c7b66f6@kernel.org>
In-Reply-To: <20250116231704.2402455-11-dw@davidwei.uk>
References: <20250116231704.2402455-1-dw@davidwei.uk>
	<20250116231704.2402455-11-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 16 Jan 2025 15:16:52 -0800 David Wei wrote:
> +static void __net_mp_close_rxq(struct net_device *dev, unsigned ifq_idx,
> +			      struct pp_memory_provider_params *old_p)
> +{
> +	struct netdev_rx_queue *rxq;
> +	int ret;
> +
> +	if (WARN_ON_ONCE(ifq_idx >= dev->real_num_rx_queues))
> +		return;
> + 
> +	rxq = __netif_get_rx_queue(dev, ifq_idx);

I think there's a small race between io_uring closing and the netdev
unregister. We can try to uninstall twice, let's put

	/* Callers holding a netdev ref may get here after we already
	 * went thru shutdown via dev_memory_provider_uninstall().
	 */
	if (dev->reg_state > NETREG_REGISTERED &&
	    !rxq->mp_params.mp_ops)
		return;

here, and in dev_memory_provider_uninstall() clear the pointers?

> +	if (WARN_ON_ONCE(rxq->mp_params.mp_ops != old_p->mp_ops ||
> +			 rxq->mp_params.mp_priv != old_p->mp_priv))
> +		return;
> +
> +	rxq->mp_params.mp_ops = NULL;
> +	rxq->mp_params.mp_priv = NULL;
> +	ret = netdev_rx_queue_restart(dev, ifq_idx);
> +	if (ret)
> +		pr_devel("Could not restart queue %u after removing memory provider.\n",
> +			 ifq_idx);
> +}

