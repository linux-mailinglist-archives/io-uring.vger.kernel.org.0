Return-Path: <io-uring+bounces-6627-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FAD9A4044A
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 01:39:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D84A3AF124
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2025 00:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36F3E42A94;
	Sat, 22 Feb 2025 00:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NMyqlQuP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D22E273FE
	for <io-uring@vger.kernel.org>; Sat, 22 Feb 2025 00:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740184743; cv=none; b=sd3gsw+nua0CB3238G/vhfyohI7h2N6zYH1D2Jk+CCvZk3Vnm6WoWvOcKE4DpQETY/fLmCUcjcMdwDjsLXZ2Vi689UCZXgpsHS6cYsgxGNOZBOEGJb6TsbIKwMnlQDZ7p084BTGtEnT6MpvWb4z15C2PcNhg/HRcgglPzg72FDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740184743; c=relaxed/simple;
	bh=rfbeCk6ryUyrI9rK13kuqdfFaor+rsH1GvGGPnFKQKk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hOjicMnLzppoKAQ6olt9CeYiVfEgP4g2thnfT0yM36XVBDiRzkb4IaaOnLDw2+K2KdTU9Q3As5j8eOsGMqsiAUswCB8XNR9mdVNiiQNdb920icRniWEwP4BWtKzMCEneAhaerXGOFUf6mVqxVxqCY4wCsc3ln+hLj3UtjZPkqpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NMyqlQuP; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-38f6475f747so1208289f8f.3
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2025 16:39:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740184739; x=1740789539; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cTpPRt6rW77NVGIZarKQ50sAWhKVDwMEGv/PXjlD04k=;
        b=NMyqlQuP0AxPO/eNCxCZG7+grKzAbA2LgSOkQ9kNKS2VtjYpzW3KgjzSYorlMhU3Fm
         h0MG1mHzrCAZdnDAg5afkcCe5n8qv4LuiRAbj7cTNlaw1q8SOgraxSoV7gEzQ8WitNZw
         lnJ8FbHbwX/7Uw7AnBCz2yYhwXRmwq0n4mWL13YJeq/mOkRFF1YNfF1fykL655G+zUtQ
         TgLCK6vomiJKxgnIcWiAHtxZhpC82M2MasMm+PnsVe1pUD384dYYyxDXMbncr/LZTv2O
         548tEUryRUoClhSWkRB16tD0FivydsD8SLaprpjwVVIfwdCHRTO2Q8B2PPRlAgFLgPtA
         vvvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740184739; x=1740789539;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cTpPRt6rW77NVGIZarKQ50sAWhKVDwMEGv/PXjlD04k=;
        b=Rbfh0w5kXghHzt6C670aAxIz87MS+RMn4woVXt/ZbgfsAgtnviL7OOraKsleDn+czS
         QUr84GS2XPxWa3bkj8QEhwdMN5B669NPpaEn5q3wt1kBdbOPoQA6MYQ/t2bd6qFGpNjH
         8tAbTL9Zjn1oi8/htniGayaVF9jNfeEB/u9jwYhGsG5LX7j4Ftpo7d0pEmlxsOWMyBdw
         +y9Uk4Dm4hNKTV4yS5tm1njMDxsmKlSBJZ17ZPM3AHar1ll1mSNncMyHAwkxBqC895sP
         4rNJN8aL92q/rmPOIUKO8mGBNu/yOe4k59aqcVsUbsASlrv/8vJDOEIHD0g67KZAjlNJ
         +syQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2Ud3Bp9kiHEaC9ih4h2lx+MpVEl9A4P5baCQFXI4uGhHI0lb9E84UGwpGHcEDIoIiO5aFI7rJYQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YytCW3F784q/5WaT6JExK+BohrYVDa7jKP9fEI8mzjdz0+QJCaJ
	vLd+ridpjCxLKBhcDCyiEysQg9auF/JYgfQQiJD8yBYLJ9++EZb5
X-Gm-Gg: ASbGncvNIGo81eQ25NJv9YiFgXCVQAxJ44Y6kL+xkj6B+XMfjl+tE5YfyE+ubfdpYBy
	KvLGYoR8vX3bUM+BZpexo0Oa257aeqrqmT1mmdXlOuFCG32DSP88XINXjiO9QnHYS7fAdzs9jw8
	SZRGE5+/8W+H7yxuOC13idlaTe9dnkvdE09EI1LLzdnftEytCjYp2tdYc2nWdN8bIezlFEgEKsP
	iPMlol6ClE0+/9lbh2TzymdrYjVnmfdcHJAdk5R5o6z8ey/DwACJo+AiHQ3gc8k4LoOr7qofYWZ
	NUSpv1UcYo3r5i3AvTQZ4UC9DRTGYx4Nsu7i
X-Google-Smtp-Source: AGHT+IFX0wEw6KsclxQR8u0uE/XGMZAr+NWGzO50bX/F60YC2AuwElzczImy8+VzSmacOvCLGVEgsQ==
X-Received: by 2002:a05:6000:1447:b0:38d:c99a:c1de with SMTP id ffacd0b85a97d-38f6e95e632mr4445115f8f.19.1740184739314;
        Fri, 21 Feb 2025 16:38:59 -0800 (PST)
Received: from [192.168.8.100] ([148.252.141.194])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-439b0371cfcsm31418085e9.36.2025.02.21.16.38.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 16:38:58 -0800 (PST)
Message-ID: <6165d6a4-a8d3-4c2f-8550-e157a279c8f3@gmail.com>
Date: Sat, 22 Feb 2025 00:40:03 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] io_uring/zcrx: add single shot recvzc
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20250221205146.1210952-1-dw@davidwei.uk>
 <20250221205146.1210952-2-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250221205146.1210952-2-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/21/25 20:51, David Wei wrote:
> Currently only multishot recvzc requests are supported, but sometimes
> there is a need to do a single recv e.g. peeking at some data in the
> socket. Add single shot recvzc requests where IORING_RECV_MULTISHOT is
> _not_ set and the sqe->len field is set to the number of bytes to read
> N.

There is no oneshot, we need to change the message.


> There could be multiple completions containing data, like the multishot
> case, since N bytes could be split across multiple frags. This is
> followed by a final completion with res and cflags both set to 0 that
> indicate the completion of the request, or a -res that indicate an
> error.
> 
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>   io_uring/net.c  | 19 +++++++++++++++++--
>   io_uring/zcrx.c | 17 ++++++++++++-----
>   io_uring/zcrx.h |  2 +-
>   3 files changed, 30 insertions(+), 8 deletions(-)
> 
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 000dc70d08d0..cae34a24266c 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -94,6 +94,7 @@ struct io_recvzc {
>   	struct file			*file;
>   	unsigned			msg_flags;
>   	u16				flags;
> +	u32				len;
>   	struct io_zcrx_ifq		*ifq;
>   };
>   
> @@ -1241,7 +1242,7 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   	unsigned ifq_idx;
>   
>   	if (unlikely(sqe->file_index || sqe->addr2 || sqe->addr ||
> -		     sqe->len || sqe->addr3))
> +		     sqe->addr3))
>   		return -EINVAL;
>   
>   	ifq_idx = READ_ONCE(sqe->zcrx_ifq_idx);
> @@ -1250,6 +1251,12 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   	zc->ifq = req->ctx->ifq;
>   	if (!zc->ifq)
>   		return -EINVAL;
> +	zc->len = READ_ONCE(sqe->len);
> +	if (zc->len == UINT_MAX)
> +		return -EINVAL;

The uapi gives u32, if we're using a special value it should
match the type. ~(u32)0

> +	/* UINT_MAX means no limit on readlen */
> +	if (!zc->len)
> +		zc->len = UINT_MAX;
>   
>   	zc->flags = READ_ONCE(sqe->ioprio);
>   	zc->msg_flags = READ_ONCE(sqe->msg_flags);
> @@ -1269,6 +1276,7 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
>   {
>   	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
> +	bool limit = zc->len != UINT_MAX;
>   	struct socket *sock;
>   	int ret;
>   
> @@ -1281,7 +1289,7 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
>   		return -ENOTSOCK;
>   
>   	ret = io_zcrx_recv(req, zc->ifq, sock, zc->msg_flags | MSG_DONTWAIT,
> -			   issue_flags);
> +			   issue_flags, &zc->len);
>   	if (unlikely(ret <= 0) && ret != -EAGAIN) {
>   		if (ret == -ERESTARTSYS)
>   			ret = -EINTR;
> @@ -1296,6 +1304,13 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
>   		return IOU_OK;
>   	}
>   
> +	if (zc->len == 0) {

If len hits zero we should always complete it, regardless
of errors the stack might have returned, so might be
cleaner if you do that check right after io_zcrx_recv().

> +		io_req_set_res(req, 0, 0);
> +
> +		if (issue_flags & IO_URING_F_MULTISHOT)
> +			return IOU_STOP_MULTISHOT;
> +		return IOU_OK;
> +	}
>   	if (issue_flags & IO_URING_F_MULTISHOT)
>   		return IOU_ISSUE_SKIP_COMPLETE;
>   	return -EAGAIN;
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index f2d326e18e67..74bca4e471bc 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -817,6 +817,7 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
>   	int i, copy, end, off;
>   	int ret = 0;
>   
> +	len = min_t(size_t, len, desc->count);
>   	if (unlikely(args->nr_skbs++ > IO_SKBS_PER_CALL_LIMIT))
>   		return -EAGAIN;
>   
> @@ -894,26 +895,32 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
>   out:
>   	if (offset == start_off)
>   		return ret;
> +	if (desc->count != UINT_MAX)
> +		desc->count -= (offset - start_off);

I'd say just set desc->count to it's max value (size_t), and
never care about checking for limits after.

>   	return offset - start_off;
>   }
>   
>   static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>   				struct sock *sk, int flags,
> -				unsigned issue_flags)
> +				unsigned issue_flags, unsigned int *outlen)
>   {
> +	unsigned int len = *outlen;
> +	bool limit = len != UINT_MAX;
>   	struct io_zcrx_args args = {
>   		.req = req,
>   		.ifq = ifq,
>   		.sock = sk->sk_socket,
>   	};
>   	read_descriptor_t rd_desc = {
> -		.count = 1,
> +		.count = len,
>   		.arg.data = &args,
>   	};
>   	int ret;
>   
>   	lock_sock(sk);
>   	ret = tcp_read_sock(sk, &rd_desc, io_zcrx_recv_skb);
> +	if (limit && ret)
> +		*outlen = len - ret;
>   	if (ret <= 0) {
>   		if (ret < 0 || sock_flag(sk, SOCK_DONE))
>   			goto out;
> @@ -930,7 +937,7 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
>   		ret = IOU_REQUEUE;
>   	} else if (sock_flag(sk, SOCK_DONE)) {
>   		/* Make it to retry until it finally gets 0. */
> -		if (issue_flags & IO_URING_F_MULTISHOT)
> +		if (!limit && (issue_flags & IO_URING_F_MULTISHOT))
>   			ret = IOU_REQUEUE;

And with earlier len check in net.c you don't need this change,
which feels wrong, as it's only here to circumvent some handling
in net.c, I assume

-- 
Pavel Begunkov


