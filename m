Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE2A16B491
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 23:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgBXWws (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 17:52:48 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45410 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBXWws (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 17:52:48 -0500
Received: by mail-wr1-f67.google.com with SMTP id g3so12364382wrs.12;
        Mon, 24 Feb 2020 14:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=clWXIEodYApVfnchd/Rd00t8musNINdEvTSweuTj3ss=;
        b=L4DT0W2bP7YkE3AH74MKysjVmA3TIs2dTzX/8IjtOwvJnMU5li9fKi2YaxjVItcaU2
         wyFugf22RewUmuyLCWfXEaYKTCGEFa3ai2f5AwKYynoQO4wPhQA0PSprgP+umoEZbAKm
         pW0J1vadiEi56oTfqzQQ0K56jYfCGmJu1E3GIyaUeANGMVDS3BTFTA66I9Xc0A/nPCT2
         x1wGLDCNUzvg1VJo+azgW8eodGadT2Ebl68tKT5zcwDPuDMgynVGUPc3wtmyjgwWeBrc
         1d65u0En65ZUvRETDeUyglxX1YQKCIPDiaqTUmRdO+CDxaQ22Kov9zgTJYcY4DZisq4g
         N8aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=clWXIEodYApVfnchd/Rd00t8musNINdEvTSweuTj3ss=;
        b=WGDGxfzNPMbIcqlA5gSASbOG1brhMr3CkLzjUI6QdnohSoP3tXRd7RQdWEPES6AiiK
         w9Y/AsD9YMJrDgql1wKz0B6Tg5vy0onQ44zhQ52mjMcBStYvLPoVRQ31gNcatY3sBtqm
         ffMgh6C30Av2q2AtjTcGg8UkGkdR0Ay5e9XGnqUDB8z6o6E6gZCWlRXTVR5spWnMSzQ/
         /QDOF/J8+8h9xKDMgT3iwilB90FiKlP/bMIGhMTiH7NCwg/6NoPK4Obv8Yvfb+w8D1bD
         stG9G6u38UXhr1FCn7SymujNYlq12zvtWMzXa1Ft167p/rcW6dnvZDlfXocoVYUwKkRu
         FQ0w==
X-Gm-Message-State: APjAAAUkLQuAs4myVN0Pm6mjtJgF/qCIirIdBZGOYWrpnvdGbk5yedJz
        HJK4R12EcRp4XXas7sR14Zl9Fk7K
X-Google-Smtp-Source: APXvYqyZFBkpJR4KtXK57nuBEnl2GOwRPNCG5BybZfyfE5/vrpZTKWKcRm36JOciBLg3SdGu9ibSFA==
X-Received: by 2002:a5d:484f:: with SMTP id n15mr68773094wrs.365.1582584764595;
        Mon, 24 Feb 2020 14:52:44 -0800 (PST)
Received: from [192.168.43.206] ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id o4sm20022588wrx.25.2020.02.24.14.52.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 14:52:43 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1582530525.git.asml.silence@gmail.com>
 <923cc84a-e11f-2a16-2f12-ca3ba2f3ade4@kernel.dk>
 <596e6b61-e9de-7498-05c4-571613673c15@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v4 0/3] io_uring: add splice(2) support
Message-ID: <e2fe9083-d5bf-001d-0821-04e265cb85cb@gmail.com>
Date:   Tue, 25 Feb 2020 01:51:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <596e6b61-e9de-7498-05c4-571613673c15@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="OZWzoOL1kMRMn1xgpuoaMH4cfD8BJ2Prk"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--OZWzoOL1kMRMn1xgpuoaMH4cfD8BJ2Prk
Content-Type: multipart/mixed; boundary="NtZEoBCB3ddcZeMeUF9QJzD4z0KjD01lc";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <e2fe9083-d5bf-001d-0821-04e265cb85cb@gmail.com>
Subject: Re: [PATCH v4 0/3] io_uring: add splice(2) support
References: <cover.1582530525.git.asml.silence@gmail.com>
 <923cc84a-e11f-2a16-2f12-ca3ba2f3ade4@kernel.dk>
 <596e6b61-e9de-7498-05c4-571613673c15@kernel.dk>
In-Reply-To: <596e6b61-e9de-7498-05c4-571613673c15@kernel.dk>

--NtZEoBCB3ddcZeMeUF9QJzD4z0KjD01lc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 25/02/2020 01:34, Jens Axboe wrote:
> On 2/24/20 8:35 AM, Jens Axboe wrote:
>> On 2/24/20 1:32 AM, Pavel Begunkov wrote:
>>> *on top of for-5.6 + async patches*
>>>
>>> Not the fastets implementation, but I'd need to stir up/duplicate
>>> splice.c bits to do it more efficiently.
>>>
>>> note: rebase on top of the recent inflight patchset.
>>
>> Let's get this queued up, looks good to go to me. Do you have a few
>> liburing test cases we can add for this?
>=20
> Seems to me like we have an address space issue for the off_in and

Is that a problem? From the old fixing thread loop_rw_iter() it appeared
to me, that it's ok to pass a kernel address as a user one.
f_op->write of some implemented through the same copy_to_user().


> off_out parameters. Why aren't we passing in pointers to these
> and making them work like regular splice?

That's one extra copy_to_user() + copy_from_user(), which I hope to remov=
e
in the future. And I'm not really a fan of such API, and would prefer to =
give
away such tracking to the userspace.

>=20
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 792ef01a521c..b0cfd68be8c9 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -448,8 +448,8 @@ struct io_epoll {
>  struct io_splice {
>  	struct file			*file_out;
>  	struct file			*file_in;
> -	loff_t				off_out;
> -	loff_t				off_in;
> +	loff_t __user			*off_out;
> +	loff_t __user			*off_in;
>  	u64				len;
>  	unsigned int			flags;
>  };
> @@ -2578,8 +2578,8 @@ static int io_splice_prep(struct io_kiocb *req, c=
onst struct io_uring_sqe *sqe)
>  		return 0;
> =20
>  	sp->file_in =3D NULL;
> -	sp->off_in =3D READ_ONCE(sqe->splice_off_in);
> -	sp->off_out =3D READ_ONCE(sqe->off);
> +	sp->off_in =3D u64_to_user_ptr(READ_ONCE(sqe->splice_off_in));
> +	sp->off_out =3D u64_to_user_ptr(READ_ONCE(sqe->off));
>  	sp->len =3D READ_ONCE(sqe->len);
>  	sp->flags =3D READ_ONCE(sqe->splice_flags);
> =20
> @@ -2614,7 +2614,6 @@ static int io_splice(struct io_kiocb *req, struct=
 io_kiocb **nxt,
>  	struct file *in =3D sp->file_in;
>  	struct file *out =3D sp->file_out;
>  	unsigned int flags =3D sp->flags & ~SPLICE_F_FD_IN_FIXED;
> -	loff_t *poff_in, *poff_out;
>  	long ret;
> =20
>  	if (force_nonblock) {
> @@ -2623,9 +2622,7 @@ static int io_splice(struct io_kiocb *req, struct=
 io_kiocb **nxt,
>  		flags |=3D SPLICE_F_NONBLOCK;
>  	}
> =20
> -	poff_in =3D (sp->off_in =3D=3D -1) ? NULL : &sp->off_in;
> -	poff_out =3D (sp->off_out =3D=3D -1) ? NULL : &sp->off_out;
> -	ret =3D do_splice(in, poff_in, out, poff_out, sp->len, flags);
> +	ret =3D do_splice(in, sp->off_in, out, sp->off_out, sp->len, flags);
>  	if (force_nonblock && ret =3D=3D -EAGAIN)
>  		return -EAGAIN;
> =20
>=20

--=20
Pavel Begunkov


--NtZEoBCB3ddcZeMeUF9QJzD4z0KjD01lc--

--OZWzoOL1kMRMn1xgpuoaMH4cfD8BJ2Prk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5UU40ACgkQWt5b1Glr
+6WDAw/9HeuPgI5QKhDNSWKPpcu3xzmczt26ra96ePRs5LA4Arkut3K/8X41Wf0B
wmbYNH0q7AoPpDR52vj6Y6wcg1rs61xDUa34hI1XuMir0OwKjw1J3uEtHbOwkkAH
U3ECR/I172TDPfZk/suToQ/crglr5itm/avoszyFzU+eY1hiMPMXiG/Hp2SACYne
iOHEuL55fMPjMJHCrOMqvigKa1HLzq9svaymVXPaJT7LHm3/rxv00LyPnUtXHISz
UD3TwC81M8D3wb4KoaK/BeC5/RfQ5cHrb3FPEnP8TzGqkqJ2XLZUdHQipSzsLlHV
RMS94zTlC/wEG0sEv6LudbP2TdXQfOLQBG/IFTa3IQhnvY2u1tWyV+IKeSH1Vccb
ilkhix/34Vg3kFHQDS7c5BAzHypSWpA/LHZBNWOQvO9nIMdhD4ofxvD7mtRZrD1D
84RruMr0aPzjLqWvXR6hCmGRXGCPwD+M1JssdNXbaJMh8iewGVBE/WjcSbX6aU0Y
Y2v1+Htl22JDnIES63BmAz5pRoOHewXo737HSkviwc3NLYsjlONL+DKAMa44q1+Q
TegrlEFqQ0N5VnoY6EWHLyU80/znYOvLummoVisGcsk4eccvryDw6f5EIXV3C2A+
5Umyz7ej4R2oVAWtaRdo/1aMkAG3LnPzFHNR0H5GEaBcL7ZTfqs=
=6wez
-----END PGP SIGNATURE-----

--OZWzoOL1kMRMn1xgpuoaMH4cfD8BJ2Prk--
