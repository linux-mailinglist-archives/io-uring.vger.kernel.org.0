Return-Path: <io-uring+bounces-7840-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7C9AAAB8AD
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 08:39:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A51C53A5C03
	for <lists+io-uring@lfdr.de>; Tue,  6 May 2025 06:29:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD97F27B4FE;
	Tue,  6 May 2025 04:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AUcv5z9c"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2606B297128;
	Tue,  6 May 2025 01:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746495481; cv=none; b=Xy2iGnBdSqfoJ7Wby26DGDLEq/UZHkekL2gUmJhuo3dtaFpJ8U4Io0XSu8rrHzOnlY74YWYLGr/Xkzg0ZohZXOL9qeHrpe7HoizYiRhfScjcU1SZ5HOe/7fmZqacXU9BN9Gg/inehlZU+5G83F4J16qlE6mY+Emy03jEKiykWZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746495481; c=relaxed/simple;
	bh=zKECytagb87TMOLvGwWUa+PfDXa1A/lXuEpkDrkjAnM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E6EZ+dZ+f9hOKTVe0R7h0+p/Dkze0edVobRPa0BNczcIdkxQQLkyKQm7JrX+IC6dwdd9YJAFD21QM5no9RiRrmG97l6RY7fhEr/1DgPLLeKXvW2em9w88B/2Hu7gWee7GKntQVyh/pSRmjQOZ5pyIH3mfPdMg/EPk+HwRCJ0C6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AUcv5z9c; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AD4C4CEE4;
	Tue,  6 May 2025 01:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746495480;
	bh=zKECytagb87TMOLvGwWUa+PfDXa1A/lXuEpkDrkjAnM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AUcv5z9ca99yIo2NLkz4SbM2b9WWkH0uw/wz4j+St1LLxEyfCJEsFq1ZdUTAa9c2L
	 TDlUp+WqRO3spDiJ7VP6zq4YtkngpCzgRsN3AhxF+iHbRhEpHJo/NGCGI/GH8hrwir
	 akWRoH0LOdfxi2MuogXg+4weQT1gWeuj3VxnAbtPI8laajeMTjyU2oJPsHI0FtLUlN
	 26f/mL+aTgG6bFUz9+H/yNgZjmt9fEPOoYa+C6GN7FIUyKlwExDdKuTyScVnhiGYBJ
	 3wSuE0Q1rlqd6GvOeqkb9nRRKhcVH1g7UT3bBvgRcbZWqs/1L0pgZ/upZbY7X5pSUU
	 kUOM/O+IQitUQ==
Date: Mon, 5 May 2025 18:37:58 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Mina Almasry <almasrymina@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, io-uring@vger.kernel.org,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>, Donald Hunter <donald.hunter@gmail.com>,
 Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>,
 Jeroen de Borst <jeroendb@google.com>, Harshitha Ramamurthy
 <hramamurthy@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de
 Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, Pavel Begunkov
 <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>, Neal Cardwell
 <ncardwell@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
 <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, "Eugenio
 =?UTF-8?B?UMOpcmV6?=" <eperezma@redhat.com>, Stefan Hajnoczi
 <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan
 <shuah@kernel.org>, sdf@fomichev.me, dw@davidwei.uk, Jamal Hadi Salim
 <jhs@mojatatu.com>, Victor Nogueira <victor@mojatatu.com>, Pedro Tammela
 <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>, Kaiyuan
 Zhang <kaiyuanz@google.com>
Subject: Re: [PATCH net-next v13 4/9] net: devmem: Implement TX path
Message-ID: <20250505183758.7778811c@kernel.org>
In-Reply-To: <20250429032645.363766-5-almasrymina@google.com>
References: <20250429032645.363766-1-almasrymina@google.com>
	<20250429032645.363766-5-almasrymina@google.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Functionally LGTM. But I'm not sure if the discussion with Paolo is
resolved, so here's a couple more nit picks:

On Tue, 29 Apr 2025 03:26:40 +0000 Mina Almasry wrote:
> +	case SCM_DEVMEM_DMABUF:
> +		if (cmsg->cmsg_len != CMSG_LEN(sizeof(u32)))
> +			return -EINVAL;
> +		sockc->dmabuf_id = *(u32 *)CMSG_DATA(cmsg);
> +
>  		break;

The empty line before break is very odd.

> +	sockc = (struct sockcm_cookie){ .tsflags = READ_ONCE(sk->sk_tsflags),
> +					.dmabuf_id = 0 };

Too ugly to exist, either full init fits on a line or there needs to be
a line break after {.

