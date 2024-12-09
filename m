Return-Path: <io-uring+bounces-5344-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D6D859E9C91
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 18:06:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D1B01682FF
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 17:05:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8450B1ACEA8;
	Mon,  9 Dec 2024 17:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1yBOidUM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36401ACED6
	for <io-uring@vger.kernel.org>; Mon,  9 Dec 2024 17:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733763863; cv=none; b=jetrm97YiugVhh4MiB9PO4EX2+Gi4IQJAq32ne1gReq7JEPDLk6vm672UT8PBHpYI+IXKdhk1E+HYUoXZ2CZwW7G+33hiWt9kFyGj1jtujbXMsSSOKVakSd17r+afT/pqf2KX0x4QptflsaR18W6wvnxHIMY2pbCB3fssbuMw/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733763863; c=relaxed/simple;
	bh=hCjPF4h39sBuItXkw9/FumQVj8JC2FFC+VY5mhvViVs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BQ/qp8xyyiG8hZuczI+2N3HHQjxya++lXeXYRMs5nvPEk7huStvzJPJcY2pTkv/uMUo2alYpJ46KOeLVlw7X1grFnJ5Bsv/kLkbbbBvrMcuXMPhd+bOnzL6M2HG9vTP5EZ0KnWUHn+iPFdvpjKmK3EG2Fej0P05WJo3exK77GXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1yBOidUM; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4675936f333so305761cf.0
        for <io-uring@vger.kernel.org>; Mon, 09 Dec 2024 09:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733763861; x=1734368661; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bCTwjGvqKJOsLa8zRJ1KLiCVtqh5oEHJ+hDYeJPcrPI=;
        b=1yBOidUMHqLuAgU75LMz5k+AFGkf0TZlkKKAiFsa4nAUVBYs8A5EM648GGvq5yCY2q
         n9t1g4uMUAm7unDaxNx4WqtL2S6of7Rrnk15jp3Xc6K1E4TLUo2VCwZSffp0TFdCLVDe
         hlcLebOqnG5zP+VfBgVmFNOeTEW87MJHPon3ULeydua63RMeit9s2gw/ZIexj4UQ2Qmj
         XcnTXmeqETCQnXFtF6lysi8pFJt2K2NqBWKUaAbQMSblkQkUEizobCL21xSVe4NUpil+
         oqrL/59BApSn+ZkZTNZy/JlHzAIdIt8vGXrcH8tq6mjofC9+eMlO8d6WGyEXAPDVwAI8
         Hocw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733763861; x=1734368661;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bCTwjGvqKJOsLa8zRJ1KLiCVtqh5oEHJ+hDYeJPcrPI=;
        b=JeAMCoXtKqMQXL7UGduAI2Dg2WPdbS361Slt84Sz5OWdY6FBIvBV6s3xw7u6mk9KIX
         8+5/4eiIpdTzWGD3xntoWeCdXkOlDejc+ix+gIjEj7pnf6KeGhGlgGpvSyb/afPTZPrP
         xss3bP7P3w/I+CGUk9dMs95+6l1IxNZN5axrcp6vVUJ+UTjLZEv0OUdL1jmVEsyYbMkK
         /0+OOa7bXhfoMTJGEmYGdV3V6gStUyx/19NTY7ZAvuK4fjG+2cIrfiR85Qbe/s1jIU3H
         ddvdPhg90JiC7+wMEfAuQOq0jEvCp37vccQI9ozrhILpXGXSay/C6ua8yc9XFSfG4/Ch
         zerQ==
X-Gm-Message-State: AOJu0Ywof1OsNympXT//jP6XrPjfawkr1yVVfFYvEYa4krrwX/Nz54eC
	8DFjbGtoa4vMFWcq1nk3huKU05sVWQ11W5RA8XQvEonwwUaysyGJF00vup1IEEVCqE2cPQ8yCEG
	tdcJP95IAnnOQHR0T5qtTVDwgncr6Wo/Ek5Dl
X-Gm-Gg: ASbGnctK9o6j8V6hxpMAtJ4qgMi6MpnavDp2SKp7akpfC1EAYutRtFpv8fvd5KAJ8Ip
	69dunUSRIPqBjM0hBCYZkWJvR2Pq9Bh3bmaN9glphoE1iIbU4s1k/4sIvyPfeCw==
X-Google-Smtp-Source: AGHT+IFC1ZJOrFzGya4ylHTn6E5h6AODB0/VBoKQiZgx63JCO6sMmPTNeNOdLjHbcmcpys0XBMxngQzCL15leZysps4=
X-Received: by 2002:a05:622a:2593:b0:465:18f3:79c8 with SMTP id
 d75a77b69052e-4674c766b8dmr9777901cf.13.1733763860541; Mon, 09 Dec 2024
 09:04:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241204172204.4180482-1-dw@davidwei.uk> <20241204172204.4180482-5-dw@davidwei.uk>
In-Reply-To: <20241204172204.4180482-5-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 9 Dec 2024 09:04:08 -0800
Message-ID: <CAHS8izM+gvUSEPHbJ_ao0ih9NALnADvT3hYBno_-JgKS9rYz8w@mail.gmail.com>
Subject: Re: [PATCH net-next v8 04/17] net: prepare for non devmem TCP memory providers
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
> There is a good bunch of places in generic paths assuming that the only
> page pool memory provider is devmem TCP. As we want to reuse the net_iov
> and provider infrastructure, we need to patch it up and explicitly check
> the provider type when we branch into devmem TCP code.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  net/core/devmem.c         | 10 ++++++++--
>  net/core/devmem.h         |  8 ++++++++
>  net/core/page_pool_user.c | 15 +++++++++------
>  net/ipv4/tcp.c            |  6 ++++++
>  4 files changed, 31 insertions(+), 8 deletions(-)
>
> diff --git a/net/core/devmem.c b/net/core/devmem.c
> index 01738029e35c..78983a98e5dc 100644
> --- a/net/core/devmem.c
> +++ b/net/core/devmem.c
> @@ -28,6 +28,12 @@ static DEFINE_XARRAY_FLAGS(net_devmem_dmabuf_bindings,=
 XA_FLAGS_ALLOC1);
>
>  static const struct memory_provider_ops dmabuf_devmem_ops;
>
> +bool net_is_devmem_page_pool_ops(const struct memory_provider_ops *ops)
> +{
> +       return ops =3D=3D &dmabuf_devmem_ops;
> +}
> +EXPORT_SYMBOL_GPL(net_is_devmem_page_pool_ops);
> +
>  static void net_devmem_dmabuf_free_chunk_owner(struct gen_pool *genpool,
>                                                struct gen_pool_chunk *chu=
nk,
>                                                void *not_used)
> @@ -316,10 +322,10 @@ void dev_dmabuf_uninstall(struct net_device *dev)
>         unsigned int i;
>
>         for (i =3D 0; i < dev->real_num_rx_queues; i++) {
> -               binding =3D dev->_rx[i].mp_params.mp_priv;
> -               if (!binding)
> +               if (dev->_rx[i].mp_params.mp_ops !=3D &dmabuf_devmem_ops)
>                         continue;
>

Maybe use the net_is_devmem_page_pool_ops helper you defined here.

Reviewed-by: Mina Almasry <almasrymina@google.com>

--=20
Thanks,
Mina

