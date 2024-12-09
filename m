Return-Path: <io-uring+bounces-5347-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F21899E9CC2
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 18:16:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4282166CCD
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 17:15:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 891BF13E02D;
	Mon,  9 Dec 2024 17:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jJA2Z3G7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9911552E7
	for <io-uring@vger.kernel.org>; Mon,  9 Dec 2024 17:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733764548; cv=none; b=UUILHQLVNQj3Gvk6d2soBacNJ9sToBZMQS18zqvU6Py+3AskaO/LpWCsxlL+agg98XXmGMkYUSNMhWfNziiNs4Rwtr9PF1y7NV/Br9ipfCvyxIzlu+7rPdzB24YTmycUgWCO9ewuo10wl0ps6wbdT3ZboxqyCo5tFoWbQc39eqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733764548; c=relaxed/simple;
	bh=NJxiQUeBq2WFEVAR8RXGCuOrLxf9jxbTqjpMUTNkSRo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YNwePpefEcP+asc0UE6p6A0fv2FxMEocaDohp4MHp/JVR0LG/Hgd+nGy41zXmyZkOBFmfekw1Av2BEJHMU5gefgDbMS2E2ySgGTtP9rN3V/X95JTUXr+aP/+SX6uqNpqnJZrjA8SFhEOQyECITm2ReRPCxYVHAlSSc875S70J/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jJA2Z3G7; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4675936f333so309381cf.0
        for <io-uring@vger.kernel.org>; Mon, 09 Dec 2024 09:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733764546; x=1734369346; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E/Oc9AAL5s3pNxwTIxiLkmqgw8dYjTavNjAYI8gx6Oo=;
        b=jJA2Z3G7YsCvnLOkzK3aKTaBTjo6u8riBxEPMjUv1ixRU0rRf2KUiyHdPqALVquSn4
         oqF6WTTR8nnwfoTpFLECYqDmLQ8hDQ7xm94MSLpsApkSyyQU6/mjlRte10fw8l0D2vz1
         PPA2Euto23aPZHLU/8mt+FVcFB/qkqXutNns/NrF74hdZpolqGwu2akZUAXR7E2AbB9D
         s9adLyfyuJ2qLNpst3Lhr72pRb5wer7YNYq8eMqD4/NHR6srh2PXH3Gjc1IqlgosKkel
         iAS/AZHor9QRi+iFDv/9lLcNK7iNHybnPwWqOmB9h1AqAzXUTN+sBhYOKMTmVCpGd2nC
         6EKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733764546; x=1734369346;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E/Oc9AAL5s3pNxwTIxiLkmqgw8dYjTavNjAYI8gx6Oo=;
        b=m7f6sFLWNhktJEKxR7kxU0WR2y1QweClpjyHtQdJK4y+G2eF1Ze3wPRJGpnHawVnMJ
         MMt+jIWBTURkoKvMlDg+4fllEBFrenwS41cKE0cB4LAUZGrPcnRuQsi1o5t9hiSi/ITN
         aQ7p0+NJzVAMjGyrS1J9moMzAt9JmK8Z70egxn1e+yTKxzYJNT/WJKobD9xI6WT7CV7z
         jMw08Fj5fqdosJFzc3bxv51iCR42oBEyW3M+vzmCNgjflx6QTRUwNrVY9MIfDxGi91cR
         /OMk2GBfpgntCgRZWGsmPCOGfcqEqy2MFbLn9TsfoDl/TLQXB6nGy7WsMYas4IYkDhrs
         CxxQ==
X-Gm-Message-State: AOJu0Yzv2fjepgs+UavGpp89eAKe9B4vrr3nkqzTB9SyXh3oEvhurATl
	7SJaJjulJNs+XIxT9PsYL2Jh/itfl5ZNPALZwfNrCuGaziPVa7NAlcv8FY5Shpz+GlEDzFyWWwQ
	D1++8iC2voXWUWsIJ/WZU44mlWizcXPiTZw35
X-Gm-Gg: ASbGncsLOXIyvDhXTKYH19OX773iYCoLeiLK3Yr0BMPBU55NFv4G/qxyqp6KmWxxJH2
	vxbBSNurUPOHt7/BWcxIzL4KYg0StKF2VWb6vOKTnIJpwFOWl+3t0/llJWMt9Nw==
X-Google-Smtp-Source: AGHT+IEfLFjXy136jiaj25OIuPvKpgJgwQwu6lo3Ert4vSwxxcBI0qpz7yA3ZKCRI7TGu2DWBxYzqaMt1FTjjCqcZyk=
X-Received: by 2002:ac8:6905:0:b0:466:9660:18a2 with SMTP id
 d75a77b69052e-46746f6859emr9758881cf.16.1733764545557; Mon, 09 Dec 2024
 09:15:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241204172204.4180482-1-dw@davidwei.uk> <20241204172204.4180482-8-dw@davidwei.uk>
In-Reply-To: <20241204172204.4180482-8-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 9 Dec 2024 09:15:33 -0800
Message-ID: <CAHS8izMYOtU-QoCggE+7h9V+Rtxf-m2rBMHHdJtMxSQku-b1Xw@mail.gmail.com>
Subject: Re: [PATCH net-next v8 07/17] net: page_pool: introduce page_pool_mp_return_in_cache
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>, 
	Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>, 
	Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 9:22=E2=80=AFAM David Wei <dw@davidwei.uk> wrote:
>
> From: Pavel Begunkov <asml.silence@gmail.com>
>
> Add a helper that allows a page pool memory provider to efficiently
> return a netmem off the allocation callback.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  include/net/page_pool/memory_provider.h |  4 ++++
>  net/core/page_pool.c                    | 19 +++++++++++++++++++
>  2 files changed, 23 insertions(+)
>
> diff --git a/include/net/page_pool/memory_provider.h b/include/net/page_p=
ool/memory_provider.h
> index 83d7eec0058d..352b3a35d31c 100644
> --- a/include/net/page_pool/memory_provider.h
> +++ b/include/net/page_pool/memory_provider.h
> @@ -1,3 +1,5 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +
>  #ifndef _NET_PAGE_POOL_MEMORY_PROVIDER_H
>  #define _NET_PAGE_POOL_MEMORY_PROVIDER_H
>
> @@ -7,4 +9,6 @@ int page_pool_mp_init_paged_area(struct page_pool *pool,
>  void page_pool_mp_release_area(struct page_pool *pool,
>                                 struct net_iov_area *area);
>
> +void page_pool_mp_return_in_cache(struct page_pool *pool, netmem_ref net=
mem);
> +
>  #endif
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index d17e536ba8b8..24f29bdd70ab 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -1213,3 +1213,22 @@ void page_pool_mp_release_area(struct page_pool *p=
ool,
>                 page_pool_release_page_dma(pool, net_iov_to_netmem(niov))=
;
>         }
>  }
> +
> +/*
> + * page_pool_mp_return_in_cache() - return a netmem to the allocation ca=
che.
> + * @pool:      pool from which pages were allocated
> + * @netmem:    netmem to return
> + *
> + * Return already allocated and accounted netmem to the page pool's allo=
cation
> + * cache. The function doesn't provide synchronisation and must only be =
called
> + * from the napi context.
> + */
> +void page_pool_mp_return_in_cache(struct page_pool *pool, netmem_ref net=
mem)
> +{
> +       if (WARN_ON_ONCE(pool->alloc.count >=3D PP_ALLOC_CACHE_REFILL))
> +               return;
> +

Really the caller needs to check this, and if the caller is checking
it then this additional check is unnecessarily defensive I would say.
But not really a big deal. I think I gave this feedback on the
previous iteration.

Reviewed-by: Mina Almasry <almasrymina@google.com>


--=20
Thanks,
Mina

