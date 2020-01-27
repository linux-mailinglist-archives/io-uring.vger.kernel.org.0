Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91D5114AAA3
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2020 20:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbgA0Tkc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 14:40:32 -0500
Received: from mail-wr1-f47.google.com ([209.85.221.47]:42183 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgA0Tkb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 14:40:31 -0500
Received: by mail-wr1-f47.google.com with SMTP id q6so12890583wro.9
        for <io-uring@vger.kernel.org>; Mon, 27 Jan 2020 11:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=Zil4VZseJ0A+XSTSFsADqTH8nzBv/xEaJOiFPP1vCxI=;
        b=LYs19XJrMc9ZgFAjDDu52d5IJlbE8NL8BfiaT0WDGLZU9h6a7/UDtBBZz2rNsO1W+f
         zvXiY5Hd0TCRp0KX9Sc52OBUL5hTeI+OvkKWzKMMn+V25GFtjAXjWxQmxuNH7xX7Nil7
         8I3BDJg04W7bNFqE3tS9v9RGPKmefUppy+M2XjXjAcJTaKVCvmu+NdP//uL/ZtqteNoQ
         L6LJ8Hrd7LW5fLvAGPq4jyuxF8aS4HrUWqFF55WlXdij+tYxxxL6AYxEkev8NznWln5o
         ndjAOrxcrIzBrYScOxVODlU4pB/3sfWxsBB8pu9WGn4DBzhDmvBneD6X/2Xloeu+acrg
         dAHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=Zil4VZseJ0A+XSTSFsADqTH8nzBv/xEaJOiFPP1vCxI=;
        b=H/oRWYlII2otfIEpaWbNDh66A06kDdK9tGw2Qx03Ml53zu7gbSLaE36VsmtaCXv3Mq
         d3mrJzJMiudiT8Luy8c+/kNSdIYRRrHX1TwbkkuXG0N0/WZMZhrT2FRl2GCk8EmVGSfY
         QTbt+4TCXMrAESqOGYi+NA2srKXNt74kC/vjm/LSwa9SIfQSc3OMfkRrYFI322jxC8Ap
         +Ddoxv+r8C7ezDSX3f8Vy1sWa4asR0BRuvEXhF9MkzuLRgOyuF9vMzhXn56jY3EA58ct
         DBypauFr9j4WuSZi9YMALlDHNsI4KT2BTU5dsQE2M6ptINJaeZuhVbZUeaM9wT9LRq7a
         lvWA==
X-Gm-Message-State: APjAAAXmzJqbslpoBlHecAoTw3Y9SDAgSGNLiikao0lO4yWUqtXjdNcP
        zWI1iwXkI+jfDQ/nbd6X22NSva62
X-Google-Smtp-Source: APXvYqzzlWU8Q/J9+LomdgwIWQWmVnNovlSnyQN2xi44k1CcsWoFDMa811FelfQ1dRsKal0f5I1A2A==
X-Received: by 2002:adf:bc4f:: with SMTP id a15mr23155803wrh.160.1580154029358;
        Mon, 27 Jan 2020 11:40:29 -0800 (PST)
Received: from [192.168.43.118] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id n3sm21226983wmc.27.2020.01.27.11.40.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 11:40:28 -0800 (PST)
Subject: Re: [PATCHSET 0/4] Add support for shared io-wq backends
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, Daurnimator <quae@daurnimator.com>
Cc:     io-uring@vger.kernel.org
References: <20200123231614.10850-1-axboe@kernel.dk>
 <CAEnbY+c34Uiguq=11eZ1F0z_VZopeBbw1g1gfn-S0Fb5wCaL5A@mail.gmail.com>
 <4917a761-6665-0aa2-0990-9122dfac007a@gmail.com>
 <694c2b6f-6b51-fd7b-751e-db87de90e490@kernel.dk>
 <a9fcf996-88ed-6bc4-f5ef-6ce4ed2253c5@gmail.com>
 <92e92002-f803-819a-5f5e-44cf09e63c9b@kernel.dk>
 <3b3b5e03-2c7e-aa00-c1fd-3af8b2620d5e@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <7316bdb3-4426-2016-df48-107a68d3e2ab@gmail.com>
Date:   Mon, 27 Jan 2020 22:39:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <3b3b5e03-2c7e-aa00-c1fd-3af8b2620d5e@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="d65VFq5wGXFWwNuIJayICE9gPxjeuC5u3"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--d65VFq5wGXFWwNuIJayICE9gPxjeuC5u3
Content-Type: multipart/mixed; boundary="mqXszbISBLnU15N0YOCRNLHLiCdUJL5Tt";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Daurnimator <quae@daurnimator.com>
Cc: io-uring@vger.kernel.org
Message-ID: <7316bdb3-4426-2016-df48-107a68d3e2ab@gmail.com>
Subject: Re: [PATCHSET 0/4] Add support for shared io-wq backends
References: <20200123231614.10850-1-axboe@kernel.dk>
 <CAEnbY+c34Uiguq=11eZ1F0z_VZopeBbw1g1gfn-S0Fb5wCaL5A@mail.gmail.com>
 <4917a761-6665-0aa2-0990-9122dfac007a@gmail.com>
 <694c2b6f-6b51-fd7b-751e-db87de90e490@kernel.dk>
 <a9fcf996-88ed-6bc4-f5ef-6ce4ed2253c5@gmail.com>
 <92e92002-f803-819a-5f5e-44cf09e63c9b@kernel.dk>
 <3b3b5e03-2c7e-aa00-c1fd-3af8b2620d5e@gmail.com>
In-Reply-To: <3b3b5e03-2c7e-aa00-c1fd-3af8b2620d5e@gmail.com>

--mqXszbISBLnU15N0YOCRNLHLiCdUJL5Tt
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 27/01/2020 17:07, Pavel Begunkov wrote:
> On 1/27/2020 4:39 PM, Jens Axboe wrote:
>> On 1/27/20 6:29 AM, Pavel Begunkov wrote:
>>> On 1/26/2020 8:00 PM, Jens Axboe wrote:
>>>> On 1/26/20 8:11 AM, Pavel Begunkov wrote:
>>>>> On 1/26/2020 4:51 AM, Daurnimator wrote:
>>>>>> On Fri, 24 Jan 2020 at 10:16, Jens Axboe <axboe@kernel.dk> wrote:
>>> Ok. I can't promise it'll play handy for sharing. Though, you'll be o=
ut
>>> of space in struct io_uring_params soon anyway.
>>
>> I'm going to keep what we have for now, as I'm really not imagining a
>> lot more sharing - what else would we share? So let's not over-design
>> anything.
>>
> Fair enough. I prefer a ptr to an extendable struct, that will take the=

> last u64, when needed.
>=20
> However, it's still better to share through file descriptors. It's just=

> not secure enough the way it's now.
>=20

I'll send a patch with fd-approach shortly, just if you want to squeeze t=
hem
into 5.6-rc

--=20
Pavel Begunkov


--mqXszbISBLnU15N0YOCRNLHLiCdUJL5Tt--

--d65VFq5wGXFWwNuIJayICE9gPxjeuC5u3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4vPIgACgkQWt5b1Glr
+6VpNA//YbuJCb59ZL+CwjV7pHw85u1DWM1jZKeILrRXbBiZdoXTRkTZCvUmjah1
egqSzhirDNdMDcgjTVBTDf+KUwniIDeqWMxfj5xoJO02622GeTGGF4R9n6BxK3DG
H6A/y3/bAhByr9b0IeyqnZQNXYHP7VC0vSw+ceAocirGZmtomLSdfk0pPryECY3u
aTkWQtr1EElJMiWgn7l+UozLku34XvoGkEEOtcsuJxiSW8jfVaxe0IaE/z6o0SI5
v2eLQpweAdl7SQp6/6oJDzfAikRDiKoxUFKIG00DJgN/jdnAOLUyGu3g6zP38SQQ
fuCMMYXWtTaA1TQLwxgUoQ+TRWewvot7gRox7uPX1lNMQvhEL1Vp1OI2Akj+vZ67
Yndz70ZwkNrMqLOA15ODCHDXwSelWn0o7sX+qEGJ2qJyE5M5T0Oa004utTU+FtlR
mL5ei1AqnjUHHtu1NeMAPN5HdapYsDsrzHPDaf/wQ/Vdenuzr+RXIPwrCaeO0XbX
oDw33NEG+N033zwaNCRqV+oBuBWXTJf996S2GbuScAeOGCM/2j7q/BDhZjZYw78k
iUHao0roUTzGDmsqDZTrfTp36gOmAON3PsSvI3V5OuvYwrv9KoYHdG7xFQ5bk7f5
F+nUHaIe4OfHMMRMk+sWuz2btRUcX6WeGEhB5L2UmjwK9LmWzCw=
=7gJ2
-----END PGP SIGNATURE-----

--d65VFq5wGXFWwNuIJayICE9gPxjeuC5u3--
