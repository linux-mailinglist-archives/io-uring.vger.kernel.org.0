Return-Path: <io-uring+bounces-5105-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6CAD9DB037
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 01:19:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5AD79B22139
	for <lists+io-uring@lfdr.de>; Thu, 28 Nov 2024 00:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90B7D4A35;
	Thu, 28 Nov 2024 00:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hvh7o7Ic"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5B3A935;
	Thu, 28 Nov 2024 00:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732753172; cv=none; b=nH2kwyOVOzMC3c+SOLoKBSgoFmk0f5mpYZsqr7eaYmCm974IGIZiz8bCqHviquQdQL6ejM5UhzCRS/6CgVpCMz9ekYaGCR6OSHJGznlos14zLggdoMVNXRqyJOisUEJRWRF+BJ7v/Jf4oOX5Cy8bjphmagc13nRk4feH7aTEw2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732753172; c=relaxed/simple;
	bh=HlSTxNed9m4Q39gNcyPVC7WZOlpvCEyU1ZrCHZJiYhc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tX7pyuGkAkLxJOAyIu/4R0GHZjzMnnzywHkCgU4haiHzT4X67QkcVnTpfHN/s5JTIpIcGcUCAu8pQQeft3InnrY3hJdw0cSCbvfnfViDv9WYuG0imofCEYxl6i9WQY6IfGbgrfIErBUnBIwDp96kAPCA+kck0cKo6iHf4cCMDeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hvh7o7Ic; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4668f208f5fso2476181cf.0;
        Wed, 27 Nov 2024 16:19:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732753169; x=1733357969; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KvI8+Z6yxtZMlzQvuoKlEClGPgHwzd6xUpgtxwNOTDo=;
        b=Hvh7o7IchEtOCx8Y+gmkt1Vtf//847ogODcr24TWSRN938aoHVHuLuynZ2+LGFLmOj
         IDIloVQijTRv+jiR3fBj4frf36k0wAm42V1e05eLo17yWYIhpDNujvSv74cTDWyGbh6x
         uCEZWJaGWKI+fZPK8phqpfuZjJRLuf0KWjjA+oboG22r7NWzKyMjGKisCDOI890PVlnh
         SC23gMlTxyKBge4yo71sb34OVoFNX0CfyrqDkOrLnpLXVRssXKADXrTVkdeYJp9TGm4K
         ur5WOKx6zp9/3GFeLWrmL0ETtiF0YUSNiaGkAcLwr5+2jRFNa5wCnXHc4m9Sea9AZgbA
         DY0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732753169; x=1733357969;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KvI8+Z6yxtZMlzQvuoKlEClGPgHwzd6xUpgtxwNOTDo=;
        b=pJ0WE10sv+ly+JGirx5ELz9IwRFc9SjsCesN2m3+Cqll3Fmj1I65Tb5gM7iC677Mbc
         Z1IOJr383XxO2VCEV7l7dVmSN4ImGNrMT/jdZejDhF1KZnXajXp33pWfoUC5rz11DinZ
         fiQIkbhhHVTGcfFdnv4xd31JmQnQhGNiMXjNgLXp4Uhhp/xHxEwaLtFZirOtPA2c67gg
         UZqmT3ximxN6bblgp13bawkwQCcS4Xu6plegy8Tqhw96g3fBdHmMKbbZr1gSUW1gtlV4
         TRt1yPOv9wt+vYCJZG5oUQnHDtgBYR6qVxIPDMy2VOSb2w5zhWRIrAwoiAC/KWqpE3Pt
         hFbQ==
X-Forwarded-Encrypted: i=1; AJvYcCW/p/uHh8AsZ6nRPLZmALiORUzTTWeGErCRpDYVCwVNt1cDVQnyAwu2iJeoa4SQuHgL68ww4mz/NA==@vger.kernel.org, AJvYcCWT4Sl+x1dcNrLZ8ZTgYzVau8uoY39A9YoXNpOaSxOApL80Tr8wxRd2AkH0REDtkSJ6nynMo9vW+mOhXYvTJA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6o7hL3rWoZ4EpptQiz0DpFWYOQnWiSHhrJQQM/PehcNiskAkN
	vCWaCYJeCeX5Nsx44fX8pw1FGnRsZDcM47Zc8Ib0Fw69rygnlhQXErtkhMP2OtemLHyS6dsl1ev
	3P92PoXplrtDohMiPmpnVBM2ePnw=
X-Gm-Gg: ASbGnctHJeQwOi6etJLNbXBkDsr8Levb5YNGPd0uH3sNfGfs8SwHmGPTDByarLSMhfK
	h8GoN5HWq5Nmk80kQLcuCgndlmgOZANqjgvf8Na0iWpSDM7k=
X-Google-Smtp-Source: AGHT+IFnlTgnrcYW38HN35OhKME2+zudnPGxgqhAvM774mOQOMTM5VaA9MrrKw3v8OchEaE8UJS1mpyBaELszNIIoh0=
X-Received: by 2002:ac8:7f11:0:b0:466:a7d8:fd0c with SMTP id
 d75a77b69052e-466b354087bmr72790991cf.30.1732753168670; Wed, 27 Nov 2024
 16:19:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241127-fuse-uring-for-6-10-rfc4-v7-0-934b3a69baca@ddn.com> <20241127-fuse-uring-for-6-10-rfc4-v7-1-934b3a69baca@ddn.com>
In-Reply-To: <20241127-fuse-uring-for-6-10-rfc4-v7-1-934b3a69baca@ddn.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 27 Nov 2024 16:19:17 -0800
Message-ID: <CAJnrk1bdOKvVs3mngJgcCc1q9cJ-_93ZMnxY=PSj9wNc5noA-A@mail.gmail.com>
Subject: Re: [PATCH RFC v7 01/16] fuse: rename to fuse_dev_end_requests and
 make non-static
To: Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>, 
	bernd@bsbernd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2024 at 5:41=E2=80=AFAM Bernd Schubert <bschubert@ddn.com> =
wrote:
>
> This function is needed by fuse_uring.c to clean ring queues,
> so make it non static. Especially in non-static mode the function
> name 'end_requests' should be prefixed with fuse_
>
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>

> ---
>  fs/fuse/dev.c        | 11 +++++------
>  fs/fuse/fuse_dev_i.h | 14 ++++++++++++++
>  2 files changed, 19 insertions(+), 6 deletions(-)
>
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 1f64ae6d7a69e53c8d96f2e1f5caca3ff2b4ab26..09b73044a9b6748767d2479dd=
a0a09a97b8b4c0f 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -7,6 +7,7 @@
>  */
>
>  #include "fuse_i.h"
> +#include "fuse_dev_i.h"
>
>  #include <linux/init.h>
>  #include <linux/module.h>
> @@ -34,8 +35,6 @@ MODULE_ALIAS("devname:fuse");
>
>  static struct kmem_cache *fuse_req_cachep;
>
> -static void end_requests(struct list_head *head);
> -
>  static struct fuse_dev *fuse_get_dev(struct file *file)
>  {
>         /*
> @@ -1873,7 +1872,7 @@ static void fuse_resend(struct fuse_conn *fc)
>                 spin_unlock(&fiq->lock);
>                 list_for_each_entry(req, &to_queue, list)
>                         clear_bit(FR_PENDING, &req->flags);
> -               end_requests(&to_queue);
> +               fuse_dev_end_requests(&to_queue);
>                 return;
>         }
>         /* iq and pq requests are both oldest to newest */
> @@ -2192,7 +2191,7 @@ static __poll_t fuse_dev_poll(struct file *file, po=
ll_table *wait)
>  }
>
>  /* Abort all requests on the given list (pending or processing) */
> -static void end_requests(struct list_head *head)
> +void fuse_dev_end_requests(struct list_head *head)
>  {
>         while (!list_empty(head)) {
>                 struct fuse_req *req;
> @@ -2295,7 +2294,7 @@ void fuse_abort_conn(struct fuse_conn *fc)
>                 wake_up_all(&fc->blocked_waitq);
>                 spin_unlock(&fc->lock);
>
> -               end_requests(&to_end);
> +               fuse_dev_end_requests(&to_end);
>         } else {
>                 spin_unlock(&fc->lock);
>         }
> @@ -2325,7 +2324,7 @@ int fuse_dev_release(struct inode *inode, struct fi=
le *file)
>                         list_splice_init(&fpq->processing[i], &to_end);
>                 spin_unlock(&fpq->lock);
>
> -               end_requests(&to_end);
> +               fuse_dev_end_requests(&to_end);
>
>                 /* Are we the last open device? */
>                 if (atomic_dec_and_test(&fc->dev_count)) {
> diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
> new file mode 100644
> index 0000000000000000000000000000000000000000..4fcff2223fa60fbfb844a3f8e=
1252a523c4c01af
> --- /dev/null
> +++ b/fs/fuse/fuse_dev_i.h
> @@ -0,0 +1,14 @@
> +/* SPDX-License-Identifier: GPL-2.0
> + *
> + * FUSE: Filesystem in Userspace
> + * Copyright (C) 2001-2008  Miklos Szeredi <miklos@szeredi.hu>
> + */
> +#ifndef _FS_FUSE_DEV_I_H
> +#define _FS_FUSE_DEV_I_H
> +
> +#include <linux/types.h>
> +
> +void fuse_dev_end_requests(struct list_head *head);
> +
> +#endif
> +
>
> --
> 2.43.0
>

