Return-Path: <io-uring+bounces-4317-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 90B9C9B9644
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 18:09:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B1F8D1C208F1
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 17:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8DB513A3F3;
	Fri,  1 Nov 2024 17:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4uwigSGs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F43A935
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 17:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730480983; cv=none; b=ew8fc7uilHMvSVwZobDFXP6CGL9xfusGxYQF2mOIB66j8pY48t1/N2J0yoU2wgR4Fk6KV4C0yaVg3T28CHKdSM58u+toQxaaBv9kyX3OXIV95vebyiO5iYyEVbJLB/PIxBJKK3R6sqTqwjaUGTZ8PwzD9BaKetgUjsUpi1nxCc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730480983; c=relaxed/simple;
	bh=v/flG3MQ6OddjwpQCS3r/Fpymi8ON8bNYYOP+7Sda0Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iNxtLAe4jc5LlxdfWfXh2SkLFm8bdvEyhruCD00UYIvaXRlVH2y4zIz/CGvaNeWnKnIzRAxNqHzHqV7M1kfeSdpHBFUydoUyRul9fKh2ZbknLXaw5REEdMEWN6gvTKG7hHo3U1Rt5k/l5+Ysh+LfMCDzc/ygOHtVTOHG3BjYO/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4uwigSGs; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-539e617ef81so625e87.1
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 10:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730480979; x=1731085779; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=leKs4cy/2ceBeA0A+XYjBZ1WS0bFYV6vrc29reZpnsM=;
        b=4uwigSGsPN04Gkvfl7UZSiNvDpiy7HisC2OnIfzqqGmUbHPRlnH1y4xdI57b/s24iv
         X7PxzNdJBjH/6NBLhkfxJwwte8+xcvKgkrGBepDEzMPqtxeNT/TX8zLj/Sc1LSosHuru
         N1ZtGW0toVettv0rpd5b7W6oARup9ZKMqFZyllD7UR8y14jBYfrwfdwHVhugfASXsizL
         FvEkxfcZO/fIhKEq4W7E1Z7n/3UfbkCwBOOUq4Mr/g1T6K1FIJCav5iyazbhdNMygM3P
         pTfiuUYaUseybHrAqK2ZgrA7OancUeAlELls2x/aLQb0iE0TQSifTsMuaH5OZgM97f1H
         nBiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730480979; x=1731085779;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=leKs4cy/2ceBeA0A+XYjBZ1WS0bFYV6vrc29reZpnsM=;
        b=mOffQ8YneEIvRziOO7aX1zknnh0KUtWhvbgeuioYTNvjv+IMDpCwL3usioPjAU4eVy
         K2YaGTFwxTzgHeja0ZwMQVQ2pBzReQBmBQqpdG0sfOqUwxUzus1R6Q5FhNcBgMXsP7UF
         Hltgj/YNnMjexKHjVg/3VG+JB4B3g/5+CkznKk3dtzziLzUaNbgOr2rEA7GsVTLf8Ps8
         R2yOywhvA77xPtmdIfzDyFtfmDOUJvHF5HCxOjbaMAx2agGJHt0ut/CN0PmgcM1F9jDT
         iNvrMU+fXXRnqcBaHU/CDmvAMZsMzSJuIj7e2BSvtA066YAY1GkDhQcfjdTtiJiFh19P
         fbJg==
X-Gm-Message-State: AOJu0YzfpjrsW74+cWdgJbNTKNneA7s82X18VWtPsbTa6iQnSsbWjV4E
	DAtM6qvggKc3kYjn5ZvIJ0QW70Jefn6J6D0aDTjqrKsfUSPMvDGYDp3Anp0ujOklegdLeEiu36S
	f/y2fDzyjrQtqvnIJ6249E9zmPwx/YK7IkpLz
X-Gm-Gg: ASbGncscJbIOogct8n1SiK1uJoTHnWW5XP1eHsyJUYSJ6u/CVZt1qULMQqECrayQDAV
	IA1AEfY3pLl5sDPC3cdL9r9sbmBZfuOM9R5st90EujThKFNY3OhjgcH/8sV8FmA==
X-Google-Smtp-Source: AGHT+IFJg2QoQo+HZXxYUlhvJJ4YYwGOZgmDliKv7KclE5csHykWupXpSX551XBsReEwY0xxjINcXOOo7bv53rlku+A=
X-Received: by 2002:a05:6512:3da3:b0:53c:75e8:a5c9 with SMTP id
 2adb3069b0e04-53c7ada1db3mr714381e87.4.1730480978386; Fri, 01 Nov 2024
 10:09:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241029230521.2385749-1-dw@davidwei.uk> <20241029230521.2385749-5-dw@davidwei.uk>
In-Reply-To: <20241029230521.2385749-5-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 1 Nov 2024 10:09:25 -0700
Message-ID: <CAHS8izPZ3bzmPx=geE0Nb0q8kG8fvzsGT2YgohoFJbSz2r21Zw@mail.gmail.com>
Subject: Re: [PATCH v7 04/15] net: prepare for non devmem TCP memory providers
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>, 
	Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>, 
	Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 29, 2024 at 4:06=E2=80=AFPM David Wei <dw@davidwei.uk> wrote:
>
> From: Pavel Begunkov <asml.silence@gmail.com>
>
> There is a good bunch of places in generic paths assuming that the only
> page pool memory provider is devmem TCP. As we want to reuse the net_iov
> and provider infrastructure, we need to patch it up and explicitly check
> the provider type when we branch into devmem TCP code.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  net/core/devmem.c         | 10 ++++++++--
>  net/core/devmem.h         |  8 ++++++++
>  net/core/page_pool_user.c | 15 +++++++++------
>  net/ipv4/tcp.c            |  6 ++++++
>  4 files changed, 31 insertions(+), 8 deletions(-)
>
> diff --git a/net/core/devmem.c b/net/core/devmem.c
> index 01738029e35c..78983a98e5dc 100644
> --- a/net/core/devmem.c
> +++ b/net/core/devmem.c
> @@ -28,6 +28,12 @@ static DEFINE_XARRAY_FLAGS(net_devmem_dmabuf_bindings,=
 XA_FLAGS_ALLOC1);
>
>  static const struct memory_provider_ops dmabuf_devmem_ops;
>
> +bool net_is_devmem_page_pool_ops(const struct memory_provider_ops *ops)
> +{
> +       return ops =3D=3D &dmabuf_devmem_ops;
> +}
> +EXPORT_SYMBOL_GPL(net_is_devmem_page_pool_ops);
> +
>  static void net_devmem_dmabuf_free_chunk_owner(struct gen_pool *genpool,
>                                                struct gen_pool_chunk *chu=
nk,
>                                                void *not_used)
> @@ -316,10 +322,10 @@ void dev_dmabuf_uninstall(struct net_device *dev)
>         unsigned int i;
>
>         for (i =3D 0; i < dev->real_num_rx_queues; i++) {
> -               binding =3D dev->_rx[i].mp_params.mp_priv;
> -               if (!binding)
> +               if (dev->_rx[i].mp_params.mp_ops !=3D &dmabuf_devmem_ops)
>                         continue;
>

Use the net_is_devmem_page_pool_ops helper here?

> +               binding =3D dev->_rx[i].mp_params.mp_priv;
>                 xa_for_each(&binding->bound_rxqs, xa_idx, rxq)
>                         if (rxq =3D=3D &dev->_rx[i]) {
>                                 xa_erase(&binding->bound_rxqs, xa_idx);
> diff --git a/net/core/devmem.h b/net/core/devmem.h
> index a2b9913e9a17..a3fdd66bb05b 100644
> --- a/net/core/devmem.h
> +++ b/net/core/devmem.h
> @@ -116,6 +116,8 @@ struct net_iov *
>  net_devmem_alloc_dmabuf(struct net_devmem_dmabuf_binding *binding);
>  void net_devmem_free_dmabuf(struct net_iov *ppiov);
>
> +bool net_is_devmem_page_pool_ops(const struct memory_provider_ops *ops);
> +
>  #else
>  struct net_devmem_dmabuf_binding;
>
> @@ -168,6 +170,12 @@ static inline u32 net_devmem_iov_binding_id(const st=
ruct net_iov *niov)
>  {
>         return 0;
>  }
> +
> +static inline bool
> +net_is_devmem_page_pool_ops(const struct memory_provider_ops *ops)
> +{
> +       return false;
> +}
>  #endif
>
>  #endif /* _NET_DEVMEM_H */
> diff --git a/net/core/page_pool_user.c b/net/core/page_pool_user.c
> index 48335766c1bf..604862a73535 100644
> --- a/net/core/page_pool_user.c
> +++ b/net/core/page_pool_user.c
> @@ -214,7 +214,7 @@ static int
>  page_pool_nl_fill(struct sk_buff *rsp, const struct page_pool *pool,
>                   const struct genl_info *info)
>  {
> -       struct net_devmem_dmabuf_binding *binding =3D pool->mp_priv;
> +       struct net_devmem_dmabuf_binding *binding;
>         size_t inflight, refsz;
>         void *hdr;
>
> @@ -244,8 +244,11 @@ page_pool_nl_fill(struct sk_buff *rsp, const struct =
page_pool *pool,
>                          pool->user.detach_time))
>                 goto err_cancel;
>
> -       if (binding && nla_put_u32(rsp, NETDEV_A_PAGE_POOL_DMABUF, bindin=
g->id))
> -               goto err_cancel;
> +       if (net_is_devmem_page_pool_ops(pool->mp_ops)) {
> +               binding =3D pool->mp_priv;
> +               if (nla_put_u32(rsp, NETDEV_A_PAGE_POOL_DMABUF, binding->=
id))
> +                       goto err_cancel;
> +       }

Worthy of note is that I think Jakub asked for this introspection, and
likely you should also add similar introspection. I.e. page_pool
dumping should likely be improved to dump that it's bound to io_uring
memory. Not sure what io_uring memory 'id' equivalent would be, if
any.

>
>         genlmsg_end(rsp, hdr);
>
> @@ -353,16 +356,16 @@ void page_pool_unlist(struct page_pool *pool)
>  int page_pool_check_memory_provider(struct net_device *dev,
>                                     struct netdev_rx_queue *rxq)
>  {
> -       struct net_devmem_dmabuf_binding *binding =3D rxq->mp_params.mp_p=
riv;
> +       void *mp_priv =3D rxq->mp_params.mp_priv;
>         struct page_pool *pool;
>         struct hlist_node *n;
>
> -       if (!binding)
> +       if (!mp_priv)
>                 return 0;
>
>         mutex_lock(&page_pools_lock);
>         hlist_for_each_entry_safe(pool, n, &dev->page_pools, user.list) {
> -               if (pool->mp_priv !=3D binding)
> +               if (pool->mp_priv !=3D mp_priv)
>                         continue;
>
>                 if (pool->slow.queue_idx =3D=3D get_netdev_rx_queue_index=
(rxq)) {
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index e928efc22f80..31e01da61c12 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -277,6 +277,7 @@
>  #include <net/ip.h>
>  #include <net/sock.h>
>  #include <net/rstreason.h>
> +#include <net/page_pool/types.h>
>
>  #include <linux/uaccess.h>
>  #include <asm/ioctls.h>
> @@ -2476,6 +2477,11 @@ static int tcp_recvmsg_dmabuf(struct sock *sk, con=
st struct sk_buff *skb,
>                         }
>
>                         niov =3D skb_frag_net_iov(frag);
> +                       if (net_is_devmem_page_pool_ops(niov->pp->mp_ops)=
) {
> +                               err =3D -ENODEV;
> +                               goto out;
> +                       }
> +

I think this check needs to go in the caller. Currently the caller
assumes that if !skb_frags_readable(), then the frag is dma-buf, and
calls tcp_recvmsg_dmabuf on it. The caller needs to check that the
frag is specifically a dma-buf frag now.

Can io_uring frags somehow end up in tcp_recvmsg_locked? You're still
using the tcp stack with io_uring ZC right? So I suspect they might?

--
Thanks,
Mina

