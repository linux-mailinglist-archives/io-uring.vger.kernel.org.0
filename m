Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8020160160
	for <lists+io-uring@lfdr.de>; Sun, 16 Feb 2020 02:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgBPBfs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Feb 2020 20:35:48 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41872 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbgBPBfr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Feb 2020 20:35:47 -0500
Received: by mail-wr1-f66.google.com with SMTP id c9so15453179wrw.8;
        Sat, 15 Feb 2020 17:35:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=7+d5Nrp+osfYanxo1LNIT+sLcmGaxpWvSNTDggfZYE4=;
        b=behSwtCljNLa8S0x+KLujcUlKT25NT4GFsROjdAPHUXR6M1TsgYXeM0rMNX2gLL88B
         /U55elo8i+XecM8Ye5ASGPaLLTebX92D4u9nZEojT5a3kXn5ARQA3YOMZKfxec5VUxUY
         gS89Eyo/JBdq5fE4aKJ8PfmfOwz9XpELPzS+NqjU/oqfRJLIbzKFptqcNSZsX5TBz2EI
         99nwzXzC3ZmGEWZBgfXI0gPMHPx8ihVmlYivaPiUkjpOexozi2z3F5a8keQ2mjBG5UjV
         VkltL/WAdwhkzJZ7B9XJ2XF0hxkspyQ5Ojq4Gu5FAx6uvUsFZmUN2E1fls5JD7/8FUMi
         TzfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=7+d5Nrp+osfYanxo1LNIT+sLcmGaxpWvSNTDggfZYE4=;
        b=Qi9dwmGzufUpSDdqOPT7aZ7POZwW514iQNOLhTNpRF+CrjE4tZfQ3jl0ocbcrNeWN0
         LtUiK0efInLud48k3pxY/pOPhRkan39PlYJGxNImkLvFrxG9bWDfLDRKoZtH3AQqvpcq
         CqHP40j+nEwOuLPC838PvvowZJTcsbOfZRBV9BuDbxzDzvLQn+az/2ZZ9EhLgqcGEb3J
         JJLCHXvQGAYdDivw+hYvadOfJJGxxhRs/E9VqwXCgC4HgX0K5pw+yoCrpeU9iRPXWPeL
         n76iiebi4YpTsmmG4o6VuERSTL22Ov0zFlSJA5wv8ETF9VdbTAcrYaQO3I7tpAxCHgJK
         WM8w==
X-Gm-Message-State: APjAAAXNjyDbFWRIte3vkZN3fPhH1GZAPKc2qkBXKUoTwICQs1xF3yfl
        xPSCCCNPTdiEXu5ER7I26AKSWcJB
X-Google-Smtp-Source: APXvYqxnMVSV1V7A7CnKJ0DAjYqY0wBeVipbzZzcNGsQX7gBL192Y1rZ7SyDC2YOz0FsdpGWEwugGw==
X-Received: by 2002:a5d:4d0a:: with SMTP id z10mr12438935wrt.253.1581816944369;
        Sat, 15 Feb 2020 17:35:44 -0800 (PST)
Received: from [192.168.43.97] ([109.126.146.5])
        by smtp.gmail.com with ESMTPSA id r6sm13765867wrp.95.2020.02.15.17.35.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Feb 2020 17:35:43 -0800 (PST)
Subject: Re: [PATCH liburing 1/2] splice: add splice(2) helpers
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1581804801.git.asml.silence@gmail.com>
 <bbb5b5bb4344d931c0296855c5ba8ae2eb0e89ff.1581804801.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <f617dbcf-ffc0-9b6f-f2f4-a3abdc28db23@gmail.com>
Date:   Sun, 16 Feb 2020 04:34:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <bbb5b5bb4344d931c0296855c5ba8ae2eb0e89ff.1581804801.git.asml.silence@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kGGrgNNaKiNuGTGouHWqLy2xVRekfoZnd"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kGGrgNNaKiNuGTGouHWqLy2xVRekfoZnd
Content-Type: multipart/mixed; boundary="rQZmKnHlmC5pJ8l6Mpy4ZViLSsIWvYVbC";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <f617dbcf-ffc0-9b6f-f2f4-a3abdc28db23@gmail.com>
Subject: Re: [PATCH liburing 1/2] splice: add splice(2) helpers
References: <cover.1581804801.git.asml.silence@gmail.com>
 <bbb5b5bb4344d931c0296855c5ba8ae2eb0e89ff.1581804801.git.asml.silence@gmail.com>
In-Reply-To: <bbb5b5bb4344d931c0296855c5ba8ae2eb0e89ff.1581804801.git.asml.silence@gmail.com>

--rQZmKnHlmC5pJ8l6Mpy4ZViLSsIWvYVbC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 16/02/2020 01:16, Pavel Begunkov wrote:
> Add splice helpers and update io_uring.h
>=20
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>=20
> Quick update for extra newline and the fixed fd comment
>=20
>  src/include/liburing.h          | 11 +++++++++++
>  src/include/liburing/io_uring.h | 14 +++++++++++++-
>  2 files changed, 24 insertions(+), 1 deletion(-)
>=20
> diff --git a/src/include/liburing.h b/src/include/liburing.h
> index 8ca6cd9..0628255 100644
> --- a/src/include/liburing.h
> +++ b/src/include/liburing.h
> @@ -191,6 +191,17 @@ static inline void io_uring_prep_rw(int op, struct=
 io_uring_sqe *sqe, int fd,
>  	sqe->__pad2[0] =3D sqe->__pad2[1] =3D sqe->__pad2[2] =3D 0;
>  }
> =20
> +static void io_uring_prep_splice(struct io_uring_sqe *sqe,

And it still misses inline... My bad, I'll resend tomorrow.



> +				 int fd_in, loff_t off_in,
> +				 int fd_out, loff_t off_out,
> +				 unsigned int nbytes, int splice_flags)
> +{
> +	io_uring_prep_rw(IORING_OP_SPLICE, sqe, fd_out, (void *)off_in,
> +			 nbytes, off_out);
> +	sqe->splice_fd_in =3D fd_in;
> +	sqe->splice_flags =3D splice_flags;
> +}
> +
>  static inline void io_uring_prep_readv(struct io_uring_sqe *sqe, int f=
d,
>  				       const struct iovec *iovecs,
>  				       unsigned nr_vecs, off_t offset)
> diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_=
uring.h
> index 424fb4b..dc78697 100644
> --- a/src/include/liburing/io_uring.h
> +++ b/src/include/liburing/io_uring.h
> @@ -23,7 +23,10 @@ struct io_uring_sqe {
>  		__u64	off;	/* offset into file */
>  		__u64	addr2;
>  	};
> -	__u64	addr;		/* pointer to buffer or iovecs */
> +	union {
> +		__u64	addr;	/* pointer to buffer or iovecs */
> +		__u64	off_in;
> +	};
>  	__u32	len;		/* buffer size or number of iovecs */
>  	union {
>  		__kernel_rwf_t	rw_flags;
> @@ -37,6 +40,7 @@ struct io_uring_sqe {
>  		__u32		open_flags;
>  		__u32		statx_flags;
>  		__u32		fadvise_advice;
> +		__u32		splice_flags;
>  	};
>  	__u64	user_data;	/* data to be passed back at completion time */
>  	union {
> @@ -45,6 +49,7 @@ struct io_uring_sqe {
>  			__u16	buf_index;
>  			/* personality to use, if used */
>  			__u16	personality;
> +			__u32	splice_fd_in;
>  		};
>  		__u64	__pad2[3];
>  	};
> @@ -113,6 +118,7 @@ enum {
>  	IORING_OP_RECV,
>  	IORING_OP_OPENAT2,
>  	IORING_OP_EPOLL_CTL,
> +	IORING_OP_SPLICE,
> =20
>  	/* this goes last, obviously */
>  	IORING_OP_LAST,
> @@ -128,6 +134,12 @@ enum {
>   */
>  #define IORING_TIMEOUT_ABS	(1U << 0)
> =20
> +/*
> + * sqe->splice_flags
> + * extends splice(2) flags
> + */
> +#define SPLICE_F_FD_IN_FIXED	(1U << 31) /* the last bit of __u32 */
> +
>  /*
>   * IO completion data structure (Completion Queue Entry)
>   */
>=20

--=20
Pavel Begunkov


--rQZmKnHlmC5pJ8l6Mpy4ZViLSsIWvYVbC--

--kGGrgNNaKiNuGTGouHWqLy2xVRekfoZnd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5InEcACgkQWt5b1Glr
+6UFwQ//ZDtfYyxZyQbh+DbeX2Z0e1d1klVP8HU6UYL3JoAmv/WqFeQDUOJAEeB3
4HjjUSAt+b1yhLhGtFe47T7wV7sCR5HztQJSOqMQf/aq0vjrAlwYHKL8eehw91Uv
xMGmRTzBWLOpewgffISG4VScojZA3EuwXIwMjwS9Ytedji7lvt2RjcrTGIX1G7op
vkTd/HlQu5dzRjIr4XplCyIvk9BR5t3K2sqGEOTyOC7rfXNvx+FiD2Ap5QlwuZy7
PF3PTcuCIBY4JquFejpM7yPViwLjGNbeRw9+jmH8HTIVJCdoDRf1C5XI6KD6ky6H
Fzc30fniCBVfBtxHBB6CKMzsGtgdS05vnIMH+zyQIgpWew1lv11rYNodjX8odaUa
4D8gpU3e/VezLrrgFlVTBUBNLeaaMFiIKDWCWKZomSvgzfzW+4ftJrRuW/Wwnup7
pZY+RDzdIrSW6Pf17OHgJDwM+P//0VkB6+TJiyFXBQx/9x/pY4HQLSmQRh5lkjPI
2TvZJIiVlHWjPuK+tLYv55GCkcLquxl/7S4TQiCiS1sjEid5ujw75GZZes6GJj9U
GUi71el5e+BHKAyOgPLnfy7OJ1jYXOOlWgC52eNErUVLczy/DuOW9Vkwq0SApiPs
dY7eSUM4fynl9y5eWwBjwJ0kIoAxEsfL6Q733qohZxlMi7eE9xk=
=yO/O
-----END PGP SIGNATURE-----

--kGGrgNNaKiNuGTGouHWqLy2xVRekfoZnd--
