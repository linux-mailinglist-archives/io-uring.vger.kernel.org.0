Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3238514C3D4
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 01:10:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgA2AKo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Jan 2020 19:10:44 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38690 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgA2AKo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Jan 2020 19:10:44 -0500
Received: by mail-wm1-f65.google.com with SMTP id a9so4510745wmj.3;
        Tue, 28 Jan 2020 16:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=63t8RqEo6ytl70vEYtdcHqhLmTPjoam4rhJBRTz9H90=;
        b=cJ47WG+J98ChhyOdNCp8R63zHWwDpE6FvQ/6rP0G/8/z5awL2y+H/L7nNlKsTleBpL
         skL0aedw3n9loV1Nk8bpkE9DzRM2+PU61YB+K+988By+B6/BAOfHt5qYmUZEIycPZiOt
         Pk/nabAEDoG8eQxhagFuttTHH6swOOxI47mGz19DzAkU9XFVwIx24NKTmqSyeHTuce3r
         3tyE0WdRVoir7g/dhdCqla/DmK3MwU7KfYPfsW8YgWJmfF85PP/W50SgmoBzWmIvfCOr
         OE1LXGz0sA7joCUckeGMQ7OWiFA/H4CSwL2AkhgaIKqPQJWPJ8H/asIU0Zm11Gwoj38w
         AsIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=63t8RqEo6ytl70vEYtdcHqhLmTPjoam4rhJBRTz9H90=;
        b=YYNArwqhVbNeP92lhqufgwfVQmSCeD/82sYTJW5Zru1nk6isCSlo3aDEYk1ubjEnkN
         6ys7si6Q9IEYpbRrHTjYbwNSFyRhDqevulK3IXJ0W2JhKUV04jJ9QWf57iK8mig2JSgm
         7G2b+CVCqvYhhnJK4jOQntHfRTZRkhi2G9pl8XJUYd3mQ6MBqpi261YOqZne5wIP98eq
         dEUd7qX7NajAS4lmBBZv/tDysSnwMYp6SCsc/ewLOYhrJ9kwKajbuEce6GFjal9mJ3jG
         CW6/8kazRkiw910+n1q3VpXNmZrGaBmQl4htxfbTCZUwhRD6A9ehwV9RCTG2Qkph3nbo
         V2Tw==
X-Gm-Message-State: APjAAAXGdMmVs601I8NGWVwRrcK7E+qDLqMuwWp2BZFTsUeqrg8NCB3s
        zJIdSZXInUB2WiJl+6MqN9+tvfoG
X-Google-Smtp-Source: APXvYqwvcfuyHrZAml0MsWxXg7CYr0SP9MyZlsxzM46aILD9BAvHdnjVcZ8/b07ROHRpJz6KqqAcaA==
X-Received: by 2002:a1c:f001:: with SMTP id a1mr7358980wmb.76.1580256640924;
        Tue, 28 Jan 2020 16:10:40 -0800 (PST)
Received: from [192.168.43.59] ([109.126.145.157])
        by smtp.gmail.com with ESMTPSA id d16sm521977wrg.27.2020.01.28.16.10.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jan 2020 16:10:40 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <2d7e7fa2-e725-8beb-90b9-6476d48bdb33@gmail.com>
 <6c401e23-de7c-1fc1-4122-33d53fcf9700@kernel.dk>
 <35eebae7-76dd-52ee-58b2-4f9e85caee40@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
Message-ID: <d3f9c1a4-8b28-3cfe-de88-503837a143bc@gmail.com>
Date:   Wed, 29 Jan 2020 03:10:00 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <35eebae7-76dd-52ee-58b2-4f9e85caee40@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="lRrc6G6gXrup0csTFFZcEntNplhztBpnq"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--lRrc6G6gXrup0csTFFZcEntNplhztBpnq
Content-Type: multipart/mixed; boundary="cK8FbgRep79RadR9iuAsWyEL8b1jMSHXS";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>
Cc: io-uring <io-uring@vger.kernel.org>,
 Linux API Mailing List <linux-api@vger.kernel.org>
Message-ID: <d3f9c1a4-8b28-3cfe-de88-503837a143bc@gmail.com>
Subject: Re: IORING_REGISTER_CREDS[_UPDATE]() and credfd_create()?
References: <ea9f2f27-e9fe-7016-5d5f-56fe1fdfc7a9@samba.org>
 <d6bc8139-abbe-8a8d-7da1-4eeafd9eebe7@kernel.dk>
 <688e187a-75dd-89d9-921c-67de228605ce@samba.org>
 <b29e972e-5ca0-8b5f-46b3-36f93d865723@kernel.dk>
 <1ac31828-e915-6180-cdb4-36685442ea75@kernel.dk>
 <0d4f43d8-a0c4-920b-5b8f-127c1c5a3fad@kernel.dk>
 <b88f0590-71c9-d2bd-9d17-027b05d30d7a@kernel.dk>
 <2d7e7fa2-e725-8beb-90b9-6476d48bdb33@gmail.com>
 <6c401e23-de7c-1fc1-4122-33d53fcf9700@kernel.dk>
 <35eebae7-76dd-52ee-58b2-4f9e85caee40@kernel.dk>
In-Reply-To: <35eebae7-76dd-52ee-58b2-4f9e85caee40@kernel.dk>

--cK8FbgRep79RadR9iuAsWyEL8b1jMSHXS
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 29/01/2020 02:51, Jens Axboe wrote:
> On 1/28/20 4:40 PM, Jens Axboe wrote:
>> On 1/28/20 4:36 PM, Pavel Begunkov wrote:
>>> On 28/01/2020 22:42, Jens Axboe wrote:
>>>> I didn't like it becoming a bit too complicated, both in terms of
>>>> implementation and use. And the fact that we'd have to jump through
>>>> hoops to make this work for a full chain.
>>>>
>>>> So I punted and just added sqe->personality and IOSQE_PERSONALITY.
>>>> This makes it way easier to use. Same branch:
>>>>
>>>> https://git.kernel.dk/cgit/linux-block/log/?h=3Dfor-5.6/io_uring-vfs=
-creds
>>>>
>>>> I'd feel much better with this variant for 5.6.
>>>>
>>>
>>> Checked out ("don't use static creds/mm assignments")
>>>
>>> 1. do we miscount cred refs? We grab one in get_current_cred() for ea=
ch async
>>> request, but if (worker->creds !=3D work->creds) it will never be put=
=2E
>>
>> Yeah I think you're right, that needs a bit of fixing up.
>=20

Hmm, it seems it leaks it unconditionally, as it grabs in a ref in overri=
de_creds().

> I think this may have gotten fixed with the later addition posted today=
?
> I'll double check. But for the newer stuff, we put it for both cases
> when the request is freed.

Yeah, maybe. I got tangled trying to verify both at once and decided to s=
tart
with the old one.


>>> 2. shouldn't worker->creds be named {old,saved,etc}_creds? It's set a=
s
>>>
>>>     worker->creds =3D override_creds(work->creds);
>>>
>>> Where override_creds() returns previous creds. And if so, then the fo=
llowing
>>> fast check looks strange:
>>>
>>>     worker->creds !=3D work->creds
>>
>> Don't care too much about the naming, but the logic does appear off.
>> I'll take a look at both of these tonight, unless you beat me to it.

Apparently, you're faster :)

>=20
> Testing this now, what a braino.
>=20
> diff --git a/fs/io-wq.c b/fs/io-wq.c
> index ee49e8852d39..8fbbadf04cc3 100644
> --- a/fs/io-wq.c
> +++ b/fs/io-wq.c
> @@ -56,7 +56,8 @@ struct io_worker {
> =20
>  	struct rcu_head rcu;
>  	struct mm_struct *mm;
> -	const struct cred *creds;
> +	const struct cred *cur_creds;
> +	const struct cred *saved_creds;
>  	struct files_struct *restore_files;
>  };
> =20
> @@ -135,9 +136,9 @@ static bool __io_worker_unuse(struct io_wqe *wqe, s=
truct io_worker *worker)
>  {
>  	bool dropped_lock =3D false;
> =20
> -	if (worker->creds) {
> -		revert_creds(worker->creds);
> -		worker->creds =3D NULL;
> +	if (worker->saved_creds) {
> +		revert_creds(worker->saved_creds);
> +		worker->cur_creds =3D worker->saved_creds =3D NULL;
>  	}
> =20
>  	if (current->files !=3D worker->restore_files) {
> @@ -424,10 +425,11 @@ static void io_wq_switch_mm(struct io_worker *wor=
ker, struct io_wq_work *work)
>  static void io_wq_switch_creds(struct io_worker *worker,
>  			       struct io_wq_work *work)
>  {
> -	if (worker->creds)
> -		revert_creds(worker->creds);
> +	if (worker->saved_creds)
> +		revert_creds(worker->saved_creds);
> =20
> -	worker->creds =3D override_creds(work->creds);
> +	worker->saved_creds =3D override_creds(work->creds);
> +	worker->cur_creds =3D work->creds;
>  }

How about as follows? rever_creds() is a bit heavier than put_creds().

static void io_wq_switch_creds(struct io_worker *worker,
			       struct io_wq_work *work)
{
	const struct cred *old_creds =3D override_creds(work->creds);

	if (worker->saved_creds)
		put_cred(old_creds);
	else
		worker->saved_creds =3D old;
	worker->cur_creds =3D work->creds;
}

> =20
>  static void io_worker_handle_work(struct io_worker *worker)
> @@ -480,7 +482,7 @@ static void io_worker_handle_work(struct io_worker =
*worker)
>  		}
>  		if (work->mm !=3D worker->mm)
>  			io_wq_switch_mm(worker, work);
> -		if (worker->creds !=3D work->creds)
> +		if (worker->cur_creds !=3D work->creds)
>  			io_wq_switch_creds(worker, work);
>  		/*
>  		 * OK to set IO_WQ_WORK_CANCEL even for uncancellable work,
>=20

--=20
Pavel Begunkov


--cK8FbgRep79RadR9iuAsWyEL8b1jMSHXS--

--lRrc6G6gXrup0csTFFZcEntNplhztBpnq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl4wzVgACgkQWt5b1Glr
+6UP7g//TrctzFamRv2q68uGare3sGHZxaIeAkesfEeJM/ltrvQuh/MIIiWnAdlo
3EE7j5ycRgDpviTaNLd43J3wAGHbz4eZHBeBw9opFkjiAbZird6Etc7+ysLFuojO
B8xBhcAfnMN80L4Rb9PTWk6d2pn74YI25mWQxxsbZ2VB44INycF12n1zmeNTF5C7
vOtvr20FVWKE7qDQYbxWbFHhbA0F5btMROOTAqWUtwg0u5sNfgXBst5xKh5yfbjL
fj2L3l2aJIhXHzUNFK7pidZw/3/d9RQrpbw6mPcUEdy8wOX7xSaj6KvVRnyLxBx1
wR7Cwm4Kgb5PGEv4lM8NfFR6a6bafB3q0RPsQjyfi6deNoh55PpqdG3P3tUe/7za
pHOQ5sm1WIypEgnz2pTPt0D6UxGGji9fI43ihugnB4ju/gLYVf2EG8CUykKUnHFB
a83suNfXTKnBR2tub/7Esc2oJ37uX/Um3mYMkXesmempLD+WfSQnaXS+F1mPpD74
hl5LtPhB+tAVExUcZGF78JXogGnUJvbAcdn26nqoq0YPbETMelnGQXWw9+4Ibhik
VtZNOqTU9SygfmHjWlchrvtG/6sckWsmxjvl+YFMlRCR6q+NF2GoiRASrRt8dfUA
t8kwYMIfclv2iqxyLhbJNqDMklj4/KpZS8nRFBv6SeZbU8zmg9Y=
=idCk
-----END PGP SIGNATURE-----

--lRrc6G6gXrup0csTFFZcEntNplhztBpnq--
