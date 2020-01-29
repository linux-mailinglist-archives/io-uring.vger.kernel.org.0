Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D854D14D325
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 23:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbgA2Wi0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 17:38:26 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37795 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbgA2WiZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 17:38:25 -0500
Received: by mail-wm1-f68.google.com with SMTP id f129so1851679wmf.2
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2020 14:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=7osWCWNb8K+14NXV/kaHB64AxuR7v4vfSX68yqI4Xt4=;
        b=gMW0L3YnPsq831n8DIEw9Qz+oGTNipQxiY3kpopbaIejmPVCauxqEfKE352E6qMD2I
         9hgTUGb3vLuiwsP+mQSQErimKoyjYXOxa9XFHnXGYO1RpPSj7XIAxIRrCQySdGwAdJpO
         YJjaBhkac6Jqp0Ig1D1PmIEFnzme5HdiBybNAs6eL/1zlrTz54j5BO2XEJFaFmKAD6iy
         aV9WlxjLImSJKnvpW90bDTK7INwqQToHhZk/o9CBOoHSZFumyONlzcpYt/EbQeqB3QpN
         6+DOF2sKBGlm4EY42ynZmqYJY84MPsE5ewPZmpAF4Sm9rAdZpAd82as5+urURCjyho1K
         EkJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=7osWCWNb8K+14NXV/kaHB64AxuR7v4vfSX68yqI4Xt4=;
        b=IoBR7FkM1nKuYANFcIlI8p0FOYIcRAOb4EZL6xXp20FJa1hvrrrj7nxgfmjQNGMKnX
         9dgWdXozoWxu2WWbSsBUSHn5BTGUS/pMhNsE1Bh7ubkfSQdQmB4CZfscoaulPGOmFrg0
         1H/0N8zJeswZnVorVNs6hcwDnJ+XhTPS4B5r3ouCfHehb6CWNkkVDYOCywJY4bp2vJlK
         pqXAiR7E932H+n9Ac6o6QKk2SpbCgUGhgma3zA5riBRyVlwn4AxPGYO7sO8lZJPBPGR7
         hk8VN93BEmzsvCuH0Ns4ZZGgW/6+H6VbRF9CPKfartKlXOsaKrY1MzlQjxW69RJvj+/M
         Bpsw==
X-Gm-Message-State: APjAAAXEFuJEGNNYDfYaTFpXfje3WcP+9p8qi68VdbtQCL4b9tus2dUm
        48v0bsIm845eGmMbFzDfkEPiWfrp
X-Google-Smtp-Source: APXvYqzj4qDilDBVg1fuTZZYrRZHxSVkKULGBhpL1N2MsPOciY/YpRvv52Jq/8TB5OyoWYvVP1wpzQ==
X-Received: by 2002:a7b:c932:: with SMTP id h18mr1376423wml.171.1580337502221;
        Wed, 29 Jan 2020 14:38:22 -0800 (PST)
Received: from [192.168.43.140] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id c9sm3885484wmc.47.2020.01.29.14.38.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 14:38:21 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix linked command file table usage
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <c2d0d637-85db-3500-f1ae-335bc1fec6c8@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <4a826524-4f77-2126-03e9-802c3567f73f@gmail.com>
Date:   Thu, 30 Jan 2020 01:37:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <c2d0d637-85db-3500-f1ae-335bc1fec6c8@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2NEQ6h4YR7dyXV94aDexQrxNEDOiOkDi5"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2NEQ6h4YR7dyXV94aDexQrxNEDOiOkDi5
Content-Type: multipart/mixed; boundary="x9Y4zqy8M8C6VAzORlNj3YInhgetomCp5";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Message-ID: <4a826524-4f77-2126-03e9-802c3567f73f@gmail.com>
Subject: Re: [PATCH] io_uring: fix linked command file table usage
References: <c2d0d637-85db-3500-f1ae-335bc1fec6c8@kernel.dk>
In-Reply-To: <c2d0d637-85db-3500-f1ae-335bc1fec6c8@kernel.dk>

--x9Y4zqy8M8C6VAzORlNj3YInhgetomCp5
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

FYI, for-next

fs/io_uring.c: In function =E2=80=98io_epoll_ctl=E2=80=99:
fs/io_uring.c:2661:22: error: =E2=80=98IO_WQ_WORK_NEEDS_FILES=E2=80=99 un=
declared (first use in
this function)
 2661 |   req->work.flags |=3D IO_WQ_WORK_NEEDS_FILES;
      |                      ^~~~~~~~~~~~~~~~~~~~~~
fs/io_uring.c:2661:22: note: each undeclared identifier is reported only =
once
for each function it appears in
make[1]: *** [scripts/Makefile.build:266: fs/io_uring.o] Error 1
make: *** [Makefile:1693: fs] Error 2


On 29/01/2020 23:49, Jens Axboe wrote:
> We're not consistent in how the file table is grabbed and assigned if w=
e
> have a command linked that requires the use of it.
>=20
> Add ->file_table to the io_op_defs[] array, and use that to determine
> when to grab the table instead of having the handlers set it if they
> need to defer. This also means we can kill the IO_WQ_WORK_NEEDS_FILES
> flag. We always initialize work->files, so io-wq can just check for
> that.
>=20
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>=20
> ---
>=20
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index f7eb577ccd2d..cb60a42b9fdf 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -476,8 +476,7 @@ static void io_worker_handle_work(struct io_worker =
*worker)
>  		if (work->flags & IO_WQ_WORK_CB)
>  			work->func(&work);
> =20
> -		if ((work->flags & IO_WQ_WORK_NEEDS_FILES) &&
> -		    current->files !=3D work->files) {
> +		if (work->files && current->files !=3D work->files) {
>  			task_lock(current);
>  			current->files =3D work->files;
>  			task_unlock(current);
> diff --git a/fs/io-wq.h b/fs/io-wq.h
> index c42602c58c56..50b3378febf2 100644
> --- a/fs/io-wq.h
> +++ b/fs/io-wq.h
> @@ -7,7 +7,6 @@ enum {
>  	IO_WQ_WORK_CANCEL	=3D 1,
>  	IO_WQ_WORK_HAS_MM	=3D 2,
>  	IO_WQ_WORK_HASHED	=3D 4,
> -	IO_WQ_WORK_NEEDS_FILES	=3D 16,
>  	IO_WQ_WORK_UNBOUND	=3D 32,
>  	IO_WQ_WORK_INTERNAL	=3D 64,
>  	IO_WQ_WORK_CB		=3D 128,
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 8bcf0538e2e1..0d8d0e217847 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -603,6 +603,8 @@ struct io_op_def {
>  	unsigned		unbound_nonreg_file : 1;
>  	/* opcode is not supported by this kernel */
>  	unsigned		not_supported : 1;
> +	/* needs file table */
> +	unsigned		file_table : 1;
>  };
> =20
>  static const struct io_op_def io_op_defs[] =3D {
> @@ -661,6 +663,7 @@ static const struct io_op_def io_op_defs[] =3D {
>  		.needs_mm		=3D 1,
>  		.needs_file		=3D 1,
>  		.unbound_nonreg_file	=3D 1,
> +		.file_table		=3D 1,
>  	},
>  	[IORING_OP_ASYNC_CANCEL] =3D {},
>  	[IORING_OP_LINK_TIMEOUT] =3D {
> @@ -679,12 +682,15 @@ static const struct io_op_def io_op_defs[] =3D {
>  	[IORING_OP_OPENAT] =3D {
>  		.needs_file		=3D 1,
>  		.fd_non_neg		=3D 1,
> +		.file_table		=3D 1,
>  	},
>  	[IORING_OP_CLOSE] =3D {
>  		.needs_file		=3D 1,
> +		.file_table		=3D 1,
>  	},
>  	[IORING_OP_FILES_UPDATE] =3D {
>  		.needs_mm		=3D 1,
> +		.file_table		=3D 1,
>  	},
>  	[IORING_OP_STATX] =3D {
>  		.needs_mm		=3D 1,
> @@ -720,6 +726,7 @@ static const struct io_op_def io_op_defs[] =3D {
>  	[IORING_OP_OPENAT2] =3D {
>  		.needs_file		=3D 1,
>  		.fd_non_neg		=3D 1,
> +		.file_table		=3D 1,
>  	},
>  };
> =20
> @@ -732,6 +739,7 @@ static void io_queue_linked_timeout(struct io_kiocb=
 *req);
>  static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>  				 struct io_uring_files_update *ip,
>  				 unsigned nr_args);
> +static int io_grab_files(struct io_kiocb *req);
> =20
>  static struct kmem_cache *req_cachep;
> =20
> @@ -2568,10 +2576,8 @@ static int io_openat2(struct io_kiocb *req, stru=
ct io_kiocb **nxt,
>  	struct file *file;
>  	int ret;
> =20
> -	if (force_nonblock) {
> -		req->work.flags |=3D IO_WQ_WORK_NEEDS_FILES;
> +	if (force_nonblock)
>  		return -EAGAIN;
> -	}
> =20
>  	ret =3D build_open_flags(&req->open.how, &op);
>  	if (ret)
> @@ -2797,10 +2803,8 @@ static int io_close(struct io_kiocb *req, struct=
 io_kiocb **nxt,
>  		return ret;
> =20
>  	/* if the file has a flush method, be safe and punt to async */
> -	if (req->close.put_file->f_op->flush && !io_wq_current_is_worker()) {=

> -		req->work.flags |=3D IO_WQ_WORK_NEEDS_FILES;
> +	if (req->close.put_file->f_op->flush && !io_wq_current_is_worker())
>  		goto eagain;
> -	}
> =20
>  	/*
>  	 * No ->flush(), safely close from here and just punt the
> @@ -3244,7 +3248,6 @@ static int io_accept(struct io_kiocb *req, struct=
 io_kiocb **nxt,
>  	ret =3D __io_accept(req, nxt, force_nonblock);
>  	if (ret =3D=3D -EAGAIN && force_nonblock) {
>  		req->work.func =3D io_accept_finish;
> -		req->work.flags |=3D IO_WQ_WORK_NEEDS_FILES;
>  		io_put_req(req);
>  		return -EAGAIN;
>  	}
> @@ -3967,10 +3970,8 @@ static int io_files_update(struct io_kiocb *req,=
 bool force_nonblock)
>  	struct io_uring_files_update up;
>  	int ret;
> =20
> -	if (force_nonblock) {
> -		req->work.flags |=3D IO_WQ_WORK_NEEDS_FILES;
> +	if (force_nonblock)
>  		return -EAGAIN;
> -	}
> =20
>  	up.offset =3D req->files_update.offset;
>  	up.fds =3D req->files_update.arg;
> @@ -3991,6 +3992,12 @@ static int io_req_defer_prep(struct io_kiocb *re=
q,
>  {
>  	ssize_t ret =3D 0;
> =20
> +	if (io_op_defs[req->opcode].file_table) {
> +		ret =3D io_grab_files(req);
> +		if (unlikely(ret))
> +			return ret;
> +	}
> +
>  	io_req_work_grab_env(req, &io_op_defs[req->opcode]);
> =20
>  	switch (req->opcode) {
> @@ -4424,6 +4431,8 @@ static int io_grab_files(struct io_kiocb *req)
>  	int ret =3D -EBADF;
>  	struct io_ring_ctx *ctx =3D req->ctx;
> =20
> +	if (req->work.files)
> +		return 0;
>  	if (!ctx->ring_file)
>  		return -EBADF;
> =20
> @@ -4542,7 +4551,7 @@ static void __io_queue_sqe(struct io_kiocb *req, =
const struct io_uring_sqe *sqe)
>  	if (ret =3D=3D -EAGAIN && (!(req->flags & REQ_F_NOWAIT) ||
>  	    (req->flags & REQ_F_MUST_PUNT))) {
>  punt:
> -		if (req->work.flags & IO_WQ_WORK_NEEDS_FILES) {
> +		if (io_op_defs[req->opcode].file_table) {
>  			ret =3D io_grab_files(req);
>  			if (ret)
>  				goto err;
>=20

--=20
Pavel Begunkov


--x9Y4zqy8M8C6VAzORlNj3YInhgetomCp5--

--2NEQ6h4YR7dyXV94aDexQrxNEDOiOkDi5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4yCTkACgkQWt5b1Glr
+6WvJQ/8DgAlwlf519Q8u5/MkHTFchPJKzZWK30NYxbdSo6VDX1wZ4nEzBWkJ1Vj
/OTrYOpfGV+jp33rrf9JhSuzM2LMe4gA6+7kEguYT/DGaLYsErx26+Cc8ksos5xJ
iwgef4yLaHSif5FwDUPYsKNN3W8ATPn8jujRYc/L7BJ8g4r182Y8kyBmSGwarLB5
Iw0YvuVSkLbOqumSuznytlmhFz1U2eWAVrEaC4GWKWyQ3FYK1M+Ed6M5aH67PMir
LWVuKffe6yC0AfidrVcCxZ+spJp/PyQYDCmcKYMka5+PzaW5enPszR55Daw0lhFr
KDpXO09RepphzhEZMcvbNAUZnn0tD+FVGFNp0YK41we65m6yxvTdEbsbyKGGyeUu
2SFhk/fcKXVFfXE+J+LWuTweIP6s0PFl5hmIAGi45seJ+KIFXWzKA0YLERpwSIbY
LrJUhwR3qIsmesYqQlVY0aUqpfVxTDfmAflEbn9qhBleToAd8tZi4tmeUYiDyV5Q
TRmGKY40RewnRECCGep57va0gjOFwexdUiU+7pNG9oT/OWrQWA+cwJLWcvsQKplA
KBtzeZsiDFj0JcZC1R4GcZLMcJoOqzuI8LL7vRjYmTdL+MaPmm4yz3rsPGWqTWcn
FmlQLhJ1XF2QwY5gtO39gXwHUoAIv2Yref92k5AEi2TWg6coZAc=
=xoZz
-----END PGP SIGNATURE-----

--2NEQ6h4YR7dyXV94aDexQrxNEDOiOkDi5--
