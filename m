Return-Path: <io-uring+bounces-1907-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C66F8C7840
	for <lists+io-uring@lfdr.de>; Thu, 16 May 2024 16:08:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E88CE1F21611
	for <lists+io-uring@lfdr.de>; Thu, 16 May 2024 14:08:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54258147C6E;
	Thu, 16 May 2024 14:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Na8wqVG7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD91E1474C6
	for <io-uring@vger.kernel.org>; Thu, 16 May 2024 14:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715868512; cv=none; b=kBa8UaKi3JxkP1ojlrv77pyrcpItqbG+8+4EnMtjfHkxJ6q0boUBobJ1gjBPtVFqMb5wZ6w3+Gu6UyvWxzFYMqccVOO7XaaF5QF5Xv1bomdQ3NG/j7H9Ycv7P98XOpyNRef5qvpOHLEHgAbukoeYB9wNjbWbay7S4VRnRhtYHlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715868512; c=relaxed/simple;
	bh=QQEZB/gFtPG3Kt8IZC9mIgC/LGd0TkgWkL/PHljRZeU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rT4mJJaH9sdvuJTKzIzyRWJ+rGP4EmwUIRqLKgH6ul0RoP+9Ij51Rxv5IOn8JpYqkvbPPdjEKkGM0TyIUANOIlbCFlxreYfMDxROGa8jBhpLTonRbCotMSDBnn4A0RnowoNrS4gAdBiqr/UC1Ei69sZCO7W8UiHxvUbAByv1bv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Na8wqVG7; arc=none smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-7f63961bed8so2575124241.1
        for <io-uring@vger.kernel.org>; Thu, 16 May 2024 07:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715868509; x=1716473309; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ta3JgRydGexjaBpmLKvHcRlKNfr+fB+S0FXwjsS43w0=;
        b=Na8wqVG7mikW4AUKFRDKcy/3rakaIop3gFhIekUctthO9G5OhJ7E2H+PatENs48faG
         RkPuRlf/WptJ9vIh2AAGvpOy9jEGOcaw97/lp7hleOLwvpWSG6qIe6z3bfKdARK6KA25
         DvG0iC6GCntIOlZiNJIXIAiBYfLFwD1eebsJDBiJSfvx0Uk6k+UoHnzXpLAO9Ve40IX2
         vqM9jndVJGVfSjyQrnfw8xvjd01AOgF7eg70U8J68y+/8bI+jsYVBO8ddeYJKo5k8npl
         KU+dpVUSbzuLBkfBcnMuNBk8TVQq9v9TkGsF84oai4ENKvfPjDIXfM2RwuCETISNdk/6
         nRpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715868509; x=1716473309;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ta3JgRydGexjaBpmLKvHcRlKNfr+fB+S0FXwjsS43w0=;
        b=gYHHitD9xDBzKphAL43GVKeuj1+yAFz7H6+ykt0hnyZhHIpT3QUWyqUaxEiX+1mc5c
         lCtpMw6VXgvZgGkFIilH1f4TTTxOY5FDwuGwFz57UfJVDfjtF9q6SvtGXgLLBWDPZ5qL
         qFtTw6IiyR1oef8LPWuEvaHXKVNUQLD5Av+9jFzYDhLdqVH5OSECLQwZcS/oNplbjmSj
         IUp4KVFQGbRkAivLN75t1L7hvKy10H7BkxGFBfbCqNKFy5MzO1wUEEs/UETzE4RWu0Pl
         I7AewxdDhHsh54t4B1jmGHlnLsxprALyA5pxTps/VkzDwLVKKnHO6ACH8mH8eqDdQHuy
         Z6lw==
X-Forwarded-Encrypted: i=1; AJvYcCVPjOv6aAgl2D35AbwW3I+Yv23voqxvzmMucKiAEDprBj3GGqvPLdRJOeET2Vi06j82RLCQoiMaN9rR+yMgqHrE2WiSje39IzU=
X-Gm-Message-State: AOJu0Yz1GdlvJ8zDd0fRhctWdc8A/VtBgGhkLYs3b7vnny9c8GDFhdtn
	Jj11Pg1/d0Y14BhGPbskiyejWickxBsAzHhaBc8pQRD1sXnN4qxa7x1tUA+FVtAp9H5Q1LYR3lb
	Jlawcy7eC3dRnva2uan/zA9h4SznUEeTqK4mN
X-Google-Smtp-Source: AGHT+IES238GTbCUHjaJ+DIyYT9pUhDbA7hY3KQWgPlc6PaiDSXyfzN0QXq1Bc6bJSodGXewjaIphRWcYHL00XmjBpk=
X-Received: by 2002:a05:6122:310a:b0:4dc:a1f6:4406 with SMTP id
 71dfb90a1353d-4df882802fdmr18508410e0c.3.1715868508411; Thu, 16 May 2024
 07:08:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20240514075457epcas5p10f02f1746f957df91353724ec859664f@epcas5p1.samsung.com>
 <20240514075444.590910-1-cliang01.li@samsung.com> <20240514075444.590910-2-cliang01.li@samsung.com>
In-Reply-To: <20240514075444.590910-2-cliang01.li@samsung.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Thu, 16 May 2024 19:37:50 +0530
Message-ID: <CACzX3Aue_vJz-PoLfj=Y+MA4=TqD0q=p3sVnnVdoVhHXM8-Brw@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] io_uring/rsrc: add hugepage buffer coalesce helpers
To: Chenliang Li <cliang01.li@samsung.com>
Cc: axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org, 
	peiwei.li@samsung.com, joshi.k@samsung.com, kundan.kumar@samsung.com, 
	anuj20.g@samsung.com, gost.dev@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 14, 2024 at 1:28=E2=80=AFPM Chenliang Li <cliang01.li@samsung.c=
om> wrote:
>
> Introduce helper functions to check whether a buffer can
> be coalesced or not, and gather folio data for later use.
>
> The coalescing optimizes time and space consumption caused
> by mapping and storing multi-hugepage fixed buffers.
>
> A coalescable multi-hugepage buffer should fully cover its folios
> (except potentially the first and last one), and these folios should
> have the same size. These requirements are for easier later process,

Nit: for easier processing later

> also we need same size'd chunks in io_import_fixed for fast iov_iter
> adjust.
>
> Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
> ---
>  io_uring/rsrc.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++++
>  io_uring/rsrc.h | 10 +++++++
>  2 files changed, 88 insertions(+)
>
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 65417c9553b1..d08224c0c5b0 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -871,6 +871,84 @@ static int io_buffer_account_pin(struct io_ring_ctx =
*ctx, struct page **pages,
>         return ret;
>  }
>
> +static bool __io_sqe_buffer_try_coalesce(struct page **pages, int nr_pag=
es,
> +                                        struct io_imu_folio_data *data)
> +{
> +       struct folio *folio =3D page_folio(pages[0]);
> +       unsigned int count =3D 1;
> +       int i;
> +
> +       data->nr_pages_mid =3D folio_nr_pages(folio);
> +       if (data->nr_pages_mid =3D=3D 1)
> +               return false;
> +
> +       data->folio_shift =3D folio_shift(folio);
> +       data->folio_size =3D folio_size(folio);
> +       data->nr_folios =3D 1;
> +       /*
> +        * Check if pages are contiguous inside a folio, and all folios h=
ave
> +        * the same page count except for the head and tail.
> +        */
> +       for (i =3D 1; i < nr_pages; i++) {
> +               if (page_folio(pages[i]) =3D=3D folio &&
> +                       pages[i] =3D=3D pages[i-1] + 1) {
> +                       count++;
> +                       continue;
> +               }
> +
> +               if (data->nr_folios =3D=3D 1)
> +                       data->nr_pages_head =3D count;
> +               else if (count !=3D data->nr_pages_mid)
> +                       return false;
> +
> +               folio =3D page_folio(pages[i]);
> +               if (folio_size(folio) !=3D data->folio_size)
> +                       return false;
> +
> +               count =3D 1;
> +               data->nr_folios++;
> +       }
> +       if (data->nr_folios =3D=3D 1)
> +               data->nr_pages_head =3D count;
> +
> +       return true;
> +}
> +
> +static bool io_sqe_buffer_try_coalesce(struct page **pages, int nr_pages=
,
> +                                      struct io_imu_folio_data *data)
> +{
> +       int i, j;
> +
> +       if (nr_pages <=3D 1 ||
> +               !__io_sqe_buffer_try_coalesce(pages, nr_pages, data))
> +               return false;
> +
> +       /*
> +        * The pages are bound to the folio, it doesn't
> +        * actually unpin them but drops all but one reference,
> +        * which is usually put down by io_buffer_unmap().
> +        * Note, needs a better helper.
> +        */
> +       if (data->nr_pages_head > 1)
> +               unpin_user_pages(&pages[1], data->nr_pages_head - 1);
> +
> +       j =3D data->nr_pages_head;
> +       nr_pages -=3D data->nr_pages_head;
> +       for (i =3D 1; i < data->nr_folios; i++) {
> +               unsigned int nr_unpin;
> +
> +               nr_unpin =3D min_t(unsigned int, nr_pages - 1,
> +                                       data->nr_pages_mid - 1);
> +               if (nr_unpin =3D=3D 0)
> +                       break;
> +               unpin_user_pages(&pages[j+1], nr_unpin);
> +               j +=3D data->nr_pages_mid;
> +               nr_pages -=3D data->nr_pages_mid;
> +       }
> +
> +       return true;
> +}
> +
>  static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec =
*iov,
>                                   struct io_mapped_ubuf **pimu,
>                                   struct page **last_hpage)
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index c032ca3436ca..b2a9d66b76dd 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -50,6 +50,16 @@ struct io_mapped_ubuf {
>         struct bio_vec  bvec[] __counted_by(nr_bvecs);
>  };
>
> +struct io_imu_folio_data {
> +       /* Head folio can be partially included in the fixed buf */
> +       unsigned int    nr_pages_head;
> +       /* For non-head/tail folios, has to be fully included */
> +       unsigned int    nr_pages_mid;
> +       unsigned int    nr_folios;
> +       unsigned int    folio_shift;
> +       size_t          folio_size;
> +};
> +
>  void io_rsrc_node_ref_zero(struct io_rsrc_node *node);
>  void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *=
ref_node);
>  struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
> --
> 2.34.1
>
>
Looks good:
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
--
Anuj Gupta

