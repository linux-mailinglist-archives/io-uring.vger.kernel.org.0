Return-Path: <io-uring+bounces-5689-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CA615A03200
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 22:24:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E2A097A06FC
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 21:24:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 850901DF961;
	Mon,  6 Jan 2025 21:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0GqVSyhI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA411DF26F
	for <io-uring@vger.kernel.org>; Mon,  6 Jan 2025 21:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736198655; cv=none; b=SaDy77k1Lbs+chszDp7xuyr6eGPb6gl+n2/e0ypRYluStHuGggRqO2+3Aq6zP8WWqFPfXswGOID+NoyxgsNi/0PqMte5JMbBO2LegP9q34tz+5TzE8ww8jIt8FyvmglTIeU1vlvMGdBxiiTBzHCljdjJJwMlpXlllVQfDWumLSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736198655; c=relaxed/simple;
	bh=kM/170mstPM0RLLJIwCc+YeiQsVc7ZRP6dmfKZzUHQA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E+u2e5roIxQxR7qRj2WIzZxDMwIAP1j3VGGJEEDfwVTs5d1YldE7O6fSF6W/cZ8XOXQFMFPi9FLiGC0SJGGkWCcagtSnIskH76bBxpSYvxhbyEhvZET/+CGMvH/I/b0xmNzNIEFA59R4w5m/wd/PLxhOjvCUSdbtxNApkO8BdH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0GqVSyhI; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4679b5c66d0so13551cf.1
        for <io-uring@vger.kernel.org>; Mon, 06 Jan 2025 13:24:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736198653; x=1736803453; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PFBjQ83aU7orUoeUhEQ1/Z1jSRvwwRq88gq9ZuwTbe4=;
        b=0GqVSyhI5zabfD2LQ1RiWqTuQf+PJdhITKVP/bKyPtv55J/eQOj4bXmMzOke837TG3
         GT/ogqL6k4FmjHcMFYJySOXAMgHQqNFkqymU5QOQrwatuk/ElrL9dz50vA8L2tOlrw58
         MAtqWRGQTWgwCQ6B+jCm2Z2mRzN5Jj4heoKpat5GRaY5P7s4iKDcXUdwHH0Lbc3DCyIj
         NVTdyWzZhWwYPCuon/vsei8Sk4baqRPNLpiNpVR2Lo5Emg1FTXSg90cJPYZ6HsePw1ml
         bP1lSEuvtFJgsFBK0CBIrze9YFBlwAgUMYetkPhJvFNi9ROXPKB0SiDGnycmWUd2XozZ
         iTQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736198653; x=1736803453;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PFBjQ83aU7orUoeUhEQ1/Z1jSRvwwRq88gq9ZuwTbe4=;
        b=FWCo69s2+PVQuNTlprE3xar4hKkczCfdt1FUUDgTkAcwPWD84WvDmfhw27YgI3I9nH
         b85HuGxKPUbwrl9I9J/d/qMwwx1HOPrjFLaIEkQxKy0EYhcYIZr2Xwi/zLkzN4HfbgQ7
         n1tiQOO/zsMQ0vXd7t5cLOAqfCagjwzosvQCM4fAN/Mg9uefCLhKHXuY8o597ddi/BqS
         Z3X07xw5HwmfhedtIKODlyjk1HPu8Decur52RfHj7tbhpXc1QnZy8kXoehauTolqisIY
         3vRwJS5yHfxb5iPSbCFPmsOwd17FWlqVEbfNdB6aFigZreRmJxOnCA4Kut+uPbU1K1ak
         +FeA==
X-Gm-Message-State: AOJu0YwQQu4OxmSGUWrqwfBP8QeQIvA2v8pK//6gWmPmFO6Ve7FUa5ln
	LJ6cjTztnkpTGwrEq+fH1+QyVo9itMq23IigOyfD2J5xK5+ZaEbEDEri6QyVWq7BFvYTdgCUWED
	T8Q4XN3TDX/9DkTln4UvaRnHgNbJyIx99whEz
X-Gm-Gg: ASbGncvxcA5ueuGqVGaFs1WQY10c3ER/jmNqz2ELiIKtOPgyieqI57zMdfAj/Pr/1UH
	5XBUpY4F2qli2MZiGzDz17CRVszM9mLoH5NrEThZQGAElyo7QADfbns3jdv9ASVHpTjNE
X-Google-Smtp-Source: AGHT+IEKzKoAs56hqGpcEAXifudHqbw2SyUscKZPc/iIYTxbToLe5cmEqtxIWJgQLlFLYmwTLb4MUeXTwHLUPn4bDTg=
X-Received: by 2002:ac8:5d4c:0:b0:461:3311:8986 with SMTP id
 d75a77b69052e-46b3b7fcd8bmr724521cf.18.1736198652587; Mon, 06 Jan 2025
 13:24:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241218003748.796939-1-dw@davidwei.uk> <20241218003748.796939-6-dw@davidwei.uk>
In-Reply-To: <20241218003748.796939-6-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 6 Jan 2025 13:24:00 -0800
Message-ID: <CAHS8izOh3uHbmbm=pjXTNdB1szL3EQ++ycEjiUMqa82b-akHsQ@mail.gmail.com>
Subject: Re: [PATCH net-next v9 05/20] net: page_pool: add mp op for netlink reporting
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

On Tue, Dec 17, 2024 at 4:38=E2=80=AFPM David Wei <dw@davidwei.uk> wrote:
>
> From: Pavel Begunkov <asml.silence@gmail.com>
>
> Add a mandatory memory provider callback that prints information about
> the provider.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>

Seems like a straightforward refactor to add the op that Jakub requested:

Reviewed-by: Mina Almasry <almasrymina@google.com>

> ---
>  include/net/page_pool/types.h | 1 +
>  net/core/devmem.c             | 9 +++++++++
>  net/core/page_pool_user.c     | 3 +--
>  3 files changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.=
h
> index d6241e8a5106..a473ea0c48c4 100644
> --- a/include/net/page_pool/types.h
> +++ b/include/net/page_pool/types.h
> @@ -157,6 +157,7 @@ struct memory_provider_ops {
>         bool (*release_netmem)(struct page_pool *pool, netmem_ref netmem)=
;
>         int (*init)(struct page_pool *pool);
>         void (*destroy)(struct page_pool *pool);
> +       int (*nl_report)(const struct page_pool *pool, struct sk_buff *rs=
p);
>  };
>
>  struct pp_memory_provider_params {
> diff --git a/net/core/devmem.c b/net/core/devmem.c
> index 48903b7ab215..df51a6c312db 100644
> --- a/net/core/devmem.c
> +++ b/net/core/devmem.c
> @@ -394,9 +394,18 @@ bool mp_dmabuf_devmem_release_page(struct page_pool =
*pool, netmem_ref netmem)
>         return false;
>  }
>
> +static int mp_dmabuf_devmem_nl_report(const struct page_pool *pool,
> +                                     struct sk_buff *rsp)
> +{
> +       const struct net_devmem_dmabuf_binding *binding =3D pool->mp_priv=
;
> +
> +       return nla_put_u32(rsp, NETDEV_A_PAGE_POOL_DMABUF, binding->id);
> +}
> +
>  static const struct memory_provider_ops dmabuf_devmem_ops =3D {
>         .init                   =3D mp_dmabuf_devmem_init,
>         .destroy                =3D mp_dmabuf_devmem_destroy,
>         .alloc_netmems          =3D mp_dmabuf_devmem_alloc_netmems,
>         .release_netmem         =3D mp_dmabuf_devmem_release_page,
> +       .nl_report              =3D mp_dmabuf_devmem_nl_report,
>  };
> diff --git a/net/core/page_pool_user.c b/net/core/page_pool_user.c
> index 8d31c71bea1a..61212f388bc8 100644
> --- a/net/core/page_pool_user.c
> +++ b/net/core/page_pool_user.c
> @@ -214,7 +214,6 @@ static int
>  page_pool_nl_fill(struct sk_buff *rsp, const struct page_pool *pool,
>                   const struct genl_info *info)
>  {
> -       struct net_devmem_dmabuf_binding *binding =3D pool->mp_priv;
>         size_t inflight, refsz;
>         void *hdr;
>
> @@ -244,7 +243,7 @@ page_pool_nl_fill(struct sk_buff *rsp, const struct p=
age_pool *pool,
>                          pool->user.detach_time))
>                 goto err_cancel;
>
> -       if (binding && nla_put_u32(rsp, NETDEV_A_PAGE_POOL_DMABUF, bindin=
g->id))
> +       if (pool->mp_ops && pool->mp_ops->nl_report(pool, rsp))
>                 goto err_cancel;
>

I thought maybe you should check nl_report exists here so that we
don't crash if we accidentally merge a memory provider that doesn't
define this, but the commit message says it's mandatory and we don't
check the existence of the other ops anyway, so this is probably fine.


--=20
Thanks,
Mina

