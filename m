Return-Path: <io-uring+bounces-11155-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DF661CC9325
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 19:08:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 56B9D3034D4A
	for <lists+io-uring@lfdr.de>; Wed, 17 Dec 2025 18:08:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09FC327465C;
	Wed, 17 Dec 2025 18:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="DKxXI9t8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6BB21638D
	for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 18:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765994924; cv=pass; b=F5RkMqr0Xq/hJB+w5vi9qX+O2ZsPDixz36iah8RXKU7uvLaP2PZuB+kmhN0AgY1JE+AjOxVFX7ALmnDjOHlTw+orq+OKwSfMhk4wnwDXyROuGziRfAokkRdX2f0Z39VRqQUIjB+9LofLg/i/B3yM9Sv4JxZOac+52+FAEvVxuYE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765994924; c=relaxed/simple;
	bh=+f6pLDVxKmDdrAafhiTaO1qCMRLoArlFFjmv+gfeZ3c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E0dSg+wcTFUWB6rDrxBdC/TL5/FaXpMM0IWYIl5v1+tjd9UjgWYiPoxF3aFZRLHn5xW8u1zSSH6MopTOdsUQAvAlJL29a/czbTM079CGMNYUKXO1S0fQ0sp644Rbw/TZrrJmRKRWYx7YVnEVowptxIYtQQlRhlSyAQTNZKkMPiM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=DKxXI9t8; arc=pass smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c03ea3b9603so409942a12.2
        for <io-uring@vger.kernel.org>; Wed, 17 Dec 2025 10:08:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765994922; cv=none;
        d=google.com; s=arc-20240605;
        b=cladP/CXyTsDIHRI32G4cXuasCokB2nTRWxJJMBPQjTOJjah3X/P/jPtaxHpNpqn/l
         ehb0kk4HPwdWSpNbNugxbcOP+A9zk6R/ACHpuSKNYS4H37ouUba3cYJ1Ps0iPHZmD3of
         kY38VYYUrXR9aJgyVlM3zDxfiMSn05pIYwDW2kOr54xrACG1JxZqAk793vhg173r3IZW
         XJq+Q9QpZT6lsPYgcYjCXz2N5x4kPRynm695dDBcS4WH2uUmq2UxfpZoUM4sI5sCU9Uy
         sWlv3myU6X1EivpC6WXxwSlJL6o+rCqcFrrogaWENt+qI/yrwrG5pIdwBDiUwAYShKyX
         K3Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sqXX5V0y/GmAHw/j5eBR5l0SkO/n2/9GJRWX/yrGrAk=;
        fh=cpXamI8UV3Sa11107pY+zhFA5hUwtAJpII0ZOTEVBEo=;
        b=lriWgfKGVBFAsRfkuZbjDzPDAqh4Qx4a01+M9CH4xpKa7kir9EXZxy90arHbeJvxqU
         Uy3GkT7CB0x7O90WNwFvBcbV8HpSkvVf3oIT8y7xaTyd16fFWdRWcgtDbXFas3GwDl8r
         8a98Dfgpxlr7iQ8aCmCCpFfdxYkgy/gmCsf1pESsisS/Zzbg9oWwi9lvadBc70s+xZ1v
         EBn5IgNLTcmQFD48muICc1BFgwuPdmygRcsCU+fbal+uGglfvHVeb7LGgWgEZWU2wSTN
         heOnBJRgqgVDXyxCB67IavTTansr3iCvwhGjcys8QbBWe0TyJvF1yN5mPZzgTbHbII9B
         60/A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1765994922; x=1766599722; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sqXX5V0y/GmAHw/j5eBR5l0SkO/n2/9GJRWX/yrGrAk=;
        b=DKxXI9t8XJzVRUS0167Ks7m79PfxN9v7pEOD69gN9gE57SrISqETFDvbvUWBw2vK6Y
         kncb8UkkXDtIfj8I9c+aUjqH+1v95F+8mj3DNOlrWYJGuuszHPqs0OTlst2ZOTFvLmAF
         3XhSxgVUFik4IwtKUuc8mWDLofYyWWH40z7jEefY3zbJ0/CRlaMxC3SCWAq+IniDRln/
         Ghh1DLQfF/tARimFMI30tICquIXXd6nO1B76GdfDurO1s2O12eIFCjuPtutPqvXlwCCb
         eox5qfkGbg2o26JEsC7l07nmE5H7YxcoRc6z+QjE7bacnPduCmLxcOoI3s2P+jMnC45k
         b6jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765994922; x=1766599722;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sqXX5V0y/GmAHw/j5eBR5l0SkO/n2/9GJRWX/yrGrAk=;
        b=vjMR3girq/KGcNiEZCYWhB824i0KAWaxXobewqNIQ4iFVJMfBJYK/hizehn4vwByxn
         zNqefTu5vK8v+G0QUDPQ5MMtylndKoO8Bp7rPrdNDaEmGCL8IqVp1gvQi7WcUbfh9Ntx
         kcGCr0YQJv1X+hqU2DvpRLhDuTVjIjnGfDeuP7zAlVEo8OD0goRCrKybWLX7Y5JZs93F
         WOgbHJLWXc6hAFGdlTfVc/hqzBqIMpiGjTeFbR9OwMwAaarj34++3a+Hi9POzhmBTmgL
         KyOBp6vhBarKyyoLV7Ftp9ucLZsoa8Vk5WzV3+oFjiX17l9GD4AkoNHewxMwHWU0zJrE
         DGpw==
X-Forwarded-Encrypted: i=1; AJvYcCVNCuspmS407YrKXoNeMBeLIOh5M6fCwLjaj0mUxV1kgehM39PfZqIIxnCSUrZXea9Rimh5QIrT1A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8mrKwIFSvS3TzPXbAC3c2rZN2yUIWG+8KcsjLDcS2is5H1AQ3
	gMauitutqlfU7tsHQiBBCX0rXiS3j8DmIKBMEn52eerXl07ceA2QMowYfDTlpZlW0MXBrxjCWqx
	rXNPL7ovLh4OHaFwQfRxFTT3GepeIzyicgCbo6Umu8A==
X-Gm-Gg: AY/fxX7xkjFc+u9z6pMJ9CRVfTivzXFwDWUg0JeJssJ07QPXDZmhrzCgbTFNP0tgEzA
	yrUIadxkPagkipytbXw/u4FEZkthC7b78duXCI2vG1MTABWRfYPxsjDwmho9TrACGirufXa5dvx
	b4smHYJMRMg6XtxtGpzpTMyQILTtD9xFSnQjQRI+hH1Br00kZfpKqfF/jI7dsFQq5246qwCzi0w
	RyreuFh4HW8p7MYwMg3oE2Y5Tmo24X76781zglYjEyDE6o/e54EepbLBfZKoa7Bm1Zvjfwa
X-Google-Smtp-Source: AGHT+IEfNta51hA9Bsp9+wHvIltb3Ow9dR8JiCSw1SA+Wjc4E2sA5J/3Z5FAvbHFP6CbaQhfWrshugEFb0ZeTze7pAw=
X-Received: by 2002:a05:7022:7e84:b0:11e:3e9:3e98 with SMTP id
 a92af1059eb24-11f34c4b85dmr7340619c88.7.1765994922256; Wed, 17 Dec 2025
 10:08:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADUfDZo4Kbkodz3w-BRsSOEwTGeEQeb-yppmMNY5-ipG33B2qg@mail.gmail.com>
 <20251217062632.113983-1-huang-jl@deepseek.com>
In-Reply-To: <20251217062632.113983-1-huang-jl@deepseek.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 17 Dec 2025 10:08:30 -0800
X-Gm-Features: AQt7F2rHioI0XR9ah-g8QyUNuTK0I0VZ798gZ0CP1QG-6M9_TEXfhBxzPdt27WQ
Message-ID: <CADUfDZohpg7RUdHfWL2HPFcNwmvSDGz3jMahaT2jD6poCDE4Ug@mail.gmail.com>
Subject: Re: [PATCH v2] io_uring: fix nr_segs calculation in io_import_kbuf
To: huang-jl <huang-jl@deepseek.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ming.lei@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 10:27=E2=80=AFPM huang-jl <huang-jl@deepseek.com> w=
rote:
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
>
> Fixes: b419bed4f0a6 ("io_uring/rsrc: ensure segments counts are correct o=
n kbuf buffers")
> Signed-off-by: huang-jl <huang-jl@deepseek.com>
> ---
>  v2: Optimize the logic to handle the iov_offset and add Fixes tag.
>
>  > Please add a Fixes tag
>
>  Thanks for your notice, this is my first time to send patch to linux. I
>  have add the Fixes tag, but not sure if I am doing it correctly.

Yup, that looks great. That will help figure out which stable kernels
the patch should be backported to.

Thanks,
Caleb

>
>  > Would a simpler fix be just to add a len +=3D iter->iov_offset before =
the loop?
>
>  Great suggestion! I have tried it, and also fix the bug correctly.
>
>  io_uring/rsrc.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index a63474b331bf..41c89f5c616d 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1059,6 +1059,7 @@ static int io_import_kbuf(int ddir, struct iov_iter=
 *iter,
>         if (count < imu->len) {
>                 const struct bio_vec *bvec =3D iter->bvec;
>
> +               len +=3D iter->iov_offset;
>                 while (len > bvec->bv_len) {
>                         len -=3D bvec->bv_len;
>                         bvec++;
> --
> 2.43.0
>

