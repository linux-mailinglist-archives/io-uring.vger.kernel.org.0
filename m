Return-Path: <io-uring+bounces-1908-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 595428C7841
	for <lists+io-uring@lfdr.de>; Thu, 16 May 2024 16:09:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 74BD71C20B82
	for <lists+io-uring@lfdr.de>; Thu, 16 May 2024 14:09:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAB36147C6E;
	Thu, 16 May 2024 14:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C/E/GRsk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620A01474C6
	for <io-uring@vger.kernel.org>; Thu, 16 May 2024 14:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715868547; cv=none; b=OC8eP5kkvmiqaFnj/GYUs8ujoNCY3q1tLk3DouPu0+EJ25gl5pU0+MMnqqMGKOr/w2ebq1JESIWOkIyNOLzalt4W6DnJGxDyU0m4VbdPeHHPsqRXg7L5Drv5CPfMmM2NQR56lrc5b2QUh2BZbg9u8a4CH3N6ykgAa9wn+fJw8aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715868547; c=relaxed/simple;
	bh=rcrOfDtRdV6vZRehdi1RWdoYlZEvozQWoaEu7mRF37o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HH+gSG1kE64++Vdqc/ep+hBh70Vrt5BXvkRDtFIjniRnBBR+WTPWNHDQpMlp5BBFOwDnuxsGlXk/WiwaF6S6LPxywFpDXGV9lfd1us/OCnVjZZaQO5ZmEraNsKqFMN9WZiN1UWSRPJPP00aCOZxldcUDLUA8JRZZ38IK3SXWBoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C/E/GRsk; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-23db0b5dd28so411686fac.2
        for <io-uring@vger.kernel.org>; Thu, 16 May 2024 07:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715868545; x=1716473345; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Wph2NV52lJR5Z+UyzoZWB29pU05H5QcbK6DjpI+zRc=;
        b=C/E/GRskVJVMCCwpaxGeaRAD3neYZ70uhJg8DYopzP/cjBtxq4sOhjFv8bi0TTCUX6
         fI9jvBPZ+LmqQlyl1J6NG0oKHr95zEYwdluBlTQPl0YblczP+Nb67Jk1yxog/Nn91IHQ
         jY6YyYfbtaO3+XMv7y7afhMkyxjORWIGUDpb5CsSUi7bmRoFDgg+LtAYgw3YpkHNWD7C
         lm7skxuHy4lJhsxSC2MhhktyfdVugEc1SFf2mITj1smiwIknV2DCeKGDqi1fw9nByPPF
         /o5hNhckD/CLOBRJCZ7SZPx9EE7dd3epDQmnLVD3xuCnL5a3YtKJMlzprXQxcBkjlV6M
         Rp5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715868545; x=1716473345;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Wph2NV52lJR5Z+UyzoZWB29pU05H5QcbK6DjpI+zRc=;
        b=j3cI2zd/c8mDdgQT1MoJOLIO0/GmEASfWzuekB4SKsnaxR2sPLnDKnHzvur7vNQ+yL
         Rz7O5lgrbOTsPw3ztqMv6XJfumVO/coSrzUkubyRsbwZtSZ8k1E8Rwv20XrTIRRvcgPB
         eqyVizMaDMh0iiHWv/vz3IC3LfoKGZEiTEQEgHwoesXvgjikJhGYplJp5fgdeIBV6UmP
         xUNI/a6H6fVK0QHOuwj1b8UZj5kbMEuftI2FXx6NDb8ZsERHuxa4Uoz3mQJ8vV2pGDdj
         KKeBNJ3jnFPCXPmn6aUApFhjZ41z7M7Wre5GCyiwbXTfYaweP2HR22ZHAQTFy51PbpDK
         kE1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUm3MVhPdlD4o5z3Rvl4ybedsrM+ReMK1OcxSaHRtR99SzKVzyp44QM7q9tR8bkAeNzPgDs8CYhJYFJmd6rdOy9gGXWzajCI+w=
X-Gm-Message-State: AOJu0YxQk9wDfswhCjj7kbFkEfmYeQJJBOW1Sfr0YkuzKnznhnR8zKGX
	9v4Z9bYF7pcIdw5yP4izOr1VIXW/IyaXl0XoLWxTKuePferuUb0EsBdbpHklANriEA7bzxmLwLh
	qi2XHfjnCsT1IwptR9Zehq/CImw==
X-Google-Smtp-Source: AGHT+IG+0DOTB9FlblAidSZ3g7Ny8U/4RGGHUNzHwp5utfk6J+QWRVnW6Y77kLjBvv7fpPt3Te3L6o68qHQpAQrT98s=
X-Received: by 2002:a05:6870:3047:b0:240:3a4e:504e with SMTP id
 586e51a60fabf-24172fca27emr21252516fac.58.1715868545346; Thu, 16 May 2024
 07:09:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20240514075459epcas5p2275b4c26f16bcfcea200e97fc75c2a14@epcas5p2.samsung.com>
 <20240514075444.590910-1-cliang01.li@samsung.com> <20240514075444.590910-3-cliang01.li@samsung.com>
In-Reply-To: <20240514075444.590910-3-cliang01.li@samsung.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Thu, 16 May 2024 19:38:28 +0530
Message-ID: <CACzX3Atc+ot_LzNu1iOHAD3VvcZD8_aPCf4nvSn2S8dY+d5+Uw@mail.gmail.com>
Subject: Re: [PATCH v4 2/4] io_uring/rsrc: store folio shift and mask into imu
To: Chenliang Li <cliang01.li@samsung.com>
Cc: axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org, 
	peiwei.li@samsung.com, joshi.k@samsung.com, kundan.kumar@samsung.com, 
	anuj20.g@samsung.com, gost.dev@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 14, 2024 at 1:25=E2=80=AFPM Chenliang Li <cliang01.li@samsung.c=
om> wrote:
>
> Store the folio shift and folio mask into imu struct and use it in
> iov_iter adjust, as we will have non PAGE_SIZE'd chunks if a
> multi-hugepage buffer get coalesced.
>
> Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
> ---
>  io_uring/rsrc.c | 6 ++++--
>  io_uring/rsrc.h | 2 ++
>  2 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index d08224c0c5b0..578d382ca9bc 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1015,6 +1015,8 @@ static int io_sqe_buffer_register(struct io_ring_ct=
x *ctx, struct iovec *iov,
>         imu->ubuf =3D (unsigned long) iov->iov_base;
>         imu->ubuf_end =3D imu->ubuf + iov->iov_len;
>         imu->nr_bvecs =3D nr_pages;
> +       imu->folio_shift =3D PAGE_SHIFT;
> +       imu->folio_mask =3D PAGE_MASK;
>         *pimu =3D imu;
>         ret =3D 0;
>
> @@ -1153,12 +1155,12 @@ int io_import_fixed(int ddir, struct iov_iter *it=
er,
>
>                         /* skip first vec */
>                         offset -=3D bvec->bv_len;
> -                       seg_skip =3D 1 + (offset >> PAGE_SHIFT);
> +                       seg_skip =3D 1 + (offset >> imu->folio_shift);
>
>                         iter->bvec =3D bvec + seg_skip;
>                         iter->nr_segs -=3D seg_skip;
>                         iter->count -=3D bvec->bv_len + offset;
> -                       iter->iov_offset =3D offset & ~PAGE_MASK;
> +                       iter->iov_offset =3D offset & ~imu->folio_mask;
>                 }
>         }
>
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index b2a9d66b76dd..93da02e652bc 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -46,7 +46,9 @@ struct io_mapped_ubuf {
>         u64             ubuf;
>         u64             ubuf_end;
>         unsigned int    nr_bvecs;
> +       unsigned int    folio_shift;
>         unsigned long   acct_pages;
> +       unsigned long   folio_mask;
>         struct bio_vec  bvec[] __counted_by(nr_bvecs);
>  };
>
> --
> 2.34.1
>
>
Looks good.
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
--
Anuj Gupta

