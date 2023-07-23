Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9995875E10A
	for <lists+io-uring@lfdr.de>; Sun, 23 Jul 2023 11:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjGWJti (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Jul 2023 05:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjGWJth (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Jul 2023 05:49:37 -0400
X-Greylist: delayed 568 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 23 Jul 2023 02:49:31 PDT
Received: from vulcan.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D3210D9;
        Sun, 23 Jul 2023 02:49:31 -0700 (PDT)
Received: from spock.localnet (unknown [94.142.239.106])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id B9F9314697E4;
        Sun, 23 Jul 2023 11:39:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1690105196;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dJFwaE+Wp4xXknQEEGSTLenwUzVW0tD9EFuQKBQb2hA=;
        b=tDbhV6Iu6EzvMO9d9hGrN/M3BZJ+vwKqaMkNJvSNvJ1zEQxPbrw701hdYG7+R83ep5k1Ec
        jxCDL+I/uD/rpi0aMzO3KvZPWa6YKD1lnA6aJEIHJ44RMSJ53VfmxLh35NhgEHUjNoaOCl
        CZwsX4/QoEA7uCMpCKzKRrhHidHKEmI=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Freund <andres@anarazel.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 6.4 800/800] io_uring: Use io_schedule* in cqring wait
Date:   Sun, 23 Jul 2023 11:39:42 +0200
Message-ID: <12251678.O9o76ZdvQC@natalenko.name>
In-Reply-To: <20230716195007.731909670@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
 <20230716195007.731909670@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5695128.DvuYhMxLoT";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--nextPart5695128.DvuYhMxLoT
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; protected-headers="v1"
From: Oleksandr Natalenko <oleksandr@natalenko.name>
To: stable@vger.kernel.org
Date: Sun, 23 Jul 2023 11:39:42 +0200
Message-ID: <12251678.O9o76ZdvQC@natalenko.name>
In-Reply-To: <20230716195007.731909670@linuxfoundation.org>
MIME-Version: 1.0

Hello.

On ned=C4=9Ble 16. =C4=8Dervence 2023 21:50:53 CEST Greg Kroah-Hartman wrot=
e:
> From: Andres Freund <andres@anarazel.de>
>=20
> commit 8a796565cec3601071cbbd27d6304e202019d014 upstream.
>=20
> I observed poor performance of io_uring compared to synchronous IO. That
> turns out to be caused by deeper CPU idle states entered with io_uring,
> due to io_uring using plain schedule(), whereas synchronous IO uses
> io_schedule().
>=20
> The losses due to this are substantial. On my cascade lake workstation,
> t/io_uring from the fio repository e.g. yields regressions between 20%
> and 40% with the following command:
> ./t/io_uring -r 5 -X0 -d 1 -s 1 -c 1 -p 0 -S$use_sync -R 0 /mnt/t2/fio/wr=
ite.0.0
>=20
> This is repeatable with different filesystems, using raw block devices
> and using different block devices.
>=20
> Use io_schedule_prepare() / io_schedule_finish() in
> io_cqring_wait_schedule() to address the difference.
>=20
> After that using io_uring is on par or surpassing synchronous IO (using
> registered files etc makes it reliably win, but arguably is a less fair
> comparison).
>=20
> There are other calls to schedule() in io_uring/, but none immediately
> jump out to be similarly situated, so I did not touch them. Similarly,
> it's possible that mutex_lock_io() should be used, but it's not clear if
> there are cases where that matters.
>=20
> Cc: stable@vger.kernel.org # 5.10+
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Cc: io-uring@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Andres Freund <andres@anarazel.de>
> Link: https://lore.kernel.org/r/20230707162007.194068-1-andres@anarazel.de
> [axboe: minor style fixup]
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  io_uring/io_uring.c |   15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>=20
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -2575,6 +2575,8 @@ int io_run_task_work_sig(struct io_ring_
>  static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
>  					  struct io_wait_queue *iowq)
>  {
> +	int token, ret;
> +
>  	if (unlikely(READ_ONCE(ctx->check_cq)))
>  		return 1;
>  	if (unlikely(!llist_empty(&ctx->work_llist)))
> @@ -2585,11 +2587,20 @@ static inline int io_cqring_wait_schedul
>  		return -EINTR;
>  	if (unlikely(io_should_wake(iowq)))
>  		return 0;
> +
> +	/*
> +	 * Use io_schedule_prepare/finish, so cpufreq can take into account
> +	 * that the task is waiting for IO - turns out to be important for low
> +	 * QD IO.
> +	 */
> +	token =3D io_schedule_prepare();
> +	ret =3D 0;
>  	if (iowq->timeout =3D=3D KTIME_MAX)
>  		schedule();
>  	else if (!schedule_hrtimeout(&iowq->timeout, HRTIMER_MODE_ABS))
> -		return -ETIME;
> -	return 0;
> +		ret =3D -ETIME;
> +	io_schedule_finish(token);
> +	return ret;
>  }
> =20
>  /*

Reportedly, this caused a regression as reported in [1] [2] [3]. Not only v=
6.4.4 is affected, v6.1.39 is affected too.

Reverting this commit fixes the issue.

Please check.

Thanks.

[1] https://bbs.archlinux.org/viewtopic.php?id=3D287343
[2] https://bugzilla.kernel.org/show_bug.cgi?id=3D217700
[3] https://bugzilla.kernel.org/show_bug.cgi?id=3D217699

=2D-=20
Oleksandr Natalenko (post-factum)
--nextPart5695128.DvuYhMxLoT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEZUOOw5ESFLHZZtOKil/iNcg8M0sFAmS89V4ACgkQil/iNcg8
M0vYLA//Rm/Cq4E6nAwj8QoHK0QmrWbP6Fv1g26ZBjR6cFS9rU7wHylkgdfQoEcV
hVx7G8nkWrJfnPwD6j4X2kJE2dZmBLc8x/zWhbaM7Fhzvz/lGIQqc2LxdeWphVEO
tLGEzrF7MUTYacH0NF6uzgdPXSz5ulKIQrKrJzhVOkSmTaJJvaWL+JAYWjcSCYNr
x270YN705uQj5x8cWsb/vz68IPzMDzcQIv4v5ZBCCGVL1n++DG9MxhOzd8wFbfv0
CW4z03dEu0OEmBmHBldvJWqNsa/Oc3DPfakBUe3T0kJxRCColZop9PQGgTebK4qz
0Q5I49z8HXIuSZ48leAcGatwCPv5hBLpxvHAnRDn/GxYd/7XVgbwxHj6gyWyxeEe
EhCcMTWo14ZKLMR8rqjXcagbaAQiRNNCJRuaZlZQjqR0BWKRC4oSlb9HhEqpXrJe
rl9GXx03Hav2ACGnF1U7yatGEUdz3MPkMkBSRaKeY/S6DQKhfAVmhTy/I3lmi8n+
pca+EFglQNyF0foIR51F2ERtQVpILM0JzHg1dvImn1Z09PRfiT5PwbgUOuVmT3NH
gIlFxmdbTA/oxtIqWuxL7+ipC2zgq2H0Ggh9T45E8kUwbVAE/ZxO+/dTyFOo4pV1
UM29CR2RJ8O0AcHKQKrM9D8+mnjwaYpIGWo+IL9XJ9GggFop6Qc=
=H98+
-----END PGP SIGNATURE-----

--nextPart5695128.DvuYhMxLoT--



