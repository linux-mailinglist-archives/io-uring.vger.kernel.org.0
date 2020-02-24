Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7BC16AF01
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 19:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727744AbgBXS0y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 13:26:54 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37700 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbgBXS0y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 13:26:54 -0500
Received: by mail-wm1-f65.google.com with SMTP id a6so359388wme.2
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 10:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=z5f9aZJUWrYWjBwlTTrNoDRWDOIdxd7l1qvuVBHpDxQ=;
        b=WoiMjucl7XszISmwPidTME3YU6+c/RUBXzjv7J2Sskj4Qb1K5E1SZEBzmin3uPwKS0
         NQZqJ5mT+FDTanImZHG8cfHtu2EjlIV8oY5qs8oGJfa9cnbVe4sZduLRPfi6cSSYacGP
         WcYkz0oHoHWKhEIlbuwi6ZTjnMugV4ERf9RWu1jbX2WWMdzMHW7o120SAXfNFzWZotrQ
         BpdQPqWzERqNsWZNwYQcOp61xqPeVUmEo4zRESMrXieRU54At/dX7CYHW8uqSza6k4/K
         ZqWhGiMPsl/hIkUZWxlYZFqpPSUeA1TiYVhNleMjiGNR6rBdVwGqmdyPojT8Abdjp8Jr
         9JYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=z5f9aZJUWrYWjBwlTTrNoDRWDOIdxd7l1qvuVBHpDxQ=;
        b=Ro2AAmDoVa1MZxSljx6f7UV8FH9Q+3K/0WkNnuB116gLm9kI+QTcLOQTEYrDUDKUJn
         cEv8PSpspnsKUKadavIHCNLkQn6dAlAq/+heWFoVYFpNUXGdHp7s3UmLAJrywY0AwZc/
         qHenehuBLAOGFcPr866DKrOIOHk9obEfdjSyMetmAT5S4DOhevlV8mtJ4wpQIqzc6OqC
         tjU7qnHPwvKx4XCWV7pcDSjmpz/J/jc5tFFmEIPycAJFQEvv+6F9QFQ+pym+SALnMnkB
         o0ZSjw+hzbvoC8JPal7kpGLcoN1hc3wYJxyDfj1js/KrR+RmzxlwEHw2/FKhKct8whAQ
         c+MQ==
X-Gm-Message-State: APjAAAV1Vp5xbuz5Cr1uKIhGwdBVYIDtOb2T5l+COY9C+2sq+xgf99CA
        quPJDp+jiSOuCFhhNzBbO90eVQaJ
X-Google-Smtp-Source: APXvYqy3eM9OGJ7Qsli1CyyfXcsVba+CwpWRcSqu5zNBLXoRWQpO54KG9TYPn0WDVDpf2nXoIpvmrw==
X-Received: by 2002:a1c:ba83:: with SMTP id k125mr341975wmf.106.1582568810387;
        Mon, 24 Feb 2020 10:26:50 -0800 (PST)
Received: from [192.168.43.177] ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id b7sm11665888wrs.97.2020.02.24.10.26.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 10:26:48 -0800 (PST)
Subject: Re: [PATCH liburing v5 2/2] test/splice: add basic splice tests
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1582566728.git.asml.silence@gmail.com>
 <aa79d4a192bd1a8e68beddfb177618c1cdacf381.1582566728.git.asml.silence@gmail.com>
 <56c83973-db0f-cc25-4b78-6c9a74431d2a@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <060087a8-a6c1-b44c-1b7c-3fc0de3a4a5d@gmail.com>
Date:   Mon, 24 Feb 2020 21:26:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <56c83973-db0f-cc25-4b78-6c9a74431d2a@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="PgiuQhw0exthb7WTWncotxEke0BjsfEnG"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--PgiuQhw0exthb7WTWncotxEke0BjsfEnG
Content-Type: multipart/mixed; boundary="ceZPB6kdPvOEc8OWHWoVfEkx9GkLSgbr2";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Message-ID: <060087a8-a6c1-b44c-1b7c-3fc0de3a4a5d@gmail.com>
Subject: Re: [PATCH liburing v5 2/2] test/splice: add basic splice tests
References: <cover.1582566728.git.asml.silence@gmail.com>
 <aa79d4a192bd1a8e68beddfb177618c1cdacf381.1582566728.git.asml.silence@gmail.com>
 <56c83973-db0f-cc25-4b78-6c9a74431d2a@kernel.dk>
In-Reply-To: <56c83973-db0f-cc25-4b78-6c9a74431d2a@kernel.dk>

--ceZPB6kdPvOEc8OWHWoVfEkx9GkLSgbr2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 24/02/2020 21:23, Jens Axboe wrote:
> On 2/24/20 10:55 AM, Pavel Begunkov wrote:
>> +static int copy_single(struct io_uring *ring,
>> +			int fd_in, loff_t off_in,
>> +			int fd_out, loff_t off_out,
>> +			int pipe_fds[2],
>> +			unsigned int len,
>> +			unsigned flags1, unsigned flags2)
>> +{
>> +	struct io_uring_cqe *cqe;
>> +	struct io_uring_sqe *sqe;
>> +	int i, ret =3D -1;
>> +
>> +	sqe =3D io_uring_get_sqe(ring);
>> +	if (!sqe) {
>> +		fprintf(stderr, "get sqe failed\n");
>> +		return -1;
>> +	}
>> +	io_uring_prep_splice(sqe, fd_in, off_in, pipe_fds[1], -1,
>> +			     len, flags1);
>> +	sqe->flags =3D IOSQE_IO_LINK;
>> +
>> +	sqe =3D io_uring_get_sqe(ring);
>> +	if (!sqe) {
>> +		fprintf(stderr, "get sqe failed\n");
>> +		return -1;
>> +	}
>> +	io_uring_prep_splice(sqe, pipe_fds[0], -1, fd_out, off_out,
>> +			     len, flags2);
>> +
>> +	ret =3D io_uring_submit(ring);
>> +	if (ret <=3D 1) {
>> +		fprintf(stderr, "sqe submit failed: %d\n", ret);
>> +		return -1;
>> +	}
>=20
> This seems wrong, you prep one and submit, the right return value would=

> be 1. This check should be < 1, not <=3D 1. I'll make the change, rest
> looks good to me. Thanks!
>=20

There are 2 sqes, "fd_in -> pipe" and "pipe -> fd_out".

--=20
Pavel Begunkov


--ceZPB6kdPvOEc8OWHWoVfEkx9GkLSgbr2--

--PgiuQhw0exthb7WTWncotxEke0BjsfEnG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5UFT0ACgkQWt5b1Glr
+6XXig/+I52yH0caE8JJTJs+LbiblMmX+2mV8oULw0KEcBOrCXp6/nSX4ZJ8ewAR
L66HXcbPpKyg/rSyxeEF7Zy3GGtlFrNacOQMnbggSwOBRTAzVA7m6IkOeW9fgjcQ
yt6NtMT+3DtDwDC886UiCiF3Ixfn068uU4ejV9xWpsiiKsGKXA9UxJFrYIt1JMM8
5gzgp+r9TupdeizXhRczAuj8/N4XXWU5soMLtrKiJQ4uJgD4vuo7TirBgcclDp2X
13EN+l6s4a51eGxFMCiNi6cYbeXBm0nl1DAO+LCYOxorYd0xD61/y6JetA1LV/no
OeYHaxffqeENPoVTEAxVnDQSDZwiwv6cKjH5LiIr6E1H8BK3AaJVeQf3cUNbsUNX
d7T2ETTLT9TvGd4YxP1Hke+fRU9XXf6jCd2QZgcRJ2YinW/f3NxcOkb3yt5JU5+r
xpN577CGDUhVPCaBCeBXQw5nU/eiW22+AEh43AgobqXCppM+eAf3o47d2iHismZG
fr6MtmXUftIYhWSdB2s4o2OuJZIEhlwYlQ3vgTki0DgVigAupbxQy1Ssll+aG3PS
Oe97y4IzefWmXNcLKXRU8uCAihR57XkddfsETiBjw47Fd0vmg0uru2bUsNsyRq2j
LaLEZqxGqCAWTqsw7/vzO5nCDT4AGOz4sC+LaEXqP1a0fMb8S4E=
=vgQo
-----END PGP SIGNATURE-----

--PgiuQhw0exthb7WTWncotxEke0BjsfEnG--
