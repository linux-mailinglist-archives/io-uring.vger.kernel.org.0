Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72E9A1560AC
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2020 22:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgBGVT5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Feb 2020 16:19:57 -0500
Received: from mail-ed1-f41.google.com ([209.85.208.41]:33129 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgBGVT5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Feb 2020 16:19:57 -0500
Received: by mail-ed1-f41.google.com with SMTP id r21so1085115edq.0
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2020 13:19:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=jzRFdz4dJWnu/VKq17XW3AHfF8e4zL+XZy+jGluYgXg=;
        b=fqA7NyZL1Lw2fM/kkGeLUIXzpEvNTwp3+SkRfAiUlWkYyeuwYMtFuVZxBGBYD+RLvR
         +RGCO2i+Y/PWZr2QcHll82g7peEbuovHgkEpNGK/rsJz8TQHqjzzB2gLk5NZuYKzeADC
         5W2wQPhFt5FPRpYu/wtWgmrtNbs433uan8isYBcRI6hDe/ShKhmqBPq8C8omtOZQ4tZb
         oKaPzgSzdKfoxfwNOZLN2SLkCoDTgyR71od/DoXKOMcJPkSeHuvZ/xWAXJhDxm8fJhGO
         Pgm4TgiLDCTkXCSOU5kU6il03DTRaKbHQAGgeJ6EacagS5x9HZAqFf6gSm3v3qe2ckoE
         sM4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=jzRFdz4dJWnu/VKq17XW3AHfF8e4zL+XZy+jGluYgXg=;
        b=aPfjSW9R2c8iQwOgFmamNU63c83A/FTBIE/YZNgINEC3bejdg9FtI1JINLrcioWAxM
         6TOPbJ+x9e6pybmT/fo0palVE4SJ1me/j8OnPNPVu3ZGAvuhNQfZUEvW51gGZ5xFgcTN
         BThVnQKMaTiYEP0o9yGppRhsWE7eNCRaAzLjJOddqwQDgKeg0+dwo5B3TplersQNVTnl
         0witDn5fbTFe9J78wQZtC6pOpdr31MYSg6iAyo3AKG6dtC6dw4zADz2xLDSbpxMiAZ1B
         YQ/3E8gE3/yEr0F6hLQJG/iXnluzmSR+OJtKM2E+qzp8vilh/4aNZrQWfCsSByN+Bxaa
         Hwgw==
X-Gm-Message-State: APjAAAWy9+FdCpXAOsAP9+Q85np7VT89DXH2jLLyobanvKU2e/QoQsTi
        jOyEP+BihMfXpCiLI9ydaqLWYUim
X-Google-Smtp-Source: APXvYqzj5T+JHupy9YCTFXsyWKcrAcR7xo7T8q0IeO8O8kew5QjSzZb9ljT6rNfndvTRd9gAX1KGBQ==
X-Received: by 2002:aa7:cd49:: with SMTP id v9mr784540edw.269.1581110395629;
        Fri, 07 Feb 2020 13:19:55 -0800 (PST)
Received: from [192.168.43.117] ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id ks2sm478617ejb.82.2020.02.07.13.19.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2020 13:19:55 -0800 (PST)
Subject: Re: io_close()
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <45f22c50-1ffe-4b73-f213-08dd49233597@gmail.com>
 <6052650b-4deb-4a4c-8efb-a85e4781cce2@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <40291566-72da-cafc-d8cd-0554abac8715@gmail.com>
Date:   Sat, 8 Feb 2020 00:19:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <6052650b-4deb-4a4c-8efb-a85e4781cce2@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="1QmSPLFk7HNNS7vM3hyrcXTKzyhuzqD6h"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--1QmSPLFk7HNNS7vM3hyrcXTKzyhuzqD6h
Content-Type: multipart/mixed; boundary="UksOERydRXByiHaU1UCp6yzSJIqjeN97Q";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Message-ID: <40291566-72da-cafc-d8cd-0554abac8715@gmail.com>
Subject: Re: io_close()
References: <45f22c50-1ffe-4b73-f213-08dd49233597@gmail.com>
 <6052650b-4deb-4a4c-8efb-a85e4781cce2@kernel.dk>
In-Reply-To: <6052650b-4deb-4a4c-8efb-a85e4781cce2@kernel.dk>

--UksOERydRXByiHaU1UCp6yzSJIqjeN97Q
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 08/02/2020 00:14, Jens Axboe wrote:
> On 2/7/20 1:52 PM, Pavel Begunkov wrote:
>> Hi,
>>
>> I noticed, that io_close() is broken for some use cases, and was think=
ing about
>> the best way to fix it. Is fput(req->close.put_file) really need to be=
 done in
>> wq? It seems, fput_many() implementation just calls schedule_delayed_w=
ork(), so
>> it's already delayed.
>=20
> It's not the fput(), it's the f_op->flush().
>=20

Got it, thanks

--=20
Pavel Begunkov


--UksOERydRXByiHaU1UCp6yzSJIqjeN97Q--

--1QmSPLFk7HNNS7vM3hyrcXTKzyhuzqD6h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl491FUACgkQWt5b1Glr
+6XpkxAAmm4T6kB6aUAxLMV8PY2zqV35q5uJwYaIS5cUrbxO8z6n8MIbuCUOo092
yLtpTS50QPMRGsX4ESnrUPrU3My7qQQLv6u/9VUY8xEv7OgjEcevUS3jmSJgnwSR
wW484tf61BC5nZlDxtWjJPmDisYtRz+VbbXMR1fNLVtD65+sRxHXtmz0BPFL4sGU
hVpHn2ToVxIt15ewaNK/nryLSeXeeYzyB3pMDOLsD9yxdsUbdhmcDat7vHt/uMJN
IPw3OB4to7dDHUT4YqdrGtH3CJJURLcr7bClDyIdw2mvNw0KGWA/IN53ia7DWQYC
o6pBku7NNZUUXrq7cCm+5WCwgOvaYOal1zgGGNa/xdXRDjCNtc/+8/CUqjP3MRhK
FvZXqzju20dEvtxJeZSaxxAp5X5UtO5h/n8eR20UnL/M4igvs9GqT6YwDLUPPiOx
vCzURtGB2JLs6gU9qcJUVG7KD5L/x+/MnVPGkTNy0V0tPtutpYtNEPahYYogMlZ7
/Q1Eepz2wlLdNllktiqRbtmG2CHSAIASf5rO4X6TznJU38QQBT0FYrUu7hGPMW4c
9i4hTFQQ8jGgBL3GuQxtgLiZOfu+WE3rQb7UT2OlKx4rvQWNhKOXF5oWMvdDOGt0
MPak6PpyyMDY1L0gF08nF2N0kn9wRGcugI6TAzeRVRGPQQb5MAg=
=4wbD
-----END PGP SIGNATURE-----

--1QmSPLFk7HNNS7vM3hyrcXTKzyhuzqD6h--
