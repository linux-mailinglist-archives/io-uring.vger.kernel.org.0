Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A958318EA4D
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2020 17:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgCVQZr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Mar 2020 12:25:47 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45213 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgCVQZr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Mar 2020 12:25:47 -0400
Received: by mail-wr1-f65.google.com with SMTP id t7so8960446wrw.12
        for <io-uring@vger.kernel.org>; Sun, 22 Mar 2020 09:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=akphjUiBTN/YCbrm1oMNrCglDC1ZvXpUc/GVHXZmaMY=;
        b=mHeWjQsT5xw/nLzHfanAXFukSsOWCVGaMK2pbTzIkGpolMeQFYvgdCFyr0fXcma43t
         P/sgnpDVwYET2xIDXawpl0VQggfVqQpPbp8KyGOj5vCjPk//D8pAxg5dnSF2YceWU4BU
         GhpIgPMfAeBAfuvClKeOvDIxqE1kYJ2m4ktunk6gpM5oMQJuL0NeIvEJpJLaxmlVmWiS
         xadP5YkJiLmNc0BJ6WKmQgZhVleiUEZ9OsXyyzp6siOU5zfWD9cpGNgU7PDo7YY1jiGV
         gC0DQ1oLuNZiYsTsLPBICHGibZzbQSRknGPj6pRfcckix1kOt/Zk7MSi7IUQOKMDVXQz
         LKMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=akphjUiBTN/YCbrm1oMNrCglDC1ZvXpUc/GVHXZmaMY=;
        b=EPv+K+BgLYM11ot/4YPhTUx4kPWT1nRXQgCal1aH4MlPwvx+D736QD8jhPCrb6TTry
         Hh+eBgJnt2Red0+f4INKE84WEXeD8ljWVqSY7FGlw+qF2Yqt0iKjZWQmKekPSQ2tMZN7
         pJKK8zBBoKw2IEHI2+qSllil10Y4Hqf2WF4l4bLJTUo2fbjfT4eRbRaWwt9da6H5pxsB
         8swtvbVPeirGf1aw32jsBCjQFkY3oIggZy5MLS5VOCYpO8NULBoE4RzMFdPvx8SdE+Ib
         bh2DisYP8dDwBystWHrA4k+aSgWHyBG433obZHxmeIBfatFLv7yUiwepMzTTAsxONiuG
         +NOg==
X-Gm-Message-State: ANhLgQ22EW4aCC3HpnMf3LAyV8Np9U8KmhhANZ8S437/2mOhsjcNlUIS
        CjdN9pJ6QoYmr08t+0slEuhYyLr1
X-Google-Smtp-Source: ADFU+vv9UPc7gMam5xgombpwKEKggi4PckZ74jkC/T9TYL2AeDanscDFc6usmEHqOQ+FFoBtmgalUA==
X-Received: by 2002:adf:ff81:: with SMTP id j1mr17500621wrr.171.1584894343594;
        Sun, 22 Mar 2020 09:25:43 -0700 (PDT)
Received: from [192.168.43.79] ([109.126.140.227])
        by smtp.gmail.com with ESMTPSA id y80sm18954678wmc.45.2020.03.22.09.25.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 09:25:42 -0700 (PDT)
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
 <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>
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
Message-ID: <cd8541df-8f97-af3c-ea49-422e546ab648@gmail.com>
Date:   Sun, 22 Mar 2020 19:24:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="A60iNAq1QCxn0GFZdLRkrrbqFyczTzYxl"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--A60iNAq1QCxn0GFZdLRkrrbqFyczTzYxl
Content-Type: multipart/mixed; boundary="U8VwPFr6ZQYQ787fVczplCsnhptjEJuC7";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Message-ID: <cd8541df-8f97-af3c-ea49-422e546ab648@gmail.com>
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
References: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
 <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>
In-Reply-To: <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>

--U8VwPFr6ZQYQ787fVczplCsnhptjEJuC7
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 22/03/2020 19:09, Pavel Begunkov wrote:
> On 19/03/2020 21:56, Jens Axboe wrote:
>> We always punt async buffered writes to an io-wq helper, as the core
>> kernel does not have IOCB_NOWAIT support for that. Most buffered async=

>> writes complete very quickly, as it's just a copy operation. This mean=
s
>> that doing multiple locking roundtrips on the shared wqe lock for each=

>> buffered write is wasteful. Additionally, buffered writes are hashed
>> work items, which means that any buffered write to a given file is
>> serialized.
>>
>> When looking for a new work item, build a chain of identicaly hashed
>> work items, and then hand back that batch. Until the batch is done, th=
e
>> caller doesn't have to synchronize with the wqe or worker locks again.=


I have an idea, how to do it a bit better. Let me try it.


--=20
Pavel Begunkov


--U8VwPFr6ZQYQ787fVczplCsnhptjEJuC7--

--A60iNAq1QCxn0GFZdLRkrrbqFyczTzYxl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl53kVEACgkQWt5b1Glr
+6XoTw/9EHO3F1pYAeCt3ZFexMzHWSdeE3+vFkHzZeFLg/3rszaelnfV/J3rMNHg
Uvqb+6pCG/XY41lhOCpMfMrkeNA2pHhKG8migkibskwr1vEcFRi1VAqZYGG3LFxK
2rTOGqrJZOos2qDhK0JWhHC+k3eibLHo7ILR0YBxBb8Q9oziXhbaexO//ryyRjhc
gKjX9rCqn/CPkrIqdYgbwjTn1++U7zHhtas9b7B5SCITTZEoPy7MvWVNcQYugRny
u2qvunawZksie0BVhwWWZV/rMJJ0dTKNDGsyRVyp9cnO4Sp0T2RTH1wSgs0mIun9
2P2BmFSC09WPRq9CkNK7zP/sojKhrKR/KfiDc9cv1jsefmIrI11K+E10xeB0hN0y
I7IlXx+EIOgFLIQg25U/jklgQZ2vgKfS7GBqaEH7nZTDL1+lg/RD02oy6EhMofi3
FgD+7b3pOiHrwCsGhKpvWpVPPcw9SdvaXXkMeoCjQOx5oZdVUV+0y4X//TamVC5n
f1OHnws0SKm3i3D5Tuk59BPJRT+Kd8sUrt1xxxKmVUpCtt1aljOREPg9qW3b7Pth
EIH70lXvxD550ORJ7Xmi2jjUlz+3U0AlN+g//5MX8b41EKLpDcOs/VoWUi2TNq8H
aNInJWzRYWGjKeAYKAbONw1mjl0G3EG5DzdN6OnZ0kQhPX/aA8U=
=lGob
-----END PGP SIGNATURE-----

--A60iNAq1QCxn0GFZdLRkrrbqFyczTzYxl--
