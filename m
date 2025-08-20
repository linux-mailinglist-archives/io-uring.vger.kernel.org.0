Return-Path: <io-uring+bounces-9089-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64297B2D173
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 03:33:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D50EF622776
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 01:33:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7016239E63;
	Wed, 20 Aug 2025 01:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iAwurI/F"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655D72367C0
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 01:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755653588; cv=none; b=mAZwaRt2eUP2cFhvC8345OrWkB7armK+r/cMv2vIkRWIXBvRegV21HZ0KwFD5Zz8fDJdzQuhGiPQmMsmjaxEZq28ULiPAelbkeZ3rPdkSMyjFt459EYevbtBxJxFuL5SJJz1rozetzvhE/a6t8NDrUP5Nx0LYXuh3ChgjsIdE1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755653588; c=relaxed/simple;
	bh=ZTbHDiDaILNF2Iw51hIoo4Uz11PEH2PDqW6D/L0pUqk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d4ZiqIKtZw6BjeVqKK1YZZPCLC1/vMFoxZoLxNnsBeA0Wqsq17LUaHXAQaWUpLwmPp+75YuQHlFfEGfpE+tEKjIGWKv7vXoX3xQ+ujhPFauaa1jIcRTV7ox/sU4jy7+Etq5kv6E20JPVt3JLGSWxMjbIe3xZ5RTcGD5z6wOY1XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iAwurI/F; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-55cc715d0easo5795e87.0
        for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 18:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755653584; x=1756258384; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gBEzfO20+SJXzkMnLzfW5+mTbykHEDBeDICHkObc3nM=;
        b=iAwurI/FpGlDBNu4jDLQ9GpTauwoKR1QLV9qczQav2mGDl+xHGmsgTmbCc0EZuUvFB
         5MiKMlsWTSLRLDXvJuetNPYCq0qQ4vu+qfwhO30g/Jcb4vgnPmWF49TjP1Me+2h3JlNM
         vEPmatvL7zRQI4tViR9VukHG1rvRUxXikO9V4EPhmqP4GX/aXddSFgeEJoNioOQr5wxy
         iSjv6xvssEBkNmR2PDslI97n3XJx7GK2+Kv/paVqh7cdnmflFFiNLhKqrtP/xuaRK850
         JaDmj3iOq3tlJTpGrL4V3QagKAe+vNexNEgBZterrR5OjYgT51oFQBXmxnEQiI9VCSK0
         reOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755653584; x=1756258384;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gBEzfO20+SJXzkMnLzfW5+mTbykHEDBeDICHkObc3nM=;
        b=eKmNpPpiPkYO8hBKshXa7DmSLE98UA/FM5Mipj9htr3w8QbkG1a/wrSzf45t0+sXdr
         Zxa60FLJxPv6pTwkqlOba26aLE5yBcSICidX7YYCvJCrGmQA/qJMpASgTp9YFTlvxyMW
         SutuaDW9oHl3ULmjxFv+pYWleZ/ln2t2AkSAHvV2HG2R6P4kgGQ56WizZc4mx/3UArjZ
         LAH8PNjs9FtNaAWEksjPKsaHLIn62q7HDHz1kOMDsqO+QcYZbbs/1lfRpgDBhYExtik3
         WUIe/FZMp8tcAGvWx2FrBh6SFnMnnb5U0OH7tFV+d/MAyvAKAv/VbKGYERtveSC4UVgp
         nkcg==
X-Forwarded-Encrypted: i=1; AJvYcCWhh4h4FE0it0FHqyGtwSZxIqgp79gvL+zaGLbQ63wvvk5AxLXtCfcdJi8y/b1JnAxfpe8pnSvFTA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0RYzWa8TTTp8eFpD2xFqut0ZM6k2lAH5dhxsiSKTMCOpA1NHn
	AAgJ8C7hFoF4BnyOyJBaGc4i8foa3TuS1jsFk/PGwx4R+M8Vdo3iFoxd3j2PFvf5fo5PSiOAg74
	P3oztAAacjfT5i81xdKNAp8RAGJBrmqWDMv2wYMV0
X-Gm-Gg: ASbGncte0jkd12koRQzK7jDa6NWxWrMY/9UmpWPDZt4OBaxZSLXQrIAFLFNukQSLeC4
	BLzX8arXLnGL6tiBo3GNPX0XwBO+aWYfg+WPOWELWs9/SP6KeStk+evYYSZXUumhhl9iZYQkGzf
	xjWv4hXWx2GCWpZCH9z1IffuPlhzeHTbkUo9MDlqDdf7u6U0gkYOG1lyAAD7WQael0qHR7YmUQV
	/PcW+tltJGaKrFyXYVf+ZLdww==
X-Google-Smtp-Source: AGHT+IFw2bMY4wq5Ep349BbGLUTagIi6qftRXZeQmjRMHUMH9PE/MkR1sRNP8O1yFbnbkQPaFLXTtWEzCJ/Ujoa0dKs=
X-Received: by 2002:a05:6512:6401:b0:55b:5e26:ed7b with SMTP id
 2adb3069b0e04-55e066d2922mr160738e87.0.1755653584237; Tue, 19 Aug 2025
 18:33:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1755499375.git.asml.silence@gmail.com> <9a2571a308e1a2ac600bc23db4911c03fc923d11.1755499376.git.asml.silence@gmail.com>
 <CAHS8izPgcjR-L=xfLvJDEVVt3uUOfavoEAWuCZ9F4DgpoAmHtQ@mail.gmail.com>
In-Reply-To: <CAHS8izPgcjR-L=xfLvJDEVVt3uUOfavoEAWuCZ9F4DgpoAmHtQ@mail.gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 19 Aug 2025 18:32:52 -0700
X-Gm-Features: Ac12FXxVNdgmS_ysafPNu2hOCIGw9pviXMhgt0QdOOufMh2CF8Pcz3nAc0tDp0s
Message-ID: <CAHS8izMN+_9iWiZnc_FdkMZVDsRRG9FM8JYsz84V8gqDJU_GAA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 12/23] net: allocate per-queue config structs
 and pass them thru the queue API
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org, 
	davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk, 
	michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2025 at 2:29=E2=80=AFPM Mina Almasry <almasrymina@google.co=
m> wrote:
>
> On Mon, Aug 18, 2025 at 6:56=E2=80=AFAM Pavel Begunkov <asml.silence@gmai=
l.com> wrote:
> >
> > From: Jakub Kicinski <kuba@kernel.org>
> >
> > Create an array of config structs to store per-queue config.
> > Pass these structs in the queue API. Drivers can also retrieve
> > the config for a single queue calling netdev_queue_config()
> > directly.
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > [pavel: patch up mlx callbacks with unused qcfg]
> > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > ---
> >  drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  8 ++-
> >  drivers/net/ethernet/google/gve/gve_main.c    |  9 ++-
> >  .../net/ethernet/mellanox/mlx5/core/en_main.c |  9 +--
> >  drivers/net/netdevsim/netdev.c                |  6 +-
> >  include/net/netdev_queues.h                   | 19 ++++++
> >  net/core/dev.h                                |  3 +
> >  net/core/netdev_config.c                      | 58 +++++++++++++++++++
> >  net/core/netdev_rx_queue.c                    | 11 +++-
> >  8 files changed, 109 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/et=
hernet/broadcom/bnxt/bnxt.c
> > index d3d9b72ef313..48ff6f024e07 100644
> > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > @@ -15824,7 +15824,9 @@ static const struct netdev_stat_ops bnxt_stat_o=
ps =3D {
> >         .get_base_stats         =3D bnxt_get_base_stats,
> >  };
> >
> > -static int bnxt_queue_mem_alloc(struct net_device *dev, void *qmem, in=
t idx)
> > +static int bnxt_queue_mem_alloc(struct net_device *dev,
> > +                               struct netdev_queue_config *qcfg,
> > +                               void *qmem, int idx)
> >  {
> >         struct bnxt_rx_ring_info *rxr, *clone;
> >         struct bnxt *bp =3D netdev_priv(dev);
> > @@ -15992,7 +15994,9 @@ static void bnxt_copy_rx_ring(struct bnxt *bp,
> >         dst->rx_agg_bmap =3D src->rx_agg_bmap;
> >  }
> >
> > -static int bnxt_queue_start(struct net_device *dev, void *qmem, int id=
x)
> > +static int bnxt_queue_start(struct net_device *dev,
> > +                           struct netdev_queue_config *qcfg,
> > +                           void *qmem, int idx)
> >  {
> >         struct bnxt *bp =3D netdev_priv(dev);
> >         struct bnxt_rx_ring_info *rxr, *clone;
> > diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/e=
thernet/google/gve/gve_main.c
> > index 1f411d7c4373..f40edab616d8 100644
> > --- a/drivers/net/ethernet/google/gve/gve_main.c
> > +++ b/drivers/net/ethernet/google/gve/gve_main.c
> > @@ -2580,8 +2580,9 @@ static void gve_rx_queue_mem_free(struct net_devi=
ce *dev, void *per_q_mem)
> >                 gve_rx_free_ring_dqo(priv, gve_per_q_mem, &cfg);
> >  }
> >
> > -static int gve_rx_queue_mem_alloc(struct net_device *dev, void *per_q_=
mem,
> > -                                 int idx)
> > +static int gve_rx_queue_mem_alloc(struct net_device *dev,
> > +                                 struct netdev_queue_config *qcfg,
> > +                                 void *per_q_mem, int idx)
> >  {
> >         struct gve_priv *priv =3D netdev_priv(dev);
> >         struct gve_rx_alloc_rings_cfg cfg =3D {0};
> > @@ -2602,7 +2603,9 @@ static int gve_rx_queue_mem_alloc(struct net_devi=
ce *dev, void *per_q_mem,
> >         return err;
> >  }
> >
> > -static int gve_rx_queue_start(struct net_device *dev, void *per_q_mem,=
 int idx)
> > +static int gve_rx_queue_start(struct net_device *dev,
> > +                             struct netdev_queue_config *qcfg,
> > +                             void *per_q_mem, int idx)
> >  {
> >         struct gve_priv *priv =3D netdev_priv(dev);
> >         struct gve_rx_ring *gve_per_q_mem;
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/driver=
s/net/ethernet/mellanox/mlx5/core/en_main.c
> > index 21bb88c5d3dc..83264c17a4f7 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > @@ -5541,8 +5541,9 @@ struct mlx5_qmgmt_data {
> >         struct mlx5e_channel_param cparam;
> >  };
> >
> > -static int mlx5e_queue_mem_alloc(struct net_device *dev, void *newq,
> > -                                int queue_index)
> > +static int mlx5e_queue_mem_alloc(struct net_device *dev,
> > +                                struct netdev_queue_config *qcfg,
> > +                                void *newq, int queue_index)
> >  {
> >         struct mlx5_qmgmt_data *new =3D (struct mlx5_qmgmt_data *)newq;
> >         struct mlx5e_priv *priv =3D netdev_priv(dev);
> > @@ -5603,8 +5604,8 @@ static int mlx5e_queue_stop(struct net_device *de=
v, void *oldq, int queue_index)
> >         return 0;
> >  }
> >
> > -static int mlx5e_queue_start(struct net_device *dev, void *newq,
> > -                            int queue_index)
> > +static int mlx5e_queue_start(struct net_device *dev, struct netdev_que=
ue_config *qcfg,
> > +                            void *newq, int queue_index)
> >  {
> >         struct mlx5_qmgmt_data *new =3D (struct mlx5_qmgmt_data *)newq;
> >         struct mlx5e_priv *priv =3D netdev_priv(dev);
> > diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/net=
dev.c
> > index 0178219f0db5..985c3403ec57 100644
> > --- a/drivers/net/netdevsim/netdev.c
> > +++ b/drivers/net/netdevsim/netdev.c
> > @@ -733,7 +733,8 @@ struct nsim_queue_mem {
> >  };
> >
> >  static int
> > -nsim_queue_mem_alloc(struct net_device *dev, void *per_queue_mem, int =
idx)
> > +nsim_queue_mem_alloc(struct net_device *dev, struct netdev_queue_confi=
g *qcfg,
> > +                    void *per_queue_mem, int idx)
> >  {
> >         struct nsim_queue_mem *qmem =3D per_queue_mem;
> >         struct netdevsim *ns =3D netdev_priv(dev);
> > @@ -782,7 +783,8 @@ static void nsim_queue_mem_free(struct net_device *=
dev, void *per_queue_mem)
> >  }
> >
> >  static int
> > -nsim_queue_start(struct net_device *dev, void *per_queue_mem, int idx)
> > +nsim_queue_start(struct net_device *dev, struct netdev_queue_config *q=
cfg,
> > +                void *per_queue_mem, int idx)
> >  {
> >         struct nsim_queue_mem *qmem =3D per_queue_mem;
> >         struct netdevsim *ns =3D netdev_priv(dev);
> > diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
> > index d73f9023c96f..b850cff71d12 100644
> > --- a/include/net/netdev_queues.h
> > +++ b/include/net/netdev_queues.h
> > @@ -32,6 +32,13 @@ struct netdev_config {
> >         /** @hds_config: HDS enabled (ETHTOOL_A_RINGS_TCP_DATA_SPLIT).
> >          */
> >         u8      hds_config;
> > +
> > +       /** @qcfg: per-queue configuration */
> > +       struct netdev_queue_config *qcfg;
> > +};
> > +
> > +/* Same semantics as fields in struct netdev_config */
> > +struct netdev_queue_config {
> >  };
>
> I was very confused why this is empty until I looked at patch 18 :-D
>
> >
> >  /* See the netdev.yaml spec for definition of each statistic */
> > @@ -136,6 +143,10 @@ void netdev_stat_queue_sum(struct net_device *netd=
ev,
> >   *
> >   * @ndo_queue_mem_size: Size of the struct that describes a queue's me=
mory.
> >   *
> > + * @ndo_queue_cfg_defaults: (Optional) Populate queue config struct wi=
th
> > + *                     defaults. Queue config structs are passed to th=
is
> > + *                     helper before the user-requested settings are a=
pplied.
> > + *
> >   * @ndo_queue_mem_alloc: Allocate memory for an RX queue at the specif=
ied index.
> >   *                      The new memory is written at the specified add=
ress.
> >   *
> > @@ -153,12 +164,17 @@ void netdev_stat_queue_sum(struct net_device *net=
dev,
> >   */
> >  struct netdev_queue_mgmt_ops {
> >         size_t  ndo_queue_mem_size;
> > +       void    (*ndo_queue_cfg_defaults)(struct net_device *dev,
> > +                                         int idx,
> > +                                         struct netdev_queue_config *q=
cfg);
> >         int     (*ndo_queue_mem_alloc)(struct net_device *dev,
> > +                                      struct netdev_queue_config *qcfg=
,
> >                                        void *per_queue_mem,
> >                                        int idx);
> >         void    (*ndo_queue_mem_free)(struct net_device *dev,
> >                                       void *per_queue_mem);
> >         int     (*ndo_queue_start)(struct net_device *dev,
> > +                                  struct netdev_queue_config *qcfg,
> >                                    void *per_queue_mem,
> >                                    int idx);
> >         int     (*ndo_queue_stop)(struct net_device *dev,
> > @@ -166,6 +182,9 @@ struct netdev_queue_mgmt_ops {
> >                                   int idx);
> >  };
> >
> > +void netdev_queue_config(struct net_device *dev, int rxq,
> > +                        struct netdev_queue_config *qcfg);
> > +
> >  /**
> >   * DOC: Lockless queue stopping / waking helpers.
> >   *
> > diff --git a/net/core/dev.h b/net/core/dev.h
> > index 7041c8bd2a0f..a553a0f1f846 100644
> > --- a/net/core/dev.h
> > +++ b/net/core/dev.h
> > @@ -9,6 +9,7 @@
> >  #include <net/netdev_lock.h>
> >
> >  struct net;
> > +struct netdev_queue_config;
> >  struct netlink_ext_ack;
> >  struct cpumask;
> >
> > @@ -96,6 +97,8 @@ int netdev_alloc_config(struct net_device *dev);
> >  void __netdev_free_config(struct netdev_config *cfg);
> >  void netdev_free_config(struct net_device *dev);
> >  int netdev_reconfig_start(struct net_device *dev);
> > +void __netdev_queue_config(struct net_device *dev, int rxq,
> > +                          struct netdev_queue_config *qcfg, bool pendi=
ng);
> >
> >  /* netdev management, shared between various uAPI entry points */
> >  struct netdev_name_node {
> > diff --git a/net/core/netdev_config.c b/net/core/netdev_config.c
> > index 270b7f10a192..bad2d53522f0 100644
> > --- a/net/core/netdev_config.c
> > +++ b/net/core/netdev_config.c
> > @@ -8,18 +8,29 @@
> >  int netdev_alloc_config(struct net_device *dev)
> >  {
> >         struct netdev_config *cfg;
> > +       unsigned int maxqs;
> >
> >         cfg =3D kzalloc(sizeof(*dev->cfg), GFP_KERNEL_ACCOUNT);
> >         if (!cfg)
> >                 return -ENOMEM;
> >
> > +       maxqs =3D max(dev->num_rx_queues, dev->num_tx_queues);
>
> I honestly did not think about tx queues at all for the queue api thus
> far. The ndos do specify that api applies to rx queues, and maybe the
> driver only implemented them to assume indeed the calls are to rx
> queues. Are you intentionally extending the queue api support for tx
> queues? Or maybe you're allocing configs for the tx queues to be used
> in some future?
>
> Other places in this patch series uses num_rx_queues directly. Feels
> like this should do the same.
>
> > +       cfg->qcfg =3D kcalloc(maxqs, sizeof(*cfg->qcfg), GFP_KERNEL_ACC=
OUNT);
> > +       if (!cfg->qcfg)
> > +               goto err_free_cfg;
> > +
> >         dev->cfg =3D cfg;
> >         dev->cfg_pending =3D cfg;
> >         return 0;
> > +
> > +err_free_cfg:
> > +       kfree(cfg);
> > +       return -ENOMEM;
> >  }
> >
> >  void __netdev_free_config(struct netdev_config *cfg)
> >  {
> > +       kfree(cfg->qcfg);
> >         kfree(cfg);
> >  }
> >
> > @@ -32,12 +43,59 @@ void netdev_free_config(struct net_device *dev)
> >  int netdev_reconfig_start(struct net_device *dev)
> >  {
> >         struct netdev_config *cfg;
> > +       unsigned int maxqs;
> >
> >         WARN_ON(dev->cfg !=3D dev->cfg_pending);
> >         cfg =3D kmemdup(dev->cfg, sizeof(*dev->cfg), GFP_KERNEL_ACCOUNT=
);
> >         if (!cfg)
> >                 return -ENOMEM;
> >
> > +       maxqs =3D max(dev->num_rx_queues, dev->num_tx_queues);
> > +       cfg->qcfg =3D kmemdup_array(dev->cfg->qcfg, maxqs, sizeof(*cfg-=
>qcfg),
> > +                                 GFP_KERNEL_ACCOUNT);
> > +       if (!cfg->qcfg)
> > +               goto err_free_cfg;
> > +
> >         dev->cfg_pending =3D cfg;
> >         return 0;
> > +
> > +err_free_cfg:
> > +       kfree(cfg);
> > +       return -ENOMEM;
> > +}
> > +
> > +void __netdev_queue_config(struct net_device *dev, int rxq,
> > +                          struct netdev_queue_config *qcfg, bool pendi=
ng)
> > +{
> > +       memset(qcfg, 0, sizeof(*qcfg));
> > +
>
> This memset 0 is wrong for queue configs like hds_thresh where 0 is a
> value, not 'restore default'.
>
> Either netdev_queue_config needs to have a comment that says 'only
> values where 0 is restore default is allowed in this struct', or this
> function needs to handle 0-as-value configs correctly.
>
> But I wonder if the memset(0) is wrong in general. Isn't this helper
> trying to grab the _current_ configuration? So qcfg should be seeded
> with appropriate value from dev->qcfgs[rxq]? This function reads like
> it's trying to get the default configuration, but in a way that
> doesn't handle hds_thresh style semantics correctly?
>

Nevermind this comment, a close review of patch 18 answered this
question actually. You are indeed grabbing the configuration from
dev->qcfgs[rxq], you're just not doing it here because
netdev_queue_config is empty.

--=20
Thanks,
Mina

