Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34DAB16F158
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 22:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbgBYVp4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 16:45:56 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33536 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgBYVp4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 16:45:56 -0500
Received: by mail-wm1-f65.google.com with SMTP id m10so3114723wmc.0
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 13:45:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=eN9WopeSfVb+Vfqw7V7VeffoZknyT8NWLU9rS/nHVvA=;
        b=BzXrUx0uYg0GLnyOqRO8U/N3gbPxVr/JwzzxLOQRupjb5Ikl38u3//uqVwSTwAppRy
         KqZ3UkuCk1xJVZwf+6bP0Qpz3cxSQWwbw9Qcjda9H7Kr1ARZ1XBz7UyTo1JHfv8zsbLp
         RlgKji0mlY9laUSRkyATxad9TSZL9brvm3QunZEsATQthDGzCH0Sp/ebUQbvpGDwMdsV
         NgP7NuyJQGZI5MeCHWYDizfV3o/9WAowe/9X2zC0vRzkwi67hSSqKMkRpz0HbRWV6sVp
         JH4oJCpJKPv7Hqi/6P99A/GCM2AFXmLln2z2TP76WpUTE9fzj6E7BDxTWl7oJ73+XYPd
         h4hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=eN9WopeSfVb+Vfqw7V7VeffoZknyT8NWLU9rS/nHVvA=;
        b=WqxlZVz31Gw4fiNnKnSDP5rWEuYc4InEQP9TUjJ4uDtmhlSdLgjEwdvYZNXCAfDKtj
         3KvRgssF2saDv4PjydGh/BxJ+NBY0xhHxXZ2/heibWi03j+06uFGdylHpeXkX8GSpTYY
         /IV6mXdnahdzEy681IR/ITjQQJ6jWr4I3PBsE7033PXdVqfLs6siUNN3SOnwSeJxTrFJ
         42WctuA0hca6Vw0z29DC4tqNSbTxgX0+yn7RVDL+FNjcLf/4he1lbkNMwDFXleZBQek1
         0hoTBr1LI4B+1LssKHQMfcj4lA8t9o+MyTSL04wQxZgPOpS1cJhzButMRKQq2F1Mxsn2
         iFeg==
X-Gm-Message-State: APjAAAVzJlw3gno4wY2pjQcGAHgwPAQNSMnM+c9Dc4zAiUAr2V6LrYeJ
        S7DXvA1uu5zJLRAmfS60l4w2egTc
X-Google-Smtp-Source: APXvYqy6OB2dRZlxChAfbljH7crTMB1T7UlEuXy8jbgJhA0VN4+9FHir7aGDi0PODEQSW9nJC6yE0w==
X-Received: by 2002:a7b:c958:: with SMTP id i24mr1215775wml.180.1582667152594;
        Tue, 25 Feb 2020 13:45:52 -0800 (PST)
Received: from [192.168.43.62] ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id l8sm27912wmj.2.2020.02.25.13.45.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 13:45:51 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <1c5f074e-22dd-095a-6be7-730c81eeb1b1@kernel.dk>
 <82423419-1c14-418e-8085-2d8b902b0a2d@gmail.com>
 <71add82f-9d25-b879-5fe5-8e2a4eb26877@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH] io_uring: pick up link work on submit reference drop
Message-ID: <f5cb2e96-b30f-eec9-7a0b-68bdfcb0b8e2@gmail.com>
Date:   Wed, 26 Feb 2020 00:45:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <71add82f-9d25-b879-5fe5-8e2a4eb26877@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="53pcYiuSQl4T7QRJYALhp9OlRJOKSSj4H"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--53pcYiuSQl4T7QRJYALhp9OlRJOKSSj4H
Content-Type: multipart/mixed; boundary="NyH80KWMHYOcHLy8BGQwKUtll30nANGV8";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Message-ID: <f5cb2e96-b30f-eec9-7a0b-68bdfcb0b8e2@gmail.com>
Subject: Re: [PATCH] io_uring: pick up link work on submit reference drop
References: <1c5f074e-22dd-095a-6be7-730c81eeb1b1@kernel.dk>
 <82423419-1c14-418e-8085-2d8b902b0a2d@gmail.com>
 <71add82f-9d25-b879-5fe5-8e2a4eb26877@kernel.dk>
In-Reply-To: <71add82f-9d25-b879-5fe5-8e2a4eb26877@kernel.dk>

--NyH80KWMHYOcHLy8BGQwKUtll30nANGV8
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 26/02/2020 00:25, Jens Axboe wrote:
> On 2/25/20 2:22 PM, Pavel Begunkov wrote:
>> On 25/02/2020 23:27, Jens Axboe wrote:
>>> If work completes inline, then we should pick up a dependent link ite=
m
>>> in __io_queue_sqe() as well. If we don't do so, we're forced to go as=
ync
>>> with that item, which is suboptimal.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>
>>> ---
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index ffd9bfa84d86..160cf1b0f478 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -4531,8 +4531,15 @@ static void io_wq_submit_work(struct io_wq_wor=
k **workptr)
>>>  		} while (1);
>>>  	}
>>> =20
>>> -	/* drop submission reference */
>>> -	io_put_req(req);
>>> +	/*
>>> +	 * Drop submission reference. In case the handler already dropped t=
he
>>> +	 * completion reference, then it didn't pick up any potential link
>>> +	 * work. If 'nxt' isn't set, try and do that here.
>>> +	 */
>>> +	if (nxt)
>>
>> It can't even get here, because of the submission ref, isn't it? would=
 the
>> following do?
>>
>> -	io_put_req(req);
>> +	io_put_req_find_next(req, &nxt);
>=20
> I don't think it can, let me make that change. And test.
>=20
>> BTW, as I mentioned before, it appears to me, we don't even need compl=
etion ref
>> as it always pinned by the submission ref. I'll resurrect the patches =
doing
>> that, but after your poll work will land.
>=20
> We absolutely do need two references, unfortunately. Otherwise we could=
 complete
> the io_kiocb deep down the stack through the callback.

And I need your knowledge here to not make mistakes :)
I remember the conversation about the necessity of submission ref, that's=
 to
make sure it won't be killed in the middle of block layer, etc. But what =
about
removing the completion ref then?

E.g. io_read(), as I see all its work is bound by lifetime of io_read() c=
all,
so it's basically synchronous from the caller perspective. In other words=
, it
can't complete req after it returned from io_read(). And that would mean =
it's
save to have only submission ref after dealing with poll and other edge c=
ases.

Do I miss something?

--=20
Pavel Begunkov


--NyH80KWMHYOcHLy8BGQwKUtll30nANGV8--

--53pcYiuSQl4T7QRJYALhp9OlRJOKSSj4H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5VlWIACgkQWt5b1Glr
+6XmUQ//bMEv1GDaVkn759dZFFQNXq3oED4zStzb2b0ZCLr2TANdABI4PD/99T7I
n4hiB7LaVKgK/rRVg7+L7byIgXQUmxTW6ifE2T0xhQ71G3tSTJsU/v9vlPtVqyhW
kK7eSS91c0e8vfhs2xdLwT6N2HvPETQBCaoXcsh1IyRLWb9NmqOEhqA1ehHV/eE2
FCNf/3Cbpe0lwRCqynL1iiW7vVNf5Dl4KzQfaai7p/2eKpg9BW+0iWxkJoyvw1L4
Vr9x9FOGLnSmEgdFTH5ah+HKnr/qqU3x30oymfhGGKDRQRUClivyB0qB2R8NlAia
5uGamIUvJ3rPzwPTt1JW2Dzl7Z/WIKLA6Em5qVHnFOH5nm9MRMWtokDl7T49gW4Z
FPO1FR9eDIy5d8ufXwX+96hGIa5oPPmdLAAI9jEPMnq0o35JD4u0bCCAjPSnOIx8
n15n5K+n+Mj3Rlys894hozp6enKxQrR7PZJEkDBr+D/47aXAL8D0jyR1vRGvXPYZ
USdxHISoVIZN1AVGvg4NwaCTmS9uaqxeYwjXcT7JdMfIR2ovVKJ3rt24sZfvlQbk
jn0VW5Kl5AWR/OkZt7A9e0EeuVX8EqhN1hRMsx2UmJC+4GD+sXBoUkgw0PhIjbZY
BLTcMZiOEpSMOuxz5Vko4v114l1elfOqOb3JFNTeOOMWZKm8++I=
=phwr
-----END PGP SIGNATURE-----

--53pcYiuSQl4T7QRJYALhp9OlRJOKSSj4H--
