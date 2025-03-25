Return-Path: <io-uring+bounces-7233-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 70D0AA7024C
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 14:42:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6EACE7A9E0A
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 13:32:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36EC2179BF;
	Tue, 25 Mar 2025 13:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mN2B/xak"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B6118027;
	Tue, 25 Mar 2025 13:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742909415; cv=none; b=Cosz5hHPULUq+qQKrem+07RAVSuE4dG+1qzsdgY5YkvH5Jmn6nbksef7OTLCLtFw7upFtf/pMf9/McX2MVAs4AM+kXGZreQbWhdjiyCN6ZNSH2n0bKcJDFWUysvCSM+5kqsjSnlaEOJZNHxrPPbG9pZ+1mgDPfsS9TdVPbkBd8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742909415; c=relaxed/simple;
	bh=pvUDOqjEhh6pD2PP/Wfy1+RA/r3jcg+Vawc2vWETGIc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wz73J6SkEYoCSsODybYX4yuzKqYF3SM+a+uF5+66xEBxmySW0tNR1DfhYiFIfG+MLgni/gPKMnNOMCZm2duawh1ElRSJJ7fcgmdCpGcKGKE8BgJi2jPrN7bOluGLVJz7V0iInMaXhSKH/4OK/WrYnOPgjoy+Wnqi3jVP6+w5PZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mN2B/xak; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ac29af3382dso949512166b.2;
        Tue, 25 Mar 2025 06:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742909411; x=1743514211; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ThxKKB9wKE3kLciqa5eBDiDy0qqnYVk2yCJkc0l3CXU=;
        b=mN2B/xakLlg4MBLzJGsycpuy/SR9InPg7UlinXHe261uKVgE+oTToqDSKI0CuuUenk
         1JtcMumYoDw1vmzxtt068Mwc7DzDeYgeqXAYG44RA4MAM+ehOnoPMnHwiOQ2REaIYvCI
         8XnIoR5sPFvawIJLdwMhGaoOUXlSrmNsSVX/3A2QpP87a4hpcjRdpItqx+BwYJNZrQ6d
         z47WoOPUoIP7whcBsWehEVTcVtu0LmBK6OsNTCMK5n76aY3St3Xb5ek8LZUTJoitx8I8
         tty1u6PO66MlaZVzK5b5l0kRgYw89V0Qel3igqRzXvx11GpaXMtXiJ6X5iLzUe0Z7lef
         4eBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742909411; x=1743514211;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ThxKKB9wKE3kLciqa5eBDiDy0qqnYVk2yCJkc0l3CXU=;
        b=UkEiaeHrMB6EB3mF4uXltTe1aNf2Lm72uNLH89UfB5e8Jm1Ahu5m1IZaNpIrxVcuMf
         fIwsP8Z3XIIuesTIn7/QKkjkNL9al9VIsHBzQhcCZVMULewoTmffywFmCOw6BCPwWbWv
         xr5mVWan4YqsMrEK5HrjVKf/Dmk3d/t0WRZY0MYrSdUE77oh5HBWwnKr6MbxZycF90sa
         51EaSh8qzi/YDHhyfwGOPZcw/OsmhxNTmBV9urmo/J2wuR/T93g/wKhsqGLjZCWNFNUC
         4MCtbhutX+L3rYzl/NYltnyy2tQc8236sfVXjwMdsisuQ55BUJRiVBDFkcePbYZH+nPk
         lBFw==
X-Forwarded-Encrypted: i=1; AJvYcCVyGHl6miqc13pcfFsTuxrayT2wEPOej7eFwXI9E6Rt+5UwiKj5dPb0sS93fyS/nMVILHeeAM9+xp3VBHk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyc5l9rekY8AfxCJFg3ZaC6TGAH1hBxT/v09AUHTuxHLIMvn6Jo
	UlwlMvjLBsXeWw0zMcTSkm6ZqNodoPcxBlAjEiIBjVvxmMC+UZeKgFO2HQ==
X-Gm-Gg: ASbGncsOFP7rSrUq7Kw/lhbIcy5qFNXR0322HjFARGAG+r9AqSE1sGGBkJDDHFXXEvg
	7VlwbVgZmJ9lKWOIV+gDpUeqtEiHSO5RcUmsJ228QYHUoeozre51ZeavOzzthaoBj0j43+VKjMY
	xbY+R9ofTIYO6x4jyt9pIh/kiL41vfjF5qavQIHQlyh5OMnggH0tKKXtcnIozrb46h/aEcJQF+e
	5tYCJJkH/6KKWChC2T0m107uEwpGXSr3g7J008bW//olc678+3sLuu/6d2YztrXwf67Z1aPUKvr
	S6nv2tf53PDnmrW1hGiMY8+dTjVZi+l9fzCd4oYJiH5bySkW56TGn3M=
X-Google-Smtp-Source: AGHT+IGNKHXotOMwpOQaaVUB7zQxZu0oFc/vWQlra2MlK+eLUShyy/i9ZscfPWFrDjUVu8YQHH2Eyg==
X-Received: by 2002:a17:907:97d3:b0:ab7:bac4:b321 with SMTP id a640c23a62f3a-ac3f2286cc9mr1545955766b.29.1742909411180;
        Tue, 25 Mar 2025 06:30:11 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.141.160])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac6964189b3sm417566066b.3.2025.03.25.06.30.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Mar 2025 06:30:10 -0700 (PDT)
Message-ID: <8b22d0df-f0ea-4667-b161-0ca42f03a232@gmail.com>
Date: Tue, 25 Mar 2025 13:30:59 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/net: use REQ_F_IMPORT_BUFFER for send_zc
To: Caleb Sander Mateos <csander@purestorage.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250324151123.726124-1-csander@purestorage.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250324151123.726124-1-csander@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/24/25 15:11, Caleb Sander Mateos wrote:
> Instead of a bool field in struct io_sr_msg, use REQ_F_IMPORT_BUFFER to
> track whether io_send_zc() has already imported the buffer. This flag
> already serves a similar purpose for sendmsg_zc and {read,write}v_fixed.
> 
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   include/linux/io_uring_types.h | 5 ++++-
>   io_uring/net.c                 | 8 +++-----
>   2 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index c17d2eedf478..699e2c0895ae 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -583,11 +583,14 @@ enum {
>   	REQ_F_BUFFERS_COMMIT	= IO_REQ_FLAG(REQ_F_BUFFERS_COMMIT_BIT),
>   	/* buf node is valid */
>   	REQ_F_BUF_NODE		= IO_REQ_FLAG(REQ_F_BUF_NODE_BIT),
>   	/* request has read/write metadata assigned */
>   	REQ_F_HAS_METADATA	= IO_REQ_FLAG(REQ_F_HAS_METADATA_BIT),
> -	/* resolve padded iovec to registered buffers */
> +	/*
> +	 * For vectored fixed buffers, resolve iovec to registered buffers.
> +	 * For SEND_ZC, whether to import buffers (i.e. the first issue).
> +	 */
>   	REQ_F_IMPORT_BUFFER	= IO_REQ_FLAG(REQ_F_IMPORT_BUFFER_BIT),
>   };
>   
>   typedef void (*io_req_tw_func_t)(struct io_kiocb *req, io_tw_token_t tw);
>   
> diff --git a/io_uring/net.c b/io_uring/net.c
> index c87af980b98e..b221abe2600e 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -75,11 +75,10 @@ struct io_sr_msg {
>   	unsigned			nr_multishot_loops;
>   	u16				flags;
>   	/* initialised and used only by !msg send variants */
>   	u16				buf_group;
>   	bool				retry;
> -	bool				imported; /* only for io_send_zc */
>   	void __user			*msg_control;
>   	/* used only for send zerocopy */
>   	struct io_kiocb 		*notif;
>   };
>   
> @@ -1305,12 +1304,11 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   	struct io_ring_ctx *ctx = req->ctx;
>   	struct io_kiocb *notif;
>   
>   	zc->done_io = 0;
>   	zc->retry = false;
> -	zc->imported = false;
> -	req->flags |= REQ_F_POLL_NO_LAZY;
> +	req->flags |= REQ_F_POLL_NO_LAZY | REQ_F_IMPORT_BUFFER;

This function is shared with sendmsg_zc, so if we set it here,
it'll trigger io_import_reg_vec() in io_sendmsg_zc() even for
non register buffer request.

>   
>   	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
>   		return -EINVAL;
>   	/* we don't support IOSQE_CQE_SKIP_SUCCESS just yet */
>   	if (req->flags & REQ_F_CQE_SKIP)
> @@ -1447,12 +1445,12 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
>   	if (unlikely(!sock))
>   		return -ENOTSOCK;
>   	if (!test_bit(SOCK_SUPPORT_ZC, &sock->flags))
>   		return -EOPNOTSUPP;
>   
> -	if (!zc->imported) {
> -		zc->imported = true;
> +	if (req->flags & REQ_F_IMPORT_BUFFER) {
> +		req->flags &= ~REQ_F_IMPORT_BUFFER;
>   		ret = io_send_zc_import(req, issue_flags);
>   		if (unlikely(ret))
>   			return ret;
>   	}
>   

-- 
Pavel Begunkov


