Return-Path: <io-uring+bounces-7241-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 954EBA705E9
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 17:02:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C8DB174480
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 16:00:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6E221BD9C8;
	Tue, 25 Mar 2025 16:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="I6yK9QT9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23405383
	for <io-uring@vger.kernel.org>; Tue, 25 Mar 2025 16:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742918438; cv=none; b=sWIKRXwozHyOUQHutp5S676UVQNZTKrN3nvHF52YKQAXtcN50YmbfJbung+kdCfVxTd760MTNGw8h2NVmRqGwaSrTCCfDYg3QodtPaA49ULhx5It9cx2vRhKGFREOippXvD9exCRsS4DCALGc6NqsjsIYaIoZMY4SIZuIEDX7uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742918438; c=relaxed/simple;
	bh=IDF9HN+RfFN8dVWLgUwgQZHC4PKcqeuKgqsDtgx509s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gnsXD6ZR+Y75EI5SWwLStY8Qw/KkiGQkhcmnj1QOIM48rnykzreAnSOPLgEhrcyPuQCnWwKhRD8xAPc3e0Bz1aELi+dFSEcU2Ws/ALx91l565NtfGr1FuWs4Zwu6Kz1OexbHx4IAlsTyWJgk/Xsi4BWjQaoKMMRGuJ94620MoGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=I6yK9QT9; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-301b4f97cc1so1749786a91.2
        for <io-uring@vger.kernel.org>; Tue, 25 Mar 2025 09:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1742918436; x=1743523236; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UgNQwt74lrSHTiF2S7NUPhRJQPfshYsGcQVo3k9jPR4=;
        b=I6yK9QT9H6PNnbCP7SKbCXTFBDXrS1gioUDx1sznQDxX2uP8KYgm0h89nxTv5MC+Vf
         +UKyGnYkuVquDKdPZoVXvEpQuqXpSijmfZs91VJtgWb3bQ3fZgmBdeK8TCF44RE6l9iC
         8jAQ0j+MxgU/UEuSm9HnolJJ/VYGM115EUXSz6gi8EPVdsdFQYQw9gmfRJM4+OuhKI2G
         SV+ktNibrN688cMyqJM1mxyNhUFp2iOiAmO2zOzYnHGesPBm+gYVEMLkKgxZQpCqIJRj
         sXY7fMqMIVDoI1LxdirmH8h7fPgaI2B18A198nNCzkbT9YK4qQIm3xwei2hd77Kfi5W7
         UTHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742918436; x=1743523236;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UgNQwt74lrSHTiF2S7NUPhRJQPfshYsGcQVo3k9jPR4=;
        b=MV9HCkfAAIY5aPgeXkRevuYvGKcHbn0aToKqKTK91nMk4RLTft838NkdsLeDzhyo0X
         yHnKL+JFZll2JbWkKHwbSHCIbKDY/ozXwKKF0HHG/Z/jC06+wwp5rEjgTYYANAnNWNwK
         CHxhQdrb7GJ/6OqmfCmZjB2CgLJTkipZcjV5eI9vIF3ciNnhWP4mDSaPf0GuzgQEHGix
         By+UV1qw7bWmOh3AKWv96Qw/0PaKXALQNYSIuZQ2RQfOf5rDEgnY9xpAl1Yr3+heSLo7
         yj9JbmBq4MWuj2vSwYeu7LvUD8tBQyqDRPI/tDYJKhvHRjpFPyOluibNysrkJn2pD0M/
         Bk0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUYv4zLziUTKAfUZMVxmwMZJLz1lWgCkb80Xm82E+YNDg5Vm9H3llp7ZEk7j7BNS4TQOuwM0jUggw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwMSGcE7MSGRTQ+hcFiMn5T5TIh4zXphE6Yy4Ih4cyAVNWhDPkg
	t0oFC6C5JRp7rfNHRo4n5cyR5lXMCJGKrhgiFsVSMTyNjkeKDbevnrkmwCdM8A/vPZzYM+SprYG
	OvbaE4STeXp1zfq9+MHFAcQa56X3jWzjDLrrs9g==
X-Gm-Gg: ASbGncvTTxBUERr9+wgEXvixXx9Wx3vr1OyGGvDP5n11o9IzozgFd4FZHTPhD6GVQnG
	o38+g7k6GeZes0ONtFmu3C2kVHuuNVviUfRkAMcdqmj/zsKZ01sFKEzjTAHSlaWFtjuq+ZyQEOo
	q5MJOjKNd7FlAWdHlVTwW9BfCK
X-Google-Smtp-Source: AGHT+IHoWPi+DWjUvGSSmqBV0OZalENxNOWa8HAi284bPtTCHxJWQUvJ+aeSD7FaBQtH//N97N0QrRyFEUI7WZ3A5b0=
X-Received: by 2002:a17:90b:1a8a:b0:2ff:5759:549a with SMTP id
 98e67ed59e1d1-3030fe534e1mr8650992a91.1.1742918435715; Tue, 25 Mar 2025
 09:00:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250325135155.935398-1-ming.lei@redhat.com> <20250325135155.935398-2-ming.lei@redhat.com>
In-Reply-To: <20250325135155.935398-2-ming.lei@redhat.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 25 Mar 2025 09:00:23 -0700
X-Gm-Features: AQ5f1JrUyLcNlMzGBprJGkafOkkB8FVpq7oBiaql7LpUsqB-Hb1zAO1Lyu2AxsU
Message-ID: <CADUfDZpesUAvHy0vLzdUk41Yk9w8rqCS82uR5T6NkzMUrkEY5A@mail.gmail.com>
Subject: Re: [PATCH 1/4] io_uring: add validate_fixed_range() for validate
 fixed buffer
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 25, 2025 at 6:52=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> Add helper of validate_fixed_range() for validating fixed buffer
> range.
>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  io_uring/rsrc.c | 34 +++++++++++++++++++++++-----------
>  1 file changed, 23 insertions(+), 11 deletions(-)
>
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 3f195e24777e..52e7492e863e 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1002,20 +1002,32 @@ int io_buffer_unregister_bvec(struct io_uring_cmd=
 *cmd, unsigned int index,
>  }
>  EXPORT_SYMBOL_GPL(io_buffer_unregister_bvec);
>
> -static int io_import_fixed(int ddir, struct iov_iter *iter,
> -                          struct io_mapped_ubuf *imu,
> -                          u64 buf_addr, size_t len)
> +static int validate_fixed_range(u64 buf_addr, size_t len,
> +               const struct io_mapped_ubuf *imu)
>  {
>         u64 buf_end;
> -       size_t offset;
>
> -       if (WARN_ON_ONCE(!imu))
> -               return -EFAULT;
>         if (unlikely(check_add_overflow(buf_addr, (u64)len, &buf_end)))
>                 return -EFAULT;
>         /* not inside the mapped region */
>         if (unlikely(buf_addr < imu->ubuf || buf_end > (imu->ubuf + imu->=
len)))
>                 return -EFAULT;
> +
> +       return 0;

It's nice to avoid this code duplication. It looks like
validate_fixed_range() could return a bool instead and leave the
return code up to the caller, but I don't feel strongly either way.

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>

> +}
> +
> +static int io_import_fixed(int ddir, struct iov_iter *iter,
> +                          struct io_mapped_ubuf *imu,
> +                          u64 buf_addr, size_t len)
> +{
> +       size_t offset;
> +       int ret;
> +
> +       if (WARN_ON_ONCE(!imu))
> +               return -EFAULT;
> +       ret =3D validate_fixed_range(buf_addr, len, imu);
> +       if (ret)
> +               return ret;
>         if (!(imu->dir & (1 << ddir)))
>                 return -EFAULT;
>
> @@ -1305,12 +1317,12 @@ static int io_vec_fill_bvec(int ddir, struct iov_=
iter *iter,
>                 u64 buf_addr =3D (u64)(uintptr_t)iovec[iov_idx].iov_base;
>                 struct bio_vec *src_bvec;
>                 size_t offset;
> -               u64 buf_end;
> +               int ret;
> +
> +               ret =3D validate_fixed_range(buf_addr, iov_len, imu);
> +               if (unlikely(ret))
> +                       return ret;
>
> -               if (unlikely(check_add_overflow(buf_addr, (u64)iov_len, &=
buf_end)))
> -                       return -EFAULT;
> -               if (unlikely(buf_addr < imu->ubuf || buf_end > (imu->ubuf=
 + imu->len)))
> -                       return -EFAULT;
>                 if (unlikely(!iov_len))
>                         return -EFAULT;
>                 if (unlikely(check_add_overflow(total_len, iov_len, &tota=
l_len)))
> --
> 2.47.0
>

