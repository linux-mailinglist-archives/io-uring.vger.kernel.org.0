Return-Path: <io-uring+bounces-332-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 259FB81A458
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 17:19:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A5AE1C22EA6
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 16:19:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D74E4D133;
	Wed, 20 Dec 2023 16:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RsuNhbfd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0E64B13D
	for <io-uring@vger.kernel.org>; Wed, 20 Dec 2023 16:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7b714a7835cso70403039f.0
        for <io-uring@vger.kernel.org>; Wed, 20 Dec 2023 08:13:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1703088791; x=1703693591; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cVPsNf/S96zsYER9FoQUWrH/cp9G4mSwOa41CLTdXzU=;
        b=RsuNhbfdkPST/c+Kzw5mk03tWMVH8m6rMH5Vo0gru8OrNaO/2tf6L9fFP1Jf2gGKSc
         1nKxoNLJdusDX59fku/IQSp/jOTwEt137mXnBzVEdjDg4MJ81rWMDyTYURkezd6wA+i9
         fwXrmuWXXMFPJ+WaROHpaQCnm47MxgYkcHpoys8Nq9QNFwH2wNKhULzGjfj4BUEPpHBJ
         Sw6U7UIgHxAHQ7JVEhm7zReCoOzT3CVEhel6REQdb9jfc5/6NPgYpeHKmbYG4XIC9Kxh
         pn4YRgFlx4zpfU+hJCM2ktEZ5lxuLPvFUP9/DOdoCOZBUso8ahrlrKPGgTyyBOnZ+qjq
         GgQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703088791; x=1703693591;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cVPsNf/S96zsYER9FoQUWrH/cp9G4mSwOa41CLTdXzU=;
        b=kVLaEBpu4MgyL29ONqffy2ok3J4rejOGRsRWnpZzi5QLwvu/Im6LcE+N/DYksq9bGi
         3K3OC+JRqb0Yro0sKyyJjFLmkQyKVHnrykPPYhY5FIn+r4Ow5L5JY0ltUEh+kLFp9NxE
         BOeD40WCwwSiYv8rEDLY0e2Ykc37OJL+0ZI0FPOq5ldBcI+37k+6O7EQ0Lg7ZrqLXdre
         e8NqXZpNvKXv7Ff9oIBDuVKMD23Q1sBSpK/Zziv9WIKWXqXZKSiekSQfVbBr0v77DsEH
         sdROT0vXPwx9GkmkD6hULtrlppCBaoK1NDqlTxM702tM2EpRoyB7ihZis4RGHhv5o7KI
         wSWg==
X-Gm-Message-State: AOJu0YxYSU3aEsiTldhM8QVmV1LWNZrgYqPwz82m1LJk3rDvcaPDXaxl
	3RefE03eoXjKuF0PopoZTrrA0m3TrgMlDWvvLsNlXA==
X-Google-Smtp-Source: AGHT+IF0YldM6uM5mkVuHFMQBigt/J/AqAnx32A9SxbicZcoLGpskk/mDiEbVnO7tlie6OMF8HdKBg==
X-Received: by 2002:a6b:e517:0:b0:7ba:7d02:f6b3 with SMTP id y23-20020a6be517000000b007ba7d02f6b3mr1003890ioc.1.1703088790957;
        Wed, 20 Dec 2023 08:13:10 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id w26-20020a5ed61a000000b007ba783a27c3sm284931iom.11.2023.12.20.08.13.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Dec 2023 08:13:10 -0800 (PST)
Message-ID: <328d24df-1541-4643-8bac-cc81c2f25836@kernel.dk>
Date: Wed, 20 Dec 2023 09:13:09 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 07/20] io_uring: add interface queue
Content-Language: en-US
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20231219210357.4029713-1-dw@davidwei.uk>
 <20231219210357.4029713-8-dw@davidwei.uk>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231219210357.4029713-8-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/19/23 2:03 PM, David Wei wrote:
> @@ -750,6 +753,54 @@ enum {
>  	SOCKET_URING_OP_SETSOCKOPT,
>  };
>  
> +struct io_uring_rbuf_rqe {
> +	__u32	off;
> +	__u32	len;
> +	__u16	region;
> +	__u8	__pad[6];
> +};
> +
> +struct io_uring_rbuf_cqe {
> +	__u32	off;
> +	__u32	len;
> +	__u16	region;
> +	__u8	sock;
> +	__u8	flags;
> +	__u8	__pad[2];
> +};

Looks like this leaves a gap? Should be __pad[4] or probably just __u32
__pad; For all of these, definitely worth thinking about if we'll ever
need more than the slight padding. Might not hurt to always leave 8
bytes extra, outside of the required padding.

> +struct io_rbuf_rqring_offsets {
> +	__u32	head;
> +	__u32	tail;
> +	__u32	rqes;
> +	__u8	__pad[4];
> +};

Ditto here, __u32 __pad;

> +struct io_rbuf_cqring_offsets {
> +	__u32	head;
> +	__u32	tail;
> +	__u32	cqes;
> +	__u8	__pad[4];
> +};

And here.

> +
> +/*
> + * Argument for IORING_REGISTER_ZC_RX_IFQ
> + */
> +struct io_uring_zc_rx_ifq_reg {
> +	__u32	if_idx;
> +	/* hw rx descriptor ring id */
> +	__u32	if_rxq_id;
> +	__u32	region_id;
> +	__u32	rq_entries;
> +	__u32	cq_entries;
> +	__u32	flags;
> +	__u16	cpu;
> +
> +	__u32	mmap_sz;
> +	struct io_rbuf_rqring_offsets rq_off;
> +	struct io_rbuf_cqring_offsets cq_off;
> +};

You have rq_off starting at a 48-bit offset here, don't think this is
going to work as it's uapi. You'd need padding to align it to 64-bits.

> diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
> new file mode 100644
> index 000000000000..5fc94cad5e3a
> --- /dev/null
> +++ b/io_uring/zc_rx.c
> +int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
> +			  struct io_uring_zc_rx_ifq_reg __user *arg)
> +{
> +	struct io_uring_zc_rx_ifq_reg reg;
> +	struct io_zc_rx_ifq *ifq;
> +	int ret;
> +
> +	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
> +		return -EINVAL;
> +	if (copy_from_user(&reg, arg, sizeof(reg)))
> +		return -EFAULT;
> +	if (ctx->ifq)
> +		return -EBUSY;
> +	if (reg.if_rxq_id == -1)
> +		return -EINVAL;
> +
> +	ifq = io_zc_rx_ifq_alloc(ctx);
> +	if (!ifq)
> +		return -ENOMEM;
> +
> +	/* TODO: initialise network interface */
> +
> +	ret = io_allocate_rbuf_ring(ifq, &reg);
> +	if (ret)
> +		goto err;
> +
> +	/* TODO: map zc region and initialise zc pool */
> +
> +	ifq->rq_entries = reg.rq_entries;
> +	ifq->cq_entries = reg.cq_entries;
> +	ifq->if_rxq_id = reg.if_rxq_id;
> +	ctx->ifq = ifq;

As these TODO's are removed in later patches, I think you should just
not include them to begin with. It reads more like notes to yourself,
doesn't really add anything to the series.

> +void io_shutdown_zc_rx_ifqs(struct io_ring_ctx *ctx)
> +{
> +	lockdep_assert_held(&ctx->uring_lock);
> +}

This is a bit odd?

-- 
Jens Axboe


