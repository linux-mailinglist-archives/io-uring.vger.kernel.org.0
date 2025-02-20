Return-Path: <io-uring+bounces-6577-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83E0EA3D7D7
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 12:09:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F95A17D979
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2025 11:07:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA8401EBFE0;
	Thu, 20 Feb 2025 11:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cv9DrYES"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71E51DE2D8;
	Thu, 20 Feb 2025 11:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740049646; cv=none; b=eJW1OJWKtZx3/ZKk0dli6HoncRrLudiUb++2ekjAeLv6rnlAcetmocEhxm5uc3yWtkTwr9rqzptbsxQw5lkJoP9wJ+tCeWMC8IYSu2HYLCvsz5+YkdPLCBs1+/3DpIG/8hhTDOd2thNIi0ZOM3bE1PtWefE10y4pcztWmghmnrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740049646; c=relaxed/simple;
	bh=UNd0HY8eZO8Hgkhjwggv79KJhEKwOIGW/kWbJz3xyl0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mPx5JngkcDvQcapk2KqFrbZR7MU8VngmJSLExIYzl4Os8jTr2BBwYCWiSeC+dx5Cpuhup0yxAulS1cpZvbNE/lYsEtCuxKo9ZBtgTRRcwiajfn1AmMkrpWnhGvSK769IiNCw1SZOm4zaozsTotevfDFyBLIP5h1azdEwPRSAhkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cv9DrYES; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5e04064af07so1490636a12.0;
        Thu, 20 Feb 2025 03:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740049643; x=1740654443; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qsw8x79fnygsuCtNzUT9j2KNBzHuvaopbsGsOQGQe6A=;
        b=Cv9DrYESlHlE1wWGrqgOYhmnKOSy1u0CGvkmdYk9VQzUTY0Y28oifiF2+fXpqVuPrj
         8/SO/78AR5znB2ppHSNVyL3tLHxDgotEES1JQuEfnc+6qa6aBKgykyHPxC7thur+WhQh
         20o0wptYtcOEtY9T/Yowtwg8TE5w6r1y7ihCpHe44+k1hp/dMvH3hkaiP63+03jkEwvC
         KyM9+8meYeCG6EBhm4v/G6h6IwDJcSXW5GWNIVct27EQA3TLTeQBiPPeY9ynWU1LOJMk
         rMge5/utCEfpDLfa13/wnwFed2qfhYoEY3ID+TwfWDN2icNXGN/M3vx08+UInZPVgvK5
         Bsew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740049643; x=1740654443;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qsw8x79fnygsuCtNzUT9j2KNBzHuvaopbsGsOQGQe6A=;
        b=kIcvXGRPOvf242JmNE6Lf/fXkzgZyO8iEcw9TbrVPetmiNyD2pNZYxFfM21EJW37mo
         DTCOuOqbp6johtDFyaNK3fdNfFGSURdgYET+2UzBVJCMvCiHBcvOR6z3nZ2xP+2DRSc5
         F1qiJBe/bp0t6nTGFc7nu6ZesWQZc6Iys8lV0hyAvoR4fO9MTCKDuoaUfJkF9lw1Uzy/
         7Bhi56qkiHWqcaqR34YuMd26zvigyaBJyWuBZifRR3NhaZG4vmcByUmdAcLEMxAxxOd2
         JYGpYmoJG4QCr/4atikh9h5U3S9tarLZj5kaGBVGkWH5RL30VpP6GaeeiATByo67GTg7
         3Auw==
X-Forwarded-Encrypted: i=1; AJvYcCWMqnQOrB9W44ePipKeVwRTsGdVBZeHzW6hxE5SQJQ3s1i1nxNhSpVv3f8JI6O04pRWLq4ZpmPKJg==@vger.kernel.org, AJvYcCXoeOmj9uBq6/g5bvnoFqwjw/Dd+W1lR0tkGh2NRqY8QwMjGHBG3OfyWj0q+/re6s6gOLmYj19s0sjBTgQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr6Dj/JGVu8kuR6q4VzYJawXc0thJ1sxYjRIIAEsnS+phwIExZ
	2Fwgvn+kdJph1oygQu84kWpAzBd1aqvPlYzYM3ZuFRkUFYvLxvV1
X-Gm-Gg: ASbGnctUj/OeVAnNxV5NX90VAIxYW09cQkRM1t88GofozPCUf0BmCVTUbrmMUX1843O
	DAttsYFonOkzbEAwuRYAoZgRxkci7aGl32VIyfiTa19O4oxuKn037LqCZbIYgMaFSw6zmdliR54
	lyd0ha1ws9kWtaFL9GTk2+KoniqsTHsl73cPJkBZLFrrdW/IYEsAiIDm5xyPJnZ6KiddcanBpzp
	C5+jVwcCgdyE/tl9+ONZYQiyHpqluWWUNc8J+ub8ZEJ9ifYIVmeqcuh7GmuBOsTSXjI4Hlu1h5A
	c/swbAQGsOX0LzaL6ByUtfV0OrR/EXSTKpSgKyloU/vsd0DP
X-Google-Smtp-Source: AGHT+IGK8B4aiG7tjcaCx8tGVNIH55NZbQ95Ez8qhFkIqQ6qRlwg7oIySkgWjJtG49VV+rzq6mKSoQ==
X-Received: by 2002:a17:906:3117:b0:ab7:b356:62e0 with SMTP id a640c23a62f3a-abb711c3ef2mr1860931266b.53.1740049642861;
        Thu, 20 Feb 2025 03:07:22 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:f455])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abb94329614sm824964166b.180.2025.02.20.03.07.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2025 03:07:22 -0800 (PST)
Message-ID: <d2889d14-27d2-4a64-b8d1-ff0e4af6d552@gmail.com>
Date: Thu, 20 Feb 2025 11:08:25 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv4 5/5] io_uring: cache nodes and mapped buffers
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, csander@purestorage.com,
 Keith Busch <kbusch@kernel.org>
References: <20250218224229.837848-1-kbusch@meta.com>
 <20250218224229.837848-6-kbusch@meta.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250218224229.837848-6-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/18/25 22:42, Keith Busch wrote:
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
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 810d1dccd27b1..bbfb651506522 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -69,8 +69,18 @@ struct io_file_table {
>   	unsigned int alloc_hint;
...
> -struct io_rsrc_node *io_rsrc_node_alloc(int type)
> +struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx, int type)
>   {
>   	struct io_rsrc_node *node;
>   
> -	node = kzalloc(sizeof(*node), GFP_KERNEL);
> +	if (type == IORING_RSRC_FILE)
> +		node = kmalloc(sizeof(*node), GFP_KERNEL);
> +	else
> +		node = io_cache_alloc(&ctx->buf_table.node_cache, GFP_KERNEL);

That's why node allocators shouldn't be a part of the buffer table.

-- 
Pavel Begunkov


