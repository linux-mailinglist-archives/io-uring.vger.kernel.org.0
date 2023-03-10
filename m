Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D026B40AE
	for <lists+io-uring@lfdr.de>; Fri, 10 Mar 2023 14:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjCJNo6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 10 Mar 2023 08:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230189AbjCJNox (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 10 Mar 2023 08:44:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A760977E07
        for <io-uring@vger.kernel.org>; Fri, 10 Mar 2023 05:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678455846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3hwAO0ex5pH6WSJUEZrM4DJzuRb2dbD+vIbVK1S/dZo=;
        b=VgrM4BBod5H5m+6xFyw/tdXvY9UQ/F2mS32plZh6r1g2w2Ybt5342uLCPnqI2KPL3ervqP
        7GxFNoYaTzdmmHVKyvqYDOhMlq0MDNZxLv7NrCv/oO8k/Cwcac5lBGQw36+4JciqSfPZSh
        ske0v7v0zSaU7A5/T0p7jQIAVGuxCrE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-3o0z0y6aP8OTokXWiAYwMw-1; Fri, 10 Mar 2023 08:44:03 -0500
X-MC-Unique: 3o0z0y6aP8OTokXWiAYwMw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7D08811E9C;
        Fri, 10 Mar 2023 13:44:02 +0000 (UTC)
Received: from localhost (unknown [10.39.194.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40E472026D4B;
        Fri, 10 Mar 2023 13:44:01 +0000 (UTC)
Date:   Fri, 10 Mar 2023 08:44:00 -0500
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org
Subject: Re: Resizing io_uring SQ/CQ?
Message-ID: <20230310134400.GB464073@fedora>
References: <20230309134808.GA374376@fedora>
 <ZAqKDen5HtSGSXzd@ovpn-8-16.pek2.redhat.com>
 <2f928d56-a2ff-39ef-f7ae-b6cc1da4fc42@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qz8FYyDSsUGsXWB9"
Content-Disposition: inline
In-Reply-To: <2f928d56-a2ff-39ef-f7ae-b6cc1da4fc42@kernel.dk>
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


--qz8FYyDSsUGsXWB9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 09, 2023 at 07:58:31PM -0700, Jens Axboe wrote:
> On 3/9/23 6:38?PM, Ming Lei wrote:
> > On Thu, Mar 09, 2023 at 08:48:08AM -0500, Stefan Hajnoczi wrote:
> >> Hi,
> >> For block I/O an application can queue excess SQEs in userspace when t=
he
> >> SQ ring becomes full. For network and IPC operations that is not
> >> possible because deadlocks can occur when socket, pipe, and eventfd SQ=
Es
> >> cannot be submitted.
> >=20
> > Can you explain a bit the deadlock in case of network application? io_u=
ring
> > does support to queue many network SQEs via IOSQE_IO_LINK, at least for
> > send.
> >=20
> >>
> >> Sometimes the application does not know how many SQEs/CQEs are needed =
upfront
> >> and that's when we face this challenge.
> >=20
> > When running out of SQEs,  the application can call io_uring_enter() to=
 submit
> > queued SQEs immediately without waiting for get events, then once
> > io_uring_enter() returns, you get free SQEs for moving one.
> >=20
> >>
> >> A simple solution is to call io_uring_setup(2) with a higher entries
> >> value than you'll ever need. However, if that value is exceeded then
> >> we're back to the deadlock scenario and that worries me.
> >=20
> > Can you please explain the deadlock scenario?
>=20
> I'm also curious of what these deadlocks are. As Ming says, you
> generally never run out of SQEs as you can always just submit what you
> have pending and now you have a full queue size worth of them available
> again.
>=20
> I do think resizing the CQ ring may have some merit, as for networking
> you may want to start smaller and resize it if you run into overflows as
> those will be less efficient. But I'm somewhat curious on the reasonings
> for wanting to resize the SQ ring?

Hi Ming and Jens,
Thanks for the response. I'll try to explain why I worry about
deadlocks.

Imagine an application has an I/O operation that must complete in order
to make progress. If io_uring_enter(2) fails then the application is
unable to submit that critical I/O.

The io_uring_enter(2) man page says:

  EBUSY  If  the IORING_FEAT_NODROP feature flag is set, then EBUSY will
	 be returned if there were overflow entries,
	 IORING_ENTER_GETEVENTS flag is set and not all of the overflow
	 entries were able to be flushed to the CQ ring.

	 Without IORING_FEAT_NODROP the application is attempting to
	 overcommit the number of requests it can have pending. The
	 application should wait for some completions and try again. May
	 occur if the application tries to queue more requests than we
	 have room for in the CQ ring, or if the application attempts to
	 wait for more events without having reaped the ones already
	 present in the CQ ring.

Some I/O operations can take forever (e.g. reading an eventfd), so there
is no guarantee that the I/Os already in flight will complete. If in
flight I/O operations accumulate to the point where io_uring_enter(2)
returns with EBUSY then the application is starved and unable to submit
more I/O.

Starvation turns into a deadlock when the completion of the already in
flight I/O depends on the yet-to-be-submitted I/O. For example, the
application is supposed to write to a socket and another process will
then signal the eventfd that the application is reading, but we're
unable to submit the write.

I asked about resizing the rings because if we can size them
appropriately, then we can ensure there are sufficient resources for all
I/Os that will be in flight. This prevents EBUSY, starvation, and
deadlock.

Maybe I've misunderstood the man page?

Stefan

--qz8FYyDSsUGsXWB9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmQLNCAACgkQnKSrs4Gr
c8gfNQf+KQFlUg2k3ATnnC6ohAaA9+qZslMYlZQcuhqL2hyprl5P2Egq3aB+NIdn
IqCTPHLKD/D0oIjWLFH9NcOSwIsAeLvxQR/81M+AgpLsgNqYltLY2suueUVmkp7W
IKaNKg2B09rjGwzeRHkISkPGvJFlf+EJuiZ+7G23e7m+66evS6Pb17Y2HR4RqUaG
tWusV9UHTanytvDs3TzQOA1+T1rwPSvpt4Aot0wGaF3vVn4yAafFc6ndMrvFsEJI
rjPzM/EgyJ2vmP3nKWzM6CC1Z6OGAMl8dS0uUvEU8sNiFFfGirX3fb07rpmYJRue
b4yqk1EIWyeHJr4Wg81HzX1rJxNsgg==
=KI3a
-----END PGP SIGNATURE-----

--qz8FYyDSsUGsXWB9--

