Return-Path: <io-uring+bounces-6877-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B091EA4A79D
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 02:41:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 869FF7A53B0
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 01:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D8417B3E1;
	Sat,  1 Mar 2025 01:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z8PYh8Kh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60336189906
	for <io-uring@vger.kernel.org>; Sat,  1 Mar 2025 01:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740793237; cv=none; b=j3SyZzEoWOUKLANCAFoYbi/MW2RJ9utna1umkGFAHLuPUn4jP0QkICMEaTf6ZJmfXX7GM2QiDSbOBNT5qH8JADsY2vpLsQhPFqySq7KiFokaTr8A7qkUzCWtzwaVlb+gVPyJJae6YN1iPU0tqMuIydwfPdFDodrKAJ2+gL6AH/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740793237; c=relaxed/simple;
	bh=usyH2J8GxxlRQrk3slkIKd1AWC5g2nsHB5ptpz8nWnE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WFemlcEtJWarf/gzCDr2APy80Lm/9JCbdKwFFozjR1TtXN56WsfACrE1Bpt9zW5MHr6D2USsc30bBXDosTfYZAz/rqfw1uBHqNRC7AvHf07/kYCXnut1bU361jcYHSyChtqDJn/akQcVPs6Z+FYnMt8/Evdvkq8HvEQPMgJRDGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z8PYh8Kh; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-abf4b376f2fso70033666b.3
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 17:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740793234; x=1741398034; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=knYRQhqu55/cTumvqKbH96yFuoVFgdObAQd82YN9YU8=;
        b=Z8PYh8KhEimDn2VfnmExFoNfhdOnbhjjtjYwH2LtXqS28FXpQmbRYUS1lC0Ej0MP6F
         ntDAF7UxH77FbO1qlJSrldK3RwPO4XhQx9QWbJ3mvfAf/zTfp0vWf4R6+lEWtzHtwCrh
         tbqIQ6XysovVC1Is9Zy5wXSc7TJw4dya5kFdXaX28Ol72RZK2VrOMCOHWxYkrJirQkTn
         z9wvvOprx+q6/kkWHq5OkqzzzZpSGp9TOEjj9g/pTvVvHF/TPnbc45whqqk083/9yKW9
         ZsU3l7hlBYsMaxbM/6GQNb9BjP94vQDE2fuMYU23o5yvP3D6hVre4KuSZ9AniyX6X2/m
         jnqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740793234; x=1741398034;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=knYRQhqu55/cTumvqKbH96yFuoVFgdObAQd82YN9YU8=;
        b=E0RbDGN9Ey3XaCHubhGOrDh4jfiRh9dV6pGJowNDXyaw0LYcZkErJddZ4FWwZKH59+
         4OYOUKSJPdYiUeh2J4ruBbChGKqVIyCL+Afk3oizK82firBvsNX9OQNB1UAXB/JDd4Q0
         CE8YLbJdAPNRPjM/9pwVg8yovykNP7JB2ddldMGat8HCKz3/QS9erPP+Xav0QZEAciW1
         WAS4R4uOhA8aE3yCzLVuOxaORlRrD2wYm7z4Zalswt/i8Z47Uc1XMWRd2Z0Za2ddXAkc
         qy8pTD2c8KP/mt2PpnvAZ7GW+O4CH+/qI2GtBxiecKArwIkpZ83ePQn6cPYxqhV8GCYg
         xGsg==
X-Gm-Message-State: AOJu0YwO9Yb+hoPFHkJ6k7TCwLwY5Ddpt3qxRALZ71XL62qoDjTKZ4u4
	gqYRxuiFsSyYES5w9djD06V/BjveiC77jUiIQO1YDhTY4s9z1Ybd
X-Gm-Gg: ASbGncvpT1TZLPrHGomA0GlTtkJUK86jnS5IRz6SjxTuqY2dZV6URGbSNDXiJtbztKT
	xCA4cRPR7cL7yf6casZk1R3/vRqDNLvYQ06YW/geZMkVa+u0d6dg0XuU8gmf9JoFzDbA6F2TKk0
	ehJTaffAWTxvTRoGdcpW4yTfpt5LggqpsyG1WojMt5mS+XD9gDBkJUsWwMrdLpUdU0ZQTPebMgf
	YAGUYLHP0PPjzi+Th0ks2pN2EnTosH1zhmMBJIinFl2PjkL2OyrVZ4CMLQpgFdMW5ceeJJqgDpJ
	0jsWLjRl/ZKCia7yuFPYObczTvXzmbvSgAr5Ze1j5l+oejHddcCedH8=
X-Google-Smtp-Source: AGHT+IFMfhe+ZCz6sAUWFBdK76M/BeoYpc6GDcTPFrFLi3o9Z2J138cUillLKgKWuuZwVWA4fYjYRw==
X-Received: by 2002:a17:907:1c1a:b0:ab7:86ae:4bb8 with SMTP id a640c23a62f3a-abf25fc615fmr492557566b.23.1740793233331;
        Fri, 28 Feb 2025 17:40:33 -0800 (PST)
Received: from [192.168.8.100] ([148.252.144.117])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c75bfedsm383192366b.144.2025.02.28.17.40.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2025 17:40:31 -0800 (PST)
Message-ID: <d4271290-2abb-49ee-a99a-bc8bb6dde558@gmail.com>
Date: Sat, 1 Mar 2025 01:41:38 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring/nop: use io_find_buf_node()
To: Caleb Sander Mateos <csander@purestorage.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
References: <20250301001610.678223-1-csander@purestorage.com>
 <20250301001610.678223-2-csander@purestorage.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250301001610.678223-2-csander@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/1/25 00:16, Caleb Sander Mateos wrote:
> Call io_find_buf_node() to avoid duplicating it in io_nop().

IORING_NOP_FIXED_BUFFER interface looks odd, instead of pretending
to use a buffer, it basically pokes directly into internal infra,
it's not something userspace should be able to do.

Jens, did use it anywhere? It's new, I'd rather kill it or align with
how requests consume buffers, i.e. addr+len, and then do
io_import_reg_buf() instead. That'd break the api though, but would
anyone care?


> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> ---
>   io_uring/nop.c | 13 ++-----------
>   1 file changed, 2 insertions(+), 11 deletions(-)
> 
> diff --git a/io_uring/nop.c b/io_uring/nop.c
> index ea539531cb5f..28f06285fdc2 100644
> --- a/io_uring/nop.c
> +++ b/io_uring/nop.c
> @@ -59,21 +59,12 @@ int io_nop(struct io_kiocb *req, unsigned int issue_flags)
>   			ret = -EBADF;
>   			goto done;
>   		}
>   	}
>   	if (nop->flags & IORING_NOP_FIXED_BUFFER) {
> -		struct io_ring_ctx *ctx = req->ctx;
> -		struct io_rsrc_node *node;
> -
> -		ret = -EFAULT;
> -		io_ring_submit_lock(ctx, issue_flags);
> -		node = io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
> -		if (node) {
> -			io_req_assign_buf_node(req, node);
> -			ret = 0;
> -		}
> -		io_ring_submit_unlock(ctx, issue_flags);
> +		if (!io_find_buf_node(req, issue_flags))
> +			ret = -EFAULT;
>   	}
>   done:
>   	if (ret < 0)
>   		req_set_fail(req);
>   	io_req_set_res(req, nop->result, 0);

-- 
Pavel Begunkov


