Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 885FD154DA3
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 22:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgBFVBE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 16:01:04 -0500
Received: from mail-ed1-f68.google.com ([209.85.208.68]:34131 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727698AbgBFVBE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Feb 2020 16:01:04 -0500
Received: by mail-ed1-f68.google.com with SMTP id r18so1228edl.1;
        Thu, 06 Feb 2020 13:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=iHy/QMCh3ianc+Pe6h4u7oblMIaf4QJNhjJ6WvB/GlA=;
        b=UNh3X1/e1venaF2dl6Fq5xMvEl/CtyR+lpLU1AoRd8Pm/Yxi77z/jQOMZkXD2zM/c3
         Xe3KHbhauLnZMM6l82IRlKgM2ABVBcXaHKX9wgH6QiSiC72B3Bxthv1MBNCTKqqskiuy
         q/VxFJR4RH4kgAJvpXazMU6myKkKjpC9orbxs+BDeHYnv83aNfvyyXdnLoeaXcrI/fpN
         8/TTWUbrKWtuSwxaHakP+kgWNbkISxDSsgbGxrh/ezhLOEX7k+T+aiX3aRr4R7lAFj5y
         TN1jJqoWUGtx1IwSsSG1M2gZjajljQTD0A0YZTkpCihCuBt5jQWnIABe0GA1gvg0DLER
         2qNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=iHy/QMCh3ianc+Pe6h4u7oblMIaf4QJNhjJ6WvB/GlA=;
        b=hs4CrA4WjeEe2YhCDwdveldPoFqU7CKKYPYSE0/WixatX1g+ixafEfF2L+lzo1m7zB
         9Pq7ymHhBLn7x3BuNr+ii/j/2uAtlx6JZGZNRbw939prbenBgBTmTrgJx9I/uA5v7Rwp
         kQlpCnuOsVDLneouwMuqvkcg7Y+YI65PpDtPG1Jr5XaZmoZVtyLlNaa/Jq6sUYdOKRUF
         ZE1zQdGWn8Q9n0qN0vlzMqiVB6unov/AfOGXKSQhk8EFt6QxYrfhHWQEVxXampmze7jW
         Eg/09yHhvVo6MrHepkTBinR67+cg5j+41spr/7WibfXhBTREHmCoftZhyNZjJksCP6Th
         4WqQ==
X-Gm-Message-State: APjAAAUm94WZMkHihpMqn9czk6I7EjFv/TVLYdizJmriZ34hnDdWX0Gz
        x8sjJTWNnbX079MzF0jgKdPkmZia
X-Google-Smtp-Source: APXvYqyd0xsU1iN4PdSRMGEIbhASW4soIkaLnrqRKDnZCotE7gu6R4/2lrx0fkaMZjMpCBmvpaWZoA==
X-Received: by 2002:a17:906:ce4a:: with SMTP id se10mr4985599ejb.157.1581022861862;
        Thu, 06 Feb 2020 13:01:01 -0800 (PST)
Received: from [192.168.43.191] ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id cm24sm56381edb.59.2020.02.06.13.01.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Feb 2020 13:01:01 -0800 (PST)
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
Message-ID: <8b076791-2ec7-3245-6036-b5107958be9f@gmail.com>
Date:   Fri, 7 Feb 2020 00:00:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <28cacc0c-68e4-a9d1-bb5e-03dbeff8a586@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="kRboZspGK2r6Ovkpr3M2jIaoVxZjCkkxP"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--kRboZspGK2r6Ovkpr3M2jIaoVxZjCkkxP
Content-Type: multipart/mixed; boundary="008okh2CNgo5yQg8LDjtCHKIuL07Q2yZe";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <8b076791-2ec7-3245-6036-b5107958be9f@gmail.com>
Subject: Re: [PATCH] io_uring: fix deferred req iovec leak
References: <e143e45a34dce9d271fc4a3b32f7620c5a7377c1.1581007844.git.asml.silence@gmail.com>
 <d8486857-ccd3-41bd-2ef7-5ac4781dbd5f@gmail.com>
 <f6a1d5aa-f84d-168e-4fdf-6fb895fc09df@gmail.com>
 <6e7207b6-95c4-4287-5872-fb05abf60e88@kernel.dk>
 <4f7f61d3-b3f9-43db-ad32-ee502dc06c8b@gmail.com>
 <28cacc0c-68e4-a9d1-bb5e-03dbeff8a586@kernel.dk>
In-Reply-To: <28cacc0c-68e4-a9d1-bb5e-03dbeff8a586@kernel.dk>

--008okh2CNgo5yQg8LDjtCHKIuL07Q2yZe
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

BTW, there are plenty of ways to leak even with this applied. E.g. double=

io_read_prep() call with ->io, and that may happen. Or by not punting in
__io_queue_sqe() after io_issue_sqe()=3D=3D-EAGAIN.

That's the next patch I'm preparing, and then I'm good for splice(2).

--=20
Pavel Begunkov


--008okh2CNgo5yQg8LDjtCHKIuL07Q2yZe--

--kRboZspGK2r6Ovkpr3M2jIaoVxZjCkkxP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl48fmIACgkQWt5b1Glr
+6Ww0g//XSgmcvVpMild1LDeVC6OHVSZdgta/+XWRv8CI8/K/5WIE6HMvzXGHl2h
i8en9pCWjZlXJL5R2UT8lp+rRieSu20Aw1Ct0lhXbfTbeAEcv7szEUs0f/gqKop1
riJkFDlQiBO8CqZKPbjNXCv+0ss+OCTnklPwj/l9nIFcRnlJOmj9XQWM/PDLn6Ih
jk6/eDW6YdprYjvPLtV5rtVF+OomAAG9oxV+AYSqYc6SJ9VQsRp7qNNmeQxn4iZe
MehdeeCbmAP4P4YLiYEIqTsQS/j5GB3y/N7DlN6OKAB31J2CY/gkWzSdt46e8WuI
FIwleyYkABHqHWqHhUQhGydHkzp6mCXZ+Z1xn1gIze6OHt+TX+s9Mdccs5g17zLF
auF9SibbiOuHqFVfrvr+tGUnEh8qAVkJLqUrAPAikZjBmbosCgalEusbhTouM+XM
rCEELORMcRKOUs1ARJ6x2r+NABGE3rPrUGN6ofNDrAKY5hXc//GuRAC7KduymBra
Qvp+hhIyaCcGL1wprRZtSZMUtZglq9M3NtYXIBxgmhyEz4v0hrco5VVOTMghEEMK
H4+T/h0DSxfriJsHkrB8d6k5fPbdTthZBtvCbbzgsPi5A6GfgH9TwPp0wtHCqWl0
AnMRTVCzD/3Gc5PoFv7z+7aOffdqi455gdvhFbcc8GeeEnTUz/A=
=/m4n
-----END PGP SIGNATURE-----

--kRboZspGK2r6Ovkpr3M2jIaoVxZjCkkxP--
