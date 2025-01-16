Return-Path: <io-uring+bounces-5900-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EDCBCA13016
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 01:39:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 891163A596D
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 00:39:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1263A957;
	Thu, 16 Jan 2025 00:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HD7TeAlq"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A642A18C0C;
	Thu, 16 Jan 2025 00:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736987969; cv=none; b=gXYyzZ7/5prQNmKlHcgNdIzfPJPAVrlsZvBUr4dJgxAfCDL75TTv6JkYGpLVu8IRUrs1K4Xo3t978t/S4dQbwcgyOPkF/8w7pUkJOsBGsoAJyf6yK4k3IsBZKeITWBuXPyhBeOx0Ymm1zD40w5xx88DOvgMlabspOQV6/oQrWwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736987969; c=relaxed/simple;
	bh=MO0KkE1QiznuBHY3LxHa3qFCP8lKsi1qSOlWXWXbF3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AgiZwW9onS1vdpUIJ3JPhwvloxIw3Kz85+3vhpoDhCdgdI0sDAjx1aQSB/Y4Kj3tGauE14fi6JQRyMhtdRp7BC60QASf26RVJywEE/H6mXYSMzCTdzGARyt3c4Abz45hQIobU7ilqkP+RSzss4LhPHm2/PHSwpOFFTFhzsVnc1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HD7TeAlq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8F6C4CED1;
	Thu, 16 Jan 2025 00:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736987969;
	bh=MO0KkE1QiznuBHY3LxHa3qFCP8lKsi1qSOlWXWXbF3Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HD7TeAlqVpMs3gNSzwq59hHxQqsiB3lZJ3TJ1L2XtS0hKKMVjyTCx86AyUvBTTZBh
	 wKxOd9trM5UwAbiAPnBC9R8uqp2Vhgr8I6vbnTRk8UAJwP3YndoLbzUSsTTZWEMAUc
	 7/kpx0dU7VhIITpVZkAWlWx3agu8t2PrlDJAySQ4yNv3390Hpr5Wd/I974z1dWc8mD
	 qK2HcAEAhJqQAnoUAzQCW61YcukMfsKrL3u8PQDXibK68hLAvXq0cZJkTDRjxlUXx2
	 RrlhGvm4cm3kio62wA16vXcC4f5s0tgx3M/KDz7jupxKcwCXsD3d+Pq3HWeqLh+YMn
	 IHGKyyhiOHCRQ==
Date: Wed, 15 Jan 2025 16:39:27 -0800
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
Message-ID: <20250115163927.07713dca@kernel.org>
In-Reply-To: <20250115163521.273482c5@kernel.org>
References: <20250108220644.3528845-1-dw@davidwei.uk>
	<20250108220644.3528845-6-dw@davidwei.uk>
	<20250115163521.273482c5@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 15 Jan 2025 16:35:21 -0800 Jakub Kicinski wrote:
> On Wed,  8 Jan 2025 14:06:26 -0800 David Wei wrote:
> > Export page_pool_set_dma_addr_netmem() in page_pool/helpers.h. This is
> > needed by memory provider implementations that are outside of net/ to be
> > able to set the dma addrs on net_iovs during alloc/free.  
> 
> Please keep helpers.h focused on the driver-facing API.
> Maybe create a new header page_pool/private.h would be
> sufficiently suggestive.

Or you can put it in the memory_provider one from the next patch.

