Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6532518EAE1
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2020 18:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgCVRcX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Mar 2020 13:32:23 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53680 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726538AbgCVRcX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Mar 2020 13:32:23 -0400
Received: by mail-wm1-f66.google.com with SMTP id 25so11929002wmk.3;
        Sun, 22 Mar 2020 10:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=BILjr/zRGMJ5LGQdbmLKkEBrRhdaMpO7WTE9dLLBOQk=;
        b=QCAPqFKEZ5p8swsrySV1viHV16RlQfWxm096xAnSWtx4QtgIswGGF6hJ3wSD4hQYQJ
         Z9Nqx2vXijdVov+/LXRg/uReD5hg+w5FgU8ZpqiLPkasapMEO8KtRyQ+SMlcTzbJ2+Kg
         fla+qXzZ3YJqxa/GCy7OAgqmBoQG5y+O7LsEe4r1F6hFKwUJ70MBbwyVyG2bvMQ+UaPX
         nDE8yJEe2ah/UzdAP8Ta2MbTYbsHgu3hzJ0kfd12uAa3a14eyLNA63KU439HnvmtNKmw
         Mu1oSwbXJQnxT2uSouKFH7KRGae5sLZUlq0f55U0jWu98X42GYJPtMqldA70byF6DrN/
         KtcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=BILjr/zRGMJ5LGQdbmLKkEBrRhdaMpO7WTE9dLLBOQk=;
        b=RBBM7DbMKITqSoy2M8XZoTLjwXAH8BHvW3SoIV0ro+7Xe1jNRgT+XbyWkkRSgfrbe6
         NP7SH0VgRtXolgnqr9gcExgP5l8cmG5EJZXT7GXMr8Ud771I0uD1X4Pm84di+WZS2h8p
         MVLYZ5morL30uA81nS7EWvwMsyDGVW+trG6OCysV8xAScw202zuVGPxMkQrSHODzmJkY
         yRTXeRcxmd4L37GB9NOSvZKd3gHoryleG8JEUp2CK9ISrjRxijE56GR7CfsYuuA8tCge
         3F1kZJveXAJC80sD9Shy/6UG2Kblp31F1sikLbCp56Q75ah8HXFoJx7RyNWV5FVKx2pR
         xbkQ==
X-Gm-Message-State: ANhLgQ0119M0CgDp89+MDZs/rZX0tfT3P4m/yhi/inOOFZ6nf3UrZwWr
        MP5bIMQxLdZ94Rcr263e2GwFOoQF
X-Google-Smtp-Source: ADFU+vtg8gO3tDJyjdse33Nakylhvf3b3EYKeCcN6JPRDAejbaS1IWxsbUjHxiLJS1EKt2yO/xDOLQ==
X-Received: by 2002:a1c:4d0c:: with SMTP id o12mr2696787wmh.176.1584898339893;
        Sun, 22 Mar 2020 10:32:19 -0700 (PDT)
Received: from [192.168.43.200] ([109.126.140.227])
        by smtp.gmail.com with ESMTPSA id s7sm18861206wri.61.2020.03.22.10.32.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 10:32:19 -0700 (PDT)
Subject: Re: [PATCH 1/1] io-wq: close cancel gap for hashed linked work
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <b9bc821a0ff3bc52a60281d8a9005dff93f6dcc3.1584893591.git.asml.silence@gmail.com>
 <c7f352b4-0255-d87a-1fb4-0b55984df137@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <bb4efaeb-2d14-f3e6-cadb-c53cf9bb7060@gmail.com>
Date:   Sun, 22 Mar 2020 20:31:27 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <c7f352b4-0255-d87a-1fb4-0b55984df137@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GQfQPFj4AYF9TPDHgOEC3sVVzZvDEsYqW"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GQfQPFj4AYF9TPDHgOEC3sVVzZvDEsYqW
Content-Type: multipart/mixed; boundary="Kp9PdT7ngHLO9dKQ3D82DI7QghfSpRdBI";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <bb4efaeb-2d14-f3e6-cadb-c53cf9bb7060@gmail.com>
Subject: Re: [PATCH 1/1] io-wq: close cancel gap for hashed linked work
References: <b9bc821a0ff3bc52a60281d8a9005dff93f6dcc3.1584893591.git.asml.silence@gmail.com>
 <c7f352b4-0255-d87a-1fb4-0b55984df137@kernel.dk>
In-Reply-To: <c7f352b4-0255-d87a-1fb4-0b55984df137@kernel.dk>

--Kp9PdT7ngHLO9dKQ3D82DI7QghfSpRdBI
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 22/03/2020 20:04, Jens Axboe wrote:
> On 3/22/20 10:14 AM, Pavel Begunkov wrote:
>> After io_assign_current_work() of a linked work, it can be decided to
>> offloaded to another thread so doing io_wqe_enqueue(). However, until
>> next io_assign_current_work() it can be cancelled, that isn't handled.=

>>
>> Don't assign it, if it's not going to be executed.
>=20
> This needs a Fixes: line as well. I'm guessing like this:
>=20
> Fixes: 60cf46ae6054 ("io-wq: hash dependent work")
>=20
> but I didn't look too closely yet... Fix looks good, though.

Yep, this one

--=20
Pavel Begunkov


--Kp9PdT7ngHLO9dKQ3D82DI7QghfSpRdBI--

--GQfQPFj4AYF9TPDHgOEC3sVVzZvDEsYqW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl53oO8ACgkQWt5b1Glr
+6UXoA//fdnjH66Yzfb+5ch64W3rgYE89OFVlPg9hxgv3Un/72MRuJSxMcz8Swsw
4E8CIk8AHwfptbbYalqPk/5ouHakzU9sw9Z0o+Vu4InEQdhBp1XWXsY6BP2dpO3R
7WyXaABZ8ReCWuNmz7weWbKzFpI1kC0WYNPkq4JVXhbGZTABwDv6ZqF0XTLgE8qR
CXpl7R8vDZNt/shCd+/T2OewepCcOMv8uNwOA1VX5M4CEkLQ/tpJvMWAk7Otaw0u
6/Rm/F/qVIoYUpP91c2p5qx0gx3LkLCWh5p6l8v0erM4sdzpOLh1Xd4tY/ld1xJ8
/EAa8SoXzkQUDB8B7V7nggIz3j6JhrgCpX3oBzFvlyqipe8q4BZl2/7OVFL37aIN
CBoZnkt/9veQV35oLn6wNhOVlN6lZ3XVVUmNi9ybJyYz4p6Ybc3ycSwOHE9X7Zhn
9s/pofjPJBspOxiZX3JV3CCjFgahj0rXR2g3Q0ZoA7Fr7Bv+cW3QOv75ESuS4vsQ
uLKK/+vPW2XFY3sd5A/UI+hVPWDJ6K/hEz7mipncdRvvcofUe32X/Ygmqpu8mhJ9
i0Hg6ZFmeo7ZT5wyEGEXeqnWPC+QK33uEkk/DAWrwi+6EVEnmQcKukY/7+bm2P3x
1e4x7yRSZOASESk9UNpRMIDFnB3fGLWFs/fIJJR2I4BqJ162u8c=
=FQDD
-----END PGP SIGNATURE-----

--GQfQPFj4AYF9TPDHgOEC3sVVzZvDEsYqW--
