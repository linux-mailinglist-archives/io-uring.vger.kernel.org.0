Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25186B4D64
	for <lists+io-uring@lfdr.de>; Fri, 10 Mar 2023 17:43:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbjCJQnp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Mar 2023 11:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjCJQnX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Mar 2023 11:43:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA93512EAE8
        for <io-uring@vger.kernel.org>; Fri, 10 Mar 2023 08:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678466365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QvnhRZFpk2sth3MDGO6CST7Tb6uuODyGE42lafipff4=;
        b=FD+xYDZ3avYWQVAZeRBeB3smbR4M1WWjuGjPhBJodQY4zqySx+4Yi2h8J++xfu+a+2wif4
        R2mbXYqqFRnhbyAjabUis8EuWydk/Vo2fMaKNh0LFO1vPCv1oQZ495vaJ7mODYJkGraUan
        QFtWIrIg4NmHDACirFVpVj/pFBNk73E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-248-yEL4FFPWPQeSVwaPAvSt9g-1; Fri, 10 Mar 2023 11:39:24 -0500
X-MC-Unique: yEL4FFPWPQeSVwaPAvSt9g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA0EF857A93;
        Fri, 10 Mar 2023 16:39:23 +0000 (UTC)
Received: from localhost (unknown [10.39.192.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 37DF62026D68;
        Fri, 10 Mar 2023 16:39:22 +0000 (UTC)
Date:   Fri, 10 Mar 2023 11:39:21 -0500
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: Resizing io_uring SQ/CQ?
Message-ID: <20230310163921.GA484401@fedora>
References: <20230309134808.GA374376@fedora>
 <ZAqKDen5HtSGSXzd@ovpn-8-16.pek2.redhat.com>
 <2f928d56-a2ff-39ef-f7ae-b6cc1da4fc42@kernel.dk>
 <20230310134400.GB464073@fedora>
 <ZAtJPG3NDCbhAvZ7@ovpn-8-16.pek2.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="kU9XcM+Ihck4v0eo"
Content-Disposition: inline
In-Reply-To: <ZAtJPG3NDCbhAvZ7@ovpn-8-16.pek2.redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--kU9XcM+Ihck4v0eo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 10, 2023 at 11:14:04PM +0800, Ming Lei wrote:
> On Fri, Mar 10, 2023 at 08:44:00AM -0500, Stefan Hajnoczi wrote:
> > On Thu, Mar 09, 2023 at 07:58:31PM -0700, Jens Axboe wrote:
> > > On 3/9/23 6:38?PM, Ming Lei wrote:
> > > > On Thu, Mar 09, 2023 at 08:48:08AM -0500, Stefan Hajnoczi wrote:
> > > >> Hi,
> > > >> For block I/O an application can queue excess SQEs in userspace wh=
en the
> > > >> SQ ring becomes full. For network and IPC operations that is not
> > > >> possible because deadlocks can occur when socket, pipe, and eventf=
d SQEs
> > > >> cannot be submitted.
> > > >=20
> > > > Can you explain a bit the deadlock in case of network application? =
io_uring
> > > > does support to queue many network SQEs via IOSQE_IO_LINK, at least=
 for
> > > > send.
> > > >=20
> > > >>
> > > >> Sometimes the application does not know how many SQEs/CQEs are nee=
ded upfront
> > > >> and that's when we face this challenge.
> > > >=20
> > > > When running out of SQEs,  the application can call io_uring_enter(=
) to submit
> > > > queued SQEs immediately without waiting for get events, then once
> > > > io_uring_enter() returns, you get free SQEs for moving one.
> > > >=20
> > > >>
> > > >> A simple solution is to call io_uring_setup(2) with a higher entri=
es
> > > >> value than you'll ever need. However, if that value is exceeded th=
en
> > > >> we're back to the deadlock scenario and that worries me.
> > > >=20
> > > > Can you please explain the deadlock scenario?
> > >=20
> > > I'm also curious of what these deadlocks are. As Ming says, you
> > > generally never run out of SQEs as you can always just submit what you
> > > have pending and now you have a full queue size worth of them availab=
le
> > > again.
> > >=20
> > > I do think resizing the CQ ring may have some merit, as for networking
> > > you may want to start smaller and resize it if you run into overflows=
 as
> > > those will be less efficient. But I'm somewhat curious on the reasoni=
ngs
> > > for wanting to resize the SQ ring?
> >=20
> > Hi Ming and Jens,
> > Thanks for the response. I'll try to explain why I worry about
> > deadlocks.
> >=20
> > Imagine an application has an I/O operation that must complete in order
> > to make progress. If io_uring_enter(2) fails then the application is
> > unable to submit that critical I/O.
> >=20
> > The io_uring_enter(2) man page says:
> >=20
> >   EBUSY  If  the IORING_FEAT_NODROP feature flag is set, then EBUSY will
> > 	 be returned if there were overflow entries,
> > 	 IORING_ENTER_GETEVENTS flag is set and not all of the overflow
> > 	 entries were able to be flushed to the CQ ring.
> >=20
> > 	 Without IORING_FEAT_NODROP the application is attempting to
> > 	 overcommit the number of requests it can have pending. The
> > 	 application should wait for some completions and try again. May
> > 	 occur if the application tries to queue more requests than we
> > 	 have room for in the CQ ring, or if the application attempts to
> > 	 wait for more events without having reaped the ones already
> > 	 present in the CQ ring.
> >=20
> > Some I/O operations can take forever (e.g. reading an eventfd), so there
> > is no guarantee that the I/Os already in flight will complete. If in
> > flight I/O operations accumulate to the point where io_uring_enter(2)
> > returns with EBUSY then the application is starved and unable to submit
>=20
> The man page said clearly that EBUSY will be returned if there were overf=
low
> CQE entries. But here, no in-flight IOs are completed and no CQEs actuall=
y in
> CQ ring, so how can the -EBUSY be triggered?
>=20
> Also I don't see any words about the following description:
>=20
> 	-EBUSY will be returned if many enough in-flight IOs are accumulated,
>=20
> So care to explain it a bit?

Thanks, Ming. I think it's because I wasn't considering IORING_FEAT_NODROP!

Can you confirm that io_uring_enter() with IORING_FEAT_NODROP always
succeeds in submitting more requests (except for out-of-memory) provided
the application keeps consuming the CQ ring? If yes, then
IORING_FEAT_NODROP solves the issue on Linux 5.5 and later.

Regarding the non-IORING_FEAT_NODROP case, I think the deadlock issue
exists:

  Without IORING_FEAT_NODROP the application is attempting to overcommit
  the number of requests it can have pending.

A general statement that does not mention the CQ ring.

  The application should wait for some completions and try again.

Doesn't help in the deadlock scenario because we must submit one more
I/O in order for existing I/Os to start completing.

  May occur if the application tries to queue more requests than we
  have room for in the CQ ring,

I interpreted this to mean that once there are cq_entries I/Os in
flight, then io_uring_enter(2) may return with EBUSY if you attempt to
submit more I/Os. Is that right?

  or if the application attempts to wait for more events without having
  reaped the ones already present in the CQ ring.

This doesn't apply to the deadlock scenario.

Stefan

--kU9XcM+Ihck4v0eo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmQLXTkACgkQnKSrs4Gr
c8jUSgf/e3rjSEyKc1vzAKZAmEGeTuIUKSJP/yh8STRYyz9E7HS++shJJxuSaRQR
QMA425GUXxriuOtnBmtIucAUgz7P8fU9CDQWW3gBeQvbxWlJYjwetgMOiG9ORQQT
7g1S/zgegWLZ/ESFqV1iGw4iTeOJrLl3oHHM+WCa6dVyCnI1tdWMcNBGtw6try2K
1bMk+TgqdfZtIHa14iyYuajXO+WnvNjUFNLQ+gz5NtNfvUXpr+bxDZbKTcCZDWqj
eZDYk7L4tnbXy2QkgTLhPaLxiR+B3eIPLsuMbVe1HHF7f/dpyrFwsAL5UNIj3a4t
41vqw94hBWWWCTByDWMWkfHoZh7uEg==
=dJx/
-----END PGP SIGNATURE-----

--kU9XcM+Ihck4v0eo--

