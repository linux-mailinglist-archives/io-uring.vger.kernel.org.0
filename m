Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2EC159A6E
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2020 21:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730532AbgBKUUv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Feb 2020 15:20:51 -0500
Received: from mail-wm1-f52.google.com ([209.85.128.52]:38306 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730228AbgBKUUv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Feb 2020 15:20:51 -0500
Received: by mail-wm1-f52.google.com with SMTP id a9so5308261wmj.3
        for <io-uring@vger.kernel.org>; Tue, 11 Feb 2020 12:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:autocrypt:subject:message-id:date:user-agent:mime-version;
        bh=bAjYs7Q2N4ZVRRAOut9mU0ectR9W9xYJXrd8qGGGnhk=;
        b=Dy1785+XoB1c6ow10nBsuea+4yib54Zlv2DoB9BGlIGc7uokb2jTAS+klG2uHwPWj+
         lWAkz7CcfAuIrUqofluhgxiJX/69GnO77CJ2C93V0xN5kJcymc+NQD1gah0+NLPiYSui
         go6husXIdPpm0IRqdzBbkHD9lsdpVnFBOLniWY+xqx9Dtrnyt5+1Kfe2soOkx7ne7giA
         LXPSCNoAR5HtJPA7chdNkrOM4gPiV1uUI+ar/9pEXdnhyuKD/t0TzzBGzhdkGwqGStXR
         LyiocuZ68lOMbh3akJFvFBS6x01jhVpfDVZ0k4PxDc2K6tWzZ0V0ann/CjZ/gU144zPM
         a73A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:autocrypt:subject:message-id:date
         :user-agent:mime-version;
        bh=bAjYs7Q2N4ZVRRAOut9mU0ectR9W9xYJXrd8qGGGnhk=;
        b=p15hrE3L9U45QoO0P6vWvNhsbqU3T7CA1UUo5Xt355+ykGrehY1K5O4yHr7HFDGjh0
         FuzFHw+/AOWXv+ca6ry9/iaSpCER9GzOk75Wj7dom3mzAzP05kDX4DUxwx1kyC3J+zKD
         QiD8XP+eSkX19n9XW3kFL/Gb9WD7W++/0BvzuQtLlrPrXL+1fHQ1WEYZt6ehtGoKw7KV
         OBCr0eQhDud3nERiUtq0xkvFdbXcFiYg5lM4O2uT3xrUDSQoqaMcVXYYN27JxMrqpKG0
         WIhYAJZxcJ46KDucYfxytShE0n/w5CQB8rQANwXIsE1n/eNiBflwOze2DuCm/IPFaz9F
         TwJA==
X-Gm-Message-State: APjAAAUlSRcxvfFPNxjgEG7n4b7UNgqc4oPTkTOLbQbjNMCurrmDcPey
        KRn1G41kY56ZSDXX3id8gh8f1/Cz
X-Google-Smtp-Source: APXvYqzK8l/fjvnRdUPFGZC4s4wpEhtxMH5c8hSF3xMx9pOjbsaxDRYZBwNoUsp7NpOpBbDAQSrb/w==
X-Received: by 2002:a7b:cb8e:: with SMTP id m14mr7850467wmi.66.1581452447888;
        Tue, 11 Feb 2020 12:20:47 -0800 (PST)
Received: from [192.168.43.18] ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id y185sm5478455wmg.2.2020.02.11.12.20.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Feb 2020 12:20:47 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: [RFC] do_hashed and wq enqueue
Message-ID: <f0662f54-3964-9cef-151d-3102c9280757@gmail.com>
Date:   Tue, 11 Feb 2020 23:20:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="JmsSrEo7rdtjZGhyQQgqRIGk8tbbanOTs"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--JmsSrEo7rdtjZGhyQQgqRIGk8tbbanOTs
Content-Type: multipart/mixed; boundary="dNApXMBBGoc9pRTBjiOvl5qpoEAfCnaip";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Message-ID: <f0662f54-3964-9cef-151d-3102c9280757@gmail.com>
Subject: [RFC] do_hashed and wq enqueue

--dNApXMBBGoc9pRTBjiOvl5qpoEAfCnaip
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

I've been looking for hashed io-wq enqueuing, but not fully understand th=
e
issue. As I remember, it was something about getting around blocking for
buffered I/O. Is that so? Is there any write-up of a thread for this issu=
e?

My case is 2-fd request, and I'm not sure how it should look. For splice(=
) it's
probably Ok to hash the non-pipe end (if any), but I wonder how it should=
 work,
if, for example, the restriction will be removed.


--=20
Pavel Begunkov


--dNApXMBBGoc9pRTBjiOvl5qpoEAfCnaip--

--JmsSrEo7rdtjZGhyQQgqRIGk8tbbanOTs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5DDHQACgkQWt5b1Glr
+6WmghAAloyjnla0cwD82+Jpy0Kqrqt9a8wKMDyuordKZxtARVwJl/rh/sthlvtc
Xkd8/mq8wyLcr/JondMByVKLEe7YF6428z/AQ5t7EfU2Qt3lwBjIR1sMr7RbiJ9W
6MQjdMchpXfxbZN4lIzJsTvdL+OtTqFxX/wHrTelu/Y3eQLRc/tVImJAbtNLeB1T
AjIpm8BEGrogJtkQGCdNShCuVJQoGz3Or8Bfanyh8vpB4ASOwyBaiPPKVzEeThZj
mehZQLKWEgncjz4lCBnj9TSj0Umic2Bv8i0zwtA787Fki9NTjJrs1Np6ahn6ta+6
qBcp5xf2N/FGKa5QDejfvow+cZQsk9tII2pbOnO/FFw/ExzytudRsV6iNwrlAC7n
wWRdVfUMolPPlPEBjMjKi6EctHOdC+cDuNojPxFvEaq6sO8a/keRfl1DAxjyFug6
ni9/VGDTulKqOBtRfg1JRtbxsLZxWYbObq4oa/Aet4yMluMvrEqt6fljaThPVygm
jqo+A4DdNako5PSQHCpvNtJsjB1QYLf9+HdbyGJI1Au5zdACIegFF8fqpu2BQRo3
/63hcME6Z7kVhsDDpAlLBMEu2PefCZQ1g68NaS+g2LT31gMwOkChVUXAHxsHxn68
4eXw524CfRfl6KH4hTYxr0VJwwdnYl2o4tOVTIrbm2gPvcM+E8U=
=wIvg
-----END PGP SIGNATURE-----

--JmsSrEo7rdtjZGhyQQgqRIGk8tbbanOTs--
