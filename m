Return-Path: <io-uring+bounces-7493-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03247A909F1
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 19:26:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74AF23A6CD5
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 17:26:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5954121578B;
	Wed, 16 Apr 2025 17:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eQTO+ZTQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB33207E1D;
	Wed, 16 Apr 2025 17:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744824383; cv=none; b=ealk6EFdU0vCaoTryhgy3Fk3vEmgRR0qdI5q10VRWR2BzKI1sYa3nmQLyPGh7iNII+D1bsAyJHe5rW4LEIGNgc2sZIwJcVxdgL3OJ2z3S47rOTomV/vOvjdaLF1QXni/ybZxyibRILNfsgxis9YPzTCDQCdIxUg2w9sdftjc2J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744824383; c=relaxed/simple;
	bh=FbyUH9Bh6iIK+R4s7jCo7E7G1tF8phIalIejn+yv1FU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f4AfttzMGksg88ZtBYZdILVnEsalwRmy16qxTbZ8p56ClGHyC1O5TYx4SvkmpUrtIzNf3iuf2bPBMa+gEBw7kZe7e3MiLq5aOGSUJWEoW09okXNPlHo+yg6TKswxj+rYkG34+cCh7V2KGvY0gzUt+AttAzpANsUi9kq9EG3Xz7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eQTO+ZTQ; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-73712952e1cso6916902b3a.1;
        Wed, 16 Apr 2025 10:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744824377; x=1745429177; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UpfXwUbl9sOBERpJjFZvJgZimEb0qN5DzdPTCUAvREQ=;
        b=eQTO+ZTQFFHze1wQLbshTs/3JbSvUeQHzutDfSNzPylY+G5OqNzjovR5h/127yaEdq
         D3VQcqmk201oJCGtpmKgATs/BFBzeyWMhmKbjGCEnKXk6hO5Upg7Wm6B/fhauD1OOdCh
         MNUfwxKy955ONSv9C7OkY4+ODwLCCo+7Q/1W4E0JgBqL2lXyPqXxkBOtA/bMklEplixd
         0+J16mA23dvBHRd+P+J3tkZLWneTXefzLbxiofVTc9Rk5MR81ybURQ6KQksDJUBtW+7F
         EwUTTl/3O1zOZdyz+/Y1YeJJEp7L98r5p8/YP1/qssyArSF1KclGBYM8aP6mc/OZ18br
         hjEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744824377; x=1745429177;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UpfXwUbl9sOBERpJjFZvJgZimEb0qN5DzdPTCUAvREQ=;
        b=myQ590QI07LjQiqJhE3RonFN6HcQbeyrrbDEdFzoU2IoOipBvTS5I8d5y54TMHf26I
         MUeYxRTC7U4zL09MtZCT5xnqt/n/v0zRqH++QamhYwNIcRs5ngoVmYHXiUaqV1T7Upo5
         qFYcvIWuru+fWiAC3XdOmBLH8JPeWsz/31lf3rGlRNB/NGwT72c64P6+kORxOhJYEfKh
         btm3lywQaTh4RDAWpwyL6dIADPF3JZa/ttPEynLQiqRlfJKV/CTmSxyFm0UNO+bUhlVO
         KgeEj90nLUtv/PAYKEG1KgT3C9m5DAPWZYoIFAdx52FiX1lVE/dbpJLZdRQVehnnjd3C
         0LcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUnanNo/kSQohXaW9IOLz2V0zah41su6KHgdAwBcdCrrY/QrfcVV4uU7TJ7opVG5cfMnNJB@vger.kernel.org, AJvYcCVEy96hDGCYQq2JTR+gn3xY/MnRGezQlwV6B+KiFhWaVDcmIJlL3KQoMP7vCaRgFsln/LCJbQ9Aa9H5SJ81@vger.kernel.org, AJvYcCVNjc3s9B6CSQcDeJm/D1yYiwItW9wlhvMqGhcilUkdC0wSpH4O2ctY75y6AY3lbzPWgQ0Kjm/vs8lCxanenZLE@vger.kernel.org, AJvYcCWhgBnCJQVOdX1G7lctHlx12WvlY/Z+9XGgcYuvBF4WP6FJjjp9TlI/2SXITi7lYrQopu2plQFBHHJe@vger.kernel.org, AJvYcCXCXlxpoN01pLbYgNo8zEj6VnUhG6DVflln3RusPtyBuTgDr16NARrysvXD8eesxqk2DW8XNJjMDQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJB7GOjLzI1fISHsg5d1xE9VldiVO10ubDF955d29q5qawIu3b
	GiE8EWX01JRnfdMlL62gB+nAAXSF+duX/4mYhXRWnA5Q+Aeskbg=
X-Gm-Gg: ASbGnctad9U5eIZEMTCNhsnPfn0myCTrvT5Ls4brSbcyT7ye4ISytpqX94oMHdSlTbV
	WnZ2FS0KYrPzdKdAeYFBe6DLx96u4M1NjCP3oGwbBWqs+gI3j4Wq8RIWr9N46/dJB72K/dPIFZq
	SLOKFDv/RSbKeIhW/CHVLu9dsfKbCz2Hp1iMJIo0GI72RupceTw0kKUUNoA5nN95/DR+ZKph7v9
	ehFbfNJFj6MNF9Diw5R+K45ZB9rRwCNpvKQWlFfV9gu8mHD1XjSgn2aCiqwJIvdp/v740LdbxXN
	qmH2P62FfVOvNPRjruviEjEY/yZuFxK1NNuRqP92
X-Google-Smtp-Source: AGHT+IFvESgg+cSE/0j040cZkZJ81uyq2b6hJEaiYQ/BAOTXEwbuhBtGhTMyBC8YbKXFKlgO8OHwXw==
X-Received: by 2002:a05:6a21:6d89:b0:1f5:839e:ece8 with SMTP id adf61e73a8af0-203b3e500c7mr5324166637.2.1744824376952;
        Wed, 16 Apr 2025 10:26:16 -0700 (PDT)
Received: from localhost ([2601:646:9e00:f56e:123b:cea3:439a:b3e3])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-73bd2198b53sm10691169b3a.21.2025.04.16.10.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Apr 2025 10:26:16 -0700 (PDT)
Date: Wed, 16 Apr 2025 10:26:15 -0700
From: Stanislav Fomichev <stfomichev@gmail.com>
To: Mina Almasry <almasrymina@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Donald Hunter <donald.hunter@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Jeroen de Borst <jeroendb@google.com>,
	Harshitha Ramamurthy <hramamurthy@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Neal Cardwell <ncardwell@google.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Shuah Khan <shuah@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>,
	Kaiyuan Zhang <kaiyuanz@google.com>
Subject: Re: [PATCH net-next v8 4/9] net: devmem: Implement TX path
Message-ID: <Z__oN6HTawqLDfyG@mini-arch>
References: <20250415224756.152002-1-almasrymina@google.com>
 <20250415224756.152002-4-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250415224756.152002-4-almasrymina@google.com>

On 04/15, Mina Almasry wrote:
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
> 
> We additionally pipe the binding down to the new
> zerocopy_fill_skb_from_devmem which fills a TX skb with net_iov netmems
> instead of the traditional page netmems.
> 
> We also special case skb_frag_dma_map to return the dma-address of these
> dmabuf net_iovs instead of attempting to map pages.
> 
> The TX path may release the dmabuf in a context where we cannot wait.
> This happens when the user unbinds a TX dmabuf while there are still
> references to its netmems in the TX path. In that case, the netmems will
> be put_netmem'd from a context where we can't unmap the dmabuf, Resolve
> this by making __net_devmem_dmabuf_binding_free schedule_work'd.
> 
> Based on work by Stanislav Fomichev <sdf@fomichev.me>. A lot of the meat
> of the implementation came from devmem TCP RFC v1[1], which included the
> TX path, but Stan did all the rebasing on top of netmem/net_iov.
> 
> Cc: Stanislav Fomichev <sdf@fomichev.me>
> Signed-off-by: Kaiyuan Zhang <kaiyuanz@google.com>
> Signed-off-by: Mina Almasry <almasrymina@google.com>
> Acked-by: Stanislav Fomichev <sdf@fomichev.me>
> 
> ---
> 
> v8:
> - move adding the binding to the net_devmem_dmabuf_bindings after it's
>   been fully initialized to eliminate potential for races with send path
>   (Stan).
> - Use net_devmem_get_by_index_lock instead of rtnl_locking
> 
> v6:
> - Retain behavior that MSG_FASTOPEN succeeds even if cmsg is invalid
>   (Paolo).
> - Rework the freeing of tx_vec slightly to improve readability. Now it
>   has its own err label (Paolo).
> - Squash making unbinding scheduled work (Paolo).
> - Add comment to clarify that net_iovs stuck in the transmit path hold
>   a ref on the underlying dmabuf binding (David).
> - Fix the comment on how binding refcounting works on RX (the comment
>   was not matching the existing code behavior).
> 
> v5:
> - Return -EFAULT from zerocopy_fill_skb_from_devmem (Stan)
> - don't null check before kvfree (stan).
> 
> v4:
> - Remove dmabuf_tx_cmsg definition and just use __u32 for the dma-buf id
>   (Willem).
> - Check that iov_iter_type() is ITER_IOVEC in
>   zerocopy_fill_skb_from_iter() (Pavel).
> - Fix binding->tx_vec not being freed on error paths (Paolo).
> - Make devmem patch mutually exclusive with msg->ubuf_info path (Pavel).
> - Check that MSG_ZEROCOPY and SOCK_ZEROCOPY are provided when
>   sockc.dmabuf_id is provided.
> - Don't mm_account_pinned_pages() on devmem TX (Pavel).
> 
> v3:
> - Use kvmalloc_array instead of kcalloc (Stan).
> - Fix unreachable code warning (Simon).
> 
> v2:
> - Remove dmabuf_offset from the dmabuf cmsg.
> - Update zerocopy_fill_skb_from_devmem to interpret the
>   iov_base/iter_iov_addr as the offset into the dmabuf to send from
>   (Stan).
> - Remove the confusing binding->tx_iter which is not needed if we
>   interpret the iov_base/iter_iov_addr as offset into the dmabuf (Stan).
> - Remove check for binding->sgt and binding->sgt->nents in dmabuf
>   binding.
> - Simplify the calculation of binding->tx_vec.
> - Check in net_devmem_get_binding that the binding we're returning
>   has ifindex matching the sending socket (Willem).
> ---
>  include/linux/skbuff.h                  |  17 +++-
>  include/net/sock.h                      |   1 +
>  net/core/datagram.c                     |  48 ++++++++-
>  net/core/devmem.c                       | 127 ++++++++++++++++++++----
>  net/core/devmem.h                       |  61 ++++++++++--
>  net/core/netdev-genl.c                  |  62 +++++++++++-
>  net/core/skbuff.c                       |  18 ++--
>  net/core/sock.c                         |   6 ++
>  net/ipv4/ip_output.c                    |   3 +-
>  net/ipv4/tcp.c                          |  50 ++++++++--
>  net/ipv6/ip6_output.c                   |   3 +-
>  net/vmw_vsock/virtio_transport_common.c |   5 +-
>  12 files changed, 338 insertions(+), 63 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index f1381aff0f89..10dc0a439108 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -1710,13 +1710,16 @@ static inline void skb_set_end_offset(struct sk_buff *skb, unsigned int offset)
>  extern const struct ubuf_info_ops msg_zerocopy_ubuf_ops;
>  
>  struct ubuf_info *msg_zerocopy_realloc(struct sock *sk, size_t size,
> -				       struct ubuf_info *uarg);
> +				       struct ubuf_info *uarg, bool devmem);
>  
>  void msg_zerocopy_put_abort(struct ubuf_info *uarg, bool have_uref);
>  
> +struct net_devmem_dmabuf_binding;
> +
>  int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
>  			    struct sk_buff *skb, struct iov_iter *from,
> -			    size_t length);
> +			    size_t length,
> +			    struct net_devmem_dmabuf_binding *binding);
>  
>  int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
>  				struct iov_iter *from, size_t length);
> @@ -1724,12 +1727,14 @@ int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
>  static inline int skb_zerocopy_iter_dgram(struct sk_buff *skb,
>  					  struct msghdr *msg, int len)
>  {
> -	return __zerocopy_sg_from_iter(msg, skb->sk, skb, &msg->msg_iter, len);
> +	return __zerocopy_sg_from_iter(msg, skb->sk, skb, &msg->msg_iter, len,
> +				       NULL);
>  }
>  
>  int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
>  			     struct msghdr *msg, int len,
> -			     struct ubuf_info *uarg);
> +			     struct ubuf_info *uarg,
> +			     struct net_devmem_dmabuf_binding *binding);
>  
>  /* Internal */
>  #define skb_shinfo(SKB)	((struct skb_shared_info *)(skb_end_pointer(SKB)))
> @@ -3700,6 +3705,10 @@ static inline dma_addr_t __skb_frag_dma_map(struct device *dev,
>  					    size_t offset, size_t size,
>  					    enum dma_data_direction dir)
>  {
> +	if (skb_frag_is_net_iov(frag)) {
> +		return netmem_to_net_iov(frag->netmem)->dma_addr + offset +
> +		       frag->offset;
> +	}
>  	return dma_map_page(dev, skb_frag_page(frag),
>  			    skb_frag_off(frag) + offset, size, dir);
>  }
> diff --git a/include/net/sock.h b/include/net/sock.h
> index bb4d6189292f..5cb10cc0ca6e 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -1851,6 +1851,7 @@ struct sockcm_cookie {
>  	u32 tsflags;
>  	u32 ts_opt_id;
>  	u32 priority;
> +	u32 dmabuf_id;
>  };
>  
>  static inline void sockcm_init(struct sockcm_cookie *sockc,
> diff --git a/net/core/datagram.c b/net/core/datagram.c
> index f0634f0cb834..042a7dceb85a 100644
> --- a/net/core/datagram.c
> +++ b/net/core/datagram.c
> @@ -63,6 +63,8 @@
>  #include <net/busy_poll.h>
>  #include <crypto/hash.h>
>  
> +#include "devmem.h"
> +
>  /*
>   *	Is a socket 'connection oriented' ?
>   */
> @@ -691,9 +693,49 @@ int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
>  	return 0;
>  }
>  
> +static int
> +zerocopy_fill_skb_from_devmem(struct sk_buff *skb, struct iov_iter *from,
> +			      int length,
> +			      struct net_devmem_dmabuf_binding *binding)
> +{
> +	int i = skb_shinfo(skb)->nr_frags;
> +	size_t virt_addr, size, off;
> +	struct net_iov *niov;
> +
> +	/* Devmem filling works by taking an IOVEC from the user where the
> +	 * iov_addrs are interpreted as an offset in bytes into the dma-buf to
> +	 * send from. We do not support other iter types.
> +	 */
> +	if (iov_iter_type(from) != ITER_IOVEC)
> +		return -EFAULT;
> +
> +	while (length && iov_iter_count(from)) {
> +		if (i == MAX_SKB_FRAGS)
> +			return -EMSGSIZE;
> +
> +		virt_addr = (size_t)iter_iov_addr(from);
> +		niov = net_devmem_get_niov_at(binding, virt_addr, &off, &size);
> +		if (!niov)
> +			return -EFAULT;
> +
> +		size = min_t(size_t, size, length);
> +		size = min_t(size_t, size, iter_iov_len(from));
> +
> +		get_netmem(net_iov_to_netmem(niov));
> +		skb_add_rx_frag_netmem(skb, i, net_iov_to_netmem(niov), off,
> +				       size, PAGE_SIZE);
> +		iov_iter_advance(from, size);
> +		length -= size;
> +		i++;
> +	}
> +
> +	return 0;
> +}
> +
>  int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
>  			    struct sk_buff *skb, struct iov_iter *from,
> -			    size_t length)
> +			    size_t length,
> +			    struct net_devmem_dmabuf_binding *binding)
>  {
>  	unsigned long orig_size = skb->truesize;
>  	unsigned long truesize;
> @@ -701,6 +743,8 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
>  
>  	if (msg && msg->msg_ubuf && msg->sg_from_iter)
>  		ret = msg->sg_from_iter(skb, from, length);
> +	else if (unlikely(binding))
> +		ret = zerocopy_fill_skb_from_devmem(skb, from, length, binding);
>  	else
>  		ret = zerocopy_fill_skb_from_iter(skb, from, length);
>  
> @@ -734,7 +778,7 @@ int zerocopy_sg_from_iter(struct sk_buff *skb, struct iov_iter *from)
>  	if (skb_copy_datagram_from_iter(skb, 0, from, copy))
>  		return -EFAULT;
>  
> -	return __zerocopy_sg_from_iter(NULL, NULL, skb, from, ~0U);
> +	return __zerocopy_sg_from_iter(NULL, NULL, skb, from, ~0U, NULL);
>  }
>  EXPORT_SYMBOL(zerocopy_sg_from_iter);
>  
> diff --git a/net/core/devmem.c b/net/core/devmem.c
> index dca2ff7cf692..9599a82990e6 100644
> --- a/net/core/devmem.c
> +++ b/net/core/devmem.c
> @@ -16,6 +16,7 @@
>  #include <net/netdev_rx_queue.h>
>  #include <net/page_pool/helpers.h>
>  #include <net/page_pool/memory_provider.h>
> +#include <net/sock.h>
>  #include <trace/events/page_pool.h>
>  
>  #include "devmem.h"
> @@ -52,8 +53,10 @@ static dma_addr_t net_devmem_get_dma_addr(const struct net_iov *niov)
>  	       ((dma_addr_t)net_iov_idx(niov) << PAGE_SHIFT);
>  }
>  
> -void __net_devmem_dmabuf_binding_free(struct net_devmem_dmabuf_binding *binding)
> +void __net_devmem_dmabuf_binding_free(struct work_struct *wq)
>  {
> +	struct net_devmem_dmabuf_binding *binding = container_of(wq, typeof(*binding), unbind_w);
> +
>  	size_t size, avail;
>  
>  	gen_pool_for_each_chunk(binding->chunk_pool,
> @@ -71,8 +74,10 @@ void __net_devmem_dmabuf_binding_free(struct net_devmem_dmabuf_binding *binding)
>  	dma_buf_detach(binding->dmabuf, binding->attachment);
>  	dma_buf_put(binding->dmabuf);
>  	xa_destroy(&binding->bound_rxqs);
> +	kvfree(binding->tx_vec);
>  	kfree(binding);
>  }
> +EXPORT_SYMBOL(__net_devmem_dmabuf_binding_free);
>  
>  struct net_iov *
>  net_devmem_alloc_dmabuf(struct net_devmem_dmabuf_binding *binding)
> @@ -117,6 +122,13 @@ void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding)
>  	unsigned long xa_idx;
>  	unsigned int rxq_idx;
>  
> +	xa_erase(&net_devmem_dmabuf_bindings, binding->id);
> +
> +	/* Ensure no tx net_devmem_lookup_dmabuf() are in flight after the
> +	 * erase.
> +	 */
> +	synchronize_net();
> +
>  	if (binding->list.next)
>  		list_del(&binding->list);
>  
> @@ -131,8 +143,6 @@ void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding)
>  		__net_mp_close_rxq(binding->dev, rxq_idx, &mp_params);
>  	}
>  
> -	xa_erase(&net_devmem_dmabuf_bindings, binding->id);
> -
>  	net_devmem_dmabuf_binding_put(binding);
>  }
>  
> @@ -166,8 +176,9 @@ int net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
>  }
>  
>  struct net_devmem_dmabuf_binding *
> -net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
> -		       struct netlink_ext_ack *extack)
> +net_devmem_bind_dmabuf(struct net_device *dev,
> +		       enum dma_data_direction direction,
> +		       unsigned int dmabuf_fd, struct netlink_ext_ack *extack)
>  {
>  	struct net_devmem_dmabuf_binding *binding;
>  	static u32 id_alloc_next;
> @@ -189,43 +200,44 @@ net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
>  	}
>  
>  	binding->dev = dev;
> -
> -	err = xa_alloc_cyclic(&net_devmem_dmabuf_bindings, &binding->id,
> -			      binding, xa_limit_32b, &id_alloc_next,
> -			      GFP_KERNEL);
> -	if (err < 0)
> -		goto err_free_binding;
> -
>  	xa_init_flags(&binding->bound_rxqs, XA_FLAGS_ALLOC);
> -
>  	refcount_set(&binding->ref, 1);
> -
>  	binding->dmabuf = dmabuf;
>  
>  	binding->attachment = dma_buf_attach(binding->dmabuf, dev->dev.parent);
>  	if (IS_ERR(binding->attachment)) {
>  		err = PTR_ERR(binding->attachment);
>  		NL_SET_ERR_MSG(extack, "Failed to bind dmabuf to device");
> -		goto err_free_id;
> +		goto err_free_binding;
>  	}
>  
>  	binding->sgt = dma_buf_map_attachment_unlocked(binding->attachment,
> -						       DMA_FROM_DEVICE);
> +						       direction);
>  	if (IS_ERR(binding->sgt)) {
>  		err = PTR_ERR(binding->sgt);
>  		NL_SET_ERR_MSG(extack, "Failed to map dmabuf attachment");
>  		goto err_detach;
>  	}
>  
> +	if (direction == DMA_TO_DEVICE) {
> +		binding->tx_vec = kvmalloc_array(dmabuf->size / PAGE_SIZE,
> +						 sizeof(struct net_iov *),
> +						 GFP_KERNEL);
> +		if (!binding->tx_vec) {
> +			err = -ENOMEM;
> +			goto err_unmap;
> +		}
> +	}
> +
>  	/* For simplicity we expect to make PAGE_SIZE allocations, but the
>  	 * binding can be much more flexible than that. We may be able to
>  	 * allocate MTU sized chunks here. Leave that for future work...
>  	 */
> -	binding->chunk_pool =
> -		gen_pool_create(PAGE_SHIFT, dev_to_node(&dev->dev));
> +	binding->chunk_pool = gen_pool_create(PAGE_SHIFT,
> +					      dev_to_node(&dev->dev));
>  	if (!binding->chunk_pool) {
>  		err = -ENOMEM;
> -		goto err_unmap;
> +		goto err_tx_vec;
>  	}
>  
>  	virtual = 0;
> @@ -270,24 +282,35 @@ net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
>  			niov->owner = &owner->area;
>  			page_pool_set_dma_addr_netmem(net_iov_to_netmem(niov),
>  						      net_devmem_get_dma_addr(niov));
> +			if (direction == DMA_TO_DEVICE)
> +				binding->tx_vec[owner->area.base_virtual / PAGE_SIZE + i] = niov;
>  		}
>  
>  		virtual += len;
>  	}
>  
> +	err = xa_alloc_cyclic(&net_devmem_dmabuf_bindings, &binding->id,
> +			      binding, xa_limit_32b, &id_alloc_next,
> +			      GFP_KERNEL);
> +	if (err < 0)
> +		goto err_free_id;
> +
> +
>  	return binding;
>  
> +err_free_id:
> +	xa_erase(&net_devmem_dmabuf_bindings, binding->id);
>  err_free_chunks:
>  	gen_pool_for_each_chunk(binding->chunk_pool,
>  				net_devmem_dmabuf_free_chunk_owner, NULL);
>  	gen_pool_destroy(binding->chunk_pool);
> +err_tx_vec:
> +	kvfree(binding->tx_vec);
>  err_unmap:
>  	dma_buf_unmap_attachment_unlocked(binding->attachment, binding->sgt,
>  					  DMA_FROM_DEVICE);
>  err_detach:
>  	dma_buf_detach(dmabuf, binding->attachment);
> -err_free_id:
> -	xa_erase(&net_devmem_dmabuf_bindings, binding->id);
>  err_free_binding:
>  	kfree(binding);
>  err_put_dmabuf:
> @@ -295,6 +318,21 @@ net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
>  	return ERR_PTR(err);
>  }
>  
> +struct net_devmem_dmabuf_binding *net_devmem_lookup_dmabuf(u32 id)
> +{
> +	struct net_devmem_dmabuf_binding *binding;
> +
> +	rcu_read_lock();
> +	binding = xa_load(&net_devmem_dmabuf_bindings, id);
> +	if (binding) {
> +		if (!net_devmem_dmabuf_binding_get(binding))
> +			binding = NULL;
> +	}
> +	rcu_read_unlock();
> +
> +	return binding;
> +}
> +
>  void net_devmem_get_net_iov(struct net_iov *niov)
>  {
>  	net_devmem_dmabuf_binding_get(net_devmem_iov_binding(niov));
> @@ -305,6 +343,53 @@ void net_devmem_put_net_iov(struct net_iov *niov)
>  	net_devmem_dmabuf_binding_put(net_devmem_iov_binding(niov));
>  }
>  
> +struct net_devmem_dmabuf_binding *net_devmem_get_binding(struct sock *sk,
> +							 unsigned int dmabuf_id)
> +{
> +	struct net_devmem_dmabuf_binding *binding;
> +	struct dst_entry *dst = __sk_dst_get(sk);
> +	int err = 0;
> +
> +	binding = net_devmem_lookup_dmabuf(dmabuf_id);
> +	if (!binding || !binding->tx_vec) {
> +		err = -EINVAL;
> +		goto out_err;
> +	}
> +
> +	/* The dma-addrs in this binding are only reachable to the corresponding
> +	 * net_device.
> +	 */
> +	if (!dst || !dst->dev || dst->dev->ifindex != binding->dev->ifindex) {
> +		err = -ENODEV;
> +		goto out_err;
> +	}
> +
> +	return binding;
> +
> +out_err:
> +	if (binding)
> +		net_devmem_dmabuf_binding_put(binding);
> +
> +	return ERR_PTR(err);
> +}
> +
> +struct net_iov *
> +net_devmem_get_niov_at(struct net_devmem_dmabuf_binding *binding,
> +		       size_t virt_addr, size_t *off, size_t *size)
> +{
> +	size_t idx;
> +
> +	if (virt_addr >= binding->dmabuf->size)
> +		return NULL;
> +
> +	idx = virt_addr / PAGE_SIZE;
> +
> +	*off = virt_addr % PAGE_SIZE;
> +	*size = PAGE_SIZE - *off;
> +
> +	return binding->tx_vec[idx];
> +}
> +
>  /*** "Dmabuf devmem memory provider" ***/
>  
>  int mp_dmabuf_devmem_init(struct page_pool *pool)
> diff --git a/net/core/devmem.h b/net/core/devmem.h
> index 946f2e015746..67168aae5e5b 100644
> --- a/net/core/devmem.h
> +++ b/net/core/devmem.h
> @@ -23,8 +23,9 @@ struct net_devmem_dmabuf_binding {
>  
>  	/* The user holds a ref (via the netlink API) for as long as they want
>  	 * the binding to remain alive. Each page pool using this binding holds
> -	 * a ref to keep the binding alive. Each allocated net_iov holds a
> -	 * ref.
> +	 * a ref to keep the binding alive. The page_pool does not release the
> +	 * ref until all the net_iovs allocated from this binding are released
> +	 * back to the page_pool.
>  	 *
>  	 * The binding undos itself and unmaps the underlying dmabuf once all
>  	 * those refs are dropped and the binding is no longer desired or in
> @@ -32,7 +33,10 @@ struct net_devmem_dmabuf_binding {
>  	 *
>  	 * net_devmem_get_net_iov() on dmabuf net_iovs will increment this
>  	 * reference, making sure that the binding remains alive until all the
> -	 * net_iovs are no longer used.
> +	 * net_iovs are no longer used. net_iovs allocated from this binding
> +	 * that are stuck in the TX path for any reason (such as awaiting
> +	 * retransmits) hold a reference to the binding until the skb holding
> +	 * them is freed.
>  	 */
>  	refcount_t ref;
>  
> @@ -48,6 +52,14 @@ struct net_devmem_dmabuf_binding {
>  	 * active.
>  	 */
>  	u32 id;
> +
> +	/* Array of net_iov pointers for this binding, sorted by virtual
> +	 * address. This array is convenient to map the virtual addresses to
> +	 * net_iovs in the TX path.
> +	 */
> +	struct net_iov **tx_vec;
> +
> +	struct work_struct unbind_w;
>  };
>  
>  #if defined(CONFIG_NET_DEVMEM)
> @@ -64,14 +76,17 @@ struct dmabuf_genpool_chunk_owner {
>  	dma_addr_t base_dma_addr;
>  };
>  
> -void __net_devmem_dmabuf_binding_free(struct net_devmem_dmabuf_binding *binding);
> +void __net_devmem_dmabuf_binding_free(struct work_struct *wq);
>  struct net_devmem_dmabuf_binding *
> -net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
> -		       struct netlink_ext_ack *extack);
> +net_devmem_bind_dmabuf(struct net_device *dev,
> +		       enum dma_data_direction direction,
> +		       unsigned int dmabuf_fd, struct netlink_ext_ack *extack);
> +struct net_devmem_dmabuf_binding *net_devmem_lookup_dmabuf(u32 id);
>  void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding);
>  int net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
>  				    struct net_devmem_dmabuf_binding *binding,
>  				    struct netlink_ext_ack *extack);
> +void net_devmem_bind_tx_release(struct sock *sk);
>  
>  static inline struct dmabuf_genpool_chunk_owner *
>  net_devmem_iov_to_chunk_owner(const struct net_iov *niov)
> @@ -100,10 +115,10 @@ static inline unsigned long net_iov_virtual_addr(const struct net_iov *niov)
>  	       ((unsigned long)net_iov_idx(niov) << PAGE_SHIFT);
>  }
>  
> -static inline void
> +static inline bool
>  net_devmem_dmabuf_binding_get(struct net_devmem_dmabuf_binding *binding)
>  {
> -	refcount_inc(&binding->ref);
> +	return refcount_inc_not_zero(&binding->ref);
>  }
>  
>  static inline void
> @@ -112,7 +127,8 @@ net_devmem_dmabuf_binding_put(struct net_devmem_dmabuf_binding *binding)
>  	if (!refcount_dec_and_test(&binding->ref))
>  		return;
>  
> -	__net_devmem_dmabuf_binding_free(binding);
> +	INIT_WORK(&binding->unbind_w, __net_devmem_dmabuf_binding_free);
> +	schedule_work(&binding->unbind_w);
>  }
>  
>  void net_devmem_get_net_iov(struct net_iov *niov);
> @@ -123,6 +139,11 @@ net_devmem_alloc_dmabuf(struct net_devmem_dmabuf_binding *binding);
>  void net_devmem_free_dmabuf(struct net_iov *ppiov);
>  
>  bool net_is_devmem_iov(struct net_iov *niov);
> +struct net_devmem_dmabuf_binding *
> +net_devmem_get_binding(struct sock *sk, unsigned int dmabuf_id);
> +struct net_iov *
> +net_devmem_get_niov_at(struct net_devmem_dmabuf_binding *binding, size_t addr,
> +		       size_t *off, size_t *size);
>  
>  #else
>  struct net_devmem_dmabuf_binding;
> @@ -140,18 +161,23 @@ static inline void net_devmem_put_net_iov(struct net_iov *niov)
>  {
>  }
>  
> -static inline void
> -__net_devmem_dmabuf_binding_free(struct net_devmem_dmabuf_binding *binding)
> +static inline void __net_devmem_dmabuf_binding_free(struct work_struct *wq)
>  {
>  }
>  
>  static inline struct net_devmem_dmabuf_binding *
>  net_devmem_bind_dmabuf(struct net_device *dev, unsigned int dmabuf_fd,
> +		       enum dma_data_direction direction,
>  		       struct netlink_ext_ack *extack)
>  {
>  	return ERR_PTR(-EOPNOTSUPP);
>  }
>  
> +static inline struct net_devmem_dmabuf_binding *net_devmem_lookup_dmabuf(u32 id)
> +{
> +	return NULL;
> +}
> +
>  static inline void
>  net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding)
>  {
> @@ -190,6 +216,19 @@ static inline bool net_is_devmem_iov(struct net_iov *niov)
>  {
>  	return false;
>  }
> +
> +static inline struct net_devmem_dmabuf_binding *
> +net_devmem_get_binding(struct sock *sk, unsigned int dmabuf_id)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +
> +static inline struct net_iov *
> +net_devmem_get_niov_at(struct net_devmem_dmabuf_binding *binding, size_t addr,
> +		       size_t *off, size_t *size)
> +{
> +	return NULL;
> +}
>  #endif
>  
>  #endif /* _NET_DEVMEM_H */
> diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
> index 5e42f800dfcf..56502923f885 100644
> --- a/net/core/netdev-genl.c
> +++ b/net/core/netdev-genl.c
> @@ -873,7 +873,8 @@ int netdev_nl_bind_rx_doit(struct sk_buff *skb, struct genl_info *info)
>  		goto err_unlock;
>  	}
>  
> -	binding = net_devmem_bind_dmabuf(netdev, dmabuf_fd, info->extack);
> +	binding = net_devmem_bind_dmabuf(netdev, DMA_FROM_DEVICE, dmabuf_fd,
> +					 info->extack);
>  	if (IS_ERR(binding)) {
>  		err = PTR_ERR(binding);
>  		goto err_unlock;
> @@ -934,10 +935,65 @@ int netdev_nl_bind_rx_doit(struct sk_buff *skb, struct genl_info *info)
>  	return err;
>  }
>  
> -/* stub */
>  int netdev_nl_bind_tx_doit(struct sk_buff *skb, struct genl_info *info)
>  {
> -	return 0;
> +	struct net_devmem_dmabuf_binding *binding;
> +	struct list_head *sock_binding_list;
> +	struct net_device *netdev;
> +	u32 ifindex, dmabuf_fd;
> +	struct sk_buff *rsp;
> +	int err = 0;
> +	void *hdr;
> +
> +	if (GENL_REQ_ATTR_CHECK(info, NETDEV_A_DEV_IFINDEX) ||
> +	    GENL_REQ_ATTR_CHECK(info, NETDEV_A_DMABUF_FD))
> +		return -EINVAL;
> +
> +	ifindex = nla_get_u32(info->attrs[NETDEV_A_DEV_IFINDEX]);
> +	dmabuf_fd = nla_get_u32(info->attrs[NETDEV_A_DMABUF_FD]);
> +
> +	sock_binding_list = genl_sk_priv_get(&netdev_nl_family,
> +					     NETLINK_CB(skb).sk);
> +	if (IS_ERR(sock_binding_list))
> +		return PTR_ERR(sock_binding_list);
> +
> +	rsp = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!rsp)
> +		return -ENOMEM;
> +
> +	hdr = genlmsg_iput(rsp, info);
> +	if (!hdr) {
> +		err = -EMSGSIZE;
> +		goto err_genlmsg_free;
> +	}
> +
> +	netdev = netdev_get_by_index_lock(genl_info_net(info), ifindex);
> +	if (!netdev || !netif_device_present(netdev)) {
> +		err = -ENODEV;
> +		goto err_unlock;
> +	}
> +
> +	binding = net_devmem_bind_dmabuf(netdev, DMA_TO_DEVICE, dmabuf_fd,
> +					 info->extack);
> +	if (IS_ERR(binding)) {
> +		err = PTR_ERR(binding);
> +		goto err_unlock;
> +	}
> +
> +	list_add(&binding->list, sock_binding_list);
> +
> +	nla_put_u32(rsp, NETDEV_A_DMABUF_ID, binding->id);
> +	genlmsg_end(rsp, hdr);
> +
> +	netdev_unlock(netdev);
> +
> +	return genlmsg_reply(rsp, info);
> +
> +err_unlock:
> +	netdev_unlock(netdev);
> +err_genlmsg_free:
> +	nlmsg_free(rsp);
> +	return err;
>  }

The above needs to be converted to netdev_nl_sock? Untested:

diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
index 33cf5b21aeef..1c6b1dfa5742 100644
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -938,7 +938,7 @@ int netdev_nl_bind_rx_doit(struct sk_buff *skb, struct genl_info *info)
 int netdev_nl_bind_tx_doit(struct sk_buff *skb, struct genl_info *info)
 {
 	struct net_devmem_dmabuf_binding *binding;
-	struct list_head *sock_binding_list;
+	struct netdev_nl_sock *priv;
 	struct net_device *netdev;
 	u32 ifindex, dmabuf_fd;
 	struct sk_buff *rsp;
@@ -952,10 +952,9 @@ int netdev_nl_bind_tx_doit(struct sk_buff *skb, struct genl_info *info)
 	ifindex = nla_get_u32(info->attrs[NETDEV_A_DEV_IFINDEX]);
 	dmabuf_fd = nla_get_u32(info->attrs[NETDEV_A_DMABUF_FD]);
 
-	sock_binding_list = genl_sk_priv_get(&netdev_nl_family,
-					     NETLINK_CB(skb).sk);
-	if (IS_ERR(sock_binding_list))
-		return PTR_ERR(sock_binding_list);
+	priv = genl_sk_priv_get(&netdev_nl_family, NETLINK_CB(skb).sk);
+	if (IS_ERR(priv))
+		return PTR_ERR(priv);
 
 	rsp = genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!rsp)
@@ -967,10 +966,12 @@ int netdev_nl_bind_tx_doit(struct sk_buff *skb, struct genl_info *info)
 		goto err_genlmsg_free;
 	}
 
+	mutex_lock(&priv->lock);
+
 	netdev = netdev_get_by_index_lock(genl_info_net(info), ifindex);
 	if (!netdev || !netif_device_present(netdev)) {
 		err = -ENODEV;
-		goto err_unlock;
+		goto err_unlock_sock;
 	}
 
 #if 0
@@ -989,17 +990,21 @@ int netdev_nl_bind_tx_doit(struct sk_buff *skb, struct genl_info *info)
 		goto err_unlock;
 	}
 
-	list_add(&binding->list, sock_binding_list);
+	list_add(&binding->list, &priv->bindings);
 
 	nla_put_u32(rsp, NETDEV_A_DMABUF_ID, binding->id);
 	genlmsg_end(rsp, hdr);
 
 	netdev_unlock(netdev);
 
+	mutex_unlock(&priv->lock);
+
 	return genlmsg_reply(rsp, info);
 
 err_unlock:
 	netdev_unlock(netdev);
+err_unlock_sock:
+	mutex_unlock(&priv->lock);
 err_genlmsg_free:
 	nlmsg_free(rsp);
 	return err;

