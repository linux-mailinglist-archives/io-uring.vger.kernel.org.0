Return-Path: <io-uring+bounces-5377-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 891039EA623
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 04:02:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 82E3918894F3
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 03:02:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B9D8198A37;
	Tue, 10 Dec 2024 03:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nOun1xSz"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFF68F6D;
	Tue, 10 Dec 2024 03:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733799753; cv=none; b=BXqmY/J7TPZZh9Scfsqf67CekE8f3AqNqwwJHJNBaRhpBhFKDMOEqEbQYHveYj1Ty27fkCwlRDZDWNx8WPru+Rv9sErlA+BKMEiLJ4oVdB4Rd9aQDvHD3iNiYZEjUuGeCdVDnvIrPft/cPJshrFdfudMGVkOJTuDF6dQkCPt6IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733799753; c=relaxed/simple;
	bh=XjzxSBPqtlDFVuUyXOEC7BA3sIrzDT6DLdhSO1Wse9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NDAqvkBmGIbJ4vy9AaCT4onNoZ0yHl4h9tbxine8J9bV+U0H+OBMlYNQEX8Wjdm5EghtpzJuqzbtYbE1EoTiJqVby0+IpxWWhHsIEm9SRDbLtHP6QR7ub0+keK8vl1ah8jUFHTY301Wwur4p/TKup82YkHR7XYGpCuyYIS05upg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nOun1xSz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D8DC4CED1;
	Tue, 10 Dec 2024 03:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733799752;
	bh=XjzxSBPqtlDFVuUyXOEC7BA3sIrzDT6DLdhSO1Wse9Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=nOun1xSzeIyUYZ0A7QNR2MDPNaYqp2bbLoHqLWZD/pI1GSc6Dmxi8TsRhUhDrI2X4
	 U016d1Jqn7W80ts7KC+lmUdWpQ3tqn4P80VLuHEUgdeXj9xaQll/MzxIr4gTJbd5u0
	 tDi3j0YzFPH60s5QDnd410Ukg98KQmy1m9teVwvWuCLrlIB+Vi4OzXRbjRkRQIWRG9
	 SWost56vENwHncUS9TEGXYAjX6+S4/NqrG3pODRO49rPPSWxFGv2khMGu7KYRtIBw7
	 u+/sJHm4O8QzPt++aFMk/tn1Rft2TGwjcZqTk0ymknkYmsmMM3KdHos0UyvBZ6s65n
	 JcPFThQ+Qvo2w==
Date: Mon, 9 Dec 2024 19:02:30 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v8 03/17] net: page_pool: create hooks for
 custom page providers
Message-ID: <20241209190230.2df85b79@kernel.org>
In-Reply-To: <20241204172204.4180482-4-dw@davidwei.uk>
References: <20241204172204.4180482-1-dw@davidwei.uk>
	<20241204172204.4180482-4-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  4 Dec 2024 09:21:42 -0800 David Wei wrote:
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index f89cf93f6eb4..36f61a1e4ffe 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -284,10 +284,11 @@ static int page_pool_init(struct page_pool *pool,
>  		rxq = __netif_get_rx_queue(pool->slow.netdev,
>  					   pool->slow.queue_idx);
>  		pool->mp_priv = rxq->mp_params.mp_priv;
> +		pool->mp_ops = rxq->mp_params.mp_ops;
>  	}
>  
> -	if (pool->mp_priv) {
> -		err = mp_dmabuf_devmem_init(pool);
> +	if (pool->mp_ops) {

Can we throw in a:

		if (WARN_ON(!is_kernel_rodata((unsigned long)pool->mp_ops)))
			goto free_ptr_ring;

here, to avoid any abuse?

> +		err = pool->mp_ops->init(pool);
>  		if (err) {
>  			pr_warn("%s() mem-provider init failed %d\n", __func__,
>  				err);

