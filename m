Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5538154C85
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 20:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbgBFT75 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 14:59:57 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:32849 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbgBFT75 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Feb 2020 14:59:57 -0500
Received: by mail-ed1-f66.google.com with SMTP id r21so7324687edq.0;
        Thu, 06 Feb 2020 11:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=EgmVhIivL5EiTcOIywB1NY5mZxiq3eHGCj/gx/SHguk=;
        b=DI2fAZj3Npvo3N6CyiCyibJ61pP3hQ8eRo8Um36O8NRRABpgAV2X2K1NYEVv4qAx/8
         V9Q/0xmdGww7aBtYj4fXYvFBTt1FKLP1PIbM61JS40CC/UyAdrJ2p+XVmbmFNBpAQ0PJ
         xGxsKvW/w/4rw7wY65bw2MEooyIagOyYHQMkG0cOczq2kPbpsqPKaTVEWRT2ogInZYoi
         AWbvPxaNa3IMhVkBA6tfmvw6aehQxlJhOlZdMWQXl82Hnz/+Eb95q63d2djBDNVXZbOI
         VM17gD+aidTbOEOBK9Vhy4snA4sE8gQ/tnJ9850jpFI6y8yHaEUTsekGZIERaYJLbC+E
         mCRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=EgmVhIivL5EiTcOIywB1NY5mZxiq3eHGCj/gx/SHguk=;
        b=egVhErslsKYeGpeO4m6+GeZ8OFtm+Rpcm+mDRpQXbUJc6/p07CLlCaafAA2sj4bPE2
         IakHjRcpD/4z62rF6O7w+hlMS5o2KhlMOW9uyyl8MTMAoT4oEAxK7X3ppyY+58gWTi3d
         kDBfHIX09+nA/Jdn39U4FCzT6K6VUIrtycXRdjFZzkHbMfgdA4lJMb8P4NxSkFfqFCk6
         G9HHJA4bLOyzi3+terr/yM8ZJNpmJW5UxcM61QjFruUZQ0D8pE97UiICM05B2YaIxNk8
         RltLII7wjZhJJHcPnZKfLWCtmHYI8JJMC4/c5x4iPDM6lxS6Nr5vvG9We/78A++b/+dt
         7+oQ==
X-Gm-Message-State: APjAAAWATRpdRLacnL8pvGWzu9XObBdBDlIwSsWUc1A1bI7zxRf2jGyV
        ODuyAW7Gsl70UqFZCt5Z4qcY5YeA
X-Google-Smtp-Source: APXvYqzawuAmAXfLcToZNMg2y6vIzWeZuiNVWBNnhXhkQIOu4Jm99yzuOiFLWq2KrntVGT+x4tf+1w==
X-Received: by 2002:a17:906:3084:: with SMTP id 4mr4747303ejv.140.1581019194323;
        Thu, 06 Feb 2020 11:59:54 -0800 (PST)
Received: from [192.168.43.191] ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id n14sm58250ejx.11.2020.02.06.11.59.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 11:59:53 -0800 (PST)
Subject: Re: [PATCH 1/1] io_uring: fix delayed mm check
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <5c7db203bb5aa23c22f16925ac00d50bdbe406e0.1581012158.git.asml.silence@gmail.com>
 <8dbd13cd-6e93-b765-ade2-27ba91d8c30d@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <5542bd3a-3701-f02a-7015-4c0f4e13cec7@gmail.com>
Date:   Thu, 6 Feb 2020 22:59:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <8dbd13cd-6e93-b765-ade2-27ba91d8c30d@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="KdrNy1j9THJ32NEXBGnD5Zw6yLX7tMGNA"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--KdrNy1j9THJ32NEXBGnD5Zw6yLX7tMGNA
Content-Type: multipart/mixed; boundary="QDagrq0nx4H1QDPvOJRCEbY3IUa8O28fN";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <5542bd3a-3701-f02a-7015-4c0f4e13cec7@gmail.com>
Subject: Re: [PATCH 1/1] io_uring: fix delayed mm check
References: <5c7db203bb5aa23c22f16925ac00d50bdbe406e0.1581012158.git.asml.silence@gmail.com>
 <8dbd13cd-6e93-b765-ade2-27ba91d8c30d@kernel.dk>
In-Reply-To: <8dbd13cd-6e93-b765-ade2-27ba91d8c30d@kernel.dk>

--QDagrq0nx4H1QDPvOJRCEbY3IUa8O28fN
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 06/02/2020 22:52, Jens Axboe wrote:
> On 2/6/20 11:16 AM, Pavel Begunkov wrote:
>> Fail fast if can't grab mm, so past that requests always have an mm
>> when required. This fixes not checking mm fault for
>> IORING_OP_{READ,WRITE}, as well allows to remove req->has_user
>> altogether.
>=20
> Looks fine, except that first hunk that I can just delete.
>=20
Oops, missed it. Thanks

--=20
Pavel Begunkov


--QDagrq0nx4H1QDPvOJRCEbY3IUa8O28fN--

--KdrNy1j9THJ32NEXBGnD5Zw6yLX7tMGNA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl48cBMACgkQWt5b1Glr
+6VsJQ//f2vqFm7I21IDe/Pv2BvyL1Ii6k5pNsbmlbRih2M+z64lzQxk5eJvtqNW
c0oyhEMVhrBOZOXSCDxJE9oNRaxjvGJLKQjYE/kN5ObPMRozzhyMsGmwfHw2uzdf
eReW9o1Jx9SHEbmFIsIat4u7mysYh2RghZ7lwonspdlFFsuS3LbLwIQvBT5eiYWF
/YQjkdhYAR258w82CUzZsTN47uYKjq8xDJtVSOrGmCKJm+yk4E/pF4RBskRP57m2
9mVMdUcYhpNGC5UOKMOJCvEDtZgcPXGPGEz+mH+Mnjl5cOjpd8ZSPvgO3zscJho2
bcr8etFtHfRzcF8tfTqcN3R5u/uO0cAkbda7JJU73WUMWX2QPL2N8TWKesGLDhne
tv8lGklkVeVMgOpNl6VP8LoCDXcBh99Tzl3u2YC026Ka6QWtZV0UOdSN5DTE1Ver
QV4b5mKPMvrs59TaDSsy9z1KZ/2ytoFBofyxSq9fOO2ypIbtwsFQFFIZByLqZkiL
rgpIdj2FbnGFqFZwdLAE2kJ65eFJVp+9e6FoT0ohpsovLkm3pFlLjFQA5VDsW8Yf
tFtBLEb9VPbhtXrH7DoDpGQCHDQ+wcqYNtl0roSMyvBLiBTQUOuFjNBcrxUlZlBO
JNZiOawVMv70HvA2YfxS9SY7dBp7Sr/hnauHmVGluNAW4104SNk=
=7Qgf
-----END PGP SIGNATURE-----

--KdrNy1j9THJ32NEXBGnD5Zw6yLX7tMGNA--
