Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0FFD7988E6
	for <lists+io-uring@lfdr.de>; Fri,  8 Sep 2023 16:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243907AbjIHOf5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Sep 2023 10:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbjIHOf4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Sep 2023 10:35:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A252319B5
        for <io-uring@vger.kernel.org>; Fri,  8 Sep 2023 07:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694183707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t56OHGUrhxYBsMlHzANLp1z0NxF3arnLj8GzM5Bg66A=;
        b=baiQ+KlfB7KeZa4YCdhYysETUOGwFpneqsJEY1zqvr6DOH9/lxy80PiOBE1gGC9vQdXI+F
        yIRsW59tOLPaYqQJrKZIAb+06AXICcd0YQPvNipRrywgkZLxZF+ByErBOgUXf548TEAGql
        sPj2//ekry7J3cy2TMT+NPqWEBuw4W0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-576-ZmmKMsAwNz683qcNLL4dSA-1; Fri, 08 Sep 2023 10:35:01 -0400
X-MC-Unique: ZmmKMsAwNz683qcNLL4dSA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF16394EA0D;
        Fri,  8 Sep 2023 14:34:58 +0000 (UTC)
Received: from fedora (unknown [10.72.120.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 736DC404119;
        Fri,  8 Sep 2023 14:34:54 +0000 (UTC)
Date:   Fri, 8 Sep 2023 22:34:49 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Chengming Zhou <zhouchengming@bytedance.com>,
        ming.lei@redhat.com
Subject: Re: [PATCH V3] io_uring: fix IO hang in io_wq_put_and_exit from
 do_exit()
Message-ID: <ZPsxCYFgZjIIeaBk@fedora>
References: <20230908093009.540763-1-ming.lei@redhat.com>
 <58227846-6b73-46ef-957f-d9b1e0451899@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58227846-6b73-46ef-957f-d9b1e0451899@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 08, 2023 at 07:49:53AM -0600, Jens Axboe wrote:
> On 9/8/23 3:30 AM, Ming Lei wrote:
> > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > index ad636954abae..95a3d31a1ef1 100644
> > --- a/io_uring/io_uring.c
> > +++ b/io_uring/io_uring.c
> > @@ -1930,6 +1930,10 @@ void io_wq_submit_work(struct io_wq_work *work)
> >  		}
> >  	}
> >  
> > +	/* It is fragile to block POLLED IO, so switch to NON_BLOCK */
> > +	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
> > +		issue_flags |= IO_URING_F_NONBLOCK;
> > +
> 
> I think this comment deserves to be more descriptive. Normally we
> absolutely cannot block for polled IO, it's only OK here because io-wq

Yeah, we don't do that until commit 2bc057692599 ("block: don't make REQ_POLLED
imply REQ_NOWAIT") which actually push the responsibility/risk up to
io_uring.

> is the issuer and not necessarily the poller of it. That generally falls
> upon the original issuer to poll these requests.
> 
> I think this should be a separate commit, coming before the main fix
> which is below.

Looks fine, actually IO_URING_F_NONBLOCK change isn't a must, and the
approach in V2 doesn't need this change.

> 
> > @@ -3363,6 +3367,12 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
> >  		finish_wait(&tctx->wait, &wait);
> >  	} while (1);
> >  
> > +	/*
> > +	 * Reap events from each ctx, otherwise these requests may take
> > +	 * resources and prevent other contexts from being moved on.
> > +	 */
> > +	xa_for_each(&tctx->xa, index, node)
> > +		io_iopoll_try_reap_events(node->ctx);
> 
> The main issue here is that if someone isn't polling for them, then we

That is actually what this patch is addressing, :-)

> get to wait for a timeout before they complete. This can delay exit, for
> example, as we're now just waiting 30 seconds (or whatever the timeout
> is on the underlying device) for them to get timed out before exit can
> finish.

For the issue on null_blk, device timeout handler provides
forward-progress, such as requests are released, so new IO can be
handled.

However, not all devices support timeout, such as virtio device.

Here we just call io_iopoll_try_reap_events() to poll submitted IOs
for releasing resources, so no need to rely on device timeout handler
any more, and the extra exit delay can be avoided.

But io_iopoll_try_reap_events() may not be enough because io_wq
associated with current context can get released resource immediately,
then new IOs are submitted successfully, but who can poll these new
submitted IOs, then all device resources can be held by this (freed)io_wq
for nothing.

I guess we may have to take the approach in patch V2 by only canceling
polled IO for avoiding the thread_exit regression, or other ideas?

> 
> Do we just want to move this a bit higher up where we iterate ctx's
> anyway? Not that important I suspect.

I think it isn't needed, here we only focus on io_wq and polled io, not
same with what the iteration code covers, otherwise io_uring_try_cancel_requests
could become less readable.


Thanks,
Ming

