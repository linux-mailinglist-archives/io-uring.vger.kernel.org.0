Return-Path: <io-uring+bounces-6739-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B30DA44058
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 14:15:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 64823188972B
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 13:10:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F1182690CB;
	Tue, 25 Feb 2025 13:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QkrI2VJT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A77BD26983E;
	Tue, 25 Feb 2025 13:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740489015; cv=none; b=LS7GXKonEcvijFT7PIqw3jr2WXDggdcdkdAbBfsbYNecclIkup25sVWcbZraVPqxJVCQv3Fp7NdmRQMBQDetY/aQgaVMrZtjhT1L4FqdR7Y4HAjPgaCxh0SlkIh4L5eLrzFp36UbFg5FPC1cao3E/jN1dAAY1Kq23zrkmH+nK6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740489015; c=relaxed/simple;
	bh=ok5IavfZnSelt//TIjXOG/fNFVUu7gTOxoU3FFkt5/s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iCVogjj/ckpVPyYqzyVz4GXTdbwXTbks/E/MCImsyLlYQzh44+Cp/+3t74Nis3ZgD8J2cK+vX7+ylm3w3a5VE3TjJoqvXMByrWu7hxYJvR1Lr3RAxndUURYTbyYsjqbCxd7n6JoqET0GyMZVPH0n5hx0yWWLFdk1eJsuQ8UZwk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QkrI2VJT; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-abb90f68f8cso1060967966b.3;
        Tue, 25 Feb 2025 05:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740489012; x=1741093812; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a8tbQQd8nGbuq95d3mRB+hcY2UI4bYE9b904GhqCNVc=;
        b=QkrI2VJThO4K74sGSlOWzo7omu9yaLcD8JBwi4QzWSbqe5so7f54IwmBvAcrKQfpex
         upg7pcC6Uml9QAF+h0JRP0xshBl7AU+mZavwRUV7f8vBCT9t6Ry+GmbZu7v4RzMEMPAU
         LCNVhR30JKFHyDegEowdZ4NKJKXbQoW9ynaa1He99tKOTqTjRRIAXWheKL+81E1LGrAI
         aPatp7y73RqvfEkl2lJn8T2Dl64t+dzp2UJS0Yjv+8/nBpo6RBYYywuGpRxbOIT+z7fs
         lIs1pMbiby46JXUcBaYUWrbJIDwlRk2JANS4EkRt00Xrhm44ELZjtazqBfyqUzqggwIw
         I24w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740489012; x=1741093812;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a8tbQQd8nGbuq95d3mRB+hcY2UI4bYE9b904GhqCNVc=;
        b=BaP3gD4t/AnsyC3txBogOZEPVBLEZKtR4tHzQi/dytGE96allyEAL98IFJ+UiW7wCX
         Quj0JHW2JWRl5FUulMWjboJXiYZbq/ASjEi/0INpQ3zRM69Uzg4B99bP+aRbeuWgx7ow
         DI+XQNYyy65eRWXViBEuJJDMXyQlma85GTSy8KYPZ+Qqhcoy1COZUBV2DD+cuc6UNwkb
         f6EPmeJ2BqSOmenxCq5BDbvPjVW+BDLUnYL6qHVxGQbVy9yazeklSXneSN6Nc9FVmXIM
         T59LF3EkwFXROrpGc+tgo6p1U+1Xbxav2OtGtOdmmoW77rS5ceGxRU1WNPVqLVwGckT5
         ni6Q==
X-Forwarded-Encrypted: i=1; AJvYcCWbM4KvFpo1Mx/4zWteVomDG+jmZo8LliZJkm5174r01tZLN4VM4248IGEsgTG25N0JESIXz2AEgA==@vger.kernel.org, AJvYcCWfu+Rfq7zPdXuEZ1cg5f+NLmTnBO3N4PiBs4Ls/wa92J/IjT7l6qHSDKt+7i4kTM2oCXoBjthWInHEEw0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9RcP1aVUcpleTYbEuwqaa5Eoso4OF9ZAbVXwzg8xbobxofmtj
	Z+scq7Mzx8KmJk60IBr/Zmf9sZ0g0EpZjwoLd4ivVs7jP50ZCMFF
X-Gm-Gg: ASbGnctS9/An6qacRvEFiLWoe7jQt5qVDfct0H/TaS5MgUzvewR1JEXnnkn4CKGPjbT
	7KbUZ/p9htOBLVN8Ov6D2hbxoZziWeBahiJXMTGA1sp5yiqcyTkCO9Z4Gnd5wi0/imGH1q4TdNK
	FDZHves7outgB0SbL2pRV+SL3nbtzieVpQjduU+dWK30wP9A228T+Fib5gWLlWdXYIS0resLBh6
	3gAzZTDzK+9hPOSPG4WFJc4Uhq/V6OpbSq9noJi3A2d5KISmtW0Jo/GXSNi7mlxKPzcKRZQVfTh
	tdauN0WCeYSFOguNl5VEL+lDZqDWkDISGaCEBk1mbwNGSmfOScvIbPBnci4=
X-Google-Smtp-Source: AGHT+IF211i7DBrfluEKw6SHYE+F0iYbTaLbukrJkgXd900SC3Fv7oGzxSnTi0+9u6KGiQ6twYuy5A==
X-Received: by 2002:a17:907:7856:b0:abb:e967:a6c7 with SMTP id a640c23a62f3a-abed0d3ee9bmr258524166b.25.1740489011658;
        Tue, 25 Feb 2025 05:10:11 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:9e08])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed1cd561esm141930166b.19.2025.02.25.05.10.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 05:10:11 -0800 (PST)
Message-ID: <cd8328b1-ecc4-4d17-8590-629e2d80e03f@gmail.com>
Date: Tue, 25 Feb 2025 13:11:12 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv5 11/11] io_uring: cache nodes and mapped buffers
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 Keith Busch <kbusch@kernel.org>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-12-kbusch@meta.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250224213116.3509093-12-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/24/25 21:31, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Frequent alloc/free cycles on these is pretty costly. Use an io cache to
> more efficiently reuse these buffers.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   include/linux/io_uring_types.h |  18 ++---
>   io_uring/filetable.c           |   2 +-
>   io_uring/rsrc.c                | 120 +++++++++++++++++++++++++--------
>   io_uring/rsrc.h                |   2 +-
>   4 files changed, 104 insertions(+), 38 deletions(-)
> 
...
> +static __cold int io_rsrc_buffer_alloc(struct io_buf_table *table, unsigned nr)
> +{
> +	const int imu_cache_size = struct_size_t(struct io_mapped_ubuf, bvec,
> +						 IO_CACHED_BVECS_SEGS);
> +	const int node_size = sizeof(struct io_rsrc_node);
> +	int ret;
> +
> +	ret = io_rsrc_data_alloc(&table->data, nr);
> +	if (ret)
> +		return ret;
> +
> +	if (io_alloc_cache_init(&table->node_cache, nr, node_size, 0))

We shouldn't use nr for the cache size, that could be unreasonably
huge for a cache. Let's use a constant for now and that should be
good enough, at least for now. 64 would be a good default. Same for
the imu cache.

-- 
Pavel Begunkov


