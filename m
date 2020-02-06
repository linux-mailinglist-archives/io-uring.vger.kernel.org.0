Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA32B154DAC
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 22:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgBFVEf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 16:04:35 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44670 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727830AbgBFVEe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Feb 2020 16:04:34 -0500
Received: by mail-ed1-f67.google.com with SMTP id g19so7451735eds.11;
        Thu, 06 Feb 2020 13:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=8KygzYBDj1GyRuPaJwTVWTkZlX7UEKXKUUupdrQ09Lo=;
        b=Ni6ovQnqVczNGIHeAf8+vgZANce3h3WPjs6wpX96kmceueIAoS3LeMY5Hk9ai1cY9B
         t5dFeEQOt5jby7AiFn+IxhMBYkZONhCU+hQrk4+RayV7VYiQolu+pFs7S3psYAd1vI/b
         atphl+DshOrOZrehB5tAdOgibC+vBORN0X03OsloYtg6pFQQ5BhLImUrUyyF9ALRGaTp
         4GRKCggtSzPBSeujOlnC5ZaYUWS8yZjcooeHIp440lDfuh1oxXPghViwbuBYsOR5tpQF
         N7T/+EGoopUGc8qm8f2092DZZlcCLdwjB3wglT2YEq6xvESNMFw5TyhwRjmyPSdfvUPB
         sjtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=8KygzYBDj1GyRuPaJwTVWTkZlX7UEKXKUUupdrQ09Lo=;
        b=nsmLeUr/pN/HN9HMdUECLpNkmhrl0MUJdhDmbgYQt5IM0sAbGTV/05aMm9eVcDHa8J
         LVDe1b0crNQjjjpZQyeS6HiS+lNXdqs4igfDeaE5TZJJjVUEPPkeEUZDBwpiv7ib/97e
         azGUUTJxJGY/x4NGvJKb78mb2k/2hi1Yn/andlVmwgg9R2Et39psaOjx9cvZ5nsks1Qi
         K4X/W8NVJ5JqdLS6H8HiFiLuE0S6JvgMfXZSLMyzOu82JuF5ZnWLl+gi90Oo5UpuVe4x
         A1270YWDuj4+g+Y3C6xE2mkUMYFwF/mhERHQG9+BqFw2FfoRMxQch3H8U0vPHXLuv1jR
         GGZQ==
X-Gm-Message-State: APjAAAXJMI4GYusTD8Oanx1wpMA/I0A8IBYd08WFfIdqTLAEZumb+aGj
        7btfBDT57zGknNZuf6QhBOkMcbd7
X-Google-Smtp-Source: APXvYqyLybDFMdK9A8LMyw/Gd5e32hVcatCrpWopzfgF2z3N5rHXaW2ZLLrMiif0L5oMrL+C06VsJQ==
X-Received: by 2002:a17:906:a842:: with SMTP id dx2mr5008341ejb.380.1581023071932;
        Thu, 06 Feb 2020 13:04:31 -0800 (PST)
Received: from [192.168.43.191] ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id s14sm58648edx.12.2020.02.06.13.04.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 13:04:31 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix deferred req iovec leak
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <e143e45a34dce9d271fc4a3b32f7620c5a7377c1.1581007844.git.asml.silence@gmail.com>
 <d8486857-ccd3-41bd-2ef7-5ac4781dbd5f@gmail.com>
 <f6a1d5aa-f84d-168e-4fdf-6fb895fc09df@gmail.com>
 <6e7207b6-95c4-4287-5872-fb05abf60e88@kernel.dk>
 <4f7f61d3-b3f9-43db-ad32-ee502dc06c8b@gmail.com>
 <28cacc0c-68e4-a9d1-bb5e-03dbeff8a586@kernel.dk>
 <37dc06c1-e7ee-a185-43a7-98883709f5b0@gmail.com>
 <2095dbc7-88fb-9d4f-78a5-8577dda09a92@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <e45f5f9d-a8f8-01d8-1658-c0744662f8ed@gmail.com>
Date:   Fri, 7 Feb 2020 00:03:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <2095dbc7-88fb-9d4f-78a5-8577dda09a92@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1dL8hC93J0oagmHF5XhXfhkRdJFGGD30c"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1dL8hC93J0oagmHF5XhXfhkRdJFGGD30c
Content-Type: multipart/mixed; boundary="TiyUiOHaj6TxvlU8d9AzCfEjcWI0Wst2n";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <e45f5f9d-a8f8-01d8-1658-c0744662f8ed@gmail.com>
Subject: Re: [PATCH] io_uring: fix deferred req iovec leak
References: <e143e45a34dce9d271fc4a3b32f7620c5a7377c1.1581007844.git.asml.silence@gmail.com>
 <d8486857-ccd3-41bd-2ef7-5ac4781dbd5f@gmail.com>
 <f6a1d5aa-f84d-168e-4fdf-6fb895fc09df@gmail.com>
 <6e7207b6-95c4-4287-5872-fb05abf60e88@kernel.dk>
 <4f7f61d3-b3f9-43db-ad32-ee502dc06c8b@gmail.com>
 <28cacc0c-68e4-a9d1-bb5e-03dbeff8a586@kernel.dk>
 <37dc06c1-e7ee-a185-43a7-98883709f5b0@gmail.com>
 <2095dbc7-88fb-9d4f-78a5-8577dda09a92@kernel.dk>
In-Reply-To: <2095dbc7-88fb-9d4f-78a5-8577dda09a92@kernel.dk>

--TiyUiOHaj6TxvlU8d9AzCfEjcWI0Wst2n
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 06/02/2020 23:58, Jens Axboe wrote:
>>
>> 1. submit a read, which need defer.
>>
>> 2. io_req_defer() allocates ->io and goes io_req_defer_prep() -> io_re=
ad_prep().
>> Let #vecs > UIO_FASTIOV, so the prep() in the presence of ->io will al=
locate iovec.
>> Note: that work.func is left io_wq_submit_work
>>
>> 3. At some point @io_wq calls io_wq_submit_work() -> io_issue_sqe() ->=
 io_read(),
>>
>> 4. actual reading succeeds, and it's coming to finalisation and the fo=
llowing
>> code in particular.
>>
>> if (!io_wq_current_is_worker())
>> 	kfree(iovec);
>>
>> 5. Because we're in io_wq, the cleanup will not be performed, even tho=
ugh we're
>> returning with success. And that's a leak.
>>
>> Do you see anything wrong with it?
>=20
> That's my bad, I didn't read the subject fully, this is specific to
> a deferred request. Patch looks good to me, and it cleans it up too
> which is always a nice win!
>=20

Great we're agree. Though, it's not only about defer, it's just one examp=
le.
The another one is a non-head request, for which io_submit_sqe() allocate=
s ->io,
+ REQ_F_FORCE_ASYNC.

--=20
Pavel Begunkov


--TiyUiOHaj6TxvlU8d9AzCfEjcWI0Wst2n--

--1dL8hC93J0oagmHF5XhXfhkRdJFGGD30c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl48fzgACgkQWt5b1Glr
+6XGGBAApTLv3+GNOm+NkMto3oF1M4j9k07T6AImaWo15w8m+ULP1voVtRaLmcpi
M+0E3TxhTCpzGBUYnObl+aXROZknLNOce/ZQZOHO8guUQwyC2n6Pu7DF69G7zipB
VDssU5IcSYrcBpgJ+B3y6T/8jvy+/E3HDGoQJ2KeI625ngGC+k0rDtvp8OzBfNiz
LnUZxf9dbaEjkjwoYxu0j9SIizY/bs3zOl+tV2y++k1BoyEO3oVgEP0Jmb9Xk5ga
waPbf5OZCVUjMknEZCz+epZMJwVuTjVOEluCjdvfiv7SZ6FC90dnUruytqluXSSU
eiW6tZC4WEWBqOho3J98ThsO3t/krOAXh4Rg22Sxp86kHFRCtCLUPwVsbc/DYpgd
wZz6oGX7QI6wHhQohql6Wc4mIG3jRo0YMcvuzDGNJCF7kuiZues7sSeixmpMxqkk
jSxpAzANOQGgzETS5M+6Ky2PDS/m4XxEDFX7TXqzizVHaQEYKpyi8YOtafrtd8Is
cl3jdr7/LlrmUNROsNU7U1aOJZXOetpV3T1AS9/QNjfFwsP/PWuGOhjn9uG5rrt2
rThADAq8BfmAvPARZ9z8LW8ohI/e+E9Nkv1LC5mkfVdtHXitZo8RV+/cldoCcKSp
kqF8hJZMNztg5N43nB2HZ/RPtHuUhXx5r9J0p8gpW6ge/T2gbvM=
=rhdt
-----END PGP SIGNATURE-----

--1dL8hC93J0oagmHF5XhXfhkRdJFGGD30c--
