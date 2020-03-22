Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1056618EC1B
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2020 21:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgCVUV7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Mar 2020 16:21:59 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40304 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726623AbgCVUV7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Mar 2020 16:21:59 -0400
Received: by mail-wr1-f68.google.com with SMTP id f3so14323821wrw.7
        for <io-uring@vger.kernel.org>; Sun, 22 Mar 2020 13:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=f5x8FHv2HZWMvJQVouun2AI86Xy5lkSovDEjEWgR2MM=;
        b=G7N8DFhIzF/GbXEOy6hp8uIT6vMVwd6C4RLY0e8wjstpwklguaZA/8bdS83SJWT7ql
         bt03gxTLQGuPMQvmMOzYnS6Q/SLFZo0cSSZPEaMY68UlDi+xX9kk06MQhYAinykTQh7X
         aZg4XHeRawAmXfbz5Mn1YSI8k2//mCXcxOqC4/E4FskG+gUftGr7eTCgvieWbmsIRHar
         frUDf9ZAM3ZNWNjXHsQIYP8NI/OIkzNXUqWMfqJbmXuMpijiwGeQ6NEajXCd6kdO+snK
         gWndeBYG81TGE46xfjlhFULmCrWqMEAw3hEkJiG1Sk02LQdWF9Uj1RlUcc8d1g5+2asO
         gplQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=f5x8FHv2HZWMvJQVouun2AI86Xy5lkSovDEjEWgR2MM=;
        b=YWhkvmCSMccA8XDmmorq5qMI2QPejYOSRUZsQwAiajyyrbAl9Kv5nrE7iX5aw4WN4+
         APQryyryyYVsqnKpnGX9HRNT5y9vJ33phrd6INjgwktci857rGupDIUcZbKBdDgvfiX+
         HfNnKla7kxd2tzI2TGROJ1OYrnOl/VX3eTo3SpRhCMTDh/JqziCyqohztSJX1/gPNu2l
         kVmwmuTAfLuh/yYwbJA4Divx5pmNYc2Mkpk/bYQNOZNMfNRty9fCRgN/lnpJSZLRm5TB
         N4NgenkWHSfPBQ7LtiA4rFKJabHUbrQiuVuW2XCMl/efNBz08O58P8zLZJW591NAhNr6
         qzNQ==
X-Gm-Message-State: ANhLgQ2cjCr6YaN4iP84D4YIcEYmSns0DAaDPlXzzL6AglDbhLntT/j6
        2yooBz68ekWOPrIUCG/r3Tzn8JqF
X-Google-Smtp-Source: ADFU+vuGK1dT+SuRPrrHTJtCS8rIOP/wDPENV3MCp7ebOrIZtan8f1KQudP/gykUTjEjckk+U6hqtA==
X-Received: by 2002:a5d:6605:: with SMTP id n5mr15595755wru.303.1584908515814;
        Sun, 22 Mar 2020 13:21:55 -0700 (PDT)
Received: from [192.168.43.118] ([109.126.140.227])
        by smtp.gmail.com with ESMTPSA id a13sm20446038wrh.80.2020.03.22.13.21.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 13:21:55 -0700 (PDT)
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
 <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>
 <cd8541df-8f97-af3c-ea49-422e546ab648@gmail.com>
 <aa7049a8-179b-7c99-fce3-ac32b3500d31@gmail.com>
 <a6dedf7c-1c62-94f1-0b98-d926af2ea4b9@kernel.dk>
 <cd75e37f-b7c8-91ad-d804-3c4fdf45d3ed@kernel.dk>
 <0f487c49-3394-0434-f91c-72c8e6b8d6f3@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <31fb5dbc-203e-36f9-341a-f39022a68637@gmail.com>
Date:   Sun, 22 Mar 2020 23:20:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <0f487c49-3394-0434-f91c-72c8e6b8d6f3@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="zjmN3KNPZtfCeRFhIhyYhaoil8cyhgqg3"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--zjmN3KNPZtfCeRFhIhyYhaoil8cyhgqg3
Content-Type: multipart/mixed; boundary="VmcjlwpWZjacG7ZXYA7WWlx2itSoa9fx8";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Message-ID: <31fb5dbc-203e-36f9-341a-f39022a68637@gmail.com>
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
References: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
 <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>
 <cd8541df-8f97-af3c-ea49-422e546ab648@gmail.com>
 <aa7049a8-179b-7c99-fce3-ac32b3500d31@gmail.com>
 <a6dedf7c-1c62-94f1-0b98-d926af2ea4b9@kernel.dk>
 <cd75e37f-b7c8-91ad-d804-3c4fdf45d3ed@kernel.dk>
 <0f487c49-3394-0434-f91c-72c8e6b8d6f3@kernel.dk>
In-Reply-To: <0f487c49-3394-0434-f91c-72c8e6b8d6f3@kernel.dk>

--VmcjlwpWZjacG7ZXYA7WWlx2itSoa9fx8
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 22/03/2020 23:15, Jens Axboe wrote:
> On 3/22/20 2:05 PM, Jens Axboe wrote:
>> On 3/22/20 1:51 PM, Jens Axboe wrote:
>>>> Please, tell if you see a hole in the concept. And as said, there is=

>>>> still a bug somewhere.
>>
>> One quick guess would be that you're wanting to use both work->list an=
d
>> work->data, the latter is used by links which is where you are crashin=
g.
>> Didn't check your list management yet so don't know if that's the case=
,
>> but if you're still on the list (or manipulating it after), then that
>> would be a bug.
>=20
> IOW, by the time you do work->func(&work), the item must be off the
> list. Does indeed look like that's exactly the bug you have.
>=20

Good guess. I made sure to grab next before ->func(), see next_hashed. An=
d it's
not in @work_list, because io_get_next_work() removes it. However, somebo=
dy may
expect it to be NULL or something. Thanks! I'll check it

--=20
Pavel Begunkov


--VmcjlwpWZjacG7ZXYA7WWlx2itSoa9fx8--

--zjmN3KNPZtfCeRFhIhyYhaoil8cyhgqg3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl53yK0ACgkQWt5b1Glr
+6XFow/+LAP5aNcKjqQZgfYDlCgvr9AzU+yIPWtMShKnJTfslnNbOdh4Te57MvJ3
DsYN7OqW98yQdaE4oygVz+sLlvQPP3hzPQkPF6OffrNzsl03w9feF+4l3QzJ43/W
gITwB0NAZImlaSxBWtLIhGfuVA5b0YX+xGfJxdzJOoBTuUmD/Ipb1Z/NDSWwFi7F
Ms5oZjwk1khQTe3S9elUFFHfWNfWi3xHQ1pturvq/rk9bsQbSVPVy2HL9yh55fz8
Oip00eK3F/B8jBhOiWWu39GcNGDJDmCaaJ2DsMkAc1uxi2ND5sTm/od3Ajqb9jsH
JtEnGH1NLu3u7wBq9T0k6lpFW2Gq5OhE/3H3N4B7w/1udXcukygGfqAuZScdhEf0
gfjOPNef2bvC642E0Yv1q1+OQ+fBMwtlTXJ53Sk3FFgOGBQjDh0ISdkXdeiO9VEP
uJN02lpGHyyMqBWiW7KJTLj4UkEgzr4XmBAllLdAsPYpgt8ovwY5kThm3FKcQKgZ
dCVAF+tcIfhkvun6Nv8Gj7XBVJbckxHjfMwV/DpZC0/9ek6FKsAe98jm5a4alxPU
erxtVF14G2JlUR1vuKXKgwWzRJcxpKE+anbCHVJyvhIMQTiwQ0G49UYRzKc2TBsp
uN5f07zn55oFD6p+8hfa2vDXCUvLUIYBGFYG7nBY8rAvWpcxG7E=
=fUH1
-----END PGP SIGNATURE-----

--zjmN3KNPZtfCeRFhIhyYhaoil8cyhgqg3--
