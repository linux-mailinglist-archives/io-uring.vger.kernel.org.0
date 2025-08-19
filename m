Return-Path: <io-uring+bounces-9084-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAE1AB2CEF8
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 00:01:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A79C0562871
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 22:00:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 904DA31DD86;
	Tue, 19 Aug 2025 21:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o3LdfPM8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01C53054C5
	for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 21:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755640515; cv=none; b=YhSR2LwT48vSfikdJF2moaNz1bdu2RQhAGg0yU4QoE4TG+xBIG8vv9ZcB5SbQ9XvTHpNKqVwpXo6WqFu+0Iuh1LWjf2QurpO9s4HW1OJfcPJaYePc5FflXWIcEUIXzKEzMCgB5+zG+bJ5X+00VXrrXncnnX05LQ7IP7blWgL6tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755640515; c=relaxed/simple;
	bh=jugAp7iAiTN5wpRLM0Lfl5uLxQIUuuVskd6wG72PHAQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hn0wX7vwd9402XmpeS/ETNwdnnlx7Fz54p1mJB+rN978FJJFKWtc9J8E6BIMj9mgbuuD5X5xoCT7QTwf3Fg/yRl042eXNpP6w4h9IULyVLO1JCcI9V1hXGnofRl1LaF9sbQ0zzyiGazdWJzC6Gt4WI+PewlyKRVVPz7T5otjTXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o3LdfPM8; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-55cc715d0easo4792e87.0
        for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 14:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755640508; x=1756245308; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1VjKxvkqlHvKuDQTAdp11Q1px0mlLxmaJPy90ey9LnI=;
        b=o3LdfPM8idVZbUxrj9am39LbMwWCU2T84wyc+PsE8dM367cJO0Ugc7yuvcTtK47bSd
         DbWJw/8odp4Cpmesnwhgng2AyUbE0t1q9WlcGNCNChL8E5aS5nZGrO9V+TNDcLnoxPkX
         VXWIiX6+SNsmC9vnVwxNg1YXsUHBOPBFj79ZxiR9bVOFSqza1f14lNPlxnthrroHhnk5
         UBRK74IWvtqQSMhfcWoITeAMpTJBqi34y4zw3IBbj0VFxppzjnhdhNRh7wofb0dZJbCx
         CGrV9QSIBVLgdMsXBM5QPQlKcq4ILsoXpuFqMw3xMYv25nq8rrFtJD8Bkcq/CHtis/To
         PBLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755640508; x=1756245308;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1VjKxvkqlHvKuDQTAdp11Q1px0mlLxmaJPy90ey9LnI=;
        b=JQpXSZdJ4McJP5Sz4EtYhok3HZvxbLCvwISirqh5QmLH6SWEEINdnfV/Irbbl8DIiI
         yoB488llHQt3f+kVDbKGjs8K//6h56EsHyNRFekm+KTkHGn48P3i+bXGm+yGfRwpgR1I
         dCwVcioRuABhWC5YYwthCJzZs+WL/nGhP3iF26b99IPuAVEyLErmoi+Mxkpgcgy4KkGP
         kPvSW0uePK4DmFSIb13fZxgYJYxJRDaT/E5kU7wDCsXo/vhBD//OrsOIp8cJUIpH47Um
         fo6WdlHJFd7WhU72wPt0xLiRoIO7ME54OH3UfWTRNcaEQ2+G30kVyk4uV+uqhVy5wPRd
         Yo7g==
X-Forwarded-Encrypted: i=1; AJvYcCUitL4qJtozb9+QkvRlIzH8hiDDbYTgD2dp0iL9i3f/+KqNfTrHPBYHHV1S0IPzZ+nTBhD2i9EQnw==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywig0Wugb06jZ/vYzDDPLhIramwjHnBRBrIczJX0Es3V6rp4KrD
	S6HG/ti4Odf3ZshzibjzuYAtOE+ZEyFDuYq/pPlD4BoMUhs4rh430g71m1EDnxrVyhvAd426zu8
	jICz/LmdcYsU/LIMoG8/afwSp2tm5NKGFcOJHLLqW
X-Gm-Gg: ASbGnctDpP3VBxTHgd/RirIc1R+X74r20noMl900aA8vY7d2gmhB+EbD2RQlG6lGNkw
	bALKNJ4s/wxcOtY3EWmCaM7goq5HuhA/g37CHtyjdCo113tg644uznIzCHaGc2z+GqUiFT8pW2H
	Q/S2/as+oDbc9Ce++gC+pxGE9Y73LsYrW/7fDE72dxib2nss8DYoq9L5iAnHyB3POveKij7LuQF
	V9QDSwbsgo8yeTixqYRl90ldlsGA4FNIVXQ0nzlLsluntBRmvGqZiw=
X-Google-Smtp-Source: AGHT+IEENPeJUziX5JKCVFlOK3QcW9hOPlY+os3uYUuHODeq049TKSrhikj9f/ivABKSBZN/jlqaOuHA4OZlfyxo/To=
X-Received: by 2002:a05:6512:6401:b0:55b:5e26:ed7b with SMTP id
 2adb3069b0e04-55e066d2922mr97406e87.0.1755640507787; Tue, 19 Aug 2025
 14:55:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1755499375.git.asml.silence@gmail.com> <819d46e1354b0c7cc97945c6c7bde09f12df1da6.1755499376.git.asml.silence@gmail.com>
In-Reply-To: <819d46e1354b0c7cc97945c6c7bde09f12df1da6.1755499376.git.asml.silence@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 19 Aug 2025 14:54:55 -0700
X-Gm-Features: Ac12FXxeo1Wf2dKxzd4cQVsy9kzkzxP83IAtSvMfurLpwYPvoLmCKi5ODIA8qfw
Message-ID: <CAHS8izOru3+zGPkOa5XMWOo1uhtzz+Zt7yDC7R=NZFfyPdeK9Q@mail.gmail.com>
Subject: Re: [PATCH net-next v3 14/23] net: add queue config validation callback
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org, 
	davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk, 
	michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2025 at 6:56=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> From: Jakub Kicinski <kuba@kernel.org>
>
> I imagine (tm) that as the number of per-queue configuration
> options grows some of them may conflict for certain drivers.
> While the drivers can obviously do all the validation locally
> doing so is fairly inconvenient as the config is fed to drivers
> piecemeal via different ops (for different params and NIC-wide
> vs per-queue).
>
> Add a centralized callback for validating the queue config
> in queue ops. The callback gets invoked before each queue restart
> and when ring params are modified.
>
> For NIC-wide changes the callback gets invoked for each active
> (or active to-be) queue, and additionally with a negative queue
> index for NIC-wide defaults. The NIC-wide check is needed in
> case all queues have an override active when NIC-wide setting
> is changed to an unsupported one. Alternatively we could check
> the settings when new queues are enabled (in the channel API),
> but accepting invalid config is a bad idea. Users may expect
> that resetting a queue override will always work.
>
> The "trick" of passing a negative index is a bit ugly, we may
> want to revisit if it causes confusion and bugs. Existing drivers
> don't care about the index so it "just works".
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/net/netdev_queues.h | 12 ++++++++++++
>  net/core/dev.h              |  2 ++
>  net/core/netdev_config.c    | 20 ++++++++++++++++++++
>  net/core/netdev_rx_queue.c  |  6 ++++++
>  net/ethtool/rings.c         |  5 +++++
>  5 files changed, 45 insertions(+)
>
> diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
> index b850cff71d12..d0cc475ec51e 100644
> --- a/include/net/netdev_queues.h
> +++ b/include/net/netdev_queues.h
> @@ -147,6 +147,14 @@ void netdev_stat_queue_sum(struct net_device *netdev=
,
>   *                     defaults. Queue config structs are passed to this
>   *                     helper before the user-requested settings are app=
lied.
>   *
> + * @ndo_queue_cfg_validate: (Optional) Check if queue config is supporte=
d.
> + *                     Called when configuration affecting a queue may b=
e
> + *                     changing, either due to NIC-wide config, or confi=
g
> + *                     scoped to the queue at a specified index.
> + *                     When NIC-wide config is changed the callback will
> + *                     be invoked for all queues, and in addition to tha=
t
> + *                     with a negative queue index for the base settings=
.
> + *
>   * @ndo_queue_mem_alloc: Allocate memory for an RX queue at the specifie=
d index.
>   *                      The new memory is written at the specified addre=
ss.
>   *
> @@ -167,6 +175,10 @@ struct netdev_queue_mgmt_ops {
>         void    (*ndo_queue_cfg_defaults)(struct net_device *dev,
>                                           int idx,
>                                           struct netdev_queue_config *qcf=
g);
> +       int     (*ndo_queue_cfg_validate)(struct net_device *dev,
> +                                         int idx,
> +                                         struct netdev_queue_config *qcf=
g,
> +                                         struct netlink_ext_ack *extack)=
;
>         int     (*ndo_queue_mem_alloc)(struct net_device *dev,
>                                        struct netdev_queue_config *qcfg,
>                                        void *per_queue_mem,
> diff --git a/net/core/dev.h b/net/core/dev.h
> index a553a0f1f846..523d50e6f88d 100644
> --- a/net/core/dev.h
> +++ b/net/core/dev.h
> @@ -99,6 +99,8 @@ void netdev_free_config(struct net_device *dev);
>  int netdev_reconfig_start(struct net_device *dev);
>  void __netdev_queue_config(struct net_device *dev, int rxq,
>                            struct netdev_queue_config *qcfg, bool pending=
);
> +int netdev_queue_config_revalidate(struct net_device *dev,
> +                                  struct netlink_ext_ack *extack);
>
>  /* netdev management, shared between various uAPI entry points */
>  struct netdev_name_node {
> diff --git a/net/core/netdev_config.c b/net/core/netdev_config.c
> index bad2d53522f0..fc700b77e4eb 100644
> --- a/net/core/netdev_config.c
> +++ b/net/core/netdev_config.c
> @@ -99,3 +99,23 @@ void netdev_queue_config(struct net_device *dev, int r=
xq,
>         __netdev_queue_config(dev, rxq, qcfg, true);
>  }
>  EXPORT_SYMBOL(netdev_queue_config);
> +
> +int netdev_queue_config_revalidate(struct net_device *dev,
> +                                  struct netlink_ext_ack *extack)
> +{
> +       const struct netdev_queue_mgmt_ops *qops =3D dev->queue_mgmt_ops;
> +       struct netdev_queue_config qcfg;
> +       int i, err;
> +
> +       if (!qops || !qops->ndo_queue_cfg_validate)
> +               return 0;
> +
> +       for (i =3D -1; i < (int)dev->real_num_rx_queues; i++) {
> +               netdev_queue_config(dev, i, &qcfg);

This function as written feels very useless tbh. There is no config
passed in from the caller, so the function does a netdev_queue_config,
which grabs the current-or-default-config (I'm not sure which tbh),
and then validates that is applicable. But of course the current or
default configs can be applied, right?

I thought there would be a refactor in a future patch that makes this
function useful, but I don't see one.

The qcfg being applied needs to be passed in by the caller of this
function, no? That would make sense to me (the caller is wondering if
this new config is applicable).

--=20
Thanks,
Mina

