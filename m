Return-Path: <io-uring+bounces-8633-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2899DAFF1D9
	for <lists+io-uring@lfdr.de>; Wed,  9 Jul 2025 21:29:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 181464E470E
	for <lists+io-uring@lfdr.de>; Wed,  9 Jul 2025 19:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92765241131;
	Wed,  9 Jul 2025 19:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bdG5ROmx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AFA241664
	for <io-uring@vger.kernel.org>; Wed,  9 Jul 2025 19:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752089377; cv=none; b=Y7l/OBnFw5tJM5purs5neT42hM4RxzqruDkzwf3uXo9njbewHfTEOmexJ/iv/qVYRrsFJi14GJFQ1DRjqG9E4opmtAppyl/n7oOmBnBPX0ct0xu68k0WOlrAtgSu+oD5ms99hfwPDU6ZaxGIIZ5k0G3zwGTCs8HvaVvrNVX1Dds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752089377; c=relaxed/simple;
	bh=WvlEgU12AHqrPXUPdrsBsIxwXfKkI7IhlDmareXNoOw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mGozs3Iw4nsAsSvJdzDjiWYaLfIwmV5EP+rfcPQYcRwgOORi81372aVCdIqRVLji8JFKHBsaozKA7u13GqK+8jjYYdtA4YqXv3vxyTNbQnRujoodteSxhPirZdKZxCrwVq3P6N9TKMEqz18iGm1FPqvXGXn9YRpTf/MxINK+fog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bdG5ROmx; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-23dd9ae5aacso2235ad.1
        for <io-uring@vger.kernel.org>; Wed, 09 Jul 2025 12:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752089375; x=1752694175; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ThbUPqHcHxCCAk0NfL8Mhvy/M6hXNg8NYsFZLUuUqM8=;
        b=bdG5ROmxHmJQuBAi56bVkOCDC/SIEa2KgP0yQK6d5IvKVYXkrZvsjQdcCiiVRPWFkH
         A+26fs+zxXWf8GXFYug9VxNtECohiH4mxZblCtns1LgatPofGfboc04q5DIEFNGHYRng
         +kwo5FnD14OiUxlm7Xe6LTMMsf9xk9Muu7TPQd8xdHjjZDeRqdvvPV8WhnfgfTUsqYDU
         sVuFcSym2AET6tIvuqamkf58vNyXkVMzq6ejKZH3I9N4iS1lxvUPx16ylxzXRYB0nTZ+
         bvDkZHpQ7GWa/O0StwPZ+LNwth9INqeqkjiXRobZiL3Mk4E8phD7fY2Zu0QxRDHSu7v5
         UuQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752089375; x=1752694175;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ThbUPqHcHxCCAk0NfL8Mhvy/M6hXNg8NYsFZLUuUqM8=;
        b=qx8BGWae+rooyKaCzxcv40eqTpfCbmKAqxD9lQQdvmSZb/+MbIxO/6U1m17jiyr63T
         NrQwYUE71X/7X63Pq6xufl3XHgrLdDHs0N5/ViSE0LJCW0iRYzbtMvP3eYhPOcG+Pozr
         SMTn+ScRm0kIUTP9gFkpV9r+vjmC3H+fAmMcMtioZUQJ54UKhLVHvCIDpoKttjZRYNnA
         zTKFbP2Yk0DUMaZQI+aGHVPK9vXUdLAyf0vipkn2VvwBbElr8mcGpidAGMGJq5GggK6w
         Ra6Km4gHwDvUcKyZj2ZGSgxJXW0TdQjL7l/EtxoXmBcXmGUwU16IqDl1CGLXOrMhFH/A
         L4uQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQhFnSRDjZNfO1J6lTkukKw2u3O4Yv9UBAtBr6s8oDw+QUgCZtRq7C/80JiMEreSUeOzgmwBPzsw==@vger.kernel.org
X-Gm-Message-State: AOJu0YySnOtKnTtkKTveTHtzyYg3IdJjdM4HTLapN9skwKPwFxxBqNrD
	th9ZGsh8hGlV83SB5zXXf9hg8cOKejygH+3Sh5VErbkjclq2PeLaRNafpR157/TQh96MtIVbBjc
	KUcGaLuWcTLrz7wAL5QtES5DC7Fh4vHD9/1dnLJoi
X-Gm-Gg: ASbGncsq/XQEvKYQPme80opEFt8LJzp65Taez6AgNrAI0X7SEmNt4k9O1ZnYBFAFuq9
	+c0nsjj/mJiRlYvqqVji4AwElOBxIKHQWvDFaVr+mewVe2Drho6taFYgWM6yVeweKG/tqD9mUvm
	/UYdj5exwiZ+agGHnHe6gAh1qkIZUmVrSWtikthBLLIhwUBJL9WkvLjyaBsaw0NZjZ43k7IbqVG
	Q==
X-Google-Smtp-Source: AGHT+IFmGcieOsYc/49aPgN2RayxnQTzWH9dSjShYHF+MmJAGzB+cGQ4KLtM7r/G1atzMJ34MlkKuN6/eZhVHrr4DpM=
X-Received: by 2002:a17:902:cf4b:b0:235:e1d6:5343 with SMTP id
 d9443c01a7336-23de3814e8bmr461055ad.20.1752089374944; Wed, 09 Jul 2025
 12:29:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250709124059.516095-2-dtatulea@nvidia.com>
In-Reply-To: <20250709124059.516095-2-dtatulea@nvidia.com>
From: Mina Almasry <almasrymina@google.com>
Date: Wed, 9 Jul 2025 12:29:22 -0700
X-Gm-Features: Ac12FXzb8O6e_uyBN8jcy_9__JTqJo61P2Qu2LqNPnLDGOIUOsAO3EnKDZXDam0
Message-ID: <CAHS8izNHXvtXF+Xftocvi+1E2hZ0v9FiTWBxaY7NWhemhPy-hQ@mail.gmail.com>
Subject: Re: [PATCH net] net: Allow non parent devices to be used for ZC DMA
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: asml.silence@gmail.com, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, Simona Vetter <simona.vetter@ffwll.ch>, 
	Willem de Bruijn <willemb@google.com>, Kaiyuan Zhang <kaiyuanz@google.com>, cratiu@nvidia.com, 
	parav@nvidia.com, Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 9, 2025 at 5:46=E2=80=AFAM Dragos Tatulea <dtatulea@nvidia.com>=
 wrote:
>
> For zerocopy (io_uring, devmem), there is an assumption that the
> parent device can do DMA. However that is not always the case:
> ScalableFunction devices have the DMA device in the grandparent.
>
> This patch adds a helper for getting the DMA device for a netdev from
> its parent or grandparent if necessary. The NULL case is handled in the
> callers.
>
> devmem and io_uring are updated accordingly to use this helper instead
> of directly using the parent.
>
> Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
> Fixes: 170aafe35cb9 ("netdev: support binding dma-buf to netdevice")

nit: This doesn't seem like a fix? The current code supports all
devices that are not SF well enough, right? And in the case of SF
devices, I expect net_devmem_bind_dmabuf() to fail gracefully as the
dma mapping of a device that doesn't support it, I think, would fail
gracefully. So to me this seems like an improvement rather than a bug
fix.

> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> ---
> Changes in v1:
> - Upgraded from RFC status.
> - Dropped driver specific bits for generic solution.
> - Implemented single patch as a fix as requested in RFC.
> - Handling of multi-PF netdevs will be handled in a subsequent patch
>   series.
>
> RFC: https://lore.kernel.org/all/20250702172433.1738947-2-dtatulea@nvidia=
.com/
> ---
>  include/linux/netdevice.h | 14 ++++++++++++++
>  io_uring/zcrx.c           |  2 +-
>  net/core/devmem.c         | 10 +++++++++-
>  3 files changed, 24 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 5847c20994d3..1cbde7193c4d 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -5560,4 +5560,18 @@ extern struct net_device *blackhole_netdev;
>                 atomic_long_add((VAL), &(DEV)->stats.__##FIELD)
>  #define DEV_STATS_READ(DEV, FIELD) atomic_long_read(&(DEV)->stats.__##FI=
ELD)
>
> +static inline struct device *netdev_get_dma_dev(const struct net_device =
*dev)
> +{
> +       struct device *dma_dev =3D dev->dev.parent;
> +
> +       if (!dma_dev)
> +               return NULL;
> +
> +       /* Some devices (e.g. SFs) have the dma device as a grandparent. =
*/
> +       if (!dma_dev->dma_mask)

I was able to confirm that !dev->dma_mask means "this device doesn't
support dma". Multiple existing places in the code seem to use this
check.

> +               dma_dev =3D dma_dev->parent;
> +
> +       return (dma_dev && dma_dev->dma_mask) ? dma_dev : NULL;

This may be a noob question, but are we sure that !dma_dev->dma_mask
&& dma_dev->parent->dma_mask !=3D NULL means that the parent is the
dma-device that we should use? I understand SF devices work that way
but it's not immediately obvious to me that this is generically true.

For example pavel came up with the case where for veth,
netdev->dev.parent =3D=3D NULL , I wonder if there are weird devices in
the wild where netdev->dev.parent->dma_mask =3D=3D NULL but that doesn't
necessarily mean that the grandparent is the dma-device that we should
use.

I guess to keep my long question short: what makes you think this is
generically safe to do? Or is it not, but we think most devices behave
this way and we're going to handle more edge cases in follow up
patches?

> +}
> +
>  #endif /* _LINUX_NETDEVICE_H */
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index 797247a34cb7..93462e5b2207 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -584,7 +584,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
>                 goto err;
>         }
>
> -       ifq->dev =3D ifq->netdev->dev.parent;
> +       ifq->dev =3D netdev_get_dma_dev(ifq->netdev);

nit: this hunk will not apply when backporting this to trees that only
have the Fixes commit... which makes it more weird that this is
considered a fix for that, but I'm fine either way.



--
Thanks,
Mina

