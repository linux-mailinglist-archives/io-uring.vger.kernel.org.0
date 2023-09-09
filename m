Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8237995D4
	for <lists+io-uring@lfdr.de>; Sat,  9 Sep 2023 03:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbjIIBoh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Sep 2023 21:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbjIIBog (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Sep 2023 21:44:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DB91FE3
        for <io-uring@vger.kernel.org>; Fri,  8 Sep 2023 18:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694223820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K/wt5PNgeS/XIFcFT75P+BpbsgjLzxZwOLL9FJKcgMs=;
        b=abRf+sPsJXh5slHHMo4DpLT9us6cjM2yo5+c+d+ZbZTde3akyeiqmeP8BlX71nfVa2RBWm
        MMlIul+x8hbg4z/12FhsWp7XxcUeypOTN7uaxid9q6T5FCE/8qp3Zy0q+uou2R1OdNBWBe
        cbuhFeocKwNO30ItwR6AR3MPGQfIkKM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-Jg7gBfcNNJa3xxxC2xAzOQ-1; Fri, 08 Sep 2023 21:43:39 -0400
X-MC-Unique: Jg7gBfcNNJa3xxxC2xAzOQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 084CE181A6E2;
        Sat,  9 Sep 2023 01:43:39 +0000 (UTC)
Received: from fedora (unknown [10.72.120.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D476F4022FC;
        Sat,  9 Sep 2023 01:43:34 +0000 (UTC)
Date:   Sat, 9 Sep 2023 09:43:29 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [PATCH V3] io_uring: fix IO hang in io_wq_put_and_exit from
 do_exit()
Message-ID: <ZPvNwczbDYaOinIC@fedora>
References: <20230908093009.540763-1-ming.lei@redhat.com>
 <58227846-6b73-46ef-957f-d9b1e0451899@kernel.dk>
 <78577243-b7a6-6d7c-38e4-dfef1762f135@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78577243-b7a6-6d7c-38e4-dfef1762f135@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 08, 2023 at 04:46:15PM +0100, Pavel Begunkov wrote:
> On 9/8/23 14:49, Jens Axboe wrote:
> > On 9/8/23 3:30 AM, Ming Lei wrote:
> > > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > > index ad636954abae..95a3d31a1ef1 100644
> > > --- a/io_uring/io_uring.c
> > > +++ b/io_uring/io_uring.c
> > > @@ -1930,6 +1930,10 @@ void io_wq_submit_work(struct io_wq_work *work)
> > >   		}
> > >   	}
> > > +	/* It is fragile to block POLLED IO, so switch to NON_BLOCK */
> > > +	if ((req->ctx->flags & IORING_SETUP_IOPOLL) && def->iopoll_queue)
> > > +		issue_flags |= IO_URING_F_NONBLOCK;
> > > +
> > 
> > I think this comment deserves to be more descriptive. Normally we
> > absolutely cannot block for polled IO, it's only OK here because io-wq
> > is the issuer and not necessarily the poller of it. That generally falls
> > upon the original issuer to poll these requests.
> > 
> > I think this should be a separate commit, coming before the main fix
> > which is below.
> > 
> > > @@ -3363,6 +3367,12 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
> > >   		finish_wait(&tctx->wait, &wait);
> > >   	} while (1);
> > > +	/*
> > > +	 * Reap events from each ctx, otherwise these requests may take
> > > +	 * resources and prevent other contexts from being moved on.
> > > +	 */
> > > +	xa_for_each(&tctx->xa, index, node)
> > > +		io_iopoll_try_reap_events(node->ctx);
> > 
> > The main issue here is that if someone isn't polling for them, then we
> > get to wait for a timeout before they complete. This can delay exit, for
> > example, as we're now just waiting 30 seconds (or whatever the timeout
> > is on the underlying device) for them to get timed out before exit can
> > finish.
> 
> Ok, our case is that userspace crashes and doesn't poll for its IO.
> How would that block io-wq termination? We send a signal and workers
> should exit, either by queueing up the request for iopoll (and then

It depends on how userspace handles the signal, such as, t/io_uring,
s->finish is set as true in INT signal handler, two cases may happen:

1) s->finish is observed immediately, then this pthread exits, and leave
polled requests in ctx->iopoll_list

2) s->finish isn't observed immediately, and just submit & polling;
if any IO can't be submitted because of no enough resource, there can
be one busy spin because submitter_uring_fn() waits for inflight IO.

So if there are two pthreads(A, B), each setup its own io_uring context
and submit & poll IO on same block device.  If 1) happens in A, all
device tags can be held for nothing.  If 2) happens in B, the busy spin
prevents exit() of this pthread B.

Then the hang is caused, exit work can't be scheduled at all, because
pthread B doesn't exit.

> we queue it into the io_uring iopoll list and the worker immediately
> returns back and presumably exits), or it fails because of the signal
> and returns back.
> 
> That should kill all io-wq and make exit go forward. Then the io_uring
> file will be destroyed and the ring exit work will be polling via
> 
> io_ring_exit_work();
> -- io_uring_try_cancel_requests();
>   -- io_iopoll_try_reap_events();
> 
> What I'm missing? Does the blocking change make io-wq iopolling
> completions inside the block? Was it by any chance with the recent
> "do_exit() waiting for ring destruction" patches?

In short, it is one resource dependency issue for polled IO.


Thanks,
Ming

