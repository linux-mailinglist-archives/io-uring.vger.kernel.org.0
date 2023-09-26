Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1AF7AF069
	for <lists+io-uring@lfdr.de>; Tue, 26 Sep 2023 18:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235184AbjIZQPH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Sep 2023 12:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235189AbjIZQPG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Sep 2023 12:15:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC90127
        for <io-uring@vger.kernel.org>; Tue, 26 Sep 2023 09:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695744851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Expj9KdGU5UQzWCnX5PAuSPH6Fbb8WCnKutwu5N8eHI=;
        b=WE1TIbicEDL6G32ipDAikLsrPwBj1PqbhaOCb701vwwTwPTphi2uMwh7JGUKWRtFtDfLxK
        sgzjU7mwe/O2XoZA1vo0zgongFYEfpUV4xvaMeF6RzScL3m1U97U2oHu3vZzQFu1onYh4o
        ApyILd3WWZypEKMYP7jw21D7q6yVxL8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-641-cUN4MP7ZMueIJqqFxc4B6A-1; Tue, 26 Sep 2023 12:14:08 -0400
X-MC-Unique: cUN4MP7ZMueIJqqFxc4B6A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7363F801779;
        Tue, 26 Sep 2023 16:14:07 +0000 (UTC)
Received: from localhost (unknown [10.39.192.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F5C540C2064;
        Tue, 26 Sep 2023 16:14:06 +0000 (UTC)
Date:   Tue, 26 Sep 2023 10:55:26 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Ming Lei <ming.lei@redhat.com>, Suwan Kim <suwan.kim027@gmail.com>
Cc:     Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chengming Zhou <zhouchengming@bytedance.com>,
        virtualization@lists.linux-foundation.org, mst@redhat.com
Subject: Re: [PATCH V3] io_uring: fix IO hang in io_wq_put_and_exit from
 do_exit()
Message-ID: <20230926145526.GA387951@fedora>
References: <20230908093009.540763-1-ming.lei@redhat.com>
 <58227846-6b73-46ef-957f-d9b1e0451899@kernel.dk>
 <ZPsxCYFgZjIIeaBk@fedora>
 <0f85a6b5-3ba6-4b77-bb7d-79f365dbb44c@kernel.dk>
 <ZPs81IAYfB8J78Pv@fedora>
 <CACGkMEvP=f1mB=01CDOhHaDLNL9espKPrUffgHEdBVkW4fo=pw@mail.gmail.com>
 <20230925211710.GH323580@fedora>
 <ZRIzr6C8tHM2N4Ng@fedora>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rd/ih7ZpJJDBDoHt"
Content-Disposition: inline
In-Reply-To: <ZRIzr6C8tHM2N4Ng@fedora>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--rd/ih7ZpJJDBDoHt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 26, 2023 at 09:28:15AM +0800, Ming Lei wrote:
> On Mon, Sep 25, 2023 at 05:17:10PM -0400, Stefan Hajnoczi wrote:
> > On Fri, Sep 15, 2023 at 03:04:05PM +0800, Jason Wang wrote:
> > > On Fri, Sep 8, 2023 at 11:25=E2=80=AFPM Ming Lei <ming.lei@redhat.com=
> wrote:
> > > >
> > > > On Fri, Sep 08, 2023 at 08:44:45AM -0600, Jens Axboe wrote:
> > > > > On 9/8/23 8:34 AM, Ming Lei wrote:
> > > > > > On Fri, Sep 08, 2023 at 07:49:53AM -0600, Jens Axboe wrote:
> > > > > >> On 9/8/23 3:30 AM, Ming Lei wrote:
> > > > > >>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > > > > >>> index ad636954abae..95a3d31a1ef1 100644
> > > > > >>> --- a/io_uring/io_uring.c
> > > > > >>> +++ b/io_uring/io_uring.c
> > > > > >>> @@ -1930,6 +1930,10 @@ void io_wq_submit_work(struct io_wq_wo=
rk *work)
> > > > > >>>           }
> > > > > >>>   }
> > > > > >>>
> > > > > >>> + /* It is fragile to block POLLED IO, so switch to NON_BLOCK=
 */
> > > > > >>> + if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_=
queue)
> > > > > >>> +         issue_flags |=3D IO_URING_F_NONBLOCK;
> > > > > >>> +
> > > > > >>
> > > > > >> I think this comment deserves to be more descriptive. Normally=
 we
> > > > > >> absolutely cannot block for polled IO, it's only OK here becau=
se io-wq
> > > > > >
> > > > > > Yeah, we don't do that until commit 2bc057692599 ("block: don't=
 make REQ_POLLED
> > > > > > imply REQ_NOWAIT") which actually push the responsibility/risk =
up to
> > > > > > io_uring.
> > > > > >
> > > > > >> is the issuer and not necessarily the poller of it. That gener=
ally falls
> > > > > >> upon the original issuer to poll these requests.
> > > > > >>
> > > > > >> I think this should be a separate commit, coming before the ma=
in fix
> > > > > >> which is below.
> > > > > >
> > > > > > Looks fine, actually IO_URING_F_NONBLOCK change isn't a must, a=
nd the
> > > > > > approach in V2 doesn't need this change.
> > > > > >
> > > > > >>
> > > > > >>> @@ -3363,6 +3367,12 @@ __cold void io_uring_cancel_generic(bo=
ol cancel_all, struct io_sq_data *sqd)
> > > > > >>>           finish_wait(&tctx->wait, &wait);
> > > > > >>>   } while (1);
> > > > > >>>
> > > > > >>> + /*
> > > > > >>> +  * Reap events from each ctx, otherwise these requests may =
take
> > > > > >>> +  * resources and prevent other contexts from being moved on.
> > > > > >>> +  */
> > > > > >>> + xa_for_each(&tctx->xa, index, node)
> > > > > >>> +         io_iopoll_try_reap_events(node->ctx);
> > > > > >>
> > > > > >> The main issue here is that if someone isn't polling for them,=
 then we
> > > > > >
> > > > > > That is actually what this patch is addressing, :-)
> > > > >
> > > > > Right, that part is obvious :)
> > > > >
> > > > > >> get to wait for a timeout before they complete. This can delay=
 exit, for
> > > > > >> example, as we're now just waiting 30 seconds (or whatever the=
 timeout
> > > > > >> is on the underlying device) for them to get timed out before =
exit can
> > > > > >> finish.
> > > > > >
> > > > > > For the issue on null_blk, device timeout handler provides
> > > > > > forward-progress, such as requests are released, so new IO can =
be
> > > > > > handled.
> > > > > >
> > > > > > However, not all devices support timeout, such as virtio device.
> > > > >
> > > > > That's a bug in the driver, you cannot sanely support polled IO a=
nd not
> > > > > be able to deal with timeouts. Someone HAS to reap the requests a=
nd
> > > > > there are only two things that can do that - the application doin=
g the
> > > > > polled IO, or if that doesn't happen, a timeout.
> > > >
> > > > OK, then device driver timeout handler has new responsibility of co=
vering
> > > > userspace accident, :-)
> >=20
> > Sorry, I don't have enough context so this is probably a silly question:
> >=20
> > When an application doesn't reap a polled request, why doesn't the block
> > layer take care of this in a generic way? I don't see anything
> > driver-specific about this.
>=20
> block layer doesn't have knowledge to handle that, io_uring knows the
> application is exiting, and can help to reap the events.

I thought the discussion was about I/O timeouts in general but here
you're only mentioning application exit. Are we talking about I/O
timeouts or purely about cleaning up I/O requests when an application
exits?

>=20
> But the big question is that if there is really IO timeout for virtio-blk.
> If there is, the reap done in io_uring may never return and cause other
> issue, so if it is done in io_uring, that can be just thought as sort of
> improvement.

virtio-blk drivers have no way of specifying timeouts on the device or
aborting/canceling requests.

virtio-blk devices may fail requests if they implement an internal
timeout mechanism (e.g. the host kernel fails requests after a host
timeout), but this is not controlled by the driver and there is no
guarantee that the device has an internal timeout. The driver will not
treat these timed out requests in a special way - the application will
see EIO errors.

>=20
> The real bug fix is still in device driver, usually only the driver timeo=
ut
> handler can provide forward progress guarantee.

The only recourse for hung I/O on a virtio-blk device is device reset,
but that is often implemented as a synchronous operation and is likely
to block until in-flight I/O finishes.

An admin virtqueue could be added to virtio-blk along with an abort
command, but existing devices will not support the new hardware
interface.

However, I'm not sure a new abort command would solve the problem.
virtio-blk devices are often implemented as userspace processes and are
limited by the availability of I/O cancellation APIs. Maybe my
understanding is outdated, but I believe userspace processes cannot
force I/O to abort. For example, the man page says the following for
IORING_OP_ASYNC_CANCEL:

  In general, requests that are interruptible (like socket IO) will get
  canceled, while disk IO requests cannot be canceled if already
  started.

Even if an abort command is added to virtio-blk, won't we just end up in
this situation:
1. The guest kernel invokes ->timeout() on virtio_blk.ko.
2. virtio_blk.ko sends an abort command to the device and resets the
   timeout.
3. The device submits IORING_OP_ASYNC_CANCEL but it cannot cancel an
   in-flight disk I/O request.
4. ...time passes...
5. The guest kernel invokes ->timeout() again and virtio_blk.ko decides
   abort was ineffective. The entire device must be reset.
?

(I based this on the ->timeout() logic in the nvme driver.)

If we're effectively just going to wait for twice the timeout duration
and then reset the device, then why go through the trouble of sending
the abort command? I'm hoping you'll tell me that IORING_OP_ASYNC_CANCEL
is in fact able to cancel disk I/O nowadays :).

>=20
> >=20
> > Driver-specific behavior would be sending an abort/cancel upon timeout.
> > virtio-blk cannot do that because there is no such command in the device
> > specification at the moment. So simply waiting for the polled request to
> > complete is the only thing that can be done (aside from resetting the
> > device), and it's generic behavior.
>=20
> Then looks not safe to support IO polling for virtio-blk, maybe disable it
> at default now until the virtio-blk spec starts to support IO abort?

The virtio_blk.ko poll_queues module parameter is already set to 0 by
default. Poll queues are only available when the user has explicitly set
the module parameter.

I have added Suwan Kim to the email thread. Suwan Kim added poll queue
support to the virtio-blk driver and may have a preference for how to
proceed.

Stefan

--rd/ih7ZpJJDBDoHt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmUS8N4ACgkQnKSrs4Gr
c8hWmgf/fD3DZcd+L6dOVkhoxLktiDsXa1YuXrbUUX/SxuNNEBqs13rtQqt7ZsK2
Q6JuURAdhVOwnq/yNZ7m8OAFEW9chwJU6XexG9ZCuRdrH+weEOFsHZYT0sp07vCb
C2GmsIkoEIaTPplPKJ//2TCh+Ag1N3FFHgZQ34IDJS/+9In+uDHt23JPS7Pp34OL
z7AZVp8lOmSapW4HpoextIwBF+l0BzsEmW5VNsWWqr6kM2dnzvC3pbqTffGcWs09
2AsgcTL/zKJNw77UzddLHVxssPd3KHYaY5YYdJKvwujkzr/m4iqj4z5VWJGWCSqi
8WOa0LVA2GGcDVmkQ8OnbpItjoWh2w==
=WLJs
-----END PGP SIGNATURE-----

--rd/ih7ZpJJDBDoHt--

