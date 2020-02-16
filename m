Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 574F51605AC
	for <lists+io-uring@lfdr.de>; Sun, 16 Feb 2020 20:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgBPTHn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Feb 2020 14:07:43 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:53850 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbgBPTHn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Feb 2020 14:07:43 -0500
Received: by mail-wm1-f50.google.com with SMTP id s10so15031229wmh.3
        for <io-uring@vger.kernel.org>; Sun, 16 Feb 2020 11:07:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=zBn6FSowl6fiEvQuUMlWfk+kNtkAlvVKz+ecPqlfm2k=;
        b=Hy4wuOxEfyTycclsZLBddbjEZGRLyAK0QIzXsYcfHC5FPAr9i8aSz2btIra8YbklME
         6z8uFnQWTa+brZpuoAIv0lwzXG/bwIKeGjD4VOn5BSycY89z82eysWThUUq5zV3PWbZl
         rmK1LxHyVBzLzpcTJI5Jdb2+Gl4EQJ5iFf2alPvLojR/Xy5+Z5alqaDg9EUdX3o9lBBy
         LWpdsGJ0N7tGnrP+VzEv+k/t+apKtwDTie7RuJp2eLAmpGKST1+Ua++x0ykAhHD4vuIo
         Sl0Ry5s3lHz2IrxYOxypd0lngoliF+RrCzRoBMzsiK/YN/0J9EgyUWpIat3bk2B4gl1U
         HqlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=zBn6FSowl6fiEvQuUMlWfk+kNtkAlvVKz+ecPqlfm2k=;
        b=JUzaonOQw7x7hGvYGE+E87stSjgcGFuH92VUe1CWEgJPVvu17BROvsPdM6YqFPQ/uB
         o71HqPB/tOFQBy0K0koogNwLpbYPZSdDZhnSW0uGIYdNl90Ly1/olSPjfUdPxZja/ygJ
         7wK2X0nqLlVYNlo9EGMPCuTdu7b9G20jRgGibwO2b9UAblOdT4hPEVlFMbsgT6f/GTwp
         9yR9P8fdAZ/aCkZkq4TzKIi3JHK9vc7j1ljXBwnqnTJ0w2dQ+VHGg4P7UOuPBxxIJoo7
         PABIIu+km6CpdiF50a2ldtznFJHUK0p/y/bJiqQyamqmmsCfRpAfUcRglWzxQT1Qow3c
         kNmQ==
X-Gm-Message-State: APjAAAVOIWduujj3u5FmHQcZws89OC3wDTLGEHzJIq/9s1ZNECbGMURu
        VzMdhWGx3QZgMxdh+InF/AZQPjUu
X-Google-Smtp-Source: APXvYqwF9sk+xHMMqJEiX5RiJNFaxRWrfx4lQcQP6OXk0OBwVktw8KL83D5NgMq9CDv5ET435YwwZg==
X-Received: by 2002:a7b:c85a:: with SMTP id c26mr17425224wml.107.1581880060364;
        Sun, 16 Feb 2020 11:07:40 -0800 (PST)
Received: from [192.168.43.97] ([109.126.145.198])
        by smtp.gmail.com with ESMTPSA id b16sm16633032wmj.39.2020.02.16.11.07.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 16 Feb 2020 11:07:39 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>,
        =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        io-uring <io-uring@vger.kernel.org>
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
 <8a3ee653-77ed-105d-c1c3-87087451914e@kernel.dk>
 <ADF462D7-A381-4314-8931-DDB0A2C18761@eoitek.com>
 <9a8e4c8a-f8b2-900d-92b6-cc69b6adf324@gmail.com>
 <5f09d89a-0c6d-47c2-465c-993af0c7ae71@kernel.dk>
 <7E66D70C-BE4E-4236-A49B-9843F66EA322@eoitek.com>
 <671A3FE3-FA12-43D8-ADF0-D1DB463B053F@eoitek.com>
 <217eda7b-3742-a50b-7d6a-c1294a85c8e0@kernel.dk>
 <1b9a7390-7539-a8bc-d437-493253b13d77@kernel.dk>
 <20200214153218.GM14914@hirez.programming.kicks-ass.net>
 <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
 <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <FA1CECBA-FBFE-4228-BA5C-1B8A4A2B3534@eoitek.com>
 <f1610a65-0bf9-8134-3e8d-72cccd2f5468@kernel.dk>
 <72423161-38EF-49D1-8229-18C328AB5DA1@eoitek.com>
 <3124507b-3458-48da-27e0-abeefcd9eb08@kernel.dk>
 <5cba3020-7d99-56b0-8927-f679118c90e9@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
Message-ID: <68a068dd-cb14-10a5-a441-12bc6a2b1dea@gmail.com>
Date:   Sun, 16 Feb 2020 22:06:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <5cba3020-7d99-56b0-8927-f679118c90e9@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2weLwSCrKGxHX56EQbjBUmsNtHzO1qElT"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2weLwSCrKGxHX56EQbjBUmsNtHzO1qElT
Content-Type: multipart/mixed; boundary="FuYQQqncNeHhAnSaLby9plYXwazJz8yGu";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?=
 <carter.li@eoitek.com>
Cc: Peter Zijlstra <peterz@infradead.org>, io-uring <io-uring@vger.kernel.org>
Message-ID: <68a068dd-cb14-10a5-a441-12bc6a2b1dea@gmail.com>
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
 <8a3ee653-77ed-105d-c1c3-87087451914e@kernel.dk>
 <ADF462D7-A381-4314-8931-DDB0A2C18761@eoitek.com>
 <9a8e4c8a-f8b2-900d-92b6-cc69b6adf324@gmail.com>
 <5f09d89a-0c6d-47c2-465c-993af0c7ae71@kernel.dk>
 <7E66D70C-BE4E-4236-A49B-9843F66EA322@eoitek.com>
 <671A3FE3-FA12-43D8-ADF0-D1DB463B053F@eoitek.com>
 <217eda7b-3742-a50b-7d6a-c1294a85c8e0@kernel.dk>
 <1b9a7390-7539-a8bc-d437-493253b13d77@kernel.dk>
 <20200214153218.GM14914@hirez.programming.kicks-ass.net>
 <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
 <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <FA1CECBA-FBFE-4228-BA5C-1B8A4A2B3534@eoitek.com>
 <f1610a65-0bf9-8134-3e8d-72cccd2f5468@kernel.dk>
 <72423161-38EF-49D1-8229-18C328AB5DA1@eoitek.com>
 <3124507b-3458-48da-27e0-abeefcd9eb08@kernel.dk>
 <5cba3020-7d99-56b0-8927-f679118c90e9@kernel.dk>
In-Reply-To: <5cba3020-7d99-56b0-8927-f679118c90e9@kernel.dk>

--FuYQQqncNeHhAnSaLby9plYXwazJz8yGu
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 15/02/2020 09:01, Jens Axboe wrote:
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index fb94b8bac638..530dcd91fa53 100644
> @@ -4630,6 +4753,14 @@ static void __io_queue_sqe(struct io_kiocb *req,=
 const struct io_uring_sqe *sqe)
>  	 */
>  	if (ret =3D=3D -EAGAIN && (!(req->flags & REQ_F_NOWAIT) ||
>  	    (req->flags & REQ_F_MUST_PUNT))) {
> +
> +		if (io_arm_poll_handler(req, &retry_count)) {
> +			if (retry_count =3D=3D 1)
> +				goto issue;

Better to sqe=3DNULL before retrying, so it won't re-read sqe and try to =
init the
req twice.

Also, the second sync-issue may -EAGAIN again, and as I remember, read/wr=
ite/etc
will try to copy iovec into req->io. But iovec is already in req->io, so =
it will
self memcpy(). Not a good thing.

> +			else if (!retry_count)
> +				goto done_req;
> +			INIT_IO_WORK(&req->work, io_wq_submit_work);

It's not nice to reset it as this:
- prep() could set some work.flags
- custom work.func is more performant (adds extra switch)
- some may rely on specified work.func to be called. e.g. close(), even t=
hough
it doesn't participate in the scheme

> +		}
>  punt:
>  		if (io_op_defs[req->opcode].file_table) {
>  			ret =3D io_grab_files(req);
> @@ -5154,26 +5285,40 @@ void io_uring_task_handler(struct task_struct *=
tsk)
>  {
>  	LIST_HEAD(local_list);
>  	struct io_kiocb *req;
> +	long state;
> =20
>  	spin_lock_irq(&tsk->uring_lock);
>  	if (!list_empty(&tsk->uring_work))

--=20
Pavel Begunkov


--FuYQQqncNeHhAnSaLby9plYXwazJz8yGu--

--2weLwSCrKGxHX56EQbjBUmsNtHzO1qElT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl5JktIACgkQWt5b1Glr
+6V+Ig/+PMo58TWQyUVL+fEl6ETtDFdA+N7JSbN/FdBlIc4W3eCxp6KbZZh40hdB
/3TignPpEoZqtDJ7FtGNTByORq9w/N/4z5FDyXVCIJieF6/cZ4eta1YMyfZhz1qR
dASlLtV47unCKTAstdQht4XvAyxRAerB//RBCrAfcx7W3ZOFZi2m18gr6wpRItmL
s07YIPq/3T87ZrpUHoBBf5IW47D3zyoaOMi7cxNHxHQuOUDD/aRXVLt/seY4eKgs
n9h5XJGeQwallwj/TcVnbhTRCrPQjpFYRDtn2Uvpx0IZEZHfNna5ZI+UhryuMm/K
vrgioGlyDsqS8d5mWRntAUiJ29UhVwnxWUcuNSKHHiY2VKQxgDGMW0HaFmnu8f0E
UAnUZtg2Agj2Ushu6yHMIJulvJ4M2WhxErfBpsgeYyb/d+n9jVDuhSPU/mRN2Osp
7utxNPWDsVUhJgOi/NjkvmJA/0cS1nGMPDXSbON1zeIHPFhnmBajN3Js0zzl58qw
+Xa0GShrnMwHnDsN1kFYfybWQpatlvvOPy7WbaBusXvvvJjXfmkuaNtm9Wrni9Wa
rGkYHSosn0/sopMd+bA67L/zNccrmzxLFjUpawRivuaNQlQhERg5lkpOw1t1B02F
9fPiEfIGXY4hrGU2mjk9SCmazU5ZJJir4A8Pf1Z6q6gJdoOB8sk=
=MJPd
-----END PGP SIGNATURE-----

--2weLwSCrKGxHX56EQbjBUmsNtHzO1qElT--
