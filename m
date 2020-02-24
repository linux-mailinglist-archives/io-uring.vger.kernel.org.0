Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D91B16A1C0
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 10:18:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbgBXJSA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 04:18:00 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36157 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727168AbgBXJSA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 04:18:00 -0500
Received: by mail-wr1-f66.google.com with SMTP id z3so9440235wru.3
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 01:17:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=LzxzcylZVM03c0p12Fa4gKAKQRyiJqLHg+wisribo98=;
        b=AoY6GdtozdGJlBBPUP+zeUuooJoKogINLSwsw0aB5GtjHJ2UBvF+lD7q0BjS4b2dEA
         tEl8pGKm7WzogNysu+0NzDEpveQR6HN+joyGzvU2nzM7y8T9oowYV292T05odITAcavC
         7NDHe1evXh0x02LVJoJAtqLX9W6gtYQzHhxgb1cJaI1L/G1W/swpkKHzezAHQpSXTUAN
         zxL/BdiHzWYUfggoshPvQpVUohZG3ZBCkv6uwBCN3fcQ2NkfjHmllO1othqW5gWNOFP5
         hU2OSFo8oIGq1ZiI17ueM12KY666bWYYEn/xiasUvNsW5C05xP56oYZkuZoC8XGoBLNo
         a4lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=LzxzcylZVM03c0p12Fa4gKAKQRyiJqLHg+wisribo98=;
        b=JE6+QZD/Jpyb1fPpv8+4PHQ3O5IIh8/x/my7eBfbBAu9KjWvALiKvxoWVzET76c2j5
         6xuYvsvge6Jx+p6LGFNL/xLSQ6bPYUUzGNTzk6JcJNwSXAIcIhGZun1P4BFlQTVJbCeH
         Rtr9HEoC7Z46mqC49WIreejuQhoaRlO7n+5Q8JZA5t+Oh2tInViirxQAZcC31OllW20L
         RNwkHM1bJE6vaWHgil6a9evKZ+HEEYe+8mfksYJB//CBdjcY7YLjOgqdLgZAL1zkIfar
         QiD+TGvNujVH9kT1uV678yPgQIdLZeY3iuRdt/w7lr9nDkqEvRo5aiyZEVRaXu8tEagt
         dzDA==
X-Gm-Message-State: APjAAAUlz10k1jcC7i7IRYIj17wnjGvDYPzd32zxZ7Mts3PwxsXULoYk
        q3/veGBeT4CESQbcEu3fX4LB1H7j
X-Google-Smtp-Source: APXvYqzNWnOdkoqUdp+DKK+pVUgNt65WZz2KOF2ibY8A3P7SbfO6Js/BGE5o3lEoMksii7M3gheGTA==
X-Received: by 2002:a5d:6144:: with SMTP id y4mr64286622wrt.367.1582535877849;
        Mon, 24 Feb 2020 01:17:57 -0800 (PST)
Received: from [192.168.43.177] ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id x12sm10938438wmc.20.2020.02.24.01.17.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 01:17:57 -0800 (PST)
Subject: Re: [PATCH v3 0/3] async punting improvements for io_uring
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1582530396.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 mQINBFmKBOQBEAC76ZFxLAKpDw0bKQ8CEiYJRGn8MHTUhURL02/7n1t0HkKQx2K1fCXClbps
 bdwSHrhOWdW61pmfMbDYbTj6ZvGRvhoLWfGkzujB2wjNcbNTXIoOzJEGISHaPf6E2IQx1ik9
 6uqVkK1OMb7qRvKH0i7HYP4WJzYbEWVyLiAxUj611mC9tgd73oqZ2pLYzGTqF2j6a/obaqha
 +hXuWTvpDQXqcOZJXIW43atprH03G1tQs7VwR21Q1eq6Yvy2ESLdc38EqCszBfQRMmKy+cfp
 W3U9Mb1w0L680pXrONcnlDBCN7/sghGeMHjGKfNANjPc+0hzz3rApPxpoE7HC1uRiwC4et83
 CKnncH1l7zgeBT9Oa3qEiBlaa1ZCBqrA4dY+z5fWJYjMpwI1SNp37RtF8fKXbKQg+JuUjAa9
 Y6oXeyEvDHMyJYMcinl6xCqCBAXPHnHmawkMMgjr3BBRzODmMr+CPVvnYe7BFYfoajzqzq+h
 EyXSl3aBf0IDPTqSUrhbmjj5OEOYgRW5p+mdYtY1cXeK8copmd+fd/eTkghok5li58AojCba
 jRjp7zVOLOjDlpxxiKhuFmpV4yWNh5JJaTbwCRSd04sCcDNlJj+TehTr+o1QiORzc2t+N5iJ
 NbILft19Izdn8U39T5oWiynqa1qCLgbuFtnYx1HlUq/HvAm+kwARAQABtDFQYXZlbCBCZWd1
 bmtvdiAoc2lsZW5jZSkgPGFzbWwuc2lsZW5jZUBnbWFpbC5jb20+iQJOBBMBCAA4FiEE+6Ju
 PTjTbx479o3OWt5b1Glr+6UFAlmKBOQCGwMFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AACgkQ
 Wt5b1Glr+6WxZA//QueaKHzgdnOikJ7NA/Vq8FmhRlwgtP0+E+w93kL+ZGLzS/cUCIjn2f4Q
 Mcutj2Neg0CcYPX3b2nJiKr5Vn0rjJ/suiaOa1h1KzyNTOmxnsqE5fmxOf6C6x+NKE18I5Jy
 xzLQoktbdDVA7JfB1itt6iWSNoOTVcvFyvfe5ggy6FSCcP+m1RlR58XxVLH+qlAvxxOeEr/e
 aQfUzrs7gqdSd9zQGEZo0jtuBiB7k98t9y0oC9Jz0PJdvaj1NZUgtXG9pEtww3LdeXP/TkFl
 HBSxVflzeoFaj4UAuy8+uve7ya/ECNCc8kk0VYaEjoVrzJcYdKP583iRhOLlZA6HEmn/+Gh9
 4orG67HNiJlbFiW3whxGizWsrtFNLsSP1YrEReYk9j1SoUHHzsu+ZtNfKuHIhK0sU07G1OPN
 2rDLlzUWR9Jc22INAkhVHOogOcc5ajMGhgWcBJMLCoi219HlX69LIDu3Y34uIg9QPZIC2jwr
 24W0kxmK6avJr7+n4o8m6sOJvhlumSp5TSNhRiKvAHB1I2JB8Q1yZCIPzx+w1ALxuoWiCdwV
 M/azguU42R17IuBzK0S3hPjXpEi2sK/k4pEPnHVUv9Cu09HCNnd6BRfFGjo8M9kZvw360gC1
 reeMdqGjwQ68o9x0R7NBRrtUOh48TDLXCANAg97wjPoy37dQE7e5Ag0EWYoE5AEQAMWS+aBV
 IJtCjwtfCOV98NamFpDEjBMrCAfLm7wZlmXy5I6o7nzzCxEw06P2rhzp1hIqkaab1kHySU7g
 dkpjmQ7Jjlrf6KdMP87mC/Hx4+zgVCkTQCKkIxNE76Ff3O9uTvkWCspSh9J0qPYyCaVta2D1
 Sq5HZ8WFcap71iVO1f2/FEHKJNz/YTSOS/W7dxJdXl2eoj3gYX2UZNfoaVv8OXKaWslZlgqN
 jSg9wsTv1K73AnQKt4fFhscN9YFxhtgD/SQuOldE5Ws4UlJoaFX/yCoJL3ky2kC0WFngzwRF
 Yo6u/KON/o28yyP+alYRMBrN0Dm60FuVSIFafSqXoJTIjSZ6olbEoT0u17Rag8BxnxryMrgR
 dkccq272MaSS0eOC9K2rtvxzddohRFPcy/8bkX+t2iukTDz75KSTKO+chce62Xxdg62dpkZX
 xK+HeDCZ7gRNZvAbDETr6XI63hPKi891GeZqvqQVYR8e+V2725w+H1iv3THiB1tx4L2bXZDI
 DtMKQ5D2RvCHNdPNcZeldEoJwKoA60yg6tuUquvsLvfCwtrmVI2rL2djYxRfGNmFMrUDN1Xq
 F3xozA91q3iZd9OYi9G+M/OA01husBdcIzj1hu0aL+MGg4Gqk6XwjoSxVd4YT41kTU7Kk+/I
 5/Nf+i88ULt6HanBYcY/+Daeo/XFABEBAAGJAjYEGAEIACAWIQT7om49ONNvHjv2jc5a3lvU
 aWv7pQUCWYoE5AIbDAAKCRBa3lvUaWv7pfmcEACKTRQ28b1y5ztKuLdLr79+T+LwZKHjX++P
 4wKjEOECCcB6KCv3hP+J2GCXDOPZvdg/ZYZafqP68Yy8AZqkfa4qPYHmIdpODtRzZSL48kM8
 LRzV8Rl7J3ItvzdBRxf4T/Zseu5U6ELiQdCUkPGsJcPIJkgPjO2ROG/ZtYa9DvnShNWPlp+R
 uPwPccEQPWO/NP4fJl2zwC6byjljZhW5kxYswGMLBwb5cDUZAisIukyAa8Xshdan6C2RZcNs
 rB3L7vsg/R8UCehxOH0C+NypG2GqjVejNZsc7bgV49EOVltS+GmGyY+moIzxsuLmT93rqyII
 5rSbbcTLe6KBYcs24XEoo49Zm9oDA3jYvNpeYD8rDcnNbuZh9kTgBwFN41JHOPv0W2FEEWqe
 JsCwQdcOQ56rtezdCJUYmRAt3BsfjN3Jn3N6rpodi4Dkdli8HylM5iq4ooeb5VkQ7UZxbCWt
 UVMKkOCdFhutRmYp0mbv2e87IK4erwNHQRkHUkzbsuym8RVpAZbLzLPIYK/J3RTErL6Z99N2
 m3J6pjwSJY/zNwuFPs9zGEnRO4g0BUbwGdbuvDzaq6/3OJLKohr5eLXNU3JkT+3HezydWm3W
 OPhauth7W0db74Qd49HXK0xe/aPrK+Cp+kU1HRactyNtF8jZQbhMCC8vMGukZtWaAwpjWiiH bA==
Message-ID: <4775cbc6-3ec1-a09b-c8a1-8b34f5a30360@gmail.com>
Date:   Mon, 24 Feb 2020 12:17:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cover.1582530396.git.asml.silence@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Y2ByCR8xwhcI1rCAquRKCzdJxI96MhjAS"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Y2ByCR8xwhcI1rCAquRKCzdJxI96MhjAS
Content-Type: multipart/mixed; boundary="PNS69vyQJhDP0sneqSBb7yxUqAXVJHG7H";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Message-ID: <4775cbc6-3ec1-a09b-c8a1-8b34f5a30360@gmail.com>
Subject: Re: [PATCH v3 0/3] async punting improvements for io_uring
References: <cover.1582530396.git.asml.silence@gmail.com>
In-Reply-To: <cover.1582530396.git.asml.silence@gmail.com>

--PNS69vyQJhDP0sneqSBb7yxUqAXVJHG7H
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 24/02/2020 11:30, Pavel Begunkov wrote:
> *on top of for-5.6*

Jens, let me know if this and the splice patchset should be rebased onto
your poll branch.

>=20
> This cleans up io-wq punting paths, doing small fixes and removing
> unnecessary logic from different submission paths.
>=20
> v2:
> - remove pid-related comment, as it's fixed separately
> - make ("add missing io_req_cancelled()") first
>   in the series, so it may be picked for 5.6
>=20
> v3:
> - rebase + drop a patch definitely colliding with poll work
>=20
> Pavel Begunkov (3):
>   io_uring: don't call work.func from sync ctx
>   io_uring: don't do full *prep_worker() from io-wq
>   io_uring: remove req->in_async
>=20
>  fs/io_uring.c | 101 +++++++++++++++++++++++++++-----------------------=

>  1 file changed, 54 insertions(+), 47 deletions(-)
>=20

--=20
Pavel Begunkov


--PNS69vyQJhDP0sneqSBb7yxUqAXVJHG7H--

--Y2ByCR8xwhcI1rCAquRKCzdJxI96MhjAS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5TlJgACgkQWt5b1Glr
+6UGkQ/9E2ck44jfTYW2UlJmfWfEx9huprmR0ElKePLxjord+HQRDMG5zfbQcEoW
8aw1WLD4hKoyzWaIn0oubG7ArA4KQ7vR++ubOAos5x1T7kLl4s0CmFu/fsuDpgpy
sGy1NhlJaeVH5fUeZOfmdazFW2mIe10BM1Y3AwYBBjZ8O+qqSOvn/JIhNKedWHWn
btP0hu4GCgUyAX0+9Eghyay00lh2Qn0BGByHs+PIDCQcE/Cky91xEU0zlbKOBxTl
wO4fDhlj3lQsJCBveMsYRTDdqx0mw4Z2ta7/cQZBDlmY4c3Q7RRRnKxbxinMCsOG
SEsXyR5EZQju6DCWo4Y8MiWQLSxJ2/jZldWE6p1n+uFOl5hBrys5ejR8f+xt17zz
5ffbMi8F8AO1NN+EZ2fYgKREvO8c/fu6L33h2KIz4a/dhfysfHra4ZETd+M55tUM
XJjxjwXEMu8ED+/AG1if275zydw0OijWAYYPL8ZmOw/xKUjhvUYwR16/lK6YUilw
TaxBtj/mYfI8Dblb78+uXt9X25zmkX9YtYc3RE4b/t6NiLPLAzxHqWiDqveiXFd/
qRuPWldoADLrY5xwVQlJ9D6kOLro63zq/zyCoAuqBM/BwZ8nz6WH5uDYZisvrH/C
qA2RVjUpwftwR7JRWjn8JCC38w0yMJoVZdYEFjb3YRMI/s0IXN0=
=MpR9
-----END PGP SIGNATURE-----

--Y2ByCR8xwhcI1rCAquRKCzdJxI96MhjAS--
