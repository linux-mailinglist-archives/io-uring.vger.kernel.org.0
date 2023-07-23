Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9B0F75E184
	for <lists+io-uring@lfdr.de>; Sun, 23 Jul 2023 12:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjGWK4z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Jul 2023 06:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjGWK4z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Jul 2023 06:56:55 -0400
X-Greylist: delayed 4613 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 23 Jul 2023 03:56:53 PDT
Received: from vulcan.natalenko.name (vulcan.natalenko.name [104.207.131.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1773CE5E;
        Sun, 23 Jul 2023 03:56:53 -0700 (PDT)
Received: from spock.localnet (unknown [94.142.239.106])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 8E69B1469946;
        Sun, 23 Jul 2023 12:56:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1690109807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ec8/Bt0MksyYMDCWUoM6BjObcBxYL4x8PlH6qLBKgs4=;
        b=rjmPHfGnLQ2Xeeg3GptQMxXu+U7/daHPaMHNmJa24J2pFCfB7+gMSN0FGSOhqL+BDymPvN
        43TL0eY5hX017zqHRLxlWo4gX4zbPR/XHTHFIWRmbcGh5NBdh5aEeFWf8BtRoPlFGG/BIz
        K4/juGaeUjARZMnC0lpJQ6KSim+sQOQ=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Freund <andres@anarazel.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 6.4 800/800] io_uring: Use io_schedule* in cqring wait
Date:   Sun, 23 Jul 2023 12:56:37 +0200
Message-ID: <4847260.31r3eYUQgx@natalenko.name>
In-Reply-To: <2023072310-superman-frosted-7321@gregkh>
References: <20230716194949.099592437@linuxfoundation.org>
 <12251678.O9o76ZdvQC@natalenko.name>
 <2023072310-superman-frosted-7321@gregkh>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4499511.LvFx2qVVIh";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

--nextPart4499511.LvFx2qVVIh
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; protected-headers="v1"
From: Oleksandr Natalenko <oleksandr@natalenko.name>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sun, 23 Jul 2023 12:56:37 +0200
Message-ID: <4847260.31r3eYUQgx@natalenko.name>
In-Reply-To: <2023072310-superman-frosted-7321@gregkh>
MIME-Version: 1.0

On ned=C4=9Ble 23. =C4=8Dervence 2023 12:50:30 CEST Greg Kroah-Hartman wrot=
e:
> On Sun, Jul 23, 2023 at 11:39:42AM +0200, Oleksandr Natalenko wrote:
> > Hello.
> >=20
> > On ned=C4=9Ble 16. =C4=8Dervence 2023 21:50:53 CEST Greg Kroah-Hartman =
wrote:
> > > From: Andres Freund <andres@anarazel.de>
> > >=20
> > > commit 8a796565cec3601071cbbd27d6304e202019d014 upstream.
> > >=20
> > > I observed poor performance of io_uring compared to synchronous IO. T=
hat
> > > turns out to be caused by deeper CPU idle states entered with io_urin=
g,
> > > due to io_uring using plain schedule(), whereas synchronous IO uses
> > > io_schedule().
> > >=20
> > > The losses due to this are substantial. On my cascade lake workstatio=
n,
> > > t/io_uring from the fio repository e.g. yields regressions between 20%
> > > and 40% with the following command:
> > > ./t/io_uring -r 5 -X0 -d 1 -s 1 -c 1 -p 0 -S$use_sync -R 0 /mnt/t2/fi=
o/write.0.0
> > >=20
> > > This is repeatable with different filesystems, using raw block devices
> > > and using different block devices.
> > >=20
> > > Use io_schedule_prepare() / io_schedule_finish() in
> > > io_cqring_wait_schedule() to address the difference.
> > >=20
> > > After that using io_uring is on par or surpassing synchronous IO (usi=
ng
> > > registered files etc makes it reliably win, but arguably is a less fa=
ir
> > > comparison).
> > >=20
> > > There are other calls to schedule() in io_uring/, but none immediately
> > > jump out to be similarly situated, so I did not touch them. Similarly,
> > > it's possible that mutex_lock_io() should be used, but it's not clear=
 if
> > > there are cases where that matters.
> > >=20
> > > Cc: stable@vger.kernel.org # 5.10+
> > > Cc: Pavel Begunkov <asml.silence@gmail.com>
> > > Cc: io-uring@vger.kernel.org
> > > Cc: linux-kernel@vger.kernel.org
> > > Signed-off-by: Andres Freund <andres@anarazel.de>
> > > Link: https://lore.kernel.org/r/20230707162007.194068-1-andres@anaraz=
el.de
> > > [axboe: minor style fixup]
> > > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > ---
> > >  io_uring/io_uring.c |   15 +++++++++++++--
> > >  1 file changed, 13 insertions(+), 2 deletions(-)
> > >=20
> > > --- a/io_uring/io_uring.c
> > > +++ b/io_uring/io_uring.c
> > > @@ -2575,6 +2575,8 @@ int io_run_task_work_sig(struct io_ring_
> > >  static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
> > >  					  struct io_wait_queue *iowq)
> > >  {
> > > +	int token, ret;
> > > +
> > >  	if (unlikely(READ_ONCE(ctx->check_cq)))
> > >  		return 1;
> > >  	if (unlikely(!llist_empty(&ctx->work_llist)))
> > > @@ -2585,11 +2587,20 @@ static inline int io_cqring_wait_schedul
> > >  		return -EINTR;
> > >  	if (unlikely(io_should_wake(iowq)))
> > >  		return 0;
> > > +
> > > +	/*
> > > +	 * Use io_schedule_prepare/finish, so cpufreq can take into account
> > > +	 * that the task is waiting for IO - turns out to be important for =
low
> > > +	 * QD IO.
> > > +	 */
> > > +	token =3D io_schedule_prepare();
> > > +	ret =3D 0;
> > >  	if (iowq->timeout =3D=3D KTIME_MAX)
> > >  		schedule();
> > >  	else if (!schedule_hrtimeout(&iowq->timeout, HRTIMER_MODE_ABS))
> > > -		return -ETIME;
> > > -	return 0;
> > > +		ret =3D -ETIME;
> > > +	io_schedule_finish(token);
> > > +	return ret;
> > >  }
> > > =20
> > >  /*
> >=20
> > Reportedly, this caused a regression as reported in [1] [2] [3]. Not on=
ly v6.4.4 is affected, v6.1.39 is affected too.
> >=20
> > Reverting this commit fixes the issue.
> >=20
> > Please check.
>=20
> Is this also an issue in 6.5-rc2?

As per [1], yes.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=3D217699#c4

>=20
> thanks,
>=20
> greg k-h
>=20


=2D-=20
Oleksandr Natalenko (post-factum)
--nextPart4499511.LvFx2qVVIh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEZUOOw5ESFLHZZtOKil/iNcg8M0sFAmS9B2UACgkQil/iNcg8
M0t3jA//UGeNRI4zGXOBcNBqKEugB/rXG1DyEoejAj8xD5afm9afoqR9U7YvWqrs
nJ88PAA+oQgkQXAbQF6zEc0M5IH8TG9KN1gFEO2KWsHsJPcpgGKqxdQRcH+RglTg
lxbIQHm56xx5rENz0KMP41pF3PMe7tE1xvKqoRTIblYaQvhMWYId/JNJ3DdxJ1iL
+jBegEGGmnphio4QskRQCZMQyumY5HBbpaD6eQtrsGzejy3FkqD0W9PtoQLzNExR
w3WErlNekYori4c5doeTyv020Pt6EE8kHQr/r5hqeKSALVvN90HsHlvKsbnXSsU2
91GKTQsZSVZlw8tV3zWRVQTpHH4i/bdhdpDANIsJHN4chPnCXK0WszX67UFdpYMM
NqaJdAqo+sWINtD/HdGHoCzMZ2xt0o3vk9P6gIRScLapFAyrxUjMt1kYWkeS+A17
QfDjftV8MEP/v1NxrTNMCGd7ap+JpvF6guW/z8kRjhPukYVC8v19EjqFkDLB05TY
3SckSZTwyQfGIfEFMMiOT0EHPXRQH+YrBL02yT7o005gBa5is7sC2fV8l+vV965M
LeI7z5YTlF2xFT+nb4CGs5m/gszI5NDdBCkVcZKwHpBk3zpjvCqKktm7kyKjfHen
pXkbVIohwXcZ97kG9uCdUXVv9KW5sAZ/oyDyqr1ku/YM6tbUZ84=
=O7Ua
-----END PGP SIGNATURE-----

--nextPart4499511.LvFx2qVVIh--



