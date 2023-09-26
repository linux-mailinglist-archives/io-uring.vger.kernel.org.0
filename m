Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A587B7AE356
	for <lists+io-uring@lfdr.de>; Tue, 26 Sep 2023 03:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbjIZB3W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Sep 2023 21:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjIZB3W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Sep 2023 21:29:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7971101
        for <io-uring@vger.kernel.org>; Mon, 25 Sep 2023 18:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695691711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6OhGiNLvBNZEMFqnuOuRobxprn9JRSs+NH5J7h+1BKk=;
        b=VuuTWpNW9UjxBSHWXWxtbJo3z1CAEgJA4+ceTTMHDiJ5xGcIL+23VOym1NwTdO6p92rIXM
        Gt6L9lPJA0CkIjSSNys56y4ykwL3Z0ARJ1IkhIzdUkLl0T9uLCZfK6xzQ5YO7AYB85pe/g
        JwauaZYEL5FAS2eYjyoiFR1akQy8opI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-OlB2hctWPDSKeJr00OCXww-1; Mon, 25 Sep 2023 21:28:26 -0400
X-MC-Unique: OlB2hctWPDSKeJr00OCXww-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B0DD800962;
        Tue, 26 Sep 2023 01:28:26 +0000 (UTC)
Received: from fedora (unknown [10.72.120.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1596B1678B;
        Tue, 26 Sep 2023 01:28:19 +0000 (UTC)
Date:   Tue, 26 Sep 2023 09:28:15 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chengming Zhou <zhouchengming@bytedance.com>,
        virtualization@lists.linux-foundation.org, mst@redhat.com,
        ming.lei@redhat.com
Subject: Re: [PATCH V3] io_uring: fix IO hang in io_wq_put_and_exit from
 do_exit()
Message-ID: <ZRIzr6C8tHM2N4Ng@fedora>
References: <20230908093009.540763-1-ming.lei@redhat.com>
 <58227846-6b73-46ef-957f-d9b1e0451899@kernel.dk>
 <ZPsxCYFgZjIIeaBk@fedora>
 <0f85a6b5-3ba6-4b77-bb7d-79f365dbb44c@kernel.dk>
 <ZPs81IAYfB8J78Pv@fedora>
 <CACGkMEvP=f1mB=01CDOhHaDLNL9espKPrUffgHEdBVkW4fo=pw@mail.gmail.com>
 <20230925211710.GH323580@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230925211710.GH323580@fedora>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 25, 2023 at 05:17:10PM -0400, Stefan Hajnoczi wrote:
> On Fri, Sep 15, 2023 at 03:04:05PM +0800, Jason Wang wrote:
> > On Fri, Sep 8, 2023 at 11:25 PM Ming Lei <ming.lei@redhat.com> wrote:
> > >
> > > On Fri, Sep 08, 2023 at 08:44:45AM -0600, Jens Axboe wrote:
> > > > On 9/8/23 8:34 AM, Ming Lei wrote:
> > > > > On Fri, Sep 08, 2023 at 07:49:53AM -0600, Jens Axboe wrote:
> > > > >> On 9/8/23 3:30 AM, Ming Lei wrote:
> > > > >>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > > > >>> index ad636954abae..95a3d31a1ef1 100644
> > > > >>> --- a/io_uring/io_uring.c
> > > > >>> +++ b/io_uring/io_uring.c
> > > > >>> @@ -1930,6 +1930,10 @@ void io_wq_submit_work(struct io_wq_work *work)
> > > > >>>           }
> > > > >>>   }
> > > > >>>
> > > > >>> + /* It is fragile to block POLLED IO, so switch to NON_BLOCK */
> > > > >>> + if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
> > > > >>> +         issue_flags |= IO_URING_F_NONBLOCK;
> > > > >>> +
> > > > >>
> > > > >> I think this comment deserves to be more descriptive. Normally we
> > > > >> absolutely cannot block for polled IO, it's only OK here because io-wq
> > > > >
> > > > > Yeah, we don't do that until commit 2bc057692599 ("block: don't make REQ_POLLED
> > > > > imply REQ_NOWAIT") which actually push the responsibility/risk up to
> > > > > io_uring.
> > > > >
> > > > >> is the issuer and not necessarily the poller of it. That generally falls
> > > > >> upon the original issuer to poll these requests.
> > > > >>
> > > > >> I think this should be a separate commit, coming before the main fix
> > > > >> which is below.
> > > > >
> > > > > Looks fine, actually IO_URING_F_NONBLOCK change isn't a must, and the
> > > > > approach in V2 doesn't need this change.
> > > > >
> > > > >>
> > > > >>> @@ -3363,6 +3367,12 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
> > > > >>>           finish_wait(&tctx->wait, &wait);
> > > > >>>   } while (1);
> > > > >>>
> > > > >>> + /*
> > > > >>> +  * Reap events from each ctx, otherwise these requests may take
> > > > >>> +  * resources and prevent other contexts from being moved on.
> > > > >>> +  */
> > > > >>> + xa_for_each(&tctx->xa, index, node)
> > > > >>> +         io_iopoll_try_reap_events(node->ctx);
> > > > >>
> > > > >> The main issue here is that if someone isn't polling for them, then we
> > > > >
> > > > > That is actually what this patch is addressing, :-)
> > > >
> > > > Right, that part is obvious :)
> > > >
> > > > >> get to wait for a timeout before they complete. This can delay exit, for
> > > > >> example, as we're now just waiting 30 seconds (or whatever the timeout
> > > > >> is on the underlying device) for them to get timed out before exit can
> > > > >> finish.
> > > > >
> > > > > For the issue on null_blk, device timeout handler provides
> > > > > forward-progress, such as requests are released, so new IO can be
> > > > > handled.
> > > > >
> > > > > However, not all devices support timeout, such as virtio device.
> > > >
> > > > That's a bug in the driver, you cannot sanely support polled IO and not
> > > > be able to deal with timeouts. Someone HAS to reap the requests and
> > > > there are only two things that can do that - the application doing the
> > > > polled IO, or if that doesn't happen, a timeout.
> > >
> > > OK, then device driver timeout handler has new responsibility of covering
> > > userspace accident, :-)
> 
> Sorry, I don't have enough context so this is probably a silly question:
> 
> When an application doesn't reap a polled request, why doesn't the block
> layer take care of this in a generic way? I don't see anything
> driver-specific about this.

block layer doesn't have knowledge to handle that, io_uring knows the
application is exiting, and can help to reap the events.

But the big question is that if there is really IO timeout for virtio-blk.
If there is, the reap done in io_uring may never return and cause other
issue, so if it is done in io_uring, that can be just thought as sort of
improvement.

The real bug fix is still in device driver, usually only the driver timeout
handler can provide forward progress guarantee.

> 
> Driver-specific behavior would be sending an abort/cancel upon timeout.
> virtio-blk cannot do that because there is no such command in the device
> specification at the moment. So simply waiting for the polled request to
> complete is the only thing that can be done (aside from resetting the
> device), and it's generic behavior.

Then looks not safe to support IO polling for virtio-blk, maybe disable it
at default now until the virtio-blk spec starts to support IO abort?

Thanks,
Ming

