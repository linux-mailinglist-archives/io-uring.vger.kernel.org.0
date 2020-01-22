Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 330351449C1
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2020 03:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgAVCZV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jan 2020 21:25:21 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37675 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgAVCZV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Jan 2020 21:25:21 -0500
Received: by mail-wm1-f67.google.com with SMTP id f129so5546289wmf.2;
        Tue, 21 Jan 2020 18:25:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=bCrN2Bgium/3DKOtOAye+OxjKHz+lgLAog9DQsTYhxo=;
        b=Lqcj9dgmuO2IoZv/pbWn0n8xaZZ/wc3EKEpJ121gNH0Jp7BHyeW0pgRXnJHn9mrMUO
         iWB205t0woplwHfoq/arQYtawgCg7IcZUD+FpFnJTdDwGD2NxP3/6LhWfFT9zuofDeoI
         bGCsJynR0NFg+2778IkxtGNa9mKola8ukudG6Vd4tGmq921NJBxrU+hWijPH4dalhGsj
         VoZGoqEAW5PRnM73Z6lSMIOalPWYkUNu9GJjsRcj9eqpsLjP0BJDpDFwiqz1c1zigLer
         WmKiTu/pc1aa1ivAv7ulL9WtzFafPlHwy4ahigHm57YA7PawV2UC9XymvON9JHucrt3u
         kFFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=bCrN2Bgium/3DKOtOAye+OxjKHz+lgLAog9DQsTYhxo=;
        b=cudwFPE/J1WQrwVRvQ5lEvqfHqDkM5q7qz5MSRAmRcVAdHf8Ad7qJDUitJpq016tLc
         Vbq+2le0poDaQb/RrRTj3ISJedI0bibVAmh9MjUldd3+JpLZXbnMHvcneLOET0pc7k5B
         ATg45RJHMHjjZaai4mfGGfjLw015WN6g3gnH4/4gXmPIT2wgLXPF+LD/rFq9QC4wYygP
         wLirwaAQSnhMurAz1Bc0zcBI+PfEDrjcPN349mCPWubzg0oRGj+NcLNSUFrJ5GdykWAG
         0MdIMiRY/tcqzWuRAfQchGhKxIQ/Nsl+rXjLJUHfjDOBp89zZ+EQR/ci4rEAu5r1aKi2
         sy5w==
X-Gm-Message-State: APjAAAVICO5Vitbu0wCdFvUFYKXocTPf2Q081CAjTMDkdl3OC/BolAK6
        tvNsDoFh58KGx0e//Govego=
X-Google-Smtp-Source: APXvYqxcu0P0Xu3hxC1+tEeAUNAeGad719lsFLUGLr29nTR9ni+9gurnXFoBHVRIEwbsQJAiKa7mWQ==
X-Received: by 2002:a1c:dcd5:: with SMTP id t204mr161275wmg.34.1579659917750;
        Tue, 21 Jan 2020 18:25:17 -0800 (PST)
Received: from [192.168.43.234] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id f207sm2139009wme.9.2020.01.21.18.25.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 18:25:16 -0800 (PST)
Subject: Re: [PATCH 2/3] io_uring: add interface for getting files
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>
References: <cover.1579649589.git.asml.silence@gmail.com>
 <96dc9d5a58450f462a62679e67db85850370a9f6.1579649589.git.asml.silence@gmail.com>
 <74320473-6f9f-7b10-4d5c-850c6f3af5ae@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <fc01874b-c01e-7d4b-2c1c-55973f2c1390@gmail.com>
Date:   Wed, 22 Jan 2020 05:24:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <74320473-6f9f-7b10-4d5c-850c6f3af5ae@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="14Ovg65bPt51zUbfLUfLw8XcItLWirDNp"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--14Ovg65bPt51zUbfLUfLw8XcItLWirDNp
Content-Type: multipart/mixed; boundary="lqDMMrYRrZdgUVJLBv5apv7s2A9JFNJN4";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Message-ID: <fc01874b-c01e-7d4b-2c1c-55973f2c1390@gmail.com>
Subject: Re: [PATCH 2/3] io_uring: add interface for getting files
References: <cover.1579649589.git.asml.silence@gmail.com>
 <96dc9d5a58450f462a62679e67db85850370a9f6.1579649589.git.asml.silence@gmail.com>
 <74320473-6f9f-7b10-4d5c-850c6f3af5ae@kernel.dk>
In-Reply-To: <74320473-6f9f-7b10-4d5c-850c6f3af5ae@kernel.dk>

--lqDMMrYRrZdgUVJLBv5apv7s2A9JFNJN4
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 22/01/2020 04:54, Jens Axboe wrote:
> On 1/21/20 5:05 PM, Pavel Begunkov wrote:
>> Preparation without functional changes. Adds io_get_file(), that allow=
s
>> to grab files not only into req->file.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  fs/io_uring.c | 66 ++++++++++++++++++++++++++++++++------------------=
-
>>  1 file changed, 41 insertions(+), 25 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 8f7846cb1ebf..e9e4aee0fb99 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1161,6 +1161,15 @@ static struct io_kiocb *io_get_req(struct io_ri=
ng_ctx *ctx,
>>  	return NULL;
>>  }
>> =20
>> +static inline void io_put_file(struct io_ring_ctx *ctx, struct file *=
file,
>> +			  bool fixed)
>> +{
>> +	if (fixed)
>> +		percpu_ref_put(&ctx->file_data->refs);
>> +	else
>> +		fput(file);
>> +}
>=20
> Just make this take struct io_kiocb?
>=20

Ok, I'll make it io_put_file(req, file, is_fixed);
It still needs @file, as there can be many per req as in splice.

> Apart from that, looks fine to me.
>=20

--=20
Pavel Begunkov


--lqDMMrYRrZdgUVJLBv5apv7s2A9JFNJN4--

--14Ovg65bPt51zUbfLUfLw8XcItLWirDNp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4nsmgACgkQWt5b1Glr
+6UKcBAAtW9i3NNLNOgqLKFOs6TFgBLiF5xpfLTXMx4p0/K9EnEF3gEiXPqipAO3
YuM6ipAklm96vWLwERWhNOsTuEH9ONOIjPXlw6/8CYw12xHljpvy8kfh1IofEVJv
35kryx2kssPKR+/PkEsIfhW8HVB38c7cgx2HzA9UQ11oYK/Q98RnIFXPQ4I3gpC0
YFATK++2rrifSRpDuRRLql5PCtSkoVtYz+H9VDIq12QOEYFbiqPV+dpNZodvd5/2
8YhaoNl5Vzu2+J5uDS62D+TI62jpW4e23RbLp4tTi4o5mE9mc0HGAqAQOUTFiekJ
XBFN43GZvxN0GAKjX/INb3iacWLoyCSd4kGwDA99p5pfwpfazxgHoMBI1I1ADU+Z
7aB9eL5/kYfKBLyycXDsPYt9hWNaET/K6KUbgwgB0b2gK6pPMyF2Zjfx00EgtwLs
NKbnJfjF2rogl5mSjZJAw+Ov/sa9VZNUnDOX6cVgHkZK0JLaV33LdajOZza/zgjN
2yfrFcRv3ct8nbWMR6fz5ogNyMAkjUbByS1HKYHrGd3hGLkcbNko850k6HVck3cR
7TF7VumcbGOIQdYsKlZ8wJCeGTppJMHcCkCyEC7defTgixBM9n0otThxr9Rn+Har
ElqvKOZBkyPEe/z0Z7tnrifHUnDYO6n0+e+iHzOjjBxbEE6FcyE=
=z7NK
-----END PGP SIGNATURE-----

--14Ovg65bPt51zUbfLUfLw8XcItLWirDNp--
