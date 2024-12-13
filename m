Return-Path: <io-uring+bounces-5469-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 006F39F0232
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 02:27:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F80F188D9CF
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 01:26:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 158B328F4;
	Fri, 13 Dec 2024 01:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M8YOTFjC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BAD3207;
	Fri, 13 Dec 2024 01:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734053156; cv=none; b=T1cSUi6hA9ae1RC9yVsnxXiop4IYhcuz/dIr/Uky6LcciOQtkbWom4JgRvfp2SEn+UNG1Q2rPLm8xvi5AjAcQDDs20p9ClKE5HkltiD25xPfinIUVcEbJuPGxrapK23wHqmAScSfE34la78q9Buw+Zf7FnwUwGtfTx0YXhsRm9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734053156; c=relaxed/simple;
	bh=36+hyo8E7/bTrbZUsL32Ov0FzUtobTilF0JqpSmFqS4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bV76ZKg9G14WEH9V3VBMxFMnLWc6VcZXXtlExlEwHxRRU18toz1UzNami1F9RtOWTlao8s1bEFNQpFrQ4ztIOFE++NwpgQpbY0LXcUL7PumDpPGOfeI3yeBZ+LM0PtNORrSgoGfOCI+6o09QmfxDJx0J3udC3cfnaqSfJT2vOgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M8YOTFjC; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-467a0a6c9fcso13801591cf.3;
        Thu, 12 Dec 2024 17:25:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734053153; x=1734657953; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AhM3pKOvhoJc2jUykt/At9pinZVU/s2F0Ck8adpcPOQ=;
        b=M8YOTFjCPT7snymtchPLu3krwlLm5yN/kZOhUrLtLA61XkR3KTrgv1H2CAfsDHFoAj
         Fn0OVT8yoxrFh6YWAReYYgmhyzsSjJhsNaUs6wQrQNG73jjao22TaSGBGduL3LsBOX9t
         7g1m/JvcMmATlu/elg9Fmphie/qE6f8IBu9c+s4nwK+8c90p/uV/j/mebmAJwhQpkYhZ
         1qkoOYzo546QJZmT0LEKOomJV1bICsF/k0YH/Sb20lOOsoMoUB590kv35ffUCPWVhs6i
         Lj3cJLtKRbddQ/fa8PnIX089ENEUEV7vxeZXgmX3/zLFhxJSeyVedXnny2ihRu0eoxCD
         VUnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734053153; x=1734657953;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AhM3pKOvhoJc2jUykt/At9pinZVU/s2F0Ck8adpcPOQ=;
        b=aJesfkphMsXkxF6AxeWMYIhdhw80RTSvUhwO0vEV9t2cmKROyY/XQOItbXFxJReMjT
         rxGabtZGqiWqSLxLX2YKlLNxPifsbWEyeMiocz0Jt7RGVz+I2GtaLtV1FHYYDw78+gF/
         QPbda+4XCxFXzlwd9qwwMRVjUsAd2NjgXeINS4Iy09+A4H1nHHn5oMkdipDf0NV+C9bC
         vEo/kv2GE1RaA8GT1mwAnwF5k+zhejWx0pEOCywXma+5s/ty3XWb+CvE4c6gGuGD/0cX
         DC9Fs+6C3ReD62ETFxPWacXDBgTXYFjRdyXqjt4IL+qUzPZ5E4jojpYrUfDkOapY2MZi
         y1nQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMMxA6cjRxZnuwA1+yKRIKwfl47AY2kOjISVcpEhjrPU+hXNMUPY0cTAXXEkHGHvNW+tD88WvOugUR7xkDjw==@vger.kernel.org, AJvYcCWzWBzzXuGirs3VM+Ycv8Dx7aB0Lfuyl9/KUMn/VZC8rdrXfrQ1UyLrnAzLUK0KhL+9jq3Z2ujwPw==@vger.kernel.org
X-Gm-Message-State: AOJu0YymAxft1Jz1TiUKesRxPDHRSFO+zxdGFcItc8TvXD1WlQhax2mr
	wuYw1BvKm6xsjawlv5AHxR9J5MewIYGbCkwruNU0nLCKADm72rQRn15tzqBDbohBJO/qe9CAojA
	wXVSt+yigg6Q7cc28IuT/mrkwYDAEiw==
X-Gm-Gg: ASbGnct0u5UjmcMGAk5me7K+dml4GIVYv722fCn+l75RKZw7TR0Zk9GezNr1IUdH12Q
	rfM2EcLdqjmHx7W/BwvD9XytpxRNzISxd9Fhk9avUfncNrv+J5s2T
X-Google-Smtp-Source: AGHT+IHMnf/+WRlyUXlo9mUiuXys0UXRPitaaUIgClmOMicF13k05oEDwxInicWRujAtpQhajo1SyQKwGeyblBrPliU=
X-Received: by 2002:a05:622a:c1:b0:467:7cda:935d with SMTP id
 d75a77b69052e-467a57102b5mr13332371cf.9.1734053153278; Thu, 12 Dec 2024
 17:25:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com> <20241209-fuse-uring-for-6-10-rfc4-v8-8-d9f9f2642be3@ddn.com>
In-Reply-To: <20241209-fuse-uring-for-6-10-rfc4-v8-8-d9f9f2642be3@ddn.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 12 Dec 2024 17:25:42 -0800
Message-ID: <CAJnrk1Z402vts+FB76wXPWr0q4h59z7yXga_JCQ3nOOwU8UBjg@mail.gmail.com>
Subject: Re: [PATCH v8 08/16] fuse: Add fuse-io-uring handling into fuse_copy
To: Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>, 
	bernd@bsbernd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 9, 2024 at 6:57=E2=80=AFAM Bernd Schubert <bschubert@ddn.com> w=
rote:
>
> Add special fuse-io-uring into the fuse argument
> copy handler.
>
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> ---
>  fs/fuse/dev.c        | 12 +++++++++++-
>  fs/fuse/fuse_dev_i.h |  5 +++++
>  2 files changed, 16 insertions(+), 1 deletion(-)
>
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 6ee7e28a84c80a3e7c8dc933986c0388371ff6cd..2ba153054f7ba61a870c847cb=
87d81168220661f 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -786,6 +786,9 @@ static int fuse_copy_do(struct fuse_copy_state *cs, v=
oid **val, unsigned *size)
>         *size -=3D ncpy;
>         cs->len -=3D ncpy;
>         cs->offset +=3D ncpy;
> +       if (cs->is_uring)
> +               cs->ring.offset +=3D ncpy;
> +
>         return ncpy;
>  }
>
> @@ -1922,7 +1925,14 @@ static struct fuse_req *request_find(struct fuse_p=
queue *fpq, u64 unique)
>  int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *arg=
s,
>                        unsigned nbytes)
>  {
> -       unsigned reqsize =3D sizeof(struct fuse_out_header);
> +
> +       unsigned int reqsize =3D 0;
> +
> +       /*
> +        * Uring has all headers separated from args - args is payload on=
ly
> +        */
> +       if (!cs->is_uring)
> +               reqsize =3D sizeof(struct fuse_out_header);
>
>         reqsize +=3D fuse_len_args(args->out_numargs, args->out_args);
>
> diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
> index 21eb1bdb492d04f0a406d25bb8d300b34244dce2..0708730b656b97071de9a5331=
ef4d51a112c602c 100644
> --- a/fs/fuse/fuse_dev_i.h
> +++ b/fs/fuse/fuse_dev_i.h
> @@ -27,6 +27,11 @@ struct fuse_copy_state {
>         unsigned int len;
>         unsigned int offset;
>         unsigned int move_pages:1;
> +       unsigned int is_uring:1;
> +       struct {
> +               /* overall offset with the user buffer */
> +               unsigned int offset;
> +       } ring;

I find it a bit unintuitive that this is named offset when it's used
only to keep track of the payload size. Maybe this should be renamed?


Thanks,
Joanne


>  };
>
>  static inline struct fuse_dev *fuse_get_dev(struct file *file)
>
> --
> 2.43.0
>

