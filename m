Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9D616AFA5
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 19:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgBXSsk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 13:48:40 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40419 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgBXSsk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 13:48:40 -0500
Received: by mail-wr1-f67.google.com with SMTP id t3so11636646wru.7
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 10:48:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=ckXOdGdsgFxwSQ2CjZwkikTp3dNG9uvKSnUObif+Li0=;
        b=bZ0tjsa1GYaN6w4udw7upGlebCNhTOICGpXYFo1Zyuk+WyGOl9o0BLt6pZ6OyD6WX+
         k/ulZ6unJvOk7NwDUo3YzTtQIL6HkJJdg/ol/kN4pGdDBRVHA+qFhIdFbmp3EdqK+tCl
         9WyOm3rJ3NTY2cd/jIXtyIFextoYlnFm2Zg7eP8Y6KIeS6v0KsEdILO2TwMdv1WetI94
         i+6ol+uMmVnRJ1SYYWA/GDH9pJDRLSZdDx21lok0wP5fLsN7ILYuBHQUQ2Xa9UaORqau
         5Qd6x/fDnErET5BjzLq0yZRXAlemi3RbeM+LWQLlNiJvX1OIkgOb5CwPOapra0kbx385
         5Vcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=ckXOdGdsgFxwSQ2CjZwkikTp3dNG9uvKSnUObif+Li0=;
        b=SfsKlT/TvCT35A66rVm89dBTVDwdDQ+a0k3izkEdQLuUds1xQq2MXDOe1y1/VooiN8
         zXcvyarwXvxDtVSXDjJWa52TAGTYEyRot4ZoM/IZYSgZHEvZyUd4QAM/1YQD4bcGM5+5
         qujqUzeZpZrBSy77zAmUYHwx5Gm6p0DEKcjZexEeo4bjon5T/P38T+g3eNgEeC2DSb8r
         l5KRTueZodU3/0yvvi0xw5wPRVEowiOJYy0ZU4GVSlXpUmktkOKuVdLzvClQ0D8tq/EI
         14bDHGdlf3ipOQ/w8wHGMDTCiLvj+NvC/BnAsrfPbkcaiogglYq05LSZiMfwNDjUyvKr
         N/eA==
X-Gm-Message-State: APjAAAUG2/bpQJFPPQv33+nI0Ax+c15gnXJy573oDKMpS1WgdbF9Xi2w
        2nkQHiAUnNAORQKSn1RGfShA4Edb
X-Google-Smtp-Source: APXvYqxnrXZtqNqLTtPLiszWedwWejT3DPt0/WTTfcIxJKPy6zr7nIqKzu5UVyb8uU8FffLbClMm4w==
X-Received: by 2002:a5d:4289:: with SMTP id k9mr70086323wrq.280.1582570117166;
        Mon, 24 Feb 2020 10:48:37 -0800 (PST)
Received: from [192.168.43.177] ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id l131sm405214wmf.31.2020.02.24.10.48.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 10:48:36 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1582566728.git.asml.silence@gmail.com>
 <aa79d4a192bd1a8e68beddfb177618c1cdacf381.1582566728.git.asml.silence@gmail.com>
 <56c83973-db0f-cc25-4b78-6c9a74431d2a@kernel.dk>
 <060087a8-a6c1-b44c-1b7c-3fc0de3a4a5d@gmail.com>
 <12eb524a-cc65-48e1-d82e-5e3d07ff444a@kernel.dk>
 <20e51d15-82d8-3e91-a1ca-36dccd9d30e7@gmail.com>
 <89272517-d4c4-1a0f-f955-af2b1c1a337f@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH liburing v5 2/2] test/splice: add basic splice tests
Message-ID: <c863a99f-aa29-4629-a959-53c584f4d2ed@gmail.com>
Date:   Mon, 24 Feb 2020 21:47:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <89272517-d4c4-1a0f-f955-af2b1c1a337f@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="x5qUnh5uel9d6KjA5RgVglXRKnTTqzlJL"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--x5qUnh5uel9d6KjA5RgVglXRKnTTqzlJL
Content-Type: multipart/mixed; boundary="yDe19ZAXCpZxJfWjIrOkHOHtTAdkYj5XA";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Message-ID: <c863a99f-aa29-4629-a959-53c584f4d2ed@gmail.com>
Subject: Re: [PATCH liburing v5 2/2] test/splice: add basic splice tests
References: <cover.1582566728.git.asml.silence@gmail.com>
 <aa79d4a192bd1a8e68beddfb177618c1cdacf381.1582566728.git.asml.silence@gmail.com>
 <56c83973-db0f-cc25-4b78-6c9a74431d2a@kernel.dk>
 <060087a8-a6c1-b44c-1b7c-3fc0de3a4a5d@gmail.com>
 <12eb524a-cc65-48e1-d82e-5e3d07ff444a@kernel.dk>
 <20e51d15-82d8-3e91-a1ca-36dccd9d30e7@gmail.com>
 <89272517-d4c4-1a0f-f955-af2b1c1a337f@kernel.dk>
In-Reply-To: <89272517-d4c4-1a0f-f955-af2b1c1a337f@kernel.dk>

--yDe19ZAXCpZxJfWjIrOkHOHtTAdkYj5XA
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 24/02/2020 21:41, Jens Axboe wrote:
>> I've wanted for long to kill this weird behaviour, it should consume t=
he whole
>> link. Can't imagine any userspace app handling all edge-case errors ri=
ght...
>=20
> Yeah, for links it makes sense to error the chain, which would consume
> the whole chain too.
>=20
>>> submit fails. I'll clean up that bit.
>>
>> ...I should have tested better. Thanks!
>=20
> No worries, just trying to do better than we have in the best so we can=

> have some vague hope of having the test suite pass on older stable
> kernels.

Have you gave a thought to using C++ for testing? It would be really nice=
 to
have some flexible test generator removing boilerplate and allowing
automatically try different flags combinations. It sounds like a lot of p=
ain
doing this in old plain C.

--=20
Pavel Begunkov


--yDe19ZAXCpZxJfWjIrOkHOHtTAdkYj5XA--

--x5qUnh5uel9d6KjA5RgVglXRKnTTqzlJL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5UGlUACgkQWt5b1Glr
+6VmTQ/9HFONmIo0ddZjz7OXLH8OzGpV0crebHL+QACy2T6CsNYv2x29CCn13x9Z
IQ4hQS32H1xe5p5ofXwyxAIGXLQhy43h74DRoVuDk72jRw1d0CZutXy3KJ1JdzZy
4qsx9P4FdCSC9mceaSq+cTXQY0DfH+vr1/BMOfOV6DoJm79+ev4c68m2inpM5/NY
KYHYyUpFjqMz7DNrb9rG/IvIQP5/xrSGpSbUEUsgBLUXfiM9Q03/HZP1Hm1eBcpF
Q5CbTMWWwF9I+/a7mEfaJXZmb8x8Bdsdo4t4aSRk3To+IDUvOwNuSLslwMZjum0A
gFufYxMVlXLFs9VosWwWiOavuRr+SwdTIJmxHkkzZRa69fGXvC6hGKaUKoinM7ne
0SawrASHzjuHWdGN3S+8h9Eb/bvOityZitXKkR4FTE2x9YtH8iQn13u850us+S4X
hssdZCmBpQDep6EfkbAGSRaVTim0rSwwpOM6AuKjvQ2OD+l/qXpzz30y4AfB+smR
1eDNRTKwlhMFsXTknt/cUqzZVdRRfQk91zBxYzAwYuypCNJaPT8JCQOx4o1YWBZX
T3L+cfi9vhsiYCdR4bYrGd5cWYhTk8CHMjtUqy19/f6YoyWheK0Jrtvg6Cr8DQsn
dewA+o93r2Rw2EddsgJhdZZK27q8YcdtbrPeQ/KPYh2R2K6YZrs=
=R3vW
-----END PGP SIGNATURE-----

--x5qUnh5uel9d6KjA5RgVglXRKnTTqzlJL--
