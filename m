Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79DF312BE80
	for <lists+io-uring@lfdr.de>; Sat, 28 Dec 2019 19:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfL1SiO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 28 Dec 2019 13:38:14 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45337 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfL1SiO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 28 Dec 2019 13:38:14 -0500
Received: by mail-wr1-f66.google.com with SMTP id j42so29068582wrj.12;
        Sat, 28 Dec 2019 10:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=PHOeEawu9NS3AXxKMeLUGvZiLduDzMn9YS6DrZ7f08g=;
        b=OQC0yg/tIiskBb4tNUumQ9DVlCgxMeEU14J45w31o9Ho7htYhxUvTFisoTcxCYK/Ln
         NdQzrJk8aGoh0ItByX9OHrv3BDfEOCVDR7MyV29hJjHF11BXPlblqIy/d64WXBJUkdL4
         1Ct9ocLdZNLYAOqN1qHXanNVnB0Qp8AUh+DD505LtTcYgHkqoOvPpiUQ8a/nSQvuwCMi
         adrQr5twX6NLC5WpAffjov+8FeywVluPPtjaNLzjOPlqV86T5IbgpB1KIO6WwihQD4wG
         /dAG3ZPPl/t7acgpT5EhCSjTCYbxrArT4tT6bsF/Pa0UZcrUFNCGU41ct+7DxDd+oqSW
         a9OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=PHOeEawu9NS3AXxKMeLUGvZiLduDzMn9YS6DrZ7f08g=;
        b=PHXVkICAvFs8CXeqV8QDazENQTrb78ufzS90QBZuamvqz4qUX4XWX17aeiPFm4sIwo
         jSIc0barOW5sZPEPxSeTWTim7kMS+ZEwaKx2g0skprNt5Pj2ruWA0ZfBOXPJJ2wuJEbT
         xHC4CyQyqYzkBiQ9SybxI3BOLter7rJUISnpjugrsXkSDutpzOp4NB8kHwHZIlQG7QPZ
         zOIxrkXrR94liZnc0YY/5xW1i86QunE+AN9PJCjLcaGoWb+I1aSCxCoctGBwdA+enjKa
         8Fyw7zjahUrkEBquX7Tn10+q7yfVZFz+YTxge23IcPO6Z8EBygMZ0FDzKYmTPfQTS7ff
         qbQA==
X-Gm-Message-State: APjAAAWwV1FL68UKv5/bFYhfOMJN8Gd8Ct6lVq2zTDWjecZP06KJ6ko4
        Idw7AwU5aud4dOjM8pY3rDyJIJ08
X-Google-Smtp-Source: APXvYqzobx86d6Sk0gkMIfybMdVJgB9tmkShN5vOg4ukaZQx6krfgeRLKpTcOK7blH8hgZM7SjmKoA==
X-Received: by 2002:adf:ea88:: with SMTP id s8mr57180104wrm.293.1577558290807;
        Sat, 28 Dec 2019 10:38:10 -0800 (PST)
Received: from [192.168.43.144] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id g21sm41528722wrb.48.2019.12.28.10.38.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Dec 2019 10:38:10 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1577528535.git.asml.silence@gmail.com>
 <1250dad37e9b73d39066a8b464f6d2cab26eef8a.1577528535.git.asml.silence@gmail.com>
 <6facf552-924f-2af1-03e5-99957a90bfd0@gmail.com>
 <e0c5f132-b916-4710-a0f3-036e4df07c69@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v4 2/2] io_uring: batch getting pcpu references
Message-ID: <504de70b-f323-4ad1-6b40-4e73aa610643@gmail.com>
Date:   Sat, 28 Dec 2019 21:37:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <e0c5f132-b916-4710-a0f3-036e4df07c69@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="t9ctzqBRzP4D9MKIOgpTUF8FvHFYG1yii"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--t9ctzqBRzP4D9MKIOgpTUF8FvHFYG1yii
Content-Type: multipart/mixed; boundary="AOpYBePRNpzxeu4k7pNRjvAYfYH6roqtN";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <504de70b-f323-4ad1-6b40-4e73aa610643@gmail.com>
Subject: Re: [PATCH v4 2/2] io_uring: batch getting pcpu references
References: <cover.1577528535.git.asml.silence@gmail.com>
 <1250dad37e9b73d39066a8b464f6d2cab26eef8a.1577528535.git.asml.silence@gmail.com>
 <6facf552-924f-2af1-03e5-99957a90bfd0@gmail.com>
 <e0c5f132-b916-4710-a0f3-036e4df07c69@kernel.dk>
In-Reply-To: <e0c5f132-b916-4710-a0f3-036e4df07c69@kernel.dk>

--AOpYBePRNpzxeu4k7pNRjvAYfYH6roqtN
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 28/12/2019 20:03, Jens Axboe wrote:
> On 12/28/19 4:15 AM, Pavel Begunkov wrote:
>> On 28/12/2019 14:13, Pavel Begunkov wrote:
>>> percpu_ref_tryget() has its own overhead. Instead getting a reference=

>>> for each request, grab a bunch once per io_submit_sqes().
>>>
>>> ~5% throughput boost for a "submit and wait 128 nops" benchmark.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>  fs/io_uring.c | 26 +++++++++++++++++---------
>>>  1 file changed, 17 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 7fc1158bf9a4..404946080e86 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -1080,9 +1080,6 @@ static struct io_kiocb *io_get_req(struct io_ri=
ng_ctx *ctx,
>>>  	gfp_t gfp =3D GFP_KERNEL | __GFP_NOWARN;
>>>  	struct io_kiocb *req;
>>> =20
>>> -	if (!percpu_ref_tryget(&ctx->refs))
>>> -		return NULL;
>>> -
>>>  	if (!state) {
>>>  		req =3D kmem_cache_alloc(req_cachep, gfp);
>>>  		if (unlikely(!req))
>>> @@ -1141,6 +1138,14 @@ static void io_free_req_many(struct io_ring_ct=
x *ctx, void **reqs, int *nr)
>>>  	}
>>>  }
>>> =20
>>> +static void __io_req_free_empty(struct io_kiocb *req)
>>
>> If anybody have better naming (or a better approach at all), I'm all e=
ars.
>=20
> __io_req_do_free()?

Not quite clear what's the difference with __io_req_free() then

>=20
> I think that's better than the empty, not quite sure what that means.

Probably, so. It was kind of "request without a bound sqe".
Does io_free_{hollow,empty}_req() sound better?

> If you're fine with that, I can just make that edit when applying.
> The rest looks fine to me now.
>=20

Please do

--=20
Pavel Begunkov


--AOpYBePRNpzxeu4k7pNRjvAYfYH6roqtN--

--t9ctzqBRzP4D9MKIOgpTUF8FvHFYG1yii
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4HoPUACgkQWt5b1Glr
+6Xrnw//R7brCauiKjhtlJvljHOa9SGoc4hUdcITQOE73pGhToWRC1mZTTGot+tD
+KOTV6zmJzOrrMfJ6h8soEt6YUprDUFGeYIZ8xZvB+BUwQn/JqgoDmt//v4nDEo7
siWOMNBWTW2i62BR4XmVKdGaZoxtXtY+Gwj6Ci0kJJfmhKfYksf+m8Dk14GwWRZ8
RPr1PMIYjOcCqbUOd5cicR1wReBylrnDnV1A6OdEQmf2CK/Y7K1Ra9HsTLyyI8n6
/di9p4uDUP8T13sNRS32G4dtH962r9mQvexFNw5X2qAjPUdA53Ndiig+1EB/xe03
Bp6tM6IqhX58uE9n0hbpSRSrDW/kCoweF2hFFmwMUZipvf2pl+FcM5o72Ykv3EgW
pTfl5h7anzEopWVG3Nu6wNuYKn2JG7IYufRx07U6laWZv1GXdr7ZBE3vG1H1x6d1
tZxwOZi+lIf/xg8C6mcHwKEqmq4mVyJfOyvKH1yAWCAki34wcBwZHp93vckQc13f
shL+eJeFRTSzr+35NyA+LNcKTLOYaFX4ja0Wf9tnqlUF7qp4auxs46cY/WkiqTou
H5CTk5wUEFqJqmdATvJ5Fao0qXW33SXFi7bMlWvTyB4aRG8JpwF9ewnYcKj+Z77z
xBoNXzQBjlv9Mhv+6Cm7IeR147iFWUb84RP9RJ8cbBHIM6Yg6QY=
=ALlr
-----END PGP SIGNATURE-----

--t9ctzqBRzP4D9MKIOgpTUF8FvHFYG1yii--
