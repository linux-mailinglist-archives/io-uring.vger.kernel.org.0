Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B65A15603B
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2020 21:56:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgBGU4I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Feb 2020 15:56:08 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:42826 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgBGU4H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Feb 2020 15:56:07 -0500
Received: by mail-ed1-f65.google.com with SMTP id e10so966967edv.9;
        Fri, 07 Feb 2020 12:56:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=5riQ67SdTsnh0GsBZWiljabEtGy2R/wq70X4S9XXoZ4=;
        b=NaUFCQC6AHJiGV/05hY1AVi/cyC1sz15akpqcg5UQYzmQSU/aKevd87WLF7UFtxcUM
         awPX+xBFwivhKTX7oQreSsMJI6qmjcFOIFPhGlBrr6y8YYaBXDzXMcDdPELn9BDcntMI
         KL6IDTAllNq9m64XLqqgeWx9VHRsImRfWRfljQxN9v3S6qsYTDdGptDUWT85jR1N7G37
         4nFHX+ueNiPo7cBJkGbh8Cgo7oQGvnhQoyhB+9pp6CZ5JqRf1FVwml8GMe9IIU4+pfoK
         Qy2MCPzvAESkJ92Ii+UPHAp+JTZIdJV5b0xa+08V1x/AqOfz65EBu0VUQF/haIYxURzX
         6tEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=5riQ67SdTsnh0GsBZWiljabEtGy2R/wq70X4S9XXoZ4=;
        b=m5CWQZ9BdvT9RnSZ/avKPh53xUOHKxrUMRquiMsYSfgaT1xL9VqIdkJ42cVKltmJRe
         Ljyr5HjWWgnwLJV4qPkxesPXRyI9He8VPhfv7hjCMbzfST+kiQJajzyF8LlWjcX4SAhb
         ulHcGk7yaGQ43DknES5qWt7vO1vaee4VmKtGi4UGdWhMvbhN1sTHoi5C7pd2qGFvZLHL
         fwIqVWZXVsaTP6Xck1BhzwXQq6ixi0OXTvzOl+19F/pePZp0tCSvdJAQdCC4gW3YnoZZ
         6D9N9eeHdnAyvCITzlJZO7q3GJfFhQgQI9oPXodU45uIX3JN6nTr2NUYcjpOVEnqpcWc
         x7eA==
X-Gm-Message-State: APjAAAUFxGsPpQ1qk+IXBwayxMuazKYbxuQ3SNs24u0UT0g3ihaWuZKm
        y9c0f1uZU6t9Q6yiqlrtC3dUnhSg
X-Google-Smtp-Source: APXvYqxpg89rXfbMBvvGyqFcq3kOnqzSH56RL4Oj8wxpANJKtsTCutxMIuFh5zoSZ04CKgAOWIy3IA==
X-Received: by 2002:a17:906:6942:: with SMTP id c2mr1165794ejs.12.1581108965643;
        Fri, 07 Feb 2020 12:56:05 -0800 (PST)
Received: from [192.168.43.117] ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id a40sm213373edf.90.2020.02.07.12.56.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2020 12:56:05 -0800 (PST)
Subject: Re: [PATCH] io_uring: add cleanup for openat()
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <d3916b5d2c04e7c0387b9dce0453f762317dd412.1581108147.git.asml.silence@gmail.com>
 <6729b8f1-f048-8cba-8a7a-45ef1d8c3256@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
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
Message-ID: <e1ef3e54-4668-a269-2dfb-ce7b952be413@gmail.com>
Date:   Fri, 7 Feb 2020 23:55:25 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <6729b8f1-f048-8cba-8a7a-45ef1d8c3256@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="GlkJcoxwMWq9787WhjIcTHSGyXMXSrsQO"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--GlkJcoxwMWq9787WhjIcTHSGyXMXSrsQO
Content-Type: multipart/mixed; boundary="BUNFkmzAcO4gXvLZ9TK1OZgV12ofYMrtC";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <e1ef3e54-4668-a269-2dfb-ce7b952be413@gmail.com>
Subject: Re: [PATCH] io_uring: add cleanup for openat()
References: <d3916b5d2c04e7c0387b9dce0453f762317dd412.1581108147.git.asml.silence@gmail.com>
 <6729b8f1-f048-8cba-8a7a-45ef1d8c3256@kernel.dk>
In-Reply-To: <6729b8f1-f048-8cba-8a7a-45ef1d8c3256@kernel.dk>

--BUNFkmzAcO4gXvLZ9TK1OZgV12ofYMrtC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 07/02/2020 23:53, Jens Axboe wrote:
> On 2/7/20 1:45 PM, Pavel Begunkov wrote:
>> openat() have allocated ->open.filename, which need to be put.
>> Add cleanup handlers for it.
>=20
> Should this include statx too?

It should. Missed, that statx uses the same struct.
I'll resend.

--=20
Pavel Begunkov


--BUNFkmzAcO4gXvLZ9TK1OZgV12ofYMrtC--

--GlkJcoxwMWq9787WhjIcTHSGyXMXSrsQO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl49zr4ACgkQWt5b1Glr
+6WFERAAkTNwy4n6EQxwsIyRzDd+CmlogBBDZeXJBdU1gdgDgczIoT/jkg/xM+Cx
yCtLIm9H2R6o+OYuLesF0rg8Hy3RlRAdbxmVPA/a6BgebhRS9VHMPzzyaTiG467b
nsT1xfOg2R0nrVWPCX15xNKB2GbON5Jh7xYmlT2Fj6mFk2boCAV5Wel0E8B01aDd
EgYGmudJRjtlT83eBO180uJzCO8LwtRe5FVgMY+zuuws6a173AglC3n+nINjrn0Y
SPhp1eq3tr12oWA2ffPu7NUVicKl9wAS6I3VLSmtbZtOwVuJEMkg6R8zqEi1Sf/p
9julOmyZH+cE652GScA79SpY7vwJD9ihZW7TKlF0bMhbb66Xekcj6YGtHJWGLx8g
FpTTGRUdFd74ImwHY1JlwLoKzaA9DKgDW8wXZsJ1PRRJk+NjA9KKEZxmQtgD32E8
E6V24WZcid30b5xvyqKAS6GTtOi7Y/75IGGvkCvwk37Fh8LiARF8zWHOFt7ozWxo
NJ4leX2d+MRv4m2qZizq7/AjPguEt2yuoylF5u5OfmtShXOCRGZVHM2MHKNpeaK4
dBr0rtIThA4/JP+N+7GiG9PhUY52KtzKiXgLMzU9X8aFjsL/VJHfHdTmcSBb7syW
d/uVoB8UAkXXWr9plm0EJjOmKd2cOIWBpaCqXizeQJsz5HMthwI=
=dzvK
-----END PGP SIGNATURE-----

--GlkJcoxwMWq9787WhjIcTHSGyXMXSrsQO--
