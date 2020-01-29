Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1FE14D380
	for <lists+io-uring@lfdr.de>; Thu, 30 Jan 2020 00:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgA2XUZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 18:20:25 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40502 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbgA2XUZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 18:20:25 -0500
Received: by mail-wm1-f66.google.com with SMTP id t14so1932272wmi.5
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2020 15:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=7EeGlpYYKtwUPMLJFT1whe84GceAxHFmslUj67IBGcY=;
        b=lY5YTcuRkalDH66F9mBAk7AOrpe3XA3vEROVdhrWxgm8hbEDDJYPmKZOCWd8osKdMh
         1FpLgFLOqp8c8PKtZtPoePfd7pyNuo1lyK7htY6bymLNAtaW9Ozux/3i8G8PkqxQb9/x
         eUuLl5Zyun+AT0+T+IuiQbkgKmkAkljOboSaPOCYHNVnr1hj4brZ346IOvV86USoUIoE
         WNJ+7y3sRxbRcI6nktqwYXL8uOFT9pVpPAnNysjsRgcal0A8N0hGOtrN5yVliLmcOpTd
         eiLkc8N1SsO2Ue9EgLA/K5oFFe9o0ypAxEJKzpeVgDFGhFGVOGfOhg+LzkTBkvgBoUbZ
         GIoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=7EeGlpYYKtwUPMLJFT1whe84GceAxHFmslUj67IBGcY=;
        b=eDqVK7J2QljBfHA6hc8EBmSHSn7O69IOpqRKB7uxDJfjbnSNj7xTU1gN/N7g4p2uTD
         PlVtR3j1wlAIWkRnVC0nZxlKhqE16ZiwGV1k0dGiuSQ46ZfPBD4jfsdA4CR51jY4LPqU
         81d3697EUwML9e9K1Q5dbO99HkgJAIR3wn63KRnLNaLbnPxCoY2iE5APJci7pHY1bX1B
         EZYcOWBTDISuI5A8zsdQ3xTj/L3/yU+yJap5F1sUGliqiaeY3TQQM8PhM/mUkxcjoIc+
         4QQ+qmdef2rC3g7U3ahDIbhU8eoFwtdyRSQcyke27Z3XoLoEZuX7IilcYfF0AVEwhiGr
         EOCg==
X-Gm-Message-State: APjAAAU19Z4PGuJ7P8tTkVylDTTdEjEWb8MeA9WM968rvBBOYXVvHZ+G
        C3wcDC3BCRf2ZR1ZYUeQTgyYeh0Q
X-Google-Smtp-Source: APXvYqyWHegvxVjSdDmvzw2l45l+7189+gCkov7mqpfYbJ0cPPvYsR16nSsRACxKwrsdoSMvbuqd2g==
X-Received: by 2002:a05:600c:2290:: with SMTP id 16mr1560049wmf.93.1580340022484;
        Wed, 29 Jan 2020 15:20:22 -0800 (PST)
Received: from [192.168.43.140] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id a26sm4148899wmm.18.2020.01.29.15.20.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 15:20:21 -0800 (PST)
Subject: Re: [PATCH] io_uring: fix linked command file table usage
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <c2d0d637-85db-3500-f1ae-335bc1fec6c8@kernel.dk>
 <4a826524-4f77-2126-03e9-802c3567f73f@gmail.com>
 <828c41db-163e-c6db-5fdb-3f87246ac0ed@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <60df3f6c-7174-a306-47bd-92ca82e2c432@gmail.com>
Date:   Thu, 30 Jan 2020 02:19:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <828c41db-163e-c6db-5fdb-3f87246ac0ed@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kZ9L6l7ibg1LqxDB7OKiqtOcUKgGnumTe"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kZ9L6l7ibg1LqxDB7OKiqtOcUKgGnumTe
Content-Type: multipart/mixed; boundary="jgiCc5KrMX9YdcTlHW8E8lgX8MO14VCn6";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Message-ID: <60df3f6c-7174-a306-47bd-92ca82e2c432@gmail.com>
Subject: Re: [PATCH] io_uring: fix linked command file table usage
References: <c2d0d637-85db-3500-f1ae-335bc1fec6c8@kernel.dk>
 <4a826524-4f77-2126-03e9-802c3567f73f@gmail.com>
 <828c41db-163e-c6db-5fdb-3f87246ac0ed@kernel.dk>
In-Reply-To: <828c41db-163e-c6db-5fdb-3f87246ac0ed@kernel.dk>

--jgiCc5KrMX9YdcTlHW8E8lgX8MO14VCn6
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 30/01/2020 01:44, Jens Axboe wrote:
> On 1/29/20 3:37 PM, Pavel Begunkov wrote:
>> FYI, for-next
>>
>> fs/io_uring.c: In function =E2=80=98io_epoll_ctl=E2=80=99:
>> fs/io_uring.c:2661:22: error: =E2=80=98IO_WQ_WORK_NEEDS_FILES=E2=80=99=
 undeclared (first use in
>> this function)
>>  2661 |   req->work.flags |=3D IO_WQ_WORK_NEEDS_FILES;
>>       |                      ^~~~~~~~~~~~~~~~~~~~~~
>> fs/io_uring.c:2661:22: note: each undeclared identifier is reported on=
ly once
>> for each function it appears in
>> make[1]: *** [scripts/Makefile.build:266: fs/io_uring.o] Error 1
>> make: *** [Makefile:1693: fs] Error 2
>=20
> Oops thanks, forgot that the epoll bits aren't in the 5.6 main branch
> yet, but they are in for-next. I'll fix it up there, thanks.
>=20

Great. Also, it seems revert of ("io_uring: only allow submit from owning=
 task
") didn't get into for-next nor for-5.6/io_uring-vfs.

--=20
Pavel Begunkov


--jgiCc5KrMX9YdcTlHW8E8lgX8MO14VCn6--

--kZ9L6l7ibg1LqxDB7OKiqtOcUKgGnumTe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4yEwoACgkQWt5b1Glr
+6VpPA//bOHoFhLyk5DWwOJRNlOEYCu1e63RxONbHvQJldOox1c1LHocOnm7Wupk
PaDRCFXTxWskkabSdFemUEPTo5+zCZIBX0+ocwe6X12yV52TyqkIfb1NYP/iqZ+S
XynT0EOQkmACXpdvISS8XOWxUNrLswoWc6DoPkOk1OswSGU4iHz/MfOLYAVwYCoI
6kZ5+nz8AbD5e4iX77E+5g+uy+2jn2ScM8miCiQPnCwbiY7oDw/j1MfENqlbRsb7
2PTg8QMWycujtcLWkTrLNBl546PBdryPE/EVLOl5MuJkr3GMIbafuMrK0tPh2rm1
03eB8Gxu89kvI7nhHZEfznoJod4ezQ/TH7UzOok37MiwjkPBHKJRckmEbfeJg9J1
KSrLXIaxAE5brnV35pz+mpyi0lNGxbe8UL/DpU6tV4OzkLxFcJ6Ru5C4HskhyrP8
CNd4Wuj7twLc2Y02NPWtKE5fSvMU/tVNWwjH3WRRJJDomSD0vAequPrWuqPbdsA8
AI23nxPy/8TLjQcfZ9iRM+i+IAhT0DjEx4mgRZHsW6pKGQCVg38m1Ukr3O9WHSSo
j3uLg2GvhO7NaO4Eq4mqiQr4fbOnjwkUogFkKLdI0m5itp128JV3I5lJ0hscVf4p
BTn7MVSPdhelAsmACf1eraBmiaM7T2r3dREe30MN82tC0GnZS9E=
=5snx
-----END PGP SIGNATURE-----

--kZ9L6l7ibg1LqxDB7OKiqtOcUKgGnumTe--
