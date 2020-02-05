Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60E69153A6A
	for <lists+io-uring@lfdr.de>; Wed,  5 Feb 2020 22:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgBEVoi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Feb 2020 16:44:38 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35588 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727116AbgBEVoh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Feb 2020 16:44:37 -0500
Received: by mail-wr1-f66.google.com with SMTP id w12so4672696wrt.2;
        Wed, 05 Feb 2020 13:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=ar6agWtuM+9Xulf6qRMIf69QeD+YmYMouRwwo5GNuII=;
        b=OJ7R2FdJf/C720qWU27LC9UPJc3V1+Nj+eDFyRCbMwNMa6g95VUQB0eojRQEa0p2BX
         yzG5+IfJlt5ikoNTm0D9/aBtNF6X2YOgAaQmWwUDB0Z4Qax0BeFHgl0ZUDdIUFRbYZjV
         rn/o9ZVTe4kpR1CsPBeo+bLU05IeMcCYF1aY/WXKt+HF3SVsBccvF85b8QyqrjJHcWe7
         eEHDgH+CagnzF+TrpN42CyF2c5pWcn8oUo7yYhnWtgaj4ylQTWAPavaaWT1Qn0eJ39H5
         6LN5SrYdiMrSKf+eBPj6lgqrJZ4fN/DKsvaqKrR8D5hveaRW50wRI7xabXpyX4uvGd/Y
         CrGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=ar6agWtuM+9Xulf6qRMIf69QeD+YmYMouRwwo5GNuII=;
        b=PTuGvwevdbhE+O+v1JHpcOTVky0akMgqviuV283RG78tDQd/gtIMUn3+dMNbKCWnK9
         NogWQfuZcl4nLNrhrcyp4gEWzxNDbIHH47/nmd7HVN8LXNQrEk2PFg+kv7cYLITUx+Q7
         CmvXrgpee6YZB+u2epxeSMTzQoTJrdHoR8/qAVgceksN4Z/39WfpACUvqYc9KAns4cUW
         IBcjxLIWpNHqiWR45Dfa8Vwf8reBjJZUBo4/kg+MKfBeJuOq1dnjatcysGLe24UNYmCH
         jEnPM3FbTKAwslC0+O8LSV+T7xLhHNnkZfbN+DaSIa2WcOh+74TeX9k26eAwjB0BQrZ0
         3qcQ==
X-Gm-Message-State: APjAAAWr9QgpwD0gF5rfwLKy6cwlowyyFCEr/4/AtpWtKiv8nR5JbQ1W
        Tg4Fh8Ns9psq0jRBqCVNetx/X5Wf
X-Google-Smtp-Source: APXvYqzT92bLiR7MO2yUyPMHJItNHZBtdiHr8wXIJoyrnLXMPN+PCREQ2UlSy9h6K/fj+STqDuo4BQ==
X-Received: by 2002:a5d:6886:: with SMTP id h6mr605043wru.154.1580939074428;
        Wed, 05 Feb 2020 13:44:34 -0800 (PST)
Received: from [192.168.43.125] ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id 133sm1204270wmd.5.2020.02.05.13.44.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2020 13:44:33 -0800 (PST)
Subject: Re: [PATCH 1/3] io_uring: pass sqe for link head
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1580928112.git.asml.silence@gmail.com>
 <c9654d6a79898d5f8aa8b9dabcb76d9f23faa149.1580928112.git.asml.silence@gmail.com>
 <19f6aa0e-158f-5125-9df9-39ae95c72962@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <332a2afd-cdfc-3b7f-c228-abc5bdc7646a@gmail.com>
Date:   Thu, 6 Feb 2020 00:43:56 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <19f6aa0e-158f-5125-9df9-39ae95c72962@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IYK2h3LBy4gGtE5VaeSAU4KhikwwceVaz"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IYK2h3LBy4gGtE5VaeSAU4KhikwwceVaz
Content-Type: multipart/mixed; boundary="QNEeBAtqmlBWcq56WAFcyeH8PtY64JIDW";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <332a2afd-cdfc-3b7f-c228-abc5bdc7646a@gmail.com>
Subject: Re: [PATCH 1/3] io_uring: pass sqe for link head
References: <cover.1580928112.git.asml.silence@gmail.com>
 <c9654d6a79898d5f8aa8b9dabcb76d9f23faa149.1580928112.git.asml.silence@gmail.com>
 <19f6aa0e-158f-5125-9df9-39ae95c72962@gmail.com>
In-Reply-To: <19f6aa0e-158f-5125-9df9-39ae95c72962@gmail.com>

--QNEeBAtqmlBWcq56WAFcyeH8PtY64JIDW
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 06/02/2020 00:39, Pavel Begunkov wrote:
> On 05/02/2020 22:07, Pavel Begunkov wrote:
>> Save an sqe for a head of a link, so it doesn't go through switch in
>> io_req_defer_prep() nor allocating an async context in advance.
>>
>> Also, it's fixes potenial memleak for double-preparing head requests.
>> E.g. prep in io_submit_sqe() and then prep in io_req_defer(),
>> which leaks iovec for vectored read/writes.
>=20
> Looking through -rc1, remembered that Jens already fixed this. So, this=
 may be
> striked out.

Just to clarify, I was talking about removing the last argument in the pa=
tch
message.

>=20
>=20
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  fs/io_uring.c | 19 ++++++++++---------
>>  1 file changed, 10 insertions(+), 9 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index f00c2c9c67c0..e18056af5672 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -4721,20 +4721,22 @@ static void io_queue_sqe(struct io_kiocb *req,=
 const struct io_uring_sqe *sqe)
>>  	}
>>  }
>> =20
>> -static inline void io_queue_link_head(struct io_kiocb *req)
>> +static inline void io_queue_link_head(struct io_kiocb *req,
>> +				      const struct io_uring_sqe *sqe)
>>  {
>>  	if (unlikely(req->flags & REQ_F_FAIL_LINK)) {
>>  		io_cqring_add_event(req, -ECANCELED);
>>  		io_double_put_req(req);
>>  	} else
>> -		io_queue_sqe(req, NULL);
>> +		io_queue_sqe(req, sqe);
>>  }
>> =20
>>  #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LIN=
K|	\
>>  				IOSQE_IO_HARDLINK | IOSQE_ASYNC)
>> =20
>>  static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring=
_sqe *sqe,
>> -			  struct io_submit_state *state, struct io_kiocb **link)
>> +			  struct io_submit_state *state, struct io_kiocb **link,
>> +			  const struct io_uring_sqe **link_sqe)
>>  {
>>  	const struct cred *old_creds =3D NULL;
>>  	struct io_ring_ctx *ctx =3D req->ctx;
>> @@ -4812,7 +4814,7 @@ static bool io_submit_sqe(struct io_kiocb *req, =
const struct io_uring_sqe *sqe,
>> =20
>>  		/* last request of a link, enqueue the link */
>>  		if (!(sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK))) {
>> -			io_queue_link_head(head);
>> +			io_queue_link_head(head, *link_sqe);
>>  			*link =3D NULL;
>>  		}
>>  	} else {
>> @@ -4823,10 +4825,8 @@ static bool io_submit_sqe(struct io_kiocb *req,=
 const struct io_uring_sqe *sqe,
>>  		if (sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
>>  			req->flags |=3D REQ_F_LINK;
>>  			INIT_LIST_HEAD(&req->link_list);
>> -			ret =3D io_req_defer_prep(req, sqe);
>> -			if (ret)
>> -				req->flags |=3D REQ_F_FAIL_LINK;
>>  			*link =3D req;
>> +			*link_sqe =3D sqe;
>>  		} else {
>>  			io_queue_sqe(req, sqe);
>>  		}
>> @@ -4924,6 +4924,7 @@ static int io_submit_sqes(struct io_ring_ctx *ct=
x, unsigned int nr,
>>  	struct io_kiocb *link =3D NULL;
>>  	int i, submitted =3D 0;
>>  	bool mm_fault =3D false;
>> +	const struct io_uring_sqe *link_sqe =3D NULL;
>> =20
>>  	/* if we have a backlog and couldn't flush it all, return BUSY */
>>  	if (test_bit(0, &ctx->sq_check_overflow)) {
>> @@ -4983,7 +4984,7 @@ static int io_submit_sqes(struct io_ring_ctx *ct=
x, unsigned int nr,
>>  		req->needs_fixed_file =3D async;
>>  		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
>>  						true, async);
>> -		if (!io_submit_sqe(req, sqe, statep, &link))
>> +		if (!io_submit_sqe(req, sqe, statep, &link, &link_sqe))
>>  			break;
>>  	}
>> =20
>> @@ -4993,7 +4994,7 @@ static int io_submit_sqes(struct io_ring_ctx *ct=
x, unsigned int nr,
>>  		percpu_ref_put_many(&ctx->refs, nr - ref_used);
>>  	}
>>  	if (link)
>> -		io_queue_link_head(link);
>> +		io_queue_link_head(link, link_sqe);
>>  	if (statep)
>>  		io_submit_state_end(&state);
>> =20
>>
>=20

--=20
Pavel Begunkov


--QNEeBAtqmlBWcq56WAFcyeH8PtY64JIDW--

--IYK2h3LBy4gGtE5VaeSAU4KhikwwceVaz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl47NxwACgkQWt5b1Glr
+6Vu/Q/7BOI23/9uOMO7/wGqAXBW9wdK6MAa3v9qAY60XypkE1qluGIyRYe4vcfB
WISUt1k4+65n7PpRc7frP6yVNNs7Rm/RLldJYBusz0b8hSf3TYcNrVIp/HREIl5b
kju9oWhHv805gJQcP5nOgC5C/eL49TCKq7mg/NObvh0WVzMASHz3wyQcLrRuVMIi
zChCzp8a29hI3xDnVwa4dVxbKxtPi0JhekxuDeqdzJCqxglCCToJ8ikV1pkpShB0
dbE0OhpyTMCkh7E8tFHpCOnJweyEYyTgX8PPKOvgl+EfPps6WvkRyeVGDSGZcBQ7
oFE0Tujsk6TlTmKGElVwdK4b2J01fUYoGI5XGS/lCs/cLrGYhStoBsPKjl1dowST
/DW1gy+1TgSVyL+Ebnfu/tIdkwpmfa/LNCxeyYASTMjqn9JAYKpKSj7DuJFHAY7t
Qfn/6s68n7WQqGETD2VTv4o3XyPed2AutGZ76Ow9+Q+wiyXJyDIQDBhfEqu0OJhT
JoELacwAswPKJpbI+UWya6oYGK8do4Q5yN5ZNI31T303ln9XO7ITWT5yVcXQt3Yq
11vnB6BpdnnZ2cIa+ki1ufkpUvhPIPEWz/NFU3B1iQv80d46DUtRJAdCcivufJUM
AzhTWAV9PGz+ePEK0nU47YMdpDya8ZXTho13HD6xyx+DODcVxKc=
=mg1P
-----END PGP SIGNATURE-----

--IYK2h3LBy4gGtE5VaeSAU4KhikwwceVaz--
