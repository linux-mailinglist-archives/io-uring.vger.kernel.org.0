Return-Path: <io-uring+bounces-5814-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7A46A09DA9
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 23:19:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DED09168056
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 22:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D416215F46;
	Fri, 10 Jan 2025 22:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BjPZUKvp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E152E215F5A;
	Fri, 10 Jan 2025 22:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736547544; cv=none; b=ovfJT9qcXnkyruSKVpkyfRohZv4vFYZpi/8YerTGq9Fxv6gaZKbDTL8GP/6e+7a12tiAZTA/dj3ARFQhRjPTVpRxrVQdXgav7jpTnAJBUd5R4Z0PhDHHMJMuVUuCL5YEgYdQneNUmF5cnSYYkfAaVL7FjT8EinRrIczr5vLA0G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736547544; c=relaxed/simple;
	bh=08D2rBWWjfluCKhbnE/2W6TJ+/eUfAZjelNyKFyFSmI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZA1v8zeL7E72uJWoOpHFMGg/rXbr/G6bOgPwvneNNQ19vUyg4PqwftehxLHY9AlcMriBDoJT02FArluJGeG9xewOtB266x8lcXLaFySxCVgfIMkFC4YVXT9bOHdZIBq5BQLe7Nm0PHe9KvUjx4dVOGQE8GsnE5S2hSpYq/3k9Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BjPZUKvp; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-467a37a2a53so28578491cf.2;
        Fri, 10 Jan 2025 14:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736547542; x=1737152342; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4hJCNkZdVqe87O3O38D3vS2ZKezMZSTJAjERIFDD6qg=;
        b=BjPZUKvp7Wyu+aqQ35ZfN7/3sKRAQNtchox6FWcNl7Swf1uM/XV4HaeU78Rv/+E4WP
         Fws9W1iJfPufzYhuIrkRqh3xnnHFeqdKHR+hZGYRm3gMAnS76TbV6g5UPElgsnIz+OVG
         +NKxK0pvPxfZfvQurCVkEbtV/OBUI6k4VLPR7MM79tmhunB5QSkGL7Gb23BdVB+BGC87
         VBjp6odgrXL7qdIfOx8aG3dSpsQMS6Vbm5hOl2chOZH5/E+AsXlYKZs1YQarL3X3oEWk
         3R0xXKxar9EE49a2dmbd5ruWO0kW5aw7sLZ5tqE0nig4RLBtqMaQp6rHBVZbshNuexlH
         Ucsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736547542; x=1737152342;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4hJCNkZdVqe87O3O38D3vS2ZKezMZSTJAjERIFDD6qg=;
        b=Hl1aymgM4PtG+4qvdqoC/xveLsUbJVu8C9ttq1xuiti9pstQo/DfVf/A9BAt7/0eNu
         m0GagOSGAN6ydtj2fspmi5HF3MBFuSCxAZ1VEpfrqPOoiu23gNIFeuQ+0kEnWW+ubMAN
         U1cQQE8iPBZ39XD4Yw7/WM2vu0Jl5MCivl5TfjxBH/VMAmnmiWZ6iFM4PWSY+a6GyyXl
         +GRpSIo00stdgc2PrzjFJp+FaOJ9Mr4n4hQFafoJoVQfkNPVLIZdInYLe4oU8qMfYs61
         Kok6UP+dqZWz/bAGF2rvXstdyWW4U8msh7nfiBsFeIJEZ2DIfZ/WkIJoUryA+1Bmd/iG
         CAiQ==
X-Forwarded-Encrypted: i=1; AJvYcCUw8ADEnKWvnktiP6iLj/KIDn5NJNMh4Gh/cKSGaWh2URIloxVkEqbxfXNOZtT/vwwj5NuE0XEz4pQESVd5/Q==@vger.kernel.org, AJvYcCWunRmRVcqeLJ1yd8I8Jt8dxLMH6OgAIKVLBVh4pWaq2RJpssdBaGGZVpUdsTfGU5lD/qoXrMjJgQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzSuQyL1X78fmYXBybQjFCBlmoc/JQAWmhufoh+6rPFLbHx/Hhz
	4ZciYXQiVhpHZZSSoPt7bKA/mV5OyR7M+hT7jwVYNISJtMrADkI+EmXDt7NZL4SykiV2ckxvV7M
	cqzTJGFoR4cHk08G3PE0EtVrBpLQ=
X-Gm-Gg: ASbGncuGXMttSnAhSMCS+yniBNgFHX6INByDp05spWjXIBNifxbO56vU9o/X4I75mrf
	eezRS9L3h8kT6UuRl4dC8f5M93GVskAkvAuIY9h93b9IUKUVDhvN3hg==
X-Google-Smtp-Source: AGHT+IHGBLsQr0hgX7l7qQwObUfam+daY2Aq2HPy1YIj01o1e6R8FuqqXgdLdTdZg09JXse0T8zzqQtF2d/mrEetPg4=
X-Received: by 2002:a05:622a:1a19:b0:467:6e45:2177 with SMTP id
 d75a77b69052e-46c70ffed13mr180414441cf.12.1736547541841; Fri, 10 Jan 2025
 14:19:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com> <20250107-fuse-uring-for-6-10-rfc4-v9-8-9c786f9a7a9d@ddn.com>
In-Reply-To: <20250107-fuse-uring-for-6-10-rfc4-v9-8-9c786f9a7a9d@ddn.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 10 Jan 2025 14:18:50 -0800
X-Gm-Features: AbW1kvavO3d5iLS8zkFkzDdj_WquwbNCyPnEsHzu8qmkIxiSwrTU_V-AlqkW50o
Message-ID: <CAJnrk1auxGHU3ZLac93y7NoLHLGo9V=C7K47naF2-+0oBkJ_kA@mail.gmail.com>
Subject: Re: [PATCH v9 08/17] fuse: Add fuse-io-uring handling into fuse_copy
To: Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>, 
	bernd@bsbernd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 6, 2025 at 4:25=E2=80=AFPM Bernd Schubert <bschubert@ddn.com> w=
rote:
>
> Add special fuse-io-uring into the fuse argument
> copy handler.
>
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>

> ---
>  fs/fuse/dev.c        | 12 +++++++++++-
>  fs/fuse/fuse_dev_i.h |  4 ++++
>  2 files changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 6ee7e28a84c80a3e7c8dc933986c0388371ff6cd..8b03a540e151daa1f62986aa7=
9030e9e7a456059 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -786,6 +786,9 @@ static int fuse_copy_do(struct fuse_copy_state *cs, v=
oid **val, unsigned *size)
>         *size -=3D ncpy;
>         cs->len -=3D ncpy;
>         cs->offset +=3D ncpy;
> +       if (cs->is_uring)
> +               cs->ring.copied_sz +=3D ncpy;
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
> index 21eb1bdb492d04f0a406d25bb8d300b34244dce2..4a8a4feb2df53fb84938a6711=
e6bcfd0f1b9f615 100644
> --- a/fs/fuse/fuse_dev_i.h
> +++ b/fs/fuse/fuse_dev_i.h
> @@ -27,6 +27,10 @@ struct fuse_copy_state {
>         unsigned int len;
>         unsigned int offset;
>         unsigned int move_pages:1;
> +       unsigned int is_uring:1;
> +       struct {
> +               unsigned int copied_sz; /* copied size into the user buff=
er */
> +       } ring;
>  };
>
>  static inline struct fuse_dev *fuse_get_dev(struct file *file)
>
> --
> 2.43.0
>

