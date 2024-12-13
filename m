Return-Path: <io-uring+bounces-5468-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 33D8D9F0143
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 01:50:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F2DC164261
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 00:50:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAFB710F7;
	Fri, 13 Dec 2024 00:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IH/X/zEB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2296A747F;
	Fri, 13 Dec 2024 00:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734051047; cv=none; b=R6GBXwrF0Ovb8ycml1i76CnB383Ju45reFcxRgS2CSBVkstcmKmhASA5CgdYk/MJJdSFJqH6StyAm9LHoe34eGp6ZdeRv+2HXinWGHTfG+6LQbqvbOYLUtoEHXfyJ4kQE5SZCF5GLRtPNXUATKTtmykWaWTSZNQmdxYln8ykrOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734051047; c=relaxed/simple;
	bh=cJfP4oTPGRXkOOs7yEd4gNxiaa9Ihzq0VeYBMfE5B0w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nmcGXdacIkiqLS1IvXjFQ2PJw8rVdPo1EJ7WKdg2uz7VonqLsHvzMMfmoAf3G85BcACQWWU+CjJUMbRs8W2ypgXoL4zRPvsGscmqvFOvYs2VZKlUrImsLImKTyLRiLIzSQNFNJdsjJbaJowNuwDDgHEDQCRq9mkgsb7S/DCbpl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IH/X/zEB; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-467a3c85e11so2440511cf.2;
        Thu, 12 Dec 2024 16:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734051045; x=1734655845; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N8hSZHekOiWK2NeFOntD0lxPB7WvdEmJsYXfkSStFiI=;
        b=IH/X/zEB6l7t8m6sGmj91PduqRVfUz6CDgYqTF4az4t+a06x4cKekko8Vdmd7DS/OO
         /bNuelW/yb+0XSJHQK5aRvKJc1GkhZojepgtBu4VFDHoUoNoJR8kB3R+rExaGuP3Hb1d
         4BmxqhyZ8qPzeCI7ul3flHCc/krOh8+TWYqbaIo1KZzL4Yo2iJtJ+xsdQpTlBUZYLysw
         nujibFji0xFjdflTxErY3Fvm96TkUN53r/rKYAceiIGi6w+FYSEKr6UXNQ2Fu4lmvdce
         g1dLp1M5nI87hsGe+JXrpFPRWJzyaaU3x7FgvPTKsjXaH08zOlEod7R7wuRe4TCITZtJ
         oCWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734051045; x=1734655845;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N8hSZHekOiWK2NeFOntD0lxPB7WvdEmJsYXfkSStFiI=;
        b=s7z/g2vn/T1eyZjO2rAshSl/DDvw0oaKAXVe8z57Gl0z4Iq7PXYAbZs9klXHnCBJ5Q
         WRz2QD5fkq/w3BmtiQSRcKvVhOkInydTRxZwdLPCgTpXzhyZtbkYNbEW904JH1Izx2Ar
         lFeA3XFWe222VMHAE7me2MAg6lQMDYzIdS43NgQc//j0DZVDWa4a81tsg9Al746nn3An
         rfz/620I0cEgDfS//nSag5xo1qaT1q358RFl64jmi8C5+tCKDpeqCJ/OOZ6BVenwOThB
         GU5L8QZIpYThR4+mJyQ0fF934pvYFYmbSlus0IPtnyuIBfVONiitLqGhKZbI1rPfSV81
         uE8Q==
X-Forwarded-Encrypted: i=1; AJvYcCU09CiKfvmcRqg+vvWphah9hfQTGwNhgraJwTWx1ZUAXw0eTeZhYwRC2ESR91qPhFply6L+bV/6ww==@vger.kernel.org, AJvYcCVPKT9C/JvUdGPhOWPHa631Zn01V6KpRLhUiOZvMt93XBAY4MUGlbyEYR4DPgnu8BJrVGr+XggCADSzRjLKnQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy76+NtNuQuccle810eNmjQb0iPNbOyHxy2J2CDRgdHCmAhaLRV
	6M+KW6L7vT18c7nWy+ee/g1fmAVBk7/Cr6GMMiZNz9mZDgXrraYJudN113uhJI/nodc7cjlJ43L
	qGzzObKhEGMnAKraoCzJCiZwVg6o=
X-Gm-Gg: ASbGncvth2hSDvucsa9yAjCyRSsXuwsz/BLFC4woa5yx4igVTxIvZMeLHlz5++g29qZ
	TIVRwckTbm8/e8GiOjIGYUcu1s2qVvrCOTK3PnjoLc8fOZfRj9Eq2
X-Google-Smtp-Source: AGHT+IE5t4HZeiN8c6CzJnfHvJZw8TB0Kvpab4LLRJkvkrxG4jErrHRFxLnDOnkdyfhWXhQgP9txgbOsxkUwUACb8j8=
X-Received: by 2002:a05:622a:580f:b0:467:87f6:383 with SMTP id
 d75a77b69052e-467a585a7ffmr12409881cf.52.1734051044930; Thu, 12 Dec 2024
 16:50:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241209-fuse-uring-for-6-10-rfc4-v8-0-d9f9f2642be3@ddn.com> <20241209-fuse-uring-for-6-10-rfc4-v8-7-d9f9f2642be3@ddn.com>
In-Reply-To: <20241209-fuse-uring-for-6-10-rfc4-v8-7-d9f9f2642be3@ddn.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 12 Dec 2024 16:50:34 -0800
Message-ID: <CAJnrk1Y1=i1qhK_NBsdzX8Z10HxhXgb7eTYeBR9t--7PK5gRQQ@mail.gmail.com>
Subject: Re: [PATCH v8 07/16] fuse: Make fuse_copy non static
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
> Move 'struct fuse_copy_state' and fuse_copy_* functions
> to fuse_dev_i.h to make it available for fuse-io-uring.
> 'copy_out_args()' is renamed to 'fuse_copy_out_args'.
>
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>

LGTM.

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>

> ---
>  fs/fuse/dev.c        | 30 ++++++++----------------------
>  fs/fuse/fuse_dev_i.h | 25 +++++++++++++++++++++++++
>  2 files changed, 33 insertions(+), 22 deletions(-)
>
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 623c5a067c1841e8210b5b4e063e7b6690f1825a..6ee7e28a84c80a3e7c8dc9339=
86c0388371ff6cd 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -678,22 +678,8 @@ static int unlock_request(struct fuse_req *req)
>         return err;
>  }
>
> -struct fuse_copy_state {
> -       int write;
> -       struct fuse_req *req;
> -       struct iov_iter *iter;
> -       struct pipe_buffer *pipebufs;
> -       struct pipe_buffer *currbuf;
> -       struct pipe_inode_info *pipe;
> -       unsigned long nr_segs;
> -       struct page *pg;
> -       unsigned len;
> -       unsigned offset;
> -       unsigned move_pages:1;
> -};
> -
> -static void fuse_copy_init(struct fuse_copy_state *cs, int write,
> -                          struct iov_iter *iter)
> +void fuse_copy_init(struct fuse_copy_state *cs, int write,
> +                   struct iov_iter *iter)
>  {
>         memset(cs, 0, sizeof(*cs));
>         cs->write =3D write;
> @@ -1054,9 +1040,9 @@ static int fuse_copy_one(struct fuse_copy_state *cs=
, void *val, unsigned size)
>  }
>
>  /* Copy request arguments to/from userspace buffer */
> -static int fuse_copy_args(struct fuse_copy_state *cs, unsigned numargs,
> -                         unsigned argpages, struct fuse_arg *args,
> -                         int zeroing)
> +int fuse_copy_args(struct fuse_copy_state *cs, unsigned numargs,
> +                  unsigned argpages, struct fuse_arg *args,
> +                  int zeroing)
>  {
>         int err =3D 0;
>         unsigned i;
> @@ -1933,8 +1919,8 @@ static struct fuse_req *request_find(struct fuse_pq=
ueue *fpq, u64 unique)
>         return NULL;
>  }
>
> -static int copy_out_args(struct fuse_copy_state *cs, struct fuse_args *a=
rgs,
> -                        unsigned nbytes)
> +int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *arg=
s,
> +                      unsigned nbytes)
>  {
>         unsigned reqsize =3D sizeof(struct fuse_out_header);
>
> @@ -2036,7 +2022,7 @@ static ssize_t fuse_dev_do_write(struct fuse_dev *f=
ud,
>         if (oh.error)
>                 err =3D nbytes !=3D sizeof(oh) ? -EINVAL : 0;
>         else
> -               err =3D copy_out_args(cs, req->args, nbytes);
> +               err =3D fuse_copy_out_args(cs, req->args, nbytes);
>         fuse_copy_finish(cs);
>
>         spin_lock(&fpq->lock);
> diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
> index 08a7e88e002773fcd18c25a229c7aa6450831401..21eb1bdb492d04f0a406d25bb=
8d300b34244dce2 100644
> --- a/fs/fuse/fuse_dev_i.h
> +++ b/fs/fuse/fuse_dev_i.h
> @@ -12,6 +12,23 @@
>  #define FUSE_INT_REQ_BIT (1ULL << 0)
>  #define FUSE_REQ_ID_STEP (1ULL << 1)
>
> +struct fuse_arg;
> +struct fuse_args;
> +
> +struct fuse_copy_state {
> +       int write;
> +       struct fuse_req *req;
> +       struct iov_iter *iter;
> +       struct pipe_buffer *pipebufs;
> +       struct pipe_buffer *currbuf;
> +       struct pipe_inode_info *pipe;
> +       unsigned long nr_segs;
> +       struct page *pg;
> +       unsigned int len;
> +       unsigned int offset;
> +       unsigned int move_pages:1;
> +};
> +
>  static inline struct fuse_dev *fuse_get_dev(struct file *file)
>  {
>         /*
> @@ -23,5 +40,13 @@ static inline struct fuse_dev *fuse_get_dev(struct fil=
e *file)
>
>  void fuse_dev_end_requests(struct list_head *head);
>
> +void fuse_copy_init(struct fuse_copy_state *cs, int write,
> +                          struct iov_iter *iter);

nit: indentation of this line is misaligned

> +int fuse_copy_args(struct fuse_copy_state *cs, unsigned int numargs,
> +                  unsigned int argpages, struct fuse_arg *args,
> +                  int zeroing);
> +int fuse_copy_out_args(struct fuse_copy_state *cs, struct fuse_args *arg=
s,
> +                      unsigned int nbytes);
> +
>  #endif
>
>
> --
> 2.43.0
>

