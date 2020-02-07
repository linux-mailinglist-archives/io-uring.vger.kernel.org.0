Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDDBD155E85
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2020 20:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgBGTKY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Feb 2020 14:10:24 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:34960 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726900AbgBGTKX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Feb 2020 14:10:23 -0500
Received: by mail-ed1-f65.google.com with SMTP id f8so693171edv.2;
        Fri, 07 Feb 2020 11:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=NYSpnRd9PaK3FIasYUc2I0eeNjv5HHl1KSytu/5Nm2A=;
        b=mhNGas8EgxmNrTMFGMLjTL9grmhtrqamfdPfVyRmQAF9k+cs802v1g0DA3Yxnm5HQ7
         KDG1Zj75eC9n2ajxfTrOzF1fY1dliXL6Ddn/wFMbYE3k7QCFSy9eYjVEW6vHw4bp7JqD
         SaF4oXTdvtX7VUldpyxHNaNXPN1gcMM+ipUot0zfH+ahEPQYtE4DgljCabAYWtwBqEif
         dsec5P/WR4RnoxZnEBRCASI9tIGh06TDyGoR5ySr/lWkBZ36uwpMAe3uKmMH+Dlu4pTP
         ODJBUJZp6dzMatVyQzFdul33r3xEpRqOob600CAdOoVRia42iroogISPPB9pwWaIfgm7
         oG5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=NYSpnRd9PaK3FIasYUc2I0eeNjv5HHl1KSytu/5Nm2A=;
        b=rqrkNDwq8NjB4HTJu7/f3Iduf8nzUYBJKzWEDLo16KRz72Z53ItWuPRPFas+1z19IU
         ZIxOuQckPiWSv4vs3mw/3JmuFdG+n/NGPLWaK5Bn9pfyHcNNurSYhNEAUt1tuSzNizRc
         Rw661jnFxRfxwE59MEwr6vB1LsMHOVRXBXuLnEpPbnnCLWD/YcIn5jnb3KKW2D77ikxg
         OKKG2WZ2+oi2GFEmdezY9fohZNYckzsEf2KTzlDQ4z3hd/sW/uxP/1HqWNgTKQfYQelV
         qExD4DLps9s1FsZJN+ekt8F6yeEvAyXe0lWadGJX7MXyusmxg9AqptVQHFDU4UB2PBOR
         XvnQ==
X-Gm-Message-State: APjAAAU900mHrS6wTFB0yOohccFNdcAPBTdLxQVbx4rSnceOhEsJx/g2
        wG4SiwmRxfKhRzarGElionEANGBJ
X-Google-Smtp-Source: APXvYqwbCLZGHl3d33/0qt9y7xK9RG5OARervabvJy7zv1HuTubjo7nPsjz/ZjlDaicSM/pEzm1eDw==
X-Received: by 2002:a05:6402:153:: with SMTP id s19mr339684edu.149.1581102621040;
        Fri, 07 Feb 2020 11:10:21 -0800 (PST)
Received: from [192.168.43.53] ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id p5sm460702ejj.61.2020.02.07.11.10.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2020 11:10:20 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix iovec leaks
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <03aa734fcea29805635689cc2f1aa648f23b5cd3.1581102250.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <bb0aeec6-9dc4-2b58-a93e-ee37c38a919c@gmail.com>
Date:   Fri, 7 Feb 2020 22:09:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <03aa734fcea29805635689cc2f1aa648f23b5cd3.1581102250.git.asml.silence@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4EhvrhPRsmTfR5gtmXPX6fxOYwUK9lats"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4EhvrhPRsmTfR5gtmXPX6fxOYwUK9lats
Content-Type: multipart/mixed; boundary="xIXvUw5lSuHbtBJwiRhgthE2VmYPzeVx3";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <bb0aeec6-9dc4-2b58-a93e-ee37c38a919c@gmail.com>
Subject: Re: [PATCH] io_uring: fix iovec leaks
References: <03aa734fcea29805635689cc2f1aa648f23b5cd3.1581102250.git.asml.silence@gmail.com>
In-Reply-To: <03aa734fcea29805635689cc2f1aa648f23b5cd3.1581102250.git.asml.silence@gmail.com>

--xIXvUw5lSuHbtBJwiRhgthE2VmYPzeVx3
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 07/02/2020 22:04, Pavel Begunkov wrote:
> Allocated iovec is freed only in io_{read,write,send,recv)(), and just
> leaves it if an error occured. There are plenty of such cases:
> - cancellation of non-head requests
> - fail grabbing files in __io_queue_sqe()
> - set REQ_F_NOWAIT and returning in __io_queue_sqe()
> - etc.
>=20
> Add REQ_F_NEED_CLEANUP, which will force such requests with custom
> allocated resourses go through cleanup handlers on put.

This is probably desirable in stable-5.5, so I tried to not change much.
I'll hide common parts in following patches for-5.6/next.

> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++++--=

>  1 file changed, 49 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 1914351ebd5e..d699695ef809 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -478,6 +478,7 @@ enum {
>  	REQ_F_MUST_PUNT_BIT,
>  	REQ_F_TIMEOUT_NOSEQ_BIT,
>  	REQ_F_COMP_LOCKED_BIT,
> +	REQ_F_NEED_CLEANUP_BIT,
>  };
> =20
>  enum {
> @@ -516,6 +517,8 @@ enum {
>  	REQ_F_TIMEOUT_NOSEQ	=3D BIT(REQ_F_TIMEOUT_NOSEQ_BIT),
>  	/* completion under lock */
>  	REQ_F_COMP_LOCKED	=3D BIT(REQ_F_COMP_LOCKED_BIT),
> +	/* needs cleanup */
> +	REQ_F_NEED_CLEANUP	=3D BIT(REQ_F_NEED_CLEANUP_BIT),
> =20
>  };
> =20
> @@ -749,6 +752,7 @@ static int __io_sqe_files_update(struct io_ring_ctx=
 *ctx,
>  				 unsigned nr_args);
>  static int io_grab_files(struct io_kiocb *req);
>  static void io_ring_file_ref_flush(struct fixed_file_data *data);
> +static void io_cleanup_req(struct io_kiocb *req);
> =20
>  static struct kmem_cache *req_cachep;
> =20
> @@ -1236,6 +1240,9 @@ static void __io_free_req(struct io_kiocb *req)
>  {
>  	__io_req_aux_free(req);
> =20
> +	if (req->flags & REQ_F_NEED_CLEANUP)
> +		io_cleanup_req(req);
> +
>  	if (req->flags & REQ_F_INFLIGHT) {
>  		struct io_ring_ctx *ctx =3D req->ctx;
>  		unsigned long flags;
> @@ -2129,6 +2136,8 @@ static void io_req_map_rw(struct io_kiocb *req, s=
size_t io_size,
>  		req->io->rw.iov =3D req->io->rw.fast_iov;
>  		memcpy(req->io->rw.iov, fast_iov,
>  			sizeof(struct iovec) * iter->nr_segs);
> +	} else {
> +		req->flags |=3D REQ_F_NEED_CLEANUP;
>  	}
>  }
> =20
> @@ -2239,6 +2248,7 @@ static int io_read(struct io_kiocb *req, struct i=
o_kiocb **nxt,
>  	}
>  out_free:
>  	kfree(iovec);
> +	req->flags &=3D ~REQ_F_NEED_CLEANUP;
>  	return ret;
>  }
> =20
> @@ -2343,6 +2353,7 @@ static int io_write(struct io_kiocb *req, struct =
io_kiocb **nxt,
>  		}
>  	}
>  out_free:
> +	req->flags &=3D ~REQ_F_NEED_CLEANUP;
>  	kfree(iovec);
>  	return ret;
>  }
> @@ -2943,6 +2954,7 @@ static int io_sendmsg_prep(struct io_kiocb *req, =
const struct io_uring_sqe *sqe)
>  #if defined(CONFIG_NET)
>  	struct io_sr_msg *sr =3D &req->sr_msg;
>  	struct io_async_ctx *io =3D req->io;
> +	int ret;
> =20
>  	sr->msg_flags =3D READ_ONCE(sqe->msg_flags);
>  	sr->msg =3D u64_to_user_ptr(READ_ONCE(sqe->addr));
> @@ -2952,8 +2964,11 @@ static int io_sendmsg_prep(struct io_kiocb *req,=
 const struct io_uring_sqe *sqe)
>  		return 0;
> =20
>  	io->msg.iov =3D io->msg.fast_iov;
> -	return sendmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
> +	ret =3D sendmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
>  					&io->msg.iov);
> +	if (!ret)
> +		req->flags |=3D REQ_F_NEED_CLEANUP;
> +	return ret;
>  #else
>  	return -EOPNOTSUPP;
>  #endif
> @@ -3011,6 +3026,7 @@ static int io_sendmsg(struct io_kiocb *req, struc=
t io_kiocb **nxt,
>  					kfree(kmsg->iov);
>  				return -ENOMEM;
>  			}
> +			req->flags |=3D REQ_F_NEED_CLEANUP;
>  			memcpy(&req->io->msg, &io.msg, sizeof(io.msg));
>  			return -EAGAIN;
>  		}
> @@ -3020,6 +3036,7 @@ static int io_sendmsg(struct io_kiocb *req, struc=
t io_kiocb **nxt,
> =20
>  	if (kmsg && kmsg->iov !=3D kmsg->fast_iov)
>  		kfree(kmsg->iov);
> +	req->flags &=3D ~REQ_F_NEED_CLEANUP;
>  	io_cqring_add_event(req, ret);
>  	if (ret < 0)
>  		req_set_fail_links(req);
> @@ -3087,6 +3104,7 @@ static int io_recvmsg_prep(struct io_kiocb *req,
>  #if defined(CONFIG_NET)
>  	struct io_sr_msg *sr =3D &req->sr_msg;
>  	struct io_async_ctx *io =3D req->io;
> +	int ret;
> =20
>  	sr->msg_flags =3D READ_ONCE(sqe->msg_flags);
>  	sr->msg =3D u64_to_user_ptr(READ_ONCE(sqe->addr));
> @@ -3096,8 +3114,11 @@ static int io_recvmsg_prep(struct io_kiocb *req,=

>  		return 0;
> =20
>  	io->msg.iov =3D io->msg.fast_iov;
> -	return recvmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
> +	ret =3D recvmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
>  					&io->msg.uaddr, &io->msg.iov);
> +	if (!ret)
> +		req->flags |=3D REQ_F_NEED_CLEANUP;
> +	return ret;
>  #else
>  	return -EOPNOTSUPP;
>  #endif
> @@ -3158,6 +3179,7 @@ static int io_recvmsg(struct io_kiocb *req, struc=
t io_kiocb **nxt,
>  				return -ENOMEM;
>  			}
>  			memcpy(&req->io->msg, &io.msg, sizeof(io.msg));
> +			req->flags |=3D REQ_F_NEED_CLEANUP;
>  			return -EAGAIN;
>  		}
>  		if (ret =3D=3D -ERESTARTSYS)
> @@ -3166,6 +3188,7 @@ static int io_recvmsg(struct io_kiocb *req, struc=
t io_kiocb **nxt,
> =20
>  	if (kmsg && kmsg->iov !=3D kmsg->fast_iov)
>  		kfree(kmsg->iov);
> +	req->flags &=3D ~REQ_F_NEED_CLEANUP;
>  	io_cqring_add_event(req, ret);
>  	if (ret < 0)
>  		req_set_fail_links(req);
> @@ -4176,6 +4199,30 @@ static int io_req_defer(struct io_kiocb *req, co=
nst struct io_uring_sqe *sqe)
>  	return -EIOCBQUEUED;
>  }
> =20
> +static void io_cleanup_req(struct io_kiocb *req)
> +{
> +	struct io_async_ctx *io =3D req->io;
> +
> +	switch (req->opcode) {
> +	case IORING_OP_READV:
> +	case IORING_OP_READ_FIXED:
> +	case IORING_OP_READ:
> +	case IORING_OP_WRITEV:
> +	case IORING_OP_WRITE_FIXED:
> +	case IORING_OP_WRITE:
> +		if (io->rw.iov !=3D io->rw.fast_iov)
> +			kfree(io->rw.iov);
> +		break;
> +	case IORING_OP_SENDMSG:
> +	case IORING_OP_RECVMSG:
> +		if (io->msg.iov !=3D io->msg.fast_iov)
> +			kfree(io->msg.iov);
> +		break;
> +	}
> +
> +	req->flags &=3D ~REQ_F_NEED_CLEANUP;
> +}
> +
>  static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sq=
e *sqe,
>  			struct io_kiocb **nxt, bool force_nonblock)
>  {
>=20

--=20
Pavel Begunkov


--xIXvUw5lSuHbtBJwiRhgthE2VmYPzeVx3--

--4EhvrhPRsmTfR5gtmXPX6fxOYwUK9lats
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl49tfQACgkQWt5b1Glr
+6UcEA/8D+LUHcwg2DN/5/HMlFfpSQajGnKN/30XHtAEoYYTznLenS64pXuAhbQD
6zdgvEAXqA99J8JgVt4lozC9lpb/stpRmoxt+/LzPO+9MkdvhFx2iJgpx/XdZeNn
DcqVvtclSkbOQ8qKTi/V9iJWhzXX6St9timbB0J+V21ArUPcnqR1BAQnMxPBBMPt
DE1OcuG54QtVXPcYm4ZnKOSy9i30y1h1JR1EWNmwKMWxErc6vazRmx7kkhskDbnc
1Mum7FDgAceHF9BFlXyyBSmE/JBYY1xUCcHxupvi4ZUk6zWpMcn7q//eEoBfueQ+
lGV/S2bxghKB2QJaPBCs739Xy9imt8Jcu6ELrfFHJi9+TATIBUKEbyBkbiEzjq+Q
oPMV+wwFTuyEKnd1N0IJb5xy4m2hWQEY5p+9g6q/q/FH5Kmds0ifbGn0hyCFm/dp
JJpVnYF75RfmiTApWlfeD7GPd5vSEOG/VHVG712/UsuKDEkZIPtwQpawLle5iGtj
iQ4biSGk/+EWs1hlnxMwNpfdgDC5I3Lttj57dX5WEGT6cCEb3HlBN0NU3z6qVZH4
7oxt3sPu6w1UF953WHa02GqUk3UWeSDekBIZ0COl2iWrWHU7wCmNHHc7Il8vEI6L
OnV4p8u2Yh6Pim+ujdUsflw7VuYZNd9Uf7z95sIxGVFZhHkVWek=
=b+cx
-----END PGP SIGNATURE-----

--4EhvrhPRsmTfR5gtmXPX6fxOYwUK9lats--
