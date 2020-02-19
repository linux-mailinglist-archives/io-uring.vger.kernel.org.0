Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31AEE16412C
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2020 11:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgBSKEP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Feb 2020 05:04:15 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37877 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgBSKEO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Feb 2020 05:04:14 -0500
Received: by mail-wm1-f68.google.com with SMTP id a6so6064179wme.2
        for <io-uring@vger.kernel.org>; Wed, 19 Feb 2020 02:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=FmC3BDDn8o+VlJUY76gMrpS01PQ0GpUPg5FEph/UgVw=;
        b=BcV/6ISfChdPAQlzZK7vo7hbkWjJa0BkzkeLhejKIdlE74s8aVJt5gCnNgBTDP3TNB
         fIuKLLt/1y8J52z1XUup4RZ9fFOdJd6rBvGss3BcKL3bUQak96SSLBT9k8kmTUWEFMJT
         B4WZM5y6dan4o+BUBqQIJ1xwXBeymWOa/ytDaXgaYshbgaa7BJhS8ItNfU8UGU2usALi
         7uZNG0vj83VstIG/5+uMjdDRYU4eyM1HlkWnLsI2envtts4Fu/+fsenRn/LvbQPSe9Pa
         bVcFRbuJAhJdJrd8unRRU6D73iBea3YPbFormpUYS3pYOhugFH88UxQO0Ama0znHLZbm
         S/zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=FmC3BDDn8o+VlJUY76gMrpS01PQ0GpUPg5FEph/UgVw=;
        b=YgSLQ03LCdVz6U4kp9agileQ1U02tRZqoQc+yOW66b4ooRrjqthQr9cM36qgfkxVyW
         yl6doyU7r5KeIznJjn3lMz4Fym8wanHR3BLEeCCA3Cja2EmYk0AmQKdNcmfMdY4k6Irp
         tPyHLxZQv/NCZ5/9TpBPyqzJayST40iEcsCZ+a8i0R9tOyaxKGkvvqd3T/ws706t0IbN
         dTIdD/yevUE8obo8dV7MLQgVfFSh5C5sEA4+sHc84kkdGB8NNDnuraNORoGMxsgzkYuz
         KyVbiQkfc+3rNiWg53etm4wWNjM2a8JDvECYkp9XWAaGBwp1NccM98XGLYT9JwZSFiiZ
         IxDw==
X-Gm-Message-State: APjAAAVPsAxCOxVyVajnfN/QLU58jkJmewW05Eenx64DiY7XbHCGJuBW
        nIPUutF5WGkYNwOMe+vmXaXXll9j
X-Google-Smtp-Source: APXvYqx++QcGCaDtMkb2r/2UI5pdrc/a26orI+uh+88gq9N8hgeVCcdmO9cEm7yFr7dTg2HWQ20Rmg==
X-Received: by 2002:a1c:9c52:: with SMTP id f79mr9059327wme.30.1582106652045;
        Wed, 19 Feb 2020 02:04:12 -0800 (PST)
Received: from [192.168.43.74] ([109.126.142.57])
        by smtp.gmail.com with ESMTPSA id r3sm2371012wrn.34.2020.02.19.02.04.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2020 02:04:11 -0800 (PST)
Subject: Re: [PATCH for-5.6] io_uring: fix use-after-free by io_cleanup_req()
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <a0ee1817fd82ae102607714825ed35833a7d6a3d.1582060617.git.asml.silence@gmail.com>
 <1e4fbbf0-5b2e-4372-758d-55e9352d11f3@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <851501b0-5043-3cfc-c25a-7d6e0fee9e66@gmail.com>
Date:   Wed, 19 Feb 2020 13:03:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1e4fbbf0-5b2e-4372-758d-55e9352d11f3@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5P8LPDHOiaXiumGegnT10bg3ImWisD80g"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5P8LPDHOiaXiumGegnT10bg3ImWisD80g
Content-Type: multipart/mixed; boundary="lpZNvahXswapMFB4snIJyKz4VYZwB1abO";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Message-ID: <851501b0-5043-3cfc-c25a-7d6e0fee9e66@gmail.com>
Subject: Re: [PATCH for-5.6] io_uring: fix use-after-free by io_cleanup_req()
References: <a0ee1817fd82ae102607714825ed35833a7d6a3d.1582060617.git.asml.silence@gmail.com>
 <1e4fbbf0-5b2e-4372-758d-55e9352d11f3@kernel.dk>
In-Reply-To: <1e4fbbf0-5b2e-4372-758d-55e9352d11f3@kernel.dk>

--lpZNvahXswapMFB4snIJyKz4VYZwB1abO
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 19/02/2020 03:13, Jens Axboe wrote:
> On 2/18/20 2:19 PM, Pavel Begunkov wrote:
>> io_cleanup_req() should be called before req->io is freed, and so
>> shouldn't be after __io_free_req() -> __io_req_aux_free(). Also,
>> it will be ignored for in io_free_req_many(), which use
>> __io_req_aux_free().
>>
>> Place cleanup_req() into __io_req_aux_free().
>=20
> I've applied this, but would be great if you could generate 5.x
> patches against io_uring-5.x. This one didn't apply, as it's
> done behind some of the 5.7 series you have.
>=20

Thanks, I cherry-picked it by didn't regenerate the patch.
I'll double check the next time

--=20
Pavel Begunkov


--lpZNvahXswapMFB4snIJyKz4VYZwB1abO--

--5P8LPDHOiaXiumGegnT10bg3ImWisD80g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5NB+4ACgkQWt5b1Glr
+6V3Vw//aiyfimiI2fvCiC6aCt6b1lMirCVptK7kc0CUvMaaGwULu4VsP3UknAED
doeIsKDMjUjWNctJT8t9TXf6JUSt5NO0OXt7pcCChIivQDP9w8V5qCpwA7sTlxDf
ExXgSnH3TV88XR18KjzGP1h7kgzs9eg6HPQ8yNyBtrW0oVAJxUnAinqX3TOGmlhG
B3vexyq5pAugMNZYjun3moDUog7ozGmXZeKk4eKZgb2FxJizuVZdWTqY1PKEv0gN
WFknM0pa69N3hwTtcrZ2Fb3lDAIIyHksVD3FGGvUU6OFKSJCCAQKxsmLZ0QoI0Pu
C1zznuk7uYm3F/VBX9eQ8Ik+bOgjA+bGeOL5/yY8bDfLTcftmxKIOLBfsVj1wqe0
5SxBQiiXvPnrwDxGf4BvpETClPXLuuYP/RGCClYaSeTMn3H1awIJfP1NLs2PVe/z
16VqV2knhctSdv3IXDOG9KbbyuJa2LssmCsYc2bGGha3O/w8gf9FfZpGyyeEmjZ3
Ro4q4cSxg2WbDtKpPg7IxnC1DR1CS95ecx3Di55/SLMjxLMTN9gwgyIyWpspC03r
1prMZjNgIJJrHb/cU/ZjBbYzMzPrEAy/ZezR6v5qJGjAfyDdGjs1nOMw94SYUo+I
B9RPQxp0AvRKOlU0k5VayTuKSRDNEMUyY22xFZA9l4Y2jACNkNE=
=Kk63
-----END PGP SIGNATURE-----

--5P8LPDHOiaXiumGegnT10bg3ImWisD80g--
