Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE4A14AD15
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 01:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgA1ATe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 19:19:34 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54472 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgA1ATe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 19:19:34 -0500
Received: by mail-wm1-f65.google.com with SMTP id g1so592317wmh.4;
        Mon, 27 Jan 2020 16:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=Fn/+CXxmCOcm78jUaAu0hb2CyqfENHRjzyg4/VOJJko=;
        b=hEC1TdIFnxqhs0ABJ2ARw2RVxpgtFHBieNPASCx5pXHJDNQ98sKIULl4OenZA1Y90r
         NdmqtAzNl/Bws6OeWt06c4wVgEQxU7NEqBDeOWGczJPzOWGDVxzRT9Sq3l2DQKiRUsnm
         /yg4l/zoXOeUJ+C+VFzOLCBqwYKp+/2BIaZ8Q6GKr/rEofYXlFYmjPRnwaT1wEvNG3sx
         FYthWkXvPrsoQkvUdd5pLwaWuN5QcPmLqZw+nQ4o0o5eyejf+rIRWowWHyfcdU7Ngya9
         XhRklcUZUq8fMLWKNaj7fhO5azpuH3WbWhGtPaUbq/40b7RmU//NIko3HKchapqOx6J1
         rDJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=Fn/+CXxmCOcm78jUaAu0hb2CyqfENHRjzyg4/VOJJko=;
        b=UUOaFN4LCOqiWs6nu3yPXPn1JNU19vbCB4Btb9yx61U/BZ9/M3qP/E79EVsy4ZrHJc
         fCVnJwc/oup3o9JtchtbSfJKJhQ+CELSTeq9zYtGGY/Uc/B7JycBK14mviYH+RUVuug0
         1XA7T2mUKtuCKAmv8PBKCc1XHIVRgUib1aZzV7buIOQKiYQKddK30W35NyXWFh5nI7Sc
         FRS90aqoCb+masKlvlIjlijZiGl2+n8hU93Q3rDnkZM3dXPItpwzwqTHsvvhUapQLVSy
         yumQb3ZRprQ8hXYSaZslwXDYbwIMTNS6wW5eLeu7UoZl1V/WBI1amgob/NqpPbO4sVse
         AQ0w==
X-Gm-Message-State: APjAAAVPoIb/jx7lQ1dUQwtGdxvyedy3gT+Vj4mLVrh0ZtXP6L6EzRc8
        Z+gr2mBxgyE41kSyZpNJUhql75gx
X-Google-Smtp-Source: APXvYqzoXVZJTMmEhsHzaG4+0NpKtS0q4ocnQ9C5sZzr3ZpQEnHs3Wz+JgYEWRZxI7+x4TMniGmTAw==
X-Received: by 2002:a7b:c258:: with SMTP id b24mr1304122wmj.140.1580170770454;
        Mon, 27 Jan 2020 16:19:30 -0800 (PST)
Received: from [192.168.43.36] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id e18sm23138099wrr.95.2020.01.27.16.19.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 16:19:29 -0800 (PST)
Subject: Re: [PATCH v2 1/2] io-wq: allow grabbing existing io-wq
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1580170474.git.asml.silence@gmail.com>
 <af01e0ca2dcab907bc865a5ecdc0317c00bb059a.1580170474.git.asml.silence@gmail.com>
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
Message-ID: <24432662-f6a5-99ef-2a73-e0917ecc8b07@gmail.com>
Date:   Tue, 28 Jan 2020 03:18:43 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <af01e0ca2dcab907bc865a5ecdc0317c00bb059a.1580170474.git.asml.silence@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FfRdXmBi7nvY5uwrh8e7tqJANyLwAqkOh"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FfRdXmBi7nvY5uwrh8e7tqJANyLwAqkOh
Content-Type: multipart/mixed; boundary="fXTwj4OQraICVi2dOsu1ydsdQyVybOeib";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <24432662-f6a5-99ef-2a73-e0917ecc8b07@gmail.com>
Subject: Re: [PATCH v2 1/2] io-wq: allow grabbing existing io-wq
References: <cover.1580170474.git.asml.silence@gmail.com>
 <af01e0ca2dcab907bc865a5ecdc0317c00bb059a.1580170474.git.asml.silence@gmail.com>
In-Reply-To: <af01e0ca2dcab907bc865a5ecdc0317c00bb059a.1580170474.git.asml.silence@gmail.com>

--fXTwj4OQraICVi2dOsu1ydsdQyVybOeib
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 28/01/2020 03:15, Pavel Begunkov wrote:
> If the id and user/creds match, return an existing io_wq if we can safe=
ly
> grab a reference to it.

Missed the outdated comment. Apparently, it's too late for continue with =
it today.

>=20
> Reported-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io-wq.c | 8 ++++++++
>  fs/io-wq.h | 1 +
>  2 files changed, 9 insertions(+)
>=20
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index b45d585cdcc8..ee49e8852d39 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -1110,6 +1110,14 @@ struct io_wq *io_wq_create(unsigned bounded, str=
uct io_wq_data *data)
>  	return ERR_PTR(ret);
>  }
> =20
> +bool io_wq_get(struct io_wq *wq, struct io_wq_data *data)
> +{
> +	if (data->get_work !=3D wq->get_work || data->put_work !=3D wq->put_w=
ork)
> +		return false;
> +
> +	return refcount_inc_not_zero(&wq->use_refs);
> +}
> +
>  static bool io_wq_worker_wake(struct io_worker *worker, void *data)
>  {
>  	wake_up_process(worker->task);
> diff --git a/fs/io-wq.h b/fs/io-wq.h
> index 167316ad447e..c42602c58c56 100644
> --- a/fs/io-wq.h
> +++ b/fs/io-wq.h
> @@ -99,6 +99,7 @@ struct io_wq_data {
>  };
> =20
>  struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data);=

> +bool io_wq_get(struct io_wq *wq, struct io_wq_data *data);
>  void io_wq_destroy(struct io_wq *wq);
> =20
>  void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work);
>=20

--=20
Pavel Begunkov


--fXTwj4OQraICVi2dOsu1ydsdQyVybOeib--

--FfRdXmBi7nvY5uwrh8e7tqJANyLwAqkOh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4vfeMACgkQWt5b1Glr
+6X3AQ/+KlguvMT7sZeyuUII0wUqorB7kZsZbGzdJHsQv2ZBlu2w8nAMR/M25T7f
UM3ph7zhisym14ynAnu+p9R8OYdr98VYqQ520Rb37ps7TKZDaR3IzGSn+uWhT0Fe
gILIRKrRuPFOgMBcPuFWENXiGDhnpt048tU8myRc2qnk3Oyy82Uv8JnsDvX5Jl/L
dbGbUCiTn7JXi/e/InmmvGmaLNscNAq3Vc2U23kJabs7OH+G7KVF6tQlOeyAGDpV
w45EZhuanDzVyBiXpfSho0ODIgefmfWs+XG8RqWKXHxnF6Kz+LDEV1Y/v4RfJSnd
0gxOAjD+6T0d5CHrvQjNzxMwAzJSCu7PktuFcohSkqpzHWqM3Q8Xurbq0umYbT/l
OB5rcVit/pPGezccA9mKeMDDt14FfePR71YYmMTGTSTG/xcSCK1AL9tWIfaCSsGi
bHeb1ZLLODzRxT21PLfofvBKeXqetnCB5Lf0URLNjNakKlyk3g8ULyG8xm+DwukG
rrl4p2jWoANq8AkK0jlbik6GvWX4dvUD2Ursezmr+GgE+rtKstl0DsK4xWEyibKe
oVSApS2le9OAdphPyfe6a137nrzlShpeMO+x2sALX2Cveru/lozQbkx3N3EVure/
YsNTe2cffMJQjoKPB8cAVQxCL+S9LkXiQO1ZVLKKc6h9H2iIS6k=
=C1V+
-----END PGP SIGNATURE-----

--FfRdXmBi7nvY5uwrh8e7tqJANyLwAqkOh--
