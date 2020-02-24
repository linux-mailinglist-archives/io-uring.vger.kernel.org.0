Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52AEE16AF3C
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 19:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgBXSd7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 13:33:59 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33299 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbgBXSd6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 13:33:58 -0500
Received: by mail-wr1-f66.google.com with SMTP id u6so11636957wrt.0
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 10:33:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=8fgwK/RxIA62ZhQnmNwFQg4KLufDZNiQl4ABIfYQapI=;
        b=jqlB4Cw7myx1XrDdhvXWWyw8XGpmnB579Ge1xPNvhEQFr9iBxDZ5VDJnQIANkoo293
         7mqv9RTswXXKRbabiTRcEZ4YWlzNFyg9SQ1DbkyELS+Tjox7T6sYYGxgU+ckZoWxbLKp
         5lql0XtnvRvKzRaGhPxO9o5Fdo2iPRj+5GjnGzwv+dPlz0zET94NlfSu7apibH7QmC/Q
         ijxNIcFk8jzPVqMU2jzQyKGIcWRyjRc9aZv/7ajOijoEKUyHVkF8SVrulqZHoQXwBiKw
         JhHw+Z8iZUimkpU1VtRnHoQMLO9oMN0BfiGSn5V0rzfkKmLtD+xHRrTS44Uo90kV8Xaz
         kv3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=8fgwK/RxIA62ZhQnmNwFQg4KLufDZNiQl4ABIfYQapI=;
        b=Pk8C/qdeBEXfeCdrv9kOeMO8tuvs9+qjvs3irs9HGTGZZSeKE2chKwXfSiq7+XT7yj
         48DJU5CwwpP1MX0W9LA9UVKinJkqDmHAp5KwmhSkveRQvD26PU6n1IMgRTw07/Qb9Zba
         TfQX8rgOGTTj/nn7tqxt12wt8vDoCdFQNe9sgBi8OzFcZqU+g+VrC0Gh/edoCqYxeO1v
         jfBRAluMM5gxvVt9SGvCz4euZaLDiGwYhRnMwuXtRbsIwkwFhwqWA40nCYT93ECXUeNv
         pP91T3dQCGxvsLPaEE7Ek5r/AgfyEH6rAifPbe7ugiuYLWHLPI8Ao3E0WP4q+r16RIqU
         YR7g==
X-Gm-Message-State: APjAAAVY4ogLY4tVdlbIcsl6iOUMY4MqB7m7hVn1QlVYkv7WI1h0dtwb
        +H2uUzgxyRBdrYyrFoNmVgGSzXbl
X-Google-Smtp-Source: APXvYqzMPPK5TdSJX200/mfbIwUJo4805LUgBbvXtZMR7mtld2SzvPAL8BtZIskrv6xVe5bux8rfHQ==
X-Received: by 2002:adf:f6c8:: with SMTP id y8mr67015916wrp.167.1582569235973;
        Mon, 24 Feb 2020 10:33:55 -0800 (PST)
Received: from [192.168.43.177] ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id q9sm20575512wrx.18.2020.02.24.10.33.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 10:33:55 -0800 (PST)
Subject: Re: [PATCH RFC] io_uring: remove retries from io_wq_submit_work()
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <843cc96a407b2cbfe869d9665c8120bdde34683e.1582535688.git.asml.silence@gmail.com>
 <295a86f4-6e70-366a-e056-33894430c7aa@kernel.dk>
 <f880f914-8fd4-2f11-a859-a78148915699@gmail.com>
 <abe952ad-54d8-1d18-7fe6-6a7f1666b7e0@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <e11dbcc8-3986-73cd-3cc8-289adf87f520@gmail.com>
Date:   Mon, 24 Feb 2020 21:33:08 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <abe952ad-54d8-1d18-7fe6-6a7f1666b7e0@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kzPYkzonS5jh8hUz1bzpdy6HFilQdvotF"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kzPYkzonS5jh8hUz1bzpdy6HFilQdvotF
Content-Type: multipart/mixed; boundary="yAEbbSWxb05pCtCythePJPem0J8gxK1eY";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Message-ID: <e11dbcc8-3986-73cd-3cc8-289adf87f520@gmail.com>
Subject: Re: [PATCH RFC] io_uring: remove retries from io_wq_submit_work()
References: <843cc96a407b2cbfe869d9665c8120bdde34683e.1582535688.git.asml.silence@gmail.com>
 <295a86f4-6e70-366a-e056-33894430c7aa@kernel.dk>
 <f880f914-8fd4-2f11-a859-a78148915699@gmail.com>
 <abe952ad-54d8-1d18-7fe6-6a7f1666b7e0@kernel.dk>
In-Reply-To: <abe952ad-54d8-1d18-7fe6-6a7f1666b7e0@kernel.dk>

--yAEbbSWxb05pCtCythePJPem0J8gxK1eY
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 24/02/2020 21:16, Jens Axboe wrote:
> On 2/24/20 8:40 AM, Pavel Begunkov wrote:
>> On 24/02/2020 18:27, Jens Axboe wrote:
>>> On 2/24/20 2:15 AM, Pavel Begunkov wrote:
>>>> It seems no opcode may return -EAGAIN for non-blocking case and expe=
ct
>>>> to be reissued. Remove retry code from io_wq_submit_work().
>>>
>>> There's actually a comment right there on how that's possible :-)
>>
>> Yeah, I saw it and understand the motive, and how it may happen, but c=
an't
>> find a line, which can actually return -EAGAIN. Could you please point=
 to an
>> example?
>=20
> Just give it a whirl, should be easy to reproduce if you just do:
>=20
> # echo 2 > /sys/block/nvme0n1/queue/nr_requests
> # fio/t/io_uring /dev/nvme0n1
>=20
> or something like that. It's propagated from the kiocb endio handler,
> through, req->result at the bottom of io_issue_sqe()

I see now, thanks! What a jungle

>=20
> 	if (ctx->flags & IORING_SETUP_IOPOLL) {
> 		const bool in_async =3D io_wq_current_is_worker();
>=20
> 		if (req->result =3D=3D -EAGAIN)                                    =20
> 			return -EAGAIN;
> 	[...]
>=20
>=20

--=20
Pavel Begunkov


--yAEbbSWxb05pCtCythePJPem0J8gxK1eY--

--kzPYkzonS5jh8hUz1bzpdy6HFilQdvotF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5UFuQACgkQWt5b1Glr
+6XmWQ//Z9zSJzt3nd4cjAV1Q77gzzscwJ5RVloO7Rgbg9INHuC49sQJhJUieLza
7tfPV9fGR6OAEjggHfRQYZXCOMsrjNAIvqf2oudIUFpeT+5WzBQH6t4k7iUEcgml
wlrIPNxwxW1+DGKy0ba44+wu6lrMYRXhHoHwGDcQtOz0Hr2D0q/Rr5ITRLiIjng3
fWNTMTI97PbTM3ZiDLtThog+CERrAMQncPqBWHM5qvSQjg7cb1euzQoCt3CVm2AO
TVFVG9m0DIfGzXwKLFViXALZlY4ufAPjt8pcCS2zsLNnCcuei9eaokpWD07560Ji
nyAUBvmxI4v06Ei6NQ4jhSEI5Vr95pBrGoKLHEy3ClmOAwDQhZRaChJ8qdlmQtRP
/oX1Qhsh8HOthA0z3Ip0QP8Nqfmu9tq89aBb8ssv2LjmuspAtkViw3VJrdQWFZEu
VQwqTXzF3Jt/F7ScDv2z2j+3x6xgIQwB6EZ2zwDDKsoVR04WuEobL0miU1mFIznD
kS15bpeOtk+NxJQGGa2GIoQiWKhuvKdsUCX1693Zfb1nDhs574yXDcP7YG82XWxP
+YeAwQt0DueSeK1iUYfyt4knq6LHRNlGWkzn+vwKGXr5gbUQElPI4THSczHwkQhu
CGpeml4WQB5zj1Av8rnO2uPGUVniD+I9L2pCtkn3eXCuExViAzE=
=aXN9
-----END PGP SIGNATURE-----

--kzPYkzonS5jh8hUz1bzpdy6HFilQdvotF--
