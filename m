Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 938431560AA
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2020 22:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgBGVTf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Feb 2020 16:19:35 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38215 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgBGVTf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Feb 2020 16:19:35 -0500
Received: by mail-ed1-f66.google.com with SMTP id p23so1055005edr.5;
        Fri, 07 Feb 2020 13:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=OWCBZ6tih1HyNFzDGB/mSHGPgMhLO6Fnq6qaK7NUkrc=;
        b=UICGqB223vOOu2383pFCn98guTfsMca3NzGr2bG+AJzB/wTCRdAZFrhNXuIcb8PrNX
         1hgj0qowVg+9Q0qktE4S76GfRxS1hEiDIAt5ZlituWPMx+UW7djSador0D2T8aP5JsGM
         xycPdQxTgaEb+yGM6SWcPBIBpIXthbynQuINR+5ZJ06Z6w+l5d5J2F6dBmXcU3IbVUfk
         Jo4xMCph5Tc4ifhdX9qnty9WwOGk1wNrBvuubzMFQHuxFtIwJKfzO7dCKoeZy7R81303
         989Zy61R9dCiERWoXIDK1F/ZPZrMgQo6UV68Z33zDnTUc8AJMF7j3FE9KLf0BSw1S2eR
         WEpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=OWCBZ6tih1HyNFzDGB/mSHGPgMhLO6Fnq6qaK7NUkrc=;
        b=Ii55JjTLWpNOS73TNFJx21V8QHeR+9+JlPfrOtT2JMZr02gKpEor4YImfK3xHv/FFl
         udag+CDjUbl6EkAGMGzfa6l8OzRqxhJEkrWIH6yKOxOBbqlNDx4exOABSQ5dXaA7kkil
         JAcyG8CkG51ZKI/MWwsp8VSvx8Z54iIQJtDAGpf88Z7N7sUPrCmqJoIRkwTK1HaztkQJ
         Rkdu7x+OM0GtYpCbiC4oJ2sCW8n8gK5YMqXLensAnB8Q74peiOLvl3RMpKveUQ39+8Kg
         H2bQ10hxJE1iKsxUd/t5mwK+v1hoe4j/kWR/VxzJ84rNfNI4ITsF6/84piN5xTDgNxpd
         wGbQ==
X-Gm-Message-State: APjAAAUZrkJxqc3F+sQ8f/K7i4W3h0pg+drVOTUuiZr+fn3ixBSufuk6
        Sgi6Bwc/C06A6lEecYKHpNTEXDsD
X-Google-Smtp-Source: APXvYqz/z1XrGqOHiPHsCg12e+jf8nNd2aAlDTzSZua9PfHTyGKug0J8xIXh8veDjbsM3f7RyR4Ksg==
X-Received: by 2002:a50:cfc1:: with SMTP id i1mr812421edk.366.1581110371916;
        Fri, 07 Feb 2020 13:19:31 -0800 (PST)
Received: from [192.168.43.117] ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id k11sm479668ejq.24.2020.02.07.13.19.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2020 13:19:31 -0800 (PST)
Subject: Re: [PATCH v2] io_uring: add cleanup for openat()/statx()
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <b55d447204244baca5a99c53fb443c20b36b8c0e.1581109120.git.asml.silence@gmail.com>
 <10b7caed-06dd-f6a0-24f1-648968011e40@kernel.dk>
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
Message-ID: <66ab5ebd-8a9c-47bc-1bf2-8a328e70c290@gmail.com>
Date:   Sat, 8 Feb 2020 00:18:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <10b7caed-06dd-f6a0-24f1-648968011e40@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7uuPjldF0rMczuXUAWDrpXw3B02Hl8en9"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7uuPjldF0rMczuXUAWDrpXw3B02Hl8en9
Content-Type: multipart/mixed; boundary="LoWLipQcGjVDclvdaAczuwtdlfwjfZVpv";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <66ab5ebd-8a9c-47bc-1bf2-8a328e70c290@gmail.com>
Subject: Re: [PATCH v2] io_uring: add cleanup for openat()/statx()
References: <b55d447204244baca5a99c53fb443c20b36b8c0e.1581109120.git.asml.silence@gmail.com>
 <10b7caed-06dd-f6a0-24f1-648968011e40@kernel.dk>
In-Reply-To: <10b7caed-06dd-f6a0-24f1-648968011e40@kernel.dk>

--LoWLipQcGjVDclvdaAczuwtdlfwjfZVpv
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 08/02/2020 00:13, Jens Axboe wrote:
> On 2/7/20 1:59 PM, Pavel Begunkov wrote:
>> openat() and statx() may have allocated ->open.filename, which should =
be
>> be put. Add cleanup handlers for them.
>=20
> Thanks, applied - but I dropped this hunk:

That's the second time it slipped, I need to read patches more attentivel=
y.
Thanks

>=20
>> @@ -2857,7 +2862,6 @@ static void io_close_finish(struct io_wq_work **=
workptr)
>>  	}
>> =20
>>  	fput(req->close.put_file);
>> -
>>  	io_put_req_find_next(req, &nxt);
>>  	if (nxt)
>>  		io_wq_assign_next(workptr, nxt);
>=20

--=20
Pavel Begunkov


--LoWLipQcGjVDclvdaAczuwtdlfwjfZVpv--

--7uuPjldF0rMczuXUAWDrpXw3B02Hl8en9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl491DgACgkQWt5b1Glr
+6VPRg/5AaMTrZu9rk7XcHCN5mjMLegmEPR0z+qdHzR7++6LKUslGj4TELRyfw0G
pQWuFjc3JPozFJgrj1S/0mN76Rqy5sncSA/OfRPVRrlXi3RqGNU+5RUpK5OaS6Qy
Yq0miHIViKCmZSP7qyhbe6KRqfQnkWnVRgSJyGeiJgkwTMIAaDbkYOdjOHvMWhcP
14Sj5ZXqbMZWICOdFzCjvagaSzJ/0XRg9ol0oyOdXljvMPFcZ19Uq/6b2ub7Kv5S
kmR4a2/U0vB6ouRq/s0khgEpDeVL1S0A2SSviCpIvGTxEvcztA7foUPsqi2LrdBC
15LyqGs+Ew20qnCT9YJg8PIY0WJkM6zKmoujboJplJiA9922n+w9TLzc591yFcGx
EctgXNAOq8WCmBy6+ZH0rdL23OZOWs2hCvVDz1nisFXiNVdzqRj2AQVSKaf9AP+c
7vnesUjkBLLu42e+Gm9Pgc6kzoCHKqe1nKAkvn3niGjwsGX+vm82Bj2+752zLjJ2
7UEZrs2qCSjmPix0fTF5OxzBdyAmvIVhaVpYC9jIyb07qsvuSpFMzcJQVFOC9VgU
3pqPybvyE+fz8WaO3Q42iE4CeFAh3b5HMeuiffFJ1DNRI+3WcPuS9QHVSaG7DwjZ
N7wZNQDAbz1ojVWZrMILTV4cAYOwKOmhbLIubFCwR7q+t4Jf3ZE=
=35C3
-----END PGP SIGNATURE-----

--7uuPjldF0rMczuXUAWDrpXw3B02Hl8en9--
