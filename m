Return-Path: <io-uring+bounces-6520-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1216EA3AA45
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 22:00:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 153A3189AEE7
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 20:57:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFA621DEFF3;
	Tue, 18 Feb 2025 20:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="S4Uzpb9d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0722D1C07E6
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 20:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739911551; cv=none; b=ZZRVZgJpbQRnX6VUg1v9cO/ZNsIOxPAQ5h6egYj+Dht3rbbLbOYZQlMwveOANsriybB2ehAYNUATUB3MeU9z/Ds5Q4DveiQSI0YszecRK4GK6S4/6WgYNFyfQSiTmcJeITKvTlK21LyKFBnlgET+6+sRpCWjaVUldqHtWsmRuG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739911551; c=relaxed/simple;
	bh=gc3RP/0P0JdzF/BDYzfxagvHOhA61NzsSD7nKlydGWc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IE9hjmKRWhC6EaXWwA2qRKSDziUUz+ntqYuWxkdz9egjsQj5iX6bIplia/UKnpay4yvGysSdGz37iQK77Foh392IIZOmCGF/rapvoUmojXvqYlGDqFEjaC1/kTAcAxJSOBOL3dX0j6j3BM5vCVqPuL1ScXRzi76atqQR8/cx0LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=S4Uzpb9d; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2fbfe16cbf5so1364368a91.0
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 12:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739911549; x=1740516349; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m0mGua/Ma6eV6C9Fy5HjGJ6Vk0axOaTEsT8ftn0BtmY=;
        b=S4Uzpb9drFXVXy4Da5MY1Y8jyyaeIiCetISFf9WaZNsCiRyFGBt9gXFwyEs36CJl2D
         eQivamRXlvYd8te6DiRi2eCnbQH6MHFM2ZDSGnwfbJoAn/knJMKG1MtV0bXWEXE9p/4t
         5l6rjXlSveNjKV+6w3NOYJTEoDblNUBuUXqHr9+to1E3BNp9nz2spMR8w+K/Vmfvi5pD
         C1wUhnxPzHO4oIr8/7/a7pkTwXNs3Pmw7LtHYa8pLHuHs9nSiBTMXWi8/i0to1068v57
         pDc14IEuHomeaZS6qdyVm/iH2bMKuDkrKJHTnKz/JBWVljWEA2cZhIawVUfV7bGY+Y7c
         aBdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739911549; x=1740516349;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m0mGua/Ma6eV6C9Fy5HjGJ6Vk0axOaTEsT8ftn0BtmY=;
        b=UiqWW663WLr9RdmKGwhohNSU0fujY6n9tRV9nlddE9tsGRgnWeJiVhUZfFUNy7gBNC
         Sr5/WHwHZP2Pym7lb71QckQ/LZXwUJdO2gqvtUnMKO3FWJRv/WyvzkLXjA1txFFp56yc
         eODYF1lT2Qp/juBc6/WBCcmjzqjl0x3nuh98PSLOWHb2ij0XlcgYiAnTusY4RIiGn2sU
         QDDhXxx1/FQbv6AE5S6VcCXoTk6JjEJ85C+bhCHN0iBOZsAeT2wlNovL7du1iZ6k9Vb3
         Effc4sMfOg9ivokbA+Z3quAPhptRJwy19YSXBdr+2P4Sg3aaaQpZyybTUzgTDW50Y6+N
         I0VQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUM2gRQ/kFDgZUUYTbYcKm4K47suqXbIvi6q0YtyRqFimh3SBMHT4+0bFtwh3GWJn5Lk4tpxDluw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwR1VCIoCKBEc5vJLcY/ol+xUqB6OEfbVG+mESiB/MpBELd1ZEg
	XzyJeRioHyGRRj58WRujlxRA3MmJnr9LjcLO4IQ2WRrahgDI+gyeMyXQ1ijxxhhD6Yomnjb6WAl
	Pui6b+Ht6o4ZxM2x48DdDNUay3aG6mUHQ4akInD44djqCIHag
X-Gm-Gg: ASbGncuCXpOu9CJ/XnQV/GnMT8AiTNdRwrv4JzATeyBmLi+Se6dKmCZsrQAjcAXsOL2
	6E5OBuVZS/+GbpkndGmCLrVsK96Rjp+ewduOfEH/KAPldJFFY9yPS7BtBiYgWAAEMlVParfQ=
X-Google-Smtp-Source: AGHT+IGfALKgUqDALD/4sLBrBcMFpBT3n6eej/o0Bmt9OTOO7UBBJMFyK+1UCppjNjFjx+6h0CClEQpahL8mdfLrYlg=
X-Received: by 2002:a17:90b:2241:b0:2ee:b665:12c2 with SMTP id
 98e67ed59e1d1-2fc40d1246amr8774025a91.2.1739911549252; Tue, 18 Feb 2025
 12:45:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250214154348.2952692-1-kbusch@meta.com> <20250214154348.2952692-6-kbusch@meta.com>
 <CADUfDZpM-TXBYQy0B4xRnKjT=-OfX+AYo+6HGA7e7pyT39LxEA@mail.gmail.com>
 <CADUfDZrfmpy3hxD5z0ADxCUkWPbU0aZDMiqpyPE+AZbeDSgZ=g@mail.gmail.com> <Z7TptdubsPCFulfV@kbusch-mbp>
In-Reply-To: <Z7TptdubsPCFulfV@kbusch-mbp>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 18 Feb 2025 12:45:38 -0800
X-Gm-Features: AWEUYZkU0HQ5Ia4fNBDiB57kFmWi9Rcb3_aZzJWUz4eHCh0QO05fO6eJnoexxXI
Message-ID: <CADUfDZqCooGdCDRYeT8MscehLgQ7OQA6mT97+Tf0NF6Ki3MLWw@mail.gmail.com>
Subject: Re: [PATCHv3 5/5] io_uring: cache nodes and mapped buffers
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, asml.silence@gmail.com, 
	axboe@kernel.dk, linux-block@vger.kernel.org, io-uring@vger.kernel.org, 
	bernd@bsbernd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2025 at 12:12=E2=80=AFPM Keith Busch <kbusch@kernel.org> wr=
ote:
>
> On Sun, Feb 16, 2025 at 02:43:40PM -0800, Caleb Sander Mateos wrote:
> > > > +       io_alloc_cache_free(&table->imu_cache, kfree);
> > > > +}
> > > > +
> > > >  int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
> > > >  {
> > > >         if (!ctx->buf_table.data.nr)
> > > >                 return -ENXIO;
> > > > -       io_rsrc_data_free(ctx, &ctx->buf_table.data);
> > > > +       io_rsrc_buffer_free(ctx, &ctx->buf_table);
> > > >         return 0;
> > > >  }
> > > >
> > > > @@ -716,6 +767,15 @@ bool io_check_coalesce_buffer(struct page **pa=
ge_array, int nr_pages,
> > > >         return true;
> > > >  }
> > > >
> > > > +static struct io_mapped_ubuf *io_alloc_imu(struct io_ring_ctx *ctx=
,
> > > > +                                          int nr_bvecs)
> > > > +{
> > > > +       if (nr_bvecs <=3D IO_CACHED_BVECS_SEGS)
> > > > +               return io_cache_alloc(&ctx->buf_table.imu_cache, GF=
P_KERNEL);
> > >
> > > If there is no entry available in the cache, this will heap-allocate
> > > one with enough space for all IO_CACHED_BVECS_SEGS bvecs. Consider
> > > using io_alloc_cache_get() instead of io_cache_alloc(), so the
> > > heap-allocated fallback uses the minimal size.
> > >
> > > Also, where are these allocations returned to the imu_cache? Looks
> > > like kvfree(imu) in io_buffer_unmap() and io_sqe_buffer_register()
> > > needs to try io_alloc_cache_put() first.
> >
> > Another issue I see is that io_alloc_cache elements are allocated with
> > kmalloc(), so they can't be freed with kvfree().
>
> You actually can kvfree(kmalloc()); Here's the kernel doc for it:
>
>   kvfree frees memory allocated by any of vmalloc(), kmalloc() or kvmallo=
c()

Good to know, thanks for the pointer! I guess it might be a bit more
efficient to call kfree() if we know based on nr_bvecs that the
allocation came from kmalloc(), but at least this isn't corrupting the
heap.

Best,
Caleb

>
> > When the imu is
> > freed, we could check nr_bvecs <=3D IO_CACHED_BVECS_SEGS to tell whethe=
r
> > to call io_alloc_cache_put() (with a fallback to kfree()) or kvfree().
>
> But you're right, it shouldn't even hit this path because it's supposed
> to try to insert the imu into the cache if that's where it was allocated
> from.

