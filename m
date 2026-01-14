Return-Path: <io-uring+bounces-11627-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AED74D1C451
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 04:36:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 37BA33003FD7
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 03:36:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADDF22D0C8B;
	Wed, 14 Jan 2026 03:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KtPxaBvF"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88009296BB7;
	Wed, 14 Jan 2026 03:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768361775; cv=none; b=FocCfMZOiK294dnuWPjq/CUbiTPNpDSSLBEsEbTN3wsmJXo6x3G3bd9wCC/CoIIt9GEG61/DLiLHmFWVzrKJ33Qx/8QGxPT/LR0ivI0K1pxz5LnFk6HkBu7xA28E9ty7st8lsQB5NLCsJKiOLisrgSRhrQmwtTjY1rEmu0qJHic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768361775; c=relaxed/simple;
	bh=XdgwGXL6Xkf7KFiVxYJaa6oGaEzMG6qYj6DrtcALVZw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TyRPnPB9CkYtPh7m+Ap0z1zVsPQ4PoqZVqvVXt3/+YgXDcVdhm8x+XDviL38sUV77PIjEWWTJJFqbD8zusirtRQlvDniDMLEQZw0pq5mrKA0BtvOOyfhfHos53GcKCvem5RKQtR3U0q/2Zm1cFoWktPksdA6gRuml2mE0lkiDik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KtPxaBvF; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5F8C4CEF7;
	Wed, 14 Jan 2026 03:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768361775;
	bh=XdgwGXL6Xkf7KFiVxYJaa6oGaEzMG6qYj6DrtcALVZw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KtPxaBvFjvBQXFgO6ttgm1CTd9pwSd7h+Lyh+D9BlZcO995/kseP/Wry1CiCN3v/n
	 gBwIeg1brhKqIgABt6UECFua/Ct/X6gYsG38FVO8f6nWOf173R366ktySg2c/OI6jY
	 vk2Ge2hCtjCrU3a9L6qa0l7mSw2vfPb0vGqD7MpfJV5pEDB/zBBeNPk3CdhrwD5Zu0
	 eumNzZOYzfdZb4LKIHdXfESrFvoslPCoWdoC1b0JaoLC/mIXrjkvL3pAioVtBHM6eI
	 WeCKp318EhcZFMv/64Kg8sLAhyMxzF4GhCzOaMZyc6/3d1xjwxIJU83EoMG09a8DJm
	 WGF3Zo8ytomJg==
Date: Tue, 13 Jan 2026 19:36:12 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Jonathan
 Corbet <corbet@lwn.net>, Michael Chan <michael.chan@broadcom.com>, Pavan
 Chebbi <pavan.chebbi@broadcom.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
 <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>, Joshua Washington
 <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, Saeed
 Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Mark Bloch
 <mbloch@nvidia.com>, Leon Romanovsky <leon@kernel.org>, Alexander Duyck
 <alexanderduyck@fb.com>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Shuah Khan <shuah@kernel.org>, Willem de Bruijn <willemb@google.com>, Ankit
 Garg <nktgrg@google.com>, Tim Hostetler <thostet@google.com>, Alok Tiwari
 <alok.a.tiwari@oracle.com>, Ziwei Xiao <ziweixiao@google.com>, John Fraker
 <jfraker@google.com>, Praveen Kaligineedi <pkaligineedi@google.com>, Mohsin
 Bashir <mohsin.bashr@gmail.com>, Joe Damato <joe@dama.to>, Mina Almasry
 <almasrymina@google.com>, Dimitri Daskalakis
 <dimitri.daskalakis1@gmail.com>, Stanislav Fomichev <sdf@fomichev.me>,
 Kuniyuki Iwashima <kuniyu@google.com>, Samiullah Khawaja
 <skhawaja@google.com>, Ahmed Zaki <ahmed.zaki@intel.com>, Alexander Lobakin
 <aleksander.lobakin@intel.com>, David Wei <dw@davidwei.uk>, Yue Haibing
 <yuehaibing@huawei.com>, Haiyue Wang <haiyuewa@163.com>, Jens Axboe
 <axboe@kernel.dk>, Simon Horman <horms@kernel.org>, Vishwanath Seshagiri
 <vishs@fb.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-kselftest@vger.kernel.org, dtatulea@nvidia.com,
 io-uring@vger.kernel.org
Subject: Re: [PATCH net-next v8 7/9] eth: bnxt: support qcfg provided rx
 page size
Message-ID: <20260113193612.2abfcf10@kernel.org>
In-Reply-To: <28028611f572ded416b8ab653f1b9515b0337fba.1767819709.git.asml.silence@gmail.com>
References: <cover.1767819709.git.asml.silence@gmail.com>
	<28028611f572ded416b8ab653f1b9515b0337fba.1767819709.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  9 Jan 2026 11:28:46 +0000 Pavel Begunkov wrote:
> @@ -4342,7 +4343,8 @@ static void bnxt_init_ring_struct(struct bnxt *bp)
>  		if (!rxr)
>  			goto skip_rx;
>  
> -		rxr->rx_page_size = BNXT_RX_PAGE_SIZE;
> +		rxq = __netif_get_rx_queue(bp->dev, i);
> +		rxr->rx_page_size = rxq->qcfg.rx_page_size;

Pretty sure I asked for the netdev_queue_config() helper to make 
a return, instead of drivers poking directly into core state.
Having the config live in rxq directly is also ugh.

But at this stage we're probably better off if you just respin
to fix the nits from Paolo and I try to de-lobotimize the driver
facing API. This is close enough.

