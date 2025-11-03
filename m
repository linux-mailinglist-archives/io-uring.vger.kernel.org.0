Return-Path: <io-uring+bounces-10339-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id DAB34C2DF89
	for <lists+io-uring@lfdr.de>; Mon, 03 Nov 2025 21:04:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 752A84E4F76
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 20:04:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49AC321ABD7;
	Mon,  3 Nov 2025 20:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="QC5uAEl3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D5E1F9F70
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 20:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762200244; cv=none; b=JvpudoKy6jjIrVqLzKliQJcLuET+pTZa+kOoApY8g4EfUySK+m+W9yrNOZJ1SbI/iKfe8B7RdLcNQ/qbkLbNrD2Yvd7s44jHkKTWtMrUKu1RjUdBoDjOeCwynbwavzsYNFGSv/CtZxanRXg6te9XMfoO99sPfOeS3OeIKz5/zIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762200244; c=relaxed/simple;
	bh=EimBx6u8pVhXHOt0w84uZZATnisjVkN5HjMA8PjIaTY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wqt0p9CgqKb5bJVemF6tS2NTMayvqnzCJG+ERn1uE4d8Vt1ltC6ZBJTXYeevOrlHp8ihahQVDP+oMs3HewDePjqfXD790smF0wPw0YEn8zG73BAreYoKDO6E/HYh07t5RDILYiCjiobXjMOFCPLYZQToNuq8k94ZmqxZsYmAVh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=QC5uAEl3; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7aa3d98838aso142727b3a.1
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 12:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1762200240; x=1762805040; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iTsBY+ZblQfJHoe0nK0yZ2Jkez47FzHS1ypWZAhmRjo=;
        b=QC5uAEl3wZuWxgfDeCb44tAPTwwPwzq7LAz25igx69ZGJWeCkYtEno9YNVeZxgBoYN
         PHZDyrxrRIWzsSQnxepZ+17cKu4GfExrmfeqo3g2EOLF09VIW0WmF7A46uIk4tWo9an8
         eG5uXXOAEooD3aAy9XKu47MFN41i9ij7W86kYrUsEoCRMQz4rdjlvfb5NgymHl1WOLJN
         W1FGvSnjVfAm2Z/UwHqzqjsV/T7rSadguyy3YUTUiSGOP9Pv877L8x7Zw1yiFRx+ezrZ
         NPQeMCmkoERggfdJqppO+B8luJWnFHrYqKBVBJDcCnQLHYva1Fffg8rJ3mcNjxFvRUWT
         EuyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762200240; x=1762805040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iTsBY+ZblQfJHoe0nK0yZ2Jkez47FzHS1ypWZAhmRjo=;
        b=dJUdk1RV6Xf0yiBIX7Fttkw2u8Mp1kM567Zxec23aj8sgMQC1dFqPFkwnREu+DiHKx
         BPWIZ79Z1KmwJpOSsHJEmzJ0FWwlAlBecriGmkCYhqZhqMheVyXaca62hCoV5GfsMAR4
         bx71ez3zzLO1mJbXoA8WUKKnaCJxqFrEVeU3wmr5oVE3ok5JgP4I8u83u9zuyEQSwGIh
         bZgmPiWnlQHCIY63a0W3ip6sMiSkbmkbaiabzvyWREXAW/w9IZX7v42aaYMSkHqKQlT0
         leJ1RM6RZq4Bir2anknBywU+MWH4oa6DaVa4fHnGO4KQNv9ztZjYgHfuHllkm+dC4AGz
         0wGw==
X-Gm-Message-State: AOJu0Yxx2dbzKY9aCqfRkVzkKgxzfVnlrTMZGw0XEaOJu8SO2kM5vst1
	x21BPbWKze6/gxDuNKKfe7cKUhq+lTnK2zVWfku+UUGaPdnMgBqiSJU13HVRO6+PHW2e3LewfQo
	g0y8uW48699Zx6dnEZACWK63V5rjABlGcmOLQETIDEw==
X-Gm-Gg: ASbGncsPhNJKlJsmBE38CC19ED/e5Ln5Nof1xpPLDTgHauAfVihqemMpm2C8aTkEDST
	HJmjXp3zXltdvtpYnEQ2jEVyQSlRrF9uizpSxdNx/K7xGNXZtINq0kY9gRDnj0yMXZ+tssvKawt
	6k5MTUQRU8VW/B1kwJaDgJ/12xEDyDQnczIErzGYSQrbE5LReIlS2xODnFvHyhlikKRDu3/VbjD
	s8HzKJ9A2L0uNYRGRgh1UnGqERMGB2TkTGfD/QZ1vT5XHQK5Ckc7+31EMUjHZj2za7DnZDGbIEv
	OoWdgrz1tRuwzpL6KQTb/Uf//bPSbmbEHOcQvm0=
X-Google-Smtp-Source: AGHT+IE+MJwdTHxUV/03KsqerebJXKaRzuJF6Wl2pnND8KZ3b7dpCKazeXCtQa0ctg+IsC4VccurcR6C5oAoKWwKI20=
X-Received: by 2002:a17:902:d48d:b0:290:bde0:bffa with SMTP id
 d9443c01a7336-2951a36c273mr97647795ad.1.1762200240453; Mon, 03 Nov 2025
 12:04:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251015172555.2797238-1-csander@purestorage.com>
In-Reply-To: <20251015172555.2797238-1-csander@purestorage.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 3 Nov 2025 12:03:49 -0800
X-Gm-Features: AWmQ_bmR1xKRPxzHCcqxg83g0jMYHGS5VpJiMbsgB9ezmv7F7vYqC0JhlQ0hPPk
Message-ID: <CADUfDZq807sZ5ZMeX3adbV70Pjjbn299kTwyADhEiJqcxMO6xA@mail.gmail.com>
Subject: Re: [PATCH] io_uring/memmap: return bool from io_mem_alloc_compound()
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jens,
Any comments on this minor cleanup?

Thanks,
Caleb

On Wed, Oct 15, 2025 at 10:25=E2=80=AFAM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> io_mem_alloc_compound() returns either ERR_PTR(-ENOMEM) or a virtual
> address for the allocated memory, but its caller just checks whether the
> result is an error. Return a bool success value instead.
>
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> ---
>  io_uring/memmap.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
>
> diff --git a/io_uring/memmap.c b/io_uring/memmap.c
> index 2e99dffddfc5..b53733a54074 100644
> --- a/io_uring/memmap.c
> +++ b/io_uring/memmap.c
> @@ -13,30 +13,30 @@
>  #include "memmap.h"
>  #include "kbuf.h"
>  #include "rsrc.h"
>  #include "zcrx.h"
>
> -static void *io_mem_alloc_compound(struct page **pages, int nr_pages,
> -                                  size_t size, gfp_t gfp)
> +static bool io_mem_alloc_compound(struct page **pages, int nr_pages,
> +                                 size_t size, gfp_t gfp)
>  {
>         struct page *page;
>         int i, order;
>
>         order =3D get_order(size);
>         if (order > MAX_PAGE_ORDER)
> -               return ERR_PTR(-ENOMEM);
> +               return false;
>         else if (order)
>                 gfp |=3D __GFP_COMP;
>
>         page =3D alloc_pages(gfp, order);
>         if (!page)
> -               return ERR_PTR(-ENOMEM);
> +               return false;
>
>         for (i =3D 0; i < nr_pages; i++)
>                 pages[i] =3D page + i;
>
> -       return page_address(page);
> +       return true;
>  }
>
>  struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *=
npages)
>  {
>         unsigned long start, end, nr_pages;
> @@ -157,18 +157,16 @@ static int io_region_allocate_pages(struct io_ring_=
ctx *ctx,
>  {
>         gfp_t gfp =3D GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN;
>         size_t size =3D (size_t) mr->nr_pages << PAGE_SHIFT;
>         unsigned long nr_allocated;
>         struct page **pages;
> -       void *p;
>
>         pages =3D kvmalloc_array(mr->nr_pages, sizeof(*pages), gfp);
>         if (!pages)
>                 return -ENOMEM;
>
> -       p =3D io_mem_alloc_compound(pages, mr->nr_pages, size, gfp);
> -       if (!IS_ERR(p)) {
> +       if (io_mem_alloc_compound(pages, mr->nr_pages, size, gfp)) {
>                 mr->flags |=3D IO_REGION_F_SINGLE_REF;
>                 goto done;
>         }
>
>         nr_allocated =3D alloc_pages_bulk_node(gfp, NUMA_NO_NODE,
> --
> 2.45.2
>

