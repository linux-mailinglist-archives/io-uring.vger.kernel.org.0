Return-Path: <io-uring+bounces-5378-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D8089EA65C
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 04:15:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B8FD285C5F
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 03:15:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BD4B41C72;
	Tue, 10 Dec 2024 03:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qm5s8u1m"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A9AB644;
	Tue, 10 Dec 2024 03:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733800529; cv=none; b=P46haohjsB50DI1JAzvzKDFrQ26SDxyuU32IrYkKEwTqxqDSeYrCFdrt69mIWej+JDjOtXaVdn0TH3n9bfC2mULmkmxsfP6mG6/fDc7PEl4QE1LtE22lZTtzj5tSAEBwb8l9YUU6BZv1Fu18CHKBJvjv7lt7hJSiWf9kyadwEbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733800529; c=relaxed/simple;
	bh=hikp0XhoCm1dqCyO4dn4t0X6ZV8oady+HW0iZKvlZ28=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iTPT3/0nlwOOLlKpOW11gTf61tOAub5RggYdKyxFZWNM4j1ipGlS1yYnKFULYepg0DBfjAbmM+NjmGKVOWyWKEKldq6/MqhwUTDYvT8SRh29/TwcjkYpog+uaIfE0jE+pT0JZxU8p+bVqtbcAyH3PzffobeCBIkVlgD7+9rJUGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qm5s8u1m; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F187C4CED1;
	Tue, 10 Dec 2024 03:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733800527;
	bh=hikp0XhoCm1dqCyO4dn4t0X6ZV8oady+HW0iZKvlZ28=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qm5s8u1mfYHldehN7GyYGGsAsD8ratla3taWqKpnZq4eMohuyS8Y9gulIWLxZjZa1
	 pK77vESvXXp1QYWZe6Cdzb1atPilWImxnpTqci85Q8GUm49rDNPm+Vhhwn46AloQ07
	 3Sivzq55/A3ia+kdpEuau4Crmx4oOz5W1tscyQ/+ue6rPeOw1M30GNKPCB1ljcbsYx
	 TDyfK5FbXpVV6Dq6EZEMRB5Asa/kSIxMyk4NrI4ztElwsGoRaAtMCF6VsuZHDqNHYm
	 CyM13GVqdAfd3gbnP4AVmU3NEZhfl9G6LpzSQH5bnphGPZBly3rc7Je6fskHQjlWRp
	 VayBWFAIwj97Q==
Date: Mon, 9 Dec 2024 19:15:26 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v8 04/17] net: prepare for non devmem TCP
 memory providers
Message-ID: <20241209191526.063d6797@kernel.org>
In-Reply-To: <20241204172204.4180482-5-dw@davidwei.uk>
References: <20241204172204.4180482-1-dw@davidwei.uk>
	<20241204172204.4180482-5-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  4 Dec 2024 09:21:43 -0800 David Wei wrote:
> +EXPORT_SYMBOL_GPL(net_is_devmem_page_pool_ops);

Export doesn't seem necessary, no module should need this right?

> @@ -316,10 +322,10 @@ void dev_dmabuf_uninstall(struct net_device *dev)
>  	unsigned int i;
>  
>  	for (i = 0; i < dev->real_num_rx_queues; i++) {
> -		binding = dev->_rx[i].mp_params.mp_priv;
> -		if (!binding)
> +		if (dev->_rx[i].mp_params.mp_ops != &dmabuf_devmem_ops)
>  			continue;
>  
> +		binding = dev->_rx[i].mp_params.mp_priv;
>  		xa_for_each(&binding->bound_rxqs, xa_idx, rxq)
>  			if (rxq == &dev->_rx[i]) {
>  				xa_erase(&binding->bound_rxqs, xa_idx);

Maybe add an op to mp_ops for queue unbinding?
Having an op struct and yet running code under if (ops == X) seems odd.

> -	if (binding && nla_put_u32(rsp, NETDEV_A_PAGE_POOL_DMABUF, binding->id))
> -		goto err_cancel;
> +	if (net_is_devmem_page_pool_ops(pool->mp_ops)) {
> +		binding = pool->mp_priv;
> +		if (nla_put_u32(rsp, NETDEV_A_PAGE_POOL_DMABUF, binding->id))
> +			goto err_cancel;

ditto, all mps should show up in page pool info. Even if it's just 
an empty nest for now, waiting for attributes to be added later.

> +	}
>  
>  	genlmsg_end(rsp, hdr);
>  
> @@ -353,16 +356,16 @@ void page_pool_unlist(struct page_pool *pool)
>  int page_pool_check_memory_provider(struct net_device *dev,
>  				    struct netdev_rx_queue *rxq)
>  {
> -	struct net_devmem_dmabuf_binding *binding = rxq->mp_params.mp_priv;
> +	void *mp_priv = rxq->mp_params.mp_priv;
>  	struct page_pool *pool;
>  	struct hlist_node *n;
>  
> -	if (!binding)
> +	if (!mp_priv)
>  		return 0;
>  
>  	mutex_lock(&page_pools_lock);
>  	hlist_for_each_entry_safe(pool, n, &dev->page_pools, user.list) {
> -		if (pool->mp_priv != binding)
> +		if (pool->mp_priv != mp_priv)
>  			continue;
>  
>  		if (pool->slow.queue_idx == get_netdev_rx_queue_index(rxq)) {

appears to be unrelated

> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index b872de9a8271..f22005c70fd3 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -277,6 +277,7 @@
>  #include <net/ip.h>
>  #include <net/sock.h>
>  #include <net/rstreason.h>
> +#include <net/page_pool/types.h>

types.h being needed to call a helper is unusual

>  #include <linux/uaccess.h>
>  #include <asm/ioctls.h>
> @@ -2476,6 +2477,11 @@ static int tcp_recvmsg_dmabuf(struct sock *sk, const struct sk_buff *skb,
>  			}
>  
>  			niov = skb_frag_net_iov(frag);
> +			if (net_is_devmem_page_pool_ops(niov->pp->mp_ops)) {

This one seems legit to me, FWIW, checking if its devmem in devmem
specific code is fine. 

> +				err = -ENODEV;
> +				goto out;
> +			}
> +
>  			end = start + skb_frag_size(frag);
>  			copy = end - offset;
>  

