Return-Path: <io-uring+bounces-8849-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C8C75B14460
	for <lists+io-uring@lfdr.de>; Tue, 29 Jul 2025 00:26:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E476617F61A
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 22:26:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AC3F21C18A;
	Mon, 28 Jul 2025 22:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PmMv7XnG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BE78488
	for <io-uring@vger.kernel.org>; Mon, 28 Jul 2025 22:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753741600; cv=none; b=GegX6dcgLz0DHfhW37fJhXjpwHX6253u5ausA32HbEAl3xFa2JNxR5MjWv2HK/fUhJbZnVGU6rKg2MKSi8IcA1GDbjTW4TQBF34HbY4JeJmISy44qzGmEcqUKgn85/C6ksbZNCDJ/9BH5L3G5dC/y0lHaAMkdaqmFtaCDX98g14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753741600; c=relaxed/simple;
	bh=qLqqVsJ6y/eeE3v6hz2G96ErsNWEEzfkmsab5m3mkgY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aHYFmK9XQ57rWgBzQTEXV9Zp8SFxQ+9rNPa2Sv0YiG0iN4G+iQEnzx2WlgPHF5dY7NJmhYWC/gl9oodortftq3WLeKaM8lPeNPa02hks2ykYNYr0gqRYth2bdyjZug9IW5gA6WojYOMO4Dg9P/1b2InguPDB22YbChuHY2GAQWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PmMv7XnG; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-240708ba498so3935ad.1
        for <io-uring@vger.kernel.org>; Mon, 28 Jul 2025 15:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753741599; x=1754346399; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zx7bn/PnjBJOHAzZudoKmzZRmJUgU0lTucf4z4soCow=;
        b=PmMv7XnGSL7USVC4hR2ucsV7M+dSVQtGX43dHd7ICZ76Vqb6vRiS62vqNTEvb74Pfa
         7OJM/9TGWv4GQblYrjfQgO1SWIuD+YK95UUMvqFsOiOnRiJUmZweE1Tp5upLR1Uzoa6n
         hYrCxUvxplDMWiBMhxjXMFSFz2d7oJGSv/cbR6dNcNvxkG5xviST02gzftPU34hw23gi
         noqNMF7kwYMj2teWHWOvgXpbeh/3Ga1jNYTn2RZ4ypIRDdMWY4cL80ifuks/q67GVex8
         AnmhvaGENOAckwV45A4ED7tFe0XsVMWzKV5ijuBUCMd0ebzavt3BoZLIt4q5gwkd8Mhf
         GcXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753741599; x=1754346399;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zx7bn/PnjBJOHAzZudoKmzZRmJUgU0lTucf4z4soCow=;
        b=YBFi5b15aqZcC6PbyZwWrvBUkXRLlRTnchltQOczYKKcnQLOXqlkLZjy+UG8qxjY4I
         jEezEEMfKiAFw13vovXmhcsLGRa5kroGkVIJ4Vki36o9vYjQtjNETLUFPBtg7k2jQEuO
         YNLglYsozt/RuVY8ONIwY4aPwBhlV4WUBjF5Dtge1q8yTKN5yawNrvtOpauBGP9/45tR
         7GKLeienQprGMl2c3GC52QN8/lrLJxs+rg58Dxn+W8e+mp/PWHdIOH2IVPmyM5wo+sLB
         sW4PS/YEZXZlDzAX9VkHmWdohmsLSO6mP4ZOcxzz3NSMCTEN792JjbA5xh5RN+xUfIov
         SenA==
X-Forwarded-Encrypted: i=1; AJvYcCXv8ZzvF0aWlZJteZ2Jt7vdQUJjfvNtDV3vvvFz7OgdADDbPA0dW13WVH8J2lYPt7qMYBBHdD81VA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwwdEvIRvKHz+igweYz7mEo8lcWdxMqhAXW8QmAESxfMemsUAA8
	LHOME8wUSzhpyLpfetTzKW3c7u0FX0A74rS2VVZAQdVPMuKqQyvCXFY+R2iT6lVcCFwvbiSP2zj
	TE+oqQ7a6SX+Tm67xqSiYWomEbuu0hBAiITDwEeSO
X-Gm-Gg: ASbGncsJyvku/HLfANmMGpY6HV/34dYOo1G2vV5J107GGLksHP8IMT9kr9CwBLmXv3A
	Tn+9Rh7Z4o3liFSBfwH+0t5K+AUAmBxdA81bk63Ij41DRPXercdw44sO2WxSqhTr+fh0QL4DzTu
	1K+UlT+a3DmeEKsymCAs/DD6UyfH6EwAGogSYFGqlGSIcc4T2VkV9MzSrMZH3tFoWsXpSz/haLP
	AWFmw6LOnxVUQ4yiQmxDgBDnNRrr5u19Xs4fw==
X-Google-Smtp-Source: AGHT+IEnEzDOA6M+rastmc2IVN5koVlvSwAQufnC053xuD5Bp17sidHULObDn3IZANk5fDEZ/Xg9r/Brxt1VKiE4DDQ=
X-Received: by 2002:a17:903:32c5:b0:240:7d9:dd14 with SMTP id
 d9443c01a7336-24067974d11mr1391335ad.18.1753741598191; Mon, 28 Jul 2025
 15:26:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1753694913.git.asml.silence@gmail.com> <afd04f9bc1611bb16152021c161624f43f6b5a22.1753694914.git.asml.silence@gmail.com>
In-Reply-To: <afd04f9bc1611bb16152021c161624f43f6b5a22.1753694914.git.asml.silence@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 28 Jul 2025 15:26:22 -0700
X-Gm-Features: Ac12FXwOc2cAFpsXJ4DYgNYrTNUsntmlvVRV3oPtPLf_hhJEAgYXEG8QLSz3dOQ
Message-ID: <CAHS8izMJrB4MogOffo9T=Hc+6UX62eCvkESiSUeb9YUdLh6nQQ@mail.gmail.com>
Subject: Re: [RFC v1 13/22] net: add queue config validation callback
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, io-uring@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org, 
	davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk, 
	michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2025 at 4:03=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
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
> index e3e7ecf91bac..f75313fc78ba 100644
> --- a/include/net/netdev_queues.h
> +++ b/include/net/netdev_queues.h
> @@ -146,6 +146,14 @@ void netdev_stat_queue_sum(struct net_device *netdev=
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
> @@ -166,6 +174,10 @@ struct netdev_queue_mgmt_ops {
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
> index 6d7f5e920018..e0d433fb6325 100644
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

Shouldn't this be like return -EOPNOSUPP; or something? Otherwise how
do you protect drivers (GVE) that support queue API but don't support
a configuring a particular netdev_queue_config from core assuming that
the configuration took place?

> +       for (i =3D -1; i < (int)dev->real_num_rx_queues; i++) {
> +               netdev_queue_config(dev, i, &qcfg);
> +               err =3D qops->ndo_queue_cfg_validate(dev, i, &qcfg, extac=
k);
> +               if (err)
> +                       return err;
> +       }
> +
> +       return 0;
> +}
> diff --git a/net/core/netdev_rx_queue.c b/net/core/netdev_rx_queue.c
> index b0523eb44e10..7c691eb1a48b 100644
> --- a/net/core/netdev_rx_queue.c
> +++ b/net/core/netdev_rx_queue.c
> @@ -37,6 +37,12 @@ int netdev_rx_queue_restart(struct net_device *dev, un=
signed int rxq_idx,
>
>         netdev_queue_config(dev, rxq_idx, &qcfg);
>
> +       if (qops->ndo_queue_cfg_validate) {
> +               err =3D qops->ndo_queue_cfg_validate(dev, rxq_idx, &qcfg,=
 extack);
> +               if (err)
> +                       goto err_free_old_mem;
> +       }
> +
>         err =3D qops->ndo_queue_mem_alloc(dev, &qcfg, new_mem, rxq_idx);
>         if (err)
>                 goto err_free_old_mem;
> diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
> index 6a74e7e4064e..7884d10c090f 100644
> --- a/net/ethtool/rings.c
> +++ b/net/ethtool/rings.c
> @@ -4,6 +4,7 @@
>
>  #include "netlink.h"
>  #include "common.h"
> +#include "../core/dev.h"
>
>  struct rings_req_info {
>         struct ethnl_req_info           base;
> @@ -307,6 +308,10 @@ ethnl_set_rings(struct ethnl_req_info *req_info, str=
uct genl_info *info)
>         dev->cfg_pending->hds_config =3D kernel_ringparam.tcp_data_split;
>         dev->cfg_pending->hds_thresh =3D kernel_ringparam.hds_thresh;
>
> +       ret =3D netdev_queue_config_revalidate(dev, info->extack);
> +       if (ret)
> +               return ret;
> +
>         ret =3D dev->ethtool_ops->set_ringparam(dev, &ringparam,
>                                               &kernel_ringparam, info->ex=
tack);
>         return ret < 0 ? ret : 1;
> --
> 2.49.0
>


--=20
Thanks,
Mina

