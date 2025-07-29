Return-Path: <io-uring+bounces-8856-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C941FB14764
	for <lists+io-uring@lfdr.de>; Tue, 29 Jul 2025 07:04:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4094163277
	for <lists+io-uring@lfdr.de>; Tue, 29 Jul 2025 05:04:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F646227599;
	Tue, 29 Jul 2025 05:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="jLLk+LP8"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8F33FB31;
	Tue, 29 Jul 2025 05:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753765445; cv=none; b=fP60EsPf3aYfRM2oB55oyMt9YoYQlSCPNSVFjYo+M3z3rR0C2MDi87fW7xRR4docxcxq91uDKbE2OoHms6/7AmfpzHk4GSMDy2xbgArDIznWdbk5RU50k8Le+EXlDecIPcBevTjZJMyZpzN5IFsHLh+W/d+72qfOzqhcpg/qaiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753765445; c=relaxed/simple;
	bh=aAlq7ihJCEA3qiheIxFAyXlvMjhrisWvr0Wkq0KiNl4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pXrsYThufuE7MI/VXhKt6wP9nW7jqkND3nObWT8Dl1Jm4Hb8bvy4Jrf60Gv21CY6lMrtuCdI4CyEevyfhgcwvhF/BLI/3aV6iIzfvx1XIqlv4290nRVAkIEb8YDblZZQOU+CEDGRrWyKx3FAQr1LndetVm7bP339cNPNB0UOF08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=jLLk+LP8; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56SNSZxo029017;
	Mon, 28 Jul 2025 22:03:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pfpt0220; bh=9quu2HCmg6fALkrlXkolXeDD5
	kJNmWKNtY6RXFtm+HU=; b=jLLk+LP85s3t6ABL1HsgGn07Qcq22p2bz5HiPA488
	7RY6/FZkH7t0AII/x1vIEnKJx6/Nq4wwbD7gPT5gSv4f9DYqnH3NsogyMmjf8W6v
	HptU3lenswS6wfF0RqH0JSZoZfwRjOd4qgltt0NPNyFoaD5szZ9awjrpc5JTQjEu
	IkU3vUBuTKu4/sUD51YvjJ5NwZ4gNp30qvtGF+vxACsodwGgIXcrIz0vXHFSSI4b
	47ep7F0bWaaPpdTmAo3Av8y2BzjtF9mqtGa3mbxUJDQs99rxZlHXLG/JtHJa6chE
	jaq84CC9AhZ7WklV8WxbaWMSAQS4A5bURGlqwFDE42IEw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 486jwp8haa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Jul 2025 22:03:50 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 28 Jul 2025 22:03:50 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Mon, 28 Jul 2025 22:03:50 -0700
Received: from opensource (unknown [10.29.20.14])
	by maili.marvell.com (Postfix) with SMTP id E9F943F7059;
	Mon, 28 Jul 2025 22:03:42 -0700 (PDT)
Date: Tue, 29 Jul 2025 05:03:41 +0000
From: Subbaraya Sundeep <sbhatta@marvell.com>
To: Pavel Begunkov <asml.silence@gmail.com>
CC: Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <io-uring@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
        Willem de
 Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <andrew+netdev@lunn.ch>,
        <horms@kernel.org>, <davem@davemloft.net>, <sdf@fomichev.me>,
        <almasrymina@google.com>, <dw@davidwei.uk>,
        <michael.chan@broadcom.com>, <dtatulea@nvidia.com>,
        <ap420073@gmail.com>
Subject: Re: [RFC v1 03/22] net: use zero value to restore rx_buf_len to
 default
Message-ID: <aIhWLcnu884VkNDO@opensource>
References: <cover.1753694913.git.asml.silence@gmail.com>
 <12b155ca79e838e2c141d9411f0b8b3aa15e508e.1753694913.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <12b155ca79e838e2c141d9411f0b8b3aa15e508e.1753694913.git.asml.silence@gmail.com>
X-Proofpoint-ORIG-GUID: wVP-HRUzD_O-trXJczz33wBs9LMc7Rql
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI5MDAzNSBTYWx0ZWRfX8Aikyld9DEnf lgC5zS1zqP6iTPapuX8Eik5J8gNiZhFj7MMmAXDFGSGZGwNYRKwH5mcgJwoL8Z9PX19yetJXRwn axavDRDhBgARYVnjMmDokPxHuVRp7ge9RBHvDx5ObpnOyMo7zWowTI32cWB5AiRtZmkkWHYcdnp
 61F0FPWCXhifb/hfsMIO7koa8L5CK95T+K7AgFjK3kclvHTFokHciq72PrNGAlu5TcRcK1B/3gF ovqmcFkzdR/6vArHOVdBWvRKWH+GWY4uoAk4/Ih2uGgQAZbEy61OYlkHw5wAz2v1nGVVyxZl8g/ 1Dv2/ThJpERmsjOc4LYb6t6LLIuaO+R9r50QV9tRIavNe4A9RnrzqvF256KSwvYy69ZHEb2Iaar
 pB6hRYdbTDussd5oo1OZq92kaj8S/utXhBW6VmOkwnKUAQLj1mUQ//HxyxmDiSANsSaDDonY
X-Authority-Analysis: v=2.4 cv=bNgWIO+Z c=1 sm=1 tr=0 ts=68885636 cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=B6grpBvjW_3kyTz4DecA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: wVP-HRUzD_O-trXJczz33wBs9LMc7Rql
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-29_01,2025-07-28_01,2025-03-28_01

LGTM.

Thanks,
Sundeep

On 2025-07-28 at 11:04:07, Pavel Begunkov (asml.silence@gmail.com) wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> 
> Distinguish between rx_buf_len being driver default vs user config.
> Use 0 as a special value meaning "unset" or "restore driver default".
> This will be necessary later on to configure it per-queue, but
> the ability to restore defaults may be useful in itself.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  Documentation/networking/ethtool-netlink.rst              | 2 +-
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 3 +++
>  include/linux/ethtool.h                                   | 1 +
>  net/ethtool/rings.c                                       | 2 +-
>  4 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> index b7a99dfdffa9..723f8e1a33a7 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -974,7 +974,7 @@ threshold value, header and data will be split.
>  ``ETHTOOL_A_RINGS_RX_BUF_LEN`` controls the size of the buffer chunks driver
>  uses to receive packets. If the device uses different memory polls for headers
>  and payload this setting may control the size of the header buffers but must
> -control the size of the payload buffers.
> +control the size of the payload buffers. Setting to 0 restores driver default.
>  
>  CHANNELS_GET
>  ============
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> index 7bdef64926c8..1a74a7b81ac1 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> @@ -396,6 +396,9 @@ static int otx2_set_ringparam(struct net_device *netdev,
>  	if (ring->rx_mini_pending || ring->rx_jumbo_pending)
>  		return -EINVAL;
>  
> +	if (!rx_buf_len)
> +		rx_buf_len = OTX2_DEFAULT_RBUF_LEN;
> +
>  	/* Hardware supports max size of 32k for a receive buffer
>  	 * and 1536 is typical ethernet frame size.
>  	 */
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index dd9f253a56ae..bbc5c485bfbf 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -77,6 +77,7 @@ enum {
>  /**
>   * struct kernel_ethtool_ringparam - RX/TX ring configuration
>   * @rx_buf_len: Current length of buffers on the rx ring.
> + *		Setting to 0 means reset to driver default.
>   * @rx_buf_len_max: Max length of buffers on the rx ring.
>   * @tcp_data_split: Scatter packet headers and data to separate buffers
>   * @tx_push: The flag of tx push mode
> diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
> index 5e872ceab5dd..628546a1827b 100644
> --- a/net/ethtool/rings.c
> +++ b/net/ethtool/rings.c
> @@ -139,7 +139,7 @@ const struct nla_policy ethnl_rings_set_policy[] = {
>  	[ETHTOOL_A_RINGS_RX_MINI]		= { .type = NLA_U32 },
>  	[ETHTOOL_A_RINGS_RX_JUMBO]		= { .type = NLA_U32 },
>  	[ETHTOOL_A_RINGS_TX]			= { .type = NLA_U32 },
> -	[ETHTOOL_A_RINGS_RX_BUF_LEN]            = NLA_POLICY_MIN(NLA_U32, 1),
> +	[ETHTOOL_A_RINGS_RX_BUF_LEN]            = { .type = NLA_U32 },
>  	[ETHTOOL_A_RINGS_TCP_DATA_SPLIT]	=
>  		NLA_POLICY_MAX(NLA_U8, ETHTOOL_TCP_DATA_SPLIT_ENABLED),
>  	[ETHTOOL_A_RINGS_CQE_SIZE]		= NLA_POLICY_MIN(NLA_U32, 1),
> -- 
> 2.49.0
> 

