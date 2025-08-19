Return-Path: <io-uring+bounces-9081-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D27F6B2CDA5
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 22:17:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09E35723369
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 20:16:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF72A342CAE;
	Tue, 19 Aug 2025 20:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I/9mfs/P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0417B2571DD
	for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 20:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755634556; cv=none; b=i5wWDgZ2LNiGVHCdatv5CFfLCeUlz44qLwXVuD8wi3Jj7Am5D5edFPBLWGBHQ+TQzaQRvYvgeUSdAyodSXhZ2voneIUY6Z6pk/ysH7eiBuTslevFN5hEuOI44BvDmO32ohUaQOMXttX1DeOG0UiN7szVh1tO+m7qVRZeM4r2EwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755634556; c=relaxed/simple;
	bh=haNt1ynrBslWuNN9po1WS/VqpVcCCWlCBE37zYZJkZY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=el0hMCPwQ9snyeJZ+3WNU5LGCWV8mLQ66CWqmdnWaIKVZo+NuSQoOk3Yz6hBMALMTGBh3CiSA4gQ5pn4Pi3zgvgjNGvZs3xY0iw8peJP/4LfDXSMbi05DRhvXw/8UmJMZDbRqU5AD4EQIRJoI2qv4p5o8LbroGdrOAT/pfG2xsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I/9mfs/P; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-55cef2f624fso1728e87.1
        for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 13:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755634552; x=1756239352; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5ZMXm24uetgG6qUHWYUnf6IXKxtAndMosq8RvrZUKXE=;
        b=I/9mfs/PHAGZt8YkAqfLpi4PE+blLDReBlDuEI3RqONOhVw1dGX4jG0muHA+IeXKCZ
         qhk+S4LRxSX1K6b/8dZXlQ3vd7BTce8yNO7pkLwMwfginHA4pM7A5V14N0KagKwIdBA+
         nrGxp8jwOybRPa6nbHPAwPJ41VB1TtRK1BRiMSjdwnqJ0K1B3wRZ5+bcYyMrBFUeix+O
         7ymGb9fjpuYBoOAtqUdPzIb7iRLyUrakp2Ifld16hzr87UgfLrJhUsLeFO03HGsPL7FZ
         IuL+wZdzB2NanxW6xPs5/L10dP4pBLMCyeQsyHeFlwtvTiBCGLE4B1N4AymvzTxJVHQF
         OjTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755634552; x=1756239352;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5ZMXm24uetgG6qUHWYUnf6IXKxtAndMosq8RvrZUKXE=;
        b=klsvCDOm0WeGYDXLEcVLZ5mfj6fx19ABesE/o9SH3EguPvAHEaGs3/5bUIsXsMp40G
         YnQg7PBCbAEF7X63eOSJfHP8qBeM58VG06i6dLKp3cJopPAQGlxoRLf+N18X4QCk5AnH
         a7wtrHntr1ti4jm24OaOn8F6o0ZnEA36LjhTqG4g9c6Yfs0cSTizis2B6xXEiDf84/P4
         8KjJyHo/0100k0g8OaNkLBqt6KQbjidJRmr0pJ58AMXbH0bjffmAu9WOs+X9keyhpPyx
         XdOvJIUUlSaHlDNraRzz0fdFYYsbBB9akbpMna9/tKOHWEW/IOIFwXZ0HsGCDUDOxlbb
         YBkA==
X-Forwarded-Encrypted: i=1; AJvYcCU0w+Awzti9nToMde5NMsXCYYP8lmmeWWoTbeSA9g3hSjLS1i95J5QHMwOZ1lmJVXLNQ3QwNdx0RA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxDaLfWi4+WidJ1tixmpSjjgIdkzuSynKRuhqZvfFvrM5+UYHeU
	6Bh0HMoHG8sxhNuNUZjP3xm65fRMRRPNlTSF5s/gOkN+z9qRBeVsMwUIsqYyiqAXU4JFMm4cn6J
	FoQLgI6rkRFYpttF2fQoQtEE1I4P44pLp8AYbo/jk
X-Gm-Gg: ASbGncuAVkA4EB4QEpE3OEvW0u/BL+cNGlYc/D+BYEvaBrosGYJjK3Acszc6eZBQIbS
	RgUr1j+xnV5EOBYzjf5HD5IpelazXb+6804lWYIaWgOynDhP/m5xvRoUlTp9tf9duwfFAT9035c
	d/RverxjpFou2AJPC8+j6wqf4kvgCEbaYf8wEzEZnDcJ3MAI6ZlMqhTqOmdC0dk5v8jkxZSFklE
	F/3t/mZ4Jtb3nI/W+HdF98iKd9MPuEgtU5Nf2M+zDQNut4a5kBsbc8=
X-Google-Smtp-Source: AGHT+IGOTSfoGmYaePWoFD5+meo3XBb2vpfJQKqJ4JTBJP5htoWmfFQaOrBPMHZxzbYyZtrHwdJp4c1LpY5fBwKAiAM=
X-Received: by 2002:a05:6512:609b:b0:55d:9f5:8846 with SMTP id
 2adb3069b0e04-55e066ac51cmr50748e87.0.1755634551686; Tue, 19 Aug 2025
 13:15:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1755499375.git.asml.silence@gmail.com> <536e37960e3d75c633bdcdcfec37a89636581f2c.1755499376.git.asml.silence@gmail.com>
In-Reply-To: <536e37960e3d75c633bdcdcfec37a89636581f2c.1755499376.git.asml.silence@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 19 Aug 2025 13:15:37 -0700
X-Gm-Features: Ac12FXyFNa4-6VDkMH60R1X9jCiq4Lpoo0jyzvsCmWd87zW1qTO99gzjyPNMFJA
Message-ID: <CAHS8izPWODE0sdVe0KTT69Wm8-LJLnXGjNFi+j77PrVGzK1FgQ@mail.gmail.com>
Subject: Re: [PATCH net-next v3 10/23] net: move netdev_config manipulation to
 dedicated helpers
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
> netdev_config manipulation will become slightly more complicated
> soon and we will need to call if from ethtool as well as queue API.
> Encapsulate the logic into helper functions.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  net/core/Makefile        |  2 +-
>  net/core/dev.c           |  7 ++-----
>  net/core/dev.h           |  5 +++++
>  net/core/netdev_config.c | 43 ++++++++++++++++++++++++++++++++++++++++
>  net/ethtool/netlink.c    | 14 ++++++-------
>  5 files changed, 57 insertions(+), 14 deletions(-)
>  create mode 100644 net/core/netdev_config.c
>
> diff --git a/net/core/Makefile b/net/core/Makefile
> index b2a76ce33932..4db487396094 100644
> --- a/net/core/Makefile
> +++ b/net/core/Makefile
> @@ -19,7 +19,7 @@ obj-$(CONFIG_NETDEV_ADDR_LIST_TEST) +=3D dev_addr_lists=
_test.o
>
>  obj-y +=3D net-sysfs.o
>  obj-y +=3D hotdata.o
> -obj-y +=3D netdev_rx_queue.o
> +obj-y +=3D netdev_config.o netdev_rx_queue.o
>  obj-$(CONFIG_PAGE_POOL) +=3D page_pool.o page_pool_user.o
>  obj-$(CONFIG_PROC_FS) +=3D net-procfs.o
>  obj-$(CONFIG_NET_PKTGEN) +=3D pktgen.o
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 5a3c0f40a93f..7cd4e5eab441 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -11873,10 +11873,8 @@ struct net_device *alloc_netdev_mqs(int sizeof_p=
riv, const char *name,
>         if (!dev->ethtool)
>                 goto free_all;
>
> -       dev->cfg =3D kzalloc(sizeof(*dev->cfg), GFP_KERNEL_ACCOUNT);
> -       if (!dev->cfg)
> +       if (netdev_alloc_config(dev))
>                 goto free_all;
> -       dev->cfg_pending =3D dev->cfg;
>
>         dev->num_napi_configs =3D maxqs;
>         napi_config_sz =3D array_size(maxqs, sizeof(*dev->napi_config));
> @@ -11947,8 +11945,7 @@ void free_netdev(struct net_device *dev)
>                 return;
>         }
>
> -       WARN_ON(dev->cfg !=3D dev->cfg_pending);
> -       kfree(dev->cfg);
> +       netdev_free_config(dev);
>         kfree(dev->ethtool);
>         netif_free_tx_queues(dev);
>         netif_free_rx_queues(dev);
> diff --git a/net/core/dev.h b/net/core/dev.h
> index d6b08d435479..7041c8bd2a0f 100644
> --- a/net/core/dev.h
> +++ b/net/core/dev.h
> @@ -92,6 +92,11 @@ extern struct rw_semaphore dev_addr_sem;
>  extern struct list_head net_todo_list;
>  void netdev_run_todo(void);
>
> +int netdev_alloc_config(struct net_device *dev);
> +void __netdev_free_config(struct netdev_config *cfg);
> +void netdev_free_config(struct net_device *dev);
> +int netdev_reconfig_start(struct net_device *dev);
> +
>  /* netdev management, shared between various uAPI entry points */
>  struct netdev_name_node {
>         struct hlist_node hlist;
> diff --git a/net/core/netdev_config.c b/net/core/netdev_config.c
> new file mode 100644
> index 000000000000..270b7f10a192
> --- /dev/null
> +++ b/net/core/netdev_config.c
> @@ -0,0 +1,43 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <linux/netdevice.h>
> +#include <net/netdev_queues.h>
> +
> +#include "dev.h"
> +
> +int netdev_alloc_config(struct net_device *dev)
> +{
> +       struct netdev_config *cfg;
> +
> +       cfg =3D kzalloc(sizeof(*dev->cfg), GFP_KERNEL_ACCOUNT);
> +       if (!cfg)
> +               return -ENOMEM;
> +
> +       dev->cfg =3D cfg;
> +       dev->cfg_pending =3D cfg;
> +       return 0;
> +}
> +
> +void __netdev_free_config(struct netdev_config *cfg)
> +{
> +       kfree(cfg);
> +}
> +
> +void netdev_free_config(struct net_device *dev)
> +{
> +       WARN_ON(dev->cfg !=3D dev->cfg_pending);
> +       __netdev_free_config(dev->cfg);
> +}
> +
> +int netdev_reconfig_start(struct net_device *dev)
> +{
> +       struct netdev_config *cfg;
> +
> +       WARN_ON(dev->cfg !=3D dev->cfg_pending);
> +       cfg =3D kmemdup(dev->cfg, sizeof(*dev->cfg), GFP_KERNEL_ACCOUNT);
> +       if (!cfg)
> +               return -ENOMEM;
> +
> +       dev->cfg_pending =3D cfg;
> +       return 0;

There are a couple of small behavior changes in this code. (a) the
WARN_ON is new, and (b) this helper retains dev->cfg_pending on error
while the old code would clear it. But both seem fine to me, so,

Reviewed-by: Mina Almasry <almasrymina@google.com>

--
Thanks,
Mina

