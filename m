Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D164E16AF64
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 19:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbgBXSkK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 13:40:10 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46937 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727426AbgBXSkK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 13:40:10 -0500
Received: by mail-wr1-f66.google.com with SMTP id g4so5274828wro.13
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 10:40:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=sVZDe3izH6pquur68t5ZbtvV7aoNxbUDQe57S/zTZFY=;
        b=Q3or4UGODJ4u34I7pZWb9JlW0+2YaKOTlBpMpnOj24SbIATaqUR4tlEonyBrwEAktT
         g9F72s8+gzcBOQuPFwPhSU5iI5NxPFsk7WsZ7Dj356XdTd5D3CAAeAnuAGY4YGAcsdTP
         cGkZzwUgGGk9sU1oF91r5MeJ21v8MeQ7WT3XPrpbkifLgyMnIrNGPpFLuU26QkA9xxzQ
         hmdbMs0nm8XnCglFuIlro1QNoihcd7E/LeD42GcZUb9bNL8bZxU6lIaBa9AkHsBM2so2
         cWCG2ivVJZMYnhmYci3JhQC+sNKLHTBULfMyzjX8YmPZ17tdbGYhPphFwWorot3BpFN2
         FZvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=sVZDe3izH6pquur68t5ZbtvV7aoNxbUDQe57S/zTZFY=;
        b=uCFPdpDjbMTB46pyt/BGsnrEDzPdAD3yIH0pfiryo1F94HlkNvJLgKee27ea8GQvOq
         S/pAxef2IMfJbwK/sQmxVEo/PzTT/N/IObEQS1pNGl+/Xh5RjuDMunPXbBwRnEYktLJo
         UxVe4n50I70ReMksM08bx/h98ZyN1g0HH5EDseJLbMl+UmyXX5HH8+N7NgqtAkQwdp91
         NoXEzeiC9cN9Uc+WUAPNDvljECuPJ1Iieu6pMCHzupJCkrKOus0Opuer6QNXQ7uZoeSh
         D4+t1cAhN88wLwWW9Czq2keVYeURqz/kQF9y2pYtgGmd4Vy8wSQmhZUbjWSpNDJroFPb
         xl3Q==
X-Gm-Message-State: APjAAAU6MQGkO1DOoQ+V8XELd2cOt42sS7q8ENHUMmzlyf8QvfvdTpu4
        xSn6VSeAMxWVv22Y6ZE4+VFBCv1M
X-Google-Smtp-Source: APXvYqxi11uQ2Ugd4DeItUeguHFDrFla11GTQmw/0loXh806G9jV6uUOgcLi+2IBoMVzKpvcvdk3ow==
X-Received: by 2002:adf:edd0:: with SMTP id v16mr66932059wro.310.1582569608579;
        Mon, 24 Feb 2020 10:40:08 -0800 (PST)
Received: from [192.168.43.177] ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id o4sm19160647wrx.25.2020.02.24.10.40.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 10:40:07 -0800 (PST)
Subject: Re: [PATCH liburing v5 2/2] test/splice: add basic splice tests
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1582566728.git.asml.silence@gmail.com>
 <aa79d4a192bd1a8e68beddfb177618c1cdacf381.1582566728.git.asml.silence@gmail.com>
 <56c83973-db0f-cc25-4b78-6c9a74431d2a@kernel.dk>
 <060087a8-a6c1-b44c-1b7c-3fc0de3a4a5d@gmail.com>
 <12eb524a-cc65-48e1-d82e-5e3d07ff444a@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <20e51d15-82d8-3e91-a1ca-36dccd9d30e7@gmail.com>
Date:   Mon, 24 Feb 2020 21:39:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <12eb524a-cc65-48e1-d82e-5e3d07ff444a@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7Apoe7RavE2yFIiVj1pnFxSKhGAbMGMcH"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7Apoe7RavE2yFIiVj1pnFxSKhGAbMGMcH
Content-Type: multipart/mixed; boundary="aEYFopg99VdTZ8rCdjZFX1pK0acWh0wcb";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Message-ID: <20e51d15-82d8-3e91-a1ca-36dccd9d30e7@gmail.com>
Subject: Re: [PATCH liburing v5 2/2] test/splice: add basic splice tests
References: <cover.1582566728.git.asml.silence@gmail.com>
 <aa79d4a192bd1a8e68beddfb177618c1cdacf381.1582566728.git.asml.silence@gmail.com>
 <56c83973-db0f-cc25-4b78-6c9a74431d2a@kernel.dk>
 <060087a8-a6c1-b44c-1b7c-3fc0de3a4a5d@gmail.com>
 <12eb524a-cc65-48e1-d82e-5e3d07ff444a@kernel.dk>
In-Reply-To: <12eb524a-cc65-48e1-d82e-5e3d07ff444a@kernel.dk>

--aEYFopg99VdTZ8rCdjZFX1pK0acWh0wcb
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 24/02/2020 21:33, Jens Axboe wrote:
> On 2/24/20 11:26 AM, Pavel Begunkov wrote:
>> On 24/02/2020 21:23, Jens Axboe wrote:
>>> On 2/24/20 10:55 AM, Pavel Begunkov wrote:
>>>> +static int copy_single(struct io_uring *ring,
>>>> +			int fd_in, loff_t off_in,
>>>> +			int fd_out, loff_t off_out,
>>>> +			int pipe_fds[2],
>>>> +			unsigned int len,
>>>> +			unsigned flags1, unsigned flags2)
>>>> +{
>>>> +	struct io_uring_cqe *cqe;
>>>> +	struct io_uring_sqe *sqe;
>>>> +	int i, ret =3D -1;
>>>> +
>>>> +	sqe =3D io_uring_get_sqe(ring);
>>>> +	if (!sqe) {
>>>> +		fprintf(stderr, "get sqe failed\n");
>>>> +		return -1;
>>>> +	}
>>>> +	io_uring_prep_splice(sqe, fd_in, off_in, pipe_fds[1], -1,
>>>> +			     len, flags1);
>>>> +	sqe->flags =3D IOSQE_IO_LINK;
>>>> +
>>>> +	sqe =3D io_uring_get_sqe(ring);
>>>> +	if (!sqe) {
>>>> +		fprintf(stderr, "get sqe failed\n");
>>>> +		return -1;
>>>> +	}
>>>> +	io_uring_prep_splice(sqe, pipe_fds[0], -1, fd_out, off_out,
>>>> +			     len, flags2);
>>>> +
>>>> +	ret =3D io_uring_submit(ring);
>>>> +	if (ret <=3D 1) {
>>>> +		fprintf(stderr, "sqe submit failed: %d\n", ret);
>>>> +		return -1;
>>>> +	}
>>>
>>> This seems wrong, you prep one and submit, the right return value wou=
ld
>>> be 1. This check should be < 1, not <=3D 1. I'll make the change, res=
t
>>> looks good to me. Thanks!
>>>
>>
>> There are 2 sqes, "fd_in -> pipe" and "pipe -> fd_out".
>=20
> I must be blind... I guess the failure case is that it doesn't work so =
well
> on the kernels not supporting splice, as we'll return 1 there as the fi=
rst

I've wanted for long to kill this weird behaviour, it should consume the =
whole
link. Can't imagine any userspace app handling all edge-case errors right=
=2E..

> submit fails. I'll clean up that bit.

=2E..I should have tested better. Thanks!

--=20
Pavel Begunkov


--aEYFopg99VdTZ8rCdjZFX1pK0acWh0wcb--

--7Apoe7RavE2yFIiVj1pnFxSKhGAbMGMcH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5UGFoACgkQWt5b1Glr
+6XMAQ/+MdewM52fbSMCdlqDG1pfX5nrb+A198wtLPOgg/ww5Qu+6IW5KFTN9Ynq
XW6yYRgN/B2hL+J/3/NRelB8BExLnqC9YthNOXMDqjSKwsqiTbPjCKFUU4dM1EjH
wEHnNEO9FJnALVkYQ6bY/YbjfRMlfuFhi3WaTPID7XCt0Zi2xhJFbNI1C+sg91h/
M1UBY3qPJnXeM7y5vM0zudH6I2nHwGSAFH/izGrKOkzX0ajuaKfpN4Dg7rhuSpt+
cRbYmfPk9JJJZG2PLHxP4gF8NrbBlHDpCLhuhIKNphLiX5ZoTCYw1bXsx9vBoZst
EKf78imc7jxgABrFD4CeBcu1WiqwStWxIYO5FRYCasPYu+Sc5FG0yb59tO9wQtBG
fflhCx1fJpEESvwK8K4vwYUB3jM0RDx3gscM5YCguducskKkuda4XnyPGhPndfiH
xc08+pgtrRqcipkXyqqnl01cUz1s0e0I8wlFU2Mnb9yjdSP+f6FAtXdkfCCleArj
y7ZwqQO0bQ09qxlnleJx+5zHCdHwl+CroOG2yV0lqyb9pNK5YLFSQwT7ofAM4DYB
NsTfqhsZTMxRnNFIbGW++hJBBk6KBpS0Ez3ZnCQFc0zE6WYyDP8F/dX0tux8126t
Lp48XdXNfbLPmhtCb8WnUltnpSqQAlGsfuJvjbDXqeGzg+Se6y8=
=4SRI
-----END PGP SIGNATURE-----

--7Apoe7RavE2yFIiVj1pnFxSKhGAbMGMcH--
