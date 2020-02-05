Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFB4A153A5E
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2020 22:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbgBEVkE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Feb 2020 16:40:04 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37200 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727149AbgBEVkD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Feb 2020 16:40:03 -0500
Received: by mail-ed1-f68.google.com with SMTP id cy15so3700277edb.4;
        Wed, 05 Feb 2020 13:40:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=uPWQZG4LPcKg3yk27RrIDGprJuGxrykdr/QJLkNDmWI=;
        b=gS9ilOEFzICP31RfpRCj1aWsWS2rqFs+yJ0uvShbBF2u40fAQwJY4QYhjZvqkJkYDm
         snOZV50oz1EiF0l/L96HmOjr/k0VJyZUaGrYOJhRIXse7/tpOuWSs88dC4l3wblRA5E1
         zoLgKOmbXMdJWo2WjMuR6isxXXY8UL4jVkqKL4DL+K+wZGV2wfXYG2U+046fQZpfThTK
         8g0dCkNSxN1lBxbXMpDJB97+pyuJADwDZV+yeYBNGMe1ri6bcVAGt0TuTV1joxZCfMbN
         mty/VFZXFhHtlxP0aPDITG9ja0jMupbWwJhP2Qxhg1TS372J+iUrzJrCi8J7lfVAcakc
         QDCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:references:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=uPWQZG4LPcKg3yk27RrIDGprJuGxrykdr/QJLkNDmWI=;
        b=clbTxVGGEYfrSMnJHeju6WzcDwdSPbA5P1mvZP80QZfVTUOyyyXM6tk8yl1lVTce+P
         H1hSc4xNAmRZNgsDNao2bXzCcX3dxD08S161IXwAuXvYWxcELwmsR08GhlSuCu2JPhs8
         +X23/gOSmVq92WBzq50bIfnV8u1PJleNRtE1L5qXaWGFhqzn+/dsA1Lb61f3LSoPNmAl
         3lirNk/2Q5X6RXSPHMZ8t66BvEUUYxg8TphgPEnCDfyBKjtXIy7kBaQuQLHWOzM0Z7/S
         1PNJvKcNDXy6RLJ3j/HLv/p4W1UO0+KEmgBx2lNqNyVxpEOViqaY4NjZRdPs+iB+trtt
         oGQQ==
X-Gm-Message-State: APjAAAUX/1iVbOxnC9fgLf07IIKk3hCiWZCfsHqxb0ZBI2vICIJ2dSXf
        QyCF9D1QCecKhZRaAlJn8IV8QwUN
X-Google-Smtp-Source: APXvYqzkTL9GLAZadhjgm8pL9VP89xbHfeWMcBcoODEQRmiJ/VUiuqKOI7dyG0B7jvtI8R3lKCLp1Q==
X-Received: by 2002:a17:906:ce4a:: with SMTP id se10mr65519ejb.157.1580938801038;
        Wed, 05 Feb 2020 13:40:01 -0800 (PST)
Received: from [192.168.43.125] ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id dd20sm120315ejb.59.2020.02.05.13.39.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 13:40:00 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1580928112.git.asml.silence@gmail.com>
 <c9654d6a79898d5f8aa8b9dabcb76d9f23faa149.1580928112.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 1/3] io_uring: pass sqe for link head
Message-ID: <19f6aa0e-158f-5125-9df9-39ae95c72962@gmail.com>
Date:   Thu, 6 Feb 2020 00:39:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <c9654d6a79898d5f8aa8b9dabcb76d9f23faa149.1580928112.git.asml.silence@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="f3jlXk8UXjQeWG29rJJfwv0ki13a0y3bA"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--f3jlXk8UXjQeWG29rJJfwv0ki13a0y3bA
Content-Type: multipart/mixed; boundary="wueUO6lOAO8P1BElffsIWk60eKs7iCg9q";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <19f6aa0e-158f-5125-9df9-39ae95c72962@gmail.com>
Subject: Re: [PATCH 1/3] io_uring: pass sqe for link head
References: <cover.1580928112.git.asml.silence@gmail.com>
 <c9654d6a79898d5f8aa8b9dabcb76d9f23faa149.1580928112.git.asml.silence@gmail.com>
In-Reply-To: <c9654d6a79898d5f8aa8b9dabcb76d9f23faa149.1580928112.git.asml.silence@gmail.com>

--wueUO6lOAO8P1BElffsIWk60eKs7iCg9q
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 05/02/2020 22:07, Pavel Begunkov wrote:
> Save an sqe for a head of a link, so it doesn't go through switch in
> io_req_defer_prep() nor allocating an async context in advance.
>=20
> Also, it's fixes potenial memleak for double-preparing head requests.
> E.g. prep in io_submit_sqe() and then prep in io_req_defer(),
> which leaks iovec for vectored read/writes.

Looking through -rc1, remembered that Jens already fixed this. So, this m=
ay be
striked out.


>=20
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
>=20
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index f00c2c9c67c0..e18056af5672 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -4721,20 +4721,22 @@ static void io_queue_sqe(struct io_kiocb *req, =
const struct io_uring_sqe *sqe)
>  	}
>  }
> =20
> -static inline void io_queue_link_head(struct io_kiocb *req)
> +static inline void io_queue_link_head(struct io_kiocb *req,
> +				      const struct io_uring_sqe *sqe)
>  {
>  	if (unlikely(req->flags & REQ_F_FAIL_LINK)) {
>  		io_cqring_add_event(req, -ECANCELED);
>  		io_double_put_req(req);
>  	} else
> -		io_queue_sqe(req, NULL);
> +		io_queue_sqe(req, sqe);
>  }
> =20
>  #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK=
|	\
>  				IOSQE_IO_HARDLINK | IOSQE_ASYNC)
> =20
>  static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_=
sqe *sqe,
> -			  struct io_submit_state *state, struct io_kiocb **link)
> +			  struct io_submit_state *state, struct io_kiocb **link,
> +			  const struct io_uring_sqe **link_sqe)
>  {
>  	const struct cred *old_creds =3D NULL;
>  	struct io_ring_ctx *ctx =3D req->ctx;
> @@ -4812,7 +4814,7 @@ static bool io_submit_sqe(struct io_kiocb *req, c=
onst struct io_uring_sqe *sqe,
> =20
>  		/* last request of a link, enqueue the link */
>  		if (!(sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK))) {
> -			io_queue_link_head(head);
> +			io_queue_link_head(head, *link_sqe);
>  			*link =3D NULL;
>  		}
>  	} else {
> @@ -4823,10 +4825,8 @@ static bool io_submit_sqe(struct io_kiocb *req, =
const struct io_uring_sqe *sqe,
>  		if (sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
>  			req->flags |=3D REQ_F_LINK;
>  			INIT_LIST_HEAD(&req->link_list);
> -			ret =3D io_req_defer_prep(req, sqe);
> -			if (ret)
> -				req->flags |=3D REQ_F_FAIL_LINK;
>  			*link =3D req;
> +			*link_sqe =3D sqe;
>  		} else {
>  			io_queue_sqe(req, sqe);
>  		}
> @@ -4924,6 +4924,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx=
, unsigned int nr,
>  	struct io_kiocb *link =3D NULL;
>  	int i, submitted =3D 0;
>  	bool mm_fault =3D false;
> +	const struct io_uring_sqe *link_sqe =3D NULL;
> =20
>  	/* if we have a backlog and couldn't flush it all, return BUSY */
>  	if (test_bit(0, &ctx->sq_check_overflow)) {
> @@ -4983,7 +4984,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx=
, unsigned int nr,
>  		req->needs_fixed_file =3D async;
>  		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
>  						true, async);
> -		if (!io_submit_sqe(req, sqe, statep, &link))
> +		if (!io_submit_sqe(req, sqe, statep, &link, &link_sqe))
>  			break;
>  	}
> =20
> @@ -4993,7 +4994,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx=
, unsigned int nr,
>  		percpu_ref_put_many(&ctx->refs, nr - ref_used);
>  	}
>  	if (link)
> -		io_queue_link_head(link);
> +		io_queue_link_head(link, link_sqe);
>  	if (statep)
>  		io_submit_state_end(&state);
> =20
>=20

--=20
Pavel Begunkov


--wueUO6lOAO8P1BElffsIWk60eKs7iCg9q--

--f3jlXk8UXjQeWG29rJJfwv0ki13a0y3bA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl47NgsACgkQWt5b1Glr
+6UwXw//dNv5BWF6lBE1QULOEs2wllbqAwaR2K077gZzH6VxaQiSYoHGzfyRkaBF
rODtR6sXkfUSRlZxAVymxlAv0bWPT29wI9BEPMSIbAYinMH8ostmgQrZkuFR6au1
YWZtVzyJaQKrxLmieOEKiPRNgAnYcichsLaaYZL9X5M0/THnhhnqdAUM03En36MV
H26UyO//BS81zLIhv80TFOy+cWx00/MBJIDmzpkVnrBmNZlFuJretY2swXBEDK9A
PGDmyuGbnZH1cc/OiIz3pcjHjB+y8xBbYlFnZfxg4yUADH4/a+9UAL4X8TmGQ4UC
mZe4zfUDOZ8g21Jeb7xaF3vC+BUuzpYnul72RXfR+yj0rICT1umZIu9CS43Oq63d
hqd9LE7YYiZc7hPRLNRN30QpdtLQULdo0zUtTkE78l04vEbtaTlEP4Gr8sV4ltf/
5NF7ljjJFKEKA4PBru2JetqZU3oGdiY1VuX8MRrM5kFy8O7enze/sI0+JVQJ/dSS
dMnnl4vhXCd23hdvZACxJQ1p7Tcxh/htgRaZU58++qpZX1f9TTqUuNT0zbUBuGNB
G24Frkc9YUWsZupi8RrxyydMjg6AcRMhmGULfMB6GYGMKP8yvoVRn4Lgo/6ioghZ
1CcwW1ezh2XGHFvgO7OGEDMIFyov03idZ30ZEI39JjjQb24tR8g=
=dRxw
-----END PGP SIGNATURE-----

--f3jlXk8UXjQeWG29rJJfwv0ki13a0y3bA--
