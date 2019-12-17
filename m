Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCB511233ED
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 18:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbfLQRwp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 12:52:45 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40468 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbfLQRwp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 12:52:45 -0500
Received: by mail-wr1-f66.google.com with SMTP id c14so12295011wrn.7;
        Tue, 17 Dec 2019 09:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=bxQc8tRF3/Vy+uj92aLlNhia59sGXyoY0/aBb0b6vh4=;
        b=uslXfJIsZQfehPXsKNxnm80alnX6Y2xJwrkJcjebM9Eum/GPeFeIy5eg8dBUBz2eSk
         vv41EwOm8mjXqQMlMSKA1iLjz+qoEeuXK12Fpjp0QeQHY46tH2G1P+CKbpFaZ4FYOvnL
         Aj7PqrkmYitmPhPLiUzW9lw2QydIxQ/smI2MGoYyYoE9Bw0Uo2e5d6Rrrd1ZnMXdVJJm
         fxjBjSjxJTJtu6DxNDosT+I20DAU1vkR+qzmLHypA8pUbEi/jITxKVDqymUXERGu7wab
         xqelamfKQsuEYndl4YUmviPAQYQnJymLo0VyH97BX+gr30eDvWGZh90btPrKmpCoZj+S
         bcCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=bxQc8tRF3/Vy+uj92aLlNhia59sGXyoY0/aBb0b6vh4=;
        b=hhEkBw/TdDGIb2H+rLCMUq8eZSLkpQymsoz+in20O7ik/ElGJz1Hhcbr4zxyU+JHky
         fwyhcSrV1Vq+uTZP7DEO8nS///hPk2j6nhIRecF9Dx8tq3BALI6ohWZCN/FLYGs3+lJa
         8MvFs/dZDFoI1VWY3BQjqqako+6RKGP39GRzMchMfLSl9OC55SLCCDdVCzEc0fw5X6AE
         LS8H0cljhjN/XS92e0fmvQOtd/BXqm9rth5d52cFbEa+DxaSixcSkNZ3YZq5IbjgSzZw
         VVtqKuejhMmyOQymCq4jKrQNh97DyYAQQztyaiH7+M06+v5cN37dFJ2KjnZjdhVGbXhc
         4vFg==
X-Gm-Message-State: APjAAAXHbtzS1UinhCwLseVLAwcrZfaXVjBAfWzd948cwExf5SHB00fu
        zRsG9TcxZ94034JLjQSoRYC6zLPL
X-Google-Smtp-Source: APXvYqy8uxNgIz1OftygsYwAaCS2SsuQp2cg2vdWTMtEolWnUakc3E8RJu0MjiYQw1OEDBY5eGPfzA==
X-Received: by 2002:a5d:55d1:: with SMTP id i17mr37582711wrw.165.1576605161836;
        Tue, 17 Dec 2019 09:52:41 -0800 (PST)
Received: from [192.168.43.142] ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id o16sm3903263wmc.18.2019.12.17.09.52.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2019 09:52:41 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1576538176.git.asml.silence@gmail.com>
 <eda17f0736faff0876c580f1cd841b61c92d7e39.1576538176.git.asml.silence@gmail.com>
 <17f7900c-385f-0dfa-11bf-af99d080f894@gmail.com>
 <76917820-052d-9597-133d-424fee3edade@kernel.dk>
 <5d4af2f6-26a2-b241-5131-3a0155cbbf22@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 3/3] io_uring: move *queue_link_head() from common path
Message-ID: <3b5100a7-2922-a9f2-e4e2-76252318959d@gmail.com>
Date:   Tue, 17 Dec 2019 20:52:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <5d4af2f6-26a2-b241-5131-3a0155cbbf22@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="T7Yvq6wRcCnY2AOcE3cmUZMbLwgNolNvd"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--T7Yvq6wRcCnY2AOcE3cmUZMbLwgNolNvd
Content-Type: multipart/mixed; boundary="mXySBXItv7iyFXgIaS2oIyByOXi04M0Qs";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <3b5100a7-2922-a9f2-e4e2-76252318959d@gmail.com>
Subject: Re: [PATCH 3/3] io_uring: move *queue_link_head() from common path
References: <cover.1576538176.git.asml.silence@gmail.com>
 <eda17f0736faff0876c580f1cd841b61c92d7e39.1576538176.git.asml.silence@gmail.com>
 <17f7900c-385f-0dfa-11bf-af99d080f894@gmail.com>
 <76917820-052d-9597-133d-424fee3edade@kernel.dk>
 <5d4af2f6-26a2-b241-5131-3a0155cbbf22@kernel.dk>
In-Reply-To: <5d4af2f6-26a2-b241-5131-3a0155cbbf22@kernel.dk>

--mXySBXItv7iyFXgIaS2oIyByOXi04M0Qs
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 17/12/2019 20:37, Jens Axboe wrote:
> On 12/17/19 9:45 AM, Jens Axboe wrote:
>> On 12/16/19 4:38 PM, Pavel Begunkov wrote:
>>> On 17/12/2019 02:22, Pavel Begunkov wrote:
>>>> Move io_queue_link_head() to links handling code in io_submit_sqe(),=

>>>> so it wouldn't need extra checks and would have better data locality=
=2E
>>>>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>>>  fs/io_uring.c | 32 ++++++++++++++------------------
>>>>  1 file changed, 14 insertions(+), 18 deletions(-)
>>>>
>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>> index bac9e711e38d..a880ed1409cb 100644
>>>> --- a/fs/io_uring.c
>>>> +++ b/fs/io_uring.c
>>>> @@ -3373,13 +3373,15 @@ static bool io_submit_sqe(struct io_kiocb *r=
eq, struct io_submit_state *state,
>>>>  			  struct io_kiocb **link)
>>>>  {
>>>>  	struct io_ring_ctx *ctx =3D req->ctx;
>>>> +	unsigned int sqe_flags;
>>>>  	int ret;
>>>> =20
>>>> +	sqe_flags =3D READ_ONCE(req->sqe->flags);
>>>>  	req->user_data =3D READ_ONCE(req->sqe->user_data);
>>>>  	trace_io_uring_submit_sqe(ctx, req->user_data, true, req->in_async=
);
>>>> =20
>>>>  	/* enforce forwards compatibility on users */
>>>> -	if (unlikely(req->sqe->flags & ~SQE_VALID_FLAGS)) {
>>>> +	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS)) {
>>>>  		ret =3D -EINVAL;
>>>>  		goto err_req;
>>>>  	}
>>>> @@ -3402,10 +3404,10 @@ static bool io_submit_sqe(struct io_kiocb *r=
eq, struct io_submit_state *state,
>>>>  	if (*link) {
>>>>  		struct io_kiocb *head =3D *link;
>>>> =20
>>>> -		if (req->sqe->flags & IOSQE_IO_DRAIN)
>>>> +		if (sqe_flags & IOSQE_IO_DRAIN)
>>>>  			head->flags |=3D REQ_F_DRAIN_LINK | REQ_F_IO_DRAIN;
>>>> =20
>>>> -		if (req->sqe->flags & IOSQE_IO_HARDLINK)
>>>> +		if (sqe_flags & IOSQE_IO_HARDLINK)
>>>>  			req->flags |=3D REQ_F_HARDLINK;
>>>> =20
>>>>  		if (io_alloc_async_ctx(req)) {
>>>> @@ -3421,9 +3423,15 @@ static bool io_submit_sqe(struct io_kiocb *re=
q, struct io_submit_state *state,
>>>>  		}
>>>>  		trace_io_uring_link(ctx, req, head);
>>>>  		list_add_tail(&req->link_list, &head->link_list);
>>>> -	} else if (req->sqe->flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
>>>> +
>>>> +		/* last request of a link, enqueue the link */
>>>> +		if (!(sqe_flags & IOSQE_IO_LINK)) {
>>>
>>> This looks suspicious (as well as in the current revision). Returning=
 back
>>> to my questions a few days ago can sqe->flags have IOSQE_IO_HARDLINK,=
 but not
>>> IOSQE_IO_LINK? I don't find any check.
>>>
>>> In other words, should it be as follows?
>>> !(sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK))
>>
>> Yeah, I think that should check for both. I'm fine with either approac=
h
>> in general:
>>
>> - IOSQE_IO_HARDLINK must have IOSQE_IO_LINK set
>>
>> or
>>
>> - IOSQE_IO_HARDLINK implies IOSQE_IO_LINK
>>
>> Seems like the former is easier to verify in terms of functionality,
>> since we can rest easy if we check this early and -EINVAL if that isn'=
t
>> the case.
>>
>> What do you think?
>=20
> If you agree, want to send in a patch for that for 5.5? Then I can resp=
in
> for-5.6/io_uring on top of that, and we can apply your cleanups there.
>=20
Yes, that's the idea. Already got a patch, if you haven't done it yet.

Just was thinking, whether to add a check for not setting both flags
at the same moment in the "imply" case. Would give us 1 state in 2 bits
for future use.

--=20
Pavel Begunkov


--mXySBXItv7iyFXgIaS2oIyByOXi04M0Qs--

--T7Yvq6wRcCnY2AOcE3cmUZMbLwgNolNvd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl35FdMACgkQWt5b1Glr
+6WrYA/+J8Ym1qVElDNgFQkxDNdTWjfCuKWNQbigdI+jaKMRuup49skZkF6SHqWE
tF4Kv4ONQjEfrMogwUgn35T/vuxYqAN5+7z1Q+5oWgqdQXeSx8ccXzcmY9C6A77F
Pj4h/IoWNgT7KkP3waimdICIZ1wLEALuA6ROfqvt9V543XXPlRZGcZlGf090tY3A
JPgLjyRJoWgwVMSSkzGlbJFdx51fz+ghZ1Z0nctu3o8vI1wBUqZ0EU9NoxNelLf6
nX5gSRZ5db8Qxg04Me4at8AVVkE0fBouWMQpi42pn6C1QtL/DFnLE79GIWZNvSTw
Hfa51OBBoTjsxwKPq1uAaqpJRT4qGBjMDPw2zSmntMhPJ3PD5ojhzEXe2HwWv7dT
b4gbv0HIYI43S+zFCYorR1foEJ5utnZMvC1e6HRzrs5EvrRITbuMYYMrtfTXKtBj
mJEW5zDet8UKHYE9pT7BcNjNn+zFWHhreX5igG5CEtxAUvHKqThAEjp5cyj22R7/
4TrpnasIMJr/SrcwRjGQwZVkPv1oZzKj2fdwslfQhMgCCNb6WR6txG1OoVA3xYzQ
I49S/34ElGpc4y9+H13675AVw28vqVLAWT1t2q14EEmuNXVgtMzIRMaoHff4DXCO
iTaORgg41L9PlmddVn7EyIRC0WWlX/M/7u6bw5mS1IQIRZDWjCc=
=Kapw
-----END PGP SIGNATURE-----

--T7Yvq6wRcCnY2AOcE3cmUZMbLwgNolNvd--
