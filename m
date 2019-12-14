Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B54A311F251
	for <lists+io-uring@lfdr.de>; Sat, 14 Dec 2019 15:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfLNOov (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Dec 2019 09:44:51 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46993 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbfLNOou (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Dec 2019 09:44:50 -0500
Received: by mail-lf1-f66.google.com with SMTP id f15so1269878lfl.13;
        Sat, 14 Dec 2019 06:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=GvncOYK7wTHUmXZxIEpUNiTwon1Kt9JqfEYhCUsVhTY=;
        b=GPFxKyLN0byQXUDpFt+dJFyxO8eyZYY+tE5wC19DG3DqTyGxLYET3YKW4UsRQ9K5cb
         dhjcVKHwRe6GxnA0o1I5FSYOhaqePDrk38TgRgV9kdWBhaTpwbMj0hD5vy+mUtQo3JWV
         HoZe53nvVGwfWKhwzFjbf9epRj2y/6f9Mi6xo6Xo5xKw9PIePsvFobIHrNrfvGO+N4TN
         ZCcjYAUGgXOhAUX3mESmYQ6nAFvn0HgIB/MGORnk7vdd/bxc5AwZ4h14rioBw3zXZUMK
         BuDBA/mqIz2XYX0tl0xpfK26hXFP7ZwSt7dkoVBURNJmx/UM9HzW9lqmDp1EghgLLvSZ
         XTew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=GvncOYK7wTHUmXZxIEpUNiTwon1Kt9JqfEYhCUsVhTY=;
        b=HncNAFh6YaVZcOMrwSbKD2TyKEI243NGXfvck1nENJOl8xztNCqhO7qEfi8c0vl8kK
         cg3yIMlRUSssG8OO8VE7ylk03rHNid/2oI1rVtSLETjYTVuxukMF7VvDLGQ/G2dmKLRq
         ga/I2duTNhH3H+JAMW4S6qxkXvacAAHxLGb1QH7WTNsCQvgwYprCj/Bo5jenmWH7YU+D
         J216UZbl90dboHnyb+BT4nAko9tPc6w3innL38XMayTX3XJNgVxtrUlf1eOILqA3+ed0
         m1WKlPVi4tAIsnL0nrrlWhxq+N0Yxtli8tBcosx5YMx7/qmt8LVH5JvaUeL0hnMCrv6M
         5UOQ==
X-Gm-Message-State: APjAAAXc48FBqHXFTvybX3H0F9xRKQLHqPN22t67TAtzfY4szlFEOvZD
        OngmwHG9gHwR7vFvhLmAJH77ol79ipw=
X-Google-Smtp-Source: APXvYqxHdVC663CBa5xt4fqYkdsI/TD3JT8/Y0ongGnNJTT3c4yc2uYcByyKRY7Usmy1C7k6lePNWA==
X-Received: by 2002:a05:6512:c7:: with SMTP id c7mr12301699lfp.120.1576334687557;
        Sat, 14 Dec 2019 06:44:47 -0800 (PST)
Received: from [192.168.0.72] ([212.122.72.247])
        by smtp.gmail.com with ESMTPSA id a9sm5951754lfk.23.2019.12.14.06.44.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Dec 2019 06:44:46 -0800 (PST)
Subject: Re: [PATCH v2] io_uring: don't wait when under-submitting
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <5caa38be87f069eb4cc921d58ee1a98ff5d53978.1576223348.git.asml.silence@gmail.com>
 <6256169d519f72fe592e70be47a04aa0e9c3b9a1.1576333754.git.asml.silence@gmail.com>
 <55f01a72-fcbc-a3e4-d9db-7dd2a7ef1acd@kernel.dk>
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
Message-ID: <28db945c-080f-1951-b4ff-b315f2d0be68@gmail.com>
Date:   Sat, 14 Dec 2019 17:44:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <55f01a72-fcbc-a3e4-d9db-7dd2a7ef1acd@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="i3rnraO7zOAROH2n7N9jLcB59RVYA2D7k"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--i3rnraO7zOAROH2n7N9jLcB59RVYA2D7k
Content-Type: multipart/mixed; boundary="R6aEDUDfRRE2I8zWq1o0o6OWYoHULpCPw";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <28db945c-080f-1951-b4ff-b315f2d0be68@gmail.com>
Subject: Re: [PATCH v2] io_uring: don't wait when under-submitting
References: <5caa38be87f069eb4cc921d58ee1a98ff5d53978.1576223348.git.asml.silence@gmail.com>
 <6256169d519f72fe592e70be47a04aa0e9c3b9a1.1576333754.git.asml.silence@gmail.com>
 <55f01a72-fcbc-a3e4-d9db-7dd2a7ef1acd@kernel.dk>
In-Reply-To: <55f01a72-fcbc-a3e4-d9db-7dd2a7ef1acd@kernel.dk>

--R6aEDUDfRRE2I8zWq1o0o6OWYoHULpCPw
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 14/12/2019 17:39, Jens Axboe wrote:
> On 12/14/19 7:31 AM, Pavel Begunkov wrote:
>> There is no reliable way to submit and wait in a single syscall, as
>> io_submit_sqes() may under-consume sqes (in case of an early error).
>> Then it will wait for not-yet-submitted requests, deadlocking the user=

>> in most cases.
>>
>> Don't wait/poll if can't submit all sqes, and return -EAGAIN
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>
>> v2: cap min_complete if submitted partially (Jens Axboe)
>=20
> Can you update the commit message as well, doesn't really reflect the
> current state of it... Apart from that, looks good to me!
>=20
Right, thanks for noticing!


--=20
Pavel Begunkov


--R6aEDUDfRRE2I8zWq1o0o6OWYoHULpCPw--

--i3rnraO7zOAROH2n7N9jLcB59RVYA2D7k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl309UsACgkQWt5b1Glr
+6XNSBAAh9DDpRL9bYvDQc79J4TpMuJU6ToJNihLy31tGupizwsWQSt8awYf/Vx6
9RtaDNi/4xLKms0hBQbSn30kA7xk7G0rAoDouwHLW4Hie9+1Jq0X8qmzAl244ToU
GMt9MKiLmq2lneeZdAJ094ga+57L1jAtOzAtGg3T9uPhiUBtNRClo2ib/OqqS779
zxxewbF0oXh1Ksgi63ytW7C9CskMMWwaE/T1xCsWRqqWQklE7dXMxYdpJ6QBLxkZ
h4626aPRtrK5OBCyW7XgynM3TKfeLwqYbp9h1Ks0itu0S2TUV/PupQwyzdaDe7/+
FSeXyop1iNiMHOSgfsxr6ptfZoFBuJntaj90VNwtBSMeNav8guk1uDtKAWnaQoHz
LvqVcjZVH0D84c6oQLWRSyNzl2MdqMcCRXjVzr6cpXBpaBbu50i7cFWMj8vK6F0a
CmEs0ha5MZmGMe30+yf6c5kzGYFSRqDVaGsF65lmTeQz55MNpyr9M6eJpG5DaHbQ
Wg+y9dT0qHdqnIMljB2LM5qaGOz/fgQfag8lYeZ4zan5QZ8QqceRiROy/9iFTzuP
ieUDzB+cXDSX0kNe6HbM0wLo1YgDfNsIYNczhmI/7Vwwt7CVivWZQeWkdVz3/eZn
6Vg8uycAeslsCofwRbFiKhpNN7SFzy+hkbiKlzBRHgS4xOFtNp0=
=B8m+
-----END PGP SIGNATURE-----

--i3rnraO7zOAROH2n7N9jLcB59RVYA2D7k--
