Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2B2712D380
	for <lists+io-uring@lfdr.de>; Mon, 30 Dec 2019 19:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfL3SqM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 Dec 2019 13:46:12 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42281 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbfL3SqM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 Dec 2019 13:46:12 -0500
Received: by mail-wr1-f68.google.com with SMTP id q6so33413506wro.9;
        Mon, 30 Dec 2019 10:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=Dcej2rvUFuNNJuvVJ2yTZVHw92BemFptATV8R6YskBA=;
        b=gMKlvKWRgWYvXtWbyK9Ut+UZLU9Nit+5hN+3zlIt27veEWHPOO68OvRFmqZbxttnA7
         oApcZmb3+XZRaugz9A8UQxTCNvXSJoEJBrQYemozbfROj61gg0u/rltRjZRPcoxd8O9G
         S0I4FH0Cjotj8T4FMcycMbNXxJDMUj4rnNXkgP14744kC7FVFwNN5udc9SInUwpbPx1D
         jFgu0m9fNN6EQo2cUBzCjVMBve9JVU8CxgpmoXYmrJHgjC5gAzNxdecEeZJgR7NOJ75s
         0EYtbv5IY2gPrV2d2He7JE1ZX0YFpmeSMJQ7f9p+2FFTRahHE8HnF/IxljVgVrwsSkGT
         h8Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=Dcej2rvUFuNNJuvVJ2yTZVHw92BemFptATV8R6YskBA=;
        b=e+8FWMrqDmin3pTFbALKruD9C7D9lwqF7h3ASSg45goBbdr0d6w//w0bD4Qo/rpLrv
         8DuVpfjmUV6q6YKPr9CFioxbOVw6DtFJUu6zmQiFo8iuVtpvr0f7aNlWkiBQbVg3//qc
         LloiiWWhkwUT5fsNd65TTfYKfgki8qabPsPpiD/LUeoBSzjMzfkCKufkVgK1kRgf1EYu
         wy9vHd7iItRQKpk1TXNQV8PRaCjJQ8bI5JHZQC/F9G14ezQf7gfM2euL6tjR9Qrir8Hx
         3F9yzknJVuDPITHt4hJkncArKrp0IT5VaFuV0RkpQ3yYAWHjB/V6TMcoIdVNQFhrIdnT
         Bpyg==
X-Gm-Message-State: APjAAAU8xZLfdXMWU/XgKCuiNV+MSLJqPDe4f08yKyof4QYgzYn259f2
        168UE1WJBMQTnHg9h5TF0N/n1lKX
X-Google-Smtp-Source: APXvYqzSot8PzAuerWpPnWBfBj6ojUpdYA3RXp2j0mT8WaGdiqWIba+s3nwNebIJTc2kjG/kl7iY6A==
X-Received: by 2002:a5d:4d8d:: with SMTP id b13mr72031691wru.6.1577731568692;
        Mon, 30 Dec 2019 10:46:08 -0800 (PST)
Received: from [192.168.43.115] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id z4sm294169wma.2.2019.12.30.10.46.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Dec 2019 10:46:08 -0800 (PST)
To:     Brian Gianforcaro <b.gianfo@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1577528535.git.asml.silence@gmail.com>
 <1250dad37e9b73d39066a8b464f6d2cab26eef8a.1577528535.git.asml.silence@gmail.com>
 <6facf552-924f-2af1-03e5-99957a90bfd0@gmail.com>
 <e0c5f132-b916-4710-a0f3-036e4df07c69@kernel.dk>
 <504de70b-f323-4ad1-6b40-4e73aa610643@gmail.com>
 <20191230033321.kg2e4ijj2w3ut36l@lmao.redmond.corp.microsoft.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v4 2/2] io_uring: batch getting pcpu references
Message-ID: <b1ba1740-d058-fffe-faa8-0f431ecfa0d3@gmail.com>
Date:   Mon, 30 Dec 2019 21:45:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191230033321.kg2e4ijj2w3ut36l@lmao.redmond.corp.microsoft.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="jtywJ44NJ3LKrazMzQTD16EW6Fhp4xzkj"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--jtywJ44NJ3LKrazMzQTD16EW6Fhp4xzkj
Content-Type: multipart/mixed; boundary="gmuU45vglpWxlmpK9iMrnf4jmFNMFMtfH";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Brian Gianforcaro <b.gianfo@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <b1ba1740-d058-fffe-faa8-0f431ecfa0d3@gmail.com>
Subject: Re: [PATCH v4 2/2] io_uring: batch getting pcpu references
References: <cover.1577528535.git.asml.silence@gmail.com>
 <1250dad37e9b73d39066a8b464f6d2cab26eef8a.1577528535.git.asml.silence@gmail.com>
 <6facf552-924f-2af1-03e5-99957a90bfd0@gmail.com>
 <e0c5f132-b916-4710-a0f3-036e4df07c69@kernel.dk>
 <504de70b-f323-4ad1-6b40-4e73aa610643@gmail.com>
 <20191230033321.kg2e4ijj2w3ut36l@lmao.redmond.corp.microsoft.com>
In-Reply-To: <20191230033321.kg2e4ijj2w3ut36l@lmao.redmond.corp.microsoft.com>

--gmuU45vglpWxlmpK9iMrnf4jmFNMFMtfH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 30/12/2019 06:33, Brian Gianforcaro wrote:
>>>>> +static void __io_req_free_empty(struct io_kiocb *req)
>>>>
>>>> If anybody have better naming (or a better approach at all), I'm all=
 ears.
>>>
>>> __io_req_do_free()?
>>
>> Not quite clear what's the difference with __io_req_free() then
>>
>>>
>>> I think that's better than the empty, not quite sure what that means.=

>>
>> Probably, so. It was kind of "request without a bound sqe".
>> Does io_free_{hollow,empty}_req() sound better?
>=20
> Given your description, perhaps io_free_unbound_req() makes sense?
>=20

Like it more, though neither of these have a set meaning in io_uring cont=
ext.
The patch already got into Jen's repo, so you can send another one, if yo=
u
think it's worth it.

--=20
Pavel Begunkov


--gmuU45vglpWxlmpK9iMrnf4jmFNMFMtfH--

--jtywJ44NJ3LKrazMzQTD16EW6Fhp4xzkj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4KRdMACgkQWt5b1Glr
+6V8Yw/+It2WyQi62HwM7VxxQj5S9J55l6cy7HlfOcoosoYZLcxaTfQDIRD+/ebM
kkQGdS/hMwLYlNQVc06Ip26dM8ub0n78co9nbD6w9PSudwNy3asdTtkNaot697yg
9e9pb3rBiRngju/xivXPkvutT1ktmp6jRssR6qaJy5b1RA+MIB8hBGxSHWaIBUEi
paL56rsg3rFiXIqF5YHcecTnG9yu3qX2rL9wU8WKOE+mTqk+2lqK8HwCKS/eNzz5
yh3glvBQIdpTFsWMn3Kg70atPAukYXnhoZsm8MW6FJZKh4RzJ5B64tgeM/hOAt6f
zj+tHNV8HEfUh3+doouleat5WUU6M4vC1PjqgmvnYoBGVv4A2XpCBUzOVzqnfHnF
4LDQKGyMFGC/SmXjI8rp/XhY59Ku3/OaIk7Evib9er7pXSbO2QCMBJuzNnszQOqa
L+0mnA9O3G2dI38IxM8gR35A8qUfAVxJu3YKd4v5oQxbNTjy4I/Aej2bW3yCK4su
jGmHxm/AlDNEAM15W5TuMS17OZD+xntg5hdYK3kJ5EoSE5Tp2cgWhrwAvasDxKK1
QQ8uV84ydnyAY62r05WaimZNDAsiCknpPP+xpGGKd6JIsWH43U33acCVPe0/S28/
uZVqRCP5Dijd8MxLCZWgDRh432GWLMYZExkTQN0hXXLhARVnTbM=
=jcrV
-----END PGP SIGNATURE-----

--jtywJ44NJ3LKrazMzQTD16EW6Fhp4xzkj--
