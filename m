Return-Path: <io-uring+bounces-7042-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D520A5A365
	for <lists+io-uring@lfdr.de>; Mon, 10 Mar 2025 19:50:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CEAE3AAEE7
	for <lists+io-uring@lfdr.de>; Mon, 10 Mar 2025 18:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8ADD22FF32;
	Mon, 10 Mar 2025 18:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="doO/eRo5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7D4D1C3BE0
	for <io-uring@vger.kernel.org>; Mon, 10 Mar 2025 18:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741632632; cv=none; b=a4C4VOYl9JYxHoy90wh8ZIpHyYzWEpVvq/jIUxxPnqOQp1DomyzUGAF7A0L0NYJcwaLAytzIiM3Tv+ELN+wCMkDhMazxDLW+Dy8UttSNez8vUeS5B4GT9H1vRLeujDgIrprMF/bUJRQ7xIsaA1CdcamJZp7AGLWGbGUQ45l/9t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741632632; c=relaxed/simple;
	bh=00mER+4kxyc06AGNSkW2wPBlJg+QDMEWoe1cocAxJCo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cb4ned8RHCQTqRDp5mn0dqsST9WaXZQS62ouHnuxDXt3gHKJUWPlx8ODZJawsGhSQpaqPkas8v+iwq7YidVfiwGgoSpDamZJSXPPT/FTLUjLoit7Sj7ffcuKA8CNSzUwNyufVkzxmDT3f/t4feW4Q78cght+xW4uEIDH7j48Cjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=doO/eRo5; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2f9b8ef4261so1239484a91.1
        for <io-uring@vger.kernel.org>; Mon, 10 Mar 2025 11:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1741632630; x=1742237430; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6d7KRPnKXLnYvSRMLuOoz9R6xRRARXiVa+1IbUrDcXw=;
        b=doO/eRo5f2p2b1pph9SqZSXTRCfHWP880OzHt1J3E93fiCFLjFBXJaDLB3/3uCx8pa
         Z6Q2e4JSAul010ukb69YiNaFt3hBD1w6VEzgOlB6NhVAfirqrSYpKoymP68EIDLVzga8
         +eAsqRlGkLnxZaFJ7/VsxP8MwwZGUTTT6yXu4CAqu/0pPgCTRwEP7H69hZb50j8UrFEj
         RrVJAIbZ2PrFL5IoZXO87vEx5VQXSORPdJsULUWSMRPpK+xHxyDMe9HqT3Z/NH3IJ/zd
         +JKKnsD0eTeKP/k0Qz3nBQ4p6M2CUNU0XKQn+xbYnhej+2YpbX8CTCHiwo5J5+b6+MYp
         Nc8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741632630; x=1742237430;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6d7KRPnKXLnYvSRMLuOoz9R6xRRARXiVa+1IbUrDcXw=;
        b=AsFre36zPjoSbPp3qYP/3BVqiSUVeq6cZFzlxD1XROVD1kCHXOlyNE9nZSyK2410jA
         X5+aesTMJ4Mv6Q1/zBX7bB8BEmDcTKtS+IzoWIphTL0bf7P9edFU0+ZuhPwo0dRgyHGb
         YOM3hHYCOuWuimk0xoWsva9SSuRNryDDa2inI4cpiW9PzdOj6w0BtdL3fKPBO/fMY+bU
         apIICe28ZXOvFq1g8XjAZwfVIx0I0CpPIwg8Ql7cdWxpsGjq4ftuRnXRlh5QOxviEdPB
         Nmbf9d4ZW5WOtk72kn8+KzSPoOqwJPoE6j3adlbrmelkS5yxNzRUPzOVTYLzSoXsINW3
         7KLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtd+W3a0JMf0qVT0Omsn6bo0gBiHwmQGgTdtDKDvcK2G5KraavAYBFn0HpOmV4xNR+waAeH9uvCQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YymQbja/hMvOzMUANjpBDXFy43064rbELVuGxEVUWUVoR2PG/TZ
	Z+oXj0VoCs1xQasImbkPBrr8g9inGY9PTtmwwgawU07InnKnUQBmHXneQ+8VYNL34RSg3JPN2Xb
	0r8w5T5+nQbMsM+W52KQMtsASQC+Lfybs/f6P9w==
X-Gm-Gg: ASbGncscFDlJi7X0c/inFdSkLZG+ttCd6NMAFis7yOqKsU1FJSPvWb6p8Ix6W5xphwQ
	d7n3nEmqq7DcVN3V++JImaO3wN1rC2LlOZUUx8zriHIahSwwSe0rlw5C51MIWd1pQfFbM7SNu5K
	rWXSmYB3G4aDJgmvnb7SSx4714fNs=
X-Google-Smtp-Source: AGHT+IHHbP/Rd3Qyc5SqRQy+2Yjv/DoEGtW3q6pFBwZu3+omdA0D+hOxskbvc1GAiRvVwA02CTydH9slcWrkkAWgw00=
X-Received: by 2002:a17:90b:4a4f:b0:2fe:b2ea:30f0 with SMTP id
 98e67ed59e1d1-300a575a10cmr6073236a91.4.1741632629829; Mon, 10 Mar 2025
 11:50:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250310184825.569371-1-kbusch@meta.com>
In-Reply-To: <20250310184825.569371-1-kbusch@meta.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 10 Mar 2025 11:50:18 -0700
X-Gm-Features: AQ5f1JqyfFmWQnRwF6p3PNZwKYYvJM5v7o1IhlMI87HrzEasEmu3-4Wq_3jGO3I
Message-ID: <CADUfDZr3obnBAvd8gWgyh6fmUdUTrG970aj=QN=JHNVfhJbHQA@mail.gmail.com>
Subject: Re: [PATCH] Revert "io_uring/rsrc: simplify the bvec iter count calculation"
To: Keith Busch <kbusch@meta.com>
Cc: axboe@kernel.dk, asml.silence@gmail.com, io-uring@vger.kernel.org, 
	Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 10, 2025 at 11:48=E2=80=AFAM Keith Busch <kbusch@meta.com> wrot=
e:
>
> From: Keith Busch <kbusch@kernel.org>
>
> This reverts commit 2a51c327d4a4a2eb62d67f4ea13a17efd0f25c5c.
>
> The kernel registered bvecs do use the iov_iter_advance() API, so we
> can't rely on this simplification anymore.
>
> Fixes: 27cb27b6d5ea40 ("io_uring: add support for kernel registered bvecs=
")
> Reported-by: Caleb Sander Mateos <csander@purestorage.com>

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>

> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  io_uring/rsrc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 5dd1e08275594..5fff6ba2b7c05 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1024,7 +1024,7 @@ static int io_import_fixed(int ddir, struct iov_ite=
r *iter,
>          * and advance us to the beginning.
>          */
>         offset =3D buf_addr - imu->ubuf;
> -       iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, len);
> +       iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, offset + len)=
;
>
>         if (offset) {
>                 /*
> @@ -1051,6 +1051,7 @@ static int io_import_fixed(int ddir, struct iov_ite=
r *iter,
>                  * to use the slow iter advance.
>                  */
>                 if (offset < bvec->bv_len) {
> +                       iter->count -=3D offset;
>                         iter->iov_offset =3D offset;
>                 } else if (imu->is_kbuf) {
>                         iov_iter_advance(iter, offset);
> @@ -1063,6 +1064,7 @@ static int io_import_fixed(int ddir, struct iov_ite=
r *iter,
>
>                         iter->bvec +=3D seg_skip;
>                         iter->nr_segs -=3D seg_skip;
> +                       iter->count -=3D bvec->bv_len + offset;
>                         iter->iov_offset =3D offset & ((1UL << imu->folio=
_shift) - 1);
>                 }
>         }
> --
> 2.47.1
>

