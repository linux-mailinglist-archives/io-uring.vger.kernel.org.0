Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5139316B4A5
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 23:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbgBXWym (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 17:54:42 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55959 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBXWyl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 17:54:41 -0500
Received: by mail-wm1-f66.google.com with SMTP id q9so1018000wmj.5;
        Mon, 24 Feb 2020 14:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=F6Z1iN97w4+cVJAjKNW+II86CGcNkQZPJNHzISvdQGs=;
        b=saRj2wQ2FiKUjG6c6Kec7pEPRByBlpQAPkIIVjLQDUHZ+lbNa4I6aWyym5ilsh85ZE
         hDDsIiXVZ4s+mZNyR7fDLm2NyKiZrNqCZjR+ZrCgTXhmM+lD88+r7eHwcnqjqT+PvlNr
         aU1e2JK8To2psDn14cBqsEaXjnc87FRBcrcizP9NFkpJ3z38d4OJHz8EzNpqTCvVi3wv
         e3AkozQgEtAoog0gsQqLZekBqr08BbkcjmkQuMPweWj03MSUXDGNUrJ5zS60Bkb6fxal
         vLGrhan/u8AJT8F6vjMKhW/3Rt4CsMZE8S2DbGMNvhbXk3s6Oj1zSRtigc0OFQ/OzaGq
         gW0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=F6Z1iN97w4+cVJAjKNW+II86CGcNkQZPJNHzISvdQGs=;
        b=HuW7+KKewWR2LPmGyKl2Y7Mgi2R24OL6QW+kwKdQYe9vFDghEAWUdgbw93+6uNuIPJ
         bZwb+RmyY/c2JTYflBte/OVq4IdN4pcne5UYuptSfNufvebslYPAZBHDMI3XnY9G7BUw
         cTvWtV/Fs7lRZkFX6LmqY5a91WM6fvGGn7xlF4HDPNHiYfQAEFBbfhSSgC6FaeHBZFZd
         j/ZK9cX0S0jGgo1AH8WdEXJZ3IZ3cTeBb992s2gQ8xLc3V4cWE788PCfs08iWA8aF6b4
         lsFmeN7j3N28Zz1AE+Ve0BP34tckZcOIP8AkmGK/ApgxHLqqs+UWsljFTxVHDV285EpJ
         an+w==
X-Gm-Message-State: APjAAAU3hjfb49H2ijKLmoEiKe1QHCGPUAWPrIK4uGfn2Ym2lhFdr32d
        6K3FH7thtC5EWchFjib0X4ggwkgi
X-Google-Smtp-Source: APXvYqwmcD2c+TtkpFaxKoieGZ01+ffdFiQplU6fR7FJW60zxHf52yxbnVeXhe7O2K0XdFYnp2q31w==
X-Received: by 2002:a1c:a1c3:: with SMTP id k186mr1175063wme.179.1582584879480;
        Mon, 24 Feb 2020 14:54:39 -0800 (PST)
Received: from [192.168.43.206] ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id i2sm1173626wmb.28.2020.02.24.14.54.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 14:54:38 -0800 (PST)
Subject: Re: [PATCH v4 0/3] io_uring: add splice(2) support
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1582530525.git.asml.silence@gmail.com>
 <923cc84a-e11f-2a16-2f12-ca3ba2f3ade4@kernel.dk>
 <596e6b61-e9de-7498-05c4-571613673c15@kernel.dk>
 <e2fe9083-d5bf-001d-0821-04e265cb85cb@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <189e8cb4-df3a-f12d-9b21-7134caa918bb@gmail.com>
Date:   Tue, 25 Feb 2020 01:53:55 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <e2fe9083-d5bf-001d-0821-04e265cb85cb@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Ozoo4hy5KCIvsO7awHbFxR1uVzpAnLi9p"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ozoo4hy5KCIvsO7awHbFxR1uVzpAnLi9p
Content-Type: multipart/mixed; boundary="Aude6cfmBxHJCEFukhlDs0IzGgKB6pbmc";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <189e8cb4-df3a-f12d-9b21-7134caa918bb@gmail.com>
Subject: Re: [PATCH v4 0/3] io_uring: add splice(2) support
References: <cover.1582530525.git.asml.silence@gmail.com>
 <923cc84a-e11f-2a16-2f12-ca3ba2f3ade4@kernel.dk>
 <596e6b61-e9de-7498-05c4-571613673c15@kernel.dk>
 <e2fe9083-d5bf-001d-0821-04e265cb85cb@gmail.com>
In-Reply-To: <e2fe9083-d5bf-001d-0821-04e265cb85cb@gmail.com>

--Aude6cfmBxHJCEFukhlDs0IzGgKB6pbmc
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 25/02/2020 01:51, Pavel Begunkov wrote:
> On 25/02/2020 01:34, Jens Axboe wrote:
>> On 2/24/20 8:35 AM, Jens Axboe wrote:
>>> On 2/24/20 1:32 AM, Pavel Begunkov wrote:
>>>> *on top of for-5.6 + async patches*
>>>>
>>>> Not the fastets implementation, but I'd need to stir up/duplicate
>>>> splice.c bits to do it more efficiently.
>>>>
>>>> note: rebase on top of the recent inflight patchset.
>>>
>>> Let's get this queued up, looks good to go to me. Do you have a few
>>> liburing test cases we can add for this?
>>
>> Seems to me like we have an address space issue for the off_in and
>=20
> Is that a problem? From the old fixing thread loop_rw_iter() it appeare=
d
> to me, that it's ok to pass a kernel address as a user one.
> f_op->write of some implemented through the same copy_to_user().

Either I finally need to check myself how the protection is implemented..=
=2E

>=20
>> off_out parameters. Why aren't we passing in pointers to these
>> and making them work like regular splice?
>=20
> That's one extra copy_to_user() + copy_from_user(), which I hope to rem=
ove
> in the future. And I'm not really a fan of such API, and would prefer t=
o give
> away such tracking to the userspace.
>=20
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 792ef01a521c..b0cfd68be8c9 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -448,8 +448,8 @@ struct io_epoll {
>>  struct io_splice {
>>  	struct file			*file_out;
>>  	struct file			*file_in;
>> -	loff_t				off_out;
>> -	loff_t				off_in;
>> +	loff_t __user			*off_out;
>> +	loff_t __user			*off_in;
>>  	u64				len;
>>  	unsigned int			flags;
>>  };
>> @@ -2578,8 +2578,8 @@ static int io_splice_prep(struct io_kiocb *req, =
const struct io_uring_sqe *sqe)
>>  		return 0;
>> =20
>>  	sp->file_in =3D NULL;
>> -	sp->off_in =3D READ_ONCE(sqe->splice_off_in);
>> -	sp->off_out =3D READ_ONCE(sqe->off);
>> +	sp->off_in =3D u64_to_user_ptr(READ_ONCE(sqe->splice_off_in));
>> +	sp->off_out =3D u64_to_user_ptr(READ_ONCE(sqe->off));
>>  	sp->len =3D READ_ONCE(sqe->len);
>>  	sp->flags =3D READ_ONCE(sqe->splice_flags);
>> =20
>> @@ -2614,7 +2614,6 @@ static int io_splice(struct io_kiocb *req, struc=
t io_kiocb **nxt,
>>  	struct file *in =3D sp->file_in;
>>  	struct file *out =3D sp->file_out;
>>  	unsigned int flags =3D sp->flags & ~SPLICE_F_FD_IN_FIXED;
>> -	loff_t *poff_in, *poff_out;
>>  	long ret;
>> =20
>>  	if (force_nonblock) {
>> @@ -2623,9 +2622,7 @@ static int io_splice(struct io_kiocb *req, struc=
t io_kiocb **nxt,
>>  		flags |=3D SPLICE_F_NONBLOCK;
>>  	}
>> =20
>> -	poff_in =3D (sp->off_in =3D=3D -1) ? NULL : &sp->off_in;
>> -	poff_out =3D (sp->off_out =3D=3D -1) ? NULL : &sp->off_out;
>> -	ret =3D do_splice(in, poff_in, out, poff_out, sp->len, flags);
>> +	ret =3D do_splice(in, sp->off_in, out, sp->off_out, sp->len, flags);=

>>  	if (force_nonblock && ret =3D=3D -EAGAIN)
>>  		return -EAGAIN;
>> =20
>>
>=20

--=20
Pavel Begunkov


--Aude6cfmBxHJCEFukhlDs0IzGgKB6pbmc--

--Ozoo4hy5KCIvsO7awHbFxR1uVzpAnLi9p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5UVAMACgkQWt5b1Glr
+6U6cQ/+OtaKdH4Wn7/s7+vEyidYyGSmLFzAVj/WPBXzP7nYlZpgXPoQ45knUbus
roj7NcE0rj9ZPk8FUgfnkI51KeJH0jc2pAroYUEYkBprCvUSTTRLzH9fFeB9UZmg
+mdhrETW/FMqLKY6PQ85ydTwXpnF38c2CPoT/QaxOz7YOMwDlIc4zmVMy86jkgw1
e8N7C7Xd4POlAOfpTGwIXTCvBapVVjVfZ5vvKLapYHiQVo4Cmt6/8QH0fDIC1LNq
azwTfPmAnTzYywLQb/HiAU/MzcIBYKrxlSdsMu20iH69UvxJmdzJx3XrG1cYbpok
PA/OVSq+kncEezoQdNXV7/r/ETBHfG7Tqt8MprzGpHJH28bygwiSu1mrsGRAaH6t
4ULG1Z2J+JjGjLUcm2TLsKH7rDTFRh4zACJQl2zl9Iwhdwa+wVV8ZnKcAw+mNTR/
nN74hYsn1UncSwGO9/ydeR+Tg4tB8gjXApeVzGPx9Tuf2ukGpgVNFlAYYjdT70ZN
d9upyg/9yIuQMVL+5XGd4t9zVRbTdsTsZcfTjTzl1zyzm98Em6lumgsQAkyF9rGf
zMF5C2Qj6IbBN/bJUcgSqMUWMYkn+IoP4eZQoZcctbV8PdQEYMc9Yi+b1Zf80MR/
FK6mR8GMCFsz2WHTif+0h0jj4WPyqpmUcBXxe0zfKivfNCgUuQE=
=VNrk
-----END PGP SIGNATURE-----

--Ozoo4hy5KCIvsO7awHbFxR1uVzpAnLi9p--
