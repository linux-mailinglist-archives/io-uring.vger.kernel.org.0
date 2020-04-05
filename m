Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3112819EE39
	for <lists+io-uring@lfdr.de>; Sun,  5 Apr 2020 23:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbgDEVO6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Apr 2020 17:14:58 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40101 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbgDEVO6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Apr 2020 17:14:58 -0400
Received: by mail-wr1-f67.google.com with SMTP id s8so12928857wrt.7;
        Sun, 05 Apr 2020 14:14:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=DUDxhMB/UN68U0GsmVbhl76obOV89JzSKfS1fMHpxR8=;
        b=btzKb/sD99fwfWW5xBsrN/PbB5ddH3RPJixOVvqHnu/GVgI+9OuW06H/gzJQEByJxa
         DLm3IMTUubiX8z+IDRwRqkiZ2JmEgu79gN0UsqO3B54auv8zrjkFy/UAencQ8wXJ+yvC
         3kLfC5+sWVZ6GuISVDTwPa+LeOChZZWHkUVvKGDVXHYOPw2rwi2jHKmurGr1kN2l8Eal
         AJJOiVV/RL+lDB1fJK/hwuFHlh7FShG3+1cjHEY7G3I9yJMBya2XCuFGgKebwJQ8Fdfh
         x7p+YvAL2Nt7EO0B6VGzsJlcA3PlrnYkI14S2VxMVehV57niTAinDfu2E3EfAnZoJJ4f
         CD/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=DUDxhMB/UN68U0GsmVbhl76obOV89JzSKfS1fMHpxR8=;
        b=S3alalG41aUlgcRc1bcZTN12oa06zkbHRsLCcnUGlV5WrrGYPeiYrx5YRt7VQ2iYtC
         gyP5m/WBpenQHiokyynscSt6h6LcEbk9rpzIybd/w5ZDYqRXJdpy9uSLfVpOfA8OXKOS
         TBjpoV+XxQDzDhBcyBJiksOyaYfXFqSi0O12Bc29Hl9fS0DfJFGXyIu8ZSN5zMiIIXG3
         JxZINwFqofZ7LJU6HCWV1w+2n7udsyAQfBZOVTfepp5TXVCZxBz+/ofmMDqK8fjVZJqw
         2StMSF5QUfq/DbavvRKZBevocTE7hTvTUBU+wsTdUDfcGIfEewSKtfcwXPSlDI82WPoz
         hyKA==
X-Gm-Message-State: AGi0PubvUHtGoF8eWu3d6B1c9kZW6vfmWd5KnlzJGr0gLnTsihSSpmHO
        EoLPACdyRFlWOnHTNxoUhfx2YA1a
X-Google-Smtp-Source: APiQypI2IX7vLcMtIk8ayVI6+IQ/x+ieR+/mPs9xpWls7rbJpLyoFhM+djk4yZyYVv2UwkWYrCwo5Q==
X-Received: by 2002:adf:f54d:: with SMTP id j13mr8369622wrp.28.1586121294437;
        Sun, 05 Apr 2020 14:14:54 -0700 (PDT)
Received: from [192.168.43.88] ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id c190sm797561wme.10.2020.04.05.14.14.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Apr 2020 14:14:53 -0700 (PDT)
Subject: Re: [PATCH] io_uring: fix ctx refcounting in io_submit_sqes()
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <8b53ce4539784423b493fdbfae9bd4c720b24d2a.1586120916.git.asml.silence@gmail.com>
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
Message-ID: <331eb009-a8c3-98c7-4cec-d91a821f22be@gmail.com>
Date:   Mon, 6 Apr 2020 00:13:55 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <8b53ce4539784423b493fdbfae9bd4c720b24d2a.1586120916.git.asml.silence@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="LAAFwmJSbOmoVNvfVa9WANJQWhdlvKHW9"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--LAAFwmJSbOmoVNvfVa9WANJQWhdlvKHW9
Content-Type: multipart/mixed; boundary="MpUJ3t078C23Yhln77CNhZqpcj2UdiCbZ";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <331eb009-a8c3-98c7-4cec-d91a821f22be@gmail.com>
Subject: Re: [PATCH] io_uring: fix ctx refcounting in io_submit_sqes()
References: <8b53ce4539784423b493fdbfae9bd4c720b24d2a.1586120916.git.asml.silence@gmail.com>
In-Reply-To: <8b53ce4539784423b493fdbfae9bd4c720b24d2a.1586120916.git.asml.silence@gmail.com>

--MpUJ3t078C23Yhln77CNhZqpcj2UdiCbZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 06/04/2020 00:08, Pavel Begunkov wrote:
> If io_get_req() fails, it drops a ref. Then, awhile keeping @submitted
> unmodified, io_submit_sqes() breaks the loop and puts @nr - @submitted
> refs. For each submitted req a ref is dropped in io_put_req() and
> friends. So, for @nr taken refs there will be
> (@nr - @submitted + @submitted + 1) dropped.
>=20
> Remove ctx refcounting from io_get_req(), that at the same time makes
> it clearer.

It seems, nobody hit OOM, so it stayed unnoticed. And neither did I.
It could be a good idea to do fault-injection for testing.

>=20
> Fixes: 2b85edfc0c90 ("io_uring: batch getting pcpu references")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 78ae8e8ed5bf..79bd22289d73 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1342,7 +1342,6 @@ static struct io_kiocb *io_get_req(struct io_ring=
_ctx *ctx,
>  	req =3D io_get_fallback_req(ctx);
>  	if (req)
>  		goto got_it;
> -	percpu_ref_put(&ctx->refs);
>  	return NULL;
>  }
> =20
>=20

--=20
Pavel Begunkov


--MpUJ3t078C23Yhln77CNhZqpcj2UdiCbZ--

--LAAFwmJSbOmoVNvfVa9WANJQWhdlvKHW9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl6KShMACgkQWt5b1Glr
+6UoOxAAsy645lj2RB08lPTdJNN8b996PhkC2pkZrUoccNFCnxegQD0rlJAsZnT+
OpVJipjd63C41eSd9Es9jOSbzT5twGCip1E+4V/yCWIcCRy7ZQg+ol5ieLtH7bDp
XrienhiI72dIghdRzWP5oMQj0Th1ifx1uLpP56XSuAj0XPdvgUmNURiPHf2Dr7w0
jNBUeJLs9ezc4wgpRU4aXqMdBpI3vsqR2TrhwynRjTWThjR50bUf9Vt2jsqbegVw
Z7myxGORCB9fMhooMH4iA9JVY4/RV1zraGNverWbQWyuY00Bqq0MNE5nbD7a5f/R
VGQTOZj3neSFFnJiadXn8oxNrs8/4p8wha9D51LWq5y3X5M4T9fCr+YxaStFhI3y
bvQIYYBu4M6EKrB93neYmhzpAEvjS24k4/7nUJHd5TNVddOyrfk5NiSzo9ynyrd8
GoTiHKgqnd+Yo9i69V6nHsmzo2MGOWwdkgxF8hZePvKE56YGcGSt17zk1ONpyrtJ
AGIRIjf7U4kxLurlgo7yoXcSM1KEB5QcpDtRTZSOzMKRfwvzRWlPz4SXRHKPNNLw
tsHhzsNA4qyNBOEy85hpYC+gQE6ZuIR1MDwoCtUkFIuioFSO/2DEtmuLD4AJ1jJ/
ypJ9dgrBKtRxEF5b+MuIr2IMwgppwJRDymWoLSPOU6tQ4q0id30=
=bQ0Q
-----END PGP SIGNATURE-----

--LAAFwmJSbOmoVNvfVa9WANJQWhdlvKHW9--
