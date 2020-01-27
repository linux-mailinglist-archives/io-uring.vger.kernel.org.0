Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E437514ABC0
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2020 22:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgA0VqK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 16:46:10 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36411 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgA0VqJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 16:46:09 -0500
Received: by mail-wm1-f68.google.com with SMTP id p17so219486wma.1
        for <io-uring@vger.kernel.org>; Mon, 27 Jan 2020 13:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=tTuHkDmZuCIy8DpxBgb7n4VDn3jAur/GaACFk4sGKz4=;
        b=pT0TapDkY/96LWvi+byZk5sv0jV28TlOcl392fXEdusT334uKH9jajEsYXUNQ8uFk0
         Je/+7GaQoSJie/mEOjBJiBPxahZOzIKDCQx2p5IXZc2r66xi5eBUO3LvTZaPO/hejp4K
         iFy0sFJAUj+rQwKL6pwrfY6DLqPYYz7SfUQKad9FvLa02KlrAOx2G8TwqmHrIASEAwHd
         Bl1lcfb31l303WOPeB2OiWcY1rhkdNwlnPWB3AunCkngwzB3DklFsM8U+UfKj9NUmIWr
         TMVFtIpan3MXfCoaF7wRpImdotDu72jfPKJo1qcwVviiDUwRGpJYQwBzKovUIonLSRpC
         t3kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=tTuHkDmZuCIy8DpxBgb7n4VDn3jAur/GaACFk4sGKz4=;
        b=e5IUJF2vsTY8ZHkxo06ZfU35zNWPlVbirwdowepxBP2iPxk2opKA193WJLUzYjDgjL
         nv46Yw+EUJZ+qQ+lB2h8Op51c5VJri631oWTtcYpqM67k/j77N7OQrZvrY7mH5TcmAsc
         GukDJLAsnV1u/ujuBhItdewjhfFhWHEIqM0PXMUAeWR1/Cbn4K5yBnjLmZ6mDoYI+4zJ
         vrcUL86l0VjXjd7+hLwvsFaVyaVt9hIjVqQWwpimOAgHYZno53j36SR8kMxxqg0EcME6
         TZNgl4pu0kPvr1vVqgDYImUpucTYZNlTl6fFEE5wzYZ63v5srDzq75qV1KKIen9ASw/N
         DaQQ==
X-Gm-Message-State: APjAAAUp0tW7cxkreo6VUEO3lt6bePGFVhfvatoLB1+gyMzI/b5cTS/O
        JIPCAcon5WIIQZHWz5LGw9jF9BZ6
X-Google-Smtp-Source: APXvYqz9gI3tLxe+1NxLTI5e7KS2Yl8n7QT9Xd9eLi9ZDA5hlnRCL4rTIlCIIvRIPgTvNKpJsuw32A==
X-Received: by 2002:a1c:1d8d:: with SMTP id d135mr720604wmd.92.1580161566781;
        Mon, 27 Jan 2020 13:46:06 -0800 (PST)
Received: from [192.168.43.36] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id n13sm180588wmd.21.2020.01.27.13.46.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 13:46:06 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, Daurnimator <quae@daurnimator.com>
Cc:     io-uring@vger.kernel.org
References: <20200123231614.10850-1-axboe@kernel.dk>
 <CAEnbY+c34Uiguq=11eZ1F0z_VZopeBbw1g1gfn-S0Fb5wCaL5A@mail.gmail.com>
 <4917a761-6665-0aa2-0990-9122dfac007a@gmail.com>
 <694c2b6f-6b51-fd7b-751e-db87de90e490@kernel.dk>
 <a9fcf996-88ed-6bc4-f5ef-6ce4ed2253c5@gmail.com>
 <92e92002-f803-819a-5f5e-44cf09e63c9b@kernel.dk>
 <3b3b5e03-2c7e-aa00-c1fd-3af8b2620d5e@gmail.com>
 <1b24da2d-dd92-608e-27b6-b827a728e7ab@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCHSET 0/4] Add support for shared io-wq backends
Message-ID: <e15d7700-7d7b-521e-0e78-e8bff9013277@gmail.com>
Date:   Tue, 28 Jan 2020 00:45:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1b24da2d-dd92-608e-27b6-b827a728e7ab@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="YJ8ZKAyiwVxYB94fsr6qZUeGBDe6IrYCf"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--YJ8ZKAyiwVxYB94fsr6qZUeGBDe6IrYCf
Content-Type: multipart/mixed; boundary="pWjGy0ELE8myXQwhFgRO155YnqcIDdPvU";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Daurnimator <quae@daurnimator.com>
Cc: io-uring@vger.kernel.org
Message-ID: <e15d7700-7d7b-521e-0e78-e8bff9013277@gmail.com>
Subject: Re: [PATCHSET 0/4] Add support for shared io-wq backends
References: <20200123231614.10850-1-axboe@kernel.dk>
 <CAEnbY+c34Uiguq=11eZ1F0z_VZopeBbw1g1gfn-S0Fb5wCaL5A@mail.gmail.com>
 <4917a761-6665-0aa2-0990-9122dfac007a@gmail.com>
 <694c2b6f-6b51-fd7b-751e-db87de90e490@kernel.dk>
 <a9fcf996-88ed-6bc4-f5ef-6ce4ed2253c5@gmail.com>
 <92e92002-f803-819a-5f5e-44cf09e63c9b@kernel.dk>
 <3b3b5e03-2c7e-aa00-c1fd-3af8b2620d5e@gmail.com>
 <1b24da2d-dd92-608e-27b6-b827a728e7ab@kernel.dk>
In-Reply-To: <1b24da2d-dd92-608e-27b6-b827a728e7ab@kernel.dk>

--pWjGy0ELE8myXQwhFgRO155YnqcIDdPvU
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 27/01/2020 23:33, Jens Axboe wrote:
> On 1/27/20 7:07 AM, Pavel Begunkov wrote:
>> On 1/27/2020 4:39 PM, Jens Axboe wrote:
>>> On 1/27/20 6:29 AM, Pavel Begunkov wrote:
>>>> On 1/26/2020 8:00 PM, Jens Axboe wrote:
>>>>> On 1/26/20 8:11 AM, Pavel Begunkov wrote:
>>>>>> On 1/26/2020 4:51 AM, Daurnimator wrote:
>>>>>>> On Fri, 24 Jan 2020 at 10:16, Jens Axboe <axboe@kernel.dk> wrote:=

>>>> Ok. I can't promise it'll play handy for sharing. Though, you'll be =
out
>>>> of space in struct io_uring_params soon anyway.
>>>
>>> I'm going to keep what we have for now, as I'm really not imagining a=

>>> lot more sharing - what else would we share? So let's not over-design=

>>> anything.
>>>
>> Fair enough. I prefer a ptr to an extendable struct, that will take th=
e
>> last u64, when needed.
>>
>> However, it's still better to share through file descriptors. It's jus=
t
>> not secure enough the way it's now.
>=20
> Is the file descriptor value really a good choice? We just had some
> confusion on ring sharing across forks. Not sure using an fd value
> is a sane "key" to use across processes.
>=20
As I see it, the problem with @mm is that uring is dead-bound to it. For
example, a process can create and send uring (e.g. via socket), and then =
be
killed. And that basically means
1. @mm of the process is locked just because of the sent uring instance.
2. a process may have an io_uring, which bound to @mm of another process,=
 even
though the layouts may be completely different.

File descriptors are different here, because io_uring doesn't know about =
them,
They are controlled by the userspace (send, dup, fork, etc), and don't sa=
botage
all isolation work done in the kernel. A dire example here is stealing io=
-wq
from within a container, which is trivial with global self-made id. I wou=
ld love
to hear, if I am mistaken somewhere.

Is there some better option?

--=20
Pavel Begunkov


--pWjGy0ELE8myXQwhFgRO155YnqcIDdPvU--

--YJ8ZKAyiwVxYB94fsr6qZUeGBDe6IrYCf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4vWfcACgkQWt5b1Glr
+6WetxAAuBIYjTDanBXaMzz7upZHee2b/fTP1FvKChZvJYzY/YrInHSD8l5E3MJu
mTA6E3TsJLwASncuOiphudpRIzt7JqrwqbiEEMvrPmJCAMvSV5TGCF00EIN3jMtR
X8c47c0xgSGi91Fuj4/u3nPbHkfq2cC/RKX1ntEJeJAbhvvlSf+SzaayVs69folE
oQFyuiy4rHtG2WVphKuJXyPq8j0/KG6jZ/+RKB29bZdbHghq2QhV6B+Cjy2VkHmj
GeVXGdASSGEHacJ1TPXpeMeSc014iv9ukfJ1x0AStLt/VXLQzJWmX/BJJNxvKz4x
v69E8saAoQYWBjlz9lhC452hVI72HozUUajyzRUWwyJhaincVN6IzpFREOFVIjzA
JxEhFC8bIiK5I2MyH8Zf/2lzBFK1107EnQ47gxkqf5WHTyHLC2LjtNlg2VwuqlCA
rVITg9FqBa2Eu3lwgNIvg8B9mF3O8lYB7ZxzPZ6VntuSJkzSugrJcGXQbeCJp6ZT
clAeh5KkQnHvA4iMd74KfUEgV1v4RIjpFPDL9hMrA27h/831AtaF283XvHCb9nTE
hWA/NUEU2ZVNDf1shCo2I7N041iw2ul6/gab0FCTN7nEIWwKwagK9jrj+fHLo0ko
tCdmRIz46gjJ2GSWlNeyQnD8GDJl69tbd3azjOHShMRssU20lZc=
=cmUi
-----END PGP SIGNATURE-----

--YJ8ZKAyiwVxYB94fsr6qZUeGBDe6IrYCf--
