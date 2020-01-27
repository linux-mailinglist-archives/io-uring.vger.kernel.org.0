Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95A2E14AC98
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2020 00:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbgA0X0J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jan 2020 18:26:09 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36788 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgA0X0I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jan 2020 18:26:08 -0500
Received: by mail-wm1-f67.google.com with SMTP id p17so515540wma.1
        for <io-uring@vger.kernel.org>; Mon, 27 Jan 2020 15:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=DOdAvp5pDp8G/mCObv7kQsMmVsyIxlGempVXU75m1d4=;
        b=YU4bMp+U0Bod1NhZIh+EU8GCEgYuKUKbKNHYLPbw3CUO7QyIbjamnzNjdHs5Rgd0dA
         3KqgMEzSIveJ+UVJ2w7Lhq88CtXSBz2zGdMH2SMQ3+Errv1TizOQaYKltLjp+QGe06d6
         CqkQu4V9VwnKcW17cyxyYgMMABVjjZQwJopLn6qdMiOtPFUDmXT1W5iV/ri+wZJJALzm
         nnc+/7Rwli+Dq++skZngZa6yNyshL+6FQx42OJ3X2/0506u1K8mUXgUJQk5VDdW3lzym
         1O3nrkhRftpjliO7czP5qdzZVvb9wtcV835erEps0+4IFbnDKfW0aCxob0QJ8Oqbt1kZ
         injw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=DOdAvp5pDp8G/mCObv7kQsMmVsyIxlGempVXU75m1d4=;
        b=aFla006X7VCRycfJEPCnS1vd6IKq3ETEkrtlWNF/KwyB9dA+Eb9vzIW9mveev+uE41
         QPORCrMx4yVc2gXKrnkqzZboHlDeo36SkZHpJxPrUgea0FtiAYX8ja9q5aIyjoOBZNF7
         c6mC5kSAvs3FdwIPaEZaeOb5juTYHQWb6yQqFy5Q9WrMYoouMLIMYpKmzUxyTKoQgpBt
         TI5CXh2kg/AAo3sFaPPgXMU/fhcsBjkv1wHwyrvL7TcIEy6srOLW1y2/7vWMEZyaZXMg
         dLvd2xoaD11ld6cYaFJHkEwlp2uZ82KVhYQ8JoxAePK+niU7eMDS3QU10fqt1zTtVZs2
         S5Ww==
X-Gm-Message-State: APjAAAXyiF5YL45rYGuVrCRZZ6B9gjucbiVqduqPPSWuTxbTybgnSe4i
        6R46cmgZETozwikxiBNrvmwLIL5n
X-Google-Smtp-Source: APXvYqwg/5J38m/Iq/YYXRZmDy5l0EXXwvJgTYypLzRGMkYiH9TxSwy9OCRDIjh4oONJYP+IOlnl5Q==
X-Received: by 2002:a1c:113:: with SMTP id 19mr1063605wmb.95.1580167564641;
        Mon, 27 Jan 2020 15:26:04 -0800 (PST)
Received: from [192.168.43.36] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id v8sm22606596wrw.2.2020.01.27.15.26.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 15:26:04 -0800 (PST)
Subject: Re: [PATCHSET 0/4] Add support for shared io-wq backends
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
 <d2db974d-cb40-36eb-c13d-e0c3713e7573@gmail.com>
 <fad41959-e8e6-ff2b-47c3-528edc6009df@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <adcb5842-34c8-a433-6ee3-b160fcb24473@gmail.com>
Date:   Tue, 28 Jan 2020 02:25:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <fad41959-e8e6-ff2b-47c3-528edc6009df@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="T0MF5BZwl5ZT8AL2SQYzmv3ONdfC0o9VA"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--T0MF5BZwl5ZT8AL2SQYzmv3ONdfC0o9VA
Content-Type: multipart/mixed; boundary="al2Ov6Caw02o2ygydK5VkqFFVIy7hSNpB";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Daurnimator <quae@daurnimator.com>
Cc: io-uring@vger.kernel.org
Message-ID: <adcb5842-34c8-a433-6ee3-b160fcb24473@gmail.com>
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
 <d2db974d-cb40-36eb-c13d-e0c3713e7573@gmail.com>
 <fad41959-e8e6-ff2b-47c3-528edc6009df@kernel.dk>
In-Reply-To: <fad41959-e8e6-ff2b-47c3-528edc6009df@kernel.dk>

--al2Ov6Caw02o2ygydK5VkqFFVIy7hSNpB
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 28/01/2020 02:23, Jens Axboe wrote:
> On 1/27/20 4:17 PM, Pavel Begunkov wrote:
>> On 28/01/2020 02:00, Jens Axboe wrote:
>>> On 1/27/20 3:40 PM, Jens Axboe wrote:
>>>> On 1/27/20 2:45 PM, Pavel Begunkov wrote:
>>>>> On 27/01/2020 23:33, Jens Axboe wrote:
>>>>>> On 1/27/20 7:07 AM, Pavel Begunkov wrote:
>>>>>>> On 1/27/2020 4:39 PM, Jens Axboe wrote:
>>>>>>>> On 1/27/20 6:29 AM, Pavel Begunkov wrote:
>>>>>>>>> On 1/26/2020 8:00 PM, Jens Axboe wrote:
>>>>>>>>>> On 1/26/20 8:11 AM, Pavel Begunkov wrote:
>>>>>>>>>>> On 1/26/2020 4:51 AM, Daurnimator wrote:
>>>>>>>>>>>> On Fri, 24 Jan 2020 at 10:16, Jens Axboe <axboe@kernel.dk> w=
rote:
>>>>>>>>> Ok. I can't promise it'll play handy for sharing. Though, you'l=
l be out
>>>>>>>>> of space in struct io_uring_params soon anyway.
>>>>>>>>
>>>>>>>> I'm going to keep what we have for now, as I'm really not imagin=
ing a
>>>>>>>> lot more sharing - what else would we share? So let's not over-d=
esign
>>>>>>>> anything.
>>>>>>>>
>>>>>>> Fair enough. I prefer a ptr to an extendable struct, that will ta=
ke the
>>>>>>> last u64, when needed.
>>>>>>>
>>>>>>> However, it's still better to share through file descriptors. It'=
s just
>>>>>>> not secure enough the way it's now.
>>>>>>
>>>>>> Is the file descriptor value really a good choice? We just had som=
e
>>>>>> confusion on ring sharing across forks. Not sure using an fd value=

>>>>>> is a sane "key" to use across processes.
>>>>>>
>>>>> As I see it, the problem with @mm is that uring is dead-bound to it=
=2E
>>>>> For example, a process can create and send uring (e.g. via socket),=

>>>>> and then be killed. And that basically means
>>>>> 1. @mm of the process is locked just because of the sent uring
>>>>> instance.
>>>>> 2. a process may have an io_uring, which bound to @mm of another
>>>>> process, even though the layouts may be completely different.
>>>>>
>>>>> File descriptors are different here, because io_uring doesn't know
>>>>> about them, They are controlled by the userspace (send, dup, fork,
>>>>> etc), and don't sabotage all isolation work done in the kernel. A d=
ire
>>>>> example here is stealing io-wq from within a container, which is
>>>>> trivial with global self-made id. I would love to hear, if I am
>>>>> mistaken somewhere.
>>>>>
>>>>> Is there some better option?
>>>>
>>>> OK, so how about this:
>>>>
>>>> - We use the 'fd' as the lookup key. This makes it easy since we can=

>>>>   just check if it's a io_uring instance or not, we don't need to do=
 any
>>>>   tracking on the side. It also means that the application asking fo=
r
>>>>   sharing must already have some relationship to the process that
>>>>   created the ring.
>>
>> Yeah, that's exactly the point.
>>
>>>>
>>>> - mm/creds must be transferred through the work item. Any SQE done o=
n
>>>>   behalf of io_uring_enter() directly already has that, if punted we=

>>>>   must pass the creds and mm. This means we break the static setup o=
f
>>>>   io_wq->mm/creds. It also means that we probably have to add that t=
o
>>>>   io_wq_work, which kind of sucks, but...
>>
>> ehh, juggling mm's... But don't have anything nicer myself.
>=20
> We already do juggle mm's, this is no different. A worker potentially
> retain the mm across works if they are the same.
>=20
>>> It'd fix Stefan's worry too.
>>>
>>>> I think with that we have a decent setup, that's also safe. I've dro=
pped
>>>> the sharing patches for now, from the 5.6 tree.
>>>
>>> So one concern might be SQPOLL, it'll have to use the ctx creds and m=
m
>>> as usual. I guess that is ok.
>>>
>>
>> OK. I'll send the patches for the first part now, and take a look at
>> the second one a bit latter if isn't done until then.
>=20
> Hang on a second, I'm doing the mm and creds bits right now. I'll push
> that to a branch, if you want to do the actual fd stuff on top of that,=

> that would be great.
>=20
Sure, should be trivially mergeable.

--=20
Pavel Begunkov


--al2Ov6Caw02o2ygydK5VkqFFVIy7hSNpB--

--T0MF5BZwl5ZT8AL2SQYzmv3ONdfC0o9VA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4vcWkACgkQWt5b1Glr
+6VZ9A//eMgEzfJa97oWWJlwiYCTuF+JofkP5Y7lBxc/NosSWdh8sUWs1Kle0TUp
I5lb015xJRcjl+wJC7dSg95PuAWw6+0DrsvFkvdRMQw2NYtc+T2EIEGuqTw/qzpA
EB2cgWhmEeTTj3WvUIhyCNJ4lui/Zgp7nfkHwaoHTWI/old9opvoesRLcS+f37k3
b7Ks8iEyFtvI34k7gXBHtfsunlCPd/QUD1iAHAZG7fUGGaHPZC+hFgeA1q/Zb2aK
a8hIvFPaj7rrw2Ta1VEGM0iPantvNunRX7Yd2Jp96bZLrLg0jZLyJ0z2GgzyLRC1
QSccJRD1sMpRwjjvA84WZim9mFRg+WWRBWMVpuArzmyhWjOGR6DA4YCBwWv6LdQj
WdoBEQotFHRXz7/P/HCvf6YDKIqqc8PHelFKjDAgVbse6lqm7r/TpcUCZUYSTrKT
hLnqnK6p6s6+0hx8VZY6VeB9tAR+JQWL3xC37zsbGlslbawqpQ1bwRAvOZeURG36
rECz7fRKSQishJCTnHM/s6q4N9KMP0JayXh/u5vfF59EyOCbji5DeQcugK7hNxiG
0Qdg5yxXeIA93UQ6oFWwBOxu2KiDhojL+zxvlrF1DDawgukp3Zcd2ylLs0g4jYFr
Nga/CaDVftLgTE8QOHhqzIMWEHPsriobEzoG3HomMj/X0esNdVc=
=kIcL
-----END PGP SIGNATURE-----

--T0MF5BZwl5ZT8AL2SQYzmv3ONdfC0o9VA--
