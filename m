Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D108A154C8C
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 21:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgBFUBY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 15:01:24 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39946 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727703AbgBFUBX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Feb 2020 15:01:23 -0500
Received: by mail-ed1-f67.google.com with SMTP id p3so7292929edx.7;
        Thu, 06 Feb 2020 12:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=dHCJ0GU/k0LUdkJwFuDS6GhRaKd1FNUzW7NwvfeeXB0=;
        b=E0yrswrabqrewEdIDTm0t4cqtbm9lQhJsgJQFJWJzVS2op9NSicOVFxg7JgBA38KZZ
         IBBUUagOBSY7jhF4LC3WegnsMB43ZWmkyVeBB3tYVP1/zZlFYjrnbaFRdfEwecwTgkaJ
         5ZFraI/b4Zh+ljvTRSVI21yjzP2+obMS7TcX2I3WybhAuvYJifkbbytTuw/DS0pvnwb8
         L5//4P3Dn2G0Y53RLUXOajmWNKyBqmpqgy/PGNU8/UmkKhv5yA3+kTtoMPjRikJHKjGx
         NQr2oniBNpJUnnnP2amhApChBxa9EqtTXzHI/FGQ6Z4fO71eTU1oNDi7mnCCjpQTaJkA
         v1PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=dHCJ0GU/k0LUdkJwFuDS6GhRaKd1FNUzW7NwvfeeXB0=;
        b=YhZxqLZcaZrQC8sVd+GgYOZUAgdE2NXjdvDj/rnn51eolGTIu5wspfRIaTBnhLQbTq
         s/jVJFAqquQgdl89tZw/TDwE3nKRjVViZ3aHIT1GDPgmJPonjNby9urMNKf9YBh9enMz
         rwgB39ARh5iuNYJaFcokvnimk3nGa3Bd75b+1k4QJYdn7KUSL42rhL+ix7Dlk0TC+qBG
         x8XsoATe/DXzoNsYD5e1zMERXClHnWpLNqOJ2fA7E0JYthndyYwyZaL9j9apLb9GrT07
         IqLflzCpE2+9F4UsqUwrTVtz7q4P9N/EErZ3AxHAaVC91m0XKKNxDAqKyg3q9uFlUtNW
         MTfw==
X-Gm-Message-State: APjAAAVwc/ITz5k91kkm7MGDDYXke+yllsJ0GyYGW32y1gilRtCtxzcU
        A/ZU0MZGSjjN/V/mGyVQAf+xyb7S
X-Google-Smtp-Source: APXvYqxItguTKiiQjR1DM7f48/kWCVSlXB7sunyAm9OMNBzHG9TurfQse8T/Xv0bYlkrFEdHAQf2AA==
X-Received: by 2002:a17:906:5606:: with SMTP id f6mr4933676ejq.179.1581019281108;
        Thu, 06 Feb 2020 12:01:21 -0800 (PST)
Received: from [192.168.43.191] ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id cm24sm38600edb.59.2020.02.06.12.01.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 12:01:20 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix deferred req iovec leak
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <e143e45a34dce9d271fc4a3b32f7620c5a7377c1.1581007844.git.asml.silence@gmail.com>
 <d8486857-ccd3-41bd-2ef7-5ac4781dbd5f@gmail.com>
 <f6a1d5aa-f84d-168e-4fdf-6fb895fc09df@gmail.com>
 <6e7207b6-95c4-4287-5872-fb05abf60e88@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <4f7f61d3-b3f9-43db-ad32-ee502dc06c8b@gmail.com>
Date:   Thu, 6 Feb 2020 23:00:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <6e7207b6-95c4-4287-5872-fb05abf60e88@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lNrp9eOjsQH0WL1w9H3roSOwYDJAm3gBL"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lNrp9eOjsQH0WL1w9H3roSOwYDJAm3gBL
Content-Type: multipart/mixed; boundary="kAZLiVDR40gLonqaP1CHysU7AraRdk9LJ";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <4f7f61d3-b3f9-43db-ad32-ee502dc06c8b@gmail.com>
Subject: Re: [PATCH] io_uring: fix deferred req iovec leak
References: <e143e45a34dce9d271fc4a3b32f7620c5a7377c1.1581007844.git.asml.silence@gmail.com>
 <d8486857-ccd3-41bd-2ef7-5ac4781dbd5f@gmail.com>
 <f6a1d5aa-f84d-168e-4fdf-6fb895fc09df@gmail.com>
 <6e7207b6-95c4-4287-5872-fb05abf60e88@kernel.dk>
In-Reply-To: <6e7207b6-95c4-4287-5872-fb05abf60e88@kernel.dk>

--kAZLiVDR40gLonqaP1CHysU7AraRdk9LJ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 06/02/2020 22:56, Jens Axboe wrote:
> On 2/6/20 10:16 AM, Pavel Begunkov wrote:
>> On 06/02/2020 20:04, Pavel Begunkov wrote:
>>> On 06/02/2020 19:51, Pavel Begunkov wrote:
>>>> After defer, a request will be prepared, that includes allocating io=
vec
>>>> if needed, and then submitted through io_wq_submit_work() but not cu=
stom
>>>> handler (e.g. io_rw_async()/io_sendrecv_async()). However, it'll lea=
k
>>>> iovec, as it's in io-wq and the code goes as follows:
>>>>
>>>> io_read() {
>>>> 	if (!io_wq_current_is_worker())
>>>> 		kfree(iovec);
>>>> }
>>>>
>>>> Put all deallocation logic in io_{read,write,send,recv}(), which wil=
l
>>>> leave the memory, if going async with -EAGAIN.
>>>>
>>> Interestingly, this will fail badly if it returns -EAGAIN from io-wq =
context.
>>> Apparently, I need to do v2.
>>>
>> Or not...
>> Jens, can you please explain what's with the -EAGAIN handling in
>> io_wq_submit_work()? Checking the code, it seems neither of
>> read/write/recv/send can return -EAGAIN from async context (i.e.
>> force_nonblock=3Dfalse). Are there other ops that can do it?
>=20
> Nobody should return -EAGAIN with force_nonblock=3Dfalse, they should
> end the io_kiocb inline for that.
>=20

If so for those 4, then the patch should work well.

--=20
Pavel Begunkov


--kAZLiVDR40gLonqaP1CHysU7AraRdk9LJ--

--lNrp9eOjsQH0WL1w9H3roSOwYDJAm3gBL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl48cGkACgkQWt5b1Glr
+6UlOQ/8C07MHg79xSZfDRsCvoXFmBYemEBszWwSW7uZ/h/+/I9fxcjygxisu/Oa
cLxxFD3sukWyBu0zN+dCKoGp7RRQZP+jZK3CppAGntxsE5ogZuRsRCHgh2U61YDp
oiDdxdnx2D2YrW6kZEij/0rw6FaaUGSljiQPVk8vzwwVjdH34unC+1+2POdM2z+d
Nn4V+cbdd74GYUdMMD0ExtDSapZ7xmWj6gskO5sIs7rJmkzrczf/8fduzGv12Gzu
oxAU8WuiN7VESnU8kKtUQw7FN+Y1v6KczeNzCg2KGdOvrov4FXHulHaLUdOvW4Pr
F0zWQymRmx3G6/DVq+cl8x9cDrEpj9OpTDIi3vmSNk3q/F2VF8ygBlhKCPz2s0WI
9fy9ul/dLiQNHDqEF1Am93RTuJ6GS8qp9f8yvA55Oogz1g+E+21FxB9V7XsD5qVm
BjnwEvejlWWq3R9CTprILZacamYIP7vzk0yjkYDEotpar1x4uDKwaXq/+4KFVXVE
612Ic2UX4HJUsZU50aqj/BCetuRkWx+35C7xL4adL7VxDCRpRKuWmjlWEHY1AsxF
icS2VAH7Kjn0zt5RDcgVNpMt22XJSG814MIpRgUd+X51ngWCmAavPt5HndxjgXQR
Jm8L2YY/Ppo+aXwtOYYQXqfgs3aS6HPor9xkcaCOLm9DOC/GLBM=
=wZkY
-----END PGP SIGNATURE-----

--lNrp9eOjsQH0WL1w9H3roSOwYDJAm3gBL--
