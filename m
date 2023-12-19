Return-Path: <io-uring+bounces-323-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 72B8D8194AD
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 00:39:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D04C6282C77
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 23:39:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24A993EA95;
	Tue, 19 Dec 2023 23:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZOhyuUFR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E96640BE5
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 23:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-552fba34d69so4855548a12.3
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 15:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1703029180; x=1703633980; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cm+QcQYL3APTv6L5Sk9aIkViOC6WvRNDdHdU2C3Yh4g=;
        b=ZOhyuUFRgkHZfI6rAAidcO/9oFBkWHhPyvyShmSuXiEoxqXRWp77PvfRJ1E8GV9k2n
         GXrNT/U7fJt6nhpOnGhIOtirUiYHocE4kMEzYdmlSZz0F2+WgZiKp2g3ZULY0rKsqT7M
         W8SA7NV8NgPFxcrYtFQZ8apbWvzzUuPm7ISyXPv4k8kI4Js5a/XyVfcFrv7+nR8oAeZ4
         9ew7cOco7ZVAr2l/Ss1AnUBHf4DBHMITAxSc6K/Es706MXX1C3huDrvH5J4F1HO5FMBa
         QqydbGRQzGnkL+iYiNNqBpG6LsPhwzPHncPzBRjsqEy1zSQALSz319bu08vIw59wyc4Z
         DcMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703029180; x=1703633980;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cm+QcQYL3APTv6L5Sk9aIkViOC6WvRNDdHdU2C3Yh4g=;
        b=JGeLEOTLJZQ/yoOadwmCf0IYpDFMhdB/lepieMT012qZ3K0iNv1EmmPXLnOKJNmWPG
         SDxFY8PUAYWIgEr9ZTdSNA5ivYOZw+DgrDqWTQBsSL5smOMP+KNpyCuhVw9dHtu72X2p
         sqJmVFd+eLNtJOeGCEao4BRI+QmyNm5zbsB8PRoKqysC9DICIXHSsYvwxOIvA5m9zWQ+
         Ge3jX2JMeILaeMK8eJmjELn39sJwTPwBrg6BK9I0SZyhvo9APAG0JkvIJtooDnOcX4tL
         /ssKbYQ8Vtuh2cBWxNptMHWRqQENIqA0L7yg474+sVRrin9/YZupZ+b6SSO0dBVVki1m
         jHHg==
X-Gm-Message-State: AOJu0YwF8/LqHEWyzn2RbmidFir3M2+/kL0b4A/FbbjP0R08F3LFeF6e
	trP1W+0/Gh2xYDDoBcYjfZZiYCWTlJdRxTghhRjiehwHuerZtaL9l3k=
X-Google-Smtp-Source: AGHT+IG8uvZU9dm9eKyJTQk0DtJ17MmccDac4QwimANzXKJavtIEf8AO8wQb+UKePqV2OmBLkNFTD+PhQkoqM/gxV5o=
X-Received: by 2002:a17:907:3e0c:b0:a23:333b:129a with SMTP id
 hp12-20020a1709073e0c00b00a23333b129amr3157952ejc.53.1703029179670; Tue, 19
 Dec 2023 15:39:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231219210357.4029713-1-dw@davidwei.uk> <20231219210357.4029713-15-dw@davidwei.uk>
In-Reply-To: <20231219210357.4029713-15-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 19 Dec 2023 15:39:27 -0800
Message-ID: <CAHS8izP0-BtwxJpO3A_th+XAgpVokz4FGFct9RCRFBrK4YiLNQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 14/20] net: page pool: add io_uring memory provider
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
> Allow creating a special io_uring pp memory providers, which will be for
> implementing io_uring zerocopy receive.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>

For your non-RFC versions, I think maybe you want to do a patch by
patch make W=3D1. I suspect this patch would build fail, because the
next patch adds the io_uring_pp_zc_ops. You're likely skipping this
step because this is an RFC, which is fine.

> ---
>  include/net/page_pool/types.h | 1 +
>  net/core/page_pool.c          | 6 ++++++
>  2 files changed, 7 insertions(+)
>
> diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.=
h
> index fd846cac9fb6..f54ee759e362 100644
> --- a/include/net/page_pool/types.h
> +++ b/include/net/page_pool/types.h
> @@ -129,6 +129,7 @@ struct mem_provider;
>  enum pp_memory_provider_type {
>         __PP_MP_NONE, /* Use system allocator directly */
>         PP_MP_DMABUF_DEVMEM, /* dmabuf devmem provider */
> +       PP_MP_IOU_ZCRX, /* io_uring zerocopy receive provider */
>  };
>
>  struct pp_memory_provider_ops {
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 9e3073d61a97..ebf5ff009d9d 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -21,6 +21,7 @@
>  #include <linux/ethtool.h>
>  #include <linux/netdevice.h>
>  #include <linux/genalloc.h>
> +#include <linux/io_uring/net.h>
>
>  #include <trace/events/page_pool.h>
>
> @@ -242,6 +243,11 @@ static int page_pool_init(struct page_pool *pool,
>         case PP_MP_DMABUF_DEVMEM:
>                 pool->mp_ops =3D &dmabuf_devmem_ops;
>                 break;
> +#if defined(CONFIG_IO_URING)
> +       case PP_MP_IOU_ZCRX:
> +               pool->mp_ops =3D &io_uring_pp_zc_ops;
> +               break;
> +#endif
>         default:
>                 err =3D -EINVAL;
>                 goto free_ptr_ring;
> --
> 2.39.3
>


--
Thanks,
Mina

