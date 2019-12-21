Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ECF7128A5E
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2019 17:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbfLUQVB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Dec 2019 11:21:01 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42075 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726709AbfLUQVA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Dec 2019 11:21:00 -0500
Received: by mail-wr1-f66.google.com with SMTP id q6so12279542wro.9;
        Sat, 21 Dec 2019 08:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=+sWXZ2IbOOe8uDsn4gFg7yVsAagg+FAjpKt0gWTLB8w=;
        b=jmEQs49CTq0EEx4ODp+2uE2wMDS0n1QDUlW/LLTGiakJRgOkxW/dIcWREnTKps0gc8
         6KoQxb3QBdhOHAyRbiA1NdwdLjstMByFbIIkxaBa6qGhlwBEl3Uaa5pp1rEKcTplrVhl
         NJNH+XXEiEFlu/g2k+PJjjD0yNxTF2DQl9mXHAY/jGntooLUs6glWGZCqlImdlgOxq9u
         RnXk0mG6iHWbOJuGQtX/2Sxx2hJQQjT/2lJ0GW/+t50pQJhaoFXlQ9hx96z1A0m0ZRsW
         xvHIdGYSGs+5O/fSwNtKIpdTYVJCXXwngFUU6fUkkzD72Dm2doYvAePEpy8ezUaCV6wK
         gAYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=+sWXZ2IbOOe8uDsn4gFg7yVsAagg+FAjpKt0gWTLB8w=;
        b=qdftwmYCxI/cTVwm5irig0eblsHBEA9IAsBqnR4v0PdDYAYAgfIzpRRwiHfhW1MDC7
         UQoCwmvAneDneUPiVRljyvJaMwKKJnnqmNEn1iLUEhDsRlyhJ5EiMySQon9AZcnIRKFT
         nUsI8ZHeovGUd4mJ3c2tY3WwI2QdjkMS+lw1tdvk9ewckJ38MhRQZfuMWIQ2sL5MyCR1
         qWCIYjygdeOyGpC3v/0srIGFUwcMvtGIjJu7yz2/QRkjGV2Mc8JuLIC7PlEqiM+IKkg2
         WAhIzbOmqz3hC4OldMNt322WeXX5hg3uqQtFWUChMfa7ss/zp+2n65aESlM16x68n8Eg
         GE/Q==
X-Gm-Message-State: APjAAAWnUkGeRHjRRoGt1m+1zg6poGC3wfCg5VbMSfYHRXKvAiuMW3oV
        jTlWLeUYiMp7zT6wld8VtOWIKKZC
X-Google-Smtp-Source: APXvYqyIZh5zYwaSs5sEw3nb8y9k700QdAhyHOtUZG1rg18Mv3fbL8sxR34mvbv/3P2T3QlnnLY05Q==
X-Received: by 2002:adf:e2cf:: with SMTP id d15mr21209324wrj.225.1576945256744;
        Sat, 21 Dec 2019 08:20:56 -0800 (PST)
Received: from [192.168.43.10] ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id f17sm13670724wmc.8.2019.12.21.08.20.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Dec 2019 08:20:56 -0800 (PST)
Subject: Re: [PATCH RFC v2 3/3] io_uring: batch get(ctx->ref) across submits
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
        Christoph Lameter <cl@linux.com>
References: <cover.1576944502.git.asml.silence@gmail.com>
 <925d8fe5406779bbfa108caa3d1f9fd16e3434b5.1576944502.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <da858877-0801-34c3-4508-dabead959410@gmail.com>
Date:   Sat, 21 Dec 2019 19:20:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <925d8fe5406779bbfa108caa3d1f9fd16e3434b5.1576944502.git.asml.silence@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ow1cDVrtXZKifTO9wYjzMLzoVJkGTwjAe"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ow1cDVrtXZKifTO9wYjzMLzoVJkGTwjAe
Content-Type: multipart/mixed; boundary="W2cy8CHM4527v9y7P13rqyRDRYLtYYsmD";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Christoph Lameter <cl@linux.com>
Message-ID: <da858877-0801-34c3-4508-dabead959410@gmail.com>
Subject: Re: [PATCH RFC v2 3/3] io_uring: batch get(ctx->ref) across submits
References: <cover.1576944502.git.asml.silence@gmail.com>
 <925d8fe5406779bbfa108caa3d1f9fd16e3434b5.1576944502.git.asml.silence@gmail.com>
In-Reply-To: <925d8fe5406779bbfa108caa3d1f9fd16e3434b5.1576944502.git.asml.silence@gmail.com>

--W2cy8CHM4527v9y7P13rqyRDRYLtYYsmD
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 21/12/2019 19:15, Pavel Begunkov wrote:
> Double account ctx->refs keeping number of taken refs in ctx. As
> io_uring gets per-request ctx->refs during submission, while holding
> ctx->uring_lock, this allows in most of the time to bypass
> percpu_ref_get*() and its overhead.

Jens, could you please benchmark with this one? Especially for offloaded =
QD1
case. I haven't got any difference for nops test and don't have a decent =
SSD
at hands to test it myself. We could drop it, if there is no benefit.

This rewrites that @extra_refs from the second one, so I left it for now.=



>=20
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 32 +++++++++++++++++++++++++-------
>  1 file changed, 25 insertions(+), 7 deletions(-)
>=20
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 5392134f042f..eef09de94609 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -84,6 +84,9 @@
>  #define IORING_MAX_ENTRIES	32768
>  #define IORING_MAX_CQ_ENTRIES	(2 * IORING_MAX_ENTRIES)
> =20
> +/* Not less than IORING_MAX_ENTRIES, so can grab once per submission l=
oop */
> +#define IORING_REFS_THRESHOLD	IORING_MAX_ENTRIES
> +
>  /*
>   * Shift of 9 is 512 entries, or exactly one page on 64-bit archs
>   */
> @@ -197,6 +200,7 @@ struct fixed_file_data {
>  struct io_ring_ctx {
>  	struct {
>  		struct percpu_ref	refs;
> +		unsigned long		taken_refs; /* used under @uring_lock */
>  	} ____cacheline_aligned_in_smp;
> =20
>  	struct {
> @@ -690,6 +694,13 @@ static void io_ring_ctx_ref_free(struct percpu_ref=
 *ref)
>  	complete(&ctx->completions[0]);
>  }
> =20
> +static void io_free_taken_refs(struct io_ring_ctx *ctx)
> +{
> +	if (ctx->taken_refs)
> +		percpu_ref_put_many(&ctx->refs, ctx->taken_refs);
> +	ctx->taken_refs =3D 0;
> +}
> +
>  static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p=
)
>  {
>  	struct io_ring_ctx *ctx;
> @@ -4388,7 +4399,6 @@ static int io_submit_sqes(struct io_ring_ctx *ctx=
, unsigned int nr,
>  	struct io_submit_state state, *statep =3D NULL;
>  	struct io_kiocb *link =3D NULL;
>  	int i, submitted =3D 0;
> -	unsigned int extra_refs;
>  	bool mm_fault =3D false;
> =20
>  	/* if we have a backlog and couldn't flush it all, return BUSY */
> @@ -4398,9 +4408,15 @@ static int io_submit_sqes(struct io_ring_ctx *ct=
x, unsigned int nr,
>  			return -EBUSY;
>  	}
> =20
> -	if (!percpu_ref_tryget_many(&ctx->refs, nr))
> -		return -EAGAIN;
> -	extra_refs =3D nr;
> +	if (ctx->taken_refs < IORING_REFS_THRESHOLD) {
> +		if (unlikely(percpu_ref_is_dying(&ctx->refs))) {
> +			io_free_taken_refs(ctx);
> +			return -ENXIO;
> +		}
> +		if (!percpu_ref_tryget_many(&ctx->refs, IORING_REFS_THRESHOLD))
> +			return -EAGAIN;
> +		ctx->taken_refs +=3D IORING_REFS_THRESHOLD;
> +	}
> =20
>  	if (nr > IO_PLUG_THRESHOLD) {
>  		io_submit_state_start(&state, nr);
> @@ -4417,8 +4433,9 @@ static int io_submit_sqes(struct io_ring_ctx *ctx=
, unsigned int nr,
>  				submitted =3D -EAGAIN;
>  			break;
>  		}
> -		--extra_refs;
>  		if (!io_get_sqring(ctx, req, &sqe)) {
> +			/* not submitted, but a ref is freed */
> +			ctx->taken_refs--;
>  			__io_free_req(req);
>  			break;
>  		}
> @@ -4454,8 +4471,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx=
, unsigned int nr,
>  		io_queue_link_head(link);
>  	if (statep)
>  		io_submit_state_end(&state);
> -	if (extra_refs)
> -		percpu_ref_put_many(&ctx->refs, extra_refs);
> +	ctx->taken_refs -=3D submitted;
> =20
>  	 /* Commit SQ ring head once we've consumed and submitted all SQEs */=

>  	io_commit_sqring(ctx);
> @@ -5731,6 +5747,7 @@ static int io_uring_fasync(int fd, struct file *f=
ile, int on)
>  static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
>  {
>  	mutex_lock(&ctx->uring_lock);
> +	io_free_taken_refs(ctx);
>  	percpu_ref_kill(&ctx->refs);
>  	mutex_unlock(&ctx->uring_lock);
> =20
> @@ -6196,6 +6213,7 @@ static int __io_uring_register(struct io_ring_ctx=
 *ctx, unsigned opcode,
> =20
>  	if (opcode !=3D IORING_UNREGISTER_FILES &&
>  	    opcode !=3D IORING_REGISTER_FILES_UPDATE) {
> +		io_free_taken_refs(ctx);
>  		percpu_ref_kill(&ctx->refs);
> =20
>  		/*
>=20

--=20
Pavel Begunkov


--W2cy8CHM4527v9y7P13rqyRDRYLtYYsmD--

--ow1cDVrtXZKifTO9wYjzMLzoVJkGTwjAe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl3+Rk0ACgkQWt5b1Glr
+6V/Wg//cNJRnigCPb609gdMvttE89kiqQAiHdLiPBObgLLi6kGoV+6j0Cfu5FhN
aUnd4fKVJ5NXVEDdwSTnMgy7rqM33TnT7Q/MWnnkxxfNFI7JYrXSdxlCZeANsbsm
vhJ/bmFSOKkbuKkLe9yN9LcJZabIiU5LTyp0UyIbEwD06e0Sp0EU98wZQ+XBxfB7
gOMNDVO1Jk2U0+yJqrqUXQ6Mam5XDrcb+qsUXPvGCMc46fobJyp75x+LHftdtsga
XDLT32OAPLh0snFL6VYgow3D0Luko6TCztFM3nIcSxYQFzelK/Lf0+94k3cyssfG
nKIUirWIMG/Nv69m8Zg19LxZiqlSStma+nYliFFS0lZYpsTIO3c/RfiEnNKpJOlI
gl/rbyoox8Z1r0enZbtW9M7mLt23pKZ0Seu2AZ5dRs874sBNv0ZyVh9jvWRCFOFb
SYX88/EDVJ4hK9HQk7dB26B30dbd0WYaljg8aypWuvWb59f4mZ9lPleI6AowZ1UM
YuPi5wbIL8XML3O21A0MqZSx8BC37ztCGqnSGEEgy6Ooz9UjT2wcvdnuUQnd8MGK
g6mR5xxUgSbmJDD7YZ0QIYztwfan5T1jk7ZwPBGFTT0w+EBBY2CwM9FfmxSVODcc
61sdN4JYx9sIOt2JX33lJqZc+an+IAJIuIE3GE+B2CluVS3SvMs=
=kJHm
-----END PGP SIGNATURE-----

--ow1cDVrtXZKifTO9wYjzMLzoVJkGTwjAe--
