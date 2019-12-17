Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28A93123455
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 19:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbfLQSGI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 13:06:08 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37962 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727754AbfLQSGI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 13:06:08 -0500
Received: by mail-wm1-f66.google.com with SMTP id u2so4241456wmc.3;
        Tue, 17 Dec 2019 10:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=mmjUvTrGlgmg/mK8tJfpjSubmRW33zvn5B4Hr3L+8FI=;
        b=W+/QnBmVR0DGhULCYDT5/RELW2kiDUJEoDXqDDO+/FhkbPVcBlW12pyr5r8E1+ag0s
         La5fjueIlxQN364mVsjF9QWIfHUWxMsccZ23LFYyX58IYNhk722A22EiqC41yRg15pDv
         CA5slYfBVvbFbU5UuoPRf88WYibFEORR7CKCOHDpFtHC97i1mvfYefK1Gtprv1/wOkR+
         CTVFrDuExnWnx3RyczBWTnl+gaUPKui7zkUr8FtzM103iBkQQeX9DbTyeg9VifRYskeg
         DQ/l0DLu5nq3xAEa2dNBfK4uvZ3hDNW18GZOJFgkzAIaIJ2rNa0xg4lKqunXzBjjAsA9
         utJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=mmjUvTrGlgmg/mK8tJfpjSubmRW33zvn5B4Hr3L+8FI=;
        b=IOU1QE3E93it3k4eZr8wYs3yU1hNZ+UAwTQEszev8ot26vrLVphQcPbIu20Ip2roZX
         yUBLgL3CXu6tjq6rtyji/u5i0XhnYL8nS/xSKLsdI44Ykk/TrZmTXYf+A6B46v7CdWWT
         i/EQu9DMg7rV3+78NBWRxmpxgpoZcauaBQScVogrJYPvLuLZbmpOgcY2r/4EJBvThNie
         YpJDrZcneFKXmZB/P1RkHjeDLs/kS2BQuAX9lG3Ofor+pMiFQw4Bm4KX38NVKt0zMsc3
         UV0jcFPS7UAa2a5EGVQFkxbednGfL5iTrmAS7cpv1arYeIxSJGJxq4TfJF1H8DlEEWbr
         FiQw==
X-Gm-Message-State: APjAAAX5DYeHb1zf/canpwwMo6OBX8bySZmK1NwbAglauIuLLrYqJODV
        PjNNWvaqCnKw7FFd1H4QzMwBvBNT
X-Google-Smtp-Source: APXvYqxTH2I8kR1/MxKfyoOwMsyRR2zg3Uzk2p2RafpoPEsIz9Pp4nX5WwGskVqKfEM8Tmac2GGJPg==
X-Received: by 2002:a7b:c93a:: with SMTP id h26mr6812177wml.83.1576605965272;
        Tue, 17 Dec 2019 10:06:05 -0800 (PST)
Received: from [192.168.43.142] ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id m10sm26629648wrx.19.2019.12.17.10.06.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 10:06:04 -0800 (PST)
Subject: Re: [PATCH 3/3] io_uring: move *queue_link_head() from common path
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1576538176.git.asml.silence@gmail.com>
 <eda17f0736faff0876c580f1cd841b61c92d7e39.1576538176.git.asml.silence@gmail.com>
 <17f7900c-385f-0dfa-11bf-af99d080f894@gmail.com>
 <76917820-052d-9597-133d-424fee3edade@kernel.dk>
 <5d4af2f6-26a2-b241-5131-3a0155cbbf22@kernel.dk>
 <3b5100a7-2922-a9f2-e4e2-76252318959d@gmail.com>
 <7edd6631-326c-ac9c-7c5b-fa4bab3932d3@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <4f3f9b65-6e9f-b650-65b8-1e0844321697@gmail.com>
Date:   Tue, 17 Dec 2019 21:05:22 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <7edd6631-326c-ac9c-7c5b-fa4bab3932d3@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="mV0yv0PR5Hx77lVg0K9IxQ16N7dyYdSiF"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--mV0yv0PR5Hx77lVg0K9IxQ16N7dyYdSiF
Content-Type: multipart/mixed; boundary="Ta4G3Z5tSQJMt9IIrzMPhnypCQZhB7gX9";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <4f3f9b65-6e9f-b650-65b8-1e0844321697@gmail.com>
Subject: Re: [PATCH 3/3] io_uring: move *queue_link_head() from common path
References: <cover.1576538176.git.asml.silence@gmail.com>
 <eda17f0736faff0876c580f1cd841b61c92d7e39.1576538176.git.asml.silence@gmail.com>
 <17f7900c-385f-0dfa-11bf-af99d080f894@gmail.com>
 <76917820-052d-9597-133d-424fee3edade@kernel.dk>
 <5d4af2f6-26a2-b241-5131-3a0155cbbf22@kernel.dk>
 <3b5100a7-2922-a9f2-e4e2-76252318959d@gmail.com>
 <7edd6631-326c-ac9c-7c5b-fa4bab3932d3@kernel.dk>
In-Reply-To: <7edd6631-326c-ac9c-7c5b-fa4bab3932d3@kernel.dk>

--Ta4G3Z5tSQJMt9IIrzMPhnypCQZhB7gX9
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 17/12/2019 21:01, Jens Axboe wrote:
> On 12/17/19 10:52 AM, Pavel Begunkov wrote:
>> On 17/12/2019 20:37, Jens Axboe wrote:
>>> On 12/17/19 9:45 AM, Jens Axboe wrote:
>>>> On 12/16/19 4:38 PM, Pavel Begunkov wrote:
>>>>> On 17/12/2019 02:22, Pavel Begunkov wrote:
>>>>>> Move io_queue_link_head() to links handling code in io_submit_sqe(=
),
>>>>>> so it wouldn't need extra checks and would have better data locali=
ty.
>>>>>>
>>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>>> ---
>>>>>>  fs/io_uring.c | 32 ++++++++++++++------------------
>>>>>>  1 file changed, 14 insertions(+), 18 deletions(-)
>>>>>>
>>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>>> index bac9e711e38d..a880ed1409cb 100644
>>>>>> --- a/fs/io_uring.c
>>>>>> +++ b/fs/io_uring.c
>>>>>> @@ -3373,13 +3373,15 @@ static bool io_submit_sqe(struct io_kiocb =
*req, struct io_submit_state *state,
>>>>>>  			  struct io_kiocb **link)
>>>>>>  {
>>>>>>  	struct io_ring_ctx *ctx =3D req->ctx;
>>>>>> +	unsigned int sqe_flags;
>>>>>>  	int ret;
>>>>>> =20
>>>>>> +	sqe_flags =3D READ_ONCE(req->sqe->flags);
>>>>>>  	req->user_data =3D READ_ONCE(req->sqe->user_data);
>>>>>>  	trace_io_uring_submit_sqe(ctx, req->user_data, true, req->in_asy=
nc);
>>>>>> =20
>>>>>>  	/* enforce forwards compatibility on users */
>>>>>> -	if (unlikely(req->sqe->flags & ~SQE_VALID_FLAGS)) {
>>>>>> +	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS)) {
>>>>>>  		ret =3D -EINVAL;
>>>>>>  		goto err_req;
>>>>>>  	}
>>>>>> @@ -3402,10 +3404,10 @@ static bool io_submit_sqe(struct io_kiocb =
*req, struct io_submit_state *state,
>>>>>>  	if (*link) {
>>>>>>  		struct io_kiocb *head =3D *link;
>>>>>> =20
>>>>>> -		if (req->sqe->flags & IOSQE_IO_DRAIN)
>>>>>> +		if (sqe_flags & IOSQE_IO_DRAIN)
>>>>>>  			head->flags |=3D REQ_F_DRAIN_LINK | REQ_F_IO_DRAIN;
>>>>>> =20
>>>>>> -		if (req->sqe->flags & IOSQE_IO_HARDLINK)
>>>>>> +		if (sqe_flags & IOSQE_IO_HARDLINK)
>>>>>>  			req->flags |=3D REQ_F_HARDLINK;
>>>>>> =20
>>>>>>  		if (io_alloc_async_ctx(req)) {
>>>>>> @@ -3421,9 +3423,15 @@ static bool io_submit_sqe(struct io_kiocb *=
req, struct io_submit_state *state,
>>>>>>  		}
>>>>>>  		trace_io_uring_link(ctx, req, head);
>>>>>>  		list_add_tail(&req->link_list, &head->link_list);
>>>>>> -	} else if (req->sqe->flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) =
{
>>>>>> +
>>>>>> +		/* last request of a link, enqueue the link */
>>>>>> +		if (!(sqe_flags & IOSQE_IO_LINK)) {
>>>>>
>>>>> This looks suspicious (as well as in the current revision). Returni=
ng back
>>>>> to my questions a few days ago can sqe->flags have IOSQE_IO_HARDLIN=
K, but not
>>>>> IOSQE_IO_LINK? I don't find any check.
>>>>>
>>>>> In other words, should it be as follows?
>>>>> !(sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK))
>>>>
>>>> Yeah, I think that should check for both. I'm fine with either appro=
ach
>>>> in general:
>>>>
>>>> - IOSQE_IO_HARDLINK must have IOSQE_IO_LINK set
>>>>
>>>> or
>>>>
>>>> - IOSQE_IO_HARDLINK implies IOSQE_IO_LINK
>>>>
>>>> Seems like the former is easier to verify in terms of functionality,=

>>>> since we can rest easy if we check this early and -EINVAL if that is=
n't
>>>> the case.
>>>>
>>>> What do you think?
>>>
>>> If you agree, want to send in a patch for that for 5.5? Then I can re=
spin
>>> for-5.6/io_uring on top of that, and we can apply your cleanups there=
=2E
>>>
>> Yes, that's the idea. Already got a patch, if you haven't done it yet.=

>=20
> I haven't.
>=20
>> Just was thinking, whether to add a check for not setting both flags
>> at the same moment in the "imply" case. Would give us 1 state in 2 bit=
s
>> for future use.
>=20
> Not sure I follow what you're saying here, can you elaborate?
>=20

Sure

#define IOSQE_IO_LINK		(1U << 2)	/* links next sqe */
#define IOSQE_IO_HARDLINK	(1U << 3)	/* like LINK, but stronger */

That's 2 consequent bits, so 4 states:
0,0 -> not a link
1,0 -> common link
0,1 -> hard link
1,1 -> reserved, space for another link-quirk type

But that would require additional check, i.e.

if (flags&(LINK|HARDLINK) =3D=3D (LINK|HARDLINK)) ...


--=20
Pavel Begunkov


--Ta4G3Z5tSQJMt9IIrzMPhnypCQZhB7gX9--

--mV0yv0PR5Hx77lVg0K9IxQ16N7dyYdSiF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl35GOIACgkQWt5b1Glr
+6VSxw//Sl7VRymYnHXAY1x8MgEzO335Jdu/kdda0vgREqNK342DvoEKdIYRELH3
jbsrscjnE/UrHX7itTewSF1vIVq+u2XweT7buNdMsSNT9Q1wgEGR2nAkP0UoKc9Y
OqxY1uMC9pwFIMI/Nxt4FYwSKM8K4wHCB5UAiTZa/JGUX524WMD6rlZeQbAeV1z6
h1Uc4juLrdHIT1YqdoPTo+9/ffpb+JHW998X+ozignfN00zq/fN48le0YjervjtS
GZsLq9/fRorRbXovUxav6Vh3007sFcnTLB20KgwLmHhujlH5DIYomyr7r/N3QpIR
dMxm2arl4C2UporRH54AxPeUv2CwjaZjVOCOSU44VS6FgskSRm4RmxTp+asSIFQD
XbZUODHElyJBicVvBkJrE+z9FEFN6L+5KpA0jGSJaLjSk1+lGsERUAol/ykJYfWe
rVJbaYugck9PHhi55NO55KsUdlaDnz5wx8cAx6oFBnUxHDQcdU2PAsYMup19/zQV
dUxN8WGEFb04OiVYO4FR+5tKaqbaG8EQAldTXuiLuBxghNTUlBV1q0HW7KoHR/w8
tp4OiVQ6ADT7NgtkU+VHFqymvkG5m3ZAiBfruAzsmVzdLfQoQdTJNHEiTCsB/Wrx
PMp33ffZ9fKBzqY7A/gpnGdPoCz7QiAduAIkXlKxc+0Iv6bY5ao=
=7SRS
-----END PGP SIGNATURE-----

--mV0yv0PR5Hx77lVg0K9IxQ16N7dyYdSiF--
