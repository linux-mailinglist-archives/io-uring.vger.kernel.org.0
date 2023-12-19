Return-Path: <io-uring+bounces-320-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D0F5819480
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 00:22:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1336C1F21C3F
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 23:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E455C3D0CA;
	Tue, 19 Dec 2023 23:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iR/EVyWE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A55640BE0
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 23:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a2371eae8f1so180214866b.1
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 15:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1703028138; x=1703632938; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MgzZo4TyHHi8UhQ+Ni8cGrZnxs3u8ZG6aWxX69pl984=;
        b=iR/EVyWEuY6kQ6rWY1GMxvJhC2mL88ETzQQVpGPXc7PAC3qRrC6e58TuL5DkShfRSu
         sUfYNiyfRa627YG6KdP5WmEbuwaZfne1oIvTTxMnkJXnmf4/YfabMOFwVcvrnWY0Ddwa
         e1rzWX1TO1gllyET5bvMyjdO7SXtbcBRgckQFZkpGJZZBEcqBxq36tdUnZdhbq/PHTvF
         xZCfdekT6pO3oXO/B4rkBjeDezy0LstNzpXJ1/gE9gJhC5y90xc3RMBywJrpAhPLxm6b
         d+QOBGVscQVJh7J6XNXDtDo2o/OgT7gcQeobNC/Xr+y+STQAFtuDxUacpFPMwj191rK/
         NTKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703028138; x=1703632938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MgzZo4TyHHi8UhQ+Ni8cGrZnxs3u8ZG6aWxX69pl984=;
        b=Nxyf7qAInr13iedrteBSxPl6KY5Jp7xQIltamiaEeFFoNsC11nW1kYfnUE2xR38pBs
         WmU0xT8YHCjqcZl42mKv5qcx0QAE5qT+NYpHSCCOCipuOGCcQuuikJWB/dyfU2/hclLy
         Q1jSuqygnc8WVdOKPAoT69TMcULf4rvenG3iXjUK8XD85lZhlt3hyoy8i1/ebHzCAv5L
         dxG2HQM3GfEPQT2ctYy0Z0psTIs6ua8OOIXsEtZcFCg0dnOdDr69YcuXaJCrkomIhyFl
         KKc55ydpO6L1uXGkYQqcLE8+pLnfyXaRHzchOCVeS60AH+I0AKy12Xb2TsDmEGLn4Yf9
         6PGw==
X-Gm-Message-State: AOJu0YzELxAthExwcBv6/zh8XDXwRQX6keWb9HDoT4pYPrMx2rmycn3X
	5f3/ng9Md95g1Auuz8G41hRLguak0RBvzNk27f36Fw==
X-Google-Smtp-Source: AGHT+IHF5ZvsFmaeJz2hiEJeyU3bIiqjfnIF5A+tpCwrw8JweSmEUYcokOaNMK1KaCEkVLZIRwKHEV3YAMStVPNdt6A=
X-Received: by 2002:a17:906:6c92:b0:a23:6eb6:6b35 with SMTP id
 s18-20020a1709066c9200b00a236eb66b35mr1077988ejr.136.1703028138420; Tue, 19
 Dec 2023 15:22:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231219210357.4029713-1-dw@davidwei.uk> <20231219210357.4029713-2-dw@davidwei.uk>
In-Reply-To: <20231219210357.4029713-2-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 19 Dec 2023 15:22:04 -0800
Message-ID: <CAHS8izMQ2u9KTBz+QhnmB483OW0hmma7Vy7OgoTGajM7FyJhiA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 01/20] net: page_pool: add ppiov mangling helper
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 19, 2023 at 1:04=E2=80=AFPM David Wei <dw@davidwei.uk> wrote:
>
> From: Pavel Begunkov <asml.silence@gmail.com>
>
> NOT FOR UPSTREAM
>
> The final version will depend on how ppiov looks like, but add a
> convenience helper for now.
>

Thanks, this patch becomes unnecessary once you pull in the latest
version of our changes; you could use net_iov_to_netmem() added here:

https://patchwork.kernel.org/project/netdevbpf/patch/20231218024024.3516870=
-9-almasrymina@google.com/

Not any kind of objection from me, just an FYI.

> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  include/net/page_pool/helpers.h | 5 +++++
>  net/core/page_pool.c            | 2 +-
>  2 files changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/page_pool/helpers.h b/include/net/page_pool/help=
ers.h
> index 95f4d579cbc4..92804c499833 100644
> --- a/include/net/page_pool/helpers.h
> +++ b/include/net/page_pool/helpers.h
> @@ -86,6 +86,11 @@ static inline u64 *page_pool_ethtool_stats_get(u64 *da=
ta, void *stats)
>
>  /* page_pool_iov support */
>
> +static inline struct page *page_pool_mangle_ppiov(struct page_pool_iov *=
ppiov)
> +{
> +       return (struct page *)((unsigned long)ppiov | PP_DEVMEM);
> +}
> +
>  static inline struct dmabuf_genpool_chunk_owner *
>  page_pool_iov_owner(const struct page_pool_iov *ppiov)
>  {
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index c0bc62ee77c6..38eff947f679 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -1074,7 +1074,7 @@ static struct page *mp_dmabuf_devmem_alloc_pages(st=
ruct page_pool *pool,
>         pool->pages_state_hold_cnt++;
>         trace_page_pool_state_hold(pool, (struct page *)ppiov,
>                                    pool->pages_state_hold_cnt);
> -       return (struct page *)((unsigned long)ppiov | PP_DEVMEM);
> +       return page_pool_mangle_ppiov(ppiov);
>  }
>
>  static void mp_dmabuf_devmem_destroy(struct page_pool *pool)
> --
> 2.39.3
>


--=20
Thanks,
Mina

