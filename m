Return-Path: <io-uring+bounces-5899-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C897A13009
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 01:35:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5CE1188068E
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 00:35:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96369F4FA;
	Thu, 16 Jan 2025 00:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jreAuJtQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D682AD23;
	Thu, 16 Jan 2025 00:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736987723; cv=none; b=X6kJdV7ZYLXkFKcfmyJgTMpd/fSLe2KKjSRp6ZI4AqMrGD89w2D/jTfManx1b9BbTNuzNf5b8c8QcHHoEPlPCHLgPYt+gJj0A2VcOGUDi9NkBl3ovg0YPx/Vp3uMskGVh60aQAGn/JRNNywTFWe+bk7MTOYFcC1oJ17uqUmgX8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736987723; c=relaxed/simple;
	bh=jMxHg9E6gtzCCPGDMWfmI86kJ74ubhSOR+r3K3vIbNU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tZw6jCvSG7mThoFxBcdPFElA+1dgixe7Ft+Ji1qNb/a+9A7Z/TLKmPpcg3x99dIBYs/bTeVV9E6/zh6T0qeSm2aLXpiUwjh359Ma7nKDocX0hNnYEgd9Qi999phkunLs/yuPfjxdbO1z0i1SH7i8INEDmuq/iaVdnXfviqOqatY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jreAuJtQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD6BC4CED1;
	Thu, 16 Jan 2025 00:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736987723;
	bh=jMxHg9E6gtzCCPGDMWfmI86kJ74ubhSOR+r3K3vIbNU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jreAuJtQmiH0afOUEm7+BSSyc3i7FetCMI5FeTSx+ncRF6QnBLSsnetYfWdYsXliK
	 Gz/Jee+iAC1yl8+27chvLIO899MnFIgkRvizIXkQQ3PDPaooeYPFc1dIa6TraskQSw
	 pZDpCH5MmTotCEhlTnmErN68RMWhCWh5paeQbhy7Bp5CHvGy/ihM5F7yNp/VQly0wT
	 0BBYBnmD5G/Ad8aV6CmbqeIp7KCh5w9nKcYZgrmDGq+vzNRROX+Y6sq7QBzlLN5WpM
	 ISYO5auragRkGiYIltQyYUKvejK/RApNyJyBwUxaTGvHDI7hQSRb5Z2Ef/B7A40SrW
	 4B3PJPhcintAw==
Date: Wed, 15 Jan 2025 16:35:21 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v10 05/22] net: page pool: export
 page_pool_set_dma_addr_netmem()
Message-ID: <20250115163521.273482c5@kernel.org>
In-Reply-To: <20250108220644.3528845-6-dw@davidwei.uk>
References: <20250108220644.3528845-1-dw@davidwei.uk>
	<20250108220644.3528845-6-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  8 Jan 2025 14:06:26 -0800 David Wei wrote:
> Export page_pool_set_dma_addr_netmem() in page_pool/helpers.h. This is
> needed by memory provider implementations that are outside of net/ to be
> able to set the dma addrs on net_iovs during alloc/free.

Please keep helpers.h focused on the driver-facing API.
Maybe create a new header page_pool/private.h would be
sufficiently suggestive.

