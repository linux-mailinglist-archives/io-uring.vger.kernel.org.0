Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A0A7AE09C
	for <lists+io-uring@lfdr.de>; Mon, 25 Sep 2023 23:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjIYVTs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Sep 2023 17:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjIYVTr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Sep 2023 17:19:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5162310F
        for <io-uring@vger.kernel.org>; Mon, 25 Sep 2023 14:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695676734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sjbIZt/PW2FzwWrzcgpL9MX8MGpM8dB4UgR9ohho57s=;
        b=Ysi+AJ/H1sqIin/X0wU2HMPFuZf/92GTlGxZAnfgYwyU+JsenYlGdeSkl25pC30LHEt9UA
        l2dkNjBl4XkAzZN9MBrFXR/yc4w7za6iusUEwjUvGiF5Y9KBRxZ3xtxeJbdrAsVlV3uFg8
        fbRe6lgiQBGOFcEPNd7EyuHsEmz54jk=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-VVU9vKFBNsa0kL8oPRzKCQ-1; Mon, 25 Sep 2023 17:18:38 -0400
X-MC-Unique: VVU9vKFBNsa0kL8oPRzKCQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE19229AB415;
        Mon, 25 Sep 2023 21:17:12 +0000 (UTC)
Received: from localhost (unknown [10.39.194.68])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40C93140273D;
        Mon, 25 Sep 2023 21:17:12 +0000 (UTC)
Date:   Mon, 25 Sep 2023 17:17:10 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chengming Zhou <zhouchengming@bytedance.com>,
        virtualization@lists.linux-foundation.org, mst@redhat.com
Subject: Re: [PATCH V3] io_uring: fix IO hang in io_wq_put_and_exit from
 do_exit()
Message-ID: <20230925211710.GH323580@fedora>
References: <20230908093009.540763-1-ming.lei@redhat.com>
 <58227846-6b73-46ef-957f-d9b1e0451899@kernel.dk>
 <ZPsxCYFgZjIIeaBk@fedora>
 <0f85a6b5-3ba6-4b77-bb7d-79f365dbb44c@kernel.dk>
 <ZPs81IAYfB8J78Pv@fedora>
 <CACGkMEvP=f1mB=01CDOhHaDLNL9espKPrUffgHEdBVkW4fo=pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="HDPsBeSpl2khZZyk"
Content-Disposition: inline
In-Reply-To: <CACGkMEvP=f1mB=01CDOhHaDLNL9espKPrUffgHEdBVkW4fo=pw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--HDPsBeSpl2khZZyk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 15, 2023 at 03:04:05PM +0800, Jason Wang wrote:
> On Fri, Sep 8, 2023 at 11:25=E2=80=AFPM Ming Lei <ming.lei@redhat.com> wr=
ote:
> >
> > On Fri, Sep 08, 2023 at 08:44:45AM -0600, Jens Axboe wrote:
> > > On 9/8/23 8:34 AM, Ming Lei wrote:
> > > > On Fri, Sep 08, 2023 at 07:49:53AM -0600, Jens Axboe wrote:
> > > >> On 9/8/23 3:30 AM, Ming Lei wrote:
> > > >>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > > >>> index ad636954abae..95a3d31a1ef1 100644
> > > >>> --- a/io_uring/io_uring.c
> > > >>> +++ b/io_uring/io_uring.c
> > > >>> @@ -1930,6 +1930,10 @@ void io_wq_submit_work(struct io_wq_work *=
work)
> > > >>>           }
> > > >>>   }
> > > >>>
> > > >>> + /* It is fragile to block POLLED IO, so switch to NON_BLOCK */
> > > >>> + if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queu=
e)
> > > >>> +         issue_flags |=3D IO_URING_F_NONBLOCK;
> > > >>> +
> > > >>
> > > >> I think this comment deserves to be more descriptive. Normally we
> > > >> absolutely cannot block for polled IO, it's only OK here because i=
o-wq
> > > >
> > > > Yeah, we don't do that until commit 2bc057692599 ("block: don't mak=
e REQ_POLLED
> > > > imply REQ_NOWAIT") which actually push the responsibility/risk up to
> > > > io_uring.
> > > >
> > > >> is the issuer and not necessarily the poller of it. That generally=
 falls
> > > >> upon the original issuer to poll these requests.
> > > >>
> > > >> I think this should be a separate commit, coming before the main f=
ix
> > > >> which is below.
> > > >
> > > > Looks fine, actually IO_URING_F_NONBLOCK change isn't a must, and t=
he
> > > > approach in V2 doesn't need this change.
> > > >
> > > >>
> > > >>> @@ -3363,6 +3367,12 @@ __cold void io_uring_cancel_generic(bool c=
ancel_all, struct io_sq_data *sqd)
> > > >>>           finish_wait(&tctx->wait, &wait);
> > > >>>   } while (1);
> > > >>>
> > > >>> + /*
> > > >>> +  * Reap events from each ctx, otherwise these requests may take
> > > >>> +  * resources and prevent other contexts from being moved on.
> > > >>> +  */
> > > >>> + xa_for_each(&tctx->xa, index, node)
> > > >>> +         io_iopoll_try_reap_events(node->ctx);
> > > >>
> > > >> The main issue here is that if someone isn't polling for them, the=
n we
> > > >
> > > > That is actually what this patch is addressing, :-)
> > >
> > > Right, that part is obvious :)
> > >
> > > >> get to wait for a timeout before they complete. This can delay exi=
t, for
> > > >> example, as we're now just waiting 30 seconds (or whatever the tim=
eout
> > > >> is on the underlying device) for them to get timed out before exit=
 can
> > > >> finish.
> > > >
> > > > For the issue on null_blk, device timeout handler provides
> > > > forward-progress, such as requests are released, so new IO can be
> > > > handled.
> > > >
> > > > However, not all devices support timeout, such as virtio device.
> > >
> > > That's a bug in the driver, you cannot sanely support polled IO and n=
ot
> > > be able to deal with timeouts. Someone HAS to reap the requests and
> > > there are only two things that can do that - the application doing the
> > > polled IO, or if that doesn't happen, a timeout.
> >
> > OK, then device driver timeout handler has new responsibility of coveri=
ng
> > userspace accident, :-)

Sorry, I don't have enough context so this is probably a silly question:

When an application doesn't reap a polled request, why doesn't the block
layer take care of this in a generic way? I don't see anything
driver-specific about this.

Driver-specific behavior would be sending an abort/cancel upon timeout.
virtio-blk cannot do that because there is no such command in the device
specification at the moment. So simply waiting for the polled request to
complete is the only thing that can be done (aside from resetting the
device), and it's generic behavior.

Thanks,
Stefan

> >
> > We may document this requirement for driver.
> >
> > So far the only one should be virtio-blk, and the two virtio storage
> > drivers never implement timeout handler.
> >
>=20
> Adding Stefan for more comments.
>=20
> Thanks
>=20

--HDPsBeSpl2khZZyk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmUR+NYACgkQnKSrs4Gr
c8hthggAo7vnKS8HByNvkS1ugVClotOiaetq0qx9G2Zsn0tcVpMLqIFVlkGu/JEn
dQPdQvRynTp5Jl98V9I6XYHRrit5J3ZlnNG7QcHlwR83L6TGvieu2MyCfK8jxtJJ
r3xZKt3BX+Kl3b5iVPSFsTC5J7DV7IgysGUxooZxLCRiJuqH/QyiBWxriWZn/ffv
mPKR4tGhfcYlOVg5KxjIGeWhX7Q2Xd33TrkFAB++mnEeCxCFTGIMi0UMAWxp8rmb
UgjGQoyEHRyko1BICncTwPCySFxM0PEiHtUvSK9/XBqPYjYXHPyEBpIU3Xhf6KvO
6j6PqRghCqs5CXiteW0wBE1i05dClg==
=d074
-----END PGP SIGNATURE-----

--HDPsBeSpl2khZZyk--

