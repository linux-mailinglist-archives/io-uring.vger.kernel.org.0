Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A21DF1560BE
	for <lists+io-uring@lfdr.de>; Fri,  7 Feb 2020 22:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgBGVgN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Feb 2020 16:36:13 -0500
Received: from mail-ed1-f44.google.com ([209.85.208.44]:38900 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbgBGVgN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Feb 2020 16:36:13 -0500
Received: by mail-ed1-f44.google.com with SMTP id p23so1096784edr.5
        for <io-uring@vger.kernel.org>; Fri, 07 Feb 2020 13:36:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=PQOg2jXQ4TYuJ2ST0Xo9/F3P7DPLPhXPZ93WoyYhYps=;
        b=IQKmfER/lpDqVgIvEv9IYzoKK7dmQZtyQZhMeimGxIv4h4eLwHvjuSEE+L/aorQY3t
         YgTz5oTF1Uzpuk1LMWfTT6q3Yz/Lh6AL1CBQ0mgfUSw0iI3PMpZtvRTDbp/62PqBHMZy
         APbUB42FjnSKQKAjuMtDooyDVKj/gR2lWMIq1rgWsFgSj7yLds4l2awZrnVn49pH3FhO
         jr99Uf5uMeSlg3vDWh1eAltnvbt4J4rbacDm4t0on1FLFd47pcvcBinMaswkWOv1Fs6+
         P2ih2xt6hYmy3Jy+JKcUh5eiKTbKSQAXnkQt7xolaUzC8bX7vBD9KJgICGW+opK3acjI
         bQ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=PQOg2jXQ4TYuJ2ST0Xo9/F3P7DPLPhXPZ93WoyYhYps=;
        b=ZMTpwfoAgE1CueiP/zAm9sSmfUjqr1hcoNxC1C6GDrvaiEu0P8Om06tynxBlioOd4v
         QxELZQJc74st9iHRo2eMmss/Zulm4FGg4as69uX13DFu/NsT2WnBwIVboFnZfpCzK8v3
         z2PoaqReAA71LOPIfY2UyB0n6cyTyt2ciR+Y5RPYmd0Y4DdTYkp9BewzkLSKrY0Ww/Aq
         AhjVWx3GlrclMiV5CgBYvV0t/juLmAEgjdMoLFOA0HIQZeuPlhy37bIdwFVqAcpB/Ax/
         ItdZcKkD0k44a7DlnshGh6lUi46Oxn6IgAFmh1avagjoMHaK3RojMqRrDFhF9wGejdNW
         6Xgg==
X-Gm-Message-State: APjAAAXufSLM9RmFJRewCpd3u9GuVkA3HUsp07wdV95qrBABKqPLxrQg
        5wEjDz8b0Db82474Q36WnIuA3Wlc
X-Google-Smtp-Source: APXvYqz5QnIIc2NNhO4bGh2IMsZ48PMHir0AEx250RkadVmsSUpJdu6y5nFOU3j/ATi8ReOF68pMSw==
X-Received: by 2002:a50:bf4b:: with SMTP id g11mr789691edk.373.1581111371265;
        Fri, 07 Feb 2020 13:36:11 -0800 (PST)
Received: from [192.168.43.117] ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id y4sm218086edl.11.2020.02.07.13.36.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2020 13:36:10 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <45f22c50-1ffe-4b73-f213-08dd49233597@gmail.com>
 <6052650b-4deb-4a4c-8efb-a85e4781cce2@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: io_close()
Message-ID: <bf5b575f-1d45-a3db-46ea-925a0eb4fa08@gmail.com>
Date:   Sat, 8 Feb 2020 00:35:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <6052650b-4deb-4a4c-8efb-a85e4781cce2@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fjmInl4w7v0SwHWZA7MedZ59RQS62jSnW"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fjmInl4w7v0SwHWZA7MedZ59RQS62jSnW
Content-Type: multipart/mixed; boundary="WSrE42krQvVAcZWqcs01U6HxgOIPsafKN";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Message-ID: <bf5b575f-1d45-a3db-46ea-925a0eb4fa08@gmail.com>
Subject: Re: io_close()
References: <45f22c50-1ffe-4b73-f213-08dd49233597@gmail.com>
 <6052650b-4deb-4a4c-8efb-a85e4781cce2@kernel.dk>
In-Reply-To: <6052650b-4deb-4a4c-8efb-a85e4781cce2@kernel.dk>

--WSrE42krQvVAcZWqcs01U6HxgOIPsafKN
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

What confuses me, is that in case of ->flush, it doesn't return -EAGAIN, =
but
io_queue_async_work() itself, so nobody will set ->work.files. But that m=
eans
io_close_finish() won't do filp_close() as well.

Did I missed somewhere called io_grab_files()?


--=20
Pavel Begunkov


--WSrE42krQvVAcZWqcs01U6HxgOIPsafKN--

--fjmInl4w7v0SwHWZA7MedZ59RQS62jSnW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl492CIACgkQWt5b1Glr
+6VcqQ//RaBJkDlDHs0KeEuzgZCGyzEtKcTiaNBaIw4n7t+hDSbuEtGbXWh3++O1
b+d0k/dEsqNXq58+Bhye6J/CMpqOCBwGjT/+Rtz0YWJJUX8MdiOIclqYvE1p6KI5
E4COUgBoP6eDhAu+DRu7d3096dmHIWGkEvH/KO1joJnZ2Blse8+lCs3BUbo2JRlB
ZmQHrfbYoJQ1s1w81RJ43hikeP3I/FBkpst0+9MpjqIT0STbNMmth5rEJxlGF9xL
znpzh7PxzPru5UQQl7XmcuUW+FMO41junKXTBTJAFUnJPfqyNzZVcdRIGoFrqaqk
ttChstmglrEavv7HZz+dRgd1Asr87MXmcjDnqkyiqvkA6tSlMgQJ96mOhalEUOSv
5JrBHwLgXMDf0giDLFNgLtuiq8V4vQaKtiMfMPAi2/3y4OBbhHGUKzR6xRFp7Yl9
EpWZrcefHnBOhYhW1SOcy2zQybO1EPWeu18CjX/3S2hYYHE4iZ+bOnSi9CWqCSrt
31VLSmgwoAAlcGahz8Xj1/18UT2xWwZkJ9g1AS/d4Kt7PH5EIN+uN6cxKrarG+dU
tqAHab90msV/r04OzgStlsXs20ZFdXkwEpkYgljQfZgzrQUlqD6PSor/IWT/p3Ym
4OZGhq9Mn8OmJ34gDWXxStbqatXLKCOKl5viS/Q4zQHRVDzU4g0=
=j+o/
-----END PGP SIGNATURE-----

--fjmInl4w7v0SwHWZA7MedZ59RQS62jSnW--
