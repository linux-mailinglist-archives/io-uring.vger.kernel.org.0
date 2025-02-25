Return-Path: <io-uring+bounces-6740-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 86729A44069
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 14:17:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D35A19E2182
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 13:12:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 639A9268FCE;
	Tue, 25 Feb 2025 13:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UpfPlT/o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EFB2690F8;
	Tue, 25 Feb 2025 13:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740489146; cv=none; b=NJsZAuLig8eOiEtcyoiPestUYdzb6dA52zqUa3JtDQiLQTgpDJxZF8tFShrj9ZLiOHa03gEbutdl8IbdCypdLA7wDaZYzhAC9cTdCBuH82VRanbf2FkV61MgxaqBdqCVqNsQVAzh3qCjWkONOC3XZjQCAo25oCms8Ht0zdsQIoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740489146; c=relaxed/simple;
	bh=21lSLCd6z2Lj3Yd5zxF4dN+8NRpgMYk5bHvye4sLTLo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VCL+V9NjD+JGa0tYXvK5BgD+kRK58QnXT/jpb3/iuWdimAhOK/yKV5QubmvQ7kTI6LDDe9MOomp9uP3XCXQWAKqiGLKruMBg5YMB3qp81VtI9wmzc/PrvNfQsEEqYb1acKde2qxWUzQ76BmuOTSjrKmi8I6DRNmR3TRAidqE21I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UpfPlT/o; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5e0b70fb1daso7232042a12.1;
        Tue, 25 Feb 2025 05:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740489143; x=1741093943; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ijjNO+c5jJjdal/lMTgEiRMbfF15Yyn5QQV2HDJFUbM=;
        b=UpfPlT/ot8iZH3qrqTaAHYWPQM4fuunmbclQWWpfm7uRxzT57PTczjsKf1+x3BiHcP
         DbRZMuYKWwltga0LDk6rHRCIhC3tGffLT3wl5cH5X4uBfTPTFoVJwXRh/Ij/gP3rFct1
         +DQkg/qGUpI1Vlv6CaGMWnYsh51KoYAy6roHDiH69G53oh8utj90TMgkUljJhHs/KWIU
         ZPa8YonjgQda9u7BHqV5pRcay9PdvdiUOyS6131HjN84DmQK2G1noo3AMhPEPh5hSw6P
         8hKDPYmqHy/2BtMUXIi/6Ec+bZJpxbnjKwdUU3eRDBZjwXpuUs7nQxV1wLz5qC1oLCG9
         ZkRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740489143; x=1741093943;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ijjNO+c5jJjdal/lMTgEiRMbfF15Yyn5QQV2HDJFUbM=;
        b=gGxMzzpPSu+kQg5X9epfpNwZM0PEwGAhDHwrshwsWQBSTFQdwF9dtT1WnB3LP9VDwF
         zLqos50G+2B5FrzjaS1oSD0Q9aXmHODxz6rKq7D1UGoxPOQ8trCWoEhS0k8MVidV/qBU
         wnxUhmu5gk92n/YVfy7kyn1tuA5SAvgExPfUEhhveuyx8C6iMtjJh8G1I2OIcG6niQz3
         3PPiU+vXLvqOF+Yhd+/teL8VmAqvYLcjyDaJTxywXka4LHktH1Ncnpx8W/jicvCb0wiQ
         PtEeNueZgYq4Jk8tQuB26Pl0rg8g3RcxhNQyTPzVUPqKhHc8+i4+oyGmtueAzNPySrgS
         VfLw==
X-Forwarded-Encrypted: i=1; AJvYcCWidlSkDGa8BDm9MRCjslmq4Tmd0mzN4WTyT1XNPa9Sfi+idzxQ9qJow7S7qoQmoRaZI1sEkA38Pg==@vger.kernel.org, AJvYcCXaZ8DYnbXSmytG1aoDd1fa9g3JPqA3kAr/JSmX9rrsBlRJbj7t9IJjieNeQjeSX6FzPbAha5X+IiE0/d4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRz58XbnSV6lBXXXWIvDs3HNYxmz8SRsoYyXFdR3ajpP0xdR8x
	dcbqBTqyG7Gn6kctkgwEGpe6Bxh/vOFaHGOpTEWAQvrPkX4IlzJd
X-Gm-Gg: ASbGncuahTke901bTqLdJFJYLK8GnV2j4726umRvka4CCrBdSn9Jt2Ce/zasu4KuwMY
	85eHrTYGFc+bxIwQ94iILKWkewIudkGekHhGdswjR6pf+F5ysdWKd9P9IEIV9arFdnYoUKsy4en
	C+cfU1QPzQS5q0wFkxddicuiphTiXxSCOJmO5w8J5xEsOIg9lPc5MnhDaQayqWB38cWUpxM6YoR
	Jdmn2xjB1QDcZG35fP2tN4R/Ce+qqZpktquHRdFbOq2kDflFVZ197MxoSSHvkvstQfpSCc0+70t
	zm13MWCd/HhUir47I9BqaIj+OZQEOeGGwAjIaiqrMbKbOkQjtnip92dazmA=
X-Google-Smtp-Source: AGHT+IHu82CiyX9/3dLiPFwQKvX8nsiqOK3vhc1mIs6+jdsKM1pVasQNOJTjTmEKMCMKOkrqwvQgBg==
X-Received: by 2002:a05:6402:35c9:b0:5dc:81b3:5e1a with SMTP id 4fb4d7f45d1cf-5e0b70b5fb0mr17694497a12.7.1740489142618;
        Tue, 25 Feb 2025 05:12:22 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:9e08])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e462032c02sm1209122a12.79.2025.02.25.05.12.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 05:12:22 -0800 (PST)
Message-ID: <07fa5f3b-2298-4e36-8adb-727423aa97dc@gmail.com>
Date: Tue, 25 Feb 2025 13:13:21 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv5 01/11] io_uring/rsrc: remove redundant check for valid
 imu
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 Keith Busch <kbusch@kernel.org>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-2-kbusch@meta.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250224213116.3509093-2-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/24/25 21:31, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> The only caller to io_buffer_unmap already checks if the node's buf is
> not null, so no need to check again.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   io_uring/rsrc.c | 19 ++++++++-----------
>   1 file changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 20b884c84e55f..efef29352dcfb 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -103,19 +103,16 @@ int io_buffer_validate(struct iovec *iov)
>   
>   static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
>   {
> +	struct io_mapped_ubuf *imu = node->buf;
>   	unsigned int i;
>   
> -	if (node->buf) {
> -		struct io_mapped_ubuf *imu = node->buf;
> -
> -		if (!refcount_dec_and_test(&imu->refs))
> -			return;
> -		for (i = 0; i < imu->nr_bvecs; i++)
> -			unpin_user_page(imu->bvec[i].bv_page);
> -		if (imu->acct_pages)
> -			io_unaccount_mem(ctx, imu->acct_pages);
> -		kvfree(imu);
> -	}
> +	if (!refcount_dec_and_test(&imu->refs))
> +		return;
> +	for (i = 0; i < imu->nr_bvecs; i++)
> +		unpin_user_page(imu->bvec[i].bv_page);
> +	if (imu->acct_pages)
> +		io_unaccount_mem(ctx, imu->acct_pages);
> +	kvfree(imu);
>   }
>   
>   struct io_rsrc_node *io_rsrc_node_alloc(int type)

-- 
Pavel Begunkov


