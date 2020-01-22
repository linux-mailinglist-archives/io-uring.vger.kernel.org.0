Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAD53145CF0
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 21:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgAVUOx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jan 2020 15:14:53 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37022 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbgAVUOw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jan 2020 15:14:52 -0500
Received: by mail-wm1-f65.google.com with SMTP id f129so72191wmf.2;
        Wed, 22 Jan 2020 12:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=4r4Tmxnw3LbafpC92Ph5QpjgF1OHfWHAwGfWwRbzrfw=;
        b=LieDZmqYvLmMVqwWRreIhD6al+RGDkix4pWagL4naCydcKEV+l00bMprhwgzdNyztm
         T/hDLK3dDOlqrCOfEUwDUgXreKlktyqMi15eJQYoVjc+Djn7Hd/0OkwPqOlE//Gj4CBu
         PlvolDDc7WeIjH6RwuAP8FpuYeDu0jr+KnSt+CiX5t1XXh6dyHimJvIDeTNusOiGf7ml
         ItYL21cAcKZtLtGGAkzmVWvrNuKApKh+l4qboLnXggZXyIth32uuzTKIE70XnqUI6tMY
         G8i+aMrTo+BXvlmhIRNp4EbSKnqa+CMy77ec/5srEMywxr0P8Q/DO3Qjqo/b5b7ZIr2z
         66qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=4r4Tmxnw3LbafpC92Ph5QpjgF1OHfWHAwGfWwRbzrfw=;
        b=qsbR5F4Rqy/FrQcsL7OPXWgi6vyaLR3B7nuWs8PcTzsafvLQNxCGi59o7rqjJc6nig
         0UH3P3BPmukwkA8QSKXW9lHrZKoJJHJNhdBvME7lM3ebwdfdE1fVgFV3ym7ZvoYiw/b5
         +Qc1fnV+ThwC6gSEJHlfSDoctxsef07MuK9khfSri947g01D25tlj3tXsgJboWj7TG16
         qarfE9FqHOnTH7ruKT7vRs3j2Yl8hL/1oudVunWXowjJ/6PR7izvEO7czAiL4JNYcJ8+
         mHTBckdiCJadlOH+6kjp3r9hEishP+Sh8uhMDr3+Xuh4TS2TSOD7t4Fn7zP3LHRF+M6A
         qqMg==
X-Gm-Message-State: APjAAAW9M7INSOcneAvIxH7P6lMWLuZ+iL1R/g8RDzx2v7v3F7Um4OF3
        YxRxuhRYB5jMwImr0xEMikyWMQQj
X-Google-Smtp-Source: APXvYqwLQZAHC5m5IJSdyDTSQuhOjmGlOLrzXgKqm5zR+hkr07AkYiK3U+uFEEDuJFjZhjHMlESh/g==
X-Received: by 2002:a05:600c:34b:: with SMTP id u11mr6904wmd.69.1579724089473;
        Wed, 22 Jan 2020 12:14:49 -0800 (PST)
Received: from [192.168.43.234] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id t25sm5452978wmj.19.2020.01.22.12.14.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 12:14:48 -0800 (PST)
Subject: Re: [PATCH 0/2] IOSQE_ASYNC patches
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1579723710.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <d22d253c-48cc-bc77-138e-9922b64f74e2@gmail.com>
Date:   Wed, 22 Jan 2020 23:14:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cover.1579723710.git.asml.silence@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FB5bJCUQHSkEGIZJe8BIcuXZUFUjENz7N"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FB5bJCUQHSkEGIZJe8BIcuXZUFUjENz7N
Content-Type: multipart/mixed; boundary="1pUjGsyKUbc0oTXDddMjqNdAISzkLfLIM";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <d22d253c-48cc-bc77-138e-9922b64f74e2@gmail.com>
Subject: Re: [PATCH 0/2] IOSQE_ASYNC patches
References: <cover.1579723710.git.asml.silence@gmail.com>
In-Reply-To: <cover.1579723710.git.asml.silence@gmail.com>

--1pUjGsyKUbc0oTXDddMjqNdAISzkLfLIM
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 22/01/2020 23:09, Pavel Begunkov wrote:
> There are 2 problems addressed:
> 1. it never calls *_prep() when going through IOSQE_ASYNC path.
> 2. non-head linked reqs ignore IOSQE_ASYNC.

Those two are intentionally short for quick fix up. I'll prepare somethin=
g
prettier on top of that a bit later.

>=20
> Also, there could be yet another problem, when we bypass io_issue_req()=

> and going straight to async.
>=20
> Pavel Begunkov (2):
>   io_uring: prep req when do IOSQE_ASYNC
>   io_uring: honor IOSQE_ASYNC for linked reqs
>=20
>  fs/io_uring.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20

--=20
Pavel Begunkov


--1pUjGsyKUbc0oTXDddMjqNdAISzkLfLIM--

--FB5bJCUQHSkEGIZJe8BIcuXZUFUjENz7N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4orRAACgkQWt5b1Glr
+6U4QQ//c3F9cpSZrexGRo1WzGk+wTv9b6IB8OcMUz8VC5BJWAAoXjGZ21OL0fXq
+wrbxZxfRfyEx9EJcerqXvqOdwNrpGVICGiyHCe86L27pmcrh2sSkY97AGQ/whvC
WnlKLnDyQkGmmdhOG5gUzFWXFKeNin1qCmP1/u5faQEjFLoxImDdoF+Ft6CjGIFc
yaUqfLuc+7zcdj1WhnvvRFNSc5QbfbJJ2xcGtLMTGjil8aJtxit13jiwsOyovSJz
OF+OBE2Feyr+h3fD2c+jqRAvmEDTGzQIs6EdXgUCpxvYVt0BMtXEjtI+hoHSYZ7M
DF86NzvCKcYuFjMX2q678ycF7+jn2uaJEGQdgNADRrvmd9vcd7Z/j+KP16jX2dO6
JOoWeALU9qhn6P5Trjpzzv3ssDoS0qUWdGjIUuhAQDcbgrDBOZtV1O6RaIBA1WOI
BzjzAwboZvg2EFWkXDmNOc8NE6xVxBa/evTQFdXFuAedwfW6PMRBLL11D9kpcx7L
jBifZYqPt/yPTVu2B65phChe7nZwKbcZr0xVpefnkTTKm/yULViLnrrD6My95QtV
X/K7shAjrZ67YHQmjsLKLsb/galIaZRs+mN2AO5oS4pWu+G05zmK9RXr+9qHoku4
a/tK1VozQpoEyk+N/RWKg/6/P4pzBBQf5Glf/jgUtMm8EoB4tFY=
=aSwU
-----END PGP SIGNATURE-----

--FB5bJCUQHSkEGIZJe8BIcuXZUFUjENz7N--
