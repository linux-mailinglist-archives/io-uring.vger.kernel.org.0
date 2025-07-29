Return-Path: <io-uring+bounces-8855-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4265CB1475F
	for <lists+io-uring@lfdr.de>; Tue, 29 Jul 2025 07:01:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DDFA47AB13C
	for <lists+io-uring@lfdr.de>; Tue, 29 Jul 2025 04:59:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A077016F8E5;
	Tue, 29 Jul 2025 05:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="VrNRYSWj"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A5D1581EE;
	Tue, 29 Jul 2025 05:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753765259; cv=none; b=aZJv+aqJ+2MFhl/KCmQXYrApQRT9hT63efJXXIoc27x2fwhjketzsDgis67wRG98oaTks46+rYbPf/w6nIDbl5nsnJp9qYROVpS6JtOzvRKdDz0KNj5G32iAc7awwYmyUXFY2h4AW0wuWcJsv1+Q+rAjc8Kn3AvogKPQZjRYu1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753765259; c=relaxed/simple;
	bh=cXukY09M1n4y41dtT5M1r7seaRfyzVDb3U9ZwOTYc9M=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SfEArAP96tiJJ2xrS8is3NRUbCzULYWYxXW3DoQLzU/1nIZxpYrTskIAI+SZ+MD7svpN4lG5jH8hdTVt/S2QkhWPN6sh6wYD+QNXsb+zbdAcfJIE34tszQAjnqPkuMPfdzdUq3rBs9rZF4NB+3NiVIJg3miTBZn3+IbwPVQDSfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=VrNRYSWj; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56SFhZtt030258;
	Mon, 28 Jul 2025 22:00:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pfpt0220; bh=63QpitPCmebWlI6vI6GogPH85
	wt1surLBaTDE24PvLk=; b=VrNRYSWjZ4/j0e9HFWtE3RTEjZ80NY0/WZJ5Y2iej
	99rF+n0zD7Fyv+NKr3fZGzaVxY3Fe+1hdvghVrlECdqrlMo7QHvWwYFz2x+JoM+G
	+4JuVGIT2dyn3a8VEvgPEpASZOndrBH9gNcfcfIJnwv7xuVvLye5Nhbv/qSCRKmm
	dU0TZ518ZbdbyGFh8SFnktlVtY8hceLzJ4b4xhR//DmvcDQZVKcJADe1C5S9zn9Q
	uboYqFhZmVViGUB312xDNY/EPJaWZ/bQdqKVHvU1O4PG5I2tXis1Uyy7lV/bBtKe
	SHSzfKNfiA9YpSTaNAufzEu1dY9T9jFpvkzKKEmBcafzw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 486c3ghdna-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Jul 2025 22:00:43 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 28 Jul 2025 22:00:44 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Mon, 28 Jul 2025 22:00:44 -0700
Received: from opensource (unknown [10.29.20.14])
	by maili.marvell.com (Postfix) with SMTP id A08905B6934;
	Mon, 28 Jul 2025 22:00:36 -0700 (PDT)
Date: Tue, 29 Jul 2025 05:00:35 +0000
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
Subject: Re: [RFC v1 02/22] net: ethtool: report max value for rx-buf-len
Message-ID: <aIhVc7GQJIHzeKvo@opensource>
References: <cover.1753694913.git.asml.silence@gmail.com>
 <6a3c35ea36adc1ee8fc3ae7a53c80d33cb903e2c.1753694913.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <6a3c35ea36adc1ee8fc3ae7a53c80d33cb903e2c.1753694913.git.asml.silence@gmail.com>
X-Authority-Analysis: v=2.4 cv=LeQ86ifi c=1 sm=1 tr=0 ts=6888557b cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=yfL3gMEO3veICod-Rg4A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: asQX669tJttKKAw1smzudK1bZ6cER3-G
X-Proofpoint-GUID: asQX669tJttKKAw1smzudK1bZ6cER3-G
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI5MDAzNSBTYWx0ZWRfX9lt1VUlgye8M atgM0gj6n8WsqCghPomw1nQz5SLHY/gBf3ajlnJ3d2eV2GwTJI0uTK4oF9kTUN05ps11LfDIMVB QDJ8UkkcLsXTeF0rlT4cpMrO1XzV3W/SN7vOokeFF7IoQFf/G6yxVg4GUPtRNbveQtTJiR8FWE3
 x9RwPPYo6ZsyYEWyaDCdDSl400G2b1H49A888jbmSkvJ6LzzbhRKFGq9aJ+zLqZfUgo4NT5nhNm 1ioZj2bmYkSMRUlODlighStifZiVwDWKkGf4dGpc9uhqHEyhXYvp6rNUO5lpGmK51fHGYUt10+c /LAe98kKvkZKO2WZo+HnV+UTofhc1DOqNPsw+MBGVuOa8BmFvIvlo3x5+sT4RbkoqTECfjpQUUY
 IozinCRdEfZ1I2Ukrl4Dw93L5Fo1yNKEsHdGqpVkLMgQltsVFh17FFITwRumod3OIwtEVvwg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-29_01,2025-07-28_01,2025-03-28_01

LGTM.

Thanks,
Sundeep

On 2025-07-28 at 11:04:06, Pavel Begunkov (asml.silence@gmail.com) wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> 
> Unlike most of our APIs the rx-buf-len param does not have an associated
> max value. In theory user could set this value pretty high, but in
> practice most NICs have limits due to the width of the length fields
> in the descriptors.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  Documentation/netlink/specs/ethtool.yaml                  | 4 ++++
>  Documentation/networking/ethtool-netlink.rst              | 1 +
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 3 ++-
>  include/linux/ethtool.h                                   | 2 ++
>  include/uapi/linux/ethtool_netlink_generated.h            | 1 +
>  net/ethtool/rings.c                                       | 5 +++++
>  6 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/netlink/specs/ethtool.yaml
> index 72a076b0e1b5..cb96b4e7093f 100644
> --- a/Documentation/netlink/specs/ethtool.yaml
> +++ b/Documentation/netlink/specs/ethtool.yaml
> @@ -361,6 +361,9 @@ attribute-sets:
>        -
>          name: hds-thresh-max
>          type: u32
> +      -
> +        name: rx-buf-len-max
> +        type: u32
>  
>    -
>      name: mm-stat
> @@ -1811,6 +1814,7 @@ operations:
>              - rx-jumbo
>              - tx
>              - rx-buf-len
> +            - rx-buf-len-max
>              - tcp-data-split
>              - cqe-size
>              - tx-push
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> index eaa9c17a3cb1..b7a99dfdffa9 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -893,6 +893,7 @@ Kernel response contents:
>    ``ETHTOOL_A_RINGS_RX_JUMBO``              u32     size of RX jumbo ring
>    ``ETHTOOL_A_RINGS_TX``                    u32     size of TX ring
>    ``ETHTOOL_A_RINGS_RX_BUF_LEN``            u32     size of buffers on the ring
> +  ``ETHTOOL_A_RINGS_RX_BUF_LEN_MAX``        u32     max size of rx buffers
>    ``ETHTOOL_A_RINGS_TCP_DATA_SPLIT``        u8      TCP header / data split
>    ``ETHTOOL_A_RINGS_CQE_SIZE``              u32     Size of TX/RX CQE
>    ``ETHTOOL_A_RINGS_TX_PUSH``               u8      flag of TX Push mode
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> index 45b8c9230184..7bdef64926c8 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> @@ -376,6 +376,7 @@ static void otx2_get_ringparam(struct net_device *netdev,
>  	ring->tx_max_pending = Q_COUNT(Q_SIZE_MAX);
>  	ring->tx_pending = qs->sqe_cnt ? qs->sqe_cnt : Q_COUNT(Q_SIZE_4K);
>  	kernel_ring->rx_buf_len = pfvf->hw.rbuf_len;
> +	kernel_ring->rx_buf_len_max = 32768;
>  	kernel_ring->cqe_size = pfvf->hw.xqe_size;
>  }
>  
> @@ -398,7 +399,7 @@ static int otx2_set_ringparam(struct net_device *netdev,
>  	/* Hardware supports max size of 32k for a receive buffer
>  	 * and 1536 is typical ethernet frame size.
>  	 */
> -	if (rx_buf_len && (rx_buf_len < 1536 || rx_buf_len > 32768)) {
> +	if (rx_buf_len && (rx_buf_len < 1536)) {
>  		netdev_err(netdev,
>  			   "Receive buffer range is 1536 - 32768");
>  		return -EINVAL;
> diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
> index 5e0dd333ad1f..dd9f253a56ae 100644
> --- a/include/linux/ethtool.h
> +++ b/include/linux/ethtool.h
> @@ -77,6 +77,7 @@ enum {
>  /**
>   * struct kernel_ethtool_ringparam - RX/TX ring configuration
>   * @rx_buf_len: Current length of buffers on the rx ring.
> + * @rx_buf_len_max: Max length of buffers on the rx ring.
>   * @tcp_data_split: Scatter packet headers and data to separate buffers
>   * @tx_push: The flag of tx push mode
>   * @rx_push: The flag of rx push mode
> @@ -89,6 +90,7 @@ enum {
>   */
>  struct kernel_ethtool_ringparam {
>  	u32	rx_buf_len;
> +	u32	rx_buf_len_max;
>  	u8	tcp_data_split;
>  	u8	tx_push;
>  	u8	rx_push;
> diff --git a/include/uapi/linux/ethtool_netlink_generated.h b/include/uapi/linux/ethtool_netlink_generated.h
> index aa8ab5227c1e..1a76e6789e33 100644
> --- a/include/uapi/linux/ethtool_netlink_generated.h
> +++ b/include/uapi/linux/ethtool_netlink_generated.h
> @@ -164,6 +164,7 @@ enum {
>  	ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN_MAX,
>  	ETHTOOL_A_RINGS_HDS_THRESH,
>  	ETHTOOL_A_RINGS_HDS_THRESH_MAX,
> +	ETHTOOL_A_RINGS_RX_BUF_LEN_MAX,
>  
>  	__ETHTOOL_A_RINGS_CNT,
>  	ETHTOOL_A_RINGS_MAX = (__ETHTOOL_A_RINGS_CNT - 1)
> diff --git a/net/ethtool/rings.c b/net/ethtool/rings.c
> index aeedd5ec6b8c..5e872ceab5dd 100644
> --- a/net/ethtool/rings.c
> +++ b/net/ethtool/rings.c
> @@ -105,6 +105,9 @@ static int rings_fill_reply(struct sk_buff *skb,
>  			  ringparam->tx_pending)))  ||
>  	    (kr->rx_buf_len &&
>  	     (nla_put_u32(skb, ETHTOOL_A_RINGS_RX_BUF_LEN, kr->rx_buf_len))) ||
> +	    (kr->rx_buf_len_max &&
> +	     (nla_put_u32(skb, ETHTOOL_A_RINGS_RX_BUF_LEN_MAX,
> +			  kr->rx_buf_len_max))) ||
>  	    (kr->tcp_data_split &&
>  	     (nla_put_u8(skb, ETHTOOL_A_RINGS_TCP_DATA_SPLIT,
>  			 kr->tcp_data_split))) ||
> @@ -281,6 +284,8 @@ ethnl_set_rings(struct ethnl_req_info *req_info, struct genl_info *info)
>  		err_attr = tb[ETHTOOL_A_RINGS_TX];
>  	else if (kernel_ringparam.hds_thresh > kernel_ringparam.hds_thresh_max)
>  		err_attr = tb[ETHTOOL_A_RINGS_HDS_THRESH];
> +	else if (kernel_ringparam.rx_buf_len > kernel_ringparam.rx_buf_len_max)
> +		err_attr = tb[ETHTOOL_A_RINGS_RX_BUF_LEN];
>  	else
>  		err_attr = NULL;
>  	if (err_attr) {
> -- 
> 2.49.0
> 

