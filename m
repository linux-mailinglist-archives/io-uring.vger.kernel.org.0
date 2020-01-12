Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC2413885C
	for <lists+io-uring@lfdr.de>; Sun, 12 Jan 2020 22:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbgALVkc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jan 2020 16:40:32 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:32835 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727222AbgALVkc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jan 2020 16:40:32 -0500
Received: by mail-lj1-f193.google.com with SMTP id y6so7887692lji.0;
        Sun, 12 Jan 2020 13:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=Jyl4d4zHXjE2fzyvfEeWIdPg0Qhn3KHMynJV0N+3WYU=;
        b=ZSe3IixKEAgrG7hyvrnHaC91mNXbJeKLlqhK7ohILkkyIRlwlq+bVIZfS8XlN7LrZ+
         hOWJTRgZ2GW//CgbsUna8RLTEobNJiD5OXx9ujkNG2FItxw/Ou4/Os1jVSAWXEXiNyn7
         YJXALmZHFhPEey3on5XddyoVUxj7RK5/sJd2/MICnMpe9CPtaY2k4iCKWXalcu2iH2in
         2IITkshRnthtMQgq4bAxo0B87LabnV1/q2727qWFka1OAbwwJ7PR0o327VHXJRH1NeG6
         hiDZLTdHxSj6KJvO3mcD4AInD5C6nwf2wC/t2NyN006AU6jOF4BXrbwVDeYFPWpibc9p
         iz8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=Jyl4d4zHXjE2fzyvfEeWIdPg0Qhn3KHMynJV0N+3WYU=;
        b=dXw1gpQ+vZe0XvW0eVmsNPBf7QjquiIAk1/p50Nz06dt4jVNxbLizV9kqyLOdQHAKo
         fNnvkHHVP0qEESM4s5Ktq0E/uybRyCNccI0fi2ubv3N/dIWgAws2o2C9AU4NJOPBzoUQ
         qLNXNosLTb1sEVz82HAsKc7QLm192aRuRodcKeaw4CSjJAtWOidmjSTU7yW++CkmYDb+
         NaBbHObbRzjP75wchBXWpyoOaqjR7uRRaJvfUOXv3oiqMuSt1JWG3VHoSZj7OEe36vce
         Ewp1okaeqM5rMKXLkBOwPRbbFHzzLedfyIZK1GtpYwu0NioSDAOd21JGwbk1aGrPX8LU
         nvEg==
X-Gm-Message-State: APjAAAWd2nun9j8rHmxfA/llc4Q1QDtdkAb254KBarbvAXHHNjbe3Pt5
        mnfbyTqaMsyrEY7bnHglelWZ0dxB
X-Google-Smtp-Source: APXvYqxxco/ezPHxDYaiyAgPOOOMkEsSBSVAT1MhpQInb2CmlvYfR2lVgbzIyCvs0xMAxg8PfGd9WQ==
X-Received: by 2002:a2e:88c5:: with SMTP id a5mr8900103ljk.201.1578865229080;
        Sun, 12 Jan 2020 13:40:29 -0800 (PST)
Received: from [192.168.43.115] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id z13sm4687427lfi.69.2020.01.12.13.40.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Jan 2020 13:40:28 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20200110154739.2119-1-axboe@kernel.dk>
 <20200110154739.2119-4-axboe@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 3/3] io_uring: add IORING_OP_MADVISE
Message-ID: <a9a6be4f-2d81-7634-a2f5-38341f718a7e@gmail.com>
Date:   Mon, 13 Jan 2020 00:39:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200110154739.2119-4-axboe@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TnaMNkjdr2jxx9mkkbIg3uf04PlhI8t8E"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TnaMNkjdr2jxx9mkkbIg3uf04PlhI8t8E
Content-Type: multipart/mixed; boundary="28z4doOrSDfZi7mZ8O7rPeprdWzFB7fqi";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Message-ID: <a9a6be4f-2d81-7634-a2f5-38341f718a7e@gmail.com>
Subject: Re: [PATCH 3/3] io_uring: add IORING_OP_MADVISE
References: <20200110154739.2119-1-axboe@kernel.dk>
 <20200110154739.2119-4-axboe@kernel.dk>
In-Reply-To: <20200110154739.2119-4-axboe@kernel.dk>

--28z4doOrSDfZi7mZ8O7rPeprdWzFB7fqi
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 10/01/2020 18:47, Jens Axboe wrote:
> This adds support for doing madvise(2) through io_uring. We assume that=

> any operation can block, and hence punt everything async. This could be=

> improved, but hard to make bullet proof. The async punt ensures it's
> safe.
>=20
I don't like that it share structs/fields names with fadvise. E.g. madvis=
e's
context is called struct io_fadvise. Could it at least have fadvise_advic=
e filed
in struct io_uring_sqe? io_uring parts of the patchset look good.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/io_uring.c                 | 56 ++++++++++++++++++++++++++++++++++-=

>  include/uapi/linux/io_uring.h |  1 +
>  2 files changed, 56 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 0b200a7d4ae0..378f97cc2bf2 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -403,7 +403,10 @@ struct io_files_update {
> =20
>  struct io_fadvise {
>  	struct file			*file;
> -	u64				offset;
> +	union {
> +		u64			offset;
> +		u64			addr;
> +	};
>  	u32				len;
>  	u32				advice;
>  };
> @@ -682,6 +685,10 @@ static const struct io_op_def io_op_defs[] =3D {
>  		/* IORING_OP_FADVISE */
>  		.needs_file		=3D 1,
>  	},
> +	{
> +		/* IORING_OP_MADVISE */
> +		.needs_mm		=3D 1,
> +	},
>  };
> =20
>  static void io_wq_submit_work(struct io_wq_work **workptr);
> @@ -2448,6 +2455,42 @@ static int io_openat(struct io_kiocb *req, struc=
t io_kiocb **nxt,
>  	return 0;
>  }
> =20
> +static int io_madvise_prep(struct io_kiocb *req, const struct io_uring=
_sqe *sqe)
> +{
> +#if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
> +	if (sqe->ioprio || sqe->buf_index || sqe->off)
> +		return -EINVAL;
> +
> +	req->fadvise.addr =3D READ_ONCE(sqe->addr);
> +	req->fadvise.len =3D READ_ONCE(sqe->len);
> +	req->fadvise.advice =3D READ_ONCE(sqe->fadvise_advice);
> +	return 0;
> +#else
> +	return -EOPNOTSUPP;
> +#endif
> +}
> +
> +static int io_madvise(struct io_kiocb *req, struct io_kiocb **nxt,
> +		      bool force_nonblock)
> +{
> +#if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
> +	struct io_fadvise *fa =3D &req->fadvise;
> +	int ret;
> +
> +	if (force_nonblock)
> +		return -EAGAIN;
> +
> +	ret =3D do_madvise(fa->addr, fa->len, fa->advice);
> +	if (ret < 0)
> +		req_set_fail_links(req);
> +	io_cqring_add_event(req, ret);
> +	io_put_req_find_next(req, nxt);
> +	return 0;
> +#else
> +	return -EOPNOTSUPP;
> +#endif
> +}
> +
>  static int io_fadvise_prep(struct io_kiocb *req, const struct io_uring=
_sqe *sqe)
>  {
>  	if (sqe->ioprio || sqe->buf_index || sqe->addr)
> @@ -3769,6 +3812,9 @@ static int io_req_defer_prep(struct io_kiocb *req=
,
>  	case IORING_OP_FADVISE:
>  		ret =3D io_fadvise_prep(req, sqe);
>  		break;
> +	case IORING_OP_MADVISE:
> +		ret =3D io_madvise_prep(req, sqe);
> +		break;
>  	default:
>  		printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
>  				req->opcode);
> @@ -3973,6 +4019,14 @@ static int io_issue_sqe(struct io_kiocb *req, co=
nst struct io_uring_sqe *sqe,
>  		}
>  		ret =3D io_fadvise(req, nxt, force_nonblock);
>  		break;
> +	case IORING_OP_MADVISE:
> +		if (sqe) {
> +			ret =3D io_madvise_prep(req, sqe);
> +			if (ret)
> +				break;
> +		}
> +		ret =3D io_madvise(req, nxt, force_nonblock);
> +		break;
>  	default:
>  		ret =3D -EINVAL;
>  		break;
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_urin=
g.h
> index f87d8fb42916..7cb6fe0fccd7 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -88,6 +88,7 @@ enum {
>  	IORING_OP_READ,
>  	IORING_OP_WRITE,
>  	IORING_OP_FADVISE,
> +	IORING_OP_MADVISE,
> =20
>  	/* this goes last, obviously */
>  	IORING_OP_LAST,
>=20

--=20
Pavel Begunkov


--28z4doOrSDfZi7mZ8O7rPeprdWzFB7fqi--

--TnaMNkjdr2jxx9mkkbIg3uf04PlhI8t8E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4bkigACgkQWt5b1Glr
+6WObw//YAQdVzXMcJJKxco0yWIVtpcOiE+UPoDSCJ2IDIjo7WDj17fOWXwhsnBC
x3IYOqOOGpeTpHQ5Bzhq+6U3dZShEc1Tf/vEtIwVRpupoFpklmULLIwwMcyxnJIF
n/yo8mi1MtdjzZKiTjeFyWXGx7baLSDVv0ZPZDk0CdOearbrfVIsywXMlMjNy89h
s66o+kBP/WiO+jIumZkZrcD0g67hSnh/WzC2Y3NBCo6Yka14R4nmeOQDG4MSBkFK
P+CusaSoaCdenfuPkYhk6JJ8tq7XoR09FtS0FMOWjNH8fYkpdHvQxy1R+a9ZkMu/
TBhlWxH81fi3sDaS8LBHEnDD5X6v2lbWmysdCVv6Ocd72ZlavqduGrwnIDgiIbbs
jwgqvc8y3GFa+/mEfK4q9atCCGpcPQuB7wpx/YftVAVRkS2sAlJ6bLRSu0ygsEiE
2ArhtaUM+KITKh4UM2yX3s7yvRz7ovqGbHSaFmlj9d2QX0k05MWi6aodtTFXgEOn
P4siXkzjbK9Z1GtCcWamxqHCDPksgBvauXs8VlDbORtnhsg/1UyKaw+PkoCjRO+j
3BWmbFnKpt0qEucH26DB8VxgzFGj/tcAj1QXUOy3JD2iVhMYpbv/WVtiU5DxW9ng
zXXNc6mwP8eblwhtT16k87ITaggpNwCWxh6xBTzL7UEqIaWs4zc=
=fscM
-----END PGP SIGNATURE-----

--TnaMNkjdr2jxx9mkkbIg3uf04PlhI8t8E--
