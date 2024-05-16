Return-Path: <io-uring+bounces-1909-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CC5D8C7849
	for <lists+io-uring@lfdr.de>; Thu, 16 May 2024 16:10:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A2FF71F22FA4
	for <lists+io-uring@lfdr.de>; Thu, 16 May 2024 14:10:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A89751487F2;
	Thu, 16 May 2024 14:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nm7nwfs/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F216314A4E5
	for <io-uring@vger.kernel.org>; Thu, 16 May 2024 14:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715868605; cv=none; b=epgLVNg7tCRg0dYU7Dpz9Uv8oxa9NtuKbCzWmSyFG9fMtIJutAmxwIDXRwberFdDTUNgXrxGtQuQZyi2KK2zDvXhy/zSsXO6XIocYKedaa7BmCtgd9B4pmG7bJmxJB8p9oz2XFxMWWq0A4VvPNvFobwuQjTPvuw9By4oY5163kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715868605; c=relaxed/simple;
	bh=ln2Ar5+YNwXgZqYG+hq+pg87IaUMPiYi+nFZTXNnYK4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mCCEVENFNqTR/dQXlfq+HpUQl1GpFgi+wxywQ8uYOqFeCKiVvSDBPl4tgXDFt5Lzic+mSyyBEkOkbnbj4fnOpe7OSi08Hz2PKmg0KpEjWB40vLf5OoJlO/l3JM5hSTqBE09T+M9eCP4lgBcv47lJ4YI9/OJ8mZ23pQ+f+tECJnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nm7nwfs/; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-792bdf626beso743135785a.1
        for <io-uring@vger.kernel.org>; Thu, 16 May 2024 07:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715868603; x=1716473403; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VCVee+x8S7DZWEoAXOAefjjymIod8VPgf0GaQBTWIKU=;
        b=Nm7nwfs/oDvi+f65MG4r0HoiJfK9MZeEG9/TKxkLOW/3fut+yJ4qmiBm71oYl6YgPG
         b+ywQQF1WfGchaa3DrzvcitY7bh7RZn/bEaEnbLGGefSzMwFJh8LhOAKwmTcFbAl+4rE
         nuW6ls+R6HBqFRSWBv9K7Z269EBrjbvJYxdHoHQItPbaR7yBv+22BDP4n0hXSWLK5iK2
         aMneAwiIFqyoXaH1TAqzAEA6mAaRcDuRo5v5H9SpMXY26f3SmkLQ4DdDrrBDrQK9Q1wv
         hf6k/8lRCml6s3ZP1gpqYM6Yuh+WUPj3D0cDoc/qxh+XeMO9Icx/2JzrpBaNQhyhOUYI
         yxgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715868603; x=1716473403;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VCVee+x8S7DZWEoAXOAefjjymIod8VPgf0GaQBTWIKU=;
        b=HqOBxCU18go0cPZtLSH0CLcnBQqs8qEL+9ZpV+yIiWNy6uP7t0XcvrfEoYAOcqdc2b
         jD+WooHsJ+GSFvPiRjVxGFC1+bGNXfOw29dhRu3lissYIGOTQgfRGIPvYHj+29Eg0MDK
         YQMow+J4hovC8HWBxpJldvhq6vsT1Z0FEMdYEIMl9nqJgXq99Clp6JjUXTSkltOhnxRx
         sWQp+HZgRZMmiffE5kcAXHCafYGcMo9w5/w7r23OMxtevFkkD4E1Fbs7+GRvB+cliApJ
         vtUb5CJStn2l58hIvCwVtTsWZB50hZqGF9dplQdcFxb6lClJv24DozMM1z3NymZrKEk3
         hQyw==
X-Forwarded-Encrypted: i=1; AJvYcCVMYqldeuBtAuyu3ZJRAhYwKhamJ1YqBzLJhsiSxKIffnLrp2yNMVACizT0k6T5goR7I8jGQhu6rdTViu+22G98smxL9depBkM=
X-Gm-Message-State: AOJu0YwMDHsw3lfe1hdSFEmmUZZGOHpmmXeiD+gd5s7KcsxQ8Vrc38VB
	hCENIbDOPK+aW0LNkEMH3HJuh3XFkdhUIc/V7HK+0yH9u6iFydJw1Ge73EArQAYxmQfWX75u+mc
	8NiATYPvczrka4dtF5CMnCUAKGA==
X-Google-Smtp-Source: AGHT+IFrQ1vacp9mrZxIFH5pO7p/pYMkvn2nICazeqUATbMNYuf0SyCfrB/A84K9zPckZT2bnLLoWmrbch6quGC+RFI=
X-Received: by 2002:a05:620a:248c:b0:790:c15b:e192 with SMTP id
 af79cd13be357-792bbe66992mr3782809685a.32.1715868602733; Thu, 16 May 2024
 07:10:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20240514075502epcas5p10be6bef71d284a110277575d6008563d@epcas5p1.samsung.com>
 <20240514075444.590910-1-cliang01.li@samsung.com> <20240514075444.590910-5-cliang01.li@samsung.com>
In-Reply-To: <20240514075444.590910-5-cliang01.li@samsung.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Thu, 16 May 2024 19:39:26 +0530
Message-ID: <CACzX3AuG4A7jfN8xtcT3FZFvPp_FZTW1vozqgAkdZvF=ZZPpcA@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] io_uring/rsrc: enable multi-hugepage buffer coalescing
To: Chenliang Li <cliang01.li@samsung.com>
Cc: axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org, 
	peiwei.li@samsung.com, joshi.k@samsung.com, kundan.kumar@samsung.com, 
	anuj20.g@samsung.com, gost.dev@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 14, 2024 at 1:25=E2=80=AFPM Chenliang Li <cliang01.li@samsung.c=
om> wrote:
>
> Modify the original buffer registration and enable the coalescing for
> buffers with more than one hugepages.
>
> Signed-off-by: Chenliang Li <cliang01.li@samsung.com>
> ---
>  io_uring/rsrc.c | 44 ++++++++------------------------------------
>  1 file changed, 8 insertions(+), 36 deletions(-)
>
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 53fac5f27bbf..5e5c1d6f3501 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1047,7 +1047,7 @@ static int io_sqe_buffer_register(struct io_ring_ct=
x *ctx, struct iovec *iov,
>         unsigned long off;
>         size_t size;
>         int ret, nr_pages, i;
> -       struct folio *folio =3D NULL;
> +       struct io_imu_folio_data data;
>
>         *pimu =3D (struct io_mapped_ubuf *)&dummy_ubuf;
>         if (!iov->iov_base)
> @@ -1062,30 +1062,11 @@ static int io_sqe_buffer_register(struct io_ring_=
ctx *ctx, struct iovec *iov,
>                 goto done;
>         }
>
> -       /* If it's a huge page, try to coalesce them into a single bvec e=
ntry */
> -       if (nr_pages > 1) {
> -               folio =3D page_folio(pages[0]);
> -               for (i =3D 1; i < nr_pages; i++) {
> -                       /*
> -                        * Pages must be consecutive and on the same foli=
o for
> -                        * this to work
> -                        */
> -                       if (page_folio(pages[i]) !=3D folio ||
> -                           pages[i] !=3D pages[i - 1] + 1) {
> -                               folio =3D NULL;
> -                               break;
> -                       }
> -               }
> -               if (folio) {
> -                       /*
> -                        * The pages are bound to the folio, it doesn't
> -                        * actually unpin them but drops all but one refe=
rence,
> -                        * which is usually put down by io_buffer_unmap()=
.
> -                        * Note, needs a better helper.
> -                        */
> -                       unpin_user_pages(&pages[1], nr_pages - 1);
> -                       nr_pages =3D 1;
> -               }
> +       /* If it's huge page(s), try to coalesce them into fewer bvec ent=
ries */
> +       if (io_sqe_buffer_try_coalesce(pages, nr_pages, &data)) {
> +               ret =3D io_coalesced_imu_alloc(ctx, iov, pimu, last_hpage=
,
> +                                               pages, &data);
> +               goto done;
>         }
>
>         imu =3D kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
> @@ -1109,10 +1090,6 @@ static int io_sqe_buffer_register(struct io_ring_c=
tx *ctx, struct iovec *iov,
>         *pimu =3D imu;
>         ret =3D 0;
>
> -       if (folio) {
> -               bvec_set_page(&imu->bvec[0], pages[0], size, off);
> -               goto done;
> -       }
>         for (i =3D 0; i < nr_pages; i++) {
>                 size_t vec_len;
>
> @@ -1218,23 +1195,18 @@ int io_import_fixed(int ddir, struct iov_iter *it=
er,
>                  * we know that:
>                  *
>                  * 1) it's a BVEC iter, we set it up
> -                * 2) all bvecs are PAGE_SIZE in size, except potentially=
 the
> +                * 2) all bvecs are the same in size, except potentially =
the
>                  *    first and last bvec
>                  *
>                  * So just find our index, and adjust the iterator afterw=
ards.
>                  * If the offset is within the first bvec (or the whole f=
irst
>                  * bvec, just use iov_iter_advance(). This makes it easie=
r
>                  * since we can just skip the first segment, which may no=
t
> -                * be PAGE_SIZE aligned.
> +                * be folio_size aligned.
>                  */
>                 const struct bio_vec *bvec =3D imu->bvec;
>
>                 if (offset < bvec->bv_len) {
> -                       /*
> -                        * Note, huge pages buffers consists of one large
> -                        * bvec entry and should always go this way. The =
other
> -                        * branch doesn't expect non PAGE_SIZE'd chunks.
> -                        */
>                         iter->bvec =3D bvec;
>                         iter->nr_segs =3D bvec->bv_len;
>                         iter->count -=3D offset;
> --
> 2.34.1
>
>
Looks good.
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
--
Anuj Gupta

