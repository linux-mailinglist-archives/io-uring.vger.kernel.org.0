Return-Path: <io-uring+bounces-5901-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AC783A13022
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 01:44:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6602164FF6
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 00:44:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 126C5C139;
	Thu, 16 Jan 2025 00:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZVIU+cwj"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2D7A50;
	Thu, 16 Jan 2025 00:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736988261; cv=none; b=SXjNFSDmjJyFwbekGvb0dMUDbJFb1Kkxx8Od4S6nmtGkYoWVje+sFS3GTml9+6zC1Ut+guRpJ2eIDKu3VLAVYEsyDZrjZnYavViqROeHWZHNSYJsEchDDMtWuKqaNtCuXIy4mzHBAZuXZ+H43TykzrLxrmoxLgWElxL52qHkgn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736988261; c=relaxed/simple;
	bh=jyKgxWK707iuWzRs0V+2tOXoQ9+CXPqSmuChQV9W5nk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mq0CSHfBpeUeWy+ieZAq73odeBDPQaCXjQ69Y5KVeMBBWOvAYZ2rQV+fw7KFSJJuMocLArzROxswkBBXegAkPW4otmGIXZm1pL4zCk876p+/+muV0QTbCspZqo2hsITIlhSnNrIgVQgLaTQ5BoygCS7LlmxkRaa+qt2QWPaEVwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZVIU+cwj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8E4FC4CED1;
	Thu, 16 Jan 2025 00:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736988260;
	bh=jyKgxWK707iuWzRs0V+2tOXoQ9+CXPqSmuChQV9W5nk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZVIU+cwjgolz/gjZRPZ5QSdRr9k/ZOUM8vEN7qNH123VEg/TYvWpA6MjV5y5xtNLR
	 bJJ8F1KzN5i9x58ivESQJWI2VlyoV8Hr5DYe7XVuUhQPNy684EqUWL+hfpUBMc0amq
	 Gwl6y+I2F1eb/NDxq/cpkF8Z3mFgsnsyOSG7KVkXlNp2WEce/G1I4WVvEed0lbl+7M
	 Vs9lDDX1SpPhbd4FnMDnF1gFygCOGWkePwibnhF5RK6JV2nP2h4enMFfohzWjtCafi
	 OjBYjVKwLC7OO8EFPnt70OrOJgq1MhsX+zoKYV8+oyBX6I+rHvQEPnoscvYRum6WS9
	 0LFBgYcC53ryg==
Date: Wed, 15 Jan 2025 16:44:19 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v10 06/22] net: page_pool: create hooks for
 custom memory providers
Message-ID: <20250115164419.38837cd0@kernel.org>
In-Reply-To: <20250108220644.3528845-7-dw@davidwei.uk>
References: <20250108220644.3528845-1-dw@davidwei.uk>
	<20250108220644.3528845-7-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  8 Jan 2025 14:06:27 -0800 David Wei wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> 
> A spin off from the original page pool memory providers patch by Jakub,
> which allows extending page pools with custom allocators. One of such
> providers is devmem TCP, and the other is io_uring zerocopy added in
> following patches.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>

Something odd with authorship here. You list me as author (From)
but didn't add my SoB. Maybe add something like "Based on 
earlier work by Jakub" to the commit and reset the tags?
Or the Suggested-by is just for the warning on ops not being built in?

> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  include/net/page_pool/memory_provider.h | 20 ++++++++++++++++++++
>  include/net/page_pool/types.h           |  4 ++++
>  net/core/devmem.c                       | 15 ++++++++++++++-
>  net/core/page_pool.c                    | 23 +++++++++++++++--------
>  4 files changed, 53 insertions(+), 9 deletions(-)
>  create mode 100644 include/net/page_pool/memory_provider.h
> 
> diff --git a/include/net/page_pool/memory_provider.h b/include/net/page_pool/memory_provider.h
> new file mode 100644
> index 000000000000..79412a8714fa
> --- /dev/null
> +++ b/include/net/page_pool/memory_provider.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0
> + *
> + * page_pool/memory_provider.h
> + *	Author:	Pavel Begunkov <asml.silence@gmail.com>
> + *	Author:	David Wei <dw@davidwei.uk>

Not a customary thing in networking to list authors in comments.

> + */
> +#ifndef _NET_PAGE_POOL_MEMORY_PROVIDER_H
> +#define _NET_PAGE_POOL_MEMORY_PROVIDER_H
> +
> +#include <net/netmem.h>
> +#include <net/page_pool/types.h>

No need? All you need is forward declarations for types at this stage. 

> +struct memory_provider_ops {
> +	netmem_ref (*alloc_netmems)(struct page_pool *pool, gfp_t gfp);
> +	bool (*release_netmem)(struct page_pool *pool, netmem_ref netmem);
> +	int (*init)(struct page_pool *pool);
> +	void (*destroy)(struct page_pool *pool);
> +};
> +
> +#endif

Rest LGTM.

