Return-Path: <io-uring+bounces-9276-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CD16B3365A
	for <lists+io-uring@lfdr.de>; Mon, 25 Aug 2025 08:24:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A79F168092
	for <lists+io-uring@lfdr.de>; Mon, 25 Aug 2025 06:24:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E71F427F017;
	Mon, 25 Aug 2025 06:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="E6ipFtB/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vk1-f227.google.com (mail-vk1-f227.google.com [209.85.221.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EA823ABBE
	for <io-uring@vger.kernel.org>; Mon, 25 Aug 2025 06:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756103090; cv=none; b=I8RTWGvi26dWtS+Zj5O5KijFTmFiEr92RAF3+Hp95Z3iJ/WRQ/L+mD0UtiKSm8I1hWlfFA7lqGoVsQTC9gjKLZtNdHxhWHj+SC0lRIqbeUGW8ds0t6XGbjHKxPcjRHmzXvW0klOwCkiyyp+8G+sdnV9b/MQ4zebdYHZbUxFxQ+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756103090; c=relaxed/simple;
	bh=CkAx1OKk3n886/wXI5HFbDKwUllz4Q79HFcuSVjyXz8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C2rUExKYqfJ7TaMvzbu557s5aMlmEffDp03zp0Ab3Z0WRzblM1WCzelaK/QPfCgub28YqpVKu68G53Hm73PEGoZbeu/cOTR39WoheJgF/VZ8P8XwcMvnOC12ekBXAJSJ4GnkvSlb9hyZrwyDwDmgJrDyXklUZTt8TIFXfc0ATSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=E6ipFtB/; arc=none smtp.client-ip=209.85.221.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Received: by mail-vk1-f227.google.com with SMTP id 71dfb90a1353d-541f5f63bc9so189442e0c.1
        for <io-uring@vger.kernel.org>; Sun, 24 Aug 2025 23:24:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756103088; x=1756707888;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GdEo+72Jeijta9GbgswIFiFRb3vB6fCqXOUCpJHFBYI=;
        b=XUVPc3KJ9mpKI/17aPGKl5L0G0y8a03h+UGfRBu71dRhTFGgEYT3Wfop/CzG7zr3Of
         PLwjn2TK6ViTuiThqNcwBZ0LlOGgLd1Gsc+NGtRUCRVUZKri7v73cY2kNFiD8F7Np1rC
         4cWGHFvJhvsetgVgL6x4P5ODzguMR8D67jD/KDATzqvH+YZu/2PgAUlfakN1sn8A/qUG
         HAckXIj8g4RIOYakalQAb4tvpDuReltqYkbZvXQIxQ21+sY2FMz72Cm3igwhArcKpzmt
         U3YXCkKsf+QB4fpFLEsaeTkt/xBPUVn1M2DKkrtGRHZjGLw2ntxLCzFXTJn6dSo3RqXI
         /fYA==
X-Forwarded-Encrypted: i=1; AJvYcCU5eLHBA9yLJCWi7UsxG7rqNlzAHXc/vuRCo6DfQq4ORuB3am762rVVIeQrYg5+smJ1b10lXiQDcw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxCICXMaP+HYRmsnUtpnbHNo4XvumyuKsBpPeAhpdQ8XLjgAgyb
	NBGsxOXpuFx+SOaW8SuKtZyPO7SvzXfNWPIPO/gkZDtJ8JbA/ZK1Q1ZkDCTzaB4evKUuXZ+daQD
	LkA44sGODDJATxirUBZJMGRFH15DnkhfbmJrErRdkSit3KG+TbwsSD2nqMmbTYm9N5EpkNnu6ya
	14zkFhcGSNdMt9zNQzGgXKsOBChju0bbF8HaW+nMF8XwE7QxBPP64xM2sGThroF42h4m1KefpVp
	1vsU19bYlzmtNw=
X-Gm-Gg: ASbGncuD12ueb3rbUnYNLhSGLeeRXJ4O3zdRwcz70sc+DFAbCUPNENRg7su1HVtInWN
	XPSBYSKFHmablMfec3xcZWqiV+s40p+sbR3S27grsr7rWU7wwZc29OHYkgHtQNc1BEjzf57fyCV
	f+DWdBfNSkSPx0YYC/KA07iCWYgYeAccI9PXuxEfwJLVzHvGpMyOuTlaMwPFbsKPD3NUg7lUma0
	6dXL1gp5p4pp/U/t1BywU8S9qBLi4yArd2H36Y5+7bgEpiJpzYhQIjdPXirtQoiznMroGX+olBV
	EaK7Zo0WxcR2S5HHJVo898hcWxyLLRekVoGdmaRsc/2X+HgmyemkDKnT2Y9Aq5dRWtuZwKRePAD
	sntyosZrsVNy6lYIsb5xg8R5ue1VN1r2sLTUQQ/XjQMHFiK6GCWEr6Ltnihl2V/suho3Tge+c+B
	/fNGQ=
X-Google-Smtp-Source: AGHT+IGQul9utDLeQ6nb5whG55K6tzu5Y5PWdUzAYyG1SnZcW0RG7rJm6MsMqOJ4w10iKxuSRT72zghzk3Ya
X-Received: by 2002:a05:6122:5210:b0:541:53a0:823 with SMTP id 71dfb90a1353d-54153a00e5emr504072e0c.13.1756103087711;
        Sun, 24 Aug 2025 23:24:47 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-123.dlp.protect.broadcom.com. [144.49.247.123])
        by smtp-relay.gmail.com with ESMTPS id a1e0cc1a2514c-89237391eb5sm125091241.4.2025.08.24.23.24.47
        for <io-uring@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 24 Aug 2025 23:24:47 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-89018ea59e0so6944737241.0
        for <io-uring@vger.kernel.org>; Sun, 24 Aug 2025 23:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1756103087; x=1756707887; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GdEo+72Jeijta9GbgswIFiFRb3vB6fCqXOUCpJHFBYI=;
        b=E6ipFtB/BfJcHRAc30KRalLaYo014WHa9uSCSiNxvSMild137DParpvVOP2YmK9mu9
         iTbvwhqpwDqG0ZB4rGCwp6R17ENyBGo88AlvCqXxGiTd24EPfyM920WfMwksZbwnS0Uq
         beSauH6hEuKZI7jklVaU146oTnIYpQAGnam2c=
X-Forwarded-Encrypted: i=1; AJvYcCXB+wR+AKgDpb4xVPW1/AKaMQv61Hk+9UXKsVD8/hPK3Mc23owiqR97h1G7msvbtsit86jVYu2o4A==@vger.kernel.org
X-Received: by 2002:a05:6102:26c4:b0:522:551b:de8a with SMTP id ada2fe7eead31-522551be1e9mr547649137.15.1756103087110;
        Sun, 24 Aug 2025 23:24:47 -0700 (PDT)
X-Received: by 2002:a05:6102:26c4:b0:522:551b:de8a with SMTP id
 ada2fe7eead31-522551be1e9mr547644137.15.1756103086668; Sun, 24 Aug 2025
 23:24:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1755499375.git.asml.silence@gmail.com> <397938dd32c6465250a137b55944f2ba46c6cc34.1755499376.git.asml.silence@gmail.com>
In-Reply-To: <397938dd32c6465250a137b55944f2ba46c6cc34.1755499376.git.asml.silence@gmail.com>
From: Somnath Kotur <somnath.kotur@broadcom.com>
Date: Mon, 25 Aug 2025 11:54:35 +0530
X-Gm-Features: Ac12FXyl2EixPxg7HMJchmyPpRJt9Ok3Fz-TI7h8PzOk4L8-I4PWchVwgu-OrbI
Message-ID: <CAOBf=mt_3rJHztyncv=hF9nPhz8ZuOJscsyHgz_fapOQ9Twgrg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 16/23] eth: bnxt: store the rx buf size per queue
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, 
	Eric Dumazet <edumazet@google.com>, Willem de Bruijn <willemb@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch, horms@kernel.org, 
	davem@davemloft.net, sdf@fomichev.me, almasrymina@google.com, dw@davidwei.uk, 
	michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000b8f269063d2a9cb6"

--000000000000b8f269063d2a9cb6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2025 at 7:45=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> From: Jakub Kicinski <kuba@kernel.org>
>
> In normal operation only a subset of queues is configured for
> zero-copy. Since zero-copy is the main use for larger buffer
> sizes we need to configure the sizes per queue.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 46 ++++++++++---------
>  drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  1 +
>  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  6 +--
>  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h |  2 +-
>  4 files changed, 30 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethe=
rnet/broadcom/bnxt/bnxt.c
> index 467e8a0745e1..50f663777843 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -900,7 +900,7 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_=
napi *bnapi, int budget)
>
>  static bool bnxt_separate_head_pool(struct bnxt_rx_ring_info *rxr)
>  {
> -       return rxr->need_head_pool || PAGE_SIZE > rxr->bnapi->bp->rx_page=
_size;
> +       return rxr->need_head_pool || PAGE_SIZE > rxr->rx_page_size;
>  }
>
>  static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *ma=
pping,
> @@ -910,9 +910,9 @@ static struct page *__bnxt_alloc_rx_page(struct bnxt =
*bp, dma_addr_t *mapping,
>  {
>         struct page *page;
>
> -       if (PAGE_SIZE > bp->rx_page_size) {
> +       if (PAGE_SIZE > rxr->rx_page_size) {
>                 page =3D page_pool_dev_alloc_frag(rxr->page_pool, offset,
> -                                               bp->rx_page_size);
> +                                               rxr->rx_page_size);
>         } else {
>                 page =3D page_pool_dev_alloc_pages(rxr->page_pool);
>                 *offset =3D 0;
> @@ -1150,9 +1150,9 @@ static struct sk_buff *bnxt_rx_multi_page_skb(struc=
t bnxt *bp,
>                 return NULL;
>         }
>         dma_addr -=3D bp->rx_dma_offset;
> -       dma_sync_single_for_cpu(&bp->pdev->dev, dma_addr, bp->rx_page_siz=
e,
> +       dma_sync_single_for_cpu(&bp->pdev->dev, dma_addr, rxr->rx_page_si=
ze,
>                                 bp->rx_dir);
> -       skb =3D napi_build_skb(data_ptr - bp->rx_offset, bp->rx_page_size=
);
> +       skb =3D napi_build_skb(data_ptr - bp->rx_offset, rxr->rx_page_siz=
e);
>         if (!skb) {
>                 page_pool_recycle_direct(rxr->page_pool, page);
>                 return NULL;
> @@ -1184,7 +1184,7 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt=
 *bp,
>                 return NULL;
>         }
>         dma_addr -=3D bp->rx_dma_offset;
> -       dma_sync_single_for_cpu(&bp->pdev->dev, dma_addr, bp->rx_page_siz=
e,
> +       dma_sync_single_for_cpu(&bp->pdev->dev, dma_addr, rxr->rx_page_si=
ze,
>                                 bp->rx_dir);
>
>         if (unlikely(!payload))
> @@ -1198,7 +1198,7 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt=
 *bp,
>
>         skb_mark_for_recycle(skb);
>         off =3D (void *)data_ptr - page_address(page);
> -       skb_add_rx_frag(skb, 0, page, off, len, bp->rx_page_size);
> +       skb_add_rx_frag(skb, 0, page, off, len, rxr->rx_page_size);
>         memcpy(skb->data - NET_IP_ALIGN, data_ptr - NET_IP_ALIGN,
>                payload + NET_IP_ALIGN);
>
> @@ -1283,7 +1283,7 @@ static u32 __bnxt_rx_agg_netmems(struct bnxt *bp,
>                 if (skb) {
>                         skb_add_rx_frag_netmem(skb, i, cons_rx_buf->netme=
m,
>                                                cons_rx_buf->offset,
> -                                              frag_len, bp->rx_page_size=
);
> +                                              frag_len, rxr->rx_page_siz=
e);
>                 } else {
>                         skb_frag_t *frag =3D &shinfo->frags[i];
>
> @@ -1308,7 +1308,7 @@ static u32 __bnxt_rx_agg_netmems(struct bnxt *bp,
>                         if (skb) {
>                                 skb->len -=3D frag_len;
>                                 skb->data_len -=3D frag_len;
> -                               skb->truesize -=3D bp->rx_page_size;
> +                               skb->truesize -=3D rxr->rx_page_size;
>                         }
>
>                         --shinfo->nr_frags;
> @@ -1323,7 +1323,7 @@ static u32 __bnxt_rx_agg_netmems(struct bnxt *bp,
>                 }
>
>                 page_pool_dma_sync_netmem_for_cpu(rxr->page_pool, netmem,=
 0,
> -                                                 bp->rx_page_size);
> +                                                 rxr->rx_page_size);
>
>                 total_frag_len +=3D frag_len;
>                 prod =3D NEXT_RX_AGG(prod);
> @@ -2276,8 +2276,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt=
_cp_ring_info *cpr,
>                         if (!skb)
>                                 goto oom_next_rx;
>                 } else {
> -                       skb =3D bnxt_xdp_build_skb(bp, skb, agg_bufs,
> -                                                rxr->page_pool, &xdp);
> +                       skb =3D bnxt_xdp_build_skb(bp, skb, agg_bufs, rxr=
, &xdp);
>                         if (!skb) {
>                                 /* we should be able to free the old skb =
here */
>                                 bnxt_xdp_buff_frags_free(rxr, &xdp);
> @@ -3825,7 +3824,7 @@ static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
>         if (BNXT_RX_PAGE_MODE(bp))
>                 pp.pool_size +=3D bp->rx_ring_size / rx_size_fac;
>
> -       pp.order =3D get_order(bp->rx_page_size);
> +       pp.order =3D get_order(rxr->rx_page_size);
>         pp.nid =3D numa_node;
>         pp.netdev =3D bp->dev;
>         pp.dev =3D &bp->pdev->dev;
> @@ -4318,6 +4317,8 @@ static void bnxt_init_ring_struct(struct bnxt *bp)
>                 if (!rxr)
>                         goto skip_rx;
>
> +               rxr->rx_page_size =3D bp->rx_page_size;
> +
>                 ring =3D &rxr->rx_ring_struct;
>                 rmem =3D &ring->ring_mem;
>                 rmem->nr_pages =3D bp->rx_nr_pages;
> @@ -4477,7 +4478,7 @@ static void bnxt_init_one_rx_agg_ring_rxbd(struct b=
nxt *bp,
>         ring =3D &rxr->rx_agg_ring_struct;
>         ring->fw_ring_id =3D INVALID_HW_RING_ID;
>         if ((bp->flags & BNXT_FLAG_AGG_RINGS)) {
> -               type =3D ((u32)bp->rx_page_size << RX_BD_LEN_SHIFT) |
> +               type =3D ((u32)rxr->rx_page_size << RX_BD_LEN_SHIFT) |
>                         RX_BD_TYPE_RX_AGG_BD | RX_BD_FLAGS_SOP;
>
>                 bnxt_init_rxbd_pages(ring, type);
> @@ -7042,6 +7043,7 @@ static void bnxt_hwrm_ring_grp_free(struct bnxt *bp=
)
>
>  static void bnxt_set_rx_ring_params_p5(struct bnxt *bp, u32 ring_type,
>                                        struct hwrm_ring_alloc_input *req,
> +                                      struct bnxt_rx_ring_info *rxr,
>                                        struct bnxt_ring_struct *ring)
>  {
>         struct bnxt_ring_grp_info *grp_info =3D &bp->grp_info[ring->grp_i=
dx];
> @@ -7051,7 +7053,7 @@ static void bnxt_set_rx_ring_params_p5(struct bnxt =
*bp, u32 ring_type,
>         if (ring_type =3D=3D HWRM_RING_ALLOC_AGG) {
>                 req->ring_type =3D RING_ALLOC_REQ_RING_TYPE_RX_AGG;
>                 req->rx_ring_id =3D cpu_to_le16(grp_info->rx_fw_ring_id);
> -               req->rx_buf_size =3D cpu_to_le16(bp->rx_page_size);
> +               req->rx_buf_size =3D cpu_to_le16(rxr->rx_page_size);
>                 enables |=3D RING_ALLOC_REQ_ENABLES_RX_RING_ID_VALID;
>         } else {
>                 req->rx_buf_size =3D cpu_to_le16(bp->rx_buf_use_size);
> @@ -7065,6 +7067,7 @@ static void bnxt_set_rx_ring_params_p5(struct bnxt =
*bp, u32 ring_type,
>  }
>
>  static int hwrm_ring_alloc_send_msg(struct bnxt *bp,
> +                                   struct bnxt_rx_ring_info *rxr,
>                                     struct bnxt_ring_struct *ring,
>                                     u32 ring_type, u32 map_index)
>  {
> @@ -7121,7 +7124,8 @@ static int hwrm_ring_alloc_send_msg(struct bnxt *bp=
,
>                               cpu_to_le32(bp->rx_ring_mask + 1) :
>                               cpu_to_le32(bp->rx_agg_ring_mask + 1);
>                 if (bp->flags & BNXT_FLAG_CHIP_P5_PLUS)
> -                       bnxt_set_rx_ring_params_p5(bp, ring_type, req, ri=
ng);
> +                       bnxt_set_rx_ring_params_p5(bp, ring_type, req,
> +                                                  rxr, ring);
>                 break;
>         case HWRM_RING_ALLOC_CMPL:
>                 req->ring_type =3D RING_ALLOC_REQ_RING_TYPE_L2_CMPL;
> @@ -7269,7 +7273,7 @@ static int bnxt_hwrm_rx_ring_alloc(struct bnxt *bp,
>         u32 map_idx =3D bnapi->index;
>         int rc;
>
> -       rc =3D hwrm_ring_alloc_send_msg(bp, ring, type, map_idx);
> +       rc =3D hwrm_ring_alloc_send_msg(bp, rxr, ring, type, map_idx);
>         if (rc)
>                 return rc;
>
> @@ -7289,7 +7293,7 @@ static int bnxt_hwrm_rx_agg_ring_alloc(struct bnxt =
*bp,
>         int rc;
>
>         map_idx =3D grp_idx + bp->rx_nr_rings;
> -       rc =3D hwrm_ring_alloc_send_msg(bp, ring, type, map_idx);
> +       rc =3D hwrm_ring_alloc_send_msg(bp, rxr, ring, type, map_idx);
>         if (rc)
>                 return rc;
>
> @@ -7313,7 +7317,7 @@ static int bnxt_hwrm_cp_ring_alloc_p5(struct bnxt *=
bp,
>
>         ring =3D &cpr->cp_ring_struct;
>         ring->handle =3D BNXT_SET_NQ_HDL(cpr);
> -       rc =3D hwrm_ring_alloc_send_msg(bp, ring, type, map_idx);
> +       rc =3D hwrm_ring_alloc_send_msg(bp, NULL, ring, type, map_idx);
>         if (rc)
>                 return rc;
>         bnxt_set_db(bp, &cpr->cp_db, type, map_idx, ring->fw_ring_id);
> @@ -7328,7 +7332,7 @@ static int bnxt_hwrm_tx_ring_alloc(struct bnxt *bp,
>         const u32 type =3D HWRM_RING_ALLOC_TX;
>         int rc;
>
> -       rc =3D hwrm_ring_alloc_send_msg(bp, ring, type, tx_idx);
> +       rc =3D hwrm_ring_alloc_send_msg(bp, NULL, ring, type, tx_idx);
>         if (rc)
>                 return rc;
>         bnxt_set_db(bp, &txr->tx_db, type, tx_idx, ring->fw_ring_id);
> @@ -7354,7 +7358,7 @@ static int bnxt_hwrm_ring_alloc(struct bnxt *bp)
>
>                 vector =3D bp->irq_tbl[map_idx].vector;
>                 disable_irq_nosync(vector);
> -               rc =3D hwrm_ring_alloc_send_msg(bp, ring, type, map_idx);
> +               rc =3D hwrm_ring_alloc_send_msg(bp, NULL, ring, type, map=
_idx);
>                 if (rc) {
>                         enable_irq(vector);
>                         goto err_out;
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethe=
rnet/broadcom/bnxt/bnxt.h
> index 56aafae568f8..4f9d4c71c0e2 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> @@ -1107,6 +1107,7 @@ struct bnxt_rx_ring_info {
>
>         unsigned long           *rx_agg_bmap;
>         u16                     rx_agg_bmap_size;
> +       u16                     rx_page_size;
>         bool                    need_head_pool;
>
>         dma_addr_t              rx_desc_mapping[MAX_RX_PAGES];
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/=
ethernet/broadcom/bnxt/bnxt_xdp.c
> index 41d3ba56ba41..19dda0201c69 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> @@ -183,7 +183,7 @@ void bnxt_xdp_buff_init(struct bnxt *bp, struct bnxt_=
rx_ring_info *rxr,
>                         u16 cons, u8 *data_ptr, unsigned int len,
>                         struct xdp_buff *xdp)
>  {
> -       u32 buflen =3D bp->rx_page_size;
> +       u32 buflen =3D rxr->rx_page_size;
>         struct bnxt_sw_rx_bd *rx_buf;
>         struct pci_dev *pdev;
>         dma_addr_t mapping;
> @@ -461,7 +461,7 @@ int bnxt_xdp(struct net_device *dev, struct netdev_bp=
f *xdp)
>
>  struct sk_buff *
>  bnxt_xdp_build_skb(struct bnxt *bp, struct sk_buff *skb, u8 num_frags,
> -                  struct page_pool *pool, struct xdp_buff *xdp)
> +                  struct bnxt_rx_ring_info *rxr, struct xdp_buff *xdp)
>  {
>         struct skb_shared_info *sinfo =3D xdp_get_shared_info_from_buff(x=
dp);
>
> @@ -470,7 +470,7 @@ bnxt_xdp_build_skb(struct bnxt *bp, struct sk_buff *s=
kb, u8 num_frags,
>
>         xdp_update_skb_shared_info(skb, num_frags,
>                                    sinfo->xdp_frags_size,
> -                                  bp->rx_page_size * num_frags,
> +                                  rxr->rx_page_size * num_frags,
>                                    xdp_buff_is_frag_pfmemalloc(xdp));
>         return skb;
>  }
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h b/drivers/net/=
ethernet/broadcom/bnxt/bnxt_xdp.h
> index 220285e190fc..8933a0dec09a 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
> @@ -32,6 +32,6 @@ void bnxt_xdp_buff_init(struct bnxt *bp, struct bnxt_rx=
_ring_info *rxr,
>  void bnxt_xdp_buff_frags_free(struct bnxt_rx_ring_info *rxr,
>                               struct xdp_buff *xdp);
>  struct sk_buff *bnxt_xdp_build_skb(struct bnxt *bp, struct sk_buff *skb,
> -                                  u8 num_frags, struct page_pool *pool,
> +                                  u8 num_frags, struct bnxt_rx_ring_info=
 *rxr,
>                                    struct xdp_buff *xdp);
>  #endif
> --
> 2.49.0
>
>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>

--000000000000b8f269063d2a9cb6
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
nSGLsSobByQoGh1GyLfFTXI7QOGn/6qvrJ7x9Oem5V7miUTD0wGAIozD7MCVoluf5Psa4Q2a5AFV
gROLty059Ex4oK55Op/0e3Aa/a8hZD/tPBT3WE70owdiCwIDAQABo4IB2zCCAdcwDgYDVR0PAQH/
BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3VyZS5nbG9i
YWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEGCCsGAQUF
BzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xv
YmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6hjhodHRw
Oi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNybDAlBgNV
HREEHjAcgRpzb21uYXRoLmtvdHVyQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAf
BgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUabMpSsFcjDNUWMvGf76o
yB7jBJUwDQYJKoZIhvcNAQELBQADggEBAJBDQpQ1TqY57vpQbwtXYP0N01q8J3tfNA/K2vOiNOpv
IufqZ5WKdKEtmT21nujCeuaCQ6SmpWqCUJVkLd+u/sHR62vCo8j2fb1pTkA7jeuCAuT9YMPRE86M
sUphsGDq2ylriQ7y5kvl728hZ0Oakm3xUCnZ9DYS/32sFGSZyrCGZipTBnjK4n5uLQ0yekSLACiD
R0zi4nzkbhwXqDbDaB+Duk52ec/Vj4xuc2uWu9rTmJNVjdk0qu9vh48xcd/BzrlmwY0crGTijAC/
r4x2/y9OfG0FyVmakU0qwDnZX982aa66tXnKNgae2k20WCDVMM5FPTrbMsQyz6Hrv3bg6qgxggJg
MIICXAIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYD
VQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgx6wAr6NdQY0sTG
G7cwDQYJYIZIAWUDBAIBBQCggccwLwYJKoZIhvcNAQkEMSIEIE8j0snl/kn8ar/l3/MvZFDQEgDm
zG4ETmz5+Y0xBS+aMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1
MDgyNTA2MjQ0N1owXAYJKoZIhvcNAQkPMU8wTTALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsG
CWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3
DQEBAQUABIIBAL89O02MlFtDpmQhWuEZUF4vnkHQH+1KkZToQB6unjZVcM6CTAvenTpjYXqrUBys
VfzXmPKE5MyCE8Q9/dLC7GWgAbuMAi4RDei5mmScoXXuRr0rRuJQ0VxIUl/7HgSXnbKlIkX5stpK
diQOHCPNIPf/Uv6/BXy8b6F4QKG/P6zi/rzc9vRPCdQtxxJ7ynnV5FEX2JJO7w+0pgaIAxQs+KVF
oA73lavnElDS1P/WWuI8PpxEbnfDFTjFd7EnBd1DqA0GEoeJgeqtN12DJhfkjNcuYNIvjkkPp2EA
e61Ctu75zOMrjVwg4JJuV/LnEg21UqMe3OLKKjrYe/duKDbA9vU=
--000000000000b8f269063d2a9cb6--

