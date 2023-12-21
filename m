Return-Path: <io-uring+bounces-339-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5510881AC4E
	for <lists+io-uring@lfdr.de>; Thu, 21 Dec 2023 02:44:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11B7A28387A
	for <lists+io-uring@lfdr.de>; Thu, 21 Dec 2023 01:44:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89EC115AE;
	Thu, 21 Dec 2023 01:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="W8SyYAyB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214243C0F
	for <io-uring@vger.kernel.org>; Thu, 21 Dec 2023 01:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1d3e6c86868so2726275ad.1
        for <io-uring@vger.kernel.org>; Wed, 20 Dec 2023 17:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1703123044; x=1703727844; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bgED0JL37f6PkBiFDCxfuY2nzyXWc9VTTnJlnrRjf1I=;
        b=W8SyYAyBuZ/Sxizl7X1AyWxr9hApVhSiHxgFWpBQuUSFJTYhk03wESKjOjeylB8b3O
         wJwRa2Sf3Fj1QjgSScp4Jmkoa29Yi93NuolScgiiYFDkWY0HHMVeVNtQlAG8kNWsawBJ
         dVJJjHFN32X2rXpRu3rU1KN9M3/eOIkG2aCXygO/94qVZJMfy6YLfNW7nEYjbzNudnDy
         uwD1i+T8NPlpQo7je6/ZSTN1iRvI7ckZxPnuBDo0/KD3zwKbzzPxx5EhkBznt0ay+YFQ
         bd3N6rJBrEtBP/19e319k/WhuSABmuQ05Z3tk35AHY+IzHkYpwRD3aVreyllK+0pOdgW
         wk6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703123044; x=1703727844;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bgED0JL37f6PkBiFDCxfuY2nzyXWc9VTTnJlnrRjf1I=;
        b=pKkFMYz4L3BLNuxBFny3iDwFhKeUuPPYm0+mA2UwYOPBq4GFYE99P90TPfzsE8/B+i
         CN5EnXp5NrWIJCS+6LxifbpF8WPTg0P5oYEpn/ufLPmoLRBZAZ2Vx3PBjpRoaZL/sDXu
         N4j10vvpVWSabKAikdHYZOJuJ1cFSFat8r+pSTcI+AP/vxJocp1KmdqJ2btCaBdZ24ni
         Eaq6hhUv82Jtz8X6iZExyRl1dkw2pPjJ7EGv/YSF7G30qoGTh7C4kYJrcriJXASF161q
         eSFnnJGrsXU1Shr+pwr3OsnzK7F0C1tcfAdkSrLCg1mx1yanvXmxAc6CkCf10DdsogIt
         UkGQ==
X-Gm-Message-State: AOJu0YzYuXtyR00PjuJfe3VjEKLLd6JSJYpkn4ihvKF/TxtOuQkWxcc9
	kXKNSf3hkVbfnOy4y3m8bwma1w==
X-Google-Smtp-Source: AGHT+IG4M1uOiIrQYUPh323xCnfL87oUnwJoi3QiX1MLKtPfsVvWOyrJyp7doejQDCTtTZLCjDqtWw==
X-Received: by 2002:a17:903:246:b0:1d3:bc96:6c13 with SMTP id j6-20020a170903024600b001d3bc966c13mr7597293plh.35.1703123044420;
        Wed, 20 Dec 2023 17:44:04 -0800 (PST)
Received: from ?IPV6:2620:10d:c085:2103:835:39e6:facb:229b? ([2620:10d:c090:400::4:4f9])
        by smtp.gmail.com with ESMTPSA id ja22-20020a170902efd600b001cfb99d8b82sm371961plb.136.2023.12.20.17.44.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Dec 2023 17:44:04 -0800 (PST)
Message-ID: <65783fb3-5209-45a3-a4bf-7b3b7acaa75e@davidwei.uk>
Date: Wed, 20 Dec 2023 17:44:02 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 07/20] io_uring: add interface queue
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20231219210357.4029713-1-dw@davidwei.uk>
 <20231219210357.4029713-8-dw@davidwei.uk>
 <328d24df-1541-4643-8bac-cc81c2f25836@kernel.dk>
Content-Language: en-GB
From: David Wei <dw@davidwei.uk>
In-Reply-To: <328d24df-1541-4643-8bac-cc81c2f25836@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2023-12-20 08:13, Jens Axboe wrote:
> On 12/19/23 2:03 PM, David Wei wrote:
>> @@ -750,6 +753,54 @@ enum {
>>  	SOCKET_URING_OP_SETSOCKOPT,
>>  };
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

Apologies, it's been a while since I last pahole'd these structs. We may
have added more fields later and reintroduced gaps.

> 
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

I will remove the io_rbuf_cqring in a future patchset which should
simplify things, but io_rbuf_rqring will stay. I'll make sure offsets
are 64-bit aligned.

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

Got it, will remove them.

> 
>> +void io_shutdown_zc_rx_ifqs(struct io_ring_ctx *ctx)
>> +{
>> +	lockdep_assert_held(&ctx->uring_lock);
>> +}
> 
> This is a bit odd?
> 

