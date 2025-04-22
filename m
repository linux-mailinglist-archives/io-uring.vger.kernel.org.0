Return-Path: <io-uring+bounces-7634-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 448D9A973D5
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 19:43:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D05EB3B3568
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 17:43:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33E7B1DED47;
	Tue, 22 Apr 2025 17:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Z5MRyVtm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3633B1DA63D
	for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 17:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745343832; cv=none; b=KD6flL8ZPWH4+NAicsKtaUyji2JDdR8crYdYYYMPF6qnOQr/hzYmPut0l4I1j2X+AvPKTFDDOQmtNqj+DtVFuBRiJ1Z79anvNjCcDTboz8C4BmZNQic+OAn4ERM1b4mdjUrpo1NoWq18A4V0noTc8mb1ojkCXhC6KOh7Yi4Rb5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745343832; c=relaxed/simple;
	bh=zcVb6Cfxy75Ob1kNh4bYs664zPYBcfFrxG08qGEETk4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=saTHYuNOb9fvANLO2c2g7pRJcHaD4nHfuUfS5B5SFOD6ZWKWVr3YUB1WOYnTCGmRhqb+QaZX7F3VV2Z23irIHPjy6djtkR2/afLPV+AbkwOi+JNHe5OQloVV/qLNkKrEESuNOoknTHeb4IxWVXZjR+r7w4k70xvkoZ0PQsJIP9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Z5MRyVtm; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2264c9d0295so22055ad.0
        for <io-uring@vger.kernel.org>; Tue, 22 Apr 2025 10:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745343829; x=1745948629; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0nQBVslpgDVVhWwmvHoRlwAkP6zwHezc78dd9O+zlzs=;
        b=Z5MRyVtmSJelRcKJ/A0VjB5ggn4Owq7/VIWqWFmreFFhO6SVN9Bh382JLue/LLmSR3
         q59KyHXAxCh3SKWUIGcQfaZFpVm1vGgDUqi03+19CQ+CzzU2uMr3D7mA/yu6HqTTI0To
         ASIyWuCX79VGbHhV/t0tlswUyJfs6gxYR3t3zExOg+ZK3c9vZHKmpFKlNj0BxdVAp9eZ
         uTZvHDBfMur2sqAmdANBq7Q4AtRWVwvXSSDmmjOzev/4Tm2+Qi7m0bKMXrXWg0n/LnJI
         1GcweZihXZtL6+Zy/mteHZx9jZvPBxUrF9/BI/IbnRiX3IB+Eej6QBZmoUUtboCTIMJo
         TOnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745343829; x=1745948629;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0nQBVslpgDVVhWwmvHoRlwAkP6zwHezc78dd9O+zlzs=;
        b=mhx+klCTslE2SkhBbQ6DLs3xi3hbpOjnAMGZmGARpJSUOiZigT+8tw7v6teiUdkRiQ
         uGElX/8xfwEWaEGCA/yv0MVJ63BLKtkiEdcYUOli3PFG7GvQZMIgSps1gGGyikuelRxD
         ryUzK4WMXQy4vhU7f6tC6OzsijpS2eCXDg3DyJrA+7jXj4ydyYhRbZpId1bEOEJoovAB
         YVar/H/6zB5966+3Yo579GvRzsZ8qAG/URtfT2sEp2CvYSZFFe/xyD/lsb9idEqjkqOt
         F5oY3KLo1jnf8yibRpe9yeXHnZpWh0e+PHkUuJgS3Y0Kns1GEHH3Af6D1UFPED0cYHme
         Og/A==
X-Forwarded-Encrypted: i=1; AJvYcCXRubGUYX3ORIfckU9A9Z6PA7DtLu1KhdG+oVM3r57KzivjSUHLRyIwdkF/DESLxdNrkDUjnjpLOQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzT/BqSxMSbkol1o8awwds8QXKd8Zqq6nc3x5rN2rtQGXr+pQL3
	XUkeN0lUdYRKRzDF4G1+rhzd8Mhs1LDHkSH1/b1KI17izy1dbILdCBScPN/kspGqqqqXii2TRhu
	HNQNn/1t2AAK/Xb6cyVsqWeIQX315GRH5hGQr
X-Gm-Gg: ASbGncvt6ZTlWMSPSWP8pt38L1kCSCtp77deAZYCmgtiZvc3r9KLwy/OtKJstGbj+OM
	GmK3LhIH3eyoSju4AQI9y+NUAjm8lr57aVBtc0ubqawLT46vVgRyNMFAoVHOe0zJsU4UvcZRuFX
	yG6xxVLmqDJbNZGXJ7igePc6RDofaWrSYQdQejewqpjwpdd9B5omav
X-Google-Smtp-Source: AGHT+IGSKGIgLM9bohGpvqQzDuyOGN9Dox9hCzuEhi9yioRJmO0B7Hjp5oQ00AwnuEeP5W6trjfsTXRGJyVju6gMOtY=
X-Received: by 2002:a17:903:1a4d:b0:215:42a3:e844 with SMTP id
 d9443c01a7336-22c54562829mr9132085ad.17.1745343829160; Tue, 22 Apr 2025
 10:43:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250417231540.2780723-1-almasrymina@google.com> <20250417231540.2780723-8-almasrymina@google.com>
In-Reply-To: <20250417231540.2780723-8-almasrymina@google.com>
From: Harshitha Ramamurthy <hramamurthy@google.com>
Date: Tue, 22 Apr 2025 10:43:38 -0700
X-Gm-Features: ATxdqUEoZbftW3pP1LK4aYTjtkb7qLFfr67voRhIGom_RJK1JmrrX3YpsAjUeYk
Message-ID: <CAEAWyHckGSYEMDqVDT0u7pFCpO9fmXpEDb7-YV87pu+R+ytxOw@mail.gmail.com>
Subject: Re: [PATCH net-next v9 7/9] gve: add netmem TX support to GVE DQO-RDA mode
To: Mina Almasry <almasrymina@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Donald Hunter <donald.hunter@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, 
	Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	sdf@fomichev.me, dw@davidwei.uk, Jamal Hadi Salim <jhs@mojatatu.com>, 
	Victor Nogueira <victor@mojatatu.com>, Pedro Tammela <pctammela@mojatatu.com>, 
	Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 17, 2025 at 4:15=E2=80=AFPM Mina Almasry <almasrymina@google.co=
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
> v4:
> - New patch
> ---
>  drivers/net/ethernet/google/gve/gve_main.c   | 4 ++++
>  drivers/net/ethernet/google/gve/gve_tx_dqo.c | 8 +++++---
>  2 files changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/eth=
ernet/google/gve/gve_main.c
> index 8aaac9101377..430314225d4d 100644
> --- a/drivers/net/ethernet/google/gve/gve_main.c
> +++ b/drivers/net/ethernet/google/gve/gve_main.c
> @@ -2665,6 +2665,10 @@ static int gve_probe(struct pci_dev *pdev, const s=
truct pci_device_id *ent)
>
>         dev_info(&pdev->dev, "GVE version %s\n", gve_version_str);
>         dev_info(&pdev->dev, "GVE queue format %d\n", (int)priv->queue_fo=
rmat);
> +
> +       if (!gve_is_gqi(priv) && !gve_is_qpl(priv))
> +               dev->netmem_tx =3D true;
> +

a nit: but it would fit in better and be more uniform if this is set
earlier in the function where other features are set for the
net_device.

>         gve_clear_probe_in_progress(priv);
>         queue_work(priv->gve_wq, &priv->service_task);
>         return 0;
> diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/e=
thernet/google/gve/gve_tx_dqo.c
> index 2eba868d8037..a27f1574a733 100644
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

