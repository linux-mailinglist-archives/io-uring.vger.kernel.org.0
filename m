Return-Path: <io-uring+bounces-4333-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E1A69B994A
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 21:17:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9C17BB2131F
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 20:17:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19DA6168DA;
	Fri,  1 Nov 2024 20:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="G+eqrW5s"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D7DB1D968D
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 20:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730492214; cv=none; b=gkajlo7T14HS3051+CGgTu01X/HcTDCAUZsUSeZ0Vuik7BJzjqR/byMvKZMjL7EUeoN51W63XHNiT80tU2ziKvKFxvv2GgO+aNyYS4zzywt8aXnP9johcmUbwZk7UJ0Kfhtrv0AGZnIPikceTyXV8GLXybet17iBjzGM8lkP5j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730492214; c=relaxed/simple;
	bh=Neq2taM8S5zc3+C2OTWpu8fNI6E1Ypyk9B14+qIRqyo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=INoNJqyK0+cLRqnqFg/oz2l88IlMHhrPIvMfUdkvDPe5rS8dzx0LYvc66QfNZEcIXYvOwZy3cLWmZd3jc+9JeB8rsduzbIROYaIjUicZI5o0o9jsEQTqAICrWIinAaqFamrQKYmX0/n9GzhnL6+HdSkXHyI7iHobk81s4avC+Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=G+eqrW5s; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-460b295b9eeso11861cf.1
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 13:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730492211; x=1731097011; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m0pmXdKRRehOTDxxZcS9Rlf0z5oyVOgg9mgnJxfzU+4=;
        b=G+eqrW5s8586h2weWLiXdnwb3dkkfqyEejh9G/JQDjpfDjh3fQ54vmQbrVTwwtMkPg
         FlLO7qlahLANtJmy4U+uSZeYlgzEHHmwxNzg/0+GGt8iKuNDRGvqBvKf9mQAVwO0j+0o
         P70AOqClXEbXtsEP2WmIbnFPoQLla6hx6dB5mRRTrkRpkfYlc9zN1wDEvGeP0V+al/Eq
         p2nGgyIaULRRdmT5O5Sm7P4/aF4PWCyybQ1etfOEp3I4AXVqaQXAVWBpEA+uuDw+qhxG
         W0DcX4L9YT2446ZTjG54sM4O70H9IO9TyApjv8N19bYZS6xxWvpu4BCB6z6vnOOMVDd0
         5ucQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730492211; x=1731097011;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m0pmXdKRRehOTDxxZcS9Rlf0z5oyVOgg9mgnJxfzU+4=;
        b=RnIjmmIL57WpnWwijT91cQZMWBpbWWyxzKYfj0xpt+X6q+fvoACpyC0ujTxbo7dvoj
         Odjf5SXCem+bamQlRc9xazi8PGM4rJLMAYILZ2MM1eF5x1TLtVqBKbPnC8nXtz02fJpB
         FWnwrgVbp8WZIvBAmyUGm7cykD++bLvJH4xQZ+KztqQo/i+LvY8q4ke4G/F5bVsiRxHD
         2Pi6GPvY38G9EfW1hZliFS2SrtgezC6SfLJ231/7LflI0+/muOreHP4Bjep05A2/bWX7
         9PGePc+Qmgfrx4ietSkiWXrbUpyMzSLP6RasrEl7Oopfvc0mJq25fSVSXuaA9ApMKzna
         3NMw==
X-Gm-Message-State: AOJu0YwVENUiCpPML8Jm9vYZJB2bgLh/EXT3jXbKgRZAjHDBYBqtTgEq
	3PUSfweNRCpLqQEedA3u394wYjCQcr3dtmLsu7Ju4qIa3ga8YC1s1iHpHZtbgEnevyvY+FiBjaw
	TXplOc2rqzg00I29PSoZSDzk89Vdb1ypKmxZ7
X-Gm-Gg: ASbGncvMf2UAJ48Tdl2xEMQghcaus5qnP31a8E+cmOYNs035sk38x3w5er5Z5oE810b
	Rhkf5yyJUn1C9wwO5EpdAczU1mwkeHXQiZD3LjuIEq/tBAL1bQZ7m/VnAkAL2rw==
X-Google-Smtp-Source: AGHT+IGQlnMovoi5lGZ5r+xc2iOTrOWS9RcVERrIUE0qklnzO30h74p7/gLLkEvfHRWyOdgZxsJcaMWekAkfadGD3mI=
X-Received: by 2002:a05:622a:4e9b:b0:45f:89c:e55 with SMTP id
 d75a77b69052e-462c5ed23c0mr637391cf.8.1730492211131; Fri, 01 Nov 2024
 13:16:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241029230521.2385749-1-dw@davidwei.uk> <20241029230521.2385749-14-dw@davidwei.uk>
In-Reply-To: <20241029230521.2385749-14-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 1 Nov 2024 13:16:39 -0700
Message-ID: <CAHS8izMFV=1oRR6Tq-BVJxCL3hbEjNa0CBzWmWxbnk_0MZOs6w@mail.gmail.com>
Subject: Re: [PATCH v7 13/15] io_uring/zcrx: set pp memory provider for an rx queue
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
> From: David Wei <davidhwei@meta.com>
>
> Set the page pool memory provider for the rx queue configured for zero
> copy to io_uring. Then the rx queue is reset using
> netdev_rx_queue_restart() and netdev core + page pool will take care of
> filling the rx queue from the io_uring zero copy memory provider.
>
> For now, there is only one ifq so its destruction happens implicitly
> during io_uring cleanup.
>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  io_uring/zcrx.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++--
>  io_uring/zcrx.h |  2 ++
>  2 files changed, 86 insertions(+), 2 deletions(-)
>
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index 477b0d1b7b91..3f4625730dbd 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -8,6 +8,7 @@
>  #include <net/page_pool/helpers.h>
>  #include <net/page_pool/memory_provider.h>
>  #include <trace/events/page_pool.h>
> +#include <net/netdev_rx_queue.h>
>  #include <net/tcp.h>
>  #include <net/rps.h>
>
> @@ -36,6 +37,65 @@ static inline struct io_zcrx_area *io_zcrx_iov_to_area=
(const struct net_iov *nio
>         return container_of(owner, struct io_zcrx_area, nia);
>  }
>
> +static int io_open_zc_rxq(struct io_zcrx_ifq *ifq, unsigned ifq_idx)
> +{
> +       struct netdev_rx_queue *rxq;
> +       struct net_device *dev =3D ifq->dev;
> +       int ret;
> +
> +       ASSERT_RTNL();
> +
> +       if (ifq_idx >=3D dev->num_rx_queues)
> +               return -EINVAL;
> +       ifq_idx =3D array_index_nospec(ifq_idx, dev->num_rx_queues);
> +
> +       rxq =3D __netif_get_rx_queue(ifq->dev, ifq_idx);
> +       if (rxq->mp_params.mp_priv)
> +               return -EEXIST;
> +
> +       ifq->if_rxq =3D ifq_idx;
> +       rxq->mp_params.mp_ops =3D &io_uring_pp_zc_ops;
> +       rxq->mp_params.mp_priv =3D ifq;
> +       ret =3D netdev_rx_queue_restart(ifq->dev, ifq->if_rxq);
> +       if (ret)
> +               goto fail;
> +       return 0;
> +fail:
> +       rxq->mp_params.mp_ops =3D NULL;
> +       rxq->mp_params.mp_priv =3D NULL;
> +       ifq->if_rxq =3D -1;
> +       return ret;
> +}
> +

I don't see a CAP_NET_ADMIN check. Likely I missed it. Is that done
somewhere? Binding user memory to an rx queue needs to be a privileged
operation.

--=20
Thanks,
Mina

