Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73EE914ACFB
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 01:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgA1AJm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 19:09:42 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36605 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgA1AJm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 19:09:42 -0500
Received: by mail-wr1-f67.google.com with SMTP id z3so13941572wru.3;
        Mon, 27 Jan 2020 16:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=5WUA1K/djhpOvupycq+0mnjtxtFY7VY9CWyDIrrwp9I=;
        b=eEGJeoju7Q3N2Ef7y/Qg6/UaBBwfSq9+NZi8TBMEWf2DGk+gZ9vPjGPNpOcYzlaD3x
         ZeKpZfMDildlljWNQxwuKtwEM2d5HUUnK+Mq1SUUGUDFtzZmHh7xSc0xOptwTA1pfHcd
         hC29NCwG2FJT1hGR1Tyzp2aYJpsjhnmxaojFtwtCxWheAGza/3nYH2L7Q+DYEBxQud+f
         rmVnprF36nCk3Tc9LZhpQRHjythwsSGR/VA50S97mUqfrlRxLrhC9T4a6w2yEvRgkGfU
         /sV7pB2RmqKjHM9oH3SKI+o9uPEC+/OdFA/e0f6FOXua9yaqLerK96xeA4Cwb+84ZLRu
         tw0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=5WUA1K/djhpOvupycq+0mnjtxtFY7VY9CWyDIrrwp9I=;
        b=kOk8j0n/s1sjlfpPU/iLzKUcW9hlEHYHPkGMyX8uDqxIRV1DkpyXQLKEfm6TK46pe/
         waR9/sSn4qllQLdTq5ODoXTQScnP49KI+8vfCX4vAMD4nFYp/TFeRv5QTRtgF4GfuT7t
         Dc9FznNmZDAe9Pdbk6KYLUrYELXa5CWW6ipI+a/AcfE3xMeKxfRk9cKkJqhSsWSqsSSz
         DIy9Bgzms6ss0sAQ4Pgm59pxK8wUpmNNAVGfe1t+tv6tXfl+por7kBXQTcO09dkOVNEB
         nBLrtRIHe0TFR9j76B+7YfNMcmCKM0u2OkM+DJXiijqrWKyayjeLrPko/B5kFSnHvp6J
         tAcQ==
X-Gm-Message-State: APjAAAWapId7EpUUhix93ypovv/wkBu8yyYDumRmQR0hj7p/DFj+KzMQ
        4uMZW56gIqKplHkNQBrpS74MRElT
X-Google-Smtp-Source: APXvYqxbQNw55fNG95kJvnP+rkKwAgQ7Oei+SdO8XlOy5UWkjOwA/0+4E5lneR8uzfKdD9+QfbBM5w==
X-Received: by 2002:adf:f28c:: with SMTP id k12mr25806053wro.360.1580170179260;
        Mon, 27 Jan 2020 16:09:39 -0800 (PST)
Received: from [192.168.43.36] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id y185sm639472wmg.2.2020.01.27.16.09.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 16:09:38 -0800 (PST)
Subject: Re: [PATCH 0/2] io-wq sharing
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1580169415.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <4de82ab2-d4dd-f792-8dcc-2bca2b088d80@gmail.com>
Date:   Tue, 28 Jan 2020 03:08:59 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cover.1580169415.git.asml.silence@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7rzj1qscbnYF1TNLnmhT2wpyvngrcuxhc"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7rzj1qscbnYF1TNLnmhT2wpyvngrcuxhc
Content-Type: multipart/mixed; boundary="cNAQOgMyuuRyIyd6PHuS01J0WSnrbLYbG";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <4de82ab2-d4dd-f792-8dcc-2bca2b088d80@gmail.com>
Subject: Re: [PATCH 0/2] io-wq sharing
References: <cover.1580169415.git.asml.silence@gmail.com>
In-Reply-To: <cover.1580169415.git.asml.silence@gmail.com>

--cNAQOgMyuuRyIyd6PHuS01J0WSnrbLYbG
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 28/01/2020 03:06, Pavel Begunkov wrote:
> rip-off of Jens io-wq sharing patches allowing multiple io_uring
> instances to be bound to a single io-wq. The differences are:
> - io-wq, which we would like to be shared, is passed as io_uring fd
> - fail, if can't share. IMHO, it's always better to fail fast and loud
>=20
> I didn't tested it after rebasing, but hopefully won't be a problem.
>=20

Ahh, wrong version. Sorry for that

> p.s. on top of ("io_uring/io-wq: don't use static creds/mm assignments"=
)
>=20
> Pavel Begunkov (2):
>   io-wq: allow grabbing existing io-wq
>   io_uring: add io-wq workqueue sharing
>=20
>  fs/io-wq.c                    | 10 ++++++
>  fs/io-wq.h                    |  1 +
>  fs/io_uring.c                 | 67 +++++++++++++++++++++++++++--------=

>  include/uapi/linux/io_uring.h |  4 ++-
>  4 files changed, 67 insertions(+), 15 deletions(-)
>=20

--=20
Pavel Begunkov


--cNAQOgMyuuRyIyd6PHuS01J0WSnrbLYbG--

--7rzj1qscbnYF1TNLnmhT2wpyvngrcuxhc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4ve5sACgkQWt5b1Glr
+6W7ZhAAmPA74Zzsx7e01q/zELygziNfVGgKWWOd9SL5rJWgG1GhO84wYvggXAxN
B/Win/ySt28mJu+2Rv8jUJL09mRzVkocmqGxqe6VKWfD6bOpcZ3etnY4fJxv7SrI
wvg8hMUbKXVUaMlo5a0APhNthhDnC+bJgucPFUZdsFFJWuxJ8LHeg8uyXhjQK+92
Fx8YgpDocF103j4uFjE0kkp9z7Gh84zT2+nM9dJ1CxbN7jvoeWAJcYeBTrgkzvfr
uaVQ2ef5TupS/A1A9F5shgkN2pnK1j7NFMHYE4JLBcaV0Nh411Jb3lQ0kIADLreV
/XzLrHC+VmVl9MFH6XHLsf+gpcQdHSeG6eu9S92vaXI28U4vCH2FNC6v8Z2VESFL
x8jg/YHTzt93KOivDjcGfaHCMpBWSS6eK6OI0aT2VN7w6L3XQSQqz8fUeu9BUL94
qRIG4rdsbE4poQbf3wjfehCdMnQqfcgBIaltVxTGyctK7pKxQE+AZ+jm/a4GwAFo
0ObD+G4Rimo5OUdH/uMHaZdOseIJZRwdGnT/CB02U5PvEMD0c6XfRF4eJrAeiC1D
MLToMw/8YkItrvVB7DRsfNRE2g4qtdFHzw30dyE9UBahi06vBKpKtMoCH/HPVxMz
pw0IZRnWQV17RBEhr6m/Zx/XVg+q01UWliraRKnjBv4e3mBH4H8=
=v0Jz
-----END PGP SIGNATURE-----

--7rzj1qscbnYF1TNLnmhT2wpyvngrcuxhc--
