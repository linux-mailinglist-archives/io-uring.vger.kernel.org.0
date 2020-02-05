Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16BE31534E7
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2020 17:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgBEQDi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Feb 2020 11:03:38 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35692 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgBEQDi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Feb 2020 11:03:38 -0500
Received: by mail-wr1-f66.google.com with SMTP id w12so3415525wrt.2;
        Wed, 05 Feb 2020 08:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=pnB9RCK8FmRp6yLoMoOe15khy7Rws9cOlB5/jAIV8gM=;
        b=D2XdTal3it2TTNpDINBSeYT7p6p2oMx0HeYjsyDEjbZFaxKU/MHENzcL9yOLWq7O0e
         DffMDHUkj7WCr6kdiub+RL+EZci3Iji2+Ehe9HGfS5OFFQXyD/DNzUesR+unrbkJ67CX
         IhQZrxFT8iPqmG4mPFSO5iCZpHD7g1Vzw1ZSlyiA7e+kvq1XG52R9gqy36ZrGlBlQtea
         iPwqeoL+ZbU1gbCm1hikPJGQaASM5Il28GR///9IpVcHGZvCGAb3HeK7+pGLlyELnCk3
         v9UpngxvPi37nHT5RPm6YCAOTmr06hNv6FOh9gUTJX6VWkuEhOzsoWgVoXLApy5hbYV/
         Vf+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=pnB9RCK8FmRp6yLoMoOe15khy7Rws9cOlB5/jAIV8gM=;
        b=RikiRGMPL1KL7p9rx8h3gmFVQDX36fdMDdaeouVatDz5bbwUZn3zdned3K5G3pvFag
         FeHR1VHAZu7urY6y6TGK/ZBVd5yTuuck8j3uiZXw2pj7vHQvkOAIxWlSM5bAruXJgJTE
         uhYdf7+BmI1wcdcLOxi76AnIdSURwsd9zMoFT2cKQIK4byqHw/xLq8vdQdtq6FnLUjiB
         r+CeIOUUAaTd461rYmPq5jK+3hhlK8wjiqO9nclbVT2gGoJFd0gB0u3cCKP188BI4B5s
         omjtwPajJ+MndhhVTtL8mC6p66csxV8ilLm/+5ZrdyCtaO/CDO83B6ZfPsFEYev0TdCE
         CJkA==
X-Gm-Message-State: APjAAAVxP9/q7AcZ1zmeaelEWsBAwhrGvO7GM9COnjcVk8Pzj4BWgdO0
        vhj2P+X26VuhOZVZalfK/G7vmCXx
X-Google-Smtp-Source: APXvYqyzdGOQ01ccfwSGHyY9OJa44nj5odr8JsddGNX2FBcW8FpSLrunLgbdcQ1Z5mED96i46NHTag==
X-Received: by 2002:a5d:640d:: with SMTP id z13mr27826512wru.181.1580918614029;
        Wed, 05 Feb 2020 08:03:34 -0800 (PST)
Received: from [192.168.43.71] ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id c4sm56841wml.7.2020.02.05.08.03.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 08:03:33 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix mm use with IORING_OP_{READ,WRITE}
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <951bb84c8337aaac7654261a21b03506b2b8a001.1580914723.git.asml.silence@gmail.com>
 <df11c48e-f456-3b64-88d1-6012b1ac2bc8@kernel.dk>
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
Message-ID: <d9a15d32-a20b-a20f-9ea4-3ac355c15bb2@gmail.com>
Date:   Wed, 5 Feb 2020 19:02:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <df11c48e-f456-3b64-88d1-6012b1ac2bc8@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="pfG2uHdMyEOlx73mzYfCtv0xqbZ3OaDK1"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--pfG2uHdMyEOlx73mzYfCtv0xqbZ3OaDK1
Content-Type: multipart/mixed; boundary="TRgd0f8QT4hS02KsLbX8dpCiLVl9KzSjQ";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <d9a15d32-a20b-a20f-9ea4-3ac355c15bb2@gmail.com>
Subject: Re: [PATCH] io_uring: fix mm use with IORING_OP_{READ,WRITE}
References: <951bb84c8337aaac7654261a21b03506b2b8a001.1580914723.git.asml.silence@gmail.com>
 <df11c48e-f456-3b64-88d1-6012b1ac2bc8@kernel.dk>
In-Reply-To: <df11c48e-f456-3b64-88d1-6012b1ac2bc8@kernel.dk>

--TRgd0f8QT4hS02KsLbX8dpCiLVl9KzSjQ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 05/02/2020 18:54, Jens Axboe wrote:
> On 2/5/20 8:46 AM, Pavel Begunkov wrote:
>> IORING_OP_{READ,WRITE} need mm to access user buffers, hence
>> req->has_user check should go for them as well. Move the corresponding=

>> imports past the check.
>=20
> I'd need to double check, but I think the has_user check should just go=
=2E
> The import checks for access anyway, so we'll -EFAULT there if we
> somehow messed up and didn't acquire the right mm.
>=20
It'd be even better. I have plans to remove it, but I was thinking from a=

different angle.

--=20
Pavel Begunkov


--TRgd0f8QT4hS02KsLbX8dpCiLVl9KzSjQ--

--pfG2uHdMyEOlx73mzYfCtv0xqbZ3OaDK1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl465y8ACgkQWt5b1Glr
+6W/MA//ZWBm820DWIhID/ljMSZYFtMkVORKhCMRNOOgee8vcbXFg8BdD8cjMg0i
hNzoRTAlh+fxJ1UaV1pikzntvjDL03Uys9HqrxHHqjbi4FSOPcSuylIML8AgZ+dZ
t5M6JhBuuliSW7bI//iQQpdVCe2syfdsIuzML90sEu+9XIJ2SZi+rbg2qMjNEtH/
kYsCsVfCRDSa/kNuu27xuzXin2LcCfLWTl5dQd0fA2AkzQVxAhcA0jYMFMrEBHbz
RswLCyQ5byBhIDP1ct2deOZu03mdtXrT2LLw2exG+JZJPx3X+0KkzR8BRe8PfgYA
0TSWkX+6s4ICAUPHkeWcTCdIO9bA39FOp/kbpJHZF7UTx09VEoEqGo6+sFTbD92K
jIiOf/rBH6rgkHaY7w6c0pPRhEXiwqkR8Gj94GK5ubZBcBZSXEbndNWwkCJeI4La
loW26WfP/BTRCqCrC3eszh4X+ejL4cgKUgWewxKKkM7OVJn9WBDz9Fu+9TgBuQUe
lmRWCmFvJLZIKnBUyer1Xglia1WsmiicH8c8xsFspqahUxHm5KxAUVk1YDtODn3/
Bm9UnMZ/IZaoJgUfLCvWPYsJZyVotu9QI1v8ne1ukee7FfurX3W9gtRGBDbepV6T
0H+9TFyG+y73VDpngFbyJiUDj6elOt4etRawsVfC03277a6XhlE=
=Hwr7
-----END PGP SIGNATURE-----

--pfG2uHdMyEOlx73mzYfCtv0xqbZ3OaDK1--
