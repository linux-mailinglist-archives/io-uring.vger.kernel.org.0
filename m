Return-Path: <io-uring+bounces-6579-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A878FA3DB94
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 14:44:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70C9E3B8DFC
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 13:44:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E1831F8F09;
	Thu, 20 Feb 2025 13:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cnGc+g6C"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4454E1F76C0;
	Thu, 20 Feb 2025 13:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740059079; cv=none; b=g6zXOFyHRjEabhjBvhjS6YNlTm3CLKTUIMzYkJpUF6egkhf5pEax/LMNi0SFt0rZ6W79Dt449XUXJm1hyL1dTFH/4oq9w9NIjk7RZ8oD0+coszizL/NAu6RqUVtA69KkyBYJl9QYUJ5bbF9UWeacGE2x9GIkDfm9p4oEEhHEUMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740059079; c=relaxed/simple;
	bh=CMwWUZ03W806TkHXwe3kr5Wl7XYfSq37ASDCGimHEIY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tj0/jpkEeQVto/kg+PFO0UaUoxZIkhylSsJTg78cVMT0mfbfd+BpCFE7JJJlx6zHY4lCqJOnUbcX4RBDX5pRutk+O3GcavWfQumCOx3Gr8se0zOXpDf9HiQ8HQSnw78K5I7i0IYvmCbnLWWVD4cU9CgDv7BLOftjJhOJ+/6xdcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cnGc+g6C; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-abb86beea8cso195995066b.1;
        Thu, 20 Feb 2025 05:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740059075; x=1740663875; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wH3ItxDnpHtPrcEc6Ys9D8rM2UII7vdj5WIe0si5L3c=;
        b=cnGc+g6C56En6WyT8qQ+EoVCc6CM72LtG8EF8JP6UOZBFbnep8BND+NgwwjAWhBx90
         VnLsjE2fedjK1LppDR1H4EHYezQgaKiHn2VUIhrZpwTTOgbBYatISHf+wsdm+l9ORQaI
         p+puye5p3ZAt84kPhqr98YoREKlqWARLinohfLGUJ6qJV/pnGxej8npH0TErakuzbIZT
         zeOE/ELMU06AWRerAB33nkSBWokLMgS5tCIOaCZS7Qyi7X6Z0gQrRJtOl01PX7DA0S6R
         F5kUb6QFpliXjI7vrSYVa4CDTdXTrwuH7DrsvhcMu+j+dhUr9DRCbD0kBUV7QbKBK3fp
         lA6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740059075; x=1740663875;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wH3ItxDnpHtPrcEc6Ys9D8rM2UII7vdj5WIe0si5L3c=;
        b=Tu1wI/qnzJAhefClOBVP56izB/EaUeNyaQ5ALft1Gjj4vFd8M8sIMbGJOV72gF9vVv
         NvMSBF1OeX1yAhDGLNlTrGJ2rSowknW7PN42ivk0a1l7LHJnmVGwbs7pfZaNG6phzBgd
         SyTv4gy0vKAH4EVnzbqgzkZuRlONjwkqztitkeLor2ZaLL8OwSNh8f5gpfdCp+JTr5wg
         1bpgJL1ngkcZ6oc7vR3a79/fkXqcQB/5hmzucCe5vdE/tSjK2VXse3OkAEbyJde89FB5
         Dt2XBzcRqMgbxEZeBv8eI39siDXWcPJrBtOFBPvYSkm7ajAMNX/inWkw+cvNc3+oqeE7
         Nm7A==
X-Forwarded-Encrypted: i=1; AJvYcCUgJhB33JUha1mBdITFTAltXC86DWCYe32WLJPXkIw5FwTOEkkUmZIl4jbddxhZW4Z61mekGg7J@vger.kernel.org, AJvYcCWI8prGza4+zvIkQyo279Tx/qXNbpp9NRMuTTgIfVtRr2zcjEgwq9IPQtmGRocX7uaKK1OJ7dCoiA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwQWj0SZX6csmq2j8rFg9aBl8Hxsv0SJvvcaf9MBGAbZlJBePZ3
	w5lrqXFGc+9ctMCh8vKVRcsJQh9D7dgL6yvPHSf7MjhEUsK6A10f
X-Gm-Gg: ASbGncuYz4VW2/nTECUagad46LxcanMMqTP7ogqTYljrQcePoVROgtPsyR9d+hQxBdS
	CRpjBmJPIb0F25honOrcVl29Wh5WlKh8e7gFYFtMHgDS5V+UkY8z2H0Tp9ROlo7070zxbSzOxjO
	rz/yHmqZ+A+r/F7Jhq7U6RD2ZvIEn0+OAMFq4qAQhw9oGKmtABxh1aucAnAnMsHGi8BdQ2j6npS
	PrFbabk/P6ImWPw4F/hqGrT0lQmF0r5idMq9RbplvySj5693FJc4RputnsvJEh7Kq3nQKJG8whx
	7uabDMqmhCXTCGiEe1HLydCJhub3de8MH+qhDt2BkAYz7zap
X-Google-Smtp-Source: AGHT+IELkEkYK+QAvOvQS5be6WORIcG1J6+OzZZX1+JCVNyeFLOHcip9wfXoeIBG+zOwECkOOu3Qlw==
X-Received: by 2002:a17:906:309a:b0:abb:b3e6:26c2 with SMTP id a640c23a62f3a-abbccf054b5mr680717166b.25.1740059075149;
        Thu, 20 Feb 2025 05:44:35 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:f455])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abba4fc0c29sm688721966b.157.2025.02.20.05.44.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2025 05:44:34 -0800 (PST)
Message-ID: <270ce534-d33e-4642-b0dc-87e377025825@gmail.com>
Date: Thu, 20 Feb 2025 13:45:37 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] io_uring/zcrx: add single shot recvzc
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>
References: <20250218165714.56427-1-dw@davidwei.uk>
 <20250218165714.56427-2-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250218165714.56427-2-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/18/25 16:57, David Wei wrote:
> Currently only multishot recvzc requests are supported, but sometimes
> there is a need to do a single recv e.g. peeking at some data in the
> socket. Add single shot recvzc requests where IORING_RECV_MULTISHOT is
> _not_ set and the sqe->len field is set to the number of bytes to read
> N.
> 
> There could be multiple completions containing data, like the multishot
> case, since N bytes could be split across multiple frags. This is
> followed by a final completion with res and cflags both set to 0 that
> indicate the completion of the request, or a -res that indicate an
> error.
> 
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>   io_uring/net.c  | 26 ++++++++++++++++++--------
>   io_uring/zcrx.c | 17 ++++++++++++++---
>   io_uring/zcrx.h |  2 +-
>   3 files changed, 33 insertions(+), 12 deletions(-)
> 
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 000dc70d08d0..d3a9aaa52a13 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -94,6 +94,7 @@ struct io_recvzc {
>   	struct file			*file;
>   	unsigned			msg_flags;
>   	u16				flags;
> +	u32				len;

Something is up with the types, it's u32, for which you use
UINT_MAX, and later convert to ulong.

>   	struct io_zcrx_ifq		*ifq;
>   };
>   
...
> @@ -1250,6 +1251,9 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   	zc->ifq = req->ctx->ifq;
>   	if (!zc->ifq)
>   		return -EINVAL;
> +	zc->len = READ_ONCE(sqe->len);
> +	if (zc->len == UINT_MAX)
> +		return -EINVAL;
>   
>   	zc->flags = READ_ONCE(sqe->ioprio);
>   	zc->msg_flags = READ_ONCE(sqe->msg_flags);
> @@ -1257,12 +1261,14 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   		return -EINVAL;
>   	if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST | IORING_RECV_MULTISHOT))
>   		return -EINVAL;
> -	/* multishot required */
> -	if (!(zc->flags & IORING_RECV_MULTISHOT))
> -		return -EINVAL;
> -	/* All data completions are posted as aux CQEs. */
> -	req->flags |= REQ_F_APOLL_MULTISHOT;
> -
> +	if (zc->flags & IORING_RECV_MULTISHOT) {
> +		if (zc->len)
> +			return -EINVAL;
> +		/* All data completions are posted as aux CQEs. */
> +		req->flags |= REQ_F_APOLL_MULTISHOT;

If you're posting "aux" cqes you have to set the flag for
synchronisation reasons. We probably can split out a "I want to post
aux cqes" flag, but it seems like you don't actually care about
multishot here but limiting the length, or limiting the length + nowait.

> +	}
> +	if (!zc->len)
> +		zc->len = UINT_MAX;
>   	return 0;
>   }
>   
> @@ -1281,7 +1287,7 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
>   		return -ENOTSOCK;
>   
>   	ret = io_zcrx_recv(req, zc->ifq, sock, zc->msg_flags | MSG_DONTWAIT,
> -			   issue_flags);
> +			   issue_flags, zc->len);
>   	if (unlikely(ret <= 0) && ret != -EAGAIN) {
>   		if (ret == -ERESTARTSYS)
>   			ret = -EINTR;
> @@ -1296,6 +1302,10 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
>   		return IOU_OK;
>   	}
>   
> +	if (zc->len != UINT_MAX) {
> +		io_req_set_res(req, ret, 0);
> +		return IOU_OK;
> +	}
>   	if (issue_flags & IO_URING_F_MULTISHOT)
>   		return IOU_ISSUE_SKIP_COMPLETE;
>   	return -EAGAIN;
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index ea099f746599..834c887743c8 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -106,6 +106,7 @@ struct io_zcrx_args {
>   	struct io_zcrx_ifq	*ifq;
>   	struct socket		*sock;
>   	unsigned		nr_skbs;
> +	unsigned long		len;
>   };
>   
>   static const struct memory_provider_ops io_uring_pp_zc_ops;
> @@ -826,6 +827,10 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
>   	int i, copy, end, off;
>   	int ret = 0;
>   
> +	if (args->len == 0)
> +		return -EINTR;
> +	len = (args->len != UINT_MAX) ? min_t(size_t, len, args->len) : len;

Just min?

> +
>   	if (unlikely(args->nr_skbs++ > IO_SKBS_PER_CALL_LIMIT))
>   		return -EAGAIN;
>   
> @@ -920,17 +925,21 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
>   out:
>   	if (offset == start_off)
>   		return ret;
> +	args->len -= (offset - start_off);

Doesn't it unconditionally change the magic value UINT_MAX
you're trying to preserve?

> +	if (args->len == 0)
> +		desc->count = 0;
>   	return offset - start_off;
>   }
>   
>   static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>   				struct sock *sk, int flags,
> -				unsigned issue_flags)
> +				unsigned issue_flags, unsigned long len)
>   {
>   	struct io_zcrx_args args = {
>   		.req = req,
>   		.ifq = ifq,
>   		.sock = sk->sk_socket,
> +		.len = len,
>   	};
>   	read_descriptor_t rd_desc = {
>   		.count = 1,
> @@ -956,6 +965,8 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>   		ret = IOU_REQUEUE;
>   	} else if (sock_flag(sk, SOCK_DONE)) {
>   		/* Make it to retry until it finally gets 0. */
> +		if (len != UINT_MAX)
> +			goto out;
>   		if (issue_flags & IO_URING_F_MULTISHOT)
>   			ret = IOU_REQUEUE;
>   		else

-- 
Pavel Begunkov


