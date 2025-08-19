Return-Path: <io-uring+bounces-9086-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FC88B2CF6D
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 00:36:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96BEE172F9F
	for <lists+io-uring@lfdr.de>; Tue, 19 Aug 2025 22:36:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62B572288F7;
	Tue, 19 Aug 2025 22:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lm/XcDib"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2081C1E835D
	for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 22:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755642983; cv=none; b=Esw1eNEYWKUoJR9SChv/PiGJYFbjjZKDXgZwaY0pCzR2R3vIk1UDVtFbZxjsK9GT2Xq59xZc3ZeXaVMcqPPnNh91MZA+OOMoslvzwnbu4/6ZgK6l1p1DO75uDApZpEj3KOIw47my9crT/NPwEwzdMpDTxXhFVIHM4iWA5iBeg1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755642983; c=relaxed/simple;
	bh=dRzOSEjJNnWSsSayXPVOy15UVRxM0CmzVUqVNpoZXPo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UPfZ2mAFGWfXAcebFfbxd1g2s7Qlo4EEwxkuFJJ5WwgQcEyu6bD6g3R4Nkp5CvoBHNPIgCfOFW+PKrXWbM1kUNklvJt2qNpcUr5Q/BhvGBKU9FKq0Q92xVEVSyRO2MAOuGXiRbi0mTGEuUYYX1PvUTokcqKA8K2M8e5ZOwfdHUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lm/XcDib; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-55cef2f624fso837e87.1
        for <io-uring@vger.kernel.org>; Tue, 19 Aug 2025 15:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755642977; x=1756247777; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8gy2AN2/SkyT3RSY5JewoNosnXqqdYkXuYDooCYhRao=;
        b=Lm/XcDibtKL6C793b1bToiF42deS+87jmEOUi73MQamsxAFOiEdququT4no3cSR/LU
         bxKUNyDQqUitZRdm3ZNqL04uxhjrIxrDtD7vzlBbHvUHBznH61ZSKTA/pK8dVWht474a
         5Pjkyft+INaN9N0EEZp35f5B/jRi35x/pkbBAPOix91GIkHkr0EybU4kmY6QkFKrrBGD
         Z9QZQ0Xl8t4HuVVqj6PAitT7zDsR9qtmqxBE/bu6wg46hbvmb4RgPeF0CVft5PoD1xQm
         gHg+IITI2zOj2NMz91pyoNrvKIvBQnszXREGeDYt5vh97/Jvqj68d91uow9Dj9KQPLAs
         S1tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755642977; x=1756247777;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8gy2AN2/SkyT3RSY5JewoNosnXqqdYkXuYDooCYhRao=;
        b=HECBltr1bod+EaKV08Q1Sj+aYUvbLzf3JR1crZJVhwgaHE3rNvWt9o8VfG0rkREufs
         DIdtfobyOYTObUt89sAJfxBMwGjwV9Jove+CfTBqt33BnVzavHGalxypeS8xmXBmLrO0
         2A0+5zu7P5nSLfmDOJLMtF8F7z8e62K4WIE5rOT1Q6NomzSPzrquPd7BgJEjfkqMQ6wT
         pFUrP0rj9XDyUKrPiTUjEY/2PE9qUF1cSXbPAnyr0Y0Lqx9nfsQS4ks8F8wcMfcOfNIu
         kZYOwMysHpa2mYU2GaFYCFh74UTaxEFacCPFl0zLzUZag6SgZypQyDQol3GYXp0vdEbQ
         BEMg==
X-Forwarded-Encrypted: i=1; AJvYcCWTpmEhm6cGs5WGaHMTEv9lmZx2taJPpABGU+za43lcTj6PNAO7ngpI0N3yyt/+OKvJdN9KKB+TWQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzAZ1udYL3yB+vTx+Mlla05gGs0jY2WF5amGkxCWru9HaSQSn+6
	EkS6FuwEykd6+yhopsqu9eRc6BS+dmSN7sKhUCAZSlZnYHIPAg3d+yyxFasCuu0b8R9qhUuARFB
	yRq8DFOXsVPpArlnsdvngNFn2Mlsmaq3i8Fv2WrO5
X-Gm-Gg: ASbGncueST/DHWu5NlerU8+3JIIS2fbJMm0Kuw5LYKDjoSbkFG7hHr9Vb9tFJsxoimU
	d2U0KX6lA0pK0aGkFDsf2mnW2XdXtSj3OtbUkglB/CC7hHW41/W+/ea9MVQaHEUqVqTCceKGFJz
	GgKkSKU4GeXZxNRf66eqU2GpnJ+rMe2wTDKmqlatkv9gjhq+SnulnZKTbDgji3gSnckh93DC01o
	2oIUXyCfFjTJ6IjxES8LK/osuCy2JBZdDbjSNzNwAGu0BbkJ5xK/Ic=
X-Google-Smtp-Source: AGHT+IFcfgUO5wNolp6fFZvfOutvnpWwDp4dgvVZwk+86PQtZHdROgAzzyI23tJg8r+BWXatK9+8tHaza3rQxzNK+58=
X-Received: by 2002:ac2:5e36:0:b0:55b:7c73:c5f0 with SMTP id
 2adb3069b0e04-55e06752de0mr81825e87.2.1755642976845; Tue, 19 Aug 2025
 15:36:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1755499375.git.asml.silence@gmail.com> <5273e2bf83c1f22a6448363b5a51ec85854f03d6.1755499376.git.asml.silence@gmail.com>
In-Reply-To: <5273e2bf83c1f22a6448363b5a51ec85854f03d6.1755499376.git.asml.silence@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 19 Aug 2025 15:36:04 -0700
X-Gm-Features: Ac12FXwatsWO-HP9hZX1u9ho5Xx8_97189DUAz2yzlhIMmP7QDO9LFBhuYeUVNs
Message-ID: <CAHS8izNjZEZLqpXFNjFKQy8ngB8qOdSYVe_pG_vggS8iPGJvVg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 18/23] netdev: add support for setting
 rx-buf-len per queue
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org, 
	davem@davemloft.net, sdf@fomichev.me, dw@davidwei.uk, 
	michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2025 at 6:57=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> From: Jakub Kicinski <kuba@kernel.org>
>
> Zero-copy APIs increase the cost of buffer management. They also extend
> this cost to user space applications which may be used to dealing with
> much larger buffers. Allow setting rx-buf-len per queue, devices with
> HW-GRO support can commonly fill buffers up to 32k (or rather 64k - 1
> but that's not a power of 2..)
>
> The implementation adds a new option to the netdev netlink, rather
> than ethtool. The NIC-wide setting lives in ethtool ringparams so
> one could argue that we should be extending the ethtool API.
> OTOH netdev API is where we already have queue-get, and it's how
> zero-copy applications bind memory providers.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  Documentation/netlink/specs/netdev.yaml | 15 ++++
>  include/net/netdev_queues.h             |  5 ++
>  include/net/netlink.h                   | 19 +++++
>  include/uapi/linux/netdev.h             |  2 +
>  net/core/netdev-genl-gen.c              | 15 ++++
>  net/core/netdev-genl-gen.h              |  1 +
>  net/core/netdev-genl.c                  | 92 +++++++++++++++++++++++++
>  net/core/netdev_config.c                | 16 +++++
>  tools/include/uapi/linux/netdev.h       |  2 +
>  9 files changed, 167 insertions(+)
>
> diff --git a/Documentation/netlink/specs/netdev.yaml b/Documentation/netl=
ink/specs/netdev.yaml
> index c035dc0f64fd..498c4bcafdbd 100644
> --- a/Documentation/netlink/specs/netdev.yaml
> +++ b/Documentation/netlink/specs/netdev.yaml
> @@ -338,6 +338,10 @@ attribute-sets:
>          doc: XSK information for this queue, if any.
>          type: nest
>          nested-attributes: xsk-info
> +      -
> +        name: rx-buf-len
> +        doc: Per-queue configuration of ETHTOOL_A_RINGS_RX_BUF_LEN.
> +        type: u32
>    -
>      name: qstats
>      doc: |
> @@ -771,6 +775,17 @@ operations:
>          reply:
>            attributes:
>              - id
> +    -
> +      name: queue-set
> +      doc: Set per-queue configurable options.
> +      attribute-set: queue
> +      do:
> +        request:
> +          attributes:
> +            - ifindex
> +            - type
> +            - id
> +            - rx-buf-len
>
>  kernel-family:
>    headers: ["net/netdev_netlink.h"]
> diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
> index d0cc475ec51e..b69b1d519dcb 100644
> --- a/include/net/netdev_queues.h
> +++ b/include/net/netdev_queues.h
> @@ -39,6 +39,7 @@ struct netdev_config {
>
>  /* Same semantics as fields in struct netdev_config */
>  struct netdev_queue_config {
> +       u32     rx_buf_len;
>  };
>
>  /* See the netdev.yaml spec for definition of each statistic */
> @@ -141,6 +142,8 @@ void netdev_stat_queue_sum(struct net_device *netdev,
>  /**
>   * struct netdev_queue_mgmt_ops - netdev ops for queue management
>   *
> + * @supported_ring_params: ring params supported per queue (ETHTOOL_RING=
_USE_*).
> + *

Not necessarily a problem, but note that if you depend on
ETHTOOL_RING_USE_*, then queue configs need to also be ethtool
configs, which means they need to also be NIC wide configs. Maybe
that's a plus in your eyes. I wonder if ever we're going to be in a
situation where some config makes sense per queue, but not per NIC.
mem providers are already that sorta.

>   * @ndo_queue_mem_size: Size of the struct that describes a queue's memo=
ry.
>   *
>   * @ndo_queue_cfg_defaults: (Optional) Populate queue config struct with
> @@ -171,6 +174,8 @@ void netdev_stat_queue_sum(struct net_device *netdev,
>   * be called for an interface which is open.
>   */
>  struct netdev_queue_mgmt_ops {
> +       u32     supported_ring_params;
> +
>         size_t  ndo_queue_mem_size;
>         void    (*ndo_queue_cfg_defaults)(struct net_device *dev,
>                                           int idx,
> diff --git a/include/net/netlink.h b/include/net/netlink.h
> index 1a8356ca4b78..29989ad81ddd 100644
> --- a/include/net/netlink.h
> +++ b/include/net/netlink.h
> @@ -2200,6 +2200,25 @@ static inline struct nla_bitfield32 nla_get_bitfie=
ld32(const struct nlattr *nla)
>         return tmp;
>  }
>
> +/**
> + * nla_update_u32() - update u32 value from NLA_U32 attribute
> + * @dst:  value to update
> + * @attr: netlink attribute with new value or null
> + *
> + * Copy the u32 value from NLA_U32 netlink attribute @attr into variable
> + * pointed to by @dst; do nothing if @attr is null.
> + *
> + * Return: true if this function changed the value of @dst, otherwise fa=
lse.
> + */
> +static inline bool nla_update_u32(u32 *dst, const struct nlattr *attr)
> +{
> +       u32 old_val =3D *dst;
> +
> +       if (attr)
> +               *dst =3D nla_get_u32(attr);
> +       return *dst !=3D old_val;
> +}
> +
>  /**
>   * nla_memdup - duplicate attribute memory (kmemdup)
>   * @src: netlink attribute to duplicate from
> diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
> index 48eb49aa03d4..820f89b67a72 100644
> --- a/include/uapi/linux/netdev.h
> +++ b/include/uapi/linux/netdev.h
> @@ -158,6 +158,7 @@ enum {
>         NETDEV_A_QUEUE_DMABUF,
>         NETDEV_A_QUEUE_IO_URING,
>         NETDEV_A_QUEUE_XSK,
> +       NETDEV_A_QUEUE_RX_BUF_LEN,
>
>         __NETDEV_A_QUEUE_MAX,
>         NETDEV_A_QUEUE_MAX =3D (__NETDEV_A_QUEUE_MAX - 1)
> @@ -226,6 +227,7 @@ enum {
>         NETDEV_CMD_BIND_RX,
>         NETDEV_CMD_NAPI_SET,
>         NETDEV_CMD_BIND_TX,
> +       NETDEV_CMD_QUEUE_SET,
>
>         __NETDEV_CMD_MAX,
>         NETDEV_CMD_MAX =3D (__NETDEV_CMD_MAX - 1)
> diff --git a/net/core/netdev-genl-gen.c b/net/core/netdev-genl-gen.c
> index e9a2a6f26cb7..d053306a3af8 100644
> --- a/net/core/netdev-genl-gen.c
> +++ b/net/core/netdev-genl-gen.c
> @@ -106,6 +106,14 @@ static const struct nla_policy netdev_bind_tx_nl_pol=
icy[NETDEV_A_DMABUF_FD + 1]
>         [NETDEV_A_DMABUF_FD] =3D { .type =3D NLA_U32, },
>  };
>
> +/* NETDEV_CMD_QUEUE_SET - do */
> +static const struct nla_policy netdev_queue_set_nl_policy[NETDEV_A_QUEUE=
_RX_BUF_LEN + 1] =3D {
> +       [NETDEV_A_QUEUE_IFINDEX] =3D NLA_POLICY_MIN(NLA_U32, 1),
> +       [NETDEV_A_QUEUE_TYPE] =3D NLA_POLICY_MAX(NLA_U32, 1),
> +       [NETDEV_A_QUEUE_ID] =3D { .type =3D NLA_U32, },
> +       [NETDEV_A_QUEUE_RX_BUF_LEN] =3D { .type =3D NLA_U32, },
> +};
> +
>  /* Ops table for netdev */
>  static const struct genl_split_ops netdev_nl_ops[] =3D {
>         {
> @@ -204,6 +212,13 @@ static const struct genl_split_ops netdev_nl_ops[] =
=3D {
>                 .maxattr        =3D NETDEV_A_DMABUF_FD,
>                 .flags          =3D GENL_CMD_CAP_DO,
>         },
> +       {
> +               .cmd            =3D NETDEV_CMD_QUEUE_SET,
> +               .doit           =3D netdev_nl_queue_set_doit,
> +               .policy         =3D netdev_queue_set_nl_policy,
> +               .maxattr        =3D NETDEV_A_QUEUE_RX_BUF_LEN,
> +               .flags          =3D GENL_CMD_CAP_DO,
> +       },
>  };
>
>  static const struct genl_multicast_group netdev_nl_mcgrps[] =3D {
> diff --git a/net/core/netdev-genl-gen.h b/net/core/netdev-genl-gen.h
> index cf3fad74511f..b7f5e5d9fca9 100644
> --- a/net/core/netdev-genl-gen.h
> +++ b/net/core/netdev-genl-gen.h
> @@ -35,6 +35,7 @@ int netdev_nl_qstats_get_dumpit(struct sk_buff *skb,
>  int netdev_nl_bind_rx_doit(struct sk_buff *skb, struct genl_info *info);
>  int netdev_nl_napi_set_doit(struct sk_buff *skb, struct genl_info *info)=
;
>  int netdev_nl_bind_tx_doit(struct sk_buff *skb, struct genl_info *info);
> +int netdev_nl_queue_set_doit(struct sk_buff *skb, struct genl_info *info=
);
>
>  enum {
>         NETDEV_NLGRP_MGMT,
> diff --git a/net/core/netdev-genl.c b/net/core/netdev-genl.c
> index 6314eb7bdf69..abb128e45fcf 100644
> --- a/net/core/netdev-genl.c
> +++ b/net/core/netdev-genl.c
> @@ -386,6 +386,30 @@ static int nla_put_napi_id(struct sk_buff *skb, cons=
t struct napi_struct *napi)
>         return 0;
>  }
>
> +static int
> +netdev_nl_queue_fill_cfg(struct sk_buff *rsp, struct net_device *netdev,
> +                        u32 q_idx, u32 q_type)
> +{
> +       struct netdev_queue_config *qcfg;
> +
> +       if (!netdev_need_ops_lock(netdev))
> +               return 0;
> +

Why are we checking this? I don't see this function doing any locking.

> +       qcfg =3D &netdev->cfg->qcfg[q_idx];
> +       switch (q_type) {
> +       case NETDEV_QUEUE_TYPE_RX:
> +               if (qcfg->rx_buf_len &&
> +                   nla_put_u32(rsp, NETDEV_A_QUEUE_RX_BUF_LEN,
> +                               qcfg->rx_buf_len))
> +                       return -EMSGSIZE;
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       return 0;
> +}
> +
>  static int
>  netdev_nl_queue_fill_one(struct sk_buff *rsp, struct net_device *netdev,
>                          u32 q_idx, u32 q_type, const struct genl_info *i=
nfo)
> @@ -433,6 +457,9 @@ netdev_nl_queue_fill_one(struct sk_buff *rsp, struct =
net_device *netdev,
>                 break;
>         }
>
> +       if (netdev_nl_queue_fill_cfg(rsp, netdev, q_idx, q_type))
> +               goto nla_put_failure;
> +
>         genlmsg_end(rsp, hdr);
>
>         return 0;
> @@ -572,6 +599,71 @@ int netdev_nl_queue_get_dumpit(struct sk_buff *skb, =
struct netlink_callback *cb)
>         return err;
>  }
>
> +int netdev_nl_queue_set_doit(struct sk_buff *skb, struct genl_info *info=
)
> +{
> +       struct nlattr * const *tb =3D info->attrs;
> +       struct netdev_queue_config *qcfg;
> +       u32 q_id, q_type, ifindex;
> +       struct net_device *netdev;
> +       bool mod;
> +       int ret;
> +
> +       if (GENL_REQ_ATTR_CHECK(info, NETDEV_A_QUEUE_ID) ||
> +           GENL_REQ_ATTR_CHECK(info, NETDEV_A_QUEUE_TYPE) ||
> +           GENL_REQ_ATTR_CHECK(info, NETDEV_A_QUEUE_IFINDEX))
> +               return -EINVAL;
> +
> +       q_id =3D nla_get_u32(tb[NETDEV_A_QUEUE_ID]);
> +       q_type =3D nla_get_u32(tb[NETDEV_A_QUEUE_TYPE]);
> +       ifindex =3D nla_get_u32(tb[NETDEV_A_QUEUE_IFINDEX]);
> +
> +       if (q_type !=3D NETDEV_QUEUE_TYPE_RX) {
> +               /* Only Rx params exist right now */
> +               NL_SET_BAD_ATTR(info->extack, tb[NETDEV_A_QUEUE_TYPE]);
> +               return -EINVAL;
> +       }
> +
> +       ret =3D 0;
> +       netdev =3D netdev_get_by_index_lock(genl_info_net(info), ifindex)=
;
> +       if (!netdev || !netif_device_present(netdev))
> +               ret =3D -ENODEV;
> +       else if (!netdev->queue_mgmt_ops)
> +               ret =3D -EOPNOTSUPP;
> +       if (ret) {
> +               NL_SET_BAD_ATTR(info->extack, tb[NETDEV_A_QUEUE_IFINDEX])=
;
> +               goto exit_unlock;
> +       }
> +
> +       ret =3D netdev_nl_queue_validate(netdev, q_id, q_type);
> +       if (ret) {
> +               NL_SET_BAD_ATTR(info->extack, tb[NETDEV_A_QUEUE_ID]);
> +               goto exit_unlock;
> +       }
> +
> +       ret =3D netdev_reconfig_start(netdev);
> +       if (ret)
> +               goto exit_unlock;
> +
> +       qcfg =3D &netdev->cfg_pending->qcfg[q_id];
> +       mod =3D nla_update_u32(&qcfg->rx_buf_len, tb[NETDEV_A_QUEUE_RX_BU=
F_LEN]);

Don't you need to check the queue_mgmt_ops->supported_thingy first to
know that this driver actually supports modifying rx_buf_len?

> +       if (!mod)
> +               goto exit_free_cfg;
> +
> +       ret =3D netdev_rx_queue_restart(netdev, q_id, info->extack);
> +       if (ret)
> +               goto exit_free_cfg;
> +
> +       swap(netdev->cfg, netdev->cfg_pending);
> +
> +exit_free_cfg:
> +       __netdev_free_config(netdev->cfg_pending);
> +       netdev->cfg_pending =3D netdev->cfg;
> +exit_unlock:
> +       if (netdev)
> +               netdev_unlock(netdev);
> +       return ret;
> +}
> +
>  #define NETDEV_STAT_NOT_SET            (~0ULL)
>
>  static void netdev_nl_stats_add(void *_sum, const void *_add, size_t siz=
e)
> diff --git a/net/core/netdev_config.c b/net/core/netdev_config.c
> index fc700b77e4eb..ede02b77470e 100644
> --- a/net/core/netdev_config.c
> +++ b/net/core/netdev_config.c
> @@ -67,11 +67,27 @@ int netdev_reconfig_start(struct net_device *dev)
>  void __netdev_queue_config(struct net_device *dev, int rxq,
>                            struct netdev_queue_config *qcfg, bool pending=
)
>  {
> +       const struct netdev_config *cfg;
> +
> +       cfg =3D pending ? dev->cfg_pending : dev->cfg;
> +
>         memset(qcfg, 0, sizeof(*qcfg));
>
>         /* Get defaults from the driver, in case user config not set */
>         if (dev->queue_mgmt_ops->ndo_queue_cfg_defaults)
>                 dev->queue_mgmt_ops->ndo_queue_cfg_defaults(dev, rxq, qcf=
g);
> +
> +       /* Set config based on device-level settings */
> +       if (cfg->rx_buf_len)
> +               qcfg->rx_buf_len =3D cfg->rx_buf_len;
> +
> +       /* Set config dedicated to this queue */
> +       if (rxq >=3D 0) {
> +               const struct netdev_queue_config *user_cfg =3D &cfg->qcfg=
[rxq];
> +
> +               if (user_cfg->rx_buf_len)
> +                       qcfg->rx_buf_len =3D user_cfg->rx_buf_len;
> +       }
>  }
>
>  /**
> diff --git a/tools/include/uapi/linux/netdev.h b/tools/include/uapi/linux=
/netdev.h
> index 48eb49aa03d4..820f89b67a72 100644
> --- a/tools/include/uapi/linux/netdev.h
> +++ b/tools/include/uapi/linux/netdev.h
> @@ -158,6 +158,7 @@ enum {
>         NETDEV_A_QUEUE_DMABUF,
>         NETDEV_A_QUEUE_IO_URING,
>         NETDEV_A_QUEUE_XSK,
> +       NETDEV_A_QUEUE_RX_BUF_LEN,
>
>         __NETDEV_A_QUEUE_MAX,
>         NETDEV_A_QUEUE_MAX =3D (__NETDEV_A_QUEUE_MAX - 1)
> @@ -226,6 +227,7 @@ enum {
>         NETDEV_CMD_BIND_RX,
>         NETDEV_CMD_NAPI_SET,
>         NETDEV_CMD_BIND_TX,
> +       NETDEV_CMD_QUEUE_SET,
>
>         __NETDEV_CMD_MAX,
>         NETDEV_CMD_MAX =3D (__NETDEV_CMD_MAX - 1)
> --
> 2.49.0
>


--=20
Thanks,
Mina

