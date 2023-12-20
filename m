Return-Path: <io-uring+bounces-335-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F4A481A513
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 17:29:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C04F71F28479
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 16:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14FF140BF5;
	Wed, 20 Dec 2023 16:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ccxo0DOZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B293F8F5;
	Wed, 20 Dec 2023 16:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-40c48d7a7a7so54225075e9.3;
        Wed, 20 Dec 2023 08:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703089746; x=1703694546; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5ePHJRVlXqAsB+rYbVrjKZKMeyMxPoDcsXz/eFlQRS8=;
        b=ccxo0DOZVk3cUOGQGZdxBVwAYgM7DfawzaG8/tSkmk9aJLZb0lwNKhTxpIx874pKAA
         C2QkOOFrLxWOezDlNnruyddjFmmh61YMQY2nntVHAb6diwyRHZq4xfeH5kxay++6uNH/
         dEL3aZEfx0CM9OD9Bfofzd1WU0Mfulh/lOIXv1D9jQ1LqolDNzFXQvzFE4QfPFZK9nwv
         qhZC1TbECMb3jUmexuwo3+ObEy0kYaEA5fMUbQxKQTHrNbVMOu0fsoo4B2h65OTNXL7v
         WwZD+kKGaD6cAJ3VQaZ5fI7Mf1g2IIDtU6RxCH9A0OZOST0dGRNqgonhqn3Df9JUX+E9
         +HSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703089746; x=1703694546;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5ePHJRVlXqAsB+rYbVrjKZKMeyMxPoDcsXz/eFlQRS8=;
        b=TsKesgVLrE0TNqe+gya7Wem4SBeI+8WWe3x1VnGyHhfcwcNSOU5G7doqhkBKv9u6tP
         z4/ozkDZlb6i6wS8X2Qexv3a1DS8pCsC9vpkSV7fUJztl4QhmyttPOHdSnzDKSiNHQ3k
         fynayWoF9h+rB7Y7JxkmUSB/fuQU9WlKKi+9U85Ds/6insh6uNR8CcvPNAdl8XgHzDki
         pfj2bKvg5sHnXcj8nJyUd7qCMs5oy1CkNibbv6scYSoV9ssWPAG0qP4KswqrCmWGsSpW
         l6zWnTe/cwKxJ/c1XJ7CtF6i2F89BZ107O/977h/6jZGp3inBnh4Fd98bh4zsXKD6RFY
         7P9g==
X-Gm-Message-State: AOJu0Ywp5t9Ic4iCgtZ4NSzY9nAK4t/3qhO3m0GhJzdsntSNbTC7mRlx
	Mucmx6yVRfz2Qn54e29tVL8=
X-Google-Smtp-Source: AGHT+IFSpGMQoEea1amF9FEB+Nl5VaCX5sQbYQ5oK/2b0AucHt/FjytZdBmFTdLdEBNhDXE6m5axWQ==
X-Received: by 2002:a05:600c:3411:b0:404:4b6f:d70d with SMTP id y17-20020a05600c341100b004044b6fd70dmr11787674wmp.17.1703089746380;
        Wed, 20 Dec 2023 08:29:06 -0800 (PST)
Received: from [192.168.8.100] ([148.252.132.119])
        by smtp.gmail.com with ESMTPSA id v11-20020a05600c470b00b0040c5cf930e6sm157741wmo.19.2023.12.20.08.29.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Dec 2023 08:29:06 -0800 (PST)
Message-ID: <aa7613b5-8096-4419-9817-4e56e70f4dd1@gmail.com>
Date: Wed, 20 Dec 2023 16:23:13 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 07/20] io_uring: add interface queue
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20231219210357.4029713-1-dw@davidwei.uk>
 <20231219210357.4029713-8-dw@davidwei.uk>
 <328d24df-1541-4643-8bac-cc81c2f25836@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <328d24df-1541-4643-8bac-cc81c2f25836@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/20/23 16:13, Jens Axboe wrote:
> On 12/19/23 2:03 PM, David Wei wrote:
>> @@ -750,6 +753,54 @@ enum {
>>   	SOCKET_URING_OP_SETSOCKOPT,
>>   };
>>   
>> +struct io_uring_rbuf_rqe {
>> +	__u32	off;
>> +	__u32	len;
>> +	__u16	region;
>> +	__u8	__pad[6];
>> +};
>> +
>> +struct io_uring_rbuf_cqe {
>> +	__u32	off;
>> +	__u32	len;
>> +	__u16	region;
>> +	__u8	sock;
>> +	__u8	flags;
>> +	__u8	__pad[2];
>> +};
> 
> Looks like this leaves a gap? Should be __pad[4] or probably just __u32
> __pad; For all of these, definitely worth thinking about if we'll ever
> need more than the slight padding. Might not hurt to always leave 8
> bytes extra, outside of the required padding.

Good catch, and that all should be paholed to ensure all of them
are fitted nicely.

FWIW, the format will also be revisited, e.g. max 256 sockets per
ifq is too restrictive, and most probably moved from a separate queue
into the CQ.


>> +struct io_rbuf_rqring_offsets {
>> +	__u32	head;
>> +	__u32	tail;
>> +	__u32	rqes;
>> +	__u8	__pad[4];
>> +};
> 
> Ditto here, __u32 __pad;
> 
>> +struct io_rbuf_cqring_offsets {
>> +	__u32	head;
>> +	__u32	tail;
>> +	__u32	cqes;
>> +	__u8	__pad[4];
>> +};
> 
> And here.
> 
>> +
>> +/*
>> + * Argument for IORING_REGISTER_ZC_RX_IFQ
>> + */
>> +struct io_uring_zc_rx_ifq_reg {
>> +	__u32	if_idx;
>> +	/* hw rx descriptor ring id */
>> +	__u32	if_rxq_id;
>> +	__u32	region_id;
>> +	__u32	rq_entries;
>> +	__u32	cq_entries;
>> +	__u32	flags;
>> +	__u16	cpu;
>> +
>> +	__u32	mmap_sz;
>> +	struct io_rbuf_rqring_offsets rq_off;
>> +	struct io_rbuf_cqring_offsets cq_off;
>> +};
> 
> You have rq_off starting at a 48-bit offset here, don't think this is
> going to work as it's uapi. You'd need padding to align it to 64-bits.
> 
>> diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
>> new file mode 100644
>> index 000000000000..5fc94cad5e3a
>> --- /dev/null
>> +++ b/io_uring/zc_rx.c
>> +int io_register_zc_rx_ifq(struct io_ring_ctx *ctx,
>> +			  struct io_uring_zc_rx_ifq_reg __user *arg)
>> +{
>> +	struct io_uring_zc_rx_ifq_reg reg;
>> +	struct io_zc_rx_ifq *ifq;
>> +	int ret;
>> +
>> +	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
>> +		return -EINVAL;
>> +	if (copy_from_user(&reg, arg, sizeof(reg)))
>> +		return -EFAULT;
>> +	if (ctx->ifq)
>> +		return -EBUSY;
>> +	if (reg.if_rxq_id == -1)
>> +		return -EINVAL;
>> +
>> +	ifq = io_zc_rx_ifq_alloc(ctx);
>> +	if (!ifq)
>> +		return -ENOMEM;
>> +
>> +	/* TODO: initialise network interface */
>> +
>> +	ret = io_allocate_rbuf_ring(ifq, &reg);
>> +	if (ret)
>> +		goto err;
>> +
>> +	/* TODO: map zc region and initialise zc pool */
>> +
>> +	ifq->rq_entries = reg.rq_entries;
>> +	ifq->cq_entries = reg.cq_entries;
>> +	ifq->if_rxq_id = reg.if_rxq_id;
>> +	ctx->ifq = ifq;
> 
> As these TODO's are removed in later patches, I think you should just
> not include them to begin with. It reads more like notes to yourself,
> doesn't really add anything to the series.
> 
>> +void io_shutdown_zc_rx_ifqs(struct io_ring_ctx *ctx)
>> +{
>> +	lockdep_assert_held(&ctx->uring_lock);
>> +}
> 
> This is a bit odd?

Oh, this chunk actually leaked here from my rebases, which is not
a big deal as it provides the interface and a later patch implements
it, but might be better to move it there in the first place.

-- 
Pavel Begunkov

