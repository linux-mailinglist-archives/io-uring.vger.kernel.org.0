Return-Path: <io-uring+bounces-5690-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AFF3A0323D
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 22:44:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 805B73A1D8D
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 21:44:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52C741E04A0;
	Mon,  6 Jan 2025 21:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ntaNzjBM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5D2188A0D
	for <io-uring@vger.kernel.org>; Mon,  6 Jan 2025 21:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736199885; cv=none; b=uP6IT1yPQIJ60GAuV0otpN0AJOx8ymFSh5ybINq++ey7UxCwW9u2OWx7R5KK2sTCO7idDXXOwzVTqZ7D94noXvMN6l2vyMzau99fQZxgXszLD2G7zfk0SsjCUDeF2dJ+BcorTS3yu56BXC3oI/e9of/qwiw5AqxG9wxKB5g3qA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736199885; c=relaxed/simple;
	bh=HzDC/c0XNGpvaJvHCpg6iyEOCu6qco8XSvU0e16V/Tc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HmM0aZHLQ9f36wf9U7KIFL4AT8VgDoNPaqyycCsHB0e/+SKRjd7lLrJA9VQa3erJKOftn+UC1v1WzGLSTqhCHQzsoeqT57aKUe/2bca55U1O0fLwf3JvOd1RtCLlh5hLnHszlitdU2m5nlBsjJGlAj0RvDE1a0U9KGwHef4w7rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ntaNzjBM; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-467896541e1so70831cf.0
        for <io-uring@vger.kernel.org>; Mon, 06 Jan 2025 13:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736199882; x=1736804682; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/dOtmPNuJzUtI3kd2Txc5na+EAf1+u+ytRBIdK3IQI4=;
        b=ntaNzjBMGQf5u2ST5rWk8xX6dvtyBGBVX3wUjJuIUV1KCbnbJjFO2vPPyusqXDSD4h
         bFo0zJjuQ1NyIFtYTTfQQiZzbfk+3JrqmkqPHiyJOu2A8Bl3SO3P2g01vBSzB/Ery4mR
         Ep5RERlqAXBck5pB88d6Xx+ER/jvn1oRhk+XD1gXIs3ckL+nB80G+w9L+sXtkeF6G6Ci
         GbAHWcRAsAqJGojbBVK5eH6DCQMod0Wmi7oE8PFku8NRVpFmV9S6PR+87fMkg7nYBebl
         LqNECAQzTr28XfhckpciOuFqoxdqCU8nbyX6jYFXcYDZuYEh4GD6j6lJQVG/1czpJJ39
         Jo3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736199882; x=1736804682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/dOtmPNuJzUtI3kd2Txc5na+EAf1+u+ytRBIdK3IQI4=;
        b=gPxfsnHtQTzt7OD0LGO09hwskdZsfrw5y6z+9lQpIPdVKEg9QrPWVx9hOcxlnU3kFS
         1MrQbZ6cZ03w32mKvDoJ9HECsG2PTspTK5Hbffc2qBrVU1yGoaeyLWEkTUYDk1hmXqOy
         0a0izZQUK7LG17z8qH/1FBQbIawysmFI6uf7CgluLTU0nZ4DQUgCVhLAxiM8yxAiJlgR
         xvtdBjgFVoMdFP1ThUPGHXXO3pb01MCwej/IwTy+F6JhoEvyT8EdanwK7ILQC9fzm2y/
         l+r27VXWcUTozf0iEcCZj+tFOLHPBAfH88w4MAEcOQLiHskCEzUFuUpAfTcPZGdd7kJr
         CIFg==
X-Gm-Message-State: AOJu0YzXirCWKk8CgmdJnKKrMTIf5StcsbWf1vI+pVb861kXzcQkP5Cw
	f4lmol3MmAON/xl3auDff1IJ7UTvpRHELVoj48iHmdOZgR6VTZx66lgrE/8KmHlc0+De1eSKtUc
	gtxo40M2zOhWDLiBFHCV3FCK+f0aKXax/aDED
X-Gm-Gg: ASbGncsriR8DCVofnfhE92m+e6XPHzYLz2YPZZCeU6zmTs2UGvqI3z0OGnFAll+Bh5u
	b8GzlzG4l3+59P/e58QqxK2c8wkgeIIf2zxIookZv+xmj9bRVR2HWopkIkMMUEY0D7VHN
X-Google-Smtp-Source: AGHT+IFxL2nDtrWGu0U93A9+oEnN2ZpoNwWJyGuKPHkCrMt1wfC1u903xT9MRhfeN0keV/679aj4W0LqGymY2lbWeiY=
X-Received: by 2002:a05:622a:c:b0:460:463d:78dd with SMTP id
 d75a77b69052e-46b3b759509mr899301cf.4.1736199882295; Mon, 06 Jan 2025
 13:44:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241218003748.796939-1-dw@davidwei.uk> <20241218003748.796939-7-dw@davidwei.uk>
In-Reply-To: <20241218003748.796939-7-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 6 Jan 2025 13:44:30 -0800
Message-ID: <CAHS8izOg0V5kGq8gsGLC=6t+1VWfk1we_R9gecC+WbOJAdeXgw@mail.gmail.com>
Subject: Re: [PATCH net-next v9 06/20] net: page_pool: add a mp hook to unregister_netdevice*
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

On Tue, Dec 17, 2024 at 4:38=E2=80=AFPM David Wei <dw@davidwei.uk> wrote:
>
> From: Pavel Begunkov <asml.silence@gmail.com>
>
> Devmem TCP needs a hook in unregister_netdevice_many_notify() to upkeep
> the set tracking queues it's bound to, i.e. ->bound_rxqs. Instead of
> devmem sticking directly out of the genetic path, add a mp function.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  include/net/page_pool/types.h |  3 +++
>  net/core/dev.c                | 15 ++++++++++++++-
>  net/core/devmem.c             | 36 ++++++++++++++++-------------------
>  net/core/devmem.h             |  5 -----
>  4 files changed, 33 insertions(+), 26 deletions(-)
>
> diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.=
h
> index a473ea0c48c4..140fec6857c6 100644
> --- a/include/net/page_pool/types.h
> +++ b/include/net/page_pool/types.h
> @@ -152,12 +152,15 @@ struct page_pool_stats {
>   */
>  #define PAGE_POOL_FRAG_GROUP_ALIGN     (4 * sizeof(long))
>
> +struct netdev_rx_queue;
> +
>  struct memory_provider_ops {
>         netmem_ref (*alloc_netmems)(struct page_pool *pool, gfp_t gfp);
>         bool (*release_netmem)(struct page_pool *pool, netmem_ref netmem)=
;
>         int (*init)(struct page_pool *pool);
>         void (*destroy)(struct page_pool *pool);
>         int (*nl_report)(const struct page_pool *pool, struct sk_buff *rs=
p);
> +       void (*uninstall)(void *mp_priv, struct netdev_rx_queue *rxq);

nit: the other params take struct page_pool *pool as input, and find
the mp_priv in there if they need, it may be nice for consistency to
continue to pass the entire pool to these ops.

AFAIU this is the first added non-mandatory op, right? Please specify
it as so, maybe something like:

/* optional: called when the memory provider is uninstalled from the
netdev_rx_queue due to the interface going down or otherwise. The
memory provider may perform whatever cleanup necessary here if it
needs to. */

>  };
>
>  struct pp_memory_provider_params {
> diff --git a/net/core/dev.c b/net/core/dev.c
> index c7f3dea3e0eb..aa082770ab1c 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -11464,6 +11464,19 @@ void unregister_netdevice_queue(struct net_devic=
e *dev, struct list_head *head)
>  }
>  EXPORT_SYMBOL(unregister_netdevice_queue);
>
> +static void dev_memory_provider_uninstall(struct net_device *dev)
> +{
> +       unsigned int i;
> +
> +       for (i =3D 0; i < dev->real_num_rx_queues; i++) {
> +               struct netdev_rx_queue *rxq =3D &dev->_rx[i];
> +               struct pp_memory_provider_params *p =3D &rxq->mp_params;
> +
> +               if (p->mp_ops && p->mp_ops->uninstall)

Previous versions of the code checked p->mp_priv to check if the queue
is mp enabled or not, I guess you check mp_ops and that is set/cleared
along with p->mp_priv. I guess that is fine. It would have been nicer,
maybe, to have all the mp stuff behind one pointer/struct. I would
dread some code path setting one of mp_[ops|priv] but forgetting to
set the other... :shrug:

Anyhow:

Reviewed-by: Mina Almasry <almasrymina@google.com>

--=20
Thanks,
Mina

