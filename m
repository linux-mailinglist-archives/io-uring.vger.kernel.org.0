Return-Path: <io-uring+bounces-7496-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C6A8A90CB1
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 21:58:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A7743BB02F
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 19:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A57A22540A;
	Wed, 16 Apr 2025 19:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gz4vgk+w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B9D225408;
	Wed, 16 Apr 2025 19:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744833490; cv=none; b=m1Nr8+i67A/hguk/fEz0wdPVZSIK5dC6H8H0kCVh89INO6wOTGEGRc5hbZtg19Ukkqp6pYuqsPzUt1NF0xTOFZAHJJ6tg3/xk3cqWFRf4VRSTDsC+l4+/LIvo8JxQOwATXud+C7QTrab+OMQ3uUxQ9WUfv9JNWiAM2kmvtGRx80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744833490; c=relaxed/simple;
	bh=UqW3/mwjLMCZVbSBKoMYMKzxKVaROPrDnAqtWp/Y2fI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Oh5TsC8Nbf5+eOqs7iWCZ1xtqk0lPpzwXnNoNLlX5ely78rg2uzkCcgst6wf3N5N50q2/Q3vGtfovpnbmt7j38kQHzJF8mvlgRld30tJc1EYl424D0EGP7PG43tw5iah0LPGpMzIK8xRDjpuonyy6kCZdFHGdmmS/Vnv07Cx+UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gz4vgk+w; arc=none smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-6fecfae554bso39407b3.0;
        Wed, 16 Apr 2025 12:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744833487; x=1745438287; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uiV36TOCeapIy6LP4wo1t7CAFJVsxezSLglDHgTsdXQ=;
        b=gz4vgk+wdLMtyxbWyCnkfczQKfHVd9PzOHgFsIQMvT+1XoYasSxhh/JXWV/yuGBNQq
         Ue5yk+0kXPpnPU7IQDb+YIQU8ogSIMiJj2HCBFUPeUKyP3qt5qt89nqCA9FR/H7WiHSF
         xlAg0R8K7oIaYE9yBvncx9XHWlt3PoqIQum/fCjPUffJ64HkHcEbC+RUaXd6YawTLJqR
         Vf94RvjZ3i26/acuR2Z1r574QtGK8QHWooQUoyCoaZcqngwYcgisEm9xXeEj24hCky2x
         DzDg42DOo96YiZk4qOpa0dofkqEXtFBOSmJ3CgDjt3p/2kA5RxRjzNh4J7A0ukDMBzih
         x3cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744833487; x=1745438287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uiV36TOCeapIy6LP4wo1t7CAFJVsxezSLglDHgTsdXQ=;
        b=CRfym+JuK41bE76ixM+z9joRkB0sn6xsiuZCWBJfKU6RtUQ0e7LSKzaILIOa89gQ2w
         ZGapMwgmIH3RHxUqFlPsOz4G3cESbf44UuMnlOL9O1pbCWCuwwemqhdCcb0ppeq0Np8W
         rRTlOIDFSOBhAemufhNNoR96kLSvylNTVgC90kPqSAJJ33QC3Du/f2FqPBB0uTenWt6p
         1aLpsrd0wNqfnTsKmI09wbFgyxMutZjvGxkI7loe3/oZXjbARXLabEBu6pukFZ5SHYP7
         2Rk3Wqw4zgUQNVdJDi23rrajZXr9DP67Wyo1Mxw5TEu1NQZZlrm8wNupdT1FYuOVr++O
         oVDQ==
X-Forwarded-Encrypted: i=1; AJvYcCUMSIXgb5IKRAAMK1lrki4KGi9N8czZxEyfK8O10eQCEYw9c7KzfbCgZTq3KlptAtxGXW8Pt0dUHxbItmfI@vger.kernel.org, AJvYcCVoq2kpJ6CmaTuJLewSceie9pfqgJbnQtnjksRjjFWSuR6s/lHCV4orpfcutp6oLJj6nAMY+gaqmA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwePB1A0imiDaJktXVBqh4rq23bsqoV4J4c7bbnV4JZsbfq7V3K
	OEd2IcxiIDQJgmGLunuOfqrxjzaT7XCVDKGbP86dlNV6ZigxCh3hZwRrT+PaIq1MvyAfvPi/LwW
	QtAWa/P5rOgWaCvHOTROsHU6mTqQ=
X-Gm-Gg: ASbGnctJ9l8odk8GM6rrr7hYq+KZWujMpz5C+1dp5T45bQTxk1Sxv2rAkqPexCmG6Vh
	lYsFZSg8NeduKApeVAoR3MxMLwhAkrSw1JaPprlnsBW2xxpJfxqPSq+lPS/b+OWkLMfvN8XlHsM
	F7q9m2Aoc8n3WZT+Duc3KJLA==
X-Google-Smtp-Source: AGHT+IGgbJ8DCVJzfkUBW6w3VAiYaP6zWFEeGfTRtyMJgkx9hDTMIz8VtQtX0AXcgDA2qRuO0oV2G7VWUANuBSS2ySk=
X-Received: by 2002:a05:690c:4c11:b0:703:b5ae:a3da with SMTP id
 00721157ae682-706b338e022mr46467147b3.32.1744833487488; Wed, 16 Apr 2025
 12:58:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20250416055250epcas5p25fa8223a1bfeea5583ad8ba88c881a05@epcas5p2.samsung.com>
 <20250416054413.10431-1-nj.shetty@samsung.com> <98f08b07-c8de-4489-9686-241c0aab6acc@gmail.com>
 <37c982b5-92e1-4253-b8ac-d446a9a7d932@kernel.dk> <40a0bbd6-10c7-45bd-9129-51c1ea99a063@kernel.dk>
In-Reply-To: <40a0bbd6-10c7-45bd-9129-51c1ea99a063@kernel.dk>
From: Nitesh Shetty <nitheshshetty@gmail.com>
Date: Thu, 17 Apr 2025 01:27:55 +0530
X-Gm-Features: ATxdqUFSaFteCFOrfGp-HXKt8ggNDOws7ZSH8jkDxA08s9hvoNGgy20cdCAL8wM
Message-ID: <CAOSviJ3MNDOYJzJFjQDCjc04pGsktQ5vjQvDotqYoRwC2Wf=HQ@mail.gmail.com>
Subject: Re: [PATCH] io_uring/rsrc: send exact nr_segs for fixed buffer
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Nitesh Shetty <nj.shetty@samsung.com>, gost.dev@samsung.com, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 16, 2025 at 11:55=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> On 4/16/25 9:07 AM, Jens Axboe wrote:
> > On 4/16/25 9:03 AM, Pavel Begunkov wrote:
> >> On 4/16/25 06:44, Nitesh Shetty wrote:
> >>> Sending exact nr_segs, avoids bio split check and processing in
> >>> block layer, which takes around 5%[1] of overall CPU utilization.
> >>>
> >>> In our setup, we see overall improvement of IOPS from 7.15M to 7.65M =
[2]
> >>> and 5% less CPU utilization.
> >>>
> >>> [1]
> >>>       3.52%  io_uring         [kernel.kallsyms]     [k] bio_split_rw_=
at
> >>>       1.42%  io_uring         [kernel.kallsyms]     [k] bio_split_rw
> >>>       0.62%  io_uring         [kernel.kallsyms]     [k] bio_submit_sp=
lit
> >>>
> >>> [2]
> >>> sudo taskset -c 0,1 ./t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -n=
2
> >>> -r4 /dev/nvme0n1 /dev/nvme1n1
> >>>
> >>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> >>> ---
> >>>   io_uring/rsrc.c | 3 +++
> >>>   1 file changed, 3 insertions(+)
> >>>
> >>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> >>> index b36c8825550e..6fd3a4a85a9c 100644
> >>> --- a/io_uring/rsrc.c
> >>> +++ b/io_uring/rsrc.c
> >>> @@ -1096,6 +1096,9 @@ static int io_import_fixed(int ddir, struct iov=
_iter *iter,
> >>>               iter->iov_offset =3D offset & ((1UL << imu->folio_shift=
) - 1);
> >>>           }
> >>>       }
> >>> +    iter->nr_segs =3D (iter->bvec->bv_offset + iter->iov_offset +
> >>> +        iter->count + ((1UL << imu->folio_shift) - 1)) /
> >>> +        (1UL << imu->folio_shift);
> >>
> >> That's not going to work with ->is_kbuf as the segments are not unifor=
m in
> >> size.
> >
> > Oops yes good point.
>
> How about something like this? Trims superflous end segments, if they
> exist. The 'offset' section already trimmed the front parts. For
> !is_kbuf that should be simple math, like in Nitesh's patch. For
> is_kbuf, iterate them.
>
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index bef66e733a77..e482ea1e22a9 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1036,6 +1036,7 @@ static int io_import_fixed(int ddir, struct iov_ite=
r *iter,
>                            struct io_mapped_ubuf *imu,
>                            u64 buf_addr, size_t len)
>  {
> +       const struct bio_vec *bvec;
>         unsigned int folio_shift;
>         size_t offset;
>         int ret;
> @@ -1052,9 +1053,10 @@ static int io_import_fixed(int ddir, struct iov_it=
er *iter,
>          * Might not be a start of buffer, set size appropriately
>          * and advance us to the beginning.
>          */
> +       bvec =3D imu->bvec;
>         offset =3D buf_addr - imu->ubuf;
>         folio_shift =3D imu->folio_shift;
> -       iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, offset + len)=
;
> +       iov_iter_bvec(iter, ddir, bvec, imu->nr_bvecs, offset + len);
>
>         if (offset) {
>                 /*
> @@ -1073,7 +1075,6 @@ static int io_import_fixed(int ddir, struct iov_ite=
r *iter,
>                  * since we can just skip the first segment, which may no=
t
>                  * be folio_size aligned.
>                  */
> -               const struct bio_vec *bvec =3D imu->bvec;
>
>                 /*
>                  * Kernel buffer bvecs, on the other hand, don't necessar=
ily
> @@ -1099,6 +1100,27 @@ static int io_import_fixed(int ddir, struct iov_it=
er *iter,
>                 }
>         }
>
> +       /*
> +        * Offset trimmed front segments too, if any, now trim the tail.
> +        * For is_kbuf we'll iterate them as they may be different sizes,
> +        * otherwise we can just do straight up math.
> +        */
> +       if (len + offset < imu->len) {
> +               bvec =3D iter->bvec;
> +               if (imu->is_kbuf) {
> +                       while (len > bvec->bv_len) {
> +                               len -=3D bvec->bv_len;
> +                               bvec++;
> +                       }
> +                       iter->nr_segs =3D bvec - iter->bvec;
> +               } else {
> +                       size_t vec_len;
> +
> +                       vec_len =3D bvec->bv_offset + iter->iov_offset +
> +                                       iter->count + ((1UL << folio_shif=
t) - 1);
> +                       iter->nr_segs =3D vec_len >> folio_shift;
> +               }
> +       }
>         return 0;
>  }
This might not be needed for is_kbuf , as they already update nr_seg
inside iov_iter_advance.

How about changing something like this ?

-               if (offset < bvec->bv_len) {
-                       iter->count -=3D offset;
-                       iter->iov_offset =3D offset;
-               } else if (imu->is_kbuf) {
+               if (!imu->is_kbuf) {
+                       size_t vec_len;
+
+                       if (offset < bvec->bv_len) {
+                               iter->count -=3D offset;
+                               iter->iov_offset =3D offset;
+                       } else {
+                               unsigned long seg_skip;
+
+                               /* skip first vec */
+                               offset -=3D bvec->bv_len;
+                               seg_skip =3D 1 + (offset >> folio_shift);
+
+                               iter->bvec +=3D seg_skip;
+                               iter->count -=3D bvec->bv_len + offset;
+                               iter->iov_offset =3D offset & ((1UL <<
folio_shift) - 1);
+                       }
+                       vec_len =3D ALIGN(iter->bvec->bv_offset +
iter->iov_offset +
+                               iter->count, folio_shift;
+                       iter->nr_segs =3D vec_len >> folio_shift;
+               } else
                        iov_iter_advance(iter, offset);
-               } else {
-                       unsigned long seg_skip;
-
-                       /* skip first vec */
-                       offset -=3D bvec->bv_len;
-                       seg_skip =3D 1 + (offset >> folio_shift);
-
-                       iter->bvec +=3D seg_skip;
-                       iter->count -=3D bvec->bv_len + offset;
-                       iter->iov_offset =3D offset & ((1UL << folio_shift)=
 - 1);
-               }
        }

Regards,
Nitesh

