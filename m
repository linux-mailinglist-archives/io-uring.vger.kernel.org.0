Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5D6F14F579
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2020 01:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgBAAlb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jan 2020 19:41:31 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54066 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbgBAAlb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jan 2020 19:41:31 -0500
Received: by mail-wm1-f67.google.com with SMTP id s10so9941053wmh.3
        for <io-uring@vger.kernel.org>; Fri, 31 Jan 2020 16:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=GCdRLqMZvxMaAAtiIkTig+tVICF6mExVVa+6LkRus5U=;
        b=ZHqB5Yi22ylkTUU7ps6m5F0LDc3SenuCFQYeZ0A63WJjHTKwisleQwyw6KTZUUDUOx
         yySG4MK3YOkltDehXs5G6+HBAyr7fl54BiM6EHHIpNlLfiqKp8Se8osw7b29mrA3/1BU
         opu7FkdzAmpt+MNF5IAgnMbTXw7L7q7GCFRfWd+SkRBeo9JzKoo4ySo8Tro45iUkMO46
         aJWqQ5OCoLpaFgEnOOhg+oz+aEMYq4TvZv0MJxN0PFHxSI54y0G1+mA4Ats2DYEgWXsQ
         1FLrgY4lhmRNMIYbN5EMyRbC3E0QoGO7YoCUnu7hxgFIwWMl0z9SltrBxYrl8lIJ1HY0
         p0fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=GCdRLqMZvxMaAAtiIkTig+tVICF6mExVVa+6LkRus5U=;
        b=edZOkBx80stNoPHVKLU2E4aTz1GeZ366+EHkkAlas6UiDzltzmiVbdHPsTuZGs7GVO
         5NLh0UtX2vyb6aeRk8mVV6pcOr2/jtQL0xF/ErFP2X0TzyT2ACBXRIIgHC59zB4Xtk4K
         Hh4e4urQC0b84SiKLKpQNsqxjHipShnuoM7UsYll/qqu7Bls8r6MIy40O1CHkpmbX07Y
         RN3ReIDn06mMLERj8t3gQeo2OSkRlY+Dti54GQS0T3D4rvPLo/+UyzwnLSUta9sUGHMP
         7ABLqANeZsJo67K1ehYY9rGcP5PPjMTZblII2p0AQiOgTencx8d/lShpOOsVQbT2V4ms
         m+qQ==
X-Gm-Message-State: APjAAAWaAA8guptfr6gpZmJs3dSRioqbYD4krbkfkGLK/4saLe3ks56u
        e72Gok2LoraAHNfm7Dn0AaSRAE27
X-Google-Smtp-Source: APXvYqye4pMBF4sz+ifj0ndBkKD/hfwTaBSRcxQj7qDRIwhiWMcnBi9FiYRslbHfuuOt/PBpuI4iCQ==
X-Received: by 2002:a7b:c183:: with SMTP id y3mr13988789wmi.45.1580517688265;
        Fri, 31 Jan 2020 16:41:28 -0800 (PST)
Received: from [192.168.43.154] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id o1sm13873294wrn.84.2020.01.31.16.41.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 16:41:27 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <b0b0bb08-d3ab-a9f7-d468-6f113fbda19f@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: fix sporadic double CQE entry for close
Message-ID: <c1b8f3c9-af7c-7327-cd15-5bc92ffc8e6b@gmail.com>
Date:   Sat, 1 Feb 2020 03:40:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <b0b0bb08-d3ab-a9f7-d468-6f113fbda19f@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="RqkCsk6WtVLjEPdCVgs8OJ53FvVlyo1D1"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RqkCsk6WtVLjEPdCVgs8OJ53FvVlyo1D1
Content-Type: multipart/mixed; boundary="2CQYOmd0DwcQt8UcdkFVc9cZqZFgjBqzk";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Message-ID: <c1b8f3c9-af7c-7327-cd15-5bc92ffc8e6b@gmail.com>
Subject: Re: [PATCH] io_uring: fix sporadic double CQE entry for close
References: <b0b0bb08-d3ab-a9f7-d468-6f113fbda19f@kernel.dk>
In-Reply-To: <b0b0bb08-d3ab-a9f7-d468-6f113fbda19f@kernel.dk>

--2CQYOmd0DwcQt8UcdkFVc9cZqZFgjBqzk
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 01/02/2020 03:21, Jens Axboe wrote:
> We punt close to async for the final fput(), but we log the completion
> even before that even in that case. We rely on the request not having
> a files table assigned to detect what the final async close should do.
> However, if we punt the async queue to __io_queue_sqe(), we'll get
> ->files assigned and this makes io_close_finish() think it should both
> close the filp again (which does no harm) AND log a new CQE event for
> this request. This causes duplicate CQEs.
>=20
> Queue the request up for async manually so we don't grab files
> needlessly and trigger this condition.
>=20

Evidently from your 2 last patches, it's becoming hard to track everythin=
g in
the current state. As mentioned, I'm going to rework and fix submission a=
nd prep
paths with a bit of formalisation.

> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>=20
> ---
>=20
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index cb3c0a803b46..fb5c5b3e23f4 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -2841,16 +2841,13 @@ static void io_close_finish(struct io_wq_work *=
*workptr)
>  		int ret;
> =20
>  		ret =3D filp_close(req->close.put_file, req->work.files);
> -		if (ret < 0) {
> +		if (ret < 0)
>  			req_set_fail_links(req);
> -		}
>  		io_cqring_add_event(req, ret);
>  	}
> =20
>  	fput(req->close.put_file);
> =20
> -	/* we bypassed the re-issue, drop the submission reference */
> -	io_put_req(req);
>  	io_put_req_find_next(req, &nxt);
>  	if (nxt)
>  		io_wq_assign_next(workptr, nxt);
> @@ -2892,7 +2889,13 @@ static int io_close(struct io_kiocb *req, struct=
 io_kiocb **nxt,
> =20
>  eagain:
>  	req->work.func =3D io_close_finish;
> -	return -EAGAIN;
> +	/*
> +	 * Do manual async queue here to avoid grabbing files - we don't
> +	 * need the files, and it'll cause io_close_finish() to close
> +	 * the file again and cause a double CQE entry for this request
> +	 */
> +	io_queue_async_work(req);
> +	return 0;
>  }
> =20
>  static int io_prep_sfr(struct io_kiocb *req, const struct io_uring_sqe=
 *sqe)
>=20

--=20
Pavel Begunkov


--2CQYOmd0DwcQt8UcdkFVc9cZqZFgjBqzk--

--RqkCsk6WtVLjEPdCVgs8OJ53FvVlyo1D1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl40yRAACgkQWt5b1Glr
+6Xvnw/8CUG9cfIKrszNFwSFyXrx0jNgoot2QqNFzp+0anXvZdPOALrSnbswdUOb
UFy1rg9trgnYL2Q24M/jT+ZMoKeLt9Ee9pO0QDo4tLDAjcDczGzcXvZU64+dHvI3
KAkiYOF3i2MV+KTkw5RDtk/0w+a1gq1vYiXETSnFJ3kT0nDT0ahN0rR8uBDNkgdo
OXc5z8J3108sSipNmuZPdaBZkwDaKPDzraoZU43Y9f6yoGEZbAIBNAM9ooEOzaJ9
5c1xIx4rKo0xwUVH3YqxjNctTmr9QiIgYBkGQLB/rLVKatLP2GEtNF4u6yrDp4gr
4x4ljwpTpZR2HXCoyAa5YgeG8nnUIeIej8QfUzvQCeHhqcxbKW0zbx5OslA5gosc
Pbk1h3chusyOELQ79KugOcUWkSUdpPXEA16IfzoOvq/M3oP72EHboSN6dZTxycPl
q4vW9fACTQFxLg+dzSfnXMf5e3OooUD1bGeIFALZEiZ5l/e6JvOdFL4XvpDC5M4U
UTpVIHD4PxkUE6xprTSeFiCyTQwIVMdm0adsEGva3XoD1SMj1uputgcJZcfnwKaV
16Ez0M9UiBBPhu/NrVwKZoEDQ4g+ihc8GKOVgaPGDMJL0HVM1BigJV8hKS1m5jHu
WBR1H8omSE680W1pA2FBYrQG1w93SMCarMNslgGkJ06oVANmdkg=
=8SYK
-----END PGP SIGNATURE-----

--RqkCsk6WtVLjEPdCVgs8OJ53FvVlyo1D1--
