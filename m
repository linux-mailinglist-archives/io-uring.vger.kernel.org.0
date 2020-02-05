Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD3E9153593
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2020 17:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbgBEQvB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Feb 2020 11:51:01 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39693 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726678AbgBEQvA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Feb 2020 11:51:00 -0500
Received: by mail-wm1-f66.google.com with SMTP id c84so3649588wme.4;
        Wed, 05 Feb 2020 08:50:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=GNfD+v5y6RyYcbwES/UgHaqU1BwN2IKYM5M3QSIMWho=;
        b=FSPgiyuahPk9g6NhYYRDxwbb8+YtdaGI7RjUdoriZp1/OOMAkxcYjfL/1bFeXPvl5n
         7g8NQDI4zozOMNdhNQxgdHmm/jGEyc416fQFUARJ/9ttmXo6iIO4H1KI9BSM/R0TEoDl
         cD87PRPCCODtoEm0pXB8iU2ltxsp4JDjt/vMapF13WL/eKIWb1EEuQ5mlJMBeoXAFZpA
         tLNIOYg2OiNO/1Ubt16PtKqYEiJ55O7o2W7vCnnFfOtM9RIHupEyj2FeMs5FGeRvR33i
         HrFbBM33joO7xhd7QQlvwKSdLX0oWhy0RW4wwD6+9foSC5dPqDtqb0tcQFea8v7KEIKx
         Mwxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=GNfD+v5y6RyYcbwES/UgHaqU1BwN2IKYM5M3QSIMWho=;
        b=Jqi9U5tcTl5ydA1ZDHZZfm6WE3LzcZPfe1DT/xtAfD6VMp7dCm3OWGqB4bUQA8hMIh
         ssdAvAKmLk22ToozMZmlxVTtZtMSxeT4saiw3jj2VFKnaZJqGVPkiPWETM3KqSdl6uDN
         XYv4dysmgWqzJWmD7uVyGuyA4k21omHoel9i63s4LSxvC2p+SkxHP9tEVEsknGY/M5iH
         hUXNLBmJwDiDDfBJs9zFwlB5oeOa9KMjWi5Y/T+dU81QEs6v8vLG3p7YpFPtnIu50QoG
         j3q5YBsWciakDXnE4divHziKfgqbsup7La/XjZLNaJLI+KQyMgFEoA9ZvFDZBHoW6TqS
         2ibw==
X-Gm-Message-State: APjAAAXong6Ihq/s927U6jfY0X+VMfMTNq54HeduIWpHJ1jtoGc+HbKJ
        6Q5OxhwgknplBvgfK5VE4Yv4vrtb
X-Google-Smtp-Source: APXvYqw2OXfV/cYfB1uoYhwXoSuPqN0wuPOvW4vS0kq+yGTU+Bu4nbmG6kpXZLcvNBXxFPm9kg5fWg==
X-Received: by 2002:a05:600c:2290:: with SMTP id 16mr6249615wmf.184.1580921457878;
        Wed, 05 Feb 2020 08:50:57 -0800 (PST)
Received: from [192.168.43.126] ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id t10sm147634wmi.40.2020.02.05.08.50.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 08:50:57 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <951bb84c8337aaac7654261a21b03506b2b8a001.1580914723.git.asml.silence@gmail.com>
 <df11c48e-f456-3b64-88d1-6012b1ac2bc8@kernel.dk>
 <d9a15d32-a20b-a20f-9ea4-3ac355c15bb2@gmail.com>
 <c6cc1e97-f306-e3f0-3f7b-9463fdbbc5a5@kernel.dk>
 <d55fd4dc-e7f1-0f06-76bb-0e29c1db4995@kernel.dk>
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
Subject: Re: [PATCH] io_uring: fix mm use with IORING_OP_{READ,WRITE}
Message-ID: <62e33e81-7857-fb5c-92be-6757623a6478@gmail.com>
Date:   Wed, 5 Feb 2020 19:50:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <d55fd4dc-e7f1-0f06-76bb-0e29c1db4995@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="8WeZfF0cieSpIUpc3RhwHnvtRbv55nPtK"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--8WeZfF0cieSpIUpc3RhwHnvtRbv55nPtK
Content-Type: multipart/mixed; boundary="7N414J0GCl7O0RM7gWpbTzob2uj81ZNC1";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <62e33e81-7857-fb5c-92be-6757623a6478@gmail.com>
Subject: Re: [PATCH] io_uring: fix mm use with IORING_OP_{READ,WRITE}
References: <951bb84c8337aaac7654261a21b03506b2b8a001.1580914723.git.asml.silence@gmail.com>
 <df11c48e-f456-3b64-88d1-6012b1ac2bc8@kernel.dk>
 <d9a15d32-a20b-a20f-9ea4-3ac355c15bb2@gmail.com>
 <c6cc1e97-f306-e3f0-3f7b-9463fdbbc5a5@kernel.dk>
 <d55fd4dc-e7f1-0f06-76bb-0e29c1db4995@kernel.dk>
In-Reply-To: <d55fd4dc-e7f1-0f06-76bb-0e29c1db4995@kernel.dk>

--7N414J0GCl7O0RM7gWpbTzob2uj81ZNC1
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 05/02/2020 19:16, Jens Axboe wrote:
> On 2/5/20 9:05 AM, Jens Axboe wrote:
>> On 2/5/20 9:02 AM, Pavel Begunkov wrote:
>>> On 05/02/2020 18:54, Jens Axboe wrote:
>>>> On 2/5/20 8:46 AM, Pavel Begunkov wrote:
>>>>> IORING_OP_{READ,WRITE} need mm to access user buffers, hence
>>>>> req->has_user check should go for them as well. Move the correspond=
ing
>>>>> imports past the check.
>>>>
>>>> I'd need to double check, but I think the has_user check should just=
 go.
>>>> The import checks for access anyway, so we'll -EFAULT there if we
>>>> somehow messed up and didn't acquire the right mm.
>>>>
>>> It'd be even better. I have plans to remove it, but I was thinking fr=
om a
>>> different angle.
>>
>> Let me just confirm it in practice, but it should be fine. Then we can=
 just
>> kill it.
>=20
> OK now I remember - in terms of mm it's fine, we'll do the right thing.=

> But the iov_iter_init() has this gem:
>=20
> 	/* It will get better.  Eventually... */
> 	if (uaccess_kernel()) {
> 		i->type =3D ITER_KVEC | direction;
> 		i->kvec =3D (struct kvec *)iov;
> 	} else {
> 		i->type =3D ITER_IOVEC | direction;
> 		i->iov =3D iov;
> 	}
>=20
> which means that if we haven't set USER_DS, then iov_iter_init() will
> magically set the type to ITER_KVEC which then crashes when the iterato=
r
> tries to copy.
>=20
> Which is pretty lame. How about a patch that just checks for
> uaccess_kernel() and -EFAULTs if true for the non-fixed variants where
> we don't init the iter ourselves? Then we can still kill req->has_user
> and not have to fill it in.
>=20
>=20
On the other hand, we don't send requests async without @mm. So, if we fa=
il them
whenever can't grab mm, it solves all the problems even without extra che=
cks.
What do you think?


--=20
Pavel Begunkov


--7N414J0GCl7O0RM7gWpbTzob2uj81ZNC1--

--8WeZfF0cieSpIUpc3RhwHnvtRbv55nPtK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl468kgACgkQWt5b1Glr
+6XV7A//cIn1cVwo4wwBJu9BLQbEn2Xgya1OaDhPznWXIWuzijlkMXXWxICh949D
JrfejhvIS6xqmswjPdnzTQJKvj/HH8EXt4mUsIMGl6mB1LNS+S6H1wyynMzL/mA9
QkNi6cGWkEJyxnpZRZjWLyN0wYwDj45TRDVKRk1eqJeXn+IF+/JtZc6pmpQ+53OG
vrRc4gCKBS+1vfhZoDvpksxZFhS2k8MqoXQNlGHFzX5QwGP0Mqon0XAEoMOEWbI0
42W6XTiR0fILGuELkWum/n66sJ6YruaCtwOWVWJctQ4jmKZmYM6fW8c6hIxk5jpS
2y16eTIkvakkbrAxcJWGQ5BbOxwVl6Wi63nZ7L9Vcsn72LjBv2liy2vEetd+OAnN
E5xALbXQKnnz9nyOVS7wdjydHf0O2Rvhh/g03aVmrHp4QliDdL1HKJJ8DxFE3PW5
LmVz2S8qmgTk7hONT4phNVhwWS12HEqxHwsYRj2mzSaVtXYj3A5t7ZcJLFPEfZdV
jOmR8Xklc2H/YjOSh63oq0yZ5DNSWvRXUxgmzleQo3mWYLVb83THsUXmoVqqDbqF
hlaOfrUFWZp/7LEtqG9lE/ozTBkCT1MolOURagJGcwGE2N/6mDOvo1UYBIbz+mai
StRgEaI0nVrlfrxFGvAJegDOQwWHXVmsf7qfaojq71zi0oOoX9o=
=AcP9
-----END PGP SIGNATURE-----

--8WeZfF0cieSpIUpc3RhwHnvtRbv55nPtK--
