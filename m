Return-Path: <io-uring+bounces-3509-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F4F59974E4
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 20:28:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F38B01F22F17
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 18:28:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97F0D1991B6;
	Wed,  9 Oct 2024 18:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HJ2oOBgd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A445F1922EA
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 18:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728498493; cv=none; b=L7rWdi2oQ1RK2ulR373OXlj9TVK9K6KqGSBSY9ztRAy9eax5jzm/73J85JmBpk09OwGJOQoLvrthNr/2ReFFBbuTCoE/4NxBbrKBJyNlpeKmAmgkn4dPStI2Sax1mbSuTI0TjYsNkZstH3tDYwx1e3SbwTea0U+kiUg29RdAUI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728498493; c=relaxed/simple;
	bh=DlR5C3N8lf7Sd6QJ/PXzbLiO2dai4102AS6Ho0DrBfo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oB6UGkZtnvkgIZK+u5f5kaBJYp97Id/ypI72Kn0QQYC6o5ziML+TjmRyi/966DeICaw4DKIDTc2sTNnh1BMWWKvNrDK7uJqFLqkzLnGeyU3wym8cApEqbUqvdPCYjF/ylfBb+QpIO5GEUW3urFByOGkuRDpYjzu5MVGIQNtVUbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HJ2oOBgd; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3a393010110so688435ab.0
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 11:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728498490; x=1729103290; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6jtbe9EClknasbAeRY+gshgY/lQEX5MzFFXUzmJP/WE=;
        b=HJ2oOBgdXVeT1tzaAaZb/sc4nCz/q6GCZNyillrJc73NZOCrP3hZOjj0A2ookcMRIy
         +yiCmJwmZkktu0brJCwziog3jjBbycRLVRk7artffB2LPk/cJsf5YHEAtItZaObr0IhD
         1+ZeD4r2bOWmPQzTthk18e8KxruLNFZ7kW4rTvGHdW6I3yMRG7eJ/E3num4DCHw6lJIm
         Hx3WKPTCNT4RZBtPMibz7BdLsjasEO2Lzk7tlHHsEjlDB/eqCAQHu8o5yvl6E4NYL7Lf
         /a1AGwwjDeU0fAbANSCtqBvMq2TmC80b1wxyeCmSnpunuVGT1Y9VEoxQEas040oLknKu
         Zw+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728498490; x=1729103290;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6jtbe9EClknasbAeRY+gshgY/lQEX5MzFFXUzmJP/WE=;
        b=Etl0aJjnPaRJ69lTTpl1d2qmXBi2HK0mP98vYXN+RYNBGbnOfxFbYy7qaxVrTje3r/
         61erlIZq5ixmPNSEU5Iw8W31rh33KuvoesMRyIZC/14Unnk8WzjqWDfwoVUiF1+M59w8
         a7CXRVoeMGX7BzeuvAWR7ZFLHfNsVgbahT3gY7UDCTzvZj0v7GHXaaCAO6q37MZF5E55
         hqNvAWd+KQtfcRkqfjoWmj6BYk9LhZScfCTd32//ZVyVQqgVFY3e5KuMX8jpfYLeVv9I
         EKkiFRB4Je891Mzi3YkfjeRqFHpQZVzcvxfg+A2yUrPEkuEcnPu9TxSOZ9Vp7+RQ2uoB
         /1SA==
X-Forwarded-Encrypted: i=1; AJvYcCXeKOAqeinXGmEsPVmXxHK2RxhmGl7WpuGYEtJLtoxWgmadePtWZbKP59a5ngLLTAwVKncHgtEW+g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxUxwO6tU0Le2XyTKEhYoXTeMZxETm3QBfJxEwok4XwlxyD7lBE
	boy5eYk/lzLVe0chntjEDxgF6fMMswRFHj1faGFpPOd64cng0OcuyTUdYw7OY4Y=
X-Google-Smtp-Source: AGHT+IGQrKens2QtTw8cd8USva5Ahs2lit+5Usqb34DUpy4X9GC3miEJvLbIhn70WaxdChPziQUhjw==
X-Received: by 2002:a05:6e02:b29:b0:3a0:9026:3b65 with SMTP id e9e14a558f8ab-3a397d2654emr41799835ab.25.1728498490259;
        Wed, 09 Oct 2024 11:28:10 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a39bdb7f5asm3877875ab.33.2024.10.09.11.28.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 11:28:09 -0700 (PDT)
Message-ID: <703c9d90-bca1-4ee7-b1f3-0cfeaf38ef8f@kernel.dk>
Date: Wed, 9 Oct 2024 12:28:08 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 12/15] io_uring/zcrx: add io_recvzc request
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-13-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241007221603.1703699-13-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

> diff --git a/io_uring/net.c b/io_uring/net.c
> index d08abcca89cc..482e138d2994 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -1193,6 +1201,76 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
>  	return ret;
>  }
>  
> +int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
> +{
> +	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
> +	unsigned ifq_idx;
> +
> +	if (unlikely(sqe->file_index || sqe->addr2 || sqe->addr ||
> +		     sqe->len || sqe->addr3))
> +		return -EINVAL;
> +
> +	ifq_idx = READ_ONCE(sqe->zcrx_ifq_idx);
> +	if (ifq_idx != 0)
> +		return -EINVAL;
> +	zc->ifq = req->ctx->ifq;
> +	if (!zc->ifq)
> +		return -EINVAL;

This is read and assigned to 'zc' here, but then the issue handler does
it again? I'm assuming that at some point we'll have ifq selection here,
and then the issue handler will just use zc->ifq. So this part should
probably remain, and the issue side just use zc->ifq?

> +	/* All data completions are posted as aux CQEs. */
> +	req->flags |= REQ_F_APOLL_MULTISHOT;

This puzzles me a bit...

> +	zc->flags = READ_ONCE(sqe->ioprio);
> +	zc->msg_flags = READ_ONCE(sqe->msg_flags);
> +	if (zc->msg_flags)
> +		return -EINVAL;

Maybe allow MSG_DONTWAIT at least? You already pass that in anyway.

> +	if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST | IORING_RECV_MULTISHOT))
> +		return -EINVAL;
> +
> +
> +#ifdef CONFIG_COMPAT
> +	if (req->ctx->compat)
> +		zc->msg_flags |= MSG_CMSG_COMPAT;
> +#endif
> +	return 0;
> +}

Heh, we could probably just return -EINVAL for that case, but since this
is all we need, fine.

> +
> +int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
> +	struct io_zcrx_ifq *ifq;
> +	struct socket *sock;
> +	int ret;
> +
> +	if (!(req->flags & REQ_F_POLLED) &&
> +	    (zc->flags & IORING_RECVSEND_POLL_FIRST))
> +		return -EAGAIN;
> +
> +	sock = sock_from_file(req->file);
> +	if (unlikely(!sock))
> +		return -ENOTSOCK;
> +	ifq = req->ctx->ifq;
> +	if (!ifq)
> +		return -EINVAL;

	irq = zc->ifq;

and then that check can go away too, as it should already have been
errored at prep time if this wasn't valid.

> +static bool io_zcrx_queue_cqe(struct io_kiocb *req, struct net_iov *niov,
> +			      struct io_zcrx_ifq *ifq, int off, int len)
> +{
> +	struct io_uring_zcrx_cqe *rcqe;
> +	struct io_zcrx_area *area;
> +	struct io_uring_cqe *cqe;
> +	u64 offset;
> +
> +	if (!io_defer_get_uncommited_cqe(req->ctx, &cqe))
> +		return false;
> +
> +	cqe->user_data = req->cqe.user_data;
> +	cqe->res = len;
> +	cqe->flags = IORING_CQE_F_MORE;
> +
> +	area = io_zcrx_iov_to_area(niov);
> +	offset = off + (net_iov_idx(niov) << PAGE_SHIFT);
> +	rcqe = (struct io_uring_zcrx_cqe *)(cqe + 1);
> +	rcqe->off = offset + ((u64)area->area_id << IORING_ZCRX_AREA_SHIFT);
> +	memset(&rcqe->__pad, 0, sizeof(rcqe->__pad));

Just do

	rcqe->__pad = 0;

since it's a single field.

Rest looks fine to me.

-- 
Jens Axboe

