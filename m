Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE4314AC87
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 00:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgA0XR4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 18:17:56 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40549 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgA0XRz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 18:17:55 -0500
Received: by mail-wr1-f67.google.com with SMTP id c14so13805066wrn.7
        for <io-uring@vger.kernel.org>; Mon, 27 Jan 2020 15:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=rVlh3nCkUOvNDglM8lqVnrQq8DUbhYTRVwLxh3QPLEA=;
        b=HWZagWa+Zt1WdH+//Lw/27q8xWa/B8h3QmvprHsgEw1/GinFhhCNXACkI1voyV8eUx
         M6e5DPZmTvLDyIgoraRQ50E6fLKFWt5Wijb4Melr3mtQfvraz/cqnPiTqPH4p9l6JYbI
         vrf18qtcMfVN8D92fFHG4j+fBEuMP2k9fLaiO9K9xqSegcX1VdVsfc2oka928pHHhlQF
         8/Qafi0T6r/eGJatq8mDB2qplxfK25rH9EFtf0NqQbWmicb1hBF+tPQuovmFlL6r8doe
         d+2oI5sWQkUDrypbocOSJM1TP8ewjo3Ri1Uhw8IRPN0vp9wFt0ZGzt+gK9jWkQkBsmWb
         7hwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=rVlh3nCkUOvNDglM8lqVnrQq8DUbhYTRVwLxh3QPLEA=;
        b=Pj5LZE6kpTfs2MnkJQa9ftbNkfD9/QhJkzf8vHE6QMQFB0zboWJqbp77b0f/H64z+W
         /6ys/kpEtFdO0ukScaHX4X2s/W8ghFQ3iAgngX0QMKWIuGcrdobjc6ZAB860eW936pfT
         cYgb+wsLwHedt704vHcByWgLFgYJxsogdn7XJ2+AHKO2Cb7o+xVRyvQuflWDkNkd3pVk
         ZMlhmvND4qi1waa0Mw0mqsrqKW9H/tcsrG8ThPTwTa9Zu5nEweeIXGMtyYb2/BC7cbfv
         WXJd0D6zPQ7aaNWGBCUuZfBdM9cfUbWAfNf6OdrB33KmIta+6FxZ+/z2/tL4CvD3IyxK
         niBA==
X-Gm-Message-State: APjAAAVT5/3CcoNAhYjFdl81eZjplCiTN8JJNHLuWgTYZjzxLmDWM8Cl
        d2uAChDrPxPuF91h/9967gxaHJbg
X-Google-Smtp-Source: APXvYqy/7RryynS5OHcq/JKVXTbgyYgZXy5gP8GKE997v3Lr6cp2uyA6rl124zGMsvXTg7ScjIc4zA==
X-Received: by 2002:adf:f18b:: with SMTP id h11mr26251711wro.56.1580167071420;
        Mon, 27 Jan 2020 15:17:51 -0800 (PST)
Received: from [192.168.43.36] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id b67sm434474wmc.38.2020.01.27.15.17.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 15:17:50 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, Daurnimator <quae@daurnimator.com>
Cc:     io-uring@vger.kernel.org
References: <20200123231614.10850-1-axboe@kernel.dk>
 <CAEnbY+c34Uiguq=11eZ1F0z_VZopeBbw1g1gfn-S0Fb5wCaL5A@mail.gmail.com>
 <4917a761-6665-0aa2-0990-9122dfac007a@gmail.com>
 <694c2b6f-6b51-fd7b-751e-db87de90e490@kernel.dk>
 <a9fcf996-88ed-6bc4-f5ef-6ce4ed2253c5@gmail.com>
 <92e92002-f803-819a-5f5e-44cf09e63c9b@kernel.dk>
 <3b3b5e03-2c7e-aa00-c1fd-3af8b2620d5e@gmail.com>
 <1b24da2d-dd92-608e-27b6-b827a728e7ab@kernel.dk>
 <e15d7700-7d7b-521e-0e78-e8bff9013277@gmail.com>
 <c432d4e1-9cf0-d342-3d87-84bd731e07f3@kernel.dk>
 <18d3f936-c8d0-9bbb-6e9d-4c9ec579cfa4@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCHSET 0/4] Add support for shared io-wq backends
Message-ID: <d2db974d-cb40-36eb-c13d-e0c3713e7573@gmail.com>
Date:   Tue, 28 Jan 2020 02:17:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <18d3f936-c8d0-9bbb-6e9d-4c9ec579cfa4@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="tCq2iUGizhz3qeDSWq12OWmGJEeRDRoZh"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tCq2iUGizhz3qeDSWq12OWmGJEeRDRoZh
Content-Type: multipart/mixed; boundary="KPsMarNFUqVN3WhKb89N8LpyEQ4JeWbWH";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Daurnimator <quae@daurnimator.com>
Cc: io-uring@vger.kernel.org
Message-ID: <d2db974d-cb40-36eb-c13d-e0c3713e7573@gmail.com>
Subject: Re: [PATCHSET 0/4] Add support for shared io-wq backends
References: <20200123231614.10850-1-axboe@kernel.dk>
 <CAEnbY+c34Uiguq=11eZ1F0z_VZopeBbw1g1gfn-S0Fb5wCaL5A@mail.gmail.com>
 <4917a761-6665-0aa2-0990-9122dfac007a@gmail.com>
 <694c2b6f-6b51-fd7b-751e-db87de90e490@kernel.dk>
 <a9fcf996-88ed-6bc4-f5ef-6ce4ed2253c5@gmail.com>
 <92e92002-f803-819a-5f5e-44cf09e63c9b@kernel.dk>
 <3b3b5e03-2c7e-aa00-c1fd-3af8b2620d5e@gmail.com>
 <1b24da2d-dd92-608e-27b6-b827a728e7ab@kernel.dk>
 <e15d7700-7d7b-521e-0e78-e8bff9013277@gmail.com>
 <c432d4e1-9cf0-d342-3d87-84bd731e07f3@kernel.dk>
 <18d3f936-c8d0-9bbb-6e9d-4c9ec579cfa4@kernel.dk>
In-Reply-To: <18d3f936-c8d0-9bbb-6e9d-4c9ec579cfa4@kernel.dk>

--KPsMarNFUqVN3WhKb89N8LpyEQ4JeWbWH
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 28/01/2020 02:00, Jens Axboe wrote:
> On 1/27/20 3:40 PM, Jens Axboe wrote:
>> On 1/27/20 2:45 PM, Pavel Begunkov wrote:
>>> On 27/01/2020 23:33, Jens Axboe wrote:
>>>> On 1/27/20 7:07 AM, Pavel Begunkov wrote:
>>>>> On 1/27/2020 4:39 PM, Jens Axboe wrote:
>>>>>> On 1/27/20 6:29 AM, Pavel Begunkov wrote:
>>>>>>> On 1/26/2020 8:00 PM, Jens Axboe wrote:
>>>>>>>> On 1/26/20 8:11 AM, Pavel Begunkov wrote:
>>>>>>>>> On 1/26/2020 4:51 AM, Daurnimator wrote:
>>>>>>>>>> On Fri, 24 Jan 2020 at 10:16, Jens Axboe <axboe@kernel.dk> wro=
te:
>>>>>>> Ok. I can't promise it'll play handy for sharing. Though, you'll =
be out
>>>>>>> of space in struct io_uring_params soon anyway.
>>>>>>
>>>>>> I'm going to keep what we have for now, as I'm really not imaginin=
g a
>>>>>> lot more sharing - what else would we share? So let's not over-des=
ign
>>>>>> anything.
>>>>>>
>>>>> Fair enough. I prefer a ptr to an extendable struct, that will take=
 the
>>>>> last u64, when needed.
>>>>>
>>>>> However, it's still better to share through file descriptors. It's =
just
>>>>> not secure enough the way it's now.
>>>>
>>>> Is the file descriptor value really a good choice? We just had some
>>>> confusion on ring sharing across forks. Not sure using an fd value
>>>> is a sane "key" to use across processes.
>>>>
>>> As I see it, the problem with @mm is that uring is dead-bound to it.
>>> For example, a process can create and send uring (e.g. via socket),
>>> and then be killed. And that basically means
>>> 1. @mm of the process is locked just because of the sent uring
>>> instance.
>>> 2. a process may have an io_uring, which bound to @mm of another
>>> process, even though the layouts may be completely different.
>>>
>>> File descriptors are different here, because io_uring doesn't know
>>> about them, They are controlled by the userspace (send, dup, fork,
>>> etc), and don't sabotage all isolation work done in the kernel. A dir=
e
>>> example here is stealing io-wq from within a container, which is
>>> trivial with global self-made id. I would love to hear, if I am
>>> mistaken somewhere.
>>>
>>> Is there some better option?
>>
>> OK, so how about this:
>>
>> - We use the 'fd' as the lookup key. This makes it easy since we can
>>   just check if it's a io_uring instance or not, we don't need to do a=
ny
>>   tracking on the side. It also means that the application asking for
>>   sharing must already have some relationship to the process that
>>   created the ring.

Yeah, that's exactly the point.

>>
>> - mm/creds must be transferred through the work item. Any SQE done on
>>   behalf of io_uring_enter() directly already has that, if punted we
>>   must pass the creds and mm. This means we break the static setup of
>>   io_wq->mm/creds. It also means that we probably have to add that to
>>   io_wq_work, which kind of sucks, but...

ehh, juggling mm's... But don't have anything nicer myself.

> It'd fix Stefan's worry too.
>=20
>> I think with that we have a decent setup, that's also safe. I've dropp=
ed
>> the sharing patches for now, from the 5.6 tree.
>=20
> So one concern might be SQPOLL, it'll have to use the ctx creds and mm
> as usual. I guess that is ok.
>=20

OK. I'll send the patches for the first part now, and take a look at the =
second
one a bit latter if isn't done until then.


--=20
Pavel Begunkov


--KPsMarNFUqVN3WhKb89N8LpyEQ4JeWbWH--

--tCq2iUGizhz3qeDSWq12OWmGJEeRDRoZh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4vb3sACgkQWt5b1Glr
+6U3AQ//QGuv0mwOUrjey6XC16jIaBRM3J2qK+XNcYo24zej8lUdhDD53fNHiCo4
rOZdr78MyRxT3iZYtHSrKAWbo3qVfJRv+rJ+Lf6pfzdk5eeG0qOH4of/KuHEmrFK
1Fsc4GvdRZJik4s8IkD5pBTdiqaHb/E9eyb9cUoa4BT6X2nQ7d0adCZcpeUZ4GlI
eUjsvjKtohgjLQOIYrHwRfs2REI/1aCJnk/02u9CwA1oOBLbwt2yV86gHbGx3wCo
o1i5bUrcorqhEkImJgq/Gjh/gULYPGeOw39w8lqoyHOUr/N/GqHfZFJKi5pfmYLo
/X4MqX4P9uNEbKJp128ve2Q4Bk2BV0FsUpImIAEKXK4jKTPuGobZ98ek4cRWwe03
HO6rstPWBDPhe8OLKAXZL6slKJoFBTRzVfXOeBilDlTw1ZLwbohnw4q0LmOamxk+
Ul4SX+wR9cpSaEa4frgOMvNWcs3ozpOqWi1SyCR/hpTC/rUzyouum+kFvNUL4Lhs
OiCQXI61nI/8SqumjNU20iu9F9NqVCz+g2D6lj495SWEi3QRnIs1VQ77IKEHiayQ
krGMw8yLnVH8r4KYPEPTBmcOCT41UaUx+i0zG+YzOXufRMmLud72wDj5IBcaSc8a
C0eVjnMHzz5XGdigUttbZ7LczxdtOqe6lg99WC5I7bUkZNe4j0o=
=RGfI
-----END PGP SIGNATURE-----

--tCq2iUGizhz3qeDSWq12OWmGJEeRDRoZh--
