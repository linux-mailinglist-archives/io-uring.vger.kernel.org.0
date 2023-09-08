Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE7D7989F6
	for <lists+io-uring@lfdr.de>; Fri,  8 Sep 2023 17:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244553AbjIHP0s (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Sep 2023 11:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235484AbjIHP0r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Sep 2023 11:26:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FF11FEC
        for <io-uring@vger.kernel.org>; Fri,  8 Sep 2023 08:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694186722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NABqDGLYLNPmUxO0QILxeEybmyL7dFx39ewlk67l+44=;
        b=J0vZKRBa6nyIRtbO6Ym1demhVj/2uBTsiZI5WQmLvkKAl5FKtPjyQol6I6auTYzpkgQz/1
        imvAc/pFGrtInoTFthHD2r/9kOQxKRVmJeoyb2E+EBRMZ4WSvQvkK+ZblC+HlnpJn5F8qE
        64JqET7eQ6D/4vF1+ovJyRNBxrGUJMo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-3-GubM347jPU2THVRKaKEW6Q-1; Fri, 08 Sep 2023 11:25:19 -0400
X-MC-Unique: GubM347jPU2THVRKaKEW6Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3AB4880268A;
        Fri,  8 Sep 2023 15:25:19 +0000 (UTC)
Received: from fedora (unknown [10.72.120.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 59AAE403171;
        Fri,  8 Sep 2023 15:25:12 +0000 (UTC)
Date:   Fri, 8 Sep 2023 23:25:08 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chengming Zhou <zhouchengming@bytedance.com>,
        virtualization@lists.linux-foundation.org, mst@redhat.com,
        jasowang@redhat.com, ming.lei@redhat.com
Subject: Re: [PATCH V3] io_uring: fix IO hang in io_wq_put_and_exit from
 do_exit()
Message-ID: <ZPs81IAYfB8J78Pv@fedora>
References: <20230908093009.540763-1-ming.lei@redhat.com>
 <58227846-6b73-46ef-957f-d9b1e0451899@kernel.dk>
 <ZPsxCYFgZjIIeaBk@fedora>
 <0f85a6b5-3ba6-4b77-bb7d-79f365dbb44c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f85a6b5-3ba6-4b77-bb7d-79f365dbb44c@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 08, 2023 at 08:44:45AM -0600, Jens Axboe wrote:
> On 9/8/23 8:34 AM, Ming Lei wrote:
> > On Fri, Sep 08, 2023 at 07:49:53AM -0600, Jens Axboe wrote:
> >> On 9/8/23 3:30 AM, Ming Lei wrote:
> >>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> >>> index ad636954abae..95a3d31a1ef1 100644
> >>> --- a/io_uring/io_uring.c
> >>> +++ b/io_uring/io_uring.c
> >>> @@ -1930,6 +1930,10 @@ void io_wq_submit_work(struct io_wq_work *work)
> >>>  		}
> >>>  	}
> >>>  
> >>> +	/* It is fragile to block POLLED IO, so switch to NON_BLOCK */
> >>> +	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
> >>> +		issue_flags |= IO_URING_F_NONBLOCK;
> >>> +
> >>
> >> I think this comment deserves to be more descriptive. Normally we
> >> absolutely cannot block for polled IO, it's only OK here because io-wq
> > 
> > Yeah, we don't do that until commit 2bc057692599 ("block: don't make REQ_POLLED
> > imply REQ_NOWAIT") which actually push the responsibility/risk up to
> > io_uring.
> > 
> >> is the issuer and not necessarily the poller of it. That generally falls
> >> upon the original issuer to poll these requests.
> >>
> >> I think this should be a separate commit, coming before the main fix
> >> which is below.
> > 
> > Looks fine, actually IO_URING_F_NONBLOCK change isn't a must, and the
> > approach in V2 doesn't need this change.
> > 
> >>
> >>> @@ -3363,6 +3367,12 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
> >>>  		finish_wait(&tctx->wait, &wait);
> >>>  	} while (1);
> >>>  
> >>> +	/*
> >>> +	 * Reap events from each ctx, otherwise these requests may take
> >>> +	 * resources and prevent other contexts from being moved on.
> >>> +	 */
> >>> +	xa_for_each(&tctx->xa, index, node)
> >>> +		io_iopoll_try_reap_events(node->ctx);
> >>
> >> The main issue here is that if someone isn't polling for them, then we
> > 
> > That is actually what this patch is addressing, :-)
> 
> Right, that part is obvious :)
> 
> >> get to wait for a timeout before they complete. This can delay exit, for
> >> example, as we're now just waiting 30 seconds (or whatever the timeout
> >> is on the underlying device) for them to get timed out before exit can
> >> finish.
> > 
> > For the issue on null_blk, device timeout handler provides
> > forward-progress, such as requests are released, so new IO can be
> > handled.
> > 
> > However, not all devices support timeout, such as virtio device.
> 
> That's a bug in the driver, you cannot sanely support polled IO and not
> be able to deal with timeouts. Someone HAS to reap the requests and
> there are only two things that can do that - the application doing the
> polled IO, or if that doesn't happen, a timeout.

OK, then device driver timeout handler has new responsibility of covering
userspace accident, :-)

We may document this requirement for driver.

So far the only one should be virtio-blk, and the two virtio storage
drivers never implement timeout handler.

> 
> > Here we just call io_iopoll_try_reap_events() to poll submitted IOs
> > for releasing resources, so no need to rely on device timeout handler
> > any more, and the extra exit delay can be avoided.
> > 
> > But io_iopoll_try_reap_events() may not be enough because io_wq
> > associated with current context can get released resource immediately,
> > then new IOs are submitted successfully, but who can poll these new
> > submitted IOs, then all device resources can be held by this (freed)io_wq
> > for nothing.
> > 
> > I guess we may have to take the approach in patch V2 by only canceling
> > polled IO for avoiding the thread_exit regression, or other ideas?
> 
> Ideally the behavior seems like it should be that if a task goes away,
> any pending polled IO it has should be reaped. With the above notion
> that a driver supporting poll absolutely must be able to deal with
> timeouts, it's not a strict requirement as we know that requests will be
> reaped.

Then looks the io_uring fix is less important, and I will see if one
easy fix can be figured out, one way is to reap event when exiting both
current task and the associated io_wq.

Thanks,
Ming

