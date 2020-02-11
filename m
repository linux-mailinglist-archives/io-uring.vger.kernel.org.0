Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF7E159AD6
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 21:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729080AbgBKU6H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 15:58:07 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51850 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728078AbgBKU6H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 15:58:07 -0500
Received: by mail-wm1-f68.google.com with SMTP id t23so5510284wmi.1;
        Tue, 11 Feb 2020 12:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=m3fJ32xhEuPsN5HBHAQHIEew/YDs6sUWcnFvSG1TcmM=;
        b=qc/y1//yNiQEBCCkEasqpe2nrp96JVcxNS3S04vB2UBloLK2k7DzLsT8kc+EQLx9K+
         eMSfNUxA1SP+cOlk4fDJQ6+B/86W/C/WiEX8kxWrVnwcVeqdBg78VGPVsLnwZRxxm2Yg
         4eJMToKpQApxAetPyqoMjvN7b/+//s4j976SHZI03ERLplSSmbY5TW4jIQ0oSt5FIJl4
         gDGUfL5iOw2PtrjH6fYQeMU3f5HQ0l1YebX7uc4PSyJy/m+K3ILXhVqUAXM8cXgjQdOT
         JpnVJBcIBtFlRm8wwuhnwwjYc4d76CbStZzDZc4ZrA5R/siQo0lUUwxOoxMXEEXG3Zzm
         5Qfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=m3fJ32xhEuPsN5HBHAQHIEew/YDs6sUWcnFvSG1TcmM=;
        b=p1+TW8aVUUXrUq4Jby8AlaulmjgUBORLTo/dFjHvwmjXHA3LfqFsZ/zsI/ShU39cZJ
         yFDSoM93SlLOelNwoeGIFN0wIuCyoZc5bsKxCC9+5uQfB2luizcymgxSX7F/V9B083Ka
         jI0jl478FHHCGMoADG+8yHoKUMCYeFxy/1A/PbIfEUP6xY1x0rm5Ayp2G3+6WPAzcMq8
         RRX7J1eo6F/RxfQsRgsxY59fTDVzZ/hd3Jr8JpaacWY5ZuluD/4RSwuPRdpPjTSDR8jU
         9Dt7Ca/j9d55GxcY0Kv2fxh8m9L6Bq/3yvTcR094dcuT3pOvVa4oowKegWhSlpOhCG9A
         kQ9g==
X-Gm-Message-State: APjAAAW82mi6kRYxwzk42O0Ti4QN5v6kTumEYPvyIpXg2I/9EaSU4bwc
        0P0ztzy0HwkYOTp6TqapojXcgZEp
X-Google-Smtp-Source: APXvYqzdWWRzdBq9F6vH4WcTtcWWoC6MQnN8wezuZ1BwE0bS+YaXWZ+qOj1I8SEe400tOMT2IS4aTQ==
X-Received: by 2002:a05:600c:294a:: with SMTP id n10mr7913041wmd.11.1581454684451;
        Tue, 11 Feb 2020 12:58:04 -0800 (PST)
Received: from [192.168.43.18] ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id f127sm5313446wma.4.2020.02.11.12.58.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 12:58:03 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1581450491.git.asml.silence@gmail.com>
 <728f583e7835cf0c74b8dc8fbeddb58970f477a5.1581450491.git.asml.silence@gmail.com>
 <4a08cc5a-2100-3a31-becb-c16592905c86@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 3/5] io_uring: fix reassigning work.task_pid from io-wq
Message-ID: <e60026f7-8e8f-7133-57e3-762a1d84269b@gmail.com>
Date:   Tue, 11 Feb 2020 23:57:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <4a08cc5a-2100-3a31-becb-c16592905c86@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="r3ufS8hWOO0jlZFGhNNoJ76CAUirJEWUa"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--r3ufS8hWOO0jlZFGhNNoJ76CAUirJEWUa
Content-Type: multipart/mixed; boundary="nrWwE987J8OkG3OdY3y7K4XXiCHWftVzZ";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <e60026f7-8e8f-7133-57e3-762a1d84269b@gmail.com>
Subject: Re: [PATCH 3/5] io_uring: fix reassigning work.task_pid from io-wq
References: <cover.1581450491.git.asml.silence@gmail.com>
 <728f583e7835cf0c74b8dc8fbeddb58970f477a5.1581450491.git.asml.silence@gmail.com>
 <4a08cc5a-2100-3a31-becb-c16592905c86@kernel.dk>
In-Reply-To: <4a08cc5a-2100-3a31-becb-c16592905c86@kernel.dk>

--nrWwE987J8OkG3OdY3y7K4XXiCHWftVzZ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 11/02/2020 23:21, Jens Axboe wrote:
> On 2/11/20 1:01 PM, Pavel Begunkov wrote:
>> If a request got into io-wq context, io_prep_async_work() has already
>> been called. Most of the stuff there is idempotent with an exception
>> that it'll set work.task_pid to task_pid_vnr() of an io_wq worker thre=
ad
>>
>> Do only what's needed, that's io_prep_linked_timeout() and setting
>> IO_WQ_WORK_UNBOUND.
>=20
> Rest of the series aside, I'm going to fix-up the pid addition to
> only set if it's zero like the others.

IMO, io_req_work_grab_env() should never be called from io-wq. It'd do no=
thing
good but open space for subtle bugs. And if that's enforced (as done in t=
his
patch), it's safe to set @pid multiple times.

Probably, it worth to add the check just to not go through task_pid_vnr()=

several times.

--=20
Pavel Begunkov


--nrWwE987J8OkG3OdY3y7K4XXiCHWftVzZ--

--r3ufS8hWOO0jlZFGhNNoJ76CAUirJEWUa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5DFTQACgkQWt5b1Glr
+6U4HBAAiVXVbwa8UiXiDXRRjHe/Uwk9VmBUYqKOjRAm0LCbMxrrVvA5WNj/heOA
Lw3aEiKKzGVYyhRpxyV8HPfMfb41psM7XWs0DEPMFgNR89H50nCLkkfeqfjx2UKL
9F0AkfxXvFwoGLsgRq4SGN8xAjq0RifAeQjZqlXjIYXY3ChA+nYda2TxUAUrUfoM
ubNOAjr+xtOLV7DjyoDzc6jU7lYro9ndKn2VnBLAXWHAdNbLbRU0uzgruZHJ7JOS
SkKR/easNwKco+KXU+rLFA1P7TdYobJokH8tS4t3sGJCvqNTSfrWNmIhgi/Jl4SF
l7ktcd6EIowyf2NPd5ZRKcHlRvK3gj5mKr/Pa8eHoAZzL2p8OgM/SmDIMPaU1VTj
JX38BymP2FhfMcBzW9gutitqSa3o5ZsFyBoQhmxLScZtZ4PKpejne4a47siY5KyO
0xjAAK4OlRznOarq1pjCYFHiaJn26SyMi2ooAQsgGvztgUPbrludXTSg6iFpecZ1
X+tL8q20zEPt6XNyDEdKIgPJtOQFZM+a7X2rf70U43rXdyST4IMcqfdAq1USjb14
hd//fpnrnA6iS/0ASGdT/d0w8ZRJ7Q+MIl2xklBL4fmZciQI+oF1E7kzt3fn/4pi
EhIAbJwaT+D9M58R2+ZSwuZj1TIqttHn7Uy36bh423Kgyx7cw3s=
=jU+T
-----END PGP SIGNATURE-----

--r3ufS8hWOO0jlZFGhNNoJ76CAUirJEWUa--
