Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 268C5153AFF
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2020 23:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbgBEWaI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Feb 2020 17:30:08 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37736 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbgBEWaI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Feb 2020 17:30:08 -0500
Received: by mail-wr1-f66.google.com with SMTP id w15so4774820wru.4;
        Wed, 05 Feb 2020 14:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=Fa1DCh+jk5n7X+msJlbZMYPmYUwfUXma4K/VOwbfSjY=;
        b=j36kBM637O5acfRGxU8yNmlrGO60UA3cxNw9sPvaMogGWprUfTSaglGVQNlMUZbAtK
         1Nj0rvrM1dDDmLGlZrW4JH86DF3yl3QkQvkOMj7h7MQf6yXrvXc7SkLjK/kSZkGUvkZd
         +Z+LF6uQ3yN9qnoDSWmkzuD/DENhDNVY/6kx7M3HqX5s77n59f0B3nAiByc/8NsdvaTp
         klfTIyxxR4vxdVs4fM1hl3p3RE3fO9cOn+wPeCetzzdfL8IVwIu6Wn24JioIH8Wa9OVU
         gV41AtpXLP9yehbGsv0pVoaxN6Bhn57oBiDlQCzwkggOXL32C9NbzfHwgoX9fn2OmWkx
         6hRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=Fa1DCh+jk5n7X+msJlbZMYPmYUwfUXma4K/VOwbfSjY=;
        b=fpw3khSxLLLQYeIC6rZQe3ibBjadepBtedXENgYTULVTI7IbLsvdvZOyhqUhWcy4pA
         Y4fmXJzxfUJFh8S1ZVzJnPxFEUCEjndeUlDnpNtbmOWbgaKpV08O5mITwDGK90LUvKpX
         2m2FgQhElIyj4RNij8crn09K6GGuxD6yQAmmQ9A4PrG5P8jitvSGF6rYxqAgDDVatfmy
         dGoo7poExzk66TnYdZw52F4g9y66mlJdAsTyx6DkkNmk7KAbCQcW+XJ8br5MmhCk+wp9
         lysy3DkRMxGgIRuP6e/AC0kaeGQsAqKT6H5XMorp7+SptGvXJXZGziNMvzxzdmLDdhpy
         mMlg==
X-Gm-Message-State: APjAAAXleDVSRJkKsNZaU+cf4zsDgbtzZD1TdbLmF59G0MSCXI2HiANP
        RfYIto/NQmCPCuVfHhF1uoaNxvSJ
X-Google-Smtp-Source: APXvYqy3mEwpGpXlr8q14Yok36B8YeqhIXQWxI+cdRox/j9peecFBwFMqit18PhhjEeAQXI7rdyTwg==
X-Received: by 2002:adf:df83:: with SMTP id z3mr76777wrl.389.1580941804785;
        Wed, 05 Feb 2020 14:30:04 -0800 (PST)
Received: from [192.168.43.125] ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id m21sm1257086wmi.27.2020.02.05.14.30.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 14:30:04 -0800 (PST)
Subject: Re: [PATCH 0/3] io_uring: clean wq path
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1580928112.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <1fdfd8bf-c0cd-04c0-e22e-bc0945ef1734@gmail.com>
Date:   Thu, 6 Feb 2020 01:29:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cover.1580928112.git.asml.silence@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="qgSlbA92WBtIHxNiLpFDc7GwLZJ9lYpLb"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--qgSlbA92WBtIHxNiLpFDc7GwLZJ9lYpLb
Content-Type: multipart/mixed; boundary="jAhrhSC4CY4p50BIJGaO4qzOU75UZbGut";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <1fdfd8bf-c0cd-04c0-e22e-bc0945ef1734@gmail.com>
Subject: Re: [PATCH 0/3] io_uring: clean wq path
References: <cover.1580928112.git.asml.silence@gmail.com>
In-Reply-To: <cover.1580928112.git.asml.silence@gmail.com>

--jAhrhSC4CY4p50BIJGaO4qzOU75UZbGut
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 05/02/2020 22:07, Pavel Begunkov wrote:
> This is the first series of shaving some overhead for wq-offloading.
> The 1st removes extra allocations, and the 3rd req->refs abusing.

Rechecked a couple of assumptions, this patchset is messed up.
Drop it for now.

> There are plenty of opportunities to leak memory similarly to
> the way mentioned in [PATCH 1/3], and I'm working a generic fix,
> as I need it to close holes in waiting splice(2) patches.
>=20
> The untold idea behind [PATCH 3/3] is to get rid referencing even
> further. As submission ref always pin request, there is no need
> in the second (i.e. completion) ref. Even more, With a bit of
> retossing, we can get rid of req->refs at all by using non-atomic
> ref under @compl_lock, which usually will be bundled fill_event().
> I'll play with it soon. Any ideas or concerns regarding it?
>=20
> Regarding [PATCH 3/3], is there better way to do it for io_poll_add()?
>=20
>=20
> Pavel Begunkov (3):
>   io_uring: pass sqe for link head
>   io_uring: deduce force_nonblock in io_issue_sqe()
>   io_uring: pass submission ref to async
>=20
>  fs/io_uring.c | 60 +++++++++++++++++++++++++++++----------------------=

>  1 file changed, 34 insertions(+), 26 deletions(-)
>=20

--=20
Pavel Begunkov


--jAhrhSC4CY4p50BIJGaO4qzOU75UZbGut--

--qgSlbA92WBtIHxNiLpFDc7GwLZJ9lYpLb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl47QbwACgkQWt5b1Glr
+6VToQ/9G4BdubOtDPuDw2Hx+AVJmjiGAHx3h1jUxKLihhmkE8JfjSlkQYHQAsJp
M2Zl4BDgsYKPHXENHPEyT+g4HVZRQjjxx91i/8sMvMRoizGVykPWA/bQ2y5gSpT5
hSVVSYkOa0rH2/xOQLXKG6NWagqxl6R/4nqjaZfAO8DGsH/ZCEbAoZjVIdmwNIqw
7zOBitzZu+3Ve9p/IRXHuoUGCdmkiBtoObQ0Il3me8h+Pj3NU9o7Pq97cYdkQmhr
ojod7x5uAZgHhyAhH3foyCOkbwbj6u+GNN7bI4XdlEcncIO1tygFvfYtEh1lZGS2
pQubHIN0aQ2B5OTGZ6fqRB8lWMSDXFjANrxMG5phQXlLErbT1iMJEWQW++zuJmFT
Hfb/b7SwQ8xThY9Kv2pFsyCw3Ah8j3YzK1RdyQNOox9qXhooq64QJU5rVuh15GT3
48QsB3j5P5vXq29OMYG1cN8qL3uxZ/r8yiH+wsm9x4tDystH3J6ekYl7T+JQuoPJ
v5dSo/Z+n8D0ad/IGrR1m3jq2U/fWhw058in9EQ7JujCsuh8C5P6wQxRomOED/p7
jQxqameulQJOmon5HjLwN9TU2mTTMRW7Bg4tuBw1CtJ2Zi8mjLqUQddYTbMFTfaT
1wq9++DlGmCeieoaUq1OqhQSyDG1u6CMDFZpNWeg3VmQIH60/OY=
=3ONH
-----END PGP SIGNATURE-----

--qgSlbA92WBtIHxNiLpFDc7GwLZJ9lYpLb--
