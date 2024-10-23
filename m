Return-Path: <io-uring+bounces-3936-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DCC29ABBDF
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 04:51:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D13251F21194
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 02:51:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B274E52F88;
	Wed, 23 Oct 2024 02:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cSDMV2rv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB93417F7
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 02:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729651864; cv=none; b=o8cI5y1dbRSxWvt1k3cTxLZr6t9nejjL3eKd29aJvVMjfsvQqUdJxt8fqzY7nf+SbXLAWbm7+5OpusQ7WDOiOxDqfGr3M47aoCXy8RPyw/qC6iO7qQx9J5CfGIK2uJmD/HT3bsydWSiCkL0+Xcic+fTAbn5QBB7Dw975Hwt5CVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729651864; c=relaxed/simple;
	bh=k8tCDLsM+gczGQPUtW3T69I2tw1Xl/qNgWcodwTbN90=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Yk8lCB4EnOXuEh9A0k00rWqxyW0a0RSscOqiVZAtcX8sLS0BXh7vWUQMhK3OnSmGNbXTB7oWhRbfKxhiGO2URsl/kmYtdub+Sk6Du5UAN4XiuJub7XIXlGLwxuLS6YuBBpwi7MJdk0URVKtGbI60Qq2eQzsP9JRO3InFFmC2j+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cSDMV2rv; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5c94c4ad9d8so8090361a12.2
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 19:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729651861; x=1730256661; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0Z9wNHdMpKIuFpPKtU7/DOG8N4f0DoaEGmCY8wskVr0=;
        b=cSDMV2rvX95tmOtXFbtvSZ/M0DxFONsLBHmkNdj6XduuQjiw+KALBaAa5g8TdHOoQq
         RNzZ5toAozptbh/dNIrBtuRZ+DqJx1ed5ZbeO6HiXKbdg3T6u3sZjb+OUm6oc3DVxiig
         LhZp9KvJx/jdGQa4Z29fyvPvJyPXh0N8oeRl5p+ZDXNTUuOHrMgn8ZjM8i7lUpiWxySi
         sgCv1rHhnwjDW7rIsEUrlq/yH/cB+0l5esZFL3z5dIUrha8UhwVzhiCgj+ToBQ+JNtnz
         HgV4s2fwXQ/fqu88Bm6tUT44OyxI90VBL3/WoAzVQjDozwORbot6iwGjRDdznObc3wV3
         HKzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729651861; x=1730256661;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Z9wNHdMpKIuFpPKtU7/DOG8N4f0DoaEGmCY8wskVr0=;
        b=eoQHdwIx83ZoLcM3XGYCSjvsOUYMzcKOmNULA2yXwanQgkV/Idf2a4j/BQAzjYmyDM
         eYBG3RV2iF9GZwkEYhvMLcz8QwtZVWikSTAhP8v801n3D8QKgHnXeDd4c8yy/QI5Pzxs
         DN4GlOwhH1/OrkGbdDg0kddk9gSwfoWXTFMPEnhr8NCDUh5bgt7CLPVcU+Opy2a+aUea
         vKPG1GTEdBvZAbglOsVMUl68Hlwm9dKMI5r0nxExXmfmO4Nn85XEeCTeptYpmipmoM3P
         NUvzt11H0ukuqL2CNs3TlJuQYw/1BQ14aVQKJq3I0i7ZuFSgU9ERAATRE8qTenxvnnoJ
         UePg==
X-Forwarded-Encrypted: i=1; AJvYcCUSz5izb+dynJqe9g8eyU0H1qX/g31MPWxppTFuYK/jWmnA591dD0mIPunyB7RCVLWUqRRs1d55rw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwV5DK8zwPN2L1zyOB0sN8lMgr9KHP2DDx0QrJCwQm1/KXh1C9S
	eyImHlMiRU7g+TZhDQY0GWT2rsW66kxLvKbu/elaUyY5huZa27ta
X-Google-Smtp-Source: AGHT+IEIWGBCctDhLfCGdOaOE7OpF8Lxay1we1Evfzbh5s6ZguiW19F91eH4q6PCKlUTPLs6LcHqhQ==
X-Received: by 2002:a05:6402:2791:b0:5cb:666e:9f8c with SMTP id 4fb4d7f45d1cf-5cb8af97d8bmr884038a12.32.1729651860975;
        Tue, 22 Oct 2024 19:51:00 -0700 (PDT)
Received: from [192.168.42.118] ([148.252.141.112])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb6696b546sm3835199a12.8.2024.10.22.19.51.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2024 19:51:00 -0700 (PDT)
Message-ID: <834c14c5-4e8b-49c9-a523-825305495c6d@gmail.com>
Date: Wed, 23 Oct 2024 03:51:41 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] io_uring/net: move send zc fixed buffer import to
 issue path
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20241022133441.855081-1-axboe@kernel.dk>
 <20241022133441.855081-4-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241022133441.855081-4-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/22/24 14:32, Jens Axboe wrote:
> Let's keep it close with the actual import, there's no reason to do this
> on the prep side. With that, we can drop one of the branches checking
> for whether or not IORING_RECVSEND_FIXED_BUF is set.
> 
> As a side-effect, get rid of req->imu usage.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   io_uring/net.c | 29 ++++++++++++++++-------------
>   1 file changed, 16 insertions(+), 13 deletions(-)
> 
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 18507658a921..a5b875a40bbf 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -76,6 +76,7 @@ struct io_sr_msg {
>   	/* initialised and used only by !msg send variants */
>   	u16				addr_len;
>   	u16				buf_group;
> +	u16				buf_index;

There is req->buf_index we can use

>   	void __user			*addr;
>   	void __user			*msg_control;
>   	/* used only for send zerocopy */
> @@ -1254,16 +1255,6 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   		}
>   	}
>   
> -	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
> -		unsigned idx = READ_ONCE(sqe->buf_index);
> -
> -		if (unlikely(idx >= ctx->nr_user_bufs))
> -			return -EFAULT;
> -		idx = array_index_nospec(idx, ctx->nr_user_bufs);
> -		req->imu = READ_ONCE(ctx->user_bufs[idx]);
> -		io_req_set_rsrc_node(notif, ctx, 0);
> -	}
> -
>   	if (req->opcode == IORING_OP_SEND_ZC) {
>   		if (READ_ONCE(sqe->__pad3[0]))
>   			return -EINVAL;
> @@ -1279,6 +1270,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   	zc->buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
>   	zc->len = READ_ONCE(sqe->len);
>   	zc->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL | MSG_ZEROCOPY;
> +	zc->buf_index = READ_ONCE(sqe->buf_index);
>   	if (zc->msg_flags & MSG_DONTWAIT)
>   		req->flags |= REQ_F_NOWAIT;
>   
> @@ -1339,13 +1331,24 @@ static int io_sg_from_iter(struct sk_buff *skb,
>   	return ret;
>   }
>   
> -static int io_send_zc_import(struct io_kiocb *req, struct io_async_msghdr *kmsg)
> +static int io_send_zc_import(struct io_kiocb *req, unsigned int issue_flags)
>   {
>   	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
> +	struct io_async_msghdr *kmsg = req->async_data;
>   	int ret;
>   
>   	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
> -		ret = io_import_fixed(ITER_SOURCE, &kmsg->msg.msg_iter, req->imu,
> +		struct io_ring_ctx *ctx = req->ctx;
> +		struct io_mapped_ubuf *imu;
> +		int idx;
> +
> +		if (unlikely(sr->buf_index >= ctx->nr_user_bufs))
> +			return -EFAULT;
> +		idx = array_index_nospec(sr->buf_index, ctx->nr_user_bufs);
> +		imu = READ_ONCE(ctx->user_bufs[idx]);
> +		io_req_set_rsrc_node(sr->notif, ctx, issue_flags);

This entire section should be under uring_lock. First, we're looking
at a imu that can be freed at any moment because io_req_set_rsrc_node()
is done after. And even if change the order nothing guarantees that the
CPU sees the imu content right.

FWIW, seems nobody was passing non-zero flags to io_req_set_rsrc_node()
before this series, we should just kill the parameter.

> +
> +		ret = io_import_fixed(ITER_SOURCE, &kmsg->msg.msg_iter, imu,
>   					(u64)(uintptr_t)sr->buf, sr->len);
>   		if (unlikely(ret))
>   			return ret;
> @@ -1382,7 +1385,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
>   		return -EAGAIN;
>   
>   	if (!zc->done_io) {
> -		ret = io_send_zc_import(req, kmsg);
> +		ret = io_send_zc_import(req, issue_flags);
>   		if (unlikely(ret))
>   			return ret;
>   	}

-- 
Pavel Begunkov

