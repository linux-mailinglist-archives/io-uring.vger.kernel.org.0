Return-Path: <io-uring+bounces-7870-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D30F8AACA99
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 18:14:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38F8D17D57E
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 16:14:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48A4F284677;
	Tue,  6 May 2025 16:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="VolozZ25"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0556F28368F
	for <io-uring@vger.kernel.org>; Tue,  6 May 2025 16:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746548038; cv=none; b=DpBsPMKNyqIYjm9EWGN5uLHrQz1Hjs/YfH/lk1boblElhkZTITzSy+1AuhFjHW8o1RUP5Y4AUBAzq/QfasN7xawwrJ9WaXZNAH4Ly6hkpCr7Y+VJGL2JoZndlxd9DmcA+XYM0+iVmAA3fi5PbkuLltUhQY/hjHhvEnDLuSmTTYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746548038; c=relaxed/simple;
	bh=ctEJGduRkC2qEEhy+2LbPD9UxeStYYphXNtfefVEQbY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EK/v8Rm80RK0iQIyPhwSSI01eOd3d4Vp62+9aY0nVyEEG117sxEr2/Yz3U34l+tqjjKB6QS/ryGic4clnadKJfz+CoODSUIbSb/z3eBZ/BDb0K/LulQdZm/efM5T1YRxWk30SboZYPNtzE4ma+Cini3jmXD0dNFCg8p2ZfvFH5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=VolozZ25; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b0ec7f3a205so336948a12.3
        for <io-uring@vger.kernel.org>; Tue, 06 May 2025 09:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1746548035; x=1747152835; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LYWN5cRoGfT1PfSiqnzPsV4NQG6bqVTjCaW1CwrUJcM=;
        b=VolozZ256Rjn+7z/1yPNGVRV2dWyQz7KeNP+GPWRI27v7l4LDHNdarr+IO0roMDhHi
         QJdN8FpiAfP2cIMaWWfIOx1P+BKxoaWixKq3Aaqu1lDJtYG0K3A9R6HUrxLRFnvsFmQ/
         l97DHLF1PzselBbPbVyqge5o2j+gwG3be5QV7bNmpkCz74aVyO5MrjE5wM3hLpgtWb6P
         tePYqkt++pdXtZvhk9BSjDwB3Haxpyqa61aYdBPKs5xQ+0gNdnOXAfCieurCoi9VZaEU
         3p9/ySYSXXjLvGB0FZE7Z8O29F0Uqc7ogumV9jWtsRTgx9c1ZnPXxL1FXY74hgnoP01c
         qO+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746548035; x=1747152835;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LYWN5cRoGfT1PfSiqnzPsV4NQG6bqVTjCaW1CwrUJcM=;
        b=glf7yvGqk0q695iCSKRmAccznqRBjUMmH4cNkb9GZLGvXQvhWLqTAGmNh6WMNHInIU
         vhG5uASsqZM1bE6zZFPxfxvJ/c0R5ZgEiijEsQDrO0NmxRPPCo3xuMnPQQddj6VGsQ2F
         5S31qj38KO2QgeoaVWOK+7qsDswA4Kmg04MEEvk6CVP0VUybzHPAWboxyOnZz6jCv4EN
         286gCV/gmXxZDT2NTg0Uqx5Z3Xp7/GeDc3v55Wyqi9lAHyDyAyBHoQ6BAlxqGEDuQP2l
         cUkf+EIodKHbu08Y4/GdXhfq+yF7gMedHzDI9YWkQoBk0rBp9MH6T7FSD3dPUZNW/41F
         /YLw==
X-Forwarded-Encrypted: i=1; AJvYcCUila8e1OTDu0N9kCUzp787g41PTibmLOH6kMp5Uj8ufj7CoVfQzAp5utmFrF2QgK8ReqxFv43PyA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyWfHASfXwKi54ZONK01mhEsezMCMH1rqLa7hLpgyl5TUfK1Fs6
	W5OisDqk79wsYMkPiVHgF1mB9ti7J9Us+kHuU+5dqTpnx55Jj+krrQ738N1duxJ6wUx2WznJvXv
	PYZGz4DDWQzWzTUIJtiXhYwGH3DG8pFYCb5CEdA==
X-Gm-Gg: ASbGnctR7RsYkwdbUKsa8gjeypgPF3NFSJd4JPNXPCPmFWRz68LgRoYfJaI3uim6mLm
	PeMbwBz5i0yuZ+4tdR0u10PT3upGCQU74bYJFty+3uIpT/bdgZfbG/E+Ay+6XTZOiXukgQvZWaG
	ZnYXHwG0QTAy5uK6VjEQY6
X-Google-Smtp-Source: AGHT+IGOvJyPbLr4kwXZSGT/2CsH/jVCIq02WBu70npsFnHamIQl6sWwQf+KO12hU6AkAJPFapxgBzCBfCm4l5n/zjI=
X-Received: by 2002:a17:90b:33c1:b0:2ff:5759:549a with SMTP id
 98e67ed59e1d1-30aac16c2e2mr36846a91.1.1746548035169; Tue, 06 May 2025
 09:13:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20250506122651epcas5p4100fd5435ce6e6686318265b414c1176@epcas5p4.samsung.com>
 <20250506121732.8211-1-joshi.k@samsung.com> <20250506121732.8211-11-joshi.k@samsung.com>
In-Reply-To: <20250506121732.8211-11-joshi.k@samsung.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 6 May 2025 09:13:33 -0700
X-Gm-Features: ATxdqUE6maBvoXv4TdPf4qTULxuJw6-FSb-pKV6qaK5B-HKqjYsETzXEW4MddQU
Message-ID: <CADUfDZqqqQVHqMpVaMWre1=GZfu42_SOQ5W9m0vhSZYyp1BBUA@mail.gmail.com>
Subject: Re: [PATCH v16 10/11] nvme: register fdp parameters with the block layer
To: Kanchan Joshi <joshi.k@samsung.com>
Cc: axboe@kernel.dk, kbusch@kernel.org, hch@lst.de, asml.silence@gmail.com, 
	io-uring@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	Hannes Reinecke <hare@suse.de>, Nitesh Shetty <nj.shetty@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 6, 2025 at 5:31=E2=80=AFAM Kanchan Joshi <joshi.k@samsung.com> =
wrote:
>
> From: Keith Busch <kbusch@kernel.org>
>
> Register the device data placement limits if supported. This is just
> registering the limits with the block layer. Nothing beyond reporting
> these attributes is happening in this patch.
>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  drivers/nvme/host/core.c | 144 +++++++++++++++++++++++++++++++++++++++
>  drivers/nvme/host/nvme.h |   2 +
>  2 files changed, 146 insertions(+)
>
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index dd71b4c2b7b7..f25e03ff03df 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -38,6 +38,8 @@ struct nvme_ns_info {
>         u32 nsid;
>         __le32 anagrpid;
>         u8 pi_offset;
> +       u16 endgid;
> +       u64 runs;
>         bool is_shared;
>         bool is_readonly;
>         bool is_ready;
> @@ -1611,6 +1613,7 @@ static int nvme_ns_info_from_identify(struct nvme_c=
trl *ctrl,
>         info->is_shared =3D id->nmic & NVME_NS_NMIC_SHARED;
>         info->is_readonly =3D id->nsattr & NVME_NS_ATTR_RO;
>         info->is_ready =3D true;
> +       info->endgid =3D le16_to_cpu(id->endgid);
>         if (ctrl->quirks & NVME_QUIRK_BOGUS_NID) {
>                 dev_info(ctrl->device,
>                          "Ignoring bogus Namespace Identifiers\n");
> @@ -1651,6 +1654,7 @@ static int nvme_ns_info_from_id_cs_indep(struct nvm=
e_ctrl *ctrl,
>                 info->is_ready =3D id->nstat & NVME_NSTAT_NRDY;
>                 info->is_rotational =3D id->nsfeat & NVME_NS_ROTATIONAL;
>                 info->no_vwc =3D id->nsfeat & NVME_NS_VWC_NOT_PRESENT;
> +               info->endgid =3D le16_to_cpu(id->endgid);
>         }
>         kfree(id);
>         return ret;
> @@ -2155,6 +2159,132 @@ static int nvme_update_ns_info_generic(struct nvm=
e_ns *ns,
>         return ret;
>  }
>
> +static int nvme_query_fdp_granularity(struct nvme_ctrl *ctrl,
> +                                     struct nvme_ns_info *info, u8 fdp_i=
dx)
> +{
> +       struct nvme_fdp_config_log hdr, *h;
> +       struct nvme_fdp_config_desc *desc;
> +       size_t size =3D sizeof(hdr);
> +       void *log, *end;
> +       int i, n, ret;
> +
> +       ret =3D nvme_get_log_lsi(ctrl, 0, NVME_LOG_FDP_CONFIGS, 0,
> +                              NVME_CSI_NVM, &hdr, size, 0, info->endgid)=
;
> +       if (ret) {
> +               dev_warn(ctrl->device,
> +                        "FDP configs log header status:0x%x endgid:%d\n"=
, ret,
> +                        info->endgid);
> +               return ret;
> +       }
> +
> +       size =3D le32_to_cpu(hdr.sze);
> +       if (size > PAGE_SIZE * MAX_ORDER_NR_PAGES) {
> +               dev_warn(ctrl->device, "FDP config size too large:%zu\n",
> +                        size);
> +               return 0;
> +       }
> +
> +       h =3D kvmalloc(size, GFP_KERNEL);
> +       if (!h)
> +               return -ENOMEM;
> +
> +       ret =3D nvme_get_log_lsi(ctrl, 0, NVME_LOG_FDP_CONFIGS, 0,
> +                              NVME_CSI_NVM, h, size, 0, info->endgid);
> +       if (ret) {
> +               dev_warn(ctrl->device,
> +                        "FDP configs log status:0x%x endgid:%d\n", ret,
> +                        info->endgid);
> +               goto out;
> +       }
> +
> +       n =3D le16_to_cpu(h->numfdpc) + 1;
> +       if (fdp_idx > n) {
> +               dev_warn(ctrl->device, "FDP index:%d out of range:%d\n",
> +                        fdp_idx, n);
> +               /* Proceed without registering FDP streams */
> +               ret =3D 0;
> +               goto out;
> +       }
> +
> +       log =3D h + 1;
> +       desc =3D log;
> +       end =3D log + size - sizeof(*h);
> +       for (i =3D 0; i < fdp_idx; i++) {
> +               log +=3D le16_to_cpu(desc->dsze);
> +               desc =3D log;
> +               if (log >=3D end) {
> +                       dev_warn(ctrl->device,
> +                                "FDP invalid config descriptor list\n");
> +                       ret =3D 0;
> +                       goto out;
> +               }
> +       }
> +
> +       if (le32_to_cpu(desc->nrg) > 1) {
> +               dev_warn(ctrl->device, "FDP NRG > 1 not supported\n");
> +               ret =3D 0;
> +               goto out;
> +       }
> +
> +       info->runs =3D le64_to_cpu(desc->runs);
> +out:
> +       kvfree(h);
> +       return ret;
> +}
> +
> +static int nvme_query_fdp_info(struct nvme_ns *ns, struct nvme_ns_info *=
info)
> +{
> +       struct nvme_ns_head *head =3D ns->head;
> +       struct nvme_ctrl *ctrl =3D ns->ctrl;
> +       struct nvme_fdp_ruh_status *ruhs;
> +       struct nvme_fdp_config fdp;
> +       struct nvme_command c =3D {};
> +       size_t size;
> +       int ret;
> +
> +       /*
> +        * The FDP configuration is static for the lifetime of the namesp=
ace,
> +        * so return immediately if we've already registered this namespa=
ce's
> +        * streams.
> +        */
> +       if (head->nr_plids)
> +               return 0;
> +
> +       ret =3D nvme_get_features(ctrl, NVME_FEAT_FDP, info->endgid, NULL=
, 0,
> +                               &fdp);
> +       if (ret) {
> +               dev_warn(ctrl->device, "FDP get feature status:0x%x\n", r=
et);
> +               return ret;
> +       }
> +
> +       if (!(fdp.flags & FDPCFG_FDPE))
> +               return 0;
> +
> +       ret =3D nvme_query_fdp_granularity(ctrl, info, fdp.fdpcidx);
> +       if (!info->runs)
> +               return ret;
> +
> +       size =3D struct_size(ruhs, ruhsd, S8_MAX - 1);
> +       ruhs =3D kzalloc(size, GFP_KERNEL);
> +       if (!ruhs)
> +               return -ENOMEM;
> +
> +       c.imr.opcode =3D nvme_cmd_io_mgmt_recv;
> +       c.imr.nsid =3D cpu_to_le32(head->ns_id);
> +       c.imr.mo =3D NVME_IO_MGMT_RECV_MO_RUHS;
> +       c.imr.numd =3D cpu_to_le32(nvme_bytes_to_numd(size));
> +       ret =3D nvme_submit_sync_cmd(ns->queue, &c, ruhs, size);
> +       if (ret) {
> +               dev_warn(ctrl->device, "FDP io-mgmt status:0x%x\n", ret);
> +               goto free;
> +       }
> +
> +       head->nr_plids =3D le16_to_cpu(ruhs->nruhsd);
> +free:
> +       kfree(ruhs);
> +       return ret;
> +}
> +
>  static int nvme_update_ns_info_block(struct nvme_ns *ns,
>                 struct nvme_ns_info *info)
>  {
> @@ -2192,6 +2322,12 @@ static int nvme_update_ns_info_block(struct nvme_n=
s *ns,
>                         goto out;
>         }
>
> +       if (ns->ctrl->ctratt & NVME_CTRL_ATTR_FDPS) {
> +               ret =3D nvme_query_fdp_info(ns, info);
> +               if (ret < 0)
> +                       goto out;
> +       }
> +
>         lim =3D queue_limits_start_update(ns->disk->queue);
>
>         memflags =3D blk_mq_freeze_queue(ns->disk->queue);
> @@ -2225,6 +2361,12 @@ static int nvme_update_ns_info_block(struct nvme_n=
s *ns,
>         if (!nvme_init_integrity(ns->head, &lim, info))
>                 capacity =3D 0;
>
> +       lim.max_write_streams =3D ns->head->nr_plids;
> +       if (lim.max_write_streams)
> +               lim.write_stream_granularity =3D max(info->runs, U32_MAX)=
;

What is the purpose of this max(..., U32_MAX)? Should it be min() instead?

Best,
Caleb

> +       else
> +               lim.write_stream_granularity =3D 0;
> +
>         ret =3D queue_limits_commit_update(ns->disk->queue, &lim);
>         if (ret) {
>                 blk_mq_unfreeze_queue(ns->disk->queue, memflags);
> @@ -2328,6 +2470,8 @@ static int nvme_update_ns_info(struct nvme_ns *ns, =
struct nvme_ns_info *info)
>                         ns->head->disk->flags |=3D GENHD_FL_HIDDEN;
>                 else
>                         nvme_init_integrity(ns->head, &lim, info);
> +               lim.max_write_streams =3D ns_lim->max_write_streams;
> +               lim.write_stream_granularity =3D ns_lim->write_stream_gra=
nularity;
>                 ret =3D queue_limits_commit_update(ns->head->disk->queue,=
 &lim);
>
>                 set_capacity_and_notify(ns->head->disk, get_capacity(ns->=
disk));
> diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
> index aedb734283b8..3e14daa4ed3e 100644
> --- a/drivers/nvme/host/nvme.h
> +++ b/drivers/nvme/host/nvme.h
> @@ -496,6 +496,8 @@ struct nvme_ns_head {
>         struct device           cdev_device;
>
>         struct gendisk          *disk;
> +
> +       u16                     nr_plids;
>  #ifdef CONFIG_NVME_MULTIPATH
>         struct bio_list         requeue_list;
>         spinlock_t              requeue_lock;
> --
> 2.25.1
>
>

