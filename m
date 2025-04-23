Return-Path: <io-uring+bounces-7680-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0374DA997DB
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 20:26:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C87CD1B806D8
	for <lists+io-uring@lfdr.de>; Wed, 23 Apr 2025 18:26:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DD5028E601;
	Wed, 23 Apr 2025 18:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2gq+VKrr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE20C28CF6D
	for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 18:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745432788; cv=none; b=q6rmBrQ0NeJRvo9cvg4gb1FoW1Zw//K6qnw9EwBmfl5ssBDHEf9c31x0prDGQ1iG45/3tD/siZ+VTQAiAWG1Mx3m830ZwBfkW43QWobxA+KZ1MgmN5CbegJFPAUHuQ6xLIemKh6jTSOOtlSL1ChQ3+XgVfvEl/JdplHd6F6ffX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745432788; c=relaxed/simple;
	bh=PH84kld/sKE+RhISrTjG1cjFnL0yLAXB9xK4PwFZaMY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KeahUSapy1w+NXH4usTlsQKi/f/vyz6a6dsing7Xd3JD6OO5w9YVCy7zwsgj3zKDLzgxTjmvvDmcU/d6R0gWYddAqLkCsTcA5D6OL5CeZeFKhCj/Df3W3YmGOBKFtz307/KZNdCpWSHrCBzI73KSFyFzwuo9t0hyFabp3ZRUkOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2gq+VKrr; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2263428c8baso21195ad.1
        for <io-uring@vger.kernel.org>; Wed, 23 Apr 2025 11:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745432786; x=1746037586; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l0kIM1GyroCk3zmwGLYPwDaNY7xBbvOnwGmlKqF+IzQ=;
        b=2gq+VKrrvYaucHZKTwwnsDTcguRUJEnVD9Vc+V+V+MMaMRFvued3L8zrmZcBRrQhmM
         3AQIXkghMRWBlDpmF3Y442RrEa/yOvEGpOXH7jvF2ImyjOhm7ldwlQpVsBBVnrbMBR32
         oxkxBsygVehWGacZv3UxJmwvCv8bQOs6VYYwjIT31stc15bCYMBoYmLXxFC4CJxX6ijX
         un5EOHJeYtHksDBCZLviXLlVLbxF+jjTZIB70cLEkBjcWWDUtXCQHSne9rRrpLVlVfXm
         TvbupkYn09GYXohrSzKoO8ejUQwj+0XW+4JQzbpUFtXTG2WA2y4toln7Vk5BwsR+pHxz
         m5TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745432786; x=1746037586;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l0kIM1GyroCk3zmwGLYPwDaNY7xBbvOnwGmlKqF+IzQ=;
        b=RCnJXLH9XuwrV/cOzlcSW3ToR2M5UHjuN8ePUZYn5/bhsl5h1Fm2msn3WDVYEBl1AR
         BXqjQPH3WvAukYTmpSJfxD9LARlvRTiAw5krqlqbEnVnDORLu/GDL37L0YUTQsli7MHh
         gmYahycL9+H2BYbP159VtlA+YFMDg7hwUqcdc/9XC5EmgR3f5LTh7v2ufptT1jQLWkdr
         MLWq2dJF1SwXswSwThcjcmSr+Q0cWJ3jED2ifu372CxIAPxxcas/a+XN2RfIEbshF5XD
         CJMWNN5H1/k13gksxptovdHOY2PuaCoQNJsoI8ssExOdxedbAJpWcCsZBeq6s13KqRUc
         MQFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQwh7ID+qc7bimn1YHjenbykQL8r0h2m21iSJCfShynpvIBRel5FUQEo1GNt9iJ0iIM+mQ2C3tkw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk0rJku4sJd5/M7UPChRLrgn7t8mZTBkka33S1DSFXu4PyC1VI
	Gro6KpxsvnHbyfOxmgpA5MOvbVcq/EvClgHz7xVH4VyGrf4D5b/bLU087bx+R5BjohVBgzpw6zm
	4ZGBoGMoVKpTv1KUbhpM4MDCJ4a3Zhy7P1ubn
X-Gm-Gg: ASbGncsxJofUwkYPe4DJurDNGvCtUo1pbDPAwWFaKHjq0Ps3ypiTwK+Wsf1IoRr+3Vy
	E8njBEKoSrbqFiOPOLXrPxHXSSGw3Kh0TiJD0Tep7souBdfB7UnzJZM03NO4Dy67hOLTecLSm7J
	mYhF6wsqVxq53GuZSRcdaivxHlCBsTueNVsD7BVux55ruHtXk2eE3fOLE=
X-Google-Smtp-Source: AGHT+IFz1R1LxqWEGYRLYWO5W96XWnv2bqJz15jEINPSBmb87YsKZWzWOfr6fveduQ8KQij52ltnpYxHcWerkniTavs=
X-Received: by 2002:a17:903:3bce:b0:215:8232:5596 with SMTP id
 d9443c01a7336-22db218a627mr293845ad.16.1745432785574; Wed, 23 Apr 2025
 11:26:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250423031117.907681-1-almasrymina@google.com> <20250423031117.907681-8-almasrymina@google.com>
In-Reply-To: <20250423031117.907681-8-almasrymina@google.com>
From: Harshitha Ramamurthy <hramamurthy@google.com>
Date: Wed, 23 Apr 2025 11:26:14 -0700
X-Gm-Features: ATxdqUHnKDzCBYG80n4IAQ6Tqlf6P8u3mDu-47naFBmrHiwPtX2MRzVq-LrB7oQ
Message-ID: <CAEAWyHdYEzHLbW1Z=nS1yGdnbFA2HU7wb4nFZ1TmqGaUZoq9Tg@mail.gmail.com>
Subject: Re: [PATCH net-next v10 7/9] gve: add netmem TX support to GVE
 DQO-RDA mode
To: Mina Almasry <almasrymina@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Donald Hunter <donald.hunter@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, 
	Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, sdf@fomichev.me, dw@davidwei.uk, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Victor Nogueira <victor@mojatatu.com>, 
	Pedro Tammela <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2025 at 8:11=E2=80=AFPM Mina Almasry <almasrymina@google.co=
m> wrote:
>
> Use netmem_dma_*() helpers in gve_tx_dqo.c DQO-RDA paths to
> enable netmem TX support in that mode.
>
> Declare support for netmem TX in GVE DQO-RDA mode.
>
> Signed-off-by: Mina Almasry <almasrymina@google.com>
>
> ---
>
> v10:
> - Move setting dev->netmem_tx to right after priv is initialized
>   (Harshitha)
>
> v4:
> - New patch
> ---
>  drivers/net/ethernet/google/gve/gve_main.c   | 4 ++++
>  drivers/net/ethernet/google/gve/gve_tx_dqo.c | 8 +++++---
>  2 files changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/eth=
ernet/google/gve/gve_main.c
> index 8aaac91013777..b49c74620799e 100644
> --- a/drivers/net/ethernet/google/gve/gve_main.c
> +++ b/drivers/net/ethernet/google/gve/gve_main.c
> @@ -2659,12 +2659,16 @@ static int gve_probe(struct pci_dev *pdev, const =
struct pci_device_id *ent)
>         if (err)
>                 goto abort_with_wq;
>
> +       if (!gve_is_gqi(priv) && !gve_is_qpl(priv))
> +               dev->netmem_tx =3D true;
> +
>         err =3D register_netdev(dev);
>         if (err)
>                 goto abort_with_gve_init;
>
>         dev_info(&pdev->dev, "GVE version %s\n", gve_version_str);
>         dev_info(&pdev->dev, "GVE queue format %d\n", (int)priv->queue_fo=
rmat);
> +
nit: accidental extra empty line, but

Acked-by: Harshitha Ramamurthy <hramamurthy@google.com>

>         gve_clear_probe_in_progress(priv);
>         queue_work(priv->gve_wq, &priv->service_task);
>         return 0;
> diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/e=
thernet/google/gve/gve_tx_dqo.c
> index 2eba868d80370..a27f1574a7337 100644
> --- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
> +++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
> @@ -660,7 +660,8 @@ static int gve_tx_add_skb_no_copy_dqo(struct gve_tx_r=
ing *tx,
>                         goto err;
>
>                 dma_unmap_len_set(pkt, len[pkt->num_bufs], len);
> -               dma_unmap_addr_set(pkt, dma[pkt->num_bufs], addr);
> +               netmem_dma_unmap_addr_set(skb_frag_netmem(frag), pkt,
> +                                         dma[pkt->num_bufs], addr);
>                 ++pkt->num_bufs;
>
>                 gve_tx_fill_pkt_desc_dqo(tx, desc_idx, skb, len, addr,
> @@ -1038,8 +1039,9 @@ static void gve_unmap_packet(struct device *dev,
>         dma_unmap_single(dev, dma_unmap_addr(pkt, dma[0]),
>                          dma_unmap_len(pkt, len[0]), DMA_TO_DEVICE);
>         for (i =3D 1; i < pkt->num_bufs; i++) {
> -               dma_unmap_page(dev, dma_unmap_addr(pkt, dma[i]),
> -                              dma_unmap_len(pkt, len[i]), DMA_TO_DEVICE)=
;
> +               netmem_dma_unmap_page_attrs(dev, dma_unmap_addr(pkt, dma[=
i]),
> +                                           dma_unmap_len(pkt, len[i]),
> +                                           DMA_TO_DEVICE, 0);
>         }
>         pkt->num_bufs =3D 0;
>  }
> --
> 2.49.0.805.g082f7c87e0-goog
>

