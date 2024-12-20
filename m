Return-Path: <io-uring+bounces-5583-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CD9BF9F9CA5
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2024 23:14:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A79BF1895A49
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2024 22:14:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 442EA21E08B;
	Fri, 20 Dec 2024 22:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TPx57VVy"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8DA215702;
	Fri, 20 Dec 2024 22:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734732878; cv=none; b=ubRTvbiDoQtaSCSZWF8FmiHAQOF8kMqKFrY/d2ZuR94ZQIzsEh2JxywPN9ViGeVMaKU+jW2RnCIHY+tOj3eb+Tx/sfnE/653332c1XuOfAbxWr95IzRGQApya0hW5M/zjbcH/5ieWlONv6Gb+FQxGjuCy1hipR+8a/nD+M72EmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734732878; c=relaxed/simple;
	bh=KPVLL6ry6+VBOb5Qf+5gdDX6jK2LZpJO3B8rr0t/SIY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JQNvRsuHqO5i/611lkHKTtixavCg4WM+KTXEghk5u1df4ne0LO203bRhawTgHDjrKl1dhldv+q3WhOgkF2lP7KSWHXSc30xeGAnkW1OBKaD3dKbuh3lfCEL+NPLzAUdPLdvjRsZsUHXXIOfq8UDquHBLUOtWp6tRKjDzFGPR6nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TPx57VVy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30581C4CECD;
	Fri, 20 Dec 2024 22:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734732877;
	bh=KPVLL6ry6+VBOb5Qf+5gdDX6jK2LZpJO3B8rr0t/SIY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TPx57VVymhj5rplhjC7jeu0L/fw0EATG+VaW/iilfTlv02k3bQ65XT116nVoTeu4Z
	 8PPPghEKq2qBnfvpc2ZADNHZIn7X16W8lmGBrJ/tXOkioLG5JE1OAwIzS3vscHYmYt
	 SQgsbzjfHblq5O9A06CRV5+Ih81zPHWFfHkSwGBJWQNwrjcUgSQL9vG4k+CWcn/uyA
	 p9+caSlTb2pBlX7gzDsp0xIvQvjAD5eYDmRg/bmVauTQF4gZmUDS5YmKno0YA/khPA
	 4yO2Vb6k08JqWvH3kENriDWq9zFPw9zuNW7qkze+kmGAWCbMtL8zBbTJ19MTwkV6UI
	 c+/pjXsbB0Ytg==
Date: Fri, 20 Dec 2024 14:14:36 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v9 03/20] net: generalise net_iov chunk owners
Message-ID: <20241220141436.65513ff7@kernel.org>
In-Reply-To: <20241218003748.796939-4-dw@davidwei.uk>
References: <20241218003748.796939-1-dw@davidwei.uk>
	<20241218003748.796939-4-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 17 Dec 2024 16:37:29 -0800 David Wei wrote:
>  struct dmabuf_genpool_chunk_owner {
> -	/* Offset into the dma-buf where this chunk starts.  */
> -	unsigned long base_virtual;
> +	struct net_iov_area area;
> +	struct net_devmem_dmabuf_binding *binding;
>  
>  	/* dma_addr of the start of the chunk.  */
>  	dma_addr_t base_dma_addr;

Is there a good reason why dma addr is not part of net_iov_area?
net_iov_area is one chunk of continuous address space.
Instead of looping over pages in io_zcrx_map_area we could map 
the whole thing in one go.

