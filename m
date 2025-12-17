Return-Path: <io-uring+bounces-11132-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3183ECC60AE
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 06:34:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D0791301C930
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 05:33:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF1951FF7C7;
	Wed, 17 Dec 2025 05:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="XBMpvLmz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F399E1E0E08
	for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 05:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765949633; cv=none; b=a8uRYtVQlSj2TubBxNbrH0jDIXt1kf5UhGdVYFfCeCoyBs9SxzPKGlTYuy8tiUgG0/gtO4keS6EN00uETJjN3HpApw5jmhfFUohB6aKyoVYaP2SxtKz4NSEFeO3uugGIDKAX7tdxJCI8Q5bz0Hu5bn5mML3eftiDivm5B9/mFtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765949633; c=relaxed/simple;
	bh=DST+x9LPybiYdj7182pyF4xlqv6OlY0U+zBHD+N19dE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZXRrpODB4BsYPNiZAVNOegDvA8h6MqRhbLclXzyhYGKb9KJpy8X6DGLP6vlmhPconbprfbykFygWbskvOr1HKQ52GZnFHSJrWFkahUfQ2QHsZIYHC4T/Z8Za5GGb/2+bipqi6Swx0VuFL82/EfNu67HoqVN6YbA9fXggKwyOrQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=XBMpvLmz; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2a08cb5e30eso8916035ad.1
        for <io-uring@vger.kernel.org>; Tue, 16 Dec 2025 21:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1765949631; x=1766554431; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v7LVKUBAzho21lrKwJ0H+Rmeeg7N0ADHqxWDdZWfz8o=;
        b=XBMpvLmzc3N2ejBfS/ULEcyr+Brt3APyZXewQY8aYSS2mfB+EvTZ3CmRpThuPxb4pQ
         aMEl9UlAoDBuEpa3hwItY8N58mlETEVC10nkbfsAgWF6hSf+HxvzV/22Fnb3PDS1MV4X
         d3FvUhFBUD2N9GA79QtTf000xG44HmfAWCzcQ+SqDcba4AWEVn8zhi3PhIh9ucJqqlZO
         PgvcR++DVeLLozGc9o+qNfwMTq42jjAByWDPwnuqTWWGfuVKbLWjIZ/7PNBQQPEvafE8
         Y5RpY/JKyzBLf7mc9bi2++4MSd3w3AWoHdLi2XbJjjR67SGWB/oneKFlXTuorxSi2H+P
         b79w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765949631; x=1766554431;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v7LVKUBAzho21lrKwJ0H+Rmeeg7N0ADHqxWDdZWfz8o=;
        b=T+Wx9Gxt9unno0MpJv23b8Ev7iRvOgrHsfgZWxYIYk35fIqh6WqnKRcagkJ8C3iLpB
         +Fkyn8OG/VGKcHeuL5+G05eTl8WymOO9ymYJn0MOrR4BNEZtnSR6ywCS3hnEqszLXpPM
         Up+h9aiZ8Xfm2ijEqV+zDW9oRS8dy3LyZ2A7Ir2GsIolAym2+boIdXVKHdmt8idaECuX
         Dzuck5VWPIHlBLrqwM+6OCDUrYO7V3sQY8D1IjNs1DhlLMG6o8CyJuH4wVkcjpLrHS3I
         mVGih0rgDAlkJlvpj7pK/GiFb8xfgcI5lgqsse7SRx2Zqj1A0owwG0FF3C1ledHuDi/O
         bvlw==
X-Gm-Message-State: AOJu0Yy5yG/VerVEFvgo6Ygn+KJEsJurNXOr0gFs489RKyufc/Mx2YKU
	nVcR704yMtXXgw8TcUbhTlZ3v6OZS422L40V1TUjZv08LjZYEG4JW0blg/z7a/6Y4GkF2gKdBLq
	/z5BdsE0VYGd5MULDOndQIjmm5NrjRzD3sc2ctHMblA==
X-Gm-Gg: AY/fxX6Wr1zWMWmKTXjXtVqmBP65Xi2tbLBRO5GkL7btu5Jo34tSn9CueMU6Szgi9wL
	9vnP2bBqxD4SgIh/e3Ord1T/uHf7T6GEnukPh7m5X+wJ9LA5PH5gnqEp2hakyaUZfJAJn8i7X7u
	KBs/WWUVbBJn2GIt4Q6yqPUZbfR3EO4uxlUzRa6nkby85JYYOUXME8rI0gyr27EU75LBFmhVsiB
	Cpdeu9w+g0kSIn099XCQnyXH+RiMjZJK1p3NPt4R5WhU4WfVCAR8qBhslQrZapNUH19lSM1
X-Google-Smtp-Source: AGHT+IEDO2e4oqrAW3KoaZ1ukW3upIm3Qu+OPoDqt5lM/D4B9Ky5jAWYkF2CMxiGU1tI8V1rbcoBu7nC6Xhwn32RySQ=
X-Received: by 2002:a05:7023:885:b0:11e:3e9:3e88 with SMTP id
 a92af1059eb24-11f34c51e76mr6015410c88.6.1765949631005; Tue, 16 Dec 2025
 21:33:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251217032617.162914-1-huang-jl@deepseek.com>
In-Reply-To: <20251217032617.162914-1-huang-jl@deepseek.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 16 Dec 2025 21:33:39 -0800
X-Gm-Features: AQt7F2oB4kiWmo0uN4dzTlsGChkwPe9sM_53Gw1Zzzrq0lueRxXLRiKCrhOb1Rc
Message-ID: <CADUfDZo4Kbkodz3w-BRsSOEwTGeEQeb-yppmMNY5-ipG33B2qg@mail.gmail.com>
Subject: Re: [PATCH 01/01] io_uring: fix nr_segs calculation in io_import_kbuf
To: huang-jl <huang-jl@deepseek.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, ming.lei@redhat.com, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 8:02=E2=80=AFPM huang-jl <huang-jl@deepseek.com> wr=
ote:
>
> io_import_kbuf() calculates nr_segs incorrectly when iov_offset is
> non-zero after iov_iter_advance(). It doesn't account for the partial
> consumption of the first bvec.
>
> The problem comes when meet the following conditions:
> 1. Use UBLK_F_AUTO_BUF_REG feature of ublk.
> 2. The kernel will help to register the buffer, into the io uring.
> 3. Later, the ublk server try to send IO request using the registered
>    buffer in the io uring, to read/write to fuse-based filesystem, with
> O_DIRECT.
>
> From a userspace perspective, the ublk server thread is blocked in the
> kernel, and will see "soft lockup" in the kernel dmesg.
>
> When ublk registers a buffer with mixed-size bvecs like [4K]*6 + [12K]
> and a request partially consumes a bvec, the next request's nr_segs
> calculation uses bvec->bv_len instead of (bv_len - iov_offset).
>
> This causes fuse_get_user_pages() to loop forever because nr_segs
> indicates fewer pages than actually needed.
>
> Specifically, the infinite loop happens at:
> fuse_get_user_pages()
>   -> iov_iter_extract_pages()
>     -> iov_iter_extract_bvec_pages()
> Since the nr_segs is miscalculated, the iov_iter_extract_bvec_pages
> returns when finding that i->nr_segs is zero. Then
> iov_iter_extract_pages returns zero. However, fuse_get_user_pages does
> still not get enough data/pages, causing infinite loop.
>
> Example:
>   - Bvecs: [4K, 4K, 4K, 4K, 4K, 4K, 12K, ...]
>   - Request 1: 32K at offset 0, uses 6*4K + 8K of the 12K bvec
>   - Request 2: 32K at offset 32K
>     - iov_offset =3D 8K (8K already consumed from 12K bvec)
>     - Bug: calculates using 12K, not (12K - 8K) =3D 4K
>     - Result: nr_segs too small, infinite loop in fuse_get_user_pages.
>
> Fix by accounting for iov_offset when calculating the first segment's
> available length.

Please add a Fixes tag

>
> Signed-off-by: huang-jl <huang-jl@deepseek.com>
> ---
>  io_uring/rsrc.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index a63474b33..4eca0c18c 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1058,6 +1058,14 @@ static int io_import_kbuf(int ddir, struct iov_ite=
r *iter,
>
>         if (count < imu->len) {
>                 const struct bio_vec *bvec =3D iter->bvec;
> +               size_t first_seg_len =3D bvec->bv_len - iter->iov_offset;
> +
> +               if (len <=3D first_seg_len) {
> +                       iter->nr_segs =3D 1;
> +                       return 0;
> +               }
> +               len -=3D first_seg_len;
> +               bvec++;

Would a simpler fix be just to add a len +=3D iter->iov_offset before the l=
oop?

Best,
Caleb

>
>                 while (len > bvec->bv_len) {
>                         len -=3D bvec->bv_len;
> --
> 2.43.0
>
>

