Return-Path: <io-uring+bounces-7740-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E95AEA9DBBE
	for <lists+io-uring@lfdr.de>; Sat, 26 Apr 2025 17:14:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 470A63ABB57
	for <lists+io-uring@lfdr.de>; Sat, 26 Apr 2025 15:14:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2D8E25CC5A;
	Sat, 26 Apr 2025 15:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="aqZKh2uL"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.smtpout.orange.fr (smtp-75.smtpout.orange.fr [80.12.242.75])
	(using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7DA13E41A;
	Sat, 26 Apr 2025 15:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745680463; cv=none; b=i5V+9Nwza6xZeBbF1R510eFFpiyhnMNZUX221CxBXprD6lUHyzlMyKkWRbuRaFT3K8YG8W1KsEZ/zd10I0dbXG6t9Xt+exll2zyQFcmEfcQ/ps91aUwQqunQt8KIBJDgXm0iqrVIqHVjIp6OtNzX5pnQGlEymiOzMMhN8/F+yV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745680463; c=relaxed/simple;
	bh=IWfcmPKJHXBs8q7otC+Rd8qWS2HN1vQ1l6y9dmgLnGM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n9hC+tzGnYI/FDHaCWYZgewLOjnsgkbRU8AxljBtO4ePlCqauRX2OzCxSIxGOsChcQsImtuAhcR8GayCfNpzlZuLi3IWbT4uB5tt3doN9bQ9/8Vh406CE607muDxnnBfDK3OTtQBmacN41IYKDmo9AQoBdivQrO+BacOK/6x6Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=aqZKh2uL; arc=none smtp.client-ip=80.12.242.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Received: from [192.168.1.37] ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id 8hD8uuyJPSxyX8hDCuh2W3; Sat, 26 Apr 2025 17:13:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1745680389;
	bh=lGpF8EKyLgMCkElYaAwd2ZnEJtgke/GdzymKjUrzlVM=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=aqZKh2uL+y+b2Aub09013KtAOCdfvwHnCs1YOFRkOMpkOzHgfYygb59ix86fOed/Z
	 0a9DevAK9H5NZ5PKOWVXnAiNJCdSZlyR66ghl6FEzVwwyFDDj5D8ScupQ0HH3lajcX
	 yYfRZX4co8wOtYe/Bmfnlmrv96J5qgOVsUu+r/gOCzzcZVSgUXa9QkJI2oieEQve0J
	 nVXxZUfiwRQjlDk73akeFu8pOJvwe88V3wuigzVPg3oCqdR8eA5w6/ni7O8tQF2F+h
	 K3CqdJ5NnN5vWlHR252XUnBkOA7aCDr8fFukRCjcGziJPxi1UrpugV8858pvnMdPAj
	 qiZQMm1CyWk2A==
X-ME-Helo: [192.168.1.37]
X-ME-Auth: bWFyaW9uLmphaWxsZXRAd2FuYWRvby5mcg==
X-ME-Date: Sat, 26 Apr 2025 17:13:09 +0200
X-ME-IP: 90.11.132.44
Message-ID: <fceb6891-2749-496a-a6d5-db0748728e8a@wanadoo.fr>
Date: Sat, 26 Apr 2025 17:12:58 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v12 4/9] net: devmem: Implement TX path
To: Mina Almasry <almasrymina@google.com>
Cc: andrew+netdev@lunn.ch, asml.silence@gmail.com, axboe@kernel.dk,
 corbet@lwn.net, davem@davemloft.net, donald.hunter@gmail.com,
 dsahern@kernel.org, dw@davidwei.uk, edumazet@google.com,
 eperezma@redhat.com, horms@kernel.org, hramamurthy@google.com,
 io-uring@vger.kernel.org, jasowang@redhat.com, jeroendb@google.com,
 jhs@mojatatu.com, kaiyuanz@google.com, kuba@kernel.org, kuniyu@amazon.com,
 kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 mst@redhat.com, ncardwell@google.com, netdev@vger.kernel.org,
 pabeni@redhat.com, pctammela@mojatatu.com, sdf@fomichev.me,
 sgarzare@redhat.com, shuah@kernel.org, skhawaja@google.com,
 stefanha@redhat.com, victor@mojatatu.com, virtualization@lists.linux.dev,
 willemb@google.com, xuanzhuo@linux.alibaba.com
References: <20250425204743.617260-1-almasrymina@google.com>
 <20250425204743.617260-5-almasrymina@google.com>
Content-Language: en-US, fr-FR
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <20250425204743.617260-5-almasrymina@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 25/04/2025 à 22:47, Mina Almasry a écrit :
> Augment dmabuf binding to be able to handle TX. Additional to all the RX
> binding, we also create tx_vec needed for the TX path.
> 
> Provide API for sendmsg to be able to send dmabufs bound to this device:
> 
> - Provide a new dmabuf_tx_cmsg which includes the dmabuf to send from.
> - MSG_ZEROCOPY with SCM_DEVMEM_DMABUF cmsg indicates send from dma-buf.
> 
> Devmem is uncopyable, so piggyback off the existing MSG_ZEROCOPY
> implementation, while disabling instances where MSG_ZEROCOPY falls back
> to copying.

...

> @@ -270,24 +284,34 @@ net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
>   			niov->owner = &owner->area;
>   			page_pool_set_dma_addr_netmem(net_iov_to_netmem(niov),
>   						      net_devmem_get_dma_addr(niov));
> +			if (direction == DMA_TO_DEVICE)
> +				binding->tx_vec[owner->area.base_virtual / PAGE_SIZE + i] = niov;
>   		}
>   
>   		virtual += len;
>   	}
>   
> +	err = xa_alloc_cyclic(&net_devmem_dmabuf_bindings, &binding->id,
> +			      binding, xa_limit_32b, &id_alloc_next,
> +			      GFP_KERNEL);
> +	if (err < 0)
> +		goto err_free_id;
> +
>   	return binding;
>   
> +err_free_id:
> +	xa_erase(&net_devmem_dmabuf_bindings, binding->id);

Not sure this is correct now that xa_alloc_cyclic() is the last function 
which is called.
I guess that that the last goto should be to err_free_chunks.

>   err_free_chunks:
>   	gen_pool_for_each_chunk(binding->chunk_pool,
>   				net_devmem_dmabuf_free_chunk_owner, NULL);
>   	gen_pool_destroy(binding->chunk_pool);
> +err_tx_vec:
> +	kvfree(binding->tx_vec);
>   err_unmap:
>   	dma_buf_unmap_attachment_unlocked(binding->attachment, binding->sgt,
>   					  DMA_FROM_DEVICE);
>   err_detach:
>   	dma_buf_detach(dmabuf, binding->attachment);
> -err_free_id:
> -	xa_erase(&net_devmem_dmabuf_bindings, binding->id);
>   err_free_binding:
>   	kfree(binding);
>   err_put_dmabuf:

...

> diff --git a/net/core/sock.c b/net/core/sock.c
> index b64df2463300b..9dd2989040357 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -3017,6 +3017,12 @@ int __sock_cmsg_send(struct sock *sk, struct cmsghdr *cmsg,
>   		if (!sk_set_prio_allowed(sk, *(u32 *)CMSG_DATA(cmsg)))
>   			return -EPERM;
>   		sockc->priority = *(u32 *)CMSG_DATA(cmsg);
> +		break;
> +	case SCM_DEVMEM_DMABUF:
> +		if (cmsg->cmsg_len != CMSG_LEN(sizeof(u32)))
> +			return -EINVAL;
> +		sockc->dmabuf_id = *(u32 *)CMSG_DATA(cmsg);
> +

Nitpick: Unneeded newline, to be consistent with the surrounding code.

>   		break;
>   	default:
>   		return -EINVAL;

...

CJ

