Return-Path: <io-uring+bounces-5956-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 12280A147F0
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 03:13:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7314A188B0F2
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 02:13:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 697961F5601;
	Fri, 17 Jan 2025 02:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TnuhYcuD"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F3AD25A65B;
	Fri, 17 Jan 2025 02:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737080031; cv=none; b=j2p7+ONJDSrdZRzz27f0heAf/1EOYv1Lh84NWbJYNwhDxULCfAmDJz1N9e+FnJckA03YBK/+Jgd8UpRmD4YuVP0yprMI+iC3lnaG7yucEkmeeRhPkpQb18/TaL7aSieFBtP7mIW9w2TdOU5aCn1EZu+17aoAf46BnBNI+l1XlXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737080031; c=relaxed/simple;
	bh=urTXIMFgRo57yaSj4xOUvgUv4vOR6XRo2x9OwI2Aajk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R9BXo6DVRWWOZ5JCxPegJUYIQcntz//iIfJnl4jvcqTU7UgEws6pTN/0zK2pwv73CxEiMQD2HUAr6YQbkwJBmUC5/GO0Jg0F3mOMZAzTFF1tA9Es4t4S1RXIilD1jIe77SSYL2hbMTV5dobT9aVg59xu3Ob12ttoYdZXemAKmpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TnuhYcuD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B51C4CED6;
	Fri, 17 Jan 2025 02:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737080030;
	bh=urTXIMFgRo57yaSj4xOUvgUv4vOR6XRo2x9OwI2Aajk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TnuhYcuDihIGsC0kGyfMIUR/NGkHBGmkC9Ui+BMUzGdycqodPUdust9Xp4J9VOy9R
	 vOzF60m4qAoUO6sgp3jaqmvFN+sVWbc3PcHjOw+O9k7XcKh4WilWSyf1Sjj+MSkQYA
	 oG3kUaUK1ie7OsFUdAeZWS3HKKGlmtN9snkG/pOLVS1H9IhmL776xAIuZlgSI9xoef
	 FXqmp6pQ3Og3HlPGgCFXg5aIdXcMGe7pNKcBNQuHm8tsNGRHneiUJavqpznywuMpxC
	 JgZxBweQRrMuOOz3SAqlKivxo+a0vxUaxDCKuFQ9XDdrSOEntA1mvKzrvlFr+evfEO
	 4YXmP29BsHQJA==
Date: Thu, 16 Jan 2025 18:13:49 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v11 17/21] io_uring/zcrx: set pp memory
 provider for an rx queue
Message-ID: <20250116181349.623471eb@kernel.org>
In-Reply-To: <20250116231704.2402455-18-dw@davidwei.uk>
References: <20250116231704.2402455-1-dw@davidwei.uk>
	<20250116231704.2402455-18-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 16 Jan 2025 15:16:59 -0800 David Wei wrote:
> +static void io_close_queue(struct io_zcrx_ifq *ifq)
> +{
> +	struct net_device *netdev;
> +	netdevice_tracker netdev_tracker;
> +	struct pp_memory_provider_params p = {
> +		.mp_ops = &io_uring_pp_zc_ops,
> +		.mp_priv = ifq,
> +	};
> +
> +	if (ifq->if_rxq == -1)
> +		return;
> +
> +	spin_lock(&ifq->lock);
> +	netdev = ifq->netdev;
> +	netdev_tracker = ifq->netdev_tracker;
> +	ifq->netdev = NULL;
> +	spin_unlock(&ifq->lock);
> +
> +	if (netdev)
> +		net_mp_close_rxq(netdev, ifq->if_rxq, &p);
> +	ifq->if_rxq = -1;
> +}

Did you mean to call netdev_put() somewhere here? :S

