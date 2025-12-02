Return-Path: <io-uring+bounces-10889-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A7D7C9CB24
	for <lists+io-uring@lfdr.de>; Tue, 02 Dec 2025 19:58:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 54D954E46DA
	for <lists+io-uring@lfdr.de>; Tue,  2 Dec 2025 18:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 714122D23B9;
	Tue,  2 Dec 2025 18:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NJB+81+t"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F9628C00C;
	Tue,  2 Dec 2025 18:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764701903; cv=none; b=posPPrT7AbVvWPvU5GAEd954Uj8YPs1vC/gUPV1sQzYBPLov1VdIsfnMoU+Ex5T+BfeFzPt9nLtWC+pUguCCI4vlspzafZP7fx6RQ28LnnkPYthkPw12pBoDp7swbb/XqH+quDjmAeZOwAcuXuVl1MN5mmAMcR89uxBjYexuA0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764701903; c=relaxed/simple;
	bh=r8xDi8SAoeRDBGnkpp+T5spKBIQJCPR09Cf48ybbrgg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MPHgoSxrh4xNS3lfFezvB7z4MLKxiTjL183XPLFinHFjdTjhgCLQJq/2wUn9vmEtRYhNR9O2jkzYERawdyG0Phpb+Ffnr8DnwUE+jwwOnnMgcX5KGL68wvegN7g3Pl79CHUWn4X+uog1NoAALmhVoUGgBE14PNEy/BNTZWXPixY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NJB+81+t; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72518C4CEF1;
	Tue,  2 Dec 2025 18:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764701902;
	bh=r8xDi8SAoeRDBGnkpp+T5spKBIQJCPR09Cf48ybbrgg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NJB+81+tZS5+9vuaVWKZY3o9keUY2xSiCU8+gNVYRwIyAtlGaQ5sPP1afhbG8uauy
	 yMDp0BVxnW4DRGjl6JZKumEtq742R5M3cQA8M7hr/v8kpwt1AKt5o9i63vk6WneKuq
	 ZY/vnYezYeMdySUh0yMr+2DARyzdoAbXpPlj7LGebK507ClEyN82T7Bst/BgwOBrPG
	 aowwY2KBHqhompa2aJdbZ1PkQydj2r3PQec421O2xH53iPxV4HUw7sx/AsBOYt5pD+
	 YMA73+sQrP1Q7QfcblIIR+JRJFYtys90Qmrxh1yqj6VbrrUR8Cc4fCyAfNvtwpzpzP
	 uhNklhUEfSzLA==
Date: Tue, 2 Dec 2025 10:58:20 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Jonathan
 Corbet <corbet@lwn.net>, Michael Chan <michael.chan@broadcom.com>, Pavan
 Chebbi <pavan.chebbi@broadcom.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
 <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>, Ilias Apalodimas
 <ilias.apalodimas@linaro.org>, Shuah Khan <shuah@kernel.org>, Mina Almasry
 <almasrymina@google.com>, Stanislav Fomichev <sdf@fomichev.me>, Yue Haibing
 <yuehaibing@huawei.com>, David Wei <dw@davidwei.uk>, Haiyue Wang
 <haiyuewa@163.com>, Jens Axboe <axboe@kernel.dk>, Joe Damato
 <jdamato@fastly.com>, Simon Horman <horms@kernel.org>, Vishwanath Seshagiri
 <vishs@fb.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
 io-uring@vger.kernel.org, dtatulea@nvidia.com
Subject: Re: [PATCH net-next v7 7/9] eth: bnxt: allow providers to set rx
 buf size
Message-ID: <20251202105820.14d6de99@kernel.org>
In-Reply-To: <95566e5d1b75abcaefe3dca9a52015c2b5f04933.1764542851.git.asml.silence@gmail.com>
References: <cover.1764542851.git.asml.silence@gmail.com>
	<95566e5d1b75abcaefe3dca9a52015c2b5f04933.1764542851.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 30 Nov 2025 23:35:22 +0000 Pavel Begunkov wrote:
> +static ssize_t bnxt_get_rx_buf_size(struct bnxt *bp, int rxq_idx)
> +{
> +	struct netdev_rx_queue *rxq = __netif_get_rx_queue(bp->dev, rxq_idx);
> +	size_t rx_buf_size;
> +
> +	rx_buf_size = rxq->mp_params.rx_buf_len;
> +	if (!rx_buf_size)
> +		return BNXT_RX_PAGE_SIZE;

I'd like to retain my cfg objects in the queue API, if you don't mind.
I guess we just need the way for drivers to fill in the defaults and
then plumb them into the ops.

When drivers implement the logic to consolidate the configuration from
different APIs into the effective one they inevitably diverge in their
interpretations :/ We should keep it in the core from the start and
present to the driver the final queue config.

> +	/* Older chips need MSS calc so rx_buf_len is not supported,
> +	 * but we don't set queue ops for them so we should never get here.
> +	 */
> +	if (!(bp->flags & BNXT_FLAG_CHIP_P5_PLUS))
> +		return -EINVAL;
> +
> +	if (!is_power_of_2(rx_buf_size))
> +		return -ERANGE;
> +
> +	if (rx_buf_size < BNXT_RX_PAGE_SIZE ||
> +	    rx_buf_size > BNXT_MAX_RX_PAGE_SIZE)
> +		return -ERANGE;
> +
> +	return rx_buf_size;
> +}
> +
>  static int bnxt_queue_mem_alloc(struct net_device *dev, void *qmem, int idx)
>  {
>  	struct bnxt_rx_ring_info *rxr, *clone;
>  	struct bnxt *bp = netdev_priv(dev);
>  	struct bnxt_ring_struct *ring;
> +	ssize_t rx_buf_size;
>  	int rc;
>  
>  	if (!bp->rx_ring)
>  		return -ENETDOWN;
>  
> +	rx_buf_size = bnxt_get_rx_buf_size(bp, idx);
> +	if (rx_buf_size < 0)
> +		return rx_buf_size;

Does this survive full ring reconfig? IIRC the large changes to the NIC
config (like changing ring sizes) free and reallocate all rings in bnxt,
but due to "historic reasons?" they don't go thru the queue ops.

