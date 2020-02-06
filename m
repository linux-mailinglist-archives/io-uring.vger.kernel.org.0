Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B08E4154D0E
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 21:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbgBFUki (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 15:40:38 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46724 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727831AbgBFUkh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Feb 2020 15:40:37 -0500
Received: by mail-ed1-f68.google.com with SMTP id m8so7374281edi.13;
        Thu, 06 Feb 2020 12:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=rnYxDh+h749EdLwhgXfV9d4c+yVdD+YaD6lBU0Sa0/o=;
        b=slwr7AZEj3UNde7Jh1a6BWWuQrdqCWvivSo8ahEM5lv7RSe8cxRWaBRDERsRNyFPj4
         0pQrR1sBbgPUzDA8NKWZ0bYqxy/ung6IZR/A86KpOdD2l7tdt4WZ0xPgTBXUV35P/6bu
         CdAcaTFSPWtONngvIaOgUR0gcz5vUXdZ6i1j14Y90oiFDSRBov4pQNXVDLHWS2u43U5f
         Rps541ZflWTiZrAcAMN7zEhHrmmGiQjj+IUp2Gut0jFCHenbtd/uC7KKtAku6S8oJNHv
         6KbmgB/xuMF/pSuatBErveiYgOwJR0MRHaQ7LH2ooMosqyt1/93zjNCk/qASUIwLJCtw
         o9Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=rnYxDh+h749EdLwhgXfV9d4c+yVdD+YaD6lBU0Sa0/o=;
        b=oWAXdwmT2KPj6LMxQywKPVr98RNvxGCd6+Kiuef9zmn+lI/aRFVO4WEsqGdjm3U95d
         fhlqCCLKmE8x/qpJmOAL6S8ksUUGpN5wJy+lBaON6v6PRyo1Bfh0FeaptVsvtV6Qjugp
         /cUA2xoyRbg+ZSpy5dxuRXqlqUrJUPbrRGu5gcq43SpYc5/oCnye8Mu5gbNAt7rcn/9D
         9xh4FUGildaEFDYhZrrX4w2FafVFUej8Qjqb7Uia0Vy4m8asOHyJZ+/X/tqc3nIbCnag
         YCJA39AH3kGw/X5mypH+MSr1nHwHtBxBRAt1bQys2Hz3ImI8sT90/bbHS/86vcIcr098
         0kRg==
X-Gm-Message-State: APjAAAUK701Ox2gVYYGWjV2Q+wluggJ6+Q6vYU0X0k79jOBWCi0ubHz4
        N5mwkAlmOhYmfNiL5hCxKwK8dNvA
X-Google-Smtp-Source: APXvYqzV8f1i7U14LdaTobdGth0wYMDMr0iZD0b2kvpTsdqBridzwhN5R8PDlFDb/Iv6Lnb4yEJhgQ==
X-Received: by 2002:aa7:d9c2:: with SMTP id v2mr4751903eds.88.1581021634876;
        Thu, 06 Feb 2020 12:40:34 -0800 (PST)
Received: from [192.168.43.191] ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id b18sm47206eds.18.2020.02.06.12.40.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 12:40:34 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <e143e45a34dce9d271fc4a3b32f7620c5a7377c1.1581007844.git.asml.silence@gmail.com>
 <d8486857-ccd3-41bd-2ef7-5ac4781dbd5f@gmail.com>
 <f6a1d5aa-f84d-168e-4fdf-6fb895fc09df@gmail.com>
 <6e7207b6-95c4-4287-5872-fb05abf60e88@kernel.dk>
 <4f7f61d3-b3f9-43db-ad32-ee502dc06c8b@gmail.com>
 <28cacc0c-68e4-a9d1-bb5e-03dbeff8a586@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: fix deferred req iovec leak
Message-ID: <37dc06c1-e7ee-a185-43a7-98883709f5b0@gmail.com>
Date:   Thu, 6 Feb 2020 23:39:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <28cacc0c-68e4-a9d1-bb5e-03dbeff8a586@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Bxvd5vweesDEVH4gpFZIGHIROPEn12E13"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Bxvd5vweesDEVH4gpFZIGHIROPEn12E13
Content-Type: multipart/mixed; boundary="6VNq5rsRCJUdUFKrej84YQhP9PUuIhYGX";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <37dc06c1-e7ee-a185-43a7-98883709f5b0@gmail.com>
Subject: Re: [PATCH] io_uring: fix deferred req iovec leak
References: <e143e45a34dce9d271fc4a3b32f7620c5a7377c1.1581007844.git.asml.silence@gmail.com>
 <d8486857-ccd3-41bd-2ef7-5ac4781dbd5f@gmail.com>
 <f6a1d5aa-f84d-168e-4fdf-6fb895fc09df@gmail.com>
 <6e7207b6-95c4-4287-5872-fb05abf60e88@kernel.dk>
 <4f7f61d3-b3f9-43db-ad32-ee502dc06c8b@gmail.com>
 <28cacc0c-68e4-a9d1-bb5e-03dbeff8a586@kernel.dk>
In-Reply-To: <28cacc0c-68e4-a9d1-bb5e-03dbeff8a586@kernel.dk>

--6VNq5rsRCJUdUFKrej84YQhP9PUuIhYGX
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 06/02/2020 23:16, Jens Axboe wrote:
> On 2/6/20 1:00 PM, Pavel Begunkov wrote:
>> On 06/02/2020 22:56, Jens Axboe wrote:
>>> On 2/6/20 10:16 AM, Pavel Begunkov wrote:
>>>> On 06/02/2020 20:04, Pavel Begunkov wrote:
>>>>> On 06/02/2020 19:51, Pavel Begunkov wrote:
>>>>>> After defer, a request will be prepared, that includes allocating =
iovec
>>>>>> if needed, and then submitted through io_wq_submit_work() but not =
custom
>>>>>> handler (e.g. io_rw_async()/io_sendrecv_async()). However, it'll l=
eak
>>>>>> iovec, as it's in io-wq and the code goes as follows:
>>>>>>
>>>>>> io_read() {
>>>>>> 	if (!io_wq_current_is_worker())
>>>>>> 		kfree(iovec);
>>>>>> }
>>>>>>
>>>>>> Put all deallocation logic in io_{read,write,send,recv}(), which w=
ill
>>>>>> leave the memory, if going async with -EAGAIN.
>>>>>>
>>>>> Interestingly, this will fail badly if it returns -EAGAIN from io-w=
q context.
>>>>> Apparently, I need to do v2.
>>>>>
>>>> Or not...
>>>> Jens, can you please explain what's with the -EAGAIN handling in
>>>> io_wq_submit_work()? Checking the code, it seems neither of
>>>> read/write/recv/send can return -EAGAIN from async context (i.e.
>>>> force_nonblock=3Dfalse). Are there other ops that can do it?
>>>
>>> Nobody should return -EAGAIN with force_nonblock=3Dfalse, they should=

>>> end the io_kiocb inline for that.
>>>
>>
>> If so for those 4, then the patch should work well.
>=20
> Maybe I'm dense, but I'm not seeing the leak? We have two cases here:
>=20

There is an example:

1. submit a read, which need defer.

2. io_req_defer() allocates ->io and goes io_req_defer_prep() -> io_read_=
prep().
Let #vecs > UIO_FASTIOV, so the prep() in the presence of ->io will alloc=
ate iovec.
Note: that work.func is left io_wq_submit_work

3. At some point @io_wq calls io_wq_submit_work() -> io_issue_sqe() -> io=
_read(),

4. actual reading succeeds, and it's coming to finalisation and the follo=
wing
code in particular.

if (!io_wq_current_is_worker())
	kfree(iovec);

5. Because we're in io_wq, the cleanup will not be performed, even though=
 we're
returning with success. And that's a leak.

Do you see anything wrong with it?

> - The number of vecs is less than UIO_FASTIOV, in which case we use the=

>   on-stack inline_vecs. If we need to go async, we copy that inline vec=

>   to our async_ctx area.
>=20
> - The number of vecs is more than UIO_FASTIOV, this is where iovec is
>   allocated by the vec import. If we make it to completion here, we
>   free it at the end of eg io_read(). If we need to go async, we stash
>   that pointer in our async_ctx area and free it when the work item
>   has run and completed.
>=20

--=20
Pavel Begunkov


--6VNq5rsRCJUdUFKrej84YQhP9PUuIhYGX--

--Bxvd5vweesDEVH4gpFZIGHIROPEn12E13
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl48eZwACgkQWt5b1Glr
+6XOjhAAiIkgHSwn/SvBO3ukQzboHo9qpcESx1X4DY7hfOT5vB9GTsyIbIcvBDga
Sp7OgG0l7r877S4CNjpq0WIfX9ihS7ceEARpHgtqpfZBObRi+nZtrckAweD2dajq
l02ZYEybf7HjNC6/AbJfABasOn5S4/N0Ltn2buOS7srRSw+PK+8whk8EAS3D934a
34ZWPr+EaLh3tsNzyztv6ardmhcphe8jQxZMVovJuSSpL2bopVHHUpLE+2MlPd+v
aiULYBAKhnl4Gy0kDoqhJ73tkm7H/AxYUeUcPyNTRewK9yECNLMXucCEe8bymCbF
XONwnzUdbPzAXxU1+DrQ33jQIq4aU2nt/uH/dNAAmR6k82Z0ks1PJGn44OL5x0xF
yJt3PGDoN/OdrZL5JTNJNGG8K4mxGuF4gwz9pzldGFg/htW1R02wTj+X5x+Qcrmp
cgkEIaaQJ8gHs6cwHuJqD97RRWp9aPvgcDPmvVcfVPq7PxCu49vLbATbZ5Bi495c
O1o42c7Fos0Tz5TlKeWQMCZti9U4xWfpZtebvi65ep1SCbCjX38+3NkT5igk5Cyl
J1SOfF1nAfIgG1nbgpLdgfnbe8DKoWV7t1LQ+hhDkMasZ68mx1rjWp6aictF9Muc
LVHUXtE7uOe9Bv4DPPBnAU8DAs49zerMionxSbIlFpg6Q/nj12M=
=OdOu
-----END PGP SIGNATURE-----

--Bxvd5vweesDEVH4gpFZIGHIROPEn12E13--
