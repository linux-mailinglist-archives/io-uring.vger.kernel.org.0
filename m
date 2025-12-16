Return-Path: <io-uring+bounces-11054-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 90637CC05F7
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 01:50:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 444EE3015D20
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 00:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53F3916D9C2;
	Tue, 16 Dec 2025 00:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R1+j9jID"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB8F82866
	for <io-uring@vger.kernel.org>; Tue, 16 Dec 2025 00:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765846243; cv=none; b=jcy+nnxj9Iu59nuU+2C+H7+KBRKinaG6hU98GUoxEqsqSZr0/v2xlxvROg/gzakCNLt33wJx8niJH1w8UFyWRUlnMpesaJjSiNsg+DM+T/f+nflQneBCtXc7CsMo7yp8yONi1VWU14qGk+HhZRPcNrHEwRh/8QZqoDid5x4aAs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765846243; c=relaxed/simple;
	bh=jYmv6ZPUkq8rtr2BpdYQTerhCNxvH926lEM4yLQq1rg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YOJIt0DIU30akI9K2/xHvhwBDe++cfUyDKRXu7IbIjRSdPM79XvyMpm3qaDsaM2NKWfSJJZhBzipnFmbyW9nijTOEfaO99ijtdHO0DFGO3NvDxyRlpNckAtGyy4OhR1uttmV0AqVuKD2PbnEjFpfVrGPlaRoqrOyhrMWjoxOO3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R1+j9jID; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ee19b1fe5dso43359061cf.0
        for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 16:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765846240; x=1766451040; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rSe7ZYBrISjyohPsnZNA+IZPnCMaR2aLOnWgQ/y1+sc=;
        b=R1+j9jIDjZV6M8Y+oCPa/5JrwW+ajflMOzQL4QhOpLuS3+jivR3llb0ECRkVXPmXKb
         QieEcB32H7H0+HNkL2pnc7fx67aUAwdun96ZaZxEvqG9DejldQmPZe8hPkRWL2F8CoXy
         p5GFS0k9+ukYXb73TBneZLgnXGLXhAR0G4DCZsCUad0hWlm7fSbjxAJpmM6K67KRgOM4
         pCdKUeyDo/r8d9juwd9AaREPwz6WD1wsfsWDI2mU9gp1M8B5rVXFKrc2cx7Qq1w2DxWi
         RcNKjgDH21NzDOCqHOjLCKGHZbcp395AQ4Wl0Dv3rMdKtpNwCA5eEmn+o5o7kyGgkTbW
         L73Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765846240; x=1766451040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rSe7ZYBrISjyohPsnZNA+IZPnCMaR2aLOnWgQ/y1+sc=;
        b=c4vSz0jvszmDNPb/U8WGskNyn9qdadkpncV59gcHTBQww42TmA8dL1zz2HPmqsTgUc
         xKbvOrFnh+MXVFJeGDucYdMD5HAPQHIUrndMCzOcKRP2w/Zd4BnNs6d76sj0UaCgVpbo
         JDrKKvfIVAb95jQCQd7nCi39Yh4die5jcbKiwhbJNiNQp/0IVrL2ZhObO6dYDc4AV/7L
         6q4PFvvsINHf/CJ6ChlHPhDNnjfq7cbgf/YZ41oqqUjAWRp6s8nYsh9Ck/mGIqolmVlf
         robNFU7y0qILPK+T8R1VgcVStQdCJsnRIqoY8IVol3Yc94h0ScwFR8smYs2pytssc+OZ
         OGxg==
X-Forwarded-Encrypted: i=1; AJvYcCWrz6pWGHcMGS9ovbC6RJDYibVHKu9hLGNI5nhQhPgzRKjfEVNuCUaeeVYcLSBE8nYtdrSwA/4DBQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxXkA7i4t4sWuIodq5AyDtTBUiqQmjF0MdEf2mrXq+F5z/YtBZq
	4jNc8pFsq+na2SJqQlsaldcixLtlfi++7WiZ//iUrULPdZfnZ16sxxAc6zOKOV05HTX2Y44dkck
	twVXU2QDcY7qxiHHFsLPhb6S0xV4wVp8=
X-Gm-Gg: AY/fxX73GBQegmN7vGCw/cKgdHdixdRgt69ofJbcc3mgGzIj0RDnzuB+iESmj6hslEf
	PQi2LZgX9OkvyHndrAW8gCET4m3fUQX3gy8dZesnAbbrwHa03DhThkGWrHaGpVFX6dxZdzPCPe7
	y43IeG9oQtFKQm4gSvkruvvIjhW0inRTzoANHbwFNNffuyRdES/S5kWtH+tBZCQTr0qjPX+qXqT
	dpGGO0kSTnA2TkwbuxpUWqjSwqN8tS5CfpRBR5wOphQrVV6EbUaiERnpAvgKYKHt5qSCI/iV1+9
	wBgCh2gFYfQ=
X-Google-Smtp-Source: AGHT+IHhYwSbMKBO+qW36+prD31N/Bm/RB6rv4alnSv8OX0C+0WHg+WNEo8inWwYXAxcBy4QS1LTArH2czhlAYmcsSU=
X-Received: by 2002:a05:622a:48b:b0:4ed:659e:efb4 with SMTP id
 d75a77b69052e-4f1d059e64emr184619281cf.46.1765846240474; Mon, 15 Dec 2025
 16:50:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215200909.3505001-1-csander@purestorage.com> <20251215200909.3505001-3-csander@purestorage.com>
In-Reply-To: <20251215200909.3505001-3-csander@purestorage.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 16 Dec 2025 08:50:29 +0800
X-Gm-Features: AQt7F2rLwTPtoiq7tfiE7pHxoHBNJCGVz7m79v47unY-v44VO9Ow4Vb4AhS_fBY
Message-ID: <CAJnrk1YiZ6NuUavG86ZGpZ0nz8+fqi_SYkqx=UQWdWhTPj7mWQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/6] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SETUP_SQPOLL
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 4:10=E2=80=AFAM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> IORING_SETUP_SINGLE_ISSUER doesn't currently enable any optimizations,
> but it will soon be used to avoid taking io_ring_ctx's uring_lock when
> submitting from the single issuer task. If the IORING_SETUP_SQPOLL flag
> is set, the SQ thread is the sole task issuing SQEs. However, other
> tasks may make io_uring_register() syscalls, which must be synchronized
> with SQE submission. So it wouldn't be safe to skip the uring_lock
> around the SQ thread's submission even if IORING_SETUP_SINGLE_ISSUER is
> set. Therefore, clear IORING_SETUP_SINGLE_ISSUER from the io_ring_ctx
> flags if IORING_SETUP_SQPOLL is set.

If i'm understanding this correctly, these params are set by the user
and passed through the "struct io_uring_params" arg to the
io_uring_setup() syscall. Do you think it makes sense to return
-EINVAL if the user sets both IORING_SETUP_SQPOLL and
IORING_SETUP_SINGLE_ISSUER? That seems clearer to me than silently
unsetting IORING_SETUP_SINGLE_ISSUER where the user may set
IORING_SETUP_SINGLE_ISSUER expecting certain optimizations but be
unaware that IORING_SETUP_SQPOLL effectively overrides it.

Thanks,
Joanne

>
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> ---
>  io_uring/io_uring.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 761b9612c5b6..44ff5756b328 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3478,10 +3478,19 @@ static int io_uring_sanitise_params(struct io_uri=
ng_params *p)
>          */
>         if ((flags & (IORING_SETUP_SQE128|IORING_SETUP_SQE_MIXED)) =3D=3D
>             (IORING_SETUP_SQE128|IORING_SETUP_SQE_MIXED))
>                 return -EINVAL;
>
> +       /*
> +        * If IORING_SETUP_SQPOLL is set, only the SQ thread issues SQEs,
> +        * but other threads may call io_uring_register() concurrently.
> +        * We still need ctx uring lock to synchronize these io_ring_ctx
> +        * accesses, so disable the single issuer optimizations.
> +        */
> +       if (flags & IORING_SETUP_SQPOLL)
> +               p->flags &=3D ~IORING_SETUP_SINGLE_ISSUER;
> +
>         return 0;
>  }
>
>  static int io_uring_fill_params(struct io_uring_params *p)
>  {
> --
> 2.45.2
>

