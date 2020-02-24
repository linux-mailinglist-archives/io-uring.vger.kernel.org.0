Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1528516ACF1
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 18:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbgBXRRR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 12:17:17 -0500
Received: from mail-wr1-f46.google.com ([209.85.221.46]:32976 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727259AbgBXRRR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 12:17:17 -0500
Received: by mail-wr1-f46.google.com with SMTP id u6so11353487wrt.0
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 09:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=KdkPsx5Fo701ZnIqORF6klJ5kZ2/Goij1JuYFr0fIhM=;
        b=YJbLUE+q9gHjW4VQTsSVGrg6W/4krkt09XPWL2sHnt6f0JyimES/9wiDryrh6DaUcu
         UeaVbenKi07KWcGcRL4q7TKohL2UtOGLVggOgDqaiMLiOFXwPoWB/QvEMNhEB6UDGoml
         5flID9ZNp5d3j8hS1ifr+3Q0GEKvAixUQsHxBtobjuL0BgY3V2jq10+9DKpYp+x0RsJu
         WmKkV3PiMD7qKdYo9MGN5iB7pqThSW17PKMfMG0oRtbQSe4rK/mnNXdVg1u32cLhU/b/
         JuOyKhwqtIpn6vKQMQWDRPv5UzntYjB91w0Z7XpDJbaLZzyIir5PtiA5Bj1v1rSRT5i6
         hnZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=KdkPsx5Fo701ZnIqORF6klJ5kZ2/Goij1JuYFr0fIhM=;
        b=X9d1sgorvz7wxxKH8HhETDfZdtq5T5H8StRJnXfxg77xQTxXLd+ZfE33u1xtOnagtf
         HCy74Bh4deaDj9GuJoj5OI13q9wxcVVX6jFEIDRVZdYrRW6BbAJS907KODW1sVEOze/W
         eTYAsAYdMWEJT152sDytr3QtO3WQDvLzzX7xWOMn5qqx73nUxcw3CkbWGATHaPB6Wg+E
         C/dRDRzNFl9b7jGTh5Je+Z6BZZuVTmR+MV0fDEAuzYhZfloSu5IhpnTsWUDkyyNVhFJy
         C//EJ5oUYARNB+5U7jPSzwIGVG1LSW2Hs4HemDmZmjLDueNCiSdHw/XgoXLBENO2FmZe
         Incg==
X-Gm-Message-State: APjAAAVVfebilvL4Ld1OPAXGvCjPZ/AWa2oHquTSGWZZYgrt6KoFHcZO
        xDEd7zW7A0DzsuYK+YH98/hlCtdJ
X-Google-Smtp-Source: APXvYqwefXpOn/Zk5dxebhaTm/F/uj+SIf3/IBE2RmD8CzHYiQumwrArC4Z/tfwRupRd9u1Up3pxDA==
X-Received: by 2002:adf:828b:: with SMTP id 11mr6032425wrc.169.1582564633709;
        Mon, 24 Feb 2020 09:17:13 -0800 (PST)
Received: from [192.168.43.177] ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id p12sm19759415wrx.10.2020.02.24.09.17.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 09:17:13 -0800 (PST)
Subject: Re: Deduplicate io_*_prep calls?
To:     Andres Freund <andres@anarazel.de>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
 <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
 <933f2211-d395-fa84-59ae-0b2e725df613@kernel.dk>
 <23a49bca-26a6-ddbd-480b-d7f3caa16c29@gmail.com>
 <065ee992-7eaf-051a-e8c5-9e0e8731b3f1@kernel.dk>
 <746b93f0-d0b5-558a-28c7-a614b2367d91@gmail.com>
 <c17acad2-89f6-b312-f591-c9e887b4fc2b@kernel.dk>
 <ad07fe70-ea45-a1bf-21c3-9af241bdef15@gmail.com>
 <b9901cca-caab-2261-2482-9bf9f81d589d@kernel.dk>
 <aacab312-9768-3784-0608-40531e78ee2b@gmail.com>
 <20200224170846.o54p2uv4qv4arygj@alap3.anarazel.de>
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
Message-ID: <f0548228-ee23-f848-9dd8-303ac3cd927e@gmail.com>
Date:   Mon, 24 Feb 2020 20:16:24 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20200224170846.o54p2uv4qv4arygj@alap3.anarazel.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3nJ50J5V2BLSvispVTQy1TuwFJdSjqWlU"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3nJ50J5V2BLSvispVTQy1TuwFJdSjqWlU
Content-Type: multipart/mixed; boundary="X9yrC1bviq5bl4CQaUoQ7mqugc3QxjCXa";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Andres Freund <andres@anarazel.de>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Message-ID: <f0548228-ee23-f848-9dd8-303ac3cd927e@gmail.com>
Subject: Re: Deduplicate io_*_prep calls?
References: <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
 <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
 <933f2211-d395-fa84-59ae-0b2e725df613@kernel.dk>
 <23a49bca-26a6-ddbd-480b-d7f3caa16c29@gmail.com>
 <065ee992-7eaf-051a-e8c5-9e0e8731b3f1@kernel.dk>
 <746b93f0-d0b5-558a-28c7-a614b2367d91@gmail.com>
 <c17acad2-89f6-b312-f591-c9e887b4fc2b@kernel.dk>
 <ad07fe70-ea45-a1bf-21c3-9af241bdef15@gmail.com>
 <b9901cca-caab-2261-2482-9bf9f81d589d@kernel.dk>
 <aacab312-9768-3784-0608-40531e78ee2b@gmail.com>
 <20200224170846.o54p2uv4qv4arygj@alap3.anarazel.de>
In-Reply-To: <20200224170846.o54p2uv4qv4arygj@alap3.anarazel.de>

--X9yrC1bviq5bl4CQaUoQ7mqugc3QxjCXa
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 24/02/2020 20:08, Andres Freund wrote:
> Hi,
>=20
> On 2020-02-24 19:18:26 +0300, Pavel Begunkov wrote:
>> On 24/02/2020 19:02, Jens Axboe wrote:
>>>> Usually doesn't work because of such possible "hackier assignments".=

>>>> Ok, I have to go and experiment a bit. Anyway, it probably generates=
 a lot of
>>>> useless stuff, e.g. for req->ctx
>>>
>>> Tried this, and it generates the same code...
>>
>> Maybe it wasn't able to optimise in the first place
>>
>> E.g. for the following code any compiler generates 2 reads (thanks god=
bolt).
>>
>> extern void foo(int);
>> int bar(const int *v)
>> {
>>     foo(*v);
>>     return *v;
>> }
>=20
> Yea, the compiler really can't assume anything for this kind of
> thing.
> a) It's valid C to cast away the const here, as long as it's guaranteed=

>    that v isn't pointing to to actually const memory.
> b) foo() could actually have access to *v without the argument,
>    e.g. through a global.
> and even in the case of a const member of a struct, as far as I know
> it's legal to change the values, as long as the allocation isn't const.=
=20

Yep, regular stuff. And that's why I want to find a way to force compiler=
s to
think otherwise. e.g. kind of __attribute__

--=20
Pavel Begunkov


--X9yrC1bviq5bl4CQaUoQ7mqugc3QxjCXa--

--3nJ50J5V2BLSvispVTQy1TuwFJdSjqWlU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5UBOwACgkQWt5b1Glr
+6UprQ/+MR3gK6r3rgQiaIUoXsRa18EsKIq/JBOt5MzGtmAuzHrnghcLGUQdidOj
dVeJy2L/WEdAOCmh0FC5J/4ISNAJ9uBdHkCgUJiXUl+vNCBj0n7cn31hrfsmBGhl
zvVkoY6SBAwUhugyiI9+0LqzJnzuecKqolH6xEVJuBBW3gr0RGsjtimBtSMDk+5y
+0VqbZOvtRtZ8EzRsmg28tMNit7ZneciCRJbdqhADkY/vaMZh2hubvoTcuFNr5as
LoO0quNOpE+Nd1R4yeI3XWFFAnN2WSJTF0gPbePLL7KZIsFUhhkZ/t1LdFk3enKE
yayu96mC6ar8farKfADbWM5m2IsT1qAEb3Qwp1eTwgAnD2uBi/xWxyN9RHQ1R0/6
qLYonolAtikEBtoLZsdiLr2Ba1OmBcY613zF8uggbRkm2u1whFK3cs8SwyzZWieN
VDciKiEftDb5B09OIPzwt6SOn2jUqYAn0hbqnWS0jHCmByNIFBrvt23OEK2ikV0k
l4FjumaC7epneAw9XCVyA2XX9xZv9m5BklxJBq83EuHi6qV4Fww6uLwyi+7y43qx
cRcz/TfUZzyhwpnkN9Koob2kTiXbr81wcx5jKGRNHPqb3qsBg3PWWhGWwXKck92y
/P8U3NiG/IM6ngzGm8pg4K4/wMKPFe+Q4+NGpSA9v7CvppUdQk4=
=aNHB
-----END PGP SIGNATURE-----

--3nJ50J5V2BLSvispVTQy1TuwFJdSjqWlU--
