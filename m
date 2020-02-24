Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71B7F16AB30
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 17:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgBXQTV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 11:19:21 -0500
Received: from mail-wr1-f46.google.com ([209.85.221.46]:46845 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727299AbgBXQTU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 11:19:20 -0500
Received: by mail-wr1-f46.google.com with SMTP id g4so4736702wro.13
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 08:19:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=R8y8uGTnzd8mVgtP5d2WdraCSUe4sNTM+mlwoyGa4f0=;
        b=W+sgGT1fbIkGHw5XjcotOcUs2tmrfSzlm5n6WHx3yL75eJI47Qu53H96GqDsDkzAZ/
         BdLSmzwTw53lnwTP4CYP1sy0mn8MOeb+RzpgvK9kSiAn16i4UkORrbD/7egfhHiyEd+u
         5KRhMzzEFqui5gsAaKRvE1Ipf+kjDbEVse05eiZJi/RSVTCMPArHnvzqH3JyZi8+xCa8
         Ofu1DfB19UR1JKBpUI+Hu7/BshCecNtlwGqYIZ80CWjrmKFe8p0V4q6tYR2rA/1DLz/I
         ziEv5793Br3hCcAXab8Z5qRy0wFRYSrDeS+ks8IUnQImqovYgm+DhpeC8YB/SDV+NsiE
         canQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=R8y8uGTnzd8mVgtP5d2WdraCSUe4sNTM+mlwoyGa4f0=;
        b=lf2ztX3thMeQHaqtrGQgFl9lSiSDK+nByydkWi/LndrZ+76OKlMgG1iZb9s9TphfLL
         td0bS+Twi7Vfp57EHkjIpBxYSCFGl5NtkBR1Fb4thBIkg+zvLp/EvVhh+UNvXRlK5YEX
         wkCaN3vjb/zDozf1665AP65ORGqBV+EiQ4hgZfdxUr7Y9yy+k7YRbUYA/JlZzkyvj759
         6/BAg/Pd5Y3JoDS1zO/l50PDsRmBHAl4ENUdJ8MGyIK18reAtisfqOdKIFPLu8Gxya/c
         QpsXauRHMYsHv2J0updkQiMpJigIlNRCDH620JmuwQxg1iUaj4BUX79QMmUycusSQVG3
         h3zA==
X-Gm-Message-State: APjAAAVcnrtvXJTwH/BkKdTn4nhl2tyHdacEWZKvRF7+kks30k0C2qPf
        rX8DBzlHyjLdtlgn76TmtUGoIl9+
X-Google-Smtp-Source: APXvYqxNl5ZrITggirP07B2YJzamyMTBJzxylxZb2b6+VNrMELKwZwRweVjwO5wsL1Iw/DmbgnEzqg==
X-Received: by 2002:adf:f7c6:: with SMTP id a6mr70681519wrq.164.1582561157671;
        Mon, 24 Feb 2020 08:19:17 -0800 (PST)
Received: from [192.168.43.177] ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id t3sm4373200wrx.38.2020.02.24.08.19.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 08:19:16 -0800 (PST)
Subject: Re: Deduplicate io_*_prep calls?
To:     Jens Axboe <axboe@kernel.dk>, Andres Freund <andres@anarazel.de>
Cc:     io-uring@vger.kernel.org
References: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
 <b3c1489a-c95d-af41-3369-6fd79d6b259c@kernel.dk>
 <20200224033352.j6bsyrncd7z7eefq@alap3.anarazel.de>
 <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
 <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
 <933f2211-d395-fa84-59ae-0b2e725df613@kernel.dk>
 <23a49bca-26a6-ddbd-480b-d7f3caa16c29@gmail.com>
 <065ee992-7eaf-051a-e8c5-9e0e8731b3f1@kernel.dk>
 <746b93f0-d0b5-558a-28c7-a614b2367d91@gmail.com>
 <c17acad2-89f6-b312-f591-c9e887b4fc2b@kernel.dk>
 <ad07fe70-ea45-a1bf-21c3-9af241bdef15@gmail.com>
 <b9901cca-caab-2261-2482-9bf9f81d589d@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <aacab312-9768-3784-0608-40531e78ee2b@gmail.com>
Date:   Mon, 24 Feb 2020 19:18:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <b9901cca-caab-2261-2482-9bf9f81d589d@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gvx6oMzitEfTJzkmbk6w4OujWhNYX7qpg"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gvx6oMzitEfTJzkmbk6w4OujWhNYX7qpg
Content-Type: multipart/mixed; boundary="6ZpSjsKScup28emj7QmVxwAyXdrMULCCM";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Andres Freund <andres@anarazel.de>
Cc: io-uring@vger.kernel.org
Message-ID: <aacab312-9768-3784-0608-40531e78ee2b@gmail.com>
Subject: Re: Deduplicate io_*_prep calls?
References: <20200224010754.h7sr7xxspcbddcsj@alap3.anarazel.de>
 <b3c1489a-c95d-af41-3369-6fd79d6b259c@kernel.dk>
 <20200224033352.j6bsyrncd7z7eefq@alap3.anarazel.de>
 <90097a02-ade0-bc9a-bc00-54867f3c24bc@kernel.dk>
 <20200224071211.bar3aqgo76sznqd5@alap3.anarazel.de>
 <933f2211-d395-fa84-59ae-0b2e725df613@kernel.dk>
 <23a49bca-26a6-ddbd-480b-d7f3caa16c29@gmail.com>
 <065ee992-7eaf-051a-e8c5-9e0e8731b3f1@kernel.dk>
 <746b93f0-d0b5-558a-28c7-a614b2367d91@gmail.com>
 <c17acad2-89f6-b312-f591-c9e887b4fc2b@kernel.dk>
 <ad07fe70-ea45-a1bf-21c3-9af241bdef15@gmail.com>
 <b9901cca-caab-2261-2482-9bf9f81d589d@kernel.dk>
In-Reply-To: <b9901cca-caab-2261-2482-9bf9f81d589d@kernel.dk>

--6ZpSjsKScup28emj7QmVxwAyXdrMULCCM
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 24/02/2020 19:02, Jens Axboe wrote:
>> Usually doesn't work because of such possible "hackier assignments".
>> Ok, I have to go and experiment a bit. Anyway, it probably generates a=
 lot of
>> useless stuff, e.g. for req->ctx
>=20
> Tried this, and it generates the same code...

Maybe it wasn't able to optimise in the first place

E.g. for the following code any compiler generates 2 reads (thanks godbol=
t).

extern void foo(int);
int bar(const int *v)
{
    foo(*v);
    return *v;
}

>=20
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index ba8d4e2d9f99..8de5863aa749 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -598,7 +598,7 @@ struct io_kiocb {
> =20
>  	struct io_async_ctx		*io;
>  	bool				needs_fixed_file;
> -	u8				opcode;
> +	const u8			opcode;
> =20
>  	struct io_ring_ctx	*ctx;
>  	struct list_head	list;
> @@ -5427,6 +5427,8 @@ static bool io_get_sqring(struct io_ring_ctx *ctx=
, struct io_kiocb *req,
>  	 */
>  	head =3D READ_ONCE(sq_array[ctx->cached_sq_head & ctx->sq_mask]);
>  	if (likely(head < ctx->sq_entries)) {
> +		u8 *op;
> +
>  		/*
>  		 * All io need record the previous position, if LINK vs DARIN,
>  		 * it can be used to mark the position of the first IO in the
> @@ -5434,7 +5436,8 @@ static bool io_get_sqring(struct io_ring_ctx *ctx=
, struct io_kiocb *req,
>  		 */
>  		req->sequence =3D ctx->cached_sq_head;
>  		*sqe_ptr =3D &ctx->sq_sqes[head];
> -		req->opcode =3D READ_ONCE((*sqe_ptr)->opcode);
> +		op =3D (void *) req + offsetof(struct io_kiocb, opcode);
> +		*op =3D READ_ONCE((*sqe_ptr)->opcode);
>  		req->user_data =3D READ_ONCE((*sqe_ptr)->user_data);
>  		ctx->cached_sq_head++;
>  		return true;
>=20

--=20
Pavel Begunkov


--6ZpSjsKScup28emj7QmVxwAyXdrMULCCM--

--gvx6oMzitEfTJzkmbk6w4OujWhNYX7qpg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5T91IACgkQWt5b1Glr
+6Vksw/+NvRvHKEqcPS6FCu/o6sPrB8Irj/0k/6GCkRNiMsaEWnamdky+oCgLpRK
LPrqMPu2ljJK58O3/RrVmAGSgZDYG5oQfbJhjexZszGIRhcfQu+TU3Fwte0JW4aG
rtXtQV+SZm/oRPjPqMR7/nw5u7tMuSTiIJKqkzYXj7zG69XGXQCnFBM0NQQXq/h3
i2BN8hwNO2O50lsuBFdtVHSQ1LoP9r/h4SwSgsryyPDAA2Fq9LCDJh1MM98FxstU
mr8wWIQ64gOV1UIItSgZ9aVq/sabOfql1Xo3ZAq2xGEE2repj0vYbxJ/mt/UZoXC
23U2j1Afq5a18uCyyAZifwUxmbAUmQiDoa4yvIY7IQVuOxQI4XfkBJPW6UKuF3gZ
TLkEEsrVRKmlotYNocRsjaljJKptTdwLWpas1wxdsm8ptB0oQY08PPrd8WApFd7c
7eUS51hV9ULhyzDCCSH+vc2ZJ+Dl+OOkrsTG3LPTy740kyYzvoJOdhhr78VnI2Yr
ewB5veCEfIoiF1BBK1jKL38j1VA1c+y+qqCtLjmeJgMEPtdFOOP5kqSkpNN0H6Kr
cXGO+8FphwFWL4dPnx76V3TRGZNrbAQBkqywT3KfNxQ8xKxEGqM/WPbIPyMZlvEk
c/gPLRIIF9b7p55y9KKxMG81OzgMsaQ+0uRfx/9BItoyeGbON20=
=S5CF
-----END PGP SIGNATURE-----

--gvx6oMzitEfTJzkmbk6w4OujWhNYX7qpg--
